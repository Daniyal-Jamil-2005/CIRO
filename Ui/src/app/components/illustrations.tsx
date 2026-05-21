/* Flat vector illustrations in the style of the reference image */

export function VolunteerMan({ className = "" }: { className?: string }) {
  return (
    <svg viewBox="0 0 180 240" className={className}>
      {/* hair */}
      <path d="M55 50 Q55 28 78 25 Q105 22 110 45 Q112 55 108 62 L60 62 Q53 58 55 50Z" fill="#d97047" />
      {/* face */}
      <path d="M62 50 Q62 78 78 86 Q92 90 100 82 Q108 72 106 50 Q104 38 88 36 Q70 38 62 50Z" fill="#f4c9a8" />
      {/* ear */}
      <ellipse cx="62" cy="66" rx="4" ry="6" fill="#f4c9a8" />
      {/* eyes */}
      <circle cx="78" cy="62" r="1.8" fill="#2b3a48" />
      <circle cx="96" cy="62" r="1.8" fill="#2b3a48" />
      {/* brows */}
      <path d="M74 56 L82 55" stroke="#a85530" strokeWidth="1.5" strokeLinecap="round" fill="none" />
      <path d="M92 55 L100 56" stroke="#a85530" strokeWidth="1.5" strokeLinecap="round" fill="none" />
      {/* mouth */}
      <path d="M82 74 Q88 78 94 74" stroke="#a85530" strokeWidth="1.4" fill="none" strokeLinecap="round" />
      {/* neck */}
      <path d="M76 86 L76 96 L100 96 L100 86 Q92 92 76 86Z" fill="#e8b893" />
      {/* white shirt */}
      <path d="M58 100 Q70 94 88 96 Q108 94 120 100 L124 130 Q120 134 116 132 L116 200 L60 200 L60 132 Q56 134 52 130 Z" fill="#fafafa" />
      <path d="M58 100 Q70 94 88 96 Q108 94 120 100 L124 130 Q120 134 116 132 L116 200 L60 200 L60 132 Q56 134 52 130 Z" stroke="#cdd5dc" strokeWidth="1" fill="none" />
      {/* shirt collar V */}
      <path d="M76 96 L88 116 L100 96" fill="#e8b893" />
      {/* overalls (navy vest) */}
      <path d="M64 120 L64 200 L112 200 L112 120 Q102 116 88 116 Q74 116 64 120Z" fill="#324a5e" />
      <path d="M64 120 Q74 116 88 116 Q102 116 112 120 L112 138 L64 138Z" fill="#3c5770" />
      {/* overall straps */}
      <path d="M72 96 L72 124" stroke="#324a5e" strokeWidth="6" strokeLinecap="round" />
      <path d="M104 96 L104 124" stroke="#324a5e" strokeWidth="6" strokeLinecap="round" />
      {/* button */}
      <circle cx="72" cy="126" r="2.2" fill="#c9a876" />
      <circle cx="104" cy="126" r="2.2" fill="#c9a876" />
      {/* arms */}
      <path d="M58 102 Q44 130 46 168 Q48 178 56 178 Q60 172 58 156 Q60 134 68 116Z" fill="#fafafa" stroke="#cdd5dc" strokeWidth="1" />
      <path d="M120 102 Q134 130 132 168 Q130 178 122 178 Q118 172 120 156 Q118 134 110 116Z" fill="#fafafa" stroke="#cdd5dc" strokeWidth="1" />
      {/* hands */}
      <circle cx="51" cy="178" r="6" fill="#f4c9a8" />
      <circle cx="127" cy="178" r="6" fill="#f4c9a8" />
      {/* legs/pants continuing */}
      <rect x="64" y="200" width="22" height="34" fill="#324a5e" />
      <rect x="90" y="200" width="22" height="34" fill="#324a5e" />
    </svg>
  );
}

export function VictimWoman({ className = "" }: { className?: string }) {
  return (
    <svg viewBox="0 0 180 240" className={className}>
      {/* hair back */}
      <path d="M52 56 Q52 30 80 26 Q110 24 116 52 Q120 76 110 86 L60 86 Q50 72 52 56Z" fill="#2b3a48" />
      {/* face */}
      <path d="M60 56 Q60 86 78 92 Q92 96 102 88 Q112 78 110 56 Q108 42 88 40 Q68 42 60 56Z" fill="#f4c9a8" />
      <ellipse cx="60" cy="72" rx="4" ry="6" fill="#f4c9a8" />
      {/* eyes */}
      <circle cx="76" cy="66" r="1.8" fill="#2b3a48" />
      <circle cx="96" cy="66" r="1.8" fill="#2b3a48" />
      <path d="M72 60 L80 59" stroke="#2b3a48" strokeWidth="1.5" strokeLinecap="round" />
      <path d="M92 59 L100 60" stroke="#2b3a48" strokeWidth="1.5" strokeLinecap="round" />
      <path d="M82 80 Q88 84 94 80" stroke="#a85530" strokeWidth="1.4" fill="none" strokeLinecap="round" />
      {/* hair side */}
      <path d="M58 60 Q50 80 56 100 L66 96 Q60 80 64 60Z" fill="#2b3a48" />
      <path d="M114 60 Q122 80 116 100 L106 96 Q112 80 108 60Z" fill="#2b3a48" />
      {/* neck */}
      <path d="M78 92 L78 102 L100 102 L100 92 Q92 98 78 92Z" fill="#e8b893" />
      {/* denim jacket */}
      <path d="M56 108 Q72 100 88 102 Q104 100 120 108 L126 150 Q122 156 116 152 L116 210 L60 210 L60 152 Q54 156 50 150Z" fill="#3a5a78" />
      <path d="M56 108 Q72 100 88 102 Q104 100 120 108 L126 150 Q122 156 116 152 L116 210 L60 210 L60 152 Q54 156 50 150Z" stroke="#27425a" strokeWidth="1" fill="none" />
      {/* inner shirt */}
      <path d="M78 102 L88 122 L100 102 Q102 112 100 124 L78 124 Q76 112 78 102Z" fill="#e8eef2" />
      {/* arms */}
      <path d="M56 110 Q40 140 42 178 Q44 188 52 188 Q56 184 54 170 Q56 146 64 124Z" fill="#3a5a78" />
      <path d="M120 110 Q136 140 134 178 Q132 188 124 188 Q120 184 122 170 Q120 146 112 124Z" fill="#3a5a78" />
      <circle cx="47" cy="188" r="6" fill="#f4c9a8" />
      <circle cx="129" cy="188" r="6" fill="#f4c9a8" />
      {/* pants */}
      <rect x="60" y="210" width="24" height="28" fill="#27425a" />
      <rect x="92" y="210" width="24" height="28" fill="#27425a" />
    </svg>
  );
}

export function StormSceneIllustration({ className = "" }: { className?: string }) {
  return (
    <svg viewBox="0 0 320 280" className={className}>
      {/* dark sky gradient */}
      <defs>
        <linearGradient id="sky" x1="0" x2="0" y1="0" y2="1">
          <stop offset="0" stopColor="#2c4a5e" />
          <stop offset="1" stopColor="#5a7d8e" />
        </linearGradient>
        <linearGradient id="ground" x1="0" x2="0" y1="0" y2="1">
          <stop offset="0" stopColor="#c8a979" />
          <stop offset="1" stopColor="#a98759" />
        </linearGradient>
        <radialGradient id="bolt" cx="0.5" cy="0.5">
          <stop offset="0" stopColor="#e8f4ff" stopOpacity="0.9" />
          <stop offset="1" stopColor="#7eb5d1" stopOpacity="0" />
        </radialGradient>
      </defs>
      <rect width="320" height="200" fill="url(#sky)" />
      <rect y="200" width="320" height="80" fill="url(#ground)" />

      {/* tornado funnel */}
      <g>
        <ellipse cx="100" cy="190" rx="60" ry="14" fill="rgba(60,80,95,0.4)" />
        <path
          d="M85 30 Q70 80 80 130 Q88 170 100 200 Q112 170 122 130 Q128 80 115 30 Q100 25 85 30Z"
          fill="#5a6a78"
          opacity="0.85"
        />
        <path d="M88 60 Q105 65 118 58" stroke="#cdd9e2" strokeWidth="2" fill="none" opacity="0.6" />
        <path d="M85 90 Q105 96 122 88" stroke="#cdd9e2" strokeWidth="2" fill="none" opacity="0.55" />
        <path d="M82 120 Q105 128 124 118" stroke="#cdd9e2" strokeWidth="2" fill="none" opacity="0.5" />
        <path d="M84 150 Q105 158 120 148" stroke="#cdd9e2" strokeWidth="2" fill="none" opacity="0.5" />
      </g>

      {/* lightning halo */}
      <circle cx="138" cy="80" r="40" fill="url(#bolt)" />
      {/* lightning bolt */}
      <path
        d="M150 45 L128 95 L142 95 L120 145 L160 90 L146 90 L162 45 Z"
        fill="#e8f4ff"
        stroke="#7eb5d1"
        strokeWidth="1"
      />

      {/* house */}
      <g transform="translate(200,140)">
        <path d="M0 50 L40 18 L80 50 L80 100 L0 100 Z" fill="#dcd2c4" />
        <path d="M-6 52 L40 14 L86 52 L80 50 L40 18 L0 50 Z" fill="#8b3a2a" />
        <rect x="32" y="58" width="16" height="22" fill="#3a5a78" />
        <rect x="10" y="62" width="14" height="14" fill="#7ea5b8" />
        <rect x="56" y="62" width="14" height="14" fill="#7ea5b8" />
        <rect x="48" y="6" width="8" height="20" fill="#8b3a2a" />
        {/* fence */}
        <g stroke="#6b4a2a" strokeWidth="2">
          <line x1="-30" y1="92" x2="-30" y2="104" />
          <line x1="-20" y1="92" x2="-20" y2="104" />
          <line x1="-10" y1="92" x2="-10" y2="104" />
          <line x1="-32" y1="96" x2="-8" y2="96" />
        </g>
      </g>

      {/* small trees */}
      <g transform="translate(40,180)">
        <rect x="-2" y="0" width="4" height="12" fill="#5a3a1f" />
        <path d="M-10 4 L0 -18 L10 4 Z" fill="#3a5a4a" />
      </g>
      <g transform="translate(70,184)">
        <rect x="-2" y="0" width="4" height="10" fill="#5a3a1f" />
        <path d="M-8 4 L0 -14 L8 4 Z" fill="#3a5a4a" />
      </g>

      {/* rain dots */}
      {Array.from({ length: 18 }).map((_, i) => (
        <line
          key={i}
          x1={20 + i * 16}
          y1={140 + (i % 3) * 8}
          x2={16 + i * 16}
          y2={150 + (i % 3) * 8}
          stroke="#cfe1ec"
          strokeWidth="1.4"
          opacity="0.6"
        />
      ))}
    </svg>
  );
}

export function PakistanMapIllustration({ className = "" }: { className?: string }) {
  return (
    <svg viewBox="0 0 280 240" className={className}>
      <defs>
        <linearGradient id="pkfill" x1="0" x2="1" y1="0" y2="1">
          <stop offset="0" stopColor="#cfe6ec" />
          <stop offset="1" stopColor="#9bc6d2" />
        </linearGradient>
      </defs>
      <path
        d="M60,40 Q90,30 130,38 Q170,32 200,50 Q230,60 235,90 Q240,120 220,150 Q210,180 180,195 Q150,210 120,200 Q80,210 60,180 Q35,160 40,120 Q35,80 60,40Z"
        fill="url(#pkfill)"
        stroke="#3a5a78"
        strokeWidth="2"
      />
      {[
        [120, 90, "Islamabad"],
        [150, 130, "Lahore"],
        [90, 180, "Karachi"],
      ].map(([x, y, c]) => (
        <g key={c as string}>
          <circle cx={x as number} cy={y as number} r="14" fill="#d04545" fillOpacity="0.18" />
          <path
            d={`M${x},${(y as number) - 14} a8,8 0 1 1 0.1,0 L${x},${y} Z`}
            fill="#d04545"
          />
          <circle cx={x as number} cy={(y as number) - 14} r="3" fill="#fff" />
          <text x={(x as number) + 12} y={(y as number) + 4} fontSize="10" fill="#2b3a48">{c}</text>
        </g>
      ))}
    </svg>
  );
}

export function SignalFlowIllustration({ className = "" }: { className?: string }) {
  return (
    <svg viewBox="0 0 280 200" className={className}>
      {/* 4 step nodes connected */}
      {[
        { x: 35, label: "Signal", color: "#7eb5c8" },
        { x: 115, label: "Detect", color: "#c9a876" },
        { x: 195, label: "Plan", color: "#5fa890" },
        { x: 245, label: "Respond", color: "#d04545" },
      ].map((n, i, arr) => (
        <g key={n.label}>
          {i < arr.length - 1 && (
            <line
              x1={n.x + 24}
              y1="100"
              x2={arr[i + 1].x - 24}
              y2="100"
              stroke="#7eb5c8"
              strokeWidth="2"
              strokeDasharray="4 3"
            />
          )}
          <circle cx={n.x} cy="100" r="24" fill={n.color} />
          <circle cx={n.x} cy="100" r="30" fill="none" stroke={n.color} strokeOpacity="0.35" />
          <text x={n.x} y="140" fontSize="10" textAnchor="middle" fill="#2b3a48">{n.label}</text>
        </g>
      ))}
    </svg>
  );
}

export function LiveSimToggleIllustration({ className = "" }: { className?: string }) {
  return (
    <svg viewBox="0 0 280 200" className={className}>
      <rect x="40" y="60" width="200" height="80" rx="40" fill="#e6eef2" stroke="#3a5a78" strokeWidth="2" />
      <circle cx="90" cy="100" r="32" fill="#d04545" />
      <text x="90" y="104" fontSize="11" textAnchor="middle" fill="#fff" fontWeight="600">LIVE</text>
      <text x="170" y="105" fontSize="11" textAnchor="middle" fill="#2b3a48" fontWeight="600">SIM</text>
      {/* arrows */}
      <path d="M140 30 L150 40 L160 30" stroke="#7eb5c8" strokeWidth="2" fill="none" />
      <path d="M140 170 L150 160 L160 170" stroke="#7eb5c8" strokeWidth="2" fill="none" />
    </svg>
  );
}
