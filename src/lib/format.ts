import { GYM_TIMEZONE } from '@/lib/domain/time';

/** Dates are rendered in the gym's timezone, not the viewer's, so a crew
 *  spread across timezones still agrees on which day a session happened. */
export function formatDay(iso: string): string {
  return new Intl.DateTimeFormat('en-GB', {
    timeZone: GYM_TIMEZONE,
    weekday: 'short',
    day: 'numeric',
    month: 'short',
  }).format(new Date(iso));
}

export function formatTime(iso: string): string {
  return new Intl.DateTimeFormat('en-GB', {
    timeZone: GYM_TIMEZONE,
    hour: '2-digit',
    minute: '2-digit',
    hour12: false,
  }).format(new Date(iso));
}

export function relativeDay(iso: string): string {
  const days = Math.floor((Date.now() - new Date(iso).getTime()) / 86_400_000);
  if (days <= 0) return 'Today';
  if (days === 1) return 'Yesterday';
  if (days < 7) return `${days} days ago`;
  return formatDay(iso);
}

export function compactNumber(value: number): string {
  return new Intl.NumberFormat('en-GB', { notation: 'compact', maximumFractionDigits: 1 })
    .format(value);
}

/** 0-100 → a qualitative band. Thresholds are the ones the score is built around:
 *  50 is "a normal session for you", so the bands sit either side of it. */
export function scoreBand(score: number): { label: string; className: string } {
  if (score >= 80) return { label: 'Huge', className: 'text-accent' };
  if (score >= 62) return { label: 'Strong', className: 'text-good' };
  if (score >= 40) return { label: 'Solid', className: 'text-text' };
  return { label: 'Light', className: 'text-muted' };
}
