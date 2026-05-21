import { ReactNode } from "react";
import {
  Bell,
  Settings,
  Map as MapLI,
  Radio,
  GitBranch,
  Grid3x3,
  ChevronLeft,
  ChevronRight,
  Search,
  Plus,
  MapPin,
  Camera,
  Droplets,
  Flame,
  Wind,
  Sun,
  Construction,
  Mountain,
  CloudRain,
  AlertTriangle,
  Activity,
  Zap,
  CircleAlert,
} from "lucide-react";

/* ---------- Palette (matches reference) ---------- */
// app navy bg: #1e3a4a
// phone screen: cream/white
// CTA tan: #c9a876
// accent teal: #7eb5c8 / #5fa3b8
// red pin/critical: #d04545
// text navy: #2b3a48

export const card =
  "bg-white border border-[#e3e8ec] rounded-2xl shadow-[0_1px_2px_rgba(30,58,74,0.06)]";

export const sevColor: Record<string, string> = {
  CRITICAL: "bg-[#d04545] text-white",
  HIGH: "bg-[#e07a3c] text-white",
  MEDIUM: "bg-[#d4a93c] text-white",
  RESOLVING: "bg-[#5fa3b8] text-white",
  RESOLVED: "bg-[#5fa890] text-white",
};

export function SeverityBadge({ level }: { level: keyof typeof sevColor }) {
  return (
    <span className={`px-2 py-0.5 rounded-full text-[9px] tracking-wider ${sevColor[level]}`}>
      {level}
    </span>
  );
}

export function Chip({
  children,
  tone = "default",
  icon,
}: {
  children: ReactNode;
  tone?: "default" | "teal" | "tan" | "navy" | "red";
  icon?: ReactNode;
}) {
  const tones: Record<string, string> = {
    default: "bg-[#eef2f5] text-[#5a6b78] border-[#dfe6ec]",
    teal: "bg-[#dceef3] text-[#2b6478] border-[#bcdde5]",
    tan: "bg-[#f4e9d4] text-[#86683a] border-[#e6d4ad]",
    navy: "bg-[#324a5e] text-white border-[#27425a]",
    red: "bg-[#fbe2e2] text-[#8b2a2a] border-[#f1c5c5]",
  };
  return (
    <span
      className={`inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[9px] tracking-wide uppercase border ${tones[tone]}`}
    >
      {icon}
      {children}
    </span>
  );
}

export function ConfBar({ value }: { value: number }) {
  return (
    <div className="flex items-center gap-2 flex-1">
      <div className="relative flex-1 h-1.5 rounded-full bg-[#eef2f5] overflow-hidden">
        <div
          className="absolute inset-y-0 left-0 rounded-full"
          style={{
            width: `${value}%`,
            background:
              "linear-gradient(90deg,#7eb5c8 0%,#d4a93c 60%,#d04545 100%)",
          }}
        />
      </div>
      <span className="text-[10px] text-[#2b3a48] w-8 text-right tabular-nums">
        {value}%
      </span>
    </div>
  );
}

export function TopBar({
  title,
  back,
  right,
}: {
  title: string;
  back?: boolean;
  right?: ReactNode;
}) {
  return (
    <div className="flex items-center justify-between px-4 py-3 border-b border-[#e3e8ec] bg-white/95 backdrop-blur">
      <div className="flex items-center gap-1.5">
        {back && <ChevronLeft size={18} className="text-[#2b3a48]" />}
        <span className="text-[#2b3a48] text-[15px] font-medium">{title}</span>
      </div>
      <div className="flex items-center gap-3 text-[#5a6b78]">
        {right ?? (
          <>
            <div className="relative">
              <Bell size={17} />
              <span className="absolute -top-1 -right-1 w-3.5 h-3.5 rounded-full bg-[#d04545] text-white text-[8px] flex items-center justify-center">
                4
              </span>
            </div>
            <Settings size={17} />
          </>
        )}
      </div>
    </div>
  );
}

export function BottomNav({ active }: { active: "Map" | "Feed" | "Trace" | "More" }) {
  const items: Array<{ k: typeof active; Icon: typeof MapLI }> = [
    { k: "Map", Icon: MapLI },
    { k: "Feed", Icon: Radio },
    { k: "Trace", Icon: GitBranch },
    { k: "More", Icon: Grid3x3 },
  ];
  return (
    <div className="absolute bottom-0 inset-x-0 px-3 pb-3 pt-2">
      <div className="backdrop-blur-xl bg-white/90 border border-[#e3e8ec] rounded-2xl flex items-center justify-around px-2 py-1.5 shadow-[0_8px_24px_-12px_rgba(30,58,74,0.25)]">
        {items.map(({ k, Icon }) => {
          const on = k === active;
          return (
            <div
              key={k}
              className={`flex flex-col items-center gap-0.5 px-3 py-1 rounded-xl ${
                on
                  ? "bg-[#dceef3] text-[#2b6478]"
                  : "text-[#8898a4]"
              }`}
            >
              <Icon size={18} strokeWidth={on ? 2.2 : 1.8} />
              <span className="text-[9px] tracking-wide font-medium">{k}</span>
            </div>
          );
        })}
      </div>
    </div>
  );
}

export function SourceDots() {
  const states: Array<"on" | "stale" | "err"> = ["on", "on", "on", "stale", "on", "err"];
  const color: Record<string, string> = {
    on: "bg-[#5fa3b8] shadow-[0_0_6px_rgba(95,163,184,0.6)]",
    stale: "bg-[#d4a93c]",
    err: "bg-[#d04545]",
  };
  return (
    <div className="flex items-center gap-1.5">
      {states.map((s, i) => (
        <span key={i} className={`w-1.5 h-1.5 rounded-full ${color[s]}`} />
      ))}
    </div>
  );
}

export function CrisisIcon({
  type,
  size = 18,
  className = "",
}: {
  type: string;
  size?: number;
  className?: string;
}) {
  const map: Record<string, typeof Droplets> = {
    FLOOD: Droplets,
    FIRE: Flame,
    STORM: Wind,
    HEATWAVE: Sun,
    ROAD_BLOCKAGE: Construction,
    EARTHQUAKE: Activity,
    LANDSLIDE: Mountain,
    INFRASTRUCTURE_FAILURE: Zap,
    ACCIDENT: AlertTriangle,
    UNKNOWN: CircleAlert,
  };
  const Icon = map[type] || CircleAlert;
  return <Icon size={size} className={className} />;
}

export {
  Bell,
  Settings,
  ChevronLeft,
  ChevronRight,
  Search,
  Plus,
  MapPin,
  Camera,
  Radio,
  CloudRain,
};
