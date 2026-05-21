import { ReactNode } from "react";
import { Signal, Wifi, BatteryFull } from "lucide-react";

export function PhoneFrame({ label, children }: { label: string; children: ReactNode }) {
  return (
    <div className="flex flex-col items-center gap-3 shrink-0">
      <div
        className="relative rounded-[44px] p-[10px] shadow-[0_30px_80px_-20px_rgba(0,0,0,0.55)]"
        style={{
          width: 320,
          height: 660,
          background: "linear-gradient(160deg,#1a1a1f,#0a0a0d)",
        }}
      >
        <div
          className="relative overflow-hidden rounded-[36px] w-full h-full"
          style={{ background: "#ffffff" }}
        >
          {/* Status bar */}
          <div className="absolute top-0 inset-x-0 h-9 flex items-center justify-between px-6 text-[11px] text-[#2b3a48] z-50 tracking-tight font-medium">
            <span>9:41</span>
            <div className="absolute left-1/2 -translate-x-1/2 top-1.5 w-24 h-5 rounded-full bg-black" />
            <div className="flex items-center gap-1 text-[#2b3a48]">
              <Signal size={11} />
              <Wifi size={11} />
              <BatteryFull size={13} />
            </div>
          </div>
          <div className="absolute inset-0 pt-9">{children}</div>
        </div>
      </div>
      <div className="text-[#cfe1ec]/80 text-[12px] tracking-wide uppercase">{label}</div>
    </div>
  );
}
