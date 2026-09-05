'use client';

import { deleteWorkoutAction } from '@/lib/actions/workout';
import { DestructiveButton } from '@/components/destructive-button';

/**
 * Only rendered when the viewer owns the session. That check is convenience —
 * the RLS delete policy restricts deletion to your own workouts regardless, so
 * a crewmate calling the action directly deletes nothing.
 */
export function WorkoutOwnerActions({ workoutId }: { workoutId: string }) {
  return (
    <DestructiveButton
      label="Delete this session"
      confirmLabel="Delete permanently?"
      pendingLabel="Deleting…"
      action={() => deleteWorkoutAction(workoutId)}
      redirectTo="/feed"
    />
  );
}
