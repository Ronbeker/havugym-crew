'use server';

import { revalidatePath } from 'next/cache';
import { createSupabaseServerClient } from '@/lib/supabase/server';
import { logWorkoutSchema } from '@/lib/validation/schemas';
import { searchExercises } from '@/lib/queries';
import { actionError, actionOk, fieldErrorsFrom, friendlyDbError, type ActionResult } from './result';

/**
 * Logs a session.
 *
 * The score is NOT sent. log_workout() computes it in the database from the rows
 * as stored, so the only thing this action can influence is what was actually
 * lifted. The client shows a live preview using the TypeScript mirror of the same
 * formula, but that preview is cosmetic — the stored number is the database's.
 */
export async function logWorkoutAction(
  _prev: ActionResult<string> | null,
  formData: FormData,
): Promise<ActionResult<string>> {
  const rawSets = formData.get('sets');
  let sets: unknown = [];
  try {
    sets = JSON.parse(typeof rawSets === 'string' ? rawSets : '[]');
  } catch {
    return actionError('Could not read the sets you entered.');
  }

  const parsed = logWorkoutSchema.safeParse({
    havuraId: formData.get('havuraId'),
    title: formData.get('title'),
    notes: formData.get('notes') ?? '',
    durationMin: Number(formData.get('durationMin')),
    performedAt: formData.get('performedAt'),
    sets,
  });

  if (!parsed.success) {
    const fieldErrors = fieldErrorsFrom(parsed.error.issues);
    return actionError(fieldErrors.sets ?? 'Check the highlighted fields', fieldErrors);
  }

  const supabase = await createSupabaseServerClient();
  const { data, error } = await supabase.rpc('log_workout', {
    p_havura_id: parsed.data.havuraId,
    p_performed_at: parsed.data.performedAt,
    p_title: parsed.data.title,
    // The function applies nullif(trim(...), ''), so an empty string stores NULL.
    p_notes: parsed.data.notes ?? '',
    p_duration_min: parsed.data.durationMin,
    p_sets: parsed.data.sets.map((set) => ({
      exercise_id: set.exerciseId,
      set_index: set.setIndex,
      weight_kg: set.weightKg,
      reps: set.reps,
      rpe: set.rpe ?? null,
    })),
  });

  if (error) return actionError(friendlyDbError(error.message));

  revalidatePath('/feed');
  revalidatePath('/crew');
  return actionOk(data as string);
}

export async function deleteWorkoutAction(workoutId: string): Promise<ActionResult> {
  const supabase = await createSupabaseServerClient();
  // No user filter: the RLS policy permits deleting only your own workouts, so
  // this deletes nothing at all when the id belongs to someone else.
  const { error } = await supabase.from('workouts').delete().eq('id', workoutId);
  if (error) return actionError(friendlyDbError(error.message));

  revalidatePath('/feed');
  return actionOk(undefined);
}

export async function searchExercisesAction(term: string) {
  return searchExercises(term);
}
