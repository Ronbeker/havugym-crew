'use server';

import { createSupabaseServerClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';
import { getStripe, stripeConfigured } from '@/lib/stripe';
import { packBySlug } from '@/lib/packs';
import { actionError, actionOk, type ActionResult } from './result';

/**
 * Starts a Stripe Checkout Session and returns its hosted URL.
 *
 * The client sends a pack SLUG, never a price. The amount charged comes from our
 * own pack table on the server, so a tampered request can at worst buy a
 * different advertised pack at that pack's real price.
 */
export async function startCheckoutAction(slug: string): Promise<ActionResult<string>> {
  if (!stripeConfigured()) {
    return actionError('Payments are not configured in this environment.');
  }

  const pack = packBySlug(slug);
  if (!pack) return actionError('That pack does not exist.');

  const supabase = await createSupabaseServerClient();
  const { data: auth } = await supabase.auth.getUser();
  if (!auth.user) return actionError('Sign in first.');

  const origin = process.env.NEXT_PUBLIC_SITE_URL ?? 'http://localhost:3000';

  try {
    const session = await getStripe().checkout.sessions.create({
      mode: 'payment',
      customer_email: auth.user.email,
      line_items: [
        {
          quantity: 1,
          price_data: {
            currency: pack.currency,
            unit_amount: pack.amountCents,
            product_data: {
              name: `${pack.creatine.toLocaleString()} creatine`,
              description: `HavuGym Crew — ${pack.name}`,
            },
          },
        },
      ],
      // Read back by the webhook and the success page. Stripe returns these
      // verbatim, and we trust them only because Stripe is the one returning them.
      metadata: { user_id: auth.user.id, pack_slug: pack.slug },
      success_url: `${origin}/shop/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${origin}/shop`,
    });

    if (!session.url) return actionError('Stripe did not return a checkout URL.');

    // Recorded as pending before the customer leaves, so an abandoned or failed
    // payment is still visible to us rather than vanishing.
    await createAdminClient().from('orders').insert({
      user_id: auth.user.id,
      pack_slug: pack.slug,
      creatine_amount: pack.creatine,
      amount_cents: pack.amountCents,
      currency: pack.currency,
      stripe_session_id: session.id,
      status: 'pending',
    });

    return actionOk(session.url);
  } catch (error) {
    return actionError(error instanceof Error ? error.message : 'Could not start checkout.');
  }
}
