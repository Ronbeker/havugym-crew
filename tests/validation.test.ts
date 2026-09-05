import { describe, expect, it } from 'vitest';
import {
  displayNameSchema, emailSchema, joinHavuraSchema, logWorkoutSchema,
  passwordSchema, signUpSchema, workoutSetSchema,
} from '@/lib/validation/schemas';

const validWorkout = {
  havuraId: '3f2504e0-4f89-11d3-9a0c-0305e82c3301',
  title: 'Push day',
  notes: '',
  durationMin: 60,
  performedAt: '2026-09-04T10:00:00.000Z',
  sets: [{ exerciseId: 1, setIndex: 1, weightKg: 60, reps: 8 }],
};

describe('signUpSchema', () => {
  it('normalises email case and whitespace', () => {
    const result = signUpSchema.parse({
      email: '  RON@Example.COM ', password: 'longenough', displayName: ' Ron ',
    });
    expect(result.email).toBe('ron@example.com');
    expect(result.displayName).toBe('Ron');
  });

  it('rejects a short password', () => {
    expect(signUpSchema.safeParse({
      email: 'a@b.com', password: 'short', displayName: 'Ron',
    }).success).toBe(false);
  });

  it('rejects a password over bcrypt\'s 72-byte limit rather than silently truncating', () => {
    expect(signUpSchema.safeParse({
      email: 'a@b.com', password: 'x'.repeat(73), displayName: 'Ron',
    }).success).toBe(false);
  });

  it('rejects a one-character display name', () => {
    expect(signUpSchema.safeParse({
      email: 'a@b.com', password: 'longenough', displayName: 'R',
    }).success).toBe(false);
  });
});

describe('joinHavuraSchema', () => {
  it('upper-cases and trims a code', () => {
    expect(joinHavuraSchema.parse({ code: ' abc123 ' }).code).toBe('ABC123');
  });

  it('rejects the wrong length', () => {
    expect(joinHavuraSchema.safeParse({ code: 'ABC12' }).success).toBe(false);
    expect(joinHavuraSchema.safeParse({ code: 'ABC1234' }).success).toBe(false);
  });

  it('rejects characters outside the alphabet the constraint allows', () => {
    expect(joinHavuraSchema.safeParse({ code: 'ABC-12' }).success).toBe(false);
  });
});

describe('workoutSetSchema', () => {
  it('accepts a zero-weight bodyweight set', () => {
    expect(workoutSetSchema.safeParse({
      exerciseId: 1, setIndex: 1, weightKg: 0, reps: 10,
    }).success).toBe(true);
  });

  it('rejects negative weight', () => {
    expect(workoutSetSchema.safeParse({
      exerciseId: 1, setIndex: 1, weightKg: -5, reps: 10,
    }).success).toBe(false);
  });

  it('rejects zero reps — a set with no reps is not a set', () => {
    expect(workoutSetSchema.safeParse({
      exerciseId: 1, setIndex: 1, weightKg: 60, reps: 0,
    }).success).toBe(false);
  });

  it('rejects fractional reps', () => {
    expect(workoutSetSchema.safeParse({
      exerciseId: 1, setIndex: 1, weightKg: 60, reps: 8.5,
    }).success).toBe(false);
  });

  it('rejects weight beyond the column bound', () => {
    expect(workoutSetSchema.safeParse({
      exerciseId: 1, setIndex: 1, weightKg: 501, reps: 5,
    }).success).toBe(false);
  });
});

describe('logWorkoutSchema', () => {
  it('accepts a well-formed workout', () => {
    expect(logWorkoutSchema.safeParse(validWorkout).success).toBe(true);
  });

  it('rejects a workout with no sets', () => {
    expect(logWorkoutSchema.safeParse({ ...validWorkout, sets: [] }).success).toBe(false);
  });

  it('rejects a duration of zero', () => {
    expect(logWorkoutSchema.safeParse({ ...validWorkout, durationMin: 0 }).success).toBe(false);
  });

  it('rejects a duration beyond eight hours', () => {
    expect(logWorkoutSchema.safeParse({ ...validWorkout, durationMin: 481 }).success).toBe(false);
  });

  it('rejects a non-uuid crew id', () => {
    expect(logWorkoutSchema.safeParse({ ...validWorkout, havuraId: 'nope' }).success).toBe(false);
  });

  it('rejects a timestamp without an offset', () => {
    expect(logWorkoutSchema.safeParse({
      ...validWorkout, performedAt: '2026-09-04 10:00:00',
    }).success).toBe(false);
  });

  it('rejects more sets than the database will store', () => {
    const sets = Array.from({ length: 201 }, (_, i) => ({
      exerciseId: 1, setIndex: (i % 20) + 1, weightKg: 60, reps: 8,
    }));
    expect(logWorkoutSchema.safeParse({ ...validWorkout, sets }).success).toBe(false);
  });

  it('reports the offending field, so the form can highlight it', () => {
    const result = logWorkoutSchema.safeParse({ ...validWorkout, title: '' });
    expect(result.success).toBe(false);
    if (!result.success) {
      expect(result.error.issues[0].path).toContain('title');
    }
  });
});

describe('leaf schemas', () => {
  it('emailSchema lower-cases and trims', () => {
    expect(emailSchema.parse('  Ron@Example.COM  ')).toBe('ron@example.com');
  });

  it('emailSchema rejects an address with no domain', () => {
    expect(emailSchema.safeParse('ron@').success).toBe(false);
  });

  it('passwordSchema enforces both ends of the range', () => {
    expect(passwordSchema.safeParse('x'.repeat(7)).success).toBe(false);
    expect(passwordSchema.safeParse('x'.repeat(8)).success).toBe(true);
    expect(passwordSchema.safeParse('x'.repeat(72)).success).toBe(true);
    expect(passwordSchema.safeParse('x'.repeat(73)).success).toBe(false);
  });

  it('displayNameSchema matches the column CHECK exactly', () => {
    // profiles.display_name is CHECK (char_length between 2 and 32).
    expect(displayNameSchema.safeParse('R').success).toBe(false);
    expect(displayNameSchema.safeParse('Ro').success).toBe(true);
    expect(displayNameSchema.safeParse('R'.repeat(32)).success).toBe(true);
    expect(displayNameSchema.safeParse('R'.repeat(33)).success).toBe(false);
  });
});
