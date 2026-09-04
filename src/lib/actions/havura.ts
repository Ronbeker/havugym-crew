'use server';

import { cookies } from 'next/headers';
import { redirect } from 'next/navigation';
import { revalidatePath } from 'next/cache';
import { createSupabaseServerClient } from '@/lib/supabase/server';
import { createHavuraSchema, joinHavuraSchema } from '@/lib/validation/schemas';
import { ACTIVE_HAVURA_COOKIE, getMyHavuras } from '@/lib/queries';
import { actionError, actionOk, fieldErrorsFrom, friendlyDbError, type ActionResult } from './result';

/** Cookie lifetime for the active-crew hint. Not a credential; just a preference. */
const COOKIE_MAX_AGE = 60 * 60 * 24 * 365;

export async function createHavuraAction(
  _prev: ActionResult<string> | null,
  formData: FormData,
): Promise<ActionResult<string>> {
  const parsed = createHavuraSchema.safeParse({ name: formData.get('name') });
  if (!parsed.success) {
    return actionError('Check the crew name', fieldErrorsFrom(parsed.error.issues));
  }

  const supabase = await createSupabaseServerClient();
  // create_havura() writes the crew AND the owner membership in one transaction,
  // so a crew can never exist without an owner.
  const { data, error } = await supabase.rpc('create_havura', { p_name: parsed.data.name });

  if (error) return actionError(friendlyDbError(error.message));

  (await cookies()).set(ACTIVE_HAVURA_COOKIE, data as string, {
    maxAge: COOKIE_MAX_AGE,
    sameSite: 'lax',
    path: '/',
  });

  revalidatePath('/', 'layout');
  redirect('/crew');
}

export async function joinHavuraAction(
  _prev: ActionResult<string> | null,
  formData: FormData,
): Promise<ActionResult<string>> {
  const parsed = joinHavuraSchema.safeParse({ code: formData.get('code') });
  if (!parsed.success) {
    return actionError('Check the invite code', fieldErrorsFrom(parsed.error.issues));
  }

  const supabase = await createSupabaseServerClient();
  const { data, error } = await supabase.rpc('join_havura', { p_code: parsed.data.code });

  if (error) return actionError(friendlyDbError(error.message));

  (await cookies()).set(ACTIVE_HAVURA_COOKIE, data as string, {
    maxAge: COOKIE_MAX_AGE,
    sameSite: 'lax',
    path: '/',
  });

  revalidatePath('/', 'layout');
  redirect('/feed');
}

/**
 * Switches the visible crew. The cookie is validated against real membership
 * here as well as on read, so this cannot be used to point at a crew you left.
 */
export async function switchHavuraAction(havuraId: string) {
  const memberships = await getMyHavuras();
  if (!memberships.some((m) => m.id === havuraId)) return;

  (await cookies()).set(ACTIVE_HAVURA_COOKIE, havuraId, {
    maxAge: COOKIE_MAX_AGE,
    sameSite: 'lax',
    path: '/',
  });
  revalidatePath('/', 'layout');
}

export async function leaveHavuraAction(havuraId: string): Promise<ActionResult> {
  const supabase = await createSupabaseServerClient();
  const { data: auth } = await supabase.auth.getUser();
  if (!auth.user) return actionError('Your session expired. Sign in again.');

  // The RLS policy allows deleting your own membership, or any membership in a
  // crew you own. We only ever ask for our own here.
  const { error } = await supabase
    .from('havura_members')
    .delete()
    .eq('havura_id', havuraId)
    .eq('user_id', auth.user.id);

  if (error) return actionError(friendlyDbError(error.message));

  (await cookies()).delete(ACTIVE_HAVURA_COOKIE);
  revalidatePath('/', 'layout');
  return actionOk(undefined);
}
