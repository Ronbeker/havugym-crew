import { describe, expect, it } from 'vitest';
import { neglectedMuscle, suggestNextSession } from '@/lib/domain/recommendation';

describe('neglectedMuscle', () => {
  it('picks the muscle trained longest ago', () => {
    // Every muscle must appear: an ABSENT muscle counts as never trained and
    // outranks any number of days, which is the next test.
    expect(neglectedMuscle([
      { muscle: 'chest', daysAgo: 1 }, { muscle: 'back', daysAgo: 9 },
      { muscle: 'shoulders', daysAgo: 4 }, { muscle: 'legs', daysAgo: 3 },
      { muscle: 'glutes', daysAgo: 5 }, { muscle: 'core', daysAgo: 2 },
      { muscle: 'biceps', daysAgo: 6 }, { muscle: 'triceps', daysAgo: 1 },
    ])).toBe('back');
  });

  it('prefers a never-trained muscle over any number of days', () => {
    const touches = [
      { muscle: 'chest', daysAgo: 90 }, { muscle: 'back', daysAgo: 90 },
      { muscle: 'shoulders', daysAgo: 90 }, { muscle: 'legs', daysAgo: 90 },
      { muscle: 'core', daysAgo: 90 }, { muscle: 'biceps', daysAgo: 90 },
      { muscle: 'triceps', daysAgo: 90 },
    ];
    // 'glutes' is absent entirely.
    expect(neglectedMuscle(touches)).toBe('glutes');
  });

  it('is stable for an athlete with no history at all', () => {
    expect(neglectedMuscle([])).toBe(neglectedMuscle([]));
  });
});

describe('suggestNextSession', () => {
  const touches = [{ muscle: 'chest', daysAgo: 2 }];

  it('reports being on pace when ahead of the elapsed week', () => {
    const result = suggestNextSession({
      touches,
      challenge: { kind: 'workout_count', target: 7, progress: 4, dayOfWeek: 3 },
    });
    // Three days in, 3/7 of 7 is 3 expected; 4 is ahead.
    expect(result.pace!.expected).toBe(3);
    expect(result.pace!.onTrack).toBe(true);
  });

  it('reports being behind when the week has run further than the progress', () => {
    const result = suggestNextSession({
      touches,
      challenge: { kind: 'workout_count', target: 7, progress: 2, dayOfWeek: 6 },
    });
    expect(result.pace!.onTrack).toBe(false);
  });

  it('judges pace against elapsed days, not the flat target', () => {
    // 1 of 7 on day one is on pace; the same number on day six is not.
    const early = suggestNextSession({
      touches, challenge: { kind: 'workout_count', target: 7, progress: 1, dayOfWeek: 1 },
    });
    const late = suggestNextSession({
      touches, challenge: { kind: 'workout_count', target: 7, progress: 1, dayOfWeek: 6 },
    });
    expect(early.pace!.onTrack).toBe(true);
    expect(late.pace!.onTrack).toBe(false);
  });

  it('omits pace entirely when there is no challenge', () => {
    expect(suggestNextSession({ touches }).pace).toBeNull();
  });
});
