import {
  Bell,
  BottomNav,
  Camera,
  card,
  Chip,
  ChevronLeft,
  ConfBar,
  CrisisIcon,
  MapPin,
  Plus,
  Search,
  Settings as SettingsIcon,
  SeverityBadge,
  SourceDots,
  TopBar,
} from "./ui";
import {
  LiveSimToggleIllustration,
  PakistanMapIllustration,
  SignalFlowIllustration,
  StormSceneIllustration,
  VictimWoman,
  VolunteerMan,
} from "./illustrations";
import {
  Activity,
  Check,
  ChevronDown,
  Circle,
  CircleCheck,
  Clock,
  Cpu,
  Eye,
  Filter,
  Flame,
  Info,
  Loader,
  MessageSquare,
  Navigation,
  Radio as RadioIcon,
  Send,
  Sparkles,
  Tv2,
  Users,
  Wifi,
  WifiOff,
  Wind,
  Zap,
  Globe,
  Languages,
  Newspaper,
} from "lucide-react";

const screenBg = { background: "#f5f1ea" };

/* CTA button (tan) */
function TanButton({ children, full = true }: { children: React.ReactNode; full?: boolean }) {
  return (
    <button
      className={`${full ? "w-full" : ""} px-5 py-3 rounded-2xl text-white text-[13px] font-medium`}
      style={{
        background: "linear-gradient(135deg,#c9a876,#a8854f)",
        boxShadow: "0 8px 20px -10px rgba(168,133,79,0.6)",
      }}
    >
      {children}
    </button>
  );
}

/* ============ Map background (light teal) ============ */
function MapBg() {
  return (
    <div className="absolute inset-0">
      <div className="absolute inset-0" style={{ background: "#e3edf2" }} />
      {/* roads */}
      <svg viewBox="0 0 320 600" className="absolute inset-0 w-full h-full">
        <defs>
          <pattern id="grid2" width="32" height="32" patternUnits="userSpaceOnUse">
            <path d="M32 0H0V32" fill="none" stroke="#cdddE4" strokeWidth="0.5" />
          </pattern>
        </defs>
        <rect width="320" height="600" fill="url(#grid2)" />
        {/* parks / land patches */}
        <path d="M30,160 Q80,140 130,170 Q170,200 150,250 Q120,280 70,260 Q20,230 30,160Z" fill="#cfe1d6" opacity="0.7" />
        <path d="M180,300 Q240,290 270,320 Q280,360 240,380 Q200,380 180,350 Q170,320 180,300Z" fill="#cfe1d6" opacity="0.7" />
        {/* rivers / blue */}
        <path d="M0,440 Q80,420 160,450 Q240,480 320,460" stroke="#9bc6d2" strokeWidth="14" fill="none" opacity="0.85" />
        {/* roads (main) */}
        <path d="M20,300 L300,290" stroke="#fff" strokeWidth="6" />
        <path d="M20,300 L300,290" stroke="#d04545" strokeWidth="2" strokeDasharray="6 4" opacity="0.55" />
        <path d="M160,80 L150,560" stroke="#fff" strokeWidth="6" />
        <path d="M160,80 L150,560" stroke="#d4a93c" strokeWidth="2" strokeDasharray="6 4" opacity="0.5" />
        <path d="M60,120 L260,520" stroke="#fff" strokeWidth="4" />
        <path d="M60,120 L260,520" stroke="#5fa890" strokeWidth="1.5" opacity="0.5" />
      </svg>
    </div>
  );
}

function Pin({
  x,
  y,
  level,
  type,
}: {
  x: number;
  y: number;
  level: "CRITICAL" | "HIGH" | "MEDIUM" | "RESOLVING";
  type: string;
}) {
  const color = {
    CRITICAL: "#d04545",
    HIGH: "#e07a3c",
    MEDIUM: "#d4a93c",
    RESOLVING: "#5fa3b8",
  }[level];
  return (
    <div
      className="absolute -translate-x-1/2 -translate-y-full"
      style={{ left: `${x}%`, top: `${y}%` }}
    >
      {level === "CRITICAL" && (
        <span
          className="absolute -inset-3 rounded-full animate-ping"
          style={{ background: color, opacity: 0.25 }}
        />
      )}
      <div
        className="relative w-8 h-8 rounded-full flex items-center justify-center text-white shadow-[0_4px_10px_rgba(0,0,0,0.25)] border-2 border-white"
        style={{ background: color }}
      >
        <CrisisIcon type={type} size={14} />
      </div>
      <div
        className="w-0 h-0 mx-auto"
        style={{
          borderLeft: "5px solid transparent",
          borderRight: "5px solid transparent",
          borderTop: `7px solid ${color}`,
        }}
      />
    </div>
  );
}

/* ============ ONBOARDING — 4 slides ============ */
function OnboardingShell({
  index,
  total,
  illustration,
  title,
  body,
  cta,
}: {
  index: number;
  total: number;
  illustration: React.ReactNode;
  title: string;
  body: string;
  cta: string;
}) {
  return (
    <div className="relative w-full h-full" style={screenBg}>
      <div className="flex justify-between items-center px-5 pt-3">
        <span className="text-[11px] text-[#8898a4]">
          {index + 1} / {total}
        </span>
        <span className="text-[#a8854f] text-[12px]">Skip</span>
      </div>

      <div className="flex flex-col items-center px-6 pt-2">
        <div className="w-full h-[260px] rounded-3xl bg-white border border-[#e3e8ec] shadow-[0_8px_30px_-15px_rgba(30,58,74,0.25)] flex items-center justify-center overflow-hidden">
          {illustration}
        </div>

        <h2 className="text-[#2b3a48] text-center mt-6 leading-snug">{title}</h2>
        <p className="text-[#6b7c8a] text-[12.5px] text-center mt-2 leading-relaxed">
          {body}
        </p>

        <div className="flex gap-1.5 mt-6">
          {Array.from({ length: total }).map((_, i) => (
            <span
              key={i}
              className={`h-1.5 rounded-full transition-all ${
                i === index ? "w-6 bg-[#a8854f]" : "w-1.5 bg-[#d6dde2]"
              }`}
            />
          ))}
        </div>

        <div className="mt-5 w-full">
          <TanButton>{cta}</TanButton>
        </div>
      </div>
    </div>
  );
}

export const S1Onboarding = () => <S1Onboarding1 />;
export function S1Onboarding1() {
  return (
    <OnboardingShell
      index={0}
      total={4}
      illustration={<StormSceneIllustration className="w-full h-full" />}
      title="Autonomous Crisis Intelligence"
      body="CIRO detects urban crises from social signals, weather, and traffic data — before official reports arrive."
      cta="Next"
    />
  );
}

export function S1Onboarding2() {
  return (
    <OnboardingShell
      index={1}
      total={4}
      illustration={<SignalFlowIllustration className="w-full h-full" />}
      title="Signal to Response in Seconds"
      body="Agents analyse incoming data, detect crises, plan coordinated responses, and simulate execution automatically."
      cta="Next"
    />
  );
}

export function S1Onboarding3() {
  return (
    <OnboardingShell
      index={2}
      total={4}
      illustration={<PakistanMapIllustration className="w-full h-full" />}
      title="Built for Pakistan"
      body="Optimised for Pakistani cities with native Roman Urdu signal processing. Switch to global view anytime."
      cta="Next"
    />
  );
}

export function S1Onboarding4() {
  return (
    <OnboardingShell
      index={3}
      total={4}
      illustration={<LiveSimToggleIllustration className="w-full h-full" />}
      title="Live or Simulated"
      body="Toggle between real-time signal ingestion and scripted demo scenarios. The agent pipeline is identical in both modes."
      cta="Get Started"
    />
  );
}

/* ============ Welcome / volunteer screen (extra, matches ref) ============ */
export function SVolunteer() {
  return (
    <div className="relative w-full h-full" style={screenBg}>
      <div className="px-5 pt-4 flex items-center gap-3">
        <div className="w-9 h-9 rounded-full bg-[#7eb5c8]/30 border border-[#7eb5c8] flex items-center justify-center">
          <Users size={16} className="text-[#2b6478]" />
        </div>
        <div className="flex-1">
          <div className="text-[#2b3a48] text-[13px] font-medium">Jennie Shrivastava</div>
          <div className="text-[10px] text-[#8898a4]">Rescue Volunteer · South Zone</div>
        </div>
      </div>

      <div className="mx-4 mt-3 rounded-2xl bg-[#324a5e] text-white p-4">
        <div className="text-[12px] font-medium">Rescue Volunteer</div>
        <p className="text-[11px] text-white/70 mt-2 leading-relaxed">
          Your Help alert was accepted by the volunteer. Kindly be ready to go evacuated
          with emergency requirements.
        </p>
        <div className="flex justify-end mt-3">
          <button className="px-5 py-1.5 rounded-full bg-[#5fa3b8] text-white text-[11px]">
            OK
          </button>
        </div>
      </div>

      {/* humans illustration */}
      <div className="absolute bottom-0 inset-x-0">
        <svg viewBox="0 0 320 120" className="w-full" preserveAspectRatio="none">
          <path d="M0,80 Q80,40 160,70 T320,60 L320,120 L0,120Z" fill="#7eb5c8" opacity="0.5" />
          <path d="M0,100 Q80,70 160,90 T320,85 L320,120 L0,120Z" fill="#5fa3b8" opacity="0.7" />
        </svg>
        <div className="absolute bottom-0 inset-x-0 flex items-end justify-center gap-2 pointer-events-none">
          <VictimWoman className="w-[42%] h-[200px]" />
          <VolunteerMan className="w-[42%] h-[210px]" />
        </div>
      </div>
    </div>
  );
}

/* ============ S2 Map ============ */
export function S2Map() {
  return (
    <div className="relative w-full h-full">
      <MapBg />

      {/* Status strip */}
      <div className="absolute top-0 inset-x-0 z-30 px-3 pt-2">
        <div className="bg-white/95 backdrop-blur border border-[#e3e8ec] rounded-2xl flex items-center justify-between px-3 py-2 shadow-sm">
          <div className="flex items-center gap-1.5 px-2 py-0.5 rounded-full bg-[#fbe2e2] border border-[#f1c5c5]">
            <span className="w-1.5 h-1.5 rounded-full bg-[#d04545] animate-pulse" />
            <span className="text-[10px] tracking-wider text-[#8b2a2a] font-medium">LIVE</span>
          </div>
          <SourceDots />
          <div className="relative text-[#5a6b78]">
            <Bell size={15} />
            <span className="absolute -top-1.5 -right-1.5 bg-[#d04545] text-white text-[8px] rounded-full w-3.5 h-3.5 flex items-center justify-center">
              4
            </span>
          </div>
        </div>
        <div className="mt-2 bg-white border border-[#e3e8ec] rounded-2xl flex p-0.5 shadow-sm">
          <div className="flex-1 text-center py-1.5 rounded-xl text-[11px] text-[#8898a4] flex items-center justify-center gap-1.5">
            <Globe size={11} /> Global
          </div>
          <div className="flex-1 text-center py-1.5 rounded-xl text-[11px] bg-[#324a5e] text-white">
            Pakistan
          </div>
        </div>
      </div>

      <Pin x={42} y={48} level="CRITICAL" type="FLOOD" />
      <Pin x={68} y={62} level="HIGH" type="ROAD_BLOCKAGE" />
      <Pin x={55} y={36} level="MEDIUM" type="HEATWAVE" />
      <Pin x={30} y={70} level="RESOLVING" type="FIRE" />

      {/* mini crisis card */}
      <div className="absolute left-3 right-3 bottom-24 z-20">
        <div className={`${card} p-3`}>
          <div className="flex items-center gap-2">
            <div className="w-9 h-9 rounded-xl bg-[#fbe2e2] flex items-center justify-center text-[#d04545]">
              <CrisisIcon type="FLOOD" size={18} />
            </div>
            <div className="flex-1">
              <div className="flex items-center gap-1.5">
                <span className="text-[12px] text-[#2b3a48] font-medium">Lahore Flash Flood</span>
                <SeverityBadge level="CRITICAL" />
              </div>
              <div className="flex items-center gap-1 text-[10px] text-[#8898a4]">
                <MapPin size={9} /> Gulberg · 4 min ago
              </div>
            </div>
          </div>
          <div className="mt-2"><ConfBar value={94} /></div>
        </div>
      </div>

      {/* FAB */}
      <button
        className="absolute right-4 bottom-24 z-30 w-12 h-12 rounded-full flex items-center justify-center text-white shadow-lg"
        style={{
          background: "linear-gradient(135deg,#c9a876,#a8854f)",
          boxShadow: "0 8px 20px -8px rgba(168,133,79,0.7)",
        }}
      >
        <Plus size={20} />
      </button>

      <BottomNav active="Map" />
    </div>
  );
}

/* ============ S3 Crisis Detail Sheet ============ */
export function S3Detail() {
  return (
    <div className="relative w-full h-full overflow-hidden">
      <MapBg />
      <Pin x={48} y={28} level="CRITICAL" type="FLOOD" />
      <div className="absolute inset-0 bg-black/10" />
      <div
        className="absolute inset-x-0 bottom-0 top-[40%] rounded-t-3xl bg-white px-4 pt-3 pb-20 overflow-hidden border-t border-[#e3e8ec]"
        style={{ boxShadow: "0 -10px 30px -10px rgba(30,58,74,0.15)" }}
      >
        <div className="w-10 h-1 rounded-full bg-[#d6dde2] mx-auto" />
        <div className="flex items-center gap-2 mt-3">
          <div className="w-10 h-10 rounded-xl bg-[#fbe2e2] flex items-center justify-center text-[#d04545]">
            <CrisisIcon type="FLOOD" size={20} />
          </div>
          <div className="flex-1">
            <div className="flex items-center gap-2">
              <span className="text-[14px] text-[#2b3a48] font-medium">Flash Flood</span>
              <SeverityBadge level="CRITICAL" />
            </div>
            <div className="flex items-center gap-1 text-[10px] text-[#8898a4]">
              <MapPin size={9} /> Gulberg, Lahore · PK
            </div>
          </div>
        </div>
        <div className="mt-3"><ConfBar value={94} /></div>
        <div className="text-[10px] text-[#8898a4] mt-1 flex items-center gap-1">
          <Clock size={10} /> Detected 4 min ago · updated just now
        </div>

        <div className="mt-3 bg-[#f5f1ea] rounded-2xl p-3 space-y-1.5 text-[11px]">
          <div className="flex justify-between"><span className="text-[#8898a4]">Affected pop.</span><span className="text-[#2b3a48]">~42,500</span></div>
          <div className="flex justify-between"><span className="text-[#8898a4]">Blocked</span><span className="text-[#2b3a48]">MM Alam Rd, Liberty</span></div>
          <div className="flex justify-between"><span className="text-[#8898a4]">Rescue ETA</span><span className="text-[#5fa3b8] font-medium">12 min</span></div>
        </div>

        <div className="flex gap-2 mt-3">
          <button className="flex-1 py-2 rounded-xl bg-[#eef2f5] border border-[#dfe6ec] text-[#2b3a48] text-[11px] flex items-center justify-center gap-1.5">
            <RadioIcon size={12} /> 7 Signals
          </button>
          <button className="flex-1 py-2 rounded-xl bg-[#eef2f5] border border-[#dfe6ec] text-[#2b3a48] text-[11px] flex items-center justify-center gap-1.5">
            <Zap size={12} /> 4 Actions
          </button>
        </div>
        <div className="flex gap-2 mt-2">
          <button className="flex-1 py-2.5 rounded-xl bg-[#dceef3] border border-[#bcdde5] text-[#2b6478] text-[12px] flex items-center justify-center gap-1.5">
            <Navigation size={13} /> Zoom to City
          </button>
          <TanButton>
            <span className="inline-flex items-center gap-1.5">Full Details <ChevronDown size={13} className="rotate-[-90deg]" /></span>
          </TanButton>
        </div>
      </div>
      <BottomNav active="Map" />
    </div>
  );
}

/* ============ S4 Crisis Deep Dive ============ */
export function S4DeepDive() {
  return (
    <div className="relative w-full h-full flex flex-col" style={screenBg}>
      <TopBar
        title="Crisis Details"
        back
        right={<SeverityBadge level="CRITICAL" />}
      />
      <div className="flex-1 overflow-y-auto px-4 pt-3 pb-20 space-y-3">
        <div className="flex items-center gap-2">
          <div className="w-10 h-10 rounded-xl bg-[#fbe2e2] flex items-center justify-center text-[#d04545]">
            <CrisisIcon type="FLOOD" size={20} />
          </div>
          <div>
            <div className="text-[14px] text-[#2b3a48] font-medium">Flash Flood</div>
            <div className="text-[10px] text-[#8898a4]">Gulberg, Lahore · RESPONDING</div>
          </div>
        </div>

        <div className={`${card} p-3`}>
          <div className="text-[9px] tracking-widest text-[#a8854f] mb-2 font-medium">SITUATION</div>
          <div className="space-y-1.5 text-[11px]">
            <div className="flex justify-between items-center gap-3">
              <span className="text-[#8898a4]">Confidence</span>
              <div className="flex-1 max-w-[140px]"><ConfBar value={94} /></div>
            </div>
            <div className="flex justify-between"><span className="text-[#8898a4]">Affected area</span><span className="text-[#2b3a48]">3.4 km²</span></div>
            <div className="flex justify-between"><span className="text-[#8898a4]">Last updated</span><span className="text-[#2b3a48]">just now</span></div>
          </div>
        </div>

        <div className={`${card} p-3`}>
          <div className="text-[9px] tracking-widest text-[#a8854f] mb-2 font-medium">IMPACT ANALYSIS</div>
          <div className="space-y-1.5 text-[11px]">
            <div className="flex justify-between"><span className="text-[#8898a4]">Population</span><span className="text-[#2b3a48]">~42,500</span></div>
            <div className="flex justify-between"><span className="text-[#8898a4]">Casualty risk</span><span className="text-[#d04545] font-medium">CRITICAL</span></div>
            <div className="flex justify-between"><span className="text-[#8898a4]">Economic</span><span className="text-[#2b3a48]">PKR 8–12M/hr</span></div>
            <div className="flex gap-1 flex-wrap pt-1">
              <Chip>Road</Chip><Chip>Drainage</Chip><Chip>Power</Chip>
            </div>
          </div>
        </div>

        <div className={`${card} p-3`}>
          <div className="text-[9px] tracking-widest text-[#a8854f] mb-2 font-medium">BEFORE / AFTER</div>
          <div className="grid grid-cols-2 gap-3 text-[11px]">
            <div className="bg-[#fbe2e2] rounded-xl p-2.5">
              <div className="text-[#8b2a2a] text-[9px] mb-1 tracking-wider font-medium">BEFORE</div>
              <div className="space-y-1 text-[#2b3a48]">
                <div>Delay: <span className="text-[#d04545] font-medium">45 min</span></div>
                <div>Stranded: 320</div>
                <div>Alerted: 0</div>
              </div>
            </div>
            <div className="bg-[#dceef3] rounded-xl p-2.5">
              <div className="text-[#2b6478] text-[9px] mb-1 tracking-wider font-medium">AFTER</div>
              <div className="space-y-1 text-[#2b3a48]">
                <div>Delay: <span className="text-[#5fa890] font-medium">12 min</span></div>
                <div>Stranded: 4</div>
                <div>Alerted: 42,500</div>
              </div>
            </div>
          </div>
        </div>

        <div className={`${card} p-3`}>
          <div className="flex items-center justify-between">
            <div className="text-[9px] tracking-widest text-[#a8854f] font-medium">RESPONSE ACTIONS (4)</div>
            <ChevronDown size={14} className="text-[#8898a4]" />
          </div>
          <div className="mt-2 space-y-2">
            {[
              { t: "ALERT BROADCAST", s: "SENT", d: "42,500 devices · FCM-92ab1", icon: Send, tone: "teal" as const },
              { t: "ROUTE REDIRECT", s: "SIMULATED", d: "MM Alam → Boulevard alt", icon: Navigation, tone: "tan" as const },
              { t: "DISPATCH", s: "PLANNED", d: "Rescue-1922 unit", icon: Activity, tone: "default" as const },
            ].map(({ t, s, d, icon: Icon, tone }) => (
              <div key={t} className="bg-[#f5f1ea] border border-[#e6dccc] rounded-xl p-2.5">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-1.5">
                    <Icon size={12} className="text-[#5a6b78]" />
                    <span className="text-[11px] text-[#2b3a48] font-medium">{t}</span>
                  </div>
                  <Chip tone={tone}>{s}</Chip>
                </div>
                <div className="text-[10px] text-[#8898a4] mt-0.5">{d}</div>
              </div>
            ))}
          </div>
        </div>
      </div>
      <BottomNav active="Map" />
    </div>
  );
}

/* ============ S5 Signal Feed ============ */
export function S5Feed() {
  const signals = [
    {
      Icon: MessageSquare,
      src: "BLUESKY",
      lang: "ROMAN URDU",
      time: "1 min ago",
      text: "Gulberg main paani bohat zyada hai, gari nahi chal rahi. MM Alam band hai.",
      type: "FLOOD",
      loc: "Lahore",
      sim: true,
      conf: 22,
    },
    {
      Icon: Wind,
      src: "WEATHER",
      lang: "ENGLISH",
      time: "3 min ago",
      text: "Rainfall spike 84mm/hr detected at Lahore station — exceeds 30-yr average.",
      type: "FLOOD",
      loc: "Lahore",
      conf: 18,
    },
    {
      Icon: Newspaper,
      src: "RSS",
      lang: "ENGLISH",
      time: "5 min ago",
      text: "GeoNews: Heavy downpour paralyses Gulberg; commuters stranded on MM Alam Rd.",
      type: "FLOOD",
      loc: "Lahore",
      conf: 15,
    },
    {
      Icon: Activity,
      src: "TRAFFIC",
      lang: "ENGLISH",
      time: "6 min ago",
      text: "Congestion index 9.2/10 across Liberty Roundabout — sustained 14 min.",
      type: "ROAD_BLOCKAGE",
      loc: "Lahore",
      conf: 12,
    },
  ];
  return (
    <div className="relative w-full h-full flex flex-col" style={screenBg}>
      <TopBar title="Signal Feed" />
      <div className="px-3 pt-2">
        <div className="bg-white border border-[#e3e8ec] rounded-2xl flex p-0.5 shadow-sm">
          <div className="flex-1 text-center py-1.5 rounded-xl text-[11px] bg-[#324a5e] text-white">
            Pakistan
          </div>
          <div className="flex-1 text-center py-1.5 rounded-xl text-[11px] text-[#8898a4]">
            Global
          </div>
        </div>
        <div className="flex items-center gap-1.5 mt-2 px-1">
          <span className="w-1.5 h-1.5 rounded-full bg-[#5fa3b8] animate-pulse" />
          <span className="text-[10px] text-[#2b6478] tracking-wider font-medium">LIVE STREAM</span>
        </div>
      </div>
      <div className="flex gap-1.5 overflow-x-auto px-3 pt-2 pb-1 no-scrollbar">
        {["All", "Social", "News", "Weather", "Traffic", "Simulated"].map((t, i) => (
          <span
            key={t}
            className={`px-2.5 py-1 rounded-full text-[10px] whitespace-nowrap border ${
              i === 0
                ? "bg-[#324a5e] text-white border-[#324a5e]"
                : "bg-white text-[#5a6b78] border-[#e3e8ec]"
            }`}
          >
            {t}
          </span>
        ))}
      </div>
      <div className="flex-1 overflow-y-auto px-3 pb-20 space-y-2">
        {signals.map((s, i) => (
          <div key={i} className={`${card} p-3`}>
            <div className="flex items-center justify-between text-[10px] text-[#8898a4]">
              <div className="flex items-center gap-1.5">
                <s.Icon size={12} className="text-[#2b6478]" />
                <span className="text-[#2b3a48] font-medium">{s.src}</span>
              </div>
              <span>{s.time}</span>
            </div>
            <div className="flex gap-1.5 mt-1.5">
              <Chip tone="teal">{s.src}</Chip>
              <Chip icon={<Languages size={9} />}>{s.lang}</Chip>
              {s.sim && <Chip tone="tan">SIM</Chip>}
            </div>
            <p className="text-[12px] text-[#2b3a48] mt-2 leading-relaxed">{s.text}</p>
            <div className="text-[10px] mt-2 flex items-center justify-between">
              <span className="text-[#8898a4] flex items-center gap-1">
                <CrisisIcon type={s.type} size={11} className="text-[#5a6b78]" />
                {s.type} · {s.loc}
              </span>
              <span className="text-[#2b6478] font-medium">+{s.conf} conf</span>
            </div>
          </div>
        ))}
      </div>
      <BottomNav active="Feed" />
    </div>
  );
}

/* ============ S6 Agent Trace ============ */
export function S6Trace() {
  const agents = [
    { n: "Agent 1", t: "Signal Extraction", st: "SUCCESS", dur: "412ms" },
    { n: "Agent 2", t: "Detection & Scoring", st: "SUCCESS", dur: "881ms" },
    { n: "Agent 3", t: "Response Planning", st: "SUCCESS", dur: "1.2s" },
    { n: "Agent 4", t: "Action Execution", st: "RUNNING", dur: "—" },
  ];
  return (
    <div className="relative w-full h-full flex flex-col" style={screenBg}>
      <TopBar title="Agent Trace" />
      <div className="px-3 pt-2">
        <div className={`${card} p-2.5 flex items-center justify-between`}>
          <div className="flex items-center gap-2">
            <Cpu size={14} className="text-[#2b6478]" />
            <div>
              <div className="text-[9px] text-[#8898a4] tracking-wider font-medium">CRISIS</div>
              <div className="text-[12px] text-[#2b3a48]">Flash Flood · Lahore · 14:22</div>
            </div>
          </div>
          <ChevronDown size={14} className="text-[#8898a4]" />
        </div>
      </div>
      <div className="flex-1 overflow-y-auto px-3 pt-3 pb-20">
        <div className="relative">
          {agents.map((a, i) => (
            <div key={a.n} className="relative pl-10 pb-3">
              {i < agents.length - 1 && (
                <span className="absolute left-[15px] top-8 bottom-0 w-px bg-gradient-to-b from-[#7eb5c8] to-[#7eb5c8]/20" />
              )}
              <div
                className={`absolute left-0 top-1 w-8 h-8 rounded-full flex items-center justify-center text-[11px] border-2 ${
                  a.st === "RUNNING"
                    ? "bg-white border-[#5fa3b8] text-[#5fa3b8]"
                    : "bg-[#5fa890] border-[#5fa890] text-white"
                }`}
              >
                {a.st === "RUNNING" ? <Loader size={13} className="animate-spin" /> : <Check size={13} />}
              </div>
              <div className={`${card} p-3`}>
                <div className="flex items-center justify-between">
                  <div>
                    <div className="text-[12px] text-[#2b3a48] font-medium">{a.t}</div>
                    <div className="text-[9px] text-[#8898a4]">{a.n} · Gemini 1.5 Pro</div>
                  </div>
                  <Chip tone={a.st === "RUNNING" ? "teal" : "default"}>{a.st}</Chip>
                </div>
                {i === 1 && (
                  <div className="mt-2 text-[10px] text-[#2b3a48] space-y-1">
                    <div className="text-[#5a6b78] italic">"7 signals clustered around Gulberg. Confidence 94 (CRITICAL)."</div>
                    <div className="grid grid-cols-5 gap-1 mt-1.5">
                      {[["Base", 65], ["Geo", 22], ["Time", 18], ["Div", 18], ["Media", 15]].map(([k, v]) => (
                        <div key={k as string} className="bg-[#f5f1ea] border border-[#e6dccc] rounded-lg py-1 text-center">
                          <div className="text-[#a8854f] text-[11px] font-medium">{v}</div>
                          <div className="text-[8px] text-[#8898a4]">{k}</div>
                        </div>
                      ))}
                    </div>
                  </div>
                )}
                <div className="flex items-center justify-between mt-2 text-[10px] text-[#8898a4]">
                  <span className="flex items-center gap-1"><Clock size={9} /> {a.dur}</span>
                  <span className="text-[#2b6478] flex items-center gap-0.5">
                    <Eye size={10} /> Show JSON
                  </span>
                </div>
              </div>
            </div>
          ))}
        </div>

        <div className={`${card} p-3 mt-2`}>
          <div className="text-[9px] tracking-widest text-[#a8854f] mb-2 font-medium">TIMELINE</div>
          <div className="flex items-center gap-1">
            {[1, 1.2, 1.8, 1.5, 0.8].map((w, i) => (
              <div
                key={i}
                className="h-2 rounded-full"
                style={{
                  flex: w,
                  background:
                    i === 4
                      ? "#dceef3"
                      : "linear-gradient(90deg,#7eb5c8,#5fa3b8)",
                }}
              />
            ))}
          </div>
          <div className="flex justify-between text-[9px] text-[#8898a4] mt-1.5">
            <span>0s</span>
            <span>Total 2.7s</span>
          </div>
        </div>
      </div>
      <BottomNav active="Trace" />
    </div>
  );
}

/* ============ S7 Analytics ============ */
export function S7Analytics() {
  const bars = [
    ["FLOOD", 42, "#5fa3b8"],
    ["FIRE", 28, "#e07a3c"],
    ["ROAD", 18, "#d4a93c"],
    ["HEAT", 12, "#d04545"],
  ] as const;
  return (
    <div className="relative w-full h-full flex flex-col" style={screenBg}>
      <TopBar title="Analytics" back />
      <div className="px-3 pt-2">
        <div className={`${card} p-2 flex items-center gap-2`}>
          <Search size={14} className="text-[#8898a4]" />
          <span className="text-[11px] text-[#8898a4] flex-1">Ask about crisis data…</span>
          <button
            className="px-2.5 py-1 rounded-lg text-[10px] text-white font-medium"
            style={{ background: "linear-gradient(135deg,#c9a876,#a8854f)" }}
          >
            Ask
          </button>
        </div>
        <div className="flex gap-1.5 overflow-x-auto pt-2 pb-1 no-scrollbar">
          {["Floods in Karachi", "Top cities", "Avg response", "Resolved today"].map((t) => (
            <span
              key={t}
              className="px-2.5 py-1 rounded-full text-[10px] whitespace-nowrap bg-white border border-[#e3e8ec] text-[#5a6b78]"
            >
              {t}
            </span>
          ))}
        </div>
      </div>

      <div className="flex-1 overflow-y-auto px-3 pt-2 pb-20 space-y-2.5">
        <div className={`${card} p-3`}>
          <div className="text-[9px] tracking-widest text-[#a8854f] font-medium">TOTAL CRISES</div>
          <div className="flex items-end gap-2 mt-1">
            <span className="text-[#2b3a48] text-[28px] leading-none font-medium">247</span>
            <span className="text-[#5fa890] text-[11px] pb-1 flex items-center">↑ 18%</span>
          </div>
          <div className="text-[10px] text-[#8898a4]">vs last 30 days</div>
        </div>

        <div className={`${card} p-3`}>
          <div className="text-[9px] tracking-widest text-[#a8854f] mb-2 font-medium">BY TYPE</div>
          <div className="space-y-1.5">
            {bars.map(([k, v, c]) => (
              <div key={k} className="flex items-center gap-2 text-[10px]">
                <span className="w-12 text-[#5a6b78]">{k}</span>
                <div className="flex-1 h-2 rounded-full bg-[#eef2f5] overflow-hidden">
                  <div className="h-full rounded-full" style={{ width: `${v}%`, background: c }} />
                </div>
                <span className="w-8 text-right text-[#2b3a48]">{v}%</span>
              </div>
            ))}
          </div>
        </div>

        <div className={`${card} p-3`}>
          <div className="text-[9px] tracking-widest text-[#a8854f] mb-2 font-medium">TOP CITIES</div>
          {[["Lahore", 78], ["Karachi", 61], ["Islamabad", 42], ["Peshawar", 28]].map(([c, n], i) => (
            <div key={c as string} className="flex items-center justify-between py-1 text-[11px] border-b border-[#eef2f5] last:border-0">
              <span className="text-[#5a6b78]">{i + 1}. {c}</span>
              <span className="text-[#2b6478] font-medium">{n} events</span>
            </div>
          ))}
        </div>

        <div className={`${card} p-3`}>
          <div className="text-[9px] tracking-widest text-[#a8854f] font-medium">AVG RESPONSE TIME</div>
          <div className="grid grid-cols-2 gap-3 mt-2">
            <div>
              <div className="text-[#5fa3b8] text-[20px] font-medium">42s</div>
              <div className="text-[9px] text-[#8898a4]">Detection→Response</div>
            </div>
            <div>
              <div className="text-[#5fa890] text-[20px] font-medium">18m</div>
              <div className="text-[9px] text-[#8898a4]">Detection→Resolved</div>
            </div>
          </div>
        </div>
      </div>
      <BottomNav active="More" />
    </div>
  );
}

/* ============ S8 Report Disaster ============ */
export function S8Report() {
  return (
    <div className="relative w-full h-full flex flex-col" style={screenBg}>
      <TopBar title="Report a Crisis" back right={<span />} />
      <div className="flex-1 overflow-y-auto px-4 pt-3 pb-24 space-y-3">
        <div>
          <div className="text-[10px] tracking-widest text-[#a8854f] mb-1.5 font-medium">WHAT HAPPENED?</div>
          <div className={`${card} p-3 min-h-[100px] text-[12px] text-[#2b3a48] leading-relaxed`}>
            Gulberg main bohat paani jama ho gaya hai, MM Alam Road par traffic ruk gayi hai aur gariyan band ho rahi hain…
          </div>
          <div className="text-right text-[9px] text-[#8898a4] mt-1">142 / 1000</div>
        </div>

        <div>
          <div className="text-[10px] tracking-widest text-[#a8854f] mb-1.5 font-medium">CRISIS TYPE</div>
          <div className="flex gap-1.5 flex-wrap">
            {["Not sure", "Flood", "Fire", "Accident", "Road", "Heatwave"].map((t, i) => (
              <span
                key={t}
                className={`px-3 py-1.5 rounded-full text-[10px] border ${
                  i === 1
                    ? "bg-[#324a5e] text-white border-[#324a5e]"
                    : "bg-white text-[#5a6b78] border-[#e3e8ec]"
                }`}
              >
                {t}
              </span>
            ))}
          </div>
        </div>

        <div>
          <div className="text-[10px] tracking-widest text-[#a8854f] mb-1.5 font-medium">LOCATION</div>
          <div className="flex gap-2">
            <button className="flex-1 py-2 rounded-xl bg-[#dceef3] border border-[#bcdde5] text-[#2b6478] text-[11px] flex items-center justify-center gap-1.5">
              <MapPin size={12} /> Use GPS
            </button>
            <button className="flex-1 py-2 rounded-xl bg-white border border-[#e3e8ec] text-[11px] text-[#5a6b78] flex items-center justify-center gap-1.5">
              <Navigation size={12} /> Pick on Map
            </button>
          </div>
          <div className={`${card} mt-2 p-2.5 text-[11px]`}>
            <div className="text-[#2b3a48]">MM Alam Road, Gulberg III, Lahore</div>
            <div className="text-[9px] text-[#8898a4]">31.5204° N, 74.3587° E</div>
          </div>
        </div>

        <div>
          <div className="text-[10px] tracking-widest text-[#a8854f] mb-1.5 font-medium">PHOTO (OPTIONAL)</div>
          <div className={`${card} p-6 flex flex-col items-center text-[#8898a4] text-[11px] gap-1`}>
            <Camera size={22} className="text-[#a8854f]" />
            <div>Attach Photo</div>
          </div>
        </div>
      </div>
      <div className="absolute bottom-0 inset-x-0 p-3">
        <TanButton>
          <span className="inline-flex items-center gap-2"><Send size={13} /> Submit Signal</span>
        </TanButton>
      </div>
    </div>
  );
}

/* ============ S9 Notifications ============ */
export function S9Notifications() {
  const items = [
    {
      sev: "CRITICAL" as const,
      type: "Flash Flood",
      city: "Gulberg, Lahore",
      en: "Critical flood detected. Avoid MM Alam Road. Alt route via Boulevard active.",
      ur: "MM Alam Road bandh hai. Boulevard se jayein.",
      time: "2 min",
      unread: true,
    },
    {
      sev: "HIGH" as const,
      type: "Road Blockage",
      city: "Korangi, Karachi",
      en: "Major congestion on Korangi Crossing — rescue route activated.",
      ur: "Korangi Crossing par traffic jam.",
      time: "18 min",
      unread: true,
    },
    {
      sev: "RESOLVED" as const,
      type: "Heatwave",
      city: "Islamabad",
      en: "Heatwave advisory cleared. Temperatures normalising.",
      ur: "Garmi ki warning khatam.",
      time: "2 h",
    },
  ];
  return (
    <div className="relative w-full h-full flex flex-col" style={screenBg}>
      <TopBar
        title="Alert History"
        back
        right={<span className="text-[#a8854f] text-[11px] font-medium">Mark all read</span>}
      />
      <div className="px-3 pt-2 flex gap-1.5">
        {["Unread", "All", "Today", "Week"].map((t, i) => (
          <span
            key={t}
            className={`px-2.5 py-1 rounded-full text-[10px] border ${
              i === 0
                ? "bg-[#324a5e] text-white border-[#324a5e]"
                : "bg-white text-[#5a6b78] border-[#e3e8ec]"
            }`}
          >
            {t}
          </span>
        ))}
      </div>
      <div className="flex-1 overflow-y-auto px-3 pt-2 pb-20 space-y-2">
        {items.map((n, i) => (
          <div key={i} className={`${card} p-3 relative`}>
            {n.unread && (
              <span className="absolute left-1.5 top-1/2 -translate-y-1/2 w-1.5 h-1.5 rounded-full bg-[#5fa3b8]" />
            )}
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <SeverityBadge level={n.sev} />
                <span className="text-[11px] text-[#2b3a48] font-medium">{n.type}</span>
              </div>
              <span className="text-[9px] text-[#8898a4]">{n.time} ago</span>
            </div>
            <div className="text-[10px] text-[#8898a4] mt-0.5 flex items-center gap-1">
              <MapPin size={9} /> {n.city}
            </div>
            <div className="text-[11px] text-[#2b3a48] mt-1.5 leading-snug">{n.en}</div>
            <div className="text-[10px] text-[#8898a4] italic">{n.ur}</div>
            <div className="flex gap-2 mt-2">
              <button className="px-3 py-1 rounded-lg bg-[#dceef3] border border-[#bcdde5] text-[#2b6478] text-[10px]">
                View Crisis
              </button>
              {n.unread && (
                <button className="px-3 py-1 rounded-lg bg-white border border-[#e3e8ec] text-[10px] text-[#5a6b78]">
                  Mark read
                </button>
              )}
            </div>
          </div>
        ))}
      </div>
      <BottomNav active="More" />
    </div>
  );
}

/* ============ S10 Settings ============ */
export function S10Settings() {
  const sources = [
    { n: "Bluesky", st: "Live", t: "2 min", tone: "teal" as const, Icon: Wifi },
    { n: "YouTube", st: "Live", t: "4 min", tone: "teal" as const, Icon: Wifi },
    { n: "RSS Feeds", st: "Live", t: "1 min", tone: "teal" as const, Icon: Wifi },
    { n: "OpenWeather", st: "Stale", t: "18 min", tone: "tan" as const, Icon: Wifi },
    { n: "Maps Traffic", st: "Live", t: "3 min", tone: "teal" as const, Icon: Wifi },
    { n: "PMD", st: "Error", t: "—", tone: "default" as const, Icon: WifiOff },
  ];
  return (
    <div className="relative w-full h-full flex flex-col" style={screenBg}>
      <TopBar title="Settings" back right={<span />} />
      <div className="flex-1 overflow-y-auto px-3 pt-3 pb-20 space-y-3">
        <div>
          <div className="text-[10px] tracking-widest text-[#a8854f] mb-1.5 px-1 font-medium">OPERATING MODE</div>
          <div className={`${card} p-1 flex`}>
            <div className="flex-1 text-center py-2 rounded-xl bg-[#324a5e] text-white text-[11px] font-medium">
              LIVE SIGNALS
            </div>
            <div className="flex-1 text-center py-2 rounded-xl text-[#8898a4] text-[11px]">
              SIMULATED
            </div>
          </div>
          <div className="text-[10px] text-[#8898a4] mt-1.5 px-1">
            Polling real sources every 5–15 minutes
          </div>
        </div>

        <div>
          <div className="text-[10px] tracking-widest text-[#a8854f] mb-1.5 px-1 font-medium">SOURCE HEALTH</div>
          <div className={`${card} divide-y divide-[#eef2f5]`}>
            {sources.map(({ n, st, t, tone, Icon }) => (
              <div key={n} className="px-3 py-2.5 flex items-center justify-between">
                <div className="flex items-center gap-2.5">
                  <Icon size={14} className={st === "Error" ? "text-[#d04545]" : "text-[#5fa3b8]"} />
                  <div>
                    <div className="text-[12px] text-[#2b3a48]">{n}</div>
                    <div className="text-[9px] text-[#8898a4]">Last poll {t}</div>
                  </div>
                </div>
                <Chip tone={tone}>{st}</Chip>
              </div>
            ))}
          </div>
          <button className="w-full mt-2 py-2 rounded-xl bg-white border border-[#e3e8ec] text-[11px] text-[#2b3a48]">
            Force Refresh All
          </button>
        </div>

        <div>
          <div className="text-[10px] tracking-widest text-[#a8854f] mb-1.5 px-1 font-medium">ABOUT</div>
          <div className={`${card} p-3 text-[11px] space-y-1`}>
            <div className="flex justify-between"><span className="text-[#8898a4]">Version</span><span className="text-[#2b3a48]">1.0.0</span></div>
            <div className="flex justify-between"><span className="text-[#8898a4]">Hackathon</span><span className="text-[#2b3a48]">Antigravity 2026</span></div>
            <div className="flex justify-between"><span className="text-[#8898a4]">Challenge</span><span className="text-[#2b3a48]">#3</span></div>
          </div>
        </div>
      </div>
    </div>
  );
}

/* ============ S11 Simulation Bottom Sheet ============ */
export function S11Sim() {
  const scen = [
    { n: "Lahore Flash Flood", s: "CRITICAL", d: "5 signals · ~90s", sel: true, t: "FLOOD" },
    { n: "Karachi Road Blockage", s: "HIGH", d: "3 signals · ~60s", sel: false, t: "ROAD_BLOCKAGE" },
    { n: "Islamabad Heatwave", s: "MEDIUM", d: "2 signals · ~45s", sel: false, t: "HEATWAVE" },
    { n: "California Wildfire", s: "CRITICAL", d: "4 signals · ~75s", sel: false, t: "FIRE" },
  ] as const;
  return (
    <div className="relative w-full h-full overflow-hidden">
      <MapBg />
      <div className="absolute inset-0 bg-black/15" />
      <div
        className="absolute inset-x-0 bottom-0 rounded-t-3xl bg-white px-4 pt-3 pb-6 border-t border-[#e3e8ec]"
        style={{ boxShadow: "0 -10px 30px -10px rgba(30,58,74,0.2)" }}
      >
        <div className="w-10 h-1 rounded-full bg-[#d6dde2] mx-auto" />
        <div className="mt-3 flex items-center justify-between">
          <div>
            <div className="text-[14px] text-[#2b3a48] font-medium">Demo Scenarios</div>
            <div className="text-[10px] text-[#8898a4]">Pick a scripted crisis to run</div>
          </div>
          <Chip tone="tan" icon={<Sparkles size={9} />}>SIMULATED</Chip>
        </div>
        <div className="mt-3 space-y-2">
          {scen.map((c) => (
            <div
              key={c.n}
              className={`p-3 rounded-2xl border flex items-center gap-3 ${
                c.sel
                  ? "bg-[#dceef3] border-[#7eb5c8]"
                  : "bg-white border-[#e3e8ec]"
              }`}
            >
              {c.sel ? (
                <CircleCheck size={18} className="text-[#5fa3b8]" />
              ) : (
                <Circle size={18} className="text-[#cdd5dc]" />
              )}
              <div className="w-8 h-8 rounded-lg bg-white border border-[#e3e8ec] flex items-center justify-center text-[#5a6b78]">
                <CrisisIcon type={c.t} size={14} />
              </div>
              <div className="flex-1">
                <div className="flex items-center gap-2">
                  <span className="text-[12px] text-[#2b3a48] font-medium">{c.n}</span>
                  <SeverityBadge level={c.s as "CRITICAL" | "HIGH" | "MEDIUM"} />
                </div>
                <div className="text-[10px] text-[#8898a4]">{c.d}</div>
              </div>
            </div>
          ))}
        </div>
        <div className="mt-4">
          <TanButton>
            <span className="inline-flex items-center gap-2"><Sparkles size={13} /> Start Simulation</span>
          </TanButton>
        </div>
        <div className="text-center text-[11px] text-[#2b6478] mt-3">
          Switch back to Live
        </div>
      </div>
    </div>
  );
}

/* ============ S12 More ============ */
export function S12More() {
  const items: Array<{
    n: string;
    d: string;
    Icon: typeof Plus;
    badge?: string;
  }> = [
    { n: "Report a Crisis", d: "Submit a manual signal", Icon: Plus },
    { n: "Disaster Directory", d: "Browse detected crises", Icon: Filter },
    { n: "Analytics", d: "Historical intelligence", Icon: Activity },
    { n: "Notifications", d: "Alert history", Icon: Bell, badge: "4" },
    { n: "Settings & Health", d: "Mode, sources, config", Icon: SettingsIcon },
    { n: "About CIRO", d: "Hackathon info", Icon: Info },
  ];
  return (
    <div className="relative w-full h-full flex flex-col" style={screenBg}>
      <TopBar title="More" />
      <div className="flex-1 overflow-y-auto px-3 pt-3 pb-20 space-y-2">
        {items.map(({ n, d, Icon, badge }) => (
          <div key={n} className={`${card} p-3 flex items-center gap-3`}>
            <div className="w-10 h-10 rounded-xl bg-[#dceef3] border border-[#bcdde5] flex items-center justify-center text-[#2b6478]">
              <Icon size={16} />
            </div>
            <div className="flex-1">
              <div className="text-[13px] text-[#2b3a48] font-medium">{n}</div>
              <div className="text-[10px] text-[#8898a4]">{d}</div>
            </div>
            {badge && (
              <span className="px-1.5 py-0.5 rounded-full bg-[#d04545] text-white text-[10px] font-medium">
                {badge}
              </span>
            )}
            <ChevronDown size={14} className="rotate-[-90deg] text-[#cdd5dc]" />
          </div>
        ))}
      </div>
      <BottomNav active="More" />
    </div>
  );
}
