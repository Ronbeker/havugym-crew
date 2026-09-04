import { z } from 'zod';

/**
 * Every input crossing a trust boundary is parsed here first.
 *
 * These schemas are the SECOND of three layers, not the only one. The database
 * has CHECK constraints on the same fields, and the RPCs re-derive user identity
 * from auth.uid(). Zod exists to turn a bad input into a readable message for a
 * human, not to be the thing standing between us and a corrupt row — if this
 * layer were bypassed entirely, the database would still refuse.
 */

export const emailSchema = z
  .string()
  .trim()
  .toLowerCase()
  .email('Enter a valid email address');

export const passwordSchema = z
  .string()
  .min(8, 'Password must be at least 8 characters')
  .max(72, 'Password must be at most 72 characters');

export const displayNameSchema = z
  .string()
  .trim()
  .min(2, 'Name must be at least 2 characters')
  .max(32, 'Name must be at most 32 characters');

export const signUpSchema = z.object({
  email: emailSchema,
  password: passwordSchema,
  displayName: displayNameSchema,
});

export const signInSchema = z.object({
  email: emailSchema,
  password: z.string().min(1, 'Enter your password'),
});

export const createHavuraSchema = z.object({
  name: z
    .string()
    .trim()
    .min(2, 'Crew name must be at least 2 characters')
    .max(40, 'Crew name must be at most 40 characters'),
});

export const joinHavuraSchema = z.object({
  // Matches the CHECK constraint on havuras.invite_code exactly.
  code: z
    .string()
    .trim()
    .toUpperCase()
    .regex(/^[A-Z0-9]{6}$/, 'Invite codes are 6 letters and digits'),
});

/** One logged set. Bounds mirror the CHECK constraints on workout_sets. */
export const workoutSetSchema = z.object({
  exerciseId: z.number().int().positive(),
  setIndex: z.number().int().min(1).max(20),
  // Zero is valid and meaningful: bodyweight movements carry no external load.
  weightKg: z.number().min(0, 'Weight cannot be negative').max(500, 'Weight looks wrong'),
  reps: z.number().int().min(1, 'A set needs at least one rep').max(100, 'Reps look wrong'),
  rpe: z.number().min(1).max(10).nullable().optional(),
});

export const logWorkoutSchema = z.object({
  havuraId: z.string().uuid(),
  title: z.string().trim().min(1, 'Give the session a title').max(60),
  notes: z.string().trim().max(500).optional().or(z.literal('')),
  durationMin: z
    .number()
    .int()
    .min(1, 'Duration must be at least a minute')
    .max(480, 'That is more than eight hours'),
  performedAt: z.string().datetime({ offset: true }),
  sets: z
    .array(workoutSetSchema)
    .min(1, 'Add at least one set')
    .max(200, 'That is more sets than we can store'),
});

export const purchaseSchema = z.object({ itemId: z.number().int().positive() });
export const equipSchema = z.object({ itemId: z.number().int().positive() });

export type SignUpInput = z.infer<typeof signUpSchema>;
export type SignInInput = z.infer<typeof signInSchema>;
export type LogWorkoutInput = z.infer<typeof logWorkoutSchema>;
export type WorkoutSetInput = z.infer<typeof workoutSetSchema>;
