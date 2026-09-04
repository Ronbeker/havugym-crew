import { NextResponse } from 'next/server';
import { getStripe, stripeConfigured } from '@/lib/stripe';
import { creditOrder } from '@/lib/services/credit-order';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/**
 * POST /api/stripe/webhook
 *
 * This route is PUBLIC — Stripe has no session with us — which makes signature
 * verification the only thing standing between an open endpoint and anyone on
 * the internet granting themselves currency by POSTing a fake "payment
 * succeeded" event. constructEvent() recomputes the HMAC over the RAW body with
 * the endpoint secret and rejects anything that does not match.
 *
 * The body must be read as raw text. Parsing it to JSON first and re-serialising
 * changes the bytes, and the signature then fails for every legitimate event —
 * a bug that looks exactly like a misconfigured secret.
 */
export async function POST(request: Request) {
  if (!stripeConfigured() || !process.env.STRIPE_WEBHOOK_SECRET) {
    return NextResponse.json({ error: 'Payments are not configured' }, { status: 503 });
  }

  const signature = request.headers.get('stripe-signature');
  if (!signature) {
    return NextResponse.json({ error: 'Missing signature' }, { status: 400 });
  }

  const payload = await request.text();

  let event;
  try {
    event = getStripe().webhooks.constructEvent(
      payload,
      signature,
      process.env.STRIPE_WEBHOOK_SECRET,
    );
  } catch {
    // Deliberately terse: a detailed failure reason helps an attacker tune their
    // forgery attempts and helps a legitimate integrator not at all.
    return NextResponse.json({ error: 'Invalid signature' }, { status: 400 });
  }

  if (event.type === 'checkout.session.completed') {
    const session = event.data.object;
    const result = await creditOrder(session.id);

    // A 500 asks Stripe to retry, which is right for a transient failure and
    // wrong for a permanent one — retrying an unknown pack forever helps nobody.
    if (!result.ok && result.error.includes('Unknown pack')) {
      return NextResponse.json({ received: true, ignored: result.error });
    }
    if (!result.ok) {
      return NextResponse.json({ error: result.error }, { status: 500 });
    }
  }

  return NextResponse.json({ received: true });
}
