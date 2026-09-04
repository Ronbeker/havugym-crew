import 'server-only';

import { createAdminClient } from '@/lib/supabase/admin';
import { getStripe } from '@/lib/stripe';
import { packBySlug } from '@/lib/packs';

/**
 * Credits a paid Checkout Session, exactly once.
 *
 * Reached by TWO independent paths on purpose:
 *
 *   1. the Stripe webhook, which is reliable but asynchronous and can be
 *      delayed, retried, or misconfigured in an environment;
 *   2. the success page the customer is redirected to, which is immediate but
 *      only happens if they actually come back.
 *
 * Either alone has a failure mode that ends with a paying customer holding
 * nothing. Both together only work because crediting is idempotent: the ledger's
 * partial unique index on (user_id, reason, ref_type, ref_id) rejects the second
 * write, whichever arrives second. That index is why we can afford to be
 * enthusiastic about crediting rather than careful about it.
 *
 * The amount credited is read from OUR pack definition after confirming with
 * STRIPE that the session is paid — never from anything the browser sent.
 */
export async function creditOrder(sessionId: string): Promise<
  { ok: true; credited: boolean; creatine: number } | { ok: false; error: string }
> {
  const stripe = getStripe();
  const session = await stripe.checkout.sessions.retrieve(sessionId);

  if (session.payment_status !== 'paid') {
    return { ok: false, error: 'Payment is not complete.' };
  }

  const userId = session.metadata?.user_id;
  const packSlug = session.metadata?.pack_slug;
  if (!userId || !packSlug) return { ok: false, error: 'Session is missing its metadata.' };

  const pack = packBySlug(packSlug);
  if (!pack) return { ok: false, error: 'Unknown pack.' };

  const admin = createAdminClient();

  const { data: existing } = await admin
    .from('orders')
    .select('id, status, credited_at')
    .eq('stripe_session_id', sessionId)
    .maybeSingle();

  if (existing?.credited_at) {
    return { ok: true, credited: false, creatine: pack.creatine };
  }

  const { error: creditError } = await admin.rpc('apply_creatine', {
    p_user_id: userId,
    p_delta: pack.creatine,
    p_reason: 'pack_purchase',
    p_ref_type: 'stripe_session',
    p_ref_id: sessionId,
  });

  if (creditError) return { ok: false, error: creditError.message };

  await admin
    .from('orders')
    .update({ status: 'paid', credited_at: new Date().toISOString() })
    .eq('stripe_session_id', sessionId);

  return { ok: true, credited: true, creatine: pack.creatine };
}
