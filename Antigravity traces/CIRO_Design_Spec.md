# CIRO — UI/UX Design Specification
### Flutter Android App | Layout & Interaction Spec Only
**No colors, typography, or theme defined here — styling handled separately in Figma**

---

## Table of Contents

1. [Navigation Architecture](#1-navigation-architecture)
2. [Route Structure & Deep Links](#2-route-structure--deep-links)
3. [Global Components & States](#3-global-components--states)
4. [Screen Inventory](#4-screen-inventory)
5. [Screen Specifications](#5-screen-specifications)
   - [S1 Onboarding](#s1-onboarding)
   - [S2 Map](#s2-map)
   - [S3 Crisis Detail Sheet](#s3-crisis-detail-sheet)
   - [S4 Crisis Deep Dive](#s4-crisis-deep-dive)
   - [S5 Signal Feed](#s5-signal-feed)
   - [S6 Agent Trace](#s6-agent-trace)
   - [S7 Analytics](#s7-analytics)
   - [S8 Report Disaster](#s8-report-disaster)
   - [S9 Notifications](#s9-notifications)
   - [S10 Settings & System Health](#s10-settings--system-health)
   - [S11 Simulation Bottom Sheet](#s11-simulation-bottom-sheet)
   - [S12 More Menu](#s12-more-menu)
6. [Interaction Flows](#6-interaction-flows)
7. [Challenge 3 Compliance Checklist](#7-challenge-3-compliance-checklist)

---

## 1. Navigation Architecture

### Bottom Navigation Bar
Persistent across all primary screens. 4 items.

```
[ Map ] [ Feed ] [ Trace ] [ More ]
```

Rationale for each slot:
- Map — primary hero screen, always first
- Feed — signal stream, judges need fast access to see live ingestion
- Trace — agent trace screen promoted to primary nav, judges must find this in under 2 taps
- More — settings, notifications, report disaster, analytics, about

Stats / Analytics moved inside More. Agent Trace promoted out of More into primary nav because it is a core evaluation deliverable.

### Top App Bar
Persistent on all screens except Map (which has its own header).

```
[ Back arrow if nested ]  [ Screen Title ]  [ Bell icon with badge ]  [ Settings icon ]
```

Bell icon opens Notifications screen (S9).
Settings icon opens Settings screen (S10).

### Floating Action Button (FAB)
Visible only on Map screen (S2).
Position: bottom-right, above bottom nav bar.
Icon: plus symbol.
Action: navigates to Report Disaster screen (S8).
FAB hides when the Crisis Detail Sheet (S3) is expanded above 60% height.

---

## 2. Route Structure & Deep Links

All routes defined upfront so Flutter Navigator is correct from day one and FCM deep links work.

```
/                           → redirect to /map
/onboarding                 → S1 Onboarding (shown once, then skipped)
/map                        → S2 Map Screen
/map/pakistan               → S2 Map Screen, Pakistan view active
/crisis/:crisis_id          → S4 Crisis Deep Dive (deep link target from FCM)
/crisis/:crisis_id/trace    → S6 Agent Trace for specific crisis
/feed                       → S5 Signal Feed
/trace                      → S6 Agent Trace (most recent crisis)
/analytics                  → S7 Analytics
/report                     → S8 Report Disaster
/notifications              → S9 Notifications
/settings                   → S10 Settings & System Health
```

FCM notification payload must include `crisis_id`. On notification tap, app opens `/crisis/:crisis_id` directly regardless of current screen state. If app is terminated, opens to this route on launch.

---

## 3. Global Components & States

These components appear across multiple screens. Define once, reuse everywhere.

### 3.1 Status Bar Strip
Appears at the top of the Map screen only. Sticky, does not scroll.

```
[ Mode Pill ]  [ Source Health Dots x6 ]  [ Bell with badge ]
```

Mode Pill — two states:
- LIVE state: pill with pulsing dot indicator, label "LIVE SIGNALS"
- SIMULATED state: pill with static indicator, label "SIMULATED"
- Tapping either state opens Simulation Bottom Sheet (S11)

Source Health Dots — 6 dots in a row, one per source: Bluesky, YouTube, RSS, Weather, Traffic, PMD.
- Each dot has 3 states: active (live, polled within 10 min), stale (polled 10–30 min ago), error/simulated
- Tapping any dot shows a tooltip anchored below it: source name, last poll timestamp, signal count from last poll, current state label

### 3.2 Global / Pakistan Toggle
Appears on: Map screen header, Signal Feed header, Disaster list inside More.

```
[ Global ]  [ Pakistan ]
```

Segmented control style, two options only.
Switching state persists via Riverpod provider across all screens that use it.
On Map screen, switching triggers an animated camera fly-to.
On list screens, switching re-filters the list with a cross-fade animation.

### 3.3 Severity Badge
Reusable chip component used on all crisis-related surfaces.

States: CRITICAL, HIGH, MEDIUM, RESOLVING, RESOLVED
Each state has a distinct label. No icon required here — icon is handled by the crisis type component.

### 3.4 Crisis Type Icon
Reusable icon component. One icon per crisis type.

Types: FLOOD, FIRE, ROAD_BLOCKAGE, HEATWAVE, ACCIDENT, EARTHQUAKE, LANDSLIDE, STORM, INFRASTRUCTURE_FAILURE, UNKNOWN.

### 3.5 Confidence Score Bar
Horizontal progress bar showing confidence 0–100.
Bar fills left to right proportional to confidence value.
Numeric percentage displayed to the right of the bar.
Segmented visually at 45 and 61 to indicate MEDIUM / HIGH / CRITICAL thresholds.
Used in: Crisis Detail Sheet, Crisis Deep Dive, Disaster tiles in More.

### 3.6 Source Tag Chip
Small chip showing signal source. Used in signal cards.
Label: BLUESKY / YOUTUBE / RSS / WEATHER / TRAFFIC / PMD / MANUAL
Second chip alongside it: language tag — ROMAN URDU / ENGLISH / FORMAL URDU / ARABIC / OTHER
Third chip if applicable: SIM (for simulated signals)

### 3.7 Loading State
Full-screen loading: centered circular progress indicator with a short label below ("Loading signals...", "Fetching crisis data...").
List-level loading: shimmer skeleton cards — same dimensions as real cards, placeholder lines where text would appear.
Inline loading: small circular indicator inline with the triggering element.

### 3.8 Empty State
Used when a screen has no data to show. Centered layout:
```
[ Icon representing the data type ]
[ Primary message — short, one line ]
[ Secondary message — optional explanation ]
[ Action button — optional, e.g. "Switch to Simulated" or "Report a Crisis" ]
```

### 3.9 Error State
Used when a data fetch fails. Centered layout:
```
[ Error icon ]
[ "Something went wrong" ]
[ Brief reason if available ]
[ Retry button ]
```

### 3.10 Map Pin Markers (BitmapDescriptor)
Custom markers, not default Google Maps pins.

```
CRITICAL   48px  pulse animation loop (flutter_animate repeating)
HIGH       44px  bounce animation on first appear, then static
MEDIUM     40px  static, no animation
RESOLVING  40px  slow fade-pulse animation
RESOLVED   36px  static, auto-removed from map after 30 seconds
```

Each marker has a small severity indicator badge overlaid at top-right corner.
Tapping any marker opens Crisis Detail Sheet (S3).

---

## 4. Screen Inventory

```
S1   Onboarding              Full screen carousel    First-time launch only
S2   Map                     Primary screen          Crisis map, hero screen
S3   Crisis Detail Sheet     Bottom sheet            Quick view on pin tap
S4   Crisis Deep Dive        Full screen             Complete crisis analysis
S5   Signal Feed             Full screen             Raw signal stream
S6   Agent Trace             Full screen             Agent pipeline visualization
S7   Analytics               Full screen             BigQuery statistics
S8   Report Disaster         Full screen             Manual signal submission
S9   Notifications           Full screen             FCM alert history
S10  Settings & System Health Full screen            Mode, source health, config
S11  Simulation Bottom Sheet  Bottom sheet           Scenario selector
S12  More Menu               Full screen             Secondary nav hub
S13  Volunteer Alert         Full screen             Volunteer notification alert
```

Total: 13 screens (11 full screen + 2 bottom sheets)

---

## 5. Screen Specifications

---

### S1 Onboarding

**Trigger:** First app launch only. Checks SharedPreferences for `has_seen_onboarding`. If false, shows this screen. If true, redirects to /map immediately.

**Layout:** Full-screen PageView with 4 slides. Dot page indicator at bottom. Skip button top-right on all slides. Next button bottom-right. On slide 4, Next becomes "Get Started."

**Slide 1 — What CIRO Is**
```
[ Top half: animated illustration — globe with pins dropping in sequence ]

[ Bottom half: ]
  Headline: "Autonomous Crisis Intelligence"
  Body: "CIRO detects urban crises from social signals, weather, and 
         traffic data — before official reports arrive."
```

**Slide 2 — How It Works**
```
[ Top half: 4-step horizontal animation ]
  Step 1: Signal icon
  Step 2: Detection icon
  Step 3: Plan icon
  Step 4: Respond icon
  Animated connector line drawing between steps left to right

[ Bottom half: ]
  Headline: "Signal to Response in Seconds"
  Body: "Agents analyze incoming data, detect crises, plan coordinated 
         responses, and simulate execution automatically."
```

**Slide 3 — Pakistan Focus**
```
[ Top half: static Pakistan map outline with 3 colored pins placed 
  in Lahore, Karachi, Islamabad ]

[ Bottom half: ]
  Headline: "Built for Pakistan"
  Body: "Optimized for Pakistani cities with native Roman Urdu 
         signal processing. Switch to global view anytime."
```

**Slide 4 — Simulation Mode**
```
[ Top half: illustration of the LIVE/SIMULATED toggle in both states ]

[ Bottom half: ]
  Headline: "Live or Simulated"
  Body: "Toggle between real-time signal ingestion and scripted 
         demo scenarios. The agent pipeline is identical in both modes."

  Button: "Get Started" — saves has_seen_onboarding = true, navigates to /map
```

**Skip button behavior:** Saves has_seen_onboarding = true, navigates to /map immediately.

---

### S2 Map

**This is the hero screen. All navigation originates here.**

**Full Layout:**
```
[ Status Bar Strip ]           ← sticky, see 3.1
[ Global / Pakistan Toggle ]   ← below status strip
[ Map Viewport ]               ← fills remaining screen
[ FAB — bottom right ]
[ Bottom Navigation Bar ]
```

**Map Viewport — Global Mode**
```
Camera: (20N, 0E), zoom 2.5
Map type: hybrid (satellite + roads)
Rotation: enabled
Crisis pins: all active global crises rendered as custom markers
No traffic layer in global mode (too noisy at this zoom)
Tapping a pin: opens S3 Crisis Detail Sheet
Panning/zooming: free
```

Empty state — no active global crises:
```
[ Subtle centered overlay on map: ]
  "No active crises detected globally"
  "Switch to Simulated to run a demo scenario"
  [ Switch to Simulated button ]
```

**Map Viewport — Pakistan Mode**
```
Camera: (30N, 70E), zoom 5.5
Map type: normal (cleaner for urban detail)
Rotation: enabled
Crisis pins: Pakistan crises only
Traffic layer: always on — renders Google Maps red/yellow/green road coloring
Tapping a pin: opens S3 Crisis Detail Sheet
```

When user taps "Zoom to City" inside S3 Detail Sheet:
```
Camera animates to zoom 12 centered on crisis lat/lng
Traffic layer remains on
Detail Sheet collapses to 20% height (drag handle still visible)
"Back to Pakistan View" button appears as a floating chip 
  top-center of map viewport
  Tapping it: camera animates back to (30N, 70E) zoom 5.5
              floating chip disappears
              Detail Sheet expands back to 35%
```

Empty state — no active Pakistan crises:
```
[ Subtle centered overlay: ]
  "No active crises in Pakistan"
  "Report a crisis or start a simulation"
  [ Report ] [ Simulate ] — two buttons side by side
```

**FAB**
Position: bottom-right, 16dp above bottom nav bar.
Icon: plus symbol.
Behavior: navigates to /report (S8).
Visibility: hidden when S3 Detail Sheet is expanded above 60% screen height.

**Status Bar Strip — detail**
```
[ Mode Pill ]  [ 6 source dots ]  [ Bell icon ]

Mode Pill:
  LIVE state:  "LIVE SIGNALS"  pulsing dot
  SIM state:   "SIMULATED"     static dot
  Tap either:  opens S11 Simulation Bottom Sheet

Source dots layout (left to right):
  Dot 1: Bluesky
  Dot 2: YouTube
  Dot 3: RSS
  Dot 4: Weather
  Dot 5: Traffic
  Dot 6: PMD
  Each dot: 3 visual states — active / stale / error
  Tap dot: tooltip appears below
    Tooltip content: "[Source name] — Last poll: [X] min ago — [N] signals"
    Tooltip dismisses on tap-outside

Bell icon: badge shows unread notification count
  Tap: navigates to /notifications (S9)
```

---

### S3 Crisis Detail Sheet

**Trigger:** Tap any crisis pin on S2 Map.

**Component:** DraggableScrollableSheet
```
Initial snap: 35% screen height
Mid snap:     65% screen height  (user drags up)
Max snap:     85% screen height  (user drags to full)
Min snap:     15% screen height  (user drags down — does not dismiss, stays visible)
Dismiss:      tap outside the sheet OR drag down from 15% with velocity
```

Drag handle: centered at top of sheet, 32px wide, 4px tall, rounded.

**Layout at initial snap (35%):**
```
[ Drag handle ]

[ Crisis Type Icon ]  [ Severity Badge ]  [ Confidence Score Bar ]  [ NN% ]

[ City, District, Country ]
[ "Detected X minutes ago" ]   ← relative timestamp, live-updating

[ Impact Summary Block ]
  Affected population: ~NN,NNN
  Blocked: [road 1], [road 2]
  Rescue ETA: N minutes   (or "—" if not yet dispatched)

[ Pill Button: "N Signals" ]   [ Pill Button: "N Actions" ]

[ "Zoom to City" button ]      [ "Full Details" button → ]
```

**Tap "N Signals" pill:**
Sheet snaps to 65%. Below the impact block, a scrollable list appears showing the first 3 signal cards (same design as Signal Feed cards, see S5). A "See All Signals" link at the bottom.

**Tap "N Actions" pill:**
Sheet snaps to 65%. Below the impact block, the 3 action rows appear (type, status badge, one-line description). A "See Full Response" link at the bottom.

**Tap "Full Details" button:**
Pushes route /crisis/:crisis_id (S4 Crisis Deep Dive). Sheet closes.

**Tap "Zoom to City" button:**
Map camera animates to zoom 12. Sheet collapses to 20%. Floating "Back to Pakistan View" chip appears on map. (Pakistan mode only — in Global mode this button is replaced with "View on Map" which just centers the camera on the crisis without zooming to street level.)

**Real-time updates while sheet is open:**
If the crisis document updates (confidence change, new action executed, status change), the sheet content refreshes in-place without closing. A subtle "Updated just now" text appears below the timestamp and fades after 3 seconds.

**Status transition banner:**
If crisis status changes to RESOLVED while sheet is open:
```
[ Banner slides in from top of sheet: ]
  "Crisis marked as resolved"
  [ View History button ]
```

---

### S4 Crisis Deep Dive

**Route:** /crisis/:crisis_id

**Header:**
```
[ Back arrow ]  [ Crisis Type Icon + Type label ]  [ Severity Badge ]

[ City, District ]
[ Status badge: DETECTED / RESPONDING / RESOLVING / RESOLVED ]
[ "Detected X min ago  •  Updated X min ago" ]
```

If crisis is RESOLVED, a full-width resolved banner sits below the header:
```
[ "RESOLVED — X hours ago" ]
```

**Body:** Single scrollable column. Sections in this order:

**Section A — Situation**
```
[ Section header: "SITUATION" ]

Confidence Score:   [ progress bar ]  NN%
Severity:           [ Severity Badge ]
Affected Area:      N.N km²  (estimated)
Status:             [ Status label ]
Last Updated:       X minutes ago  (live-updating)
```

**Section B — Impact Analysis**
```
[ Section header: "IMPACT ANALYSIS" ]

Affected Population:      ~NN,NNN
Infrastructure Blocked:   [ comma-separated list ]
Casualty Risk:            [ LOW / MEDIUM / HIGH / CRITICAL ]
Economic Impact:          PKR X–XM per hour
Services Disrupted:       [ chip row: Road Access, Drainage, Electricity, etc. ]
```

**Section C — Before / After System State**
```
[ Section header: "SYSTEM STATE" ]

[ Two-column layout: ]
  BEFORE                  AFTER
  ──────                  ─────
  Avg Delay: NN min       Avg Delay: NN min
  Stranded: NNN           Stranded: N
  Rescue ETA: —           Rescue ETA: N min
  Alerted: 0              Alerted: NN,NNN

[ "View Route on Map" button ]
  → closes deep dive, returns to map, animates camera to crisis location,
    shows route polylines, opens detail sheet
```

**Section D — Contributing Signals**
Expandable. Default: collapsed, shows "N signals from N sources."
On expand:

```
[ Section header: "CONTRIBUTING SIGNALS (N)" ]

[ Filter chips horizontal scroll: ]
  All  |  Social  |  News  |  Weather  |  Traffic  |  Official  |  Manual  |  Simulated

[ Signal cards list — subcollection lazy-loaded on expand ]
```

Signal Card (identical to S5 Feed card):
```
[ Source icon ]  [ Source name ]  [ "X min ago" ]
[ Language chip ]  [ SIM chip if simulated ]

[ raw_text displayed in original language ]
[ one line, truncated with "..." if long ]

Confidence contribution: +NN
Extracted event type: [FLOOD / etc.]
Location confidence: [HIGH / MEDIUM / LOW]

[ If contributed to this crisis: no extra label needed ]
[ If this is a discarded signal: "NOT USED — [reason]" label ]
```

**Section E — Response Actions**
Expandable. Default: collapsed, shows "N actions — N simulated."
On expand:

```
[ Section header: "RESPONSE ACTIONS (N)" ]

Action Row (one per action):
  [ Action type label ]         [ Status chip: PLANNED / SIMULATING / SIMULATED / SENT ]
  [ One-line description ]
  [ Ticket ID or message ID if available ]
  [ "View on Map" if ROUTE_REDIRECT ]  or  [ "View Ticket" if DISPATCH ]
```

ROUTE_REDIRECT action additionally shows:
```
[ Inline mini-map — non-interactive ]
  Blocked route: marked in one visual state
  Alternate route: marked in another visual state
  Two labels: "BLOCKED" on original, "USE THIS" on alternate
```

ALERT_BROADCAST action additionally shows:
```
Alert radius: N km
Recipients: ~NN,NNN
FCM Message ID: [id]
```

**Section F — Agent Reasoning Timeline**
Expandable. Default: collapsed, shows "View agent reasoning."
On expand:

```
[ Section header: "AGENT REASONING" ]

Timeline layout — vertical, each agent is one row:

  [ Agent 1 — Signal Extraction ]
    Timestamp: HH:MM:SS
    One-line summary of what was extracted
    Duration: NNms

  [ Agent 2 — Crisis Detection ]
    Timestamp: HH:MM:SS
    "N signals clustered. Confidence: NN (SEVERITY)."
    Confidence breakdown visible inline:
      Base scores: NN  |  Geo bonus: NN  |  Temporal: NN  |  Diversity: NN  |  Media: NN
    Duration: NNms

  [ Agent 3 — Response Planning ]
    Timestamp: HH:MM:SS
    "N actions selected: [type], [type], [type]"
    One-line reasoning summary
    Duration: NNms

  [ Agent 4 — Action Execution ]
    Timestamp: HH:MM:SS
    "N actions simulated. FCM delivered."
    Duration: NNms

  [ If any feedback loop triggered: ]
    [ Indented sub-row: "Re-extraction triggered — location confidence was LOW" ]
    [ Indented sub-row: "Severity recheck — borderline HIGH/MEDIUM" ]
    [ Indented sub-row: "Replanning triggered — [reason]" ]

[ "View Full Trace" button → navigates to /crisis/:crisis_id/trace (S6) ]
```

---

### S5 Signal Feed

**Route:** /feed

**Header:**
```
[ "Signal Feed" title ]
[ Global / Pakistan Toggle ]
[ Live indicator: pulsing dot + "Live" label ]
```

**Filter bar — horizontal scroll, sticky below header:**
```
All | Social | News | Weather | Traffic | Official | Manual | Simulated | Discarded
```

Selecting a filter cross-fades the list. "All" is default. "Discarded" shows signals Agent 1 rejected — useful for transparency.

**Body:** Reverse-chronological list from `incoming_signals` Firestore collection. Real-time snapshot listener — new signals prepend to top with a brief slide-in animation.

**Signal Card:**
```
[ Source icon ]  [ Source name ]  [ "X min ago" timestamp ]

[ Source chip ]  [ Language chip ]  [ SIM chip if simulated ]

[ raw_text — full text, not truncated on feed ]

[ Extracted: event_type label  •  location string ]
[ Location confidence: HIGH / MEDIUM / LOW ]

[ "Contributed to crisis:" + crisis type badge + city ]  ← if linked to a crisis
  [ "View Crisis" button ]
  
[ "Not used — [Agent 1 rejection reason]" ]  ← if discarded
```

**Empty state:**
```
[ "No signals received yet" ]
[ "Signal pollers run every 5–15 minutes" ]
[ "Switch to Simulated to see signals now" button ]
```

**Loading state:** 4 shimmer skeleton cards.

**Error state:** standard error component with retry.

---

### S6 Agent Trace

**Route:** /trace (most recent) or /crisis/:crisis_id/trace (specific)

**This screen is a primary evaluation deliverable. Design it to be self-explanatory.**

**Header:**
```
[ "Agent Trace" title ]

[ Crisis selector dropdown: ]
  "Crisis: [type] — [city] — [timestamp]"
  Tapping opens a list of the last 10 crisis events, selectable
  Default: most recent crisis
```

**Body — two sections:**

**Section 1 — Execution Graph**
Vertical node graph, each agent is one node. Nodes connected by directional arrows.

```
    [ Signal Received ]
           |
           v
    [ Agent 1: Extraction ]
    Status chip: SUCCESS / RUNNING / FAILED
    Timestamp: HH:MM:SS
    Duration: NNms
    Tap to expand detail card below
           |
           v  (or forked arrow if re-extraction loop triggered)
    [ Agent 2: Detection & Scoring ]
    Status chip
    Timestamp + Duration
    Tap to expand
           |
           v  (or forked arrow if severity recheck loop triggered)
    [ Agent 3: Response Planning ]
    Status chip
    Timestamp + Duration
    Tap to expand
           |
           v  (or forked arrow if replanning loop triggered)
    [ Agent 4: Action Execution ]
    Status chip
    Timestamp + Duration
    Tap to expand
```

If a feedback loop was triggered, the graph shows a curved back-arrow from the loop-triggering agent back to the target agent, labeled with the loop type ("Re-extraction", "Severity recheck", "Replanning").

**Node Detail Card (appears below node when tapped, slides in):**
```
[ Agent name + model: "Gemini 1.5 Pro" ]
[ Duration: NNms ]

Input summary:
  [ Key input fields — 3–4 lines, human readable ]

Output summary:
  [ Key output fields — 3–4 lines, human readable ]

Reasoning:
  [ Full reasoning text from agent_reasoning array ]
  [ Scrollable if long ]

[ "Show Raw JSON" toggle ]
  When on: renders the full raw JSON payload for this agent step
  When off: shows the human-readable summary above
```

**Section 2 — Execution Timeline**
Below the graph, a horizontal timeline bar showing:
```
[ Signal arrived ] → [ Agent 1 ] → [ Agent 2 ] → [ Agent 3 ] → [ Agent 4 ] → [ Complete ]
        HH:MM:SS       +NNs           +NNs           +NNs           +NNs        Total: NNs
```

Total pipeline duration shown at the end.

**Empty state:**
```
[ "No agent trace available yet" ]
[ "Run a simulation to generate a trace" ]
[ "Start Simulation" button ]
```

---

### S7 Analytics

**Route:** /analytics

**Header:**
```
[ "Crisis Analytics" title ]
[ Global / Pakistan Toggle ]
```

**Natural Language Query Bar — sticky below header:**
```
[ Text input field: "Ask a question about crisis data..." ]
[ Submit button ]

Example query chips below the input (horizontal scroll):
  "Floods in Karachi this week"
  "Most active signal source"
  "Top cities by crisis count"
  "Average response time"
  "Crises resolved today"
```

Tapping an example chip fills the input and auto-submits.

**Query Result Card — appears below query bar when a result is ready:**
```
[ Query text displayed ]
[ Loading: inline spinner while Gemini + BigQuery runs ]
[ Result: formatted answer — number, list, or short sentence ]
[ "Generated SQL" toggle — shows the SQL Gemini produced ]
[ Error: "Could not answer this question. Try rephrasing." ]
```

**Dashboard Cards — scrollable, below query section:**

Card 1 — Total Crises
```
[ "TOTAL CRISES DETECTED" ]
[ Large number ]
[ Delta vs last 30 days: up/down arrow + percentage ]
```

Card 2 — By Type
```
[ "BY TYPE" ]
[ Horizontal bar chart rows: ]
  FLOOD           ████████████  NN%
  FIRE            ██████        NN%
  ROAD BLOCKAGE   █████         NN%
  HEATWAVE        ████          NN%
  OTHER           █████         NN%
```

Card 3 — Top Cities (Pakistan mode) or Top Countries (Global mode)
```
[ "TOP LOCATIONS" ]
  1.  [City/Country]     NNN events
  2.  [City/Country]     NNN events
  3.  [City/Country]     NNN events
  ...up to 5
```

Card 4 — Signal Sources
```
[ "SIGNAL SOURCES" ]
  RSS News      ██████████  NN%
  Social        ████████    NN%
  Weather       █████       NN%
  Traffic       ███         NN%
  YouTube       ██          NN%
  Manual        █           NN%
```

Card 5 — Response Time
```
[ "AVG RESPONSE TIME" ]
[ Detection → Response: NNs average ]
[ Detection → Resolved: NNm average ]
```

**Loading state:** shimmer cards while BigQuery loads.

**Empty state:**
```
[ "No analytics data yet" ]
[ "Run a simulation to generate crisis events" ]
```

---

### S8 Report Disaster

**Route:** /report

**Header:**
```
[ Back arrow ]  [ "Report a Crisis" title ]
```

**Body — single scrollable form:**

```
[ Section: "What happened?" ]
  Text input — multi-line, expands as user types
  Placeholder: "Describe what you're seeing. Any language is fine."
  Character count displayed below: NNN / 1000
  No submit-on-enter — this is a text area

[ Section: "Crisis type (optional)" ]
  "Helps our agents classify faster. Skip if unsure."
  Dropdown or horizontal chip selector:
    Not sure  |  Flood  |  Fire  |  Accident  |  Road Blockage  |  
    Heatwave  |  Earthquake  |  Other

[ Section: "Location" ]
  Two options shown as toggle buttons:
    [ Use My GPS Location ]   [ Pick on Map ]

  "Use My GPS Location" selected state:
    Shows detected address string below button
    "lat, lng" in smaller text below address
    [ Change ] link

  "Pick on Map" selected state:
    Opens a full-screen map modal
    User taps location on map
    Confirm button returns to this screen with selected coordinates
    Selected location shows as address string

[ Section: "Photo (optional)" ]
  "A photo increases signal confidence."
  [ Attach Photo ] button — opens image picker
  If photo attached: thumbnail preview with remove button

[ Submit button — full width, sticky at bottom of screen above keyboard ]
```

**Submission States:**

Loading:
```
[ Full-screen overlay, not dismissable ]
[ Spinner ]
[ "Sending to CIRO Intelligence Layer..." ]
```

Success:
```
[ Full-screen overlay, not dismissable ]
[ Success icon ]
[ "Signal received" ]
[ "Agent 1 is analyzing your report" ]
[ Auto-dismisses after 3 seconds → navigates to /map ]
[ Or: "Back to Map" button for immediate dismiss ]
```

Error:
```
[ Error banner at top of screen — not overlay ]
[ "Failed to submit. Check your connection." ]
[ Retry button ]
[ Form remains filled — user does not lose input ]
```

---

### S9 Notifications

**Route:** /notifications

**Header:**
```
[ "Alert History" title ]
[ "Mark all read" button — top right ]
```

**Filter bar:**
```
Unread | All | Today | This Week
```

**Notification Card:**
```
[ Severity badge ]  [ Crisis type label ]  [ Timestamp: "N minutes ago" ]
[ Unread indicator dot — left edge of card, only on unread cards ]

[ City, District ]

[ Alert message text — 2–3 lines, full message ]

[ English message ]
[ Below it in smaller text: Urdu message if available ]

[ "View Crisis" button ]
[ "Mark as Read" button — only on unread cards ]
```

Tapping the card body: navigates to /crisis/:crisis_id.
Tapping "Mark as Read": removes unread indicator inline, updates badge count in top bar.

**Empty state:**
```
[ "No alerts yet" ]
[ "CIRO sends alerts when crises are detected and actions are executed" ]
```

---

### S10 Settings & System Health

**Route:** /settings

**This screen also functions as the simulation control center.**

**Header:**
```
[ Back arrow ]  [ "Settings" title ]
```

**Body — vertical sections:**

**Section: Operating Mode**
```
[ "OPERATING MODE" ]
[ Large toggle: LIVE SIGNALS  /  SIMULATED ]

Current mode label below toggle:
  LIVE mode:     "Polling real signal sources every 5–15 minutes"
  SIM mode:      "Using pre-scripted demo scenarios"
```

**Section: Simulation Scenarios (visible only in SIMULATED mode)**
```
[ "DEMO SCENARIOS" ]

Radio list:
  ( ) Lahore Flash Flood         CRITICAL
  ( ) Karachi Road Blockage      HIGH
  ( ) Islamabad Heatwave         MEDIUM
  ( ) California Wildfire        CRITICAL
  ( ) Istanbul Earthquake        HIGH

[ "Start Simulation" button — full width ]
  Disabled until a scenario is selected.
  On tap: triggers simulation Cloud Function, 
          switches to /map automatically,
          sheet closes

[ "Stop Simulation" button — visible only if a simulation is in progress ]
  Stops the signal replay Cloud Function.
  Clears simulated signals from the feed.
```

**Section: Signal Source Health**
```
[ "SIGNAL SOURCE HEALTH" ]

One row per source:
  [ Source name ]    [ State label: Live / Stale / Simulated / Error ]
  Last polled: X minutes ago
  Last result: N signals

Sources:
  Bluesky
  YouTube
  RSS Feeds
  OpenWeatherMap
  Google Maps Traffic
  Pakistan Met Dept (PMD)

[ "Force Refresh All" button ]
  Triggers all pollers manually. Useful if sources show stale.
```

**Section: App Info**
```
[ "ABOUT" ]

App version: 1.0.0
Hackathon: AISeekho Antigravity 2026 — Challenge 3
Team: [Team name]

[ "View Artifacts Bucket" ] — opens gs:// link or Cloud Console URL
[ "View Antigravity Traces" ] — same bucket, traces subfolder
```

---

### S11 Simulation Bottom Sheet

**Trigger:** Tap Mode Pill in Status Bar Strip (on Map screen). Also accessible from S10 Settings.

**Component:** Modal BottomSheet (not draggable — fixed height).

```
[ Drag handle ]

[ "Demo Scenarios" — section header ]

[ If LIVE mode currently active: ]
  "Switch to simulated mode to run a demo scenario."
  [ "Switch to Simulated" toggle ]

[ If SIMULATED mode currently active: ]
  [ Radio list: ]
    ( ) Lahore Flash Flood (CRITICAL)
        "5 signal types • ~90 seconds to detection"
    ( ) Karachi Road Blockage (HIGH)
        "3 signal types • ~60 seconds to detection"
    ( ) Islamabad Heatwave (MEDIUM)
        "2 signal types • ~45 seconds to detection"
    ( ) California Wildfire (CRITICAL) — Global
        "4 signal types • ~75 seconds to detection"
    ( ) Istanbul Earthquake (HIGH) — Global
        "3 signal types • ~60 seconds to detection"

  [ "Start Simulation" button — full width ]
    Disabled until scenario selected.
    On tap: 
      Sends request to simulation_replay Cloud Function
      Sheet closes
      Map comes to focus
      Status bar mode pill updates to SIMULATED (pulsing)
      "Simulation starting..." snackbar appears at bottom

[ "Switch back to Live" link — bottom, visible in SIMULATED mode ]
[ Cancel / close handle ]
```

**If simulation already in progress:**
```
[ "Simulation in progress: Lahore Flash Flood" ]
[ Progress indicator ]
[ "Stop Simulation" button ]
```

---

### S12 More Menu

**Route:** /more

**This screen is the secondary navigation hub. Anything not in the bottom nav lives here.**

**Header:**
```
[ "More" title ]
```

**Body — list of destinations:**

```
[ List item: Report a Crisis ]
  Subtitle: "Submit a manual crisis signal"
  → navigates to /report

[ List item: Disaster Directory ]
  Subtitle: "Browse all detected crises"
  → opens a full-screen list of crisis_events
  (same as the bottom sheet pill list expanded — filterable by severity, type, city)

[ List item: Analytics ]
  Subtitle: "Historical crisis intelligence"
  → navigates to /analytics

[ List item: Notifications ]
  Subtitle: "Alert history"  +  unread count badge
  → navigates to /notifications

[ List item: Settings & System Health ]
  Subtitle: "Mode, source status, configuration"
  → navigates to /settings

[ List item: About CIRO ]
  Subtitle: "Hackathon info, artifact links"
  → opens a simple full-screen about page
    Contains: app description, hackathon details, team info,
              link to artifacts bucket, link to antigravity traces
```

**Disaster Directory (accessible from More):**

This is not a separate route — it's a full-screen push from the More list item.

```
Header:
  [ Back arrow ]  [ "Active Crises" title ]  [ Filter icon ]
  [ Global / Pakistan Toggle ]

Filter row (horizontal scroll):
  Severity: All | CRITICAL | HIGH | MEDIUM
  Type: All | Flood | Fire | Accident | ...

Pakistan mode — City dropdown:
  All Cities | Lahore | Karachi | Islamabad | Rawalpindi | 
  Peshawar | Quetta | Faisalabad | Multan | Gujranwala

Global mode — Country dropdown:
  All Countries | Pakistan | USA | Turkey | ...

Crisis Tile:
  [ Crisis type icon ]
  [ Crisis type label ]  [ Severity badge ]
  [ City, District ]
  [ Confidence bar ]  NN%
  [ "N signals" ]  [ Status badge ]
  [ "View Details" button ] → /crisis/:crisis_id

Sort options (top-right filter icon):
  Most Recent | Highest Confidence | Most Signals | Severity
```

---

## 6. Interaction Flows

### Flow 1 — First-Time User
```
Install APK
→ Onboarding S1 (4 slides, skippable)
→ Map S2 — Global view
→ User sees international pre-seeded pins
→ Taps California pin → S3 Detail Sheet opens
→ Taps "Full Details" → S4 Deep Dive
→ Scrolls to Agent Reasoning section → expands
→ Taps "View Full Trace" → S6 Agent Trace
→ Back → Back → Map
```

### Flow 2 — Pakistan Crisis Exploration
```
Map S2 — Global view
→ Tap Pakistan toggle → Pakistan view, camera animates
→ Tap Lahore pin → S3 Detail Sheet
→ Tap "Zoom to City" → camera to zoom 12, traffic layer visible, sheet collapses
→ Tap "Back to Pakistan View" chip → camera returns
→ Tap "N Signals" pill → sheet expands, signal list visible
→ Sees Roman Urdu raw text with ROMAN URDU language chip
→ Tap "Full Details" → S4 Deep Dive
→ Scrolls through Impact, Before/After, Signals, Actions
```

### Flow 3 — Simulation Mode (Primary Demo Flow)
```
Status bar → tap LIVE SIGNALS pill → S11 Simulation Bottom Sheet opens
→ Select "Lahore Flash Flood" radio
→ "Start Simulation" → sheet closes → map comes to focus
→ "Simulation starting..." snackbar appears
→ Navigate to Feed tab (S5 Signal Feed)
→ Signals arrive one by one, prepending to top:
    Weather signal (rainfall spike)  — 0s
    Bluesky Roman Urdu post           — 45s
    Second Bluesky post               — 90s  ← confidence crosses 45 at this point
    Traffic congestion spike          — 120s
    Geo News RSS article              — 150s
→ At ~90s: map pin drops on Lahore (CRITICAL, red, pulse animation)
→ FCM push notification arrives on device notification shade
→ Tap notification → deep link to /crisis/:crisis_id (S4)
→ S4 shows full crisis detail with RESPONDING status
→ Scroll to Actions → "ALERT BROADCAST: SENT" with FCM message ID
→ Scroll to Before/After → numbers visible (45 min → 12 min delay)
→ Tap "View Full Trace" → S6 Agent Trace
→ 4-node graph, tap Agent 2 node → confidence breakdown visible
→ Toggle "Show Raw JSON" → raw Cloud Workflows payload
```

### Flow 4 — Agent Trace Exploration (Judge Validation)
```
Bottom nav → Trace tab → S6 Agent Trace
→ Default: most recent crisis trace shown
→ Tap crisis selector dropdown → pick a specific crisis
→ Graph shows 4 nodes
→ Tap Agent 2 node → detail card expands
→ See: input (7 signals, 3 source types), output (confidence 94, CRITICAL)
→ See: reasoning text ("7 signals clustered around Gulberg...")
→ See: confidence breakdown (base 65, geo +22, temporal +18, diversity +18, media +15)
→ Toggle "Show Raw JSON" → raw Cloud Workflows execution JSON
→ Scroll down to timeline bar → see total pipeline duration
```

### Flow 5 — Report Disaster
```
Map S2 → FAB (+ button)
→ S8 Report Disaster
→ Type description in any language
→ Select crisis type (optional)
→ "Use My GPS Location" → location detected
→ Attach photo (optional)
→ Submit
→ Loading overlay: "Sending to CIRO Intelligence Layer..."
→ Success overlay: "Signal received. Agent 1 is analyzing..."
→ Auto-navigate to /map after 3 seconds
→ If detection threshold reached: pin drops, notification arrives
```

### Flow 6 — Analytics Query
```
More tab → Analytics → S7 Analytics
→ Tap example chip: "Floods in Karachi this week"
→ Chip fills input and auto-submits
→ Loading: inline spinner in query result card
→ Result: "3 flood events detected in Karachi in the last 7 days"
→ "Show Generated SQL" toggle → SQL visible
→ Scroll down to dashboard cards
→ See by-type breakdown, top cities, signal source distribution
```

---

## 7. Challenge 3 Compliance Checklist

Every requirement from the challenge PDF mapped to a specific screen and UI element.

```
REQUIREMENT                          SCREEN          UI ELEMENT
─────────────────────────────────────────────────────────────────────────
Multi-source input processing        S5 Feed         Signal cards with source chips
                                     S4 Deep Dive    Contributing Signals section
                                     S10 Settings    Source Health section

Event detection visible              S2 Map          Pin drop animation on detection
                                     S3 Detail Sheet Confidence bar + severity badge

Confidence level + explanation       S3 Detail Sheet Confidence bar + percentage
                                     S4 Deep Dive    Confidence breakdown in Agent Reasoning
                                     S6 Trace        Agent 2 node detail card

Reasoning & situation analysis       S4 Deep Dive    Agent Reasoning Timeline section
                                     S6 Trace        Full agent trace with reasoning text

Impact analysis                      S4 Deep Dive    Impact Analysis card (Section B)
                                     S3 Detail Sheet Impact Summary block

Action planning                      S4 Deep Dive    Response Actions section (Section E)
                                     S6 Trace        Agent 3 node detail

Action simulation (critical)         S4 Deep Dive    Action status chips: SIMULATED / SENT
                                     S9 Notif        FCM notification received + message ID
                                     S2 Map          Route polylines (ROUTE_REDIRECT)

Before vs after state                S4 Deep Dive    Before/After System State card (Section C)
                                     S3 Detail Sheet Rescue ETA before/after in impact block

Outcome visualization                S4 Deep Dive    Quantified before/after metrics
                                     S2 Map          Route polylines before/after

System logs / agent trace            S6 Trace        Full interactive node graph + JSON
                                     S4 Deep Dive    Agent Reasoning Timeline

Agentic workflow visible             S6 Trace        Node graph with feedback loop arrows
                                     S4 Deep Dive    Timeline showing A1→A2→A3→A4 sequence

Multi-source ingestion proof         S5 Feed         Source chips on each signal card
                                     S10 Settings    Source health with last poll timestamps

Handling noisy informal language     S5 Feed         ROMAN URDU language chip on signal cards
                                     S4 Deep Dive    Raw text in original language displayed

Simulated APIs documented            S5 Feed         SIM chip on simulated signals
                                     S10 Settings    Source health: Live vs Simulated label
                                     S2 Map          Status bar mode pill

End-to-end workflow                  Flow 3          Simulation mode interaction flow
                                     S2 Map → S5 Feed → S4 Deep Dive → S6 Trace path
```

---

### S13 Volunteer Alert

**Trigger:** Tap on a volunteer dispatch notification (simulated from Agent 3 action).

**Component:** Full Screen Alert

**Header:**
```
[ Close button (X) ]
```

**Body:**
```
[ Large Alert Icon / Beacon ]
[ "URGENT HELP NEEDED" text in red/bold ]

[ Crisis Title: e.g. "Flash Flood in Gulberg" ]
[ Distance/ETA: "1.2 km away • ~4 mins" ]

[ Crisis Description / Instructions from Agent 3 ]
"We need 3 volunteers to assist with traffic redirection at MM Alam Road intersection. Please confirm if you can deploy immediately."

[ Map Preview snippet showing user location vs crisis location ]

[ Accept Button (Green/Teal): "I CAN HELP" ]
[ Decline Button (Outlined/Gray): "DECLINE" ]
```

---

### S14 Dispatch Command Center

**Route:** /dispatch

**Header:**
```
[ Back arrow ]  [ "Dispatch & Response Command" title ]
```

**Body:**
```
[ Section: "Active Operations" ]
[ Crisis Title: e.g. "Flash Flood - Gulberg" ]
[ Severity Badge: CRITICAL ]

[ Agent Assessment Text ]
"Requires Heavy Water Extraction & Traffic Control. Alerting 3 services based on severity."

[ Section: "Dispatched Services" ]
  [ Card 1 ]
    Icon: 🚓 Traffic Police
    Status: Alerted - Rerouting MM Alam Road
    ETA: 5 mins

  [ Card 2 ]
    Icon: 🚒 Rescue 1122
    Status: Dispatched - Heavy duty pumps
    ETA: 12 mins

  [ Card 3 ]
    Icon: 🚑 Edhi Ambulance
    Status: Standby nearby
    ETA: N/A

[ Mini-map ]
Shows live location of responding units converging on the crisis pin.
```

---

*Design Spec version: 1.2*
*No colors, typography, or theme defined — styling handled in Figma*
*Author: Daniyal Jamil | CIRO — AISeekho Antigravity Hackathon 2026*
