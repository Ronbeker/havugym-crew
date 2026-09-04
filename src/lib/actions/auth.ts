'use server';

import { redirect } from 'next/navigation';
import { revalidatePath } from 'next/cache';
import { createSupabaseServerClient } from '@/lib/supabase/server';
import { signInSchema, signUpSchema } from '@/lib/validation/schemas';
import { actionError, actionOk, fieldErrorsFrom, type ActionResult } from './result';

export async function signUpAction(
  _prev: ActionResult<string> | null,
  formData: FormData,
): Promise<ActionResult<string>> {
  const parsed = signUpSchema.safeParse({
    email: formData.get('email'),
    password: formData.get('password'),
    displayName: formData.get('displayName'),
  });

  if (!parsed.success) {
    return actionError('Check the highlighted fields', fieldErrorsFrom(parsed.error.issues));
  }

  const supabase = await createSupabaseServerClient();
  const { data, error } = await supabase.auth.signUp({
    email: parsed.data.email,
    password: parsed.data.password,
    // Read by the on_auth_user_created trigger to name the profile it creates.
    options: { data: { display_name: parsed.data.displayName } },
  });

  if (error) {
    // Supabase says "User already registered"; everything else is unexpected.
    return actionError(
      error.message.includes('already registered')
        ? 'That email is already registered. Sign in instead.'
        : error.message,
    );
  }

  // With email confirmation enabled, signUp returns a user but no session.
  if (!data.session) {
    return actionOk('confirm-email');
  }

  revalidatePath('/', 'layout');
  redirect('/onboarding');
}

export async function signInAction(
  _prev: ActionResult<string> | null,
  formData: FormData,
): Promise<ActionResult<string>> {
  const parsed = signInSchema.safeParse({
    email: formData.get('email'),
    password: formData.get('password'),
  });

  if (!parsed.success) {
    return actionError('Check the highlighted fields', fieldErrorsFrom(parsed.error.issues));
  }

  const supabase = await createSupabaseServerClient();
  const { error } = await supabase.auth.signInWithPassword(parsed.data);

  if (error) {
    // Deliberately vague: distinguishing "no such account" from "wrong password"
    // turns the login form into an account-enumeration oracle.
    return actionError('Email or password is incorrect.');
  }

  revalidatePath('/', 'layout');
  redirect('/feed');
}

export async function signOutAction() {
  const supabase = await createSupabaseServerClient();
  await supabase.auth.signOut();
  revalidatePath('/', 'layout');
  redirect('/login');
}
