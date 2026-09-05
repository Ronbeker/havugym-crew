import { describe, expect, it } from 'vitest';
import { dayOfWeekOf, weekEndOf, weekStartOf } from '@/lib/domain/time';

describe('weekStartOf', () => {
  it('returns the Sunday of the week', () => {
    // 2026-09-04 is a Friday; its week began Sunday the 30th of August.
    expect(weekStartOf(new Date('2026-09-04T12:00:00Z'))).toBe('2026-08-30');
  });

  it('treats Sunday as the first day, not the last', () => {
    expect(weekStartOf(new Date('2026-08-30T12:00:00Z'))).toBe('2026-08-30');
  });

  it('keeps Saturday in the week that started six days earlier', () => {
    expect(weekStartOf(new Date('2026-09-05T12:00:00Z'))).toBe('2026-08-30');
  });

  it('buckets by ISRAEL local time, not UTC', () => {
    // 22:00Z on Saturday is 01:00 Sunday in Jerusalem — the start of a NEW week.
    // Bucketing this by the UTC date would pay it into a week that has closed.
    expect(weekStartOf(new Date('2026-09-05T22:00:00Z'))).toBe('2026-09-06');
  });

  it('keeps a late Saturday-night session in the week it belongs to', () => {
    // 20:00Z Saturday is 23:00 Saturday in Jerusalem — still the old week.
    expect(weekStartOf(new Date('2026-09-05T20:00:00Z'))).toBe('2026-08-30');
  });

  it('crosses a year boundary correctly', () => {
    expect(weekStartOf(new Date('2027-01-01T12:00:00Z'))).toBe('2026-12-27');
  });
});

describe('weekEndOf', () => {
  it('returns the Saturday six days later', () => {
    expect(weekEndOf('2026-08-30')).toBe('2026-09-05');
  });

  it('crosses a month boundary', () => {
    expect(weekEndOf('2026-11-29')).toBe('2026-12-05');
  });
});

describe('dayOfWeekOf', () => {
  it('numbers Sunday as 1 and Saturday as 7', () => {
    expect(dayOfWeekOf(new Date('2026-08-30T12:00:00Z'))).toBe(1); // Sunday
    expect(dayOfWeekOf(new Date('2026-09-05T12:00:00Z'))).toBe(7); // Saturday
  });

  it('walks the whole week in order', () => {
    const days = [0, 1, 2, 3, 4, 5, 6].map((offset) =>
      dayOfWeekOf(new Date(Date.UTC(2026, 7, 30 + offset, 12))),
    );
    expect(days).toEqual([1, 2, 3, 4, 5, 6, 7]);
  });

  it('uses Israel local time, so a late-night UTC Saturday is already Sunday', () => {
    expect(dayOfWeekOf(new Date('2026-09-05T22:00:00Z'))).toBe(1);
  });

  it('agrees with weekStartOf about which week a moment belongs to', () => {
    // Consistency between the two is what keeps the pace calculation honest.
    for (const iso of ['2026-08-30T00:30:00Z', '2026-09-02T18:00:00Z', '2026-09-05T20:00:00Z']) {
      const date = new Date(iso);
      expect(weekStartOf(date)).toBe('2026-08-30');
      expect(dayOfWeekOf(date)).toBeGreaterThanOrEqual(1);
      expect(dayOfWeekOf(date)).toBeLessThanOrEqual(7);
    }
  });
});
