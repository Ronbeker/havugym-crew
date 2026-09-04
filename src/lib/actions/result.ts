/**
 * One result shape for every Server Action.
 *
 * Actions never throw at the client. A thrown error in a Server Action reaches
 * the browser as an opaque "an error occurred" with the message stripped in
 * production, which is useless to the user and useless to us. Returning a
 * discriminated union instead means every failure has somewhere to be rendered,
 * and TypeScript forces the caller to handle it.
 */
export type ActionResult<T = undefined> =
  | { ok: true; data: T }
  | { ok: false; error: string; fieldErrors?: Record<string, string> };

export const actionOk = <T>(data: T): ActionResult<T> => ({ ok: true, data });

export const actionError = (
  error: string,
  fieldErrors?: Record<string, string>,
): ActionResult<never> => ({ ok: false, error, fieldErrors });

/** Collapses a ZodError into one message per field. */
export function fieldErrorsFrom(issues: { path: PropertyKey[]; message: string }[]) {
  const out: Record<string, string> = {};
  for (const issue of issues) {
    const key = String(issue.path[0] ?? '_');
    if (!out[key]) out[key] = issue.message;
  }
  return out;
}

/**
 * Maps the errors our database functions raise into messages a person can act
 * on. The RPCs raise deliberate, stable strings (INSUFFICIENT_CREATINE,
 * NOT_A_MEMBER…) precisely so this mapping can exist without string-matching
 * Postgres internals.
 */
export function friendlyDbError(message: string): string {
  if (message.includes('INSUFFICIENT_CREATINE')) return 'Not enough creatine for that.';
  if (message.includes('INVALID_INVITE_CODE')) return 'That invite code does not match any crew.';
  if (message.includes('NOT_A_MEMBER')) return 'You are not a member of that crew.';
  if (message.includes('ALREADY_OWNED')) return 'You already own that item.';
  if (message.includes('NOT_OWNED')) return 'You do not own that item.';
  if (message.includes('NO_SUCH_ITEM')) return 'That item is no longer available.';
  if (message.includes('EMPTY_WORKOUT')) return 'A workout needs at least one set.';
  if (message.includes('UNAUTHENTICATED')) return 'Your session expired. Sign in again.';
  return 'Something went wrong. Please try again.';
}
