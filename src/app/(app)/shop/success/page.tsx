import Link from 'next/link';
import { CheckIcon, CloseIcon } from '@/components/icons';
import { creditOrder } from '@/lib/services/credit-order';
import { stripeConfigured } from '@/lib/stripe';

export const metadata = { title: 'Purchase · HavuGym Crew' };
export const dynamic = 'force-dynamic';

/**
 * The second of the two crediting paths.
 *
 * If the webhook already ran, creditOrder reports credited:false and changes
 * nothing — the customer still sees a success page, because the money did
 * arrive and the creatine is in their balance either way.
 */
export default async function CheckoutSuccessPage({
  searchParams,
}: {
  searchParams: Promise<{ session_id?: string }>;
}) {
  const { session_id: sessionId } = await searchParams;

  if (!sessionId || !stripeConfigured()) {
    return (
      <div className="card text-center">
        <CloseIcon className="mx-auto h-6 w-6 text-danger" />
        <p className="mt-3 text-sm font-medium">No checkout session</p>
        <Link href="/shop" className="btn-ghost mt-4">Back to the shop</Link>
      </div>
    );
  }

  const result = await creditOrder(sessionId);

  return (
    <div className="card text-center">
      {result.ok ? (
        <>
          <CheckIcon className="mx-auto h-6 w-6 text-good" />
          <p className="mt-3 text-lg font-semibold tabular">
            +{result.creatine.toLocaleString()} creatine
          </p>
          <p className="mt-1 text-sm text-muted">
            {result.credited
              ? 'Added to your balance.'
              : 'Already added — the webhook got here first.'}
          </p>
        </>
      ) : (
        <>
          <CloseIcon className="mx-auto h-6 w-6 text-danger" />
          <p className="mt-3 text-sm font-medium">We could not confirm that payment</p>
          <p className="mt-1 text-sm text-muted">{result.error}</p>
        </>
      )}
      <Link href="/shop" className="btn-primary mt-5">Back to the shop</Link>
    </div>
  );
}
