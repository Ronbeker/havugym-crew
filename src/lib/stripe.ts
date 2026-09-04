import 'server-only';
import Stripe from 'stripe';

/**
 * Stripe client. Server-only — the secret key must never reach a bundle.
 *
 * Constructed lazily rather than at module load so the app still boots, and the
 * rest of the shop still works, when payments are not configured. Missing
 * payment keys degrade one feature; they do not take the site down.
 */
let cached: Stripe | null = null;

export function getStripe(): Stripe {
  const key = process.env.STRIPE_SECRET_KEY;
  if (!key) throw new Error('STRIPE_SECRET_KEY is not set');
  if (!cached) cached = new Stripe(key);
  return cached;
}

export function stripeConfigured(): boolean {
  return Boolean(process.env.STRIPE_SECRET_KEY);
}
