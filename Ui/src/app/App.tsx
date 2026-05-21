import { Radar } from "lucide-react";
import { PhoneFrame } from "./components/PhoneFrame";
import {
  S1Onboarding1,
  S1Onboarding2,
  S1Onboarding3,
  S1Onboarding4,
  SVolunteer,
  S2Map,
  S3Detail,
  S4DeepDive,
  S5Feed,
  S6Trace,
  S7Analytics,
  S8Report,
  S9Notifications,
  S10Settings,
  S11Sim,
  S12More,
} from "./components/screens";

const screens = [
  { label: "Onboarding · 1 of 4", node: <S1Onboarding1 /> },
  { label: "Onboarding · 2 of 4", node: <S1Onboarding2 /> },
  { label: "Onboarding · 3 of 4", node: <S1Onboarding3 /> },
  { label: "Onboarding · 4 of 4", node: <S1Onboarding4 /> },
  { label: "Volunteer Alert", node: <SVolunteer /> },
  { label: "S2 · Map", node: <S2Map /> },
  { label: "S3 · Crisis Detail", node: <S3Detail /> },
  { label: "S4 · Deep Dive", node: <S4DeepDive /> },
  { label: "S5 · Signal Feed", node: <S5Feed /> },
  { label: "S6 · Agent Trace", node: <S6Trace /> },
  { label: "S7 · Analytics", node: <S7Analytics /> },
  { label: "S8 · Report", node: <S8Report /> },
  { label: "S9 · Notifications", node: <S9Notifications /> },
  { label: "S10 · Settings", node: <S10Settings /> },
  { label: "S11 · Simulation", node: <S11Sim /> },
  { label: "S12 · More", node: <S12More /> },
];

export default function App() {
  return (
    <div
      className="min-h-screen w-full text-white"
      style={{ background: "#1e3a4a" }}
    >
      <header className="px-8 pt-10 pb-6 flex items-end justify-between flex-wrap gap-4">
        <div>
          <div className="flex items-center gap-3">
            <div
              className="w-11 h-11 rounded-2xl flex items-center justify-center"
              style={{
                background: "#c9a876",
                boxShadow: "0 10px 30px -10px rgba(201,168,118,0.6)",
              }}
            >
              <Radar size={22} className="text-[#1e3a4a]" />
            </div>
            <div>
              <div className="tracking-[0.32em] text-[12px] text-[#c9a876]">CIRO</div>
              <h1 className="text-white">Crisis Intelligence & Response Operations</h1>
            </div>
          </div>
          <p className="text-white/65 max-w-xl mt-2 text-[13px]">
            Mobile prototype gallery — autonomous disaster detection for Pakistan.
            Scroll horizontally to walk through every screen of the app.
          </p>
        </div>
        <div className="flex gap-2 flex-wrap">
          <span className="px-3 py-1.5 rounded-full bg-white/8 border border-white/15 text-[11px] text-white/75">
            React + Tailwind v4
          </span>
          <span className="px-3 py-1.5 rounded-full bg-[#c9a876]/20 border border-[#c9a876]/40 text-[11px] text-[#e8d4a8]">
            Mobile · 320×660
          </span>
          <span className="px-3 py-1.5 rounded-full bg-[#7eb5c8]/20 border border-[#7eb5c8]/40 text-[11px] text-[#bcdde5]">
            Lucide icons
          </span>
        </div>
      </header>

      <div className="overflow-x-auto pb-12">
        <div className="flex gap-8 px-8 min-w-max">
          {screens.map((s) => (
            <PhoneFrame key={s.label} label={s.label}>
              {s.node}
            </PhoneFrame>
          ))}
        </div>
      </div>

      <footer className="px-8 pb-10 text-[11px] text-white/45">
        Reference prototype for the Flutter Android build · navy + cream + tan ·
        cartoon vector illustrations · Lucide iconography
      </footer>
    </div>
  );
}
