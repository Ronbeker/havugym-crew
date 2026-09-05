/**
 * Inline SVG icons — no icon font, no emoji.
 *
 * Emoji render differently on every platform and are read aloud by screen
 * readers as their unicode name, which is noise. These are stroke icons on a
 * 24-grid, inheriting currentColor so they take the colour of whatever they sit in.
 */
type IconProps = { className?: string };

const base = (className?: string) => ({
  className: className ?? 'h-5 w-5',
  viewBox: '0 0 24 24',
  fill: 'none',
  stroke: 'currentColor',
  strokeWidth: 1.75,
  strokeLinecap: 'round' as const,
  strokeLinejoin: 'round' as const,
  'aria-hidden': true,
});

export const FeedIcon = ({ className }: IconProps) => (
  <svg {...base(className)}>
    <path d="M4 7h16M4 12h16M4 17h10" />
  </svg>
);

export const LogIcon = ({ className }: IconProps) => (
  <svg {...base(className)}>
    <path d="M12 5v14M5 12h14" />
  </svg>
);

export const CrewIcon = ({ className }: IconProps) => (
  <svg {...base(className)}>
    <path d="M16 19v-1.5a3.5 3.5 0 0 0-3.5-3.5h-5A3.5 3.5 0 0 0 4 17.5V19" />
    <circle cx="10" cy="8" r="3" />
    <path d="M20 19v-1.5a3.5 3.5 0 0 0-2.6-3.4M15.5 5.2a3 3 0 0 1 0 5.6" />
  </svg>
);

export const ShopIcon = ({ className }: IconProps) => (
  <svg {...base(className)}>
    <path d="M4 8h16l-1 11a2 2 0 0 1-2 1.8H7A2 2 0 0 1 5 19z" />
    <path d="M9 8V6a3 3 0 0 1 6 0v2" />
  </svg>
);

export const MeIcon = ({ className }: IconProps) => (
  <svg {...base(className)}>
    <circle cx="12" cy="8" r="3.5" />
    <path d="M5 20a7 7 0 0 1 14 0" />
  </svg>
);

export const DumbbellIcon = ({ className }: IconProps) => (
  <svg {...base(className)}>
    <path d="M3 9v6M6 7v10M18 7v10M21 9v6M6 12h12" />
  </svg>
);

export const TrophyIcon = ({ className }: IconProps) => (
  <svg {...base(className)}>
    <path d="M7 4h10v5a5 5 0 0 1-10 0z" />
    <path d="M7 6H4.5A2.5 2.5 0 0 0 7 9.5M17 6h2.5A2.5 2.5 0 0 1 17 9.5" />
    <path d="M12 14v3M9 20h6M10 17h4" />
  </svg>
);

export const TargetIcon = ({ className }: IconProps) => (
  <svg {...base(className)}>
    <circle cx="12" cy="12" r="8" />
    <circle cx="12" cy="12" r="4" />
    <circle cx="12" cy="12" r="1" />
  </svg>
);

export const CreatineIcon = ({ className }: IconProps) => (
  <svg {...base(className)}>
    <path d="M9 3h6M10 3v4.2L6.4 16A3 3 0 0 0 9.1 20h5.8a3 3 0 0 0 2.7-3.8L14 7.2V3" />
    <path d="M7.6 13h8.8" />
  </svg>
);

export const CheckIcon = ({ className }: IconProps) => (
  <svg {...base(className)}>
    <path d="m5 13 4 4L19 7" />
  </svg>
);

export const CloseIcon = ({ className }: IconProps) => (
  <svg {...base(className)}>
    <path d="M6 6l12 12M18 6L6 18" />
  </svg>
);

export const ChevronRightIcon = ({ className }: IconProps) => (
  <svg {...base(className)}>
    <path d="m9 6 6 6-6 6" />
  </svg>
);

export const SpinnerIcon = ({ className }: IconProps) => (
  <svg {...base(className ?? 'h-4 w-4 animate-spin')}>
    <path d="M12 3a9 9 0 1 0 9 9" />
  </svg>
);

export const ArrivalIcon = ({ className }: IconProps) => (
  <svg {...base(className)}>
    <path d="M12 21s7-5.6 7-11a7 7 0 1 0-14 0c0 5.4 7 11 7 11z" />
    <circle cx="12" cy="10" r="2.5" />
  </svg>
);

export const WalkIcon = ({ className }: IconProps) => (
  <svg {...base(className)}>
    <circle cx="13" cy="4.5" r="1.8" />
    <path d="M11 21l1.8-5.2L10 13l1-5 3.2 2.2L17 11" />
    <path d="M10 8L7 10.5M12.8 15.8L15 21" />
  </svg>
);
