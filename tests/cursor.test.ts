import { describe, expect, it } from 'vitest';
import { decodeCursor, encodeCursor } from '@/lib/queries';

/**
 * The feed cursor is user-facing: it travels in the query string, so it has to
 * survive a round trip and it has to fail safe when someone edits it.
 */
describe('feed cursor', () => {
  const cursor = {
    performedAt: '2026-09-04T17:48:12.482Z',
    id: '3f2504e0-4f89-11d3-9a0c-0305e82c3301',
  };

  it('round-trips', () => {
    expect(decodeCursor(encodeCursor(cursor))).toEqual(cursor);
  });

  it('splits on the LAST separator, so a timestamp containing one is safe', () => {
    // Not hypothetical if the timestamp format ever changes; splitting on the
    // first '|' would truncate it and silently page from the wrong place.
    const odd = { performedAt: '2026-09-04T17:48:12|482Z', id: 'abc' };
    expect(decodeCursor(encodeCursor(odd))).toEqual(odd);
  });

  it('treats a missing cursor as the first page', () => {
    expect(decodeCursor(undefined)).toBeNull();
    expect(decodeCursor('')).toBeNull();
  });

  it('treats a malformed cursor as the first page rather than erroring', () => {
    expect(decodeCursor('garbage')).toBeNull();
    expect(decodeCursor('|abc')).toBeNull();
    expect(decodeCursor('2026-09-04T17:48:12.482Z|')).toBeNull();
  });
});
