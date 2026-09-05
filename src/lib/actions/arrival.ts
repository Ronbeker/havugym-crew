'use server';

import { revalidatePath } from 'next/cache';
import { z } from 'zod';
import { createSupabaseServerClient } from '@/lib/supabase/server';
import { actionError, actionOk, friendlyDbError, type ActionResult } from './result';

const announceSchema = z.object({
  havuraId: z.string().uuid(),
  status: z.enum(['on_the_way', 'training']),
  // Short on purpose: this is a shout across the gym, not a status update.
  note: z.string().trim().max(120).optional().or(z.literal('')),
});

/**
 * Announce an arrival.
 *
 * The expiry window is NOT a parameter. It is chosen inside announce_arrival()
 * from the status, because a caller that could set its own expiry could park
 * itself at the top of the crew's screen for a week.
 */
export async function announceArrivalAction(
  havuraId: string,
  status: 'on_the_way' | 'training',
  note?: string,
): Promise<ActionResult> {
  const parsed = announceSchema.safeParse({ havuraId, status, note: note ?? '' });
  if (!parsed.success) return actionError('That does not look right.');

  const supabase = await createSupabaseServerClient();
  const { error } = await supabase.rpc('announce_arrival', {
    p_havura_id: parsed.data.havuraId,
    p_status: parsed.data.status,
    p_note: parsed.data.note || undefined,
  });

  if (error) return actionError(friendlyDbError(error.message));

  revalidatePath('/feed');
  revalidatePath('/crew');
  return actionOk(undefined);
}

export async function closeArrivalAction(havuraId: string): Promise<ActionResult> {
  const parsed = z.string().uuid().safeParse(havuraId);
  if (!parsed.success) return actionError('That does not look right.');

  const supabase = await createSupabaseServerClient();
  const { error } = await supabase.rpc('close_arrival', { p_havura_id: parsed.data });
  if (error) return actionError(friendlyDbError(error.message));

  revalidatePath('/feed');
  revalidatePath('/crew');
  return actionOk(undefined);
}
