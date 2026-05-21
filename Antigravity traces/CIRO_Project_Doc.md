# CIRO — Crisis Intelligence & Response Orchestrator
### Comprehensive Project Document
**Google Antigravity Hackathon 2026 | Challenge 3 | #AISeekho2026**
**Team: Daniyal Jamil | Bahria University Lahore Campus**

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Core Philosophy](#2-core-philosophy)
3. [System Architecture](#3-system-architecture)
4. [Signal Sources & Ingestion](#4-signal-sources--ingestion)
5. [Language Handling Strategy](#5-language-handling-strategy)
6. [Confidence Scoring Engine](#6-confidence-scoring-engine)
7. [Agent Pipeline — Deep Dive](#7-agent-pipeline--deep-dive)
8. [Data Layer](#8-data-layer)
9. [Maps & Geospatial Layer](#9-maps--geospatial-layer)
10. [Flutter App — Frontend](#10-flutter-app--frontend)
11. [Simulation Mode](#11-simulation-mode)
12. [Infrastructure & DevOps](#12-infrastructure--devops)
13. [Development Environment — Antigravity](#13-development-environment--antigravity)
14. [Submission Artifacts Strategy](#14-submission-artifacts-strategy)
15. [Demo Scenarios](#15-demo-scenarios)
16. [Assumptions](#16-assumptions)
17. [Evaluation Criteria Mapping](#17-evaluation-criteria-mapping)
18. [Full Tech Stack Reference](#18-full-tech-stack-reference)

---

## 1. Project Overview

CIRO is a real-time, multi-agent crisis intelligence system that monitors the global and Pakistani urban environment for emerging disasters. It continuously ingests signals from social media platforms, news RSS feeds, video platforms, weather APIs, traffic APIs, and official meteorological sources. When enough corroborating signals cluster around a location, the system autonomously detects a crisis, scores its severity and impact, generates a coordinated response plan, and simulates execution of those responses — all visible in real time on an interactive world map inside a Flutter Android app.

CIRO is not a reporting dashboard. It is an autonomous decision-making system. Signals flow in, agents reason, crises appear on the map, responses execute — without a single button press from an operator.

The system has two operating modes: LIVE (real signal pollers running against real APIs) and SIMULATED (pre-scripted signal sequences replayed through the identical pipeline). Both modes are available in the Flutter app via a persistent status bar. The agent pipeline is completely identical in both modes — only the signal origin differs.

**Primary geography:** Global map view with a Pakistan-specific filtered view as the primary demo focus.

**Mandatory platform:** Built entirely inside Google Antigravity IDE, deployed on Google Cloud, using Vertex AI Agent Builder for core agent orchestration.

---

## 2. Core Philosophy

**Signals before reports.** CIRO detects crises from informal, unstructured, multilingual social signals before any official body knows something is wrong. A cluster of Roman Urdu posts saying "G-10 mein pani bhar gaya" combined with a weather API rainfall spike and a traffic congestion anomaly is enough to detect an urban flood with high confidence — minutes before any official advisory.

**Confidence over certainty.** Every crisis event carries a confidence score derived from the volume, diversity, recency, and geographic clustering of its contributing signals. A single tweet is a weak signal. Five posts from the same district, a news article, a weather threshold breach, and a traffic congestion spike in the same 30-minute window is a strong one. The system never claims certainty — it reasons from evidence.

**Semantic understanding over keyword matching.** CIRO does not keyword-match for the word "flood." It uses Gemini 1.5 Pro to semantically reason about what informal posts actually mean in context — cultural idioms, sarcasm, understatement, mixed-script text. Signals are embedded as semantic vectors and clustered by meaning, not by shared keywords. "Boat chahiye Lahore mein" clusters with flood signals because semantically it describes the same situation.

**Show the reasoning.** Every decision CIRO makes is traceable. The agent pipeline produces structured logs at every step — what signals were received, how they were clustered, what confidence was assigned, what actions were planned, what was simulated. Judges and operators can follow the chain from raw Urdu post to emergency dispatch ticket.

**Real when possible, simulated when not.** Real APIs are used wherever accessible. When a real API is unavailable, rate-limited, or returns no data, the system falls back to a simulated equivalent with the same schema — silently, without breaking the pipeline. The Flutter UI always shows which sources are live and which are simulated.

**Global reach, local focus.** The system runs globally. Pakistani cities are covered with higher polling granularity and the signal sources include Pakistan-specific outlets. A dedicated Pakistan view surfaces city-level detail.

---

## 3. System Architecture

CIRO has six layers, each independently deployable with a single clear responsibility.

```
┌─────────────────────────────────────────────────────────────────────┐
│  SIGNAL LAYER                                                       │
│  Bluesky · YouTube · RSS · OpenWeatherMap · PMD · Traffic · Manual  │
└───────────────────────────┬─────────────────────────────────────────┘
                            │ raw multilingual signals
┌───────────────────────────▼─────────────────────────────────────────┐
│  LANGUAGE HANDLING LAYER                                            │
│  Language detection → route by type:                                │
│  Roman Urdu / English → raw directly to Agent 1 (Gemini native)    │
│  Formal Urdu / Arabic / Other → Cloud Translation NMT → both sent  │
└───────────────────────────┬─────────────────────────────────────────┘
                            │ language-handled signal objects
┌───────────────────────────▼─────────────────────────────────────────┐
│  INTELLIGENCE LAYER                                                 │
│  Vertex AI Agent Builder + Cloud Workflows                          │
│  Agent 1: Signal Extraction (with conditional re-extraction loop)   │
│  Agent 2: Crisis Detection, Confidence Scoring & Impact Analysis    │
│  Agent 3: Response Planning (with severity recheck loop)            │
│  Agent 4: Action Simulation & Execution (with replanning loop)      │
│  Post-detection: Gemini Search Grounding for confidence enrichment  │
└───────────────────────────┬─────────────────────────────────────────┘
                            │ crisis events + action logs
┌───────────────────────────▼─────────────────────────────────────────┐
│  DATA LAYER                                                         │
│  Firestore (live state) · BigQuery (historical) · Cloud Storage     │
└───────────────────────────┬─────────────────────────────────────────┘
                            │ real-time streams + queries
┌───────────────────────────▼─────────────────────────────────────────┐
│  PRESENTATION LAYER                                                 │
│  Flutter Android App                                                │
│  Global map · Pakistan filter · Crisis detail · Dispatch center     │
│  Live/Simulated mode toggle · Signal health dashboard               │
└─────────────────────────────────────────────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────────────────┐
│  EVENT ROUTING LAYER (cross-cutting)                                │
│  Pub/Sub topics · Eventarc Advanced · Cloud Scheduler               │
└─────────────────────────────────────────────────────────────────────┘
```

### End-to-end event flow

1. Cloud Scheduler fires every 5–30 minutes (per-source cadence), triggering signal poller Cloud Functions.
2. Each poller fetches new data from its source, publishes raw signal messages to its dedicated Pub/Sub topic.
3. Eventarc Advanced listens on all topics. Filters non-disaster-adjacent messages before they reach the agent pipeline. Routes valid signals to Cloud Workflows.
4. Cloud Workflows executes the agent pipeline — Agent 1 → Agent 2 → Agent 3 → Agent 4 — as a structured, traceable workflow with conditional feedback loops between agents.
5. Agent 2 writes a crisis event document to Firestore the moment confidence crosses the detection threshold (45).
6. Firestore real-time listener in the Flutter app fires. Map pin drops on the globe instantly.
7. Agents 3 and 4 continue. Each action executed by Agent 4 appends to the Firestore document and triggers an FCM push notification.
8. Post-detection: Gemini Search Grounding enriches the crisis confidence by searching for corroborating web evidence.
9. All events, signals, and agent outputs stream to BigQuery for historical analytics.
10. Confidence decay scheduler runs hourly, transitioning stale crises to RESOLVING and RESOLVED.

---

## 4. Signal Sources & Ingestion

All signal sources publish to Pub/Sub topics using a consistent raw signal schema. Every poller has a real implementation and a simulated fallback with an identical output schema. The pipeline cannot distinguish between them — only the `is_simulated` flag in the signal document differs.

### 4.1 Bluesky (AT Protocol)

**Access:** Fully public, no authentication. Endpoint: `https://public.api.bsky.app`

**Polling cadence:** Every 5 minutes.

**Method:** `app.bsky.feed.searchPosts` with rotating disaster keywords across English, Urdu, Roman Urdu, Arabic, and Spanish. Keywords include: flood, selab, pani, baarish, earthquake, zalzala, fire, aag, haadsa, toofan, landslide, inundation, cyclone, wildfire, and their common transliterations and misspellings.

**Signal value:** Medium. High volume, unverified. Geographic clustering of posts significantly increases confidence.

**Extracted fields:** post_id, author handle, full raw_text, timestamp, like_count, repost_count, reply_count, detected_language.

**Simulated fallback:** A Cloud Storage JSON file with 30 realistic pre-written posts in Roman Urdu, English, and Arabic covering the 5 demo scenarios. Rotated into the pipeline on demand.

**Pub/Sub topic:** `social-signals`

### 4.2 YouTube Data API v3

**Access:** Free. 10,000 units/day. Search = 100 units. Implementation uses 5–10 searches per poll.

**Polling cadence:** Every 30 minutes. (Every 5 minutes exceeds daily quota — 288 polls × 1 search = 288 units/day baseline which is fine, but rotating keyword sets at 5–10 searches per poll at 30 min cadence = 240–480 units/day, well within 10,000.)

**Method:** Search videos published in the last 2 hours using disaster keywords. Pull title, description, tags, view_count, like_count, channel_subscriber_count, location metadata (if set by uploader), and published_at. View velocity (views per hour since upload) is calculated and factored into confidence scoring.

**Signal value:** High. A video titled "massive flood in Karachi right now" with 50,000 views in 90 minutes is one of the strongest possible confidence signals.

**Stretch goal — Gemini video analysis:** For videos over 10,000 views and under 10 minutes, Agent 1 can optionally pass the YouTube URL to Gemini 1.5 Pro's multimodal endpoint for visual content analysis: "Does this video show a real disaster? What type? What location clues are visible? How severe?" Disabled by default due to latency and token cost. Enabled selectively for the demo.

**Extracted fields:** video_id, title, description, tags, view_count, view_velocity, subscriber_count, location (if set), published_at.

**Simulated fallback:** Pre-formatted JSON mimicking YouTube API responses for demo scenario videos.

**Pub/Sub topic:** `media-signals`

### 4.3 RSS Feeds — News Sources

**Access:** Free. Public RSS endpoints, no auth.

**Polling cadence:** Every 5 minutes.

**Pakistani sources (primary):**
- Dawn News, Geo News, ARY News, The News International

**International sources:**
- BBC World News, Reuters, AP News, Al Jazeera

**Method:** Poll all RSS endpoints. Parse headline, summary, publication time, source name. Filter articles containing disaster keywords. Assign source credibility tier (1 = official/government, 2 = major national news, 3 = international wire, 4 = regional/blog).

**Signal value:** High to Very High. A Dawn headline about Balochistan floods is near-certain. An AP wire about a California wildfire is definitive.

**Extracted fields:** source_name, credibility_tier, headline, summary, published_at, url.

**Simulated fallback:** Static JSON with realistic RSS-formatted headlines for each demo scenario.

**Pub/Sub topic:** `news-signals`

### 4.4 OpenWeatherMap API

**Access:** Free tier — 1,000 calls/day.

**Polling cadence:** Every 10 minutes across 50 monitored cities (20 Pakistani + 30 international).

**Threshold triggers:**
- Rainfall > 30mm/hr → FLOOD precursor signal
- Rainfall > 60mm/hr → FLOOD strong signal
- Temperature > 44°C → HEATWAVE signal
- Wind > 100km/h → STORM signal
- Any native OWM alert → HIGH credibility signal (+30)

**Extracted fields:** city, rainfall_mm_hr, temperature_c, wind_kmh, weather_condition_code, active_alerts, timestamp.

**Simulated fallback:** Cloud Function returns pre-scripted weather readings matching demo scenario conditions.

**Pub/Sub topic:** `weather-signals`

### 4.5 Pakistan Meteorological Department (PMD)

**Access:** Public website, scraped with BeautifulSoup.

**Polling cadence:** Every 15 minutes.

**Method:** Scrape PMD's public advisory page for active weather warnings, rainfall alerts, and flood advisories. PMD signals carry the highest credibility weight — an official PMD flood warning for Sindh alone pushes a crisis past the detection threshold.

**Resilience:** PMD scraping is inherently brittle. If the live scrape fails for any reason (site down, HTML structure changed, timeout), the poller immediately falls back to `simulated_pmd_feed` — a Cloud Storage JSON file with realistic PMD-style advisories for 5 Pakistani provinces, manually updated before the demo. The Flutter UI shows a "PMD: Simulated" indicator when fallback is active.

**Signal value:** Very High. Official government source.

**Pub/Sub topic:** `official-signals`

### 4.6 Traffic Signal Source — Google Maps Routes API + Simulated Fallback

**This source is explicitly required by Challenge 3** — the PDF states "Accept: simulated APIs (weather, traffic)" and the example scenario lists "Maps: traffic congestion spike" as a required input.

**Real implementation — Google Maps Routes API:**
The Routes API returns `duration` (free-flow travel time) and `duration_in_traffic` (current travel time) for a given route. The congestion ratio = duration_in_traffic / duration. A ratio above 2.5x baseline on a monitored corridor constitutes a traffic anomaly signal.

Monitored corridors per city: 3–5 major arterial roads. For Lahore: Canal Road, MM Alam Road, Ferozepur Road, Mall Road, Jail Road. For Karachi: Shahrah-e-Faisal, M.A. Jinnah Road, University Road. Similarly for Islamabad, Rawalpindi, Peshawar, Karachi, and 15 international cities.

**Polling cadence:** Every 10 minutes.

**Congestion signal thresholds:**
- Congestion ratio 2.0–2.5x → mild anomaly, low signal weight
- Congestion ratio 2.5–4.0x → HIGH congestion signal (+18)
- Congestion ratio > 4.0x → CRITICAL congestion signal (+28)
- Sudden congestion spike (ratio doubled in < 10 min) → +12 temporal bonus

**Simulated fallback — `simulated_traffic_api`:**
A Cloud Function that returns pre-scripted congestion readings for demo corridors, formatted identically to Routes API responses. In simulated mode this is what the demo scenarios use — Canal Road suddenly goes from 1.1x to 4.2x congestion ratio, matching the Lahore flood scenario timing.

**Visual output in Flutter:** The map renders Google Maps traffic layer (the familiar red/yellow/green road coloring) overlaid on the crisis map. When a traffic congestion signal contributes to a crisis, the specific congested corridors are highlighted and labeled in the Flutter detail sheet.

**Pub/Sub topic:** `traffic-signals`

### 4.7 Manual Report (Flutter App)

**Access:** In-app feature. Any user submits a crisis report.

**Input:** Free-text description (any language), optional photo upload, auto-detected GPS location, optional crisis type hint selector.

**Method:** Direct HTTP POST to Cloud Run. Bypasses Pub/Sub, goes straight to Agent 1 with `source_type: MANUAL_REPORT`. GPS-verified location is treated as HIGH location confidence regardless of text quality.

**Signal value:** Medium-High. GPS verification is valuable. Description quality varies.

**Pub/Sub topic:** N/A — direct to Agent 1.

### 4.8 Post-Detection: Gemini Search Grounding

This is not a pre-detection poller. It runs after Agent 2 creates a crisis event, to enrich confidence with current web evidence.

Once a crisis event exists in Firestore, a Cloud Function calls Vertex AI Gemini with Google Search grounding enabled. Query: "[city] [event_type] [today's date]" — e.g. "Lahore flood May 2026". Gemini returns grounded results from current indexed web pages including news sites, social media embeds, and local blogs. Each result that corroborates the crisis adds +15 to confidence (up to a maximum of +30 from this source, i.e. 2 corroborating results).

This runs once per crisis event, 2 minutes after initial detection. It's a one-time enrichment step, not a continuous poller.

**Pub/Sub topic:** N/A — writes directly to the Firestore crisis document.

---

## 5. Language Handling Strategy

CIRO receives signals in many languages. The handling strategy differs by language type because NMT translation quality varies dramatically across informal vs formal text.

### 5.1 Language Detection (Universal First Step)

Every signal passes through Cloud Translation's language detection API before any other processing. Detection is a single cheap API call (~10ms, ~$0.000001 per call) that returns the detected language code and a confidence score. No translation happens at this step — detection only.

### 5.2 Roman Urdu and English — Direct to Gemini

Roman Urdu is transliterated Urdu written in Latin script ("paani bhar gaya", "scene kharab hai", "halaat theek nahi"). NMT models are trained on formal parallel text corpora where Roman Urdu barely exists. Sending Roman Urdu through Cloud Translation NMT produces unreliable, often meaningless output that would corrupt Agent 1's extraction.

Gemini 1.5 Pro has seen massive amounts of Roman Urdu in its training data. It genuinely understands Pakistani internet language natively — idioms, sarcasm, understatement, mixed-script mid-sentence switches.

**Roman Urdu path:** raw_text sent directly to Agent 1. No translation. Agent 1's prompt explicitly acknowledges the language: "This is a Roman Urdu social media post — informal Pakistani internet language. Reason semantically about what the person is actually describing, considering cultural context, idioms, and informal expressions. Do not treat this as a literal formal statement."

**English path:** raw_text sent directly to Agent 1. Standard processing.

### 5.3 Formal Urdu, Arabic, and Other Languages — NMT + Both Sent

Formal Urdu (written in Nastaliq script), Arabic, French, Spanish, Turkish, and other languages are handled well by Cloud Translation NMT because formal parallel corpora exist for these languages.

**Formal Urdu / Arabic / Other path:**
1. Cloud Translation NMT produces normalized_text (English translation)
2. Both raw_text AND normalized_text are sent to Agent 1
3. Agent 1's prompt explicitly states: "A translation is provided but treat the original text as ground truth. The translation may have lost nuance. Use both to reason about what the post describes."

NMT is used here as a comprehension aid, not as the primary input. Gemini can cross-reference between the two and catch cases where the translation lost meaning.

### 5.4 Storage

Both fields are always stored in Firestore:
```
raw_text:         "G-10 mein pani bhar gaya hai, gaariyan phans gayi hain"
normalized_text:  "Water has filled up in G-10, cars are stuck"   (null if Roman Urdu/English)
source_language:  "roman_urdu"
translation_used: false
```

`raw_text` is what the Flutter UI displays in the Contributing Signals section — judges see authentic multilingual content. `normalized_text` is used internally by agents and is never surfaced as the primary display text.

### 5.5 Semantic Embedding (Universal)

Regardless of language path, every signal that passes Agent 1 extraction gets embedded using **Vertex AI Text Embeddings API** (`text-embedding-004`). The embedding is computed on the normalized_text if available, otherwise on raw_text.

The embedding vector is stored in the Firestore signal document. Agent 2 uses cosine similarity between signal embeddings as the primary clustering mechanism — not keyword matching on event_type. This means:

- "paani bhar gaya" and "street completely underwater" and "boat chahiye ab toh" cluster together despite sharing zero keywords, because their semantic embeddings are close.
- "doob gaya exam mein" (failed an exam) does NOT cluster with flood signals despite containing "doob gaya" (drowned), because its embedding is semantically distant.
- Vague posts like "bhai bahar mat nikalna aaj" (don't go outside today) cluster correctly with nearby flood signals because their embeddings align in the context of the other signals in the cluster.

event_type extracted by Agent 1 is used as a secondary grouping signal to separate different crisis types in the same geographic area.

---

## 6. Confidence Scoring Engine

The confidence scoring engine runs inside Agent 2. It determines whether a signal cluster constitutes a real crisis and how severe that crisis is.

### 6.1 Base Signal Scores

```
Official government advisory (PMD, NDMA)        → +40
PMD simulated fallback advisory                 → +35
Major Pakistani news RSS (Dawn, Geo, ARY)        → +28
International news RSS (BBC, Reuters, AP)        → +25
YouTube video — 100k+ views                     → +35
YouTube video — 10k+ views                      → +25
YouTube video — any                             → +15
YouTube view velocity > 5,000 views/hour        → +10 (additive)
Gemini Search Grounding corroboration           → +15 (max +30, 2 results)
OpenWeatherMap native alert                     → +30
OpenWeatherMap threshold breach                 → +20
Traffic congestion spike > 4.0x baseline        → +28
Traffic congestion spike 2.5–4.0x              → +18
Bluesky social post                             → +10
Manual in-app report (GPS verified)             → +18
```

### 6.2 Geographic Clustering Bonus

```
2+ signals same country, same event type        → +5
3+ signals same city                            → +12
3+ signals same district / neighbourhood        → +22
5+ signals same district                        → +35
8+ signals same district                        → +50
```

### 6.3 Temporal Clustering Bonus

```
All signals within 60 minutes                   → +10
All signals within 30 minutes                   → +18
All signals within 15 minutes                   → +25
Signal frequency increasing over time           → +12
Sudden traffic spike (doubled in < 10 min)      → +12
```

### 6.4 Source Diversity Bonus

Multiple independent source types corroborating each other is far stronger than one source type with many signals:

```
2 different source types                        → +8
3 different source types                        → +18
4+ different source types                       → +28
```

### 6.5 Media Evidence Bonus

```
At least one YouTube video exists               → +15
Video has 10k+ views                            → +10 (additive)
Video has geographic location metadata          → +8 (additive)
```

### 6.6 Confidence Cap and Severity Mapping

```
CONFIDENCE CAP:          100
DETECTION THRESHOLD:     45+ → crisis event created in Firestore

SEVERITY:
  45–60   → MEDIUM    monitor, advisory issued
  61–80   → HIGH      active response, dispatch recommended
  81–100  → CRITICAL  immediate coordinated response, all actions triggered
```

### 6.7 Confidence Decay

An hourly Cloud Function (`decay_scheduler`) queries all crisis documents with `status != RESOLVED` and `updated_at < now - 1hr`. For each:
- Subtract 5 confidence points
- If confidence drops below 30 → update status to RESOLVING
- If confidence drops below 15 → update status to RESOLVED, set resolved_at timestamp

This prevents old, unconfirmed signals from keeping phantom crises alive indefinitely. A crisis with no new corroborating signals closes itself within 3–6 hours.

---

## 7. Agent Pipeline — Deep Dive

The agent pipeline runs on Vertex AI Agent Builder with Cloud Workflows as the step orchestrator. Each agent is a Gemini 1.5 Pro call with function calling enabled, wrapped in a Cloud Workflows step. The execution graph is visible in the Cloud Console and exported as a submission artifact.

The pipeline is not a rigid waterfall. Three conditional feedback loops enable genuine agent interaction — agents can return to previous steps, request rechecks, and trigger replanning.

### 7.1 Agent 1 — Signal Extraction

**Trigger:** Cloud Workflows step. Receives a language-handled signal object from Eventarc.

**Input:**
```json
{
  "signal_id": "uuid",
  "source_type": "bluesky | youtube | rss | weather | official | traffic | manual",
  "raw_text": "original text",
  "normalized_text": "english translation or null",
  "source_language": "roman_urdu | formal_urdu | arabic | english | other",
  "translation_used": false,
  "source_metadata": { "views": 0, "credibility_tier": 2 },
  "received_at": "ISO8601"
}
```

**Prompt strategy:** Chain-of-thought is explicitly requested. The prompt tells Gemini to reason step by step before producing its function call. Prompt varies by language:

For Roman Urdu: "This is a Roman Urdu social media post — informal Pakistani internet language. Consider cultural idioms, understatement, sarcasm, and informal expressions. What is the person actually describing? Is this a real situation?"

For formal Urdu/Arabic + translation: "A translation is provided but treat the original as ground truth. The translation may have lost nuance. Cross-reference both to understand the post."

For English: standard extraction prompt.

**What Agent 1 extracts (Step 1 — LLM call):**
```json
{
  "event_type": "FLOOD | FIRE | ROAD_BLOCKAGE | HEATWAVE | ACCIDENT | EARTHQUAKE | LANDSLIDE | STORM | INFRASTRUCTURE_FAILURE | UNKNOWN",
  "location_raw": "the location string as mentioned in text",
  "location_confidence": "HIGH | MEDIUM | LOW",
  "severity_indicators": ["phrases from the text suggesting severity"],
  "is_disaster_related": true,
  "extraction_confidence": 85
}
```

Note: lat/lng are NOT in the LLM output. The LLM does not generate coordinates.

**Step 2 — Geocoding API call (Cloud Function, not LLM):**
`location_raw` from Step 1 is passed to the Geocoding API. Returns lat, lng, geocoding_confidence. Handles informal Pakistani location names, landmarks, and road intersections. Falls back to city-level coordinates if district-level geocoding fails.

**Step 3 — Embed and store:**
Vertex AI Text Embeddings API generates the semantic embedding vector. Agent 1 output + Geocoding output + embedding vector are merged into one signal document written to `incoming_signals` subcollection.

**Conditional Loop 1 — Re-extraction on low location confidence:**
If `location_confidence == LOW` after Geocoding, Cloud Workflows sends the signal back to Agent 1 with an augmented prompt: "Your previous extraction had low location confidence. Re-examine the text carefully. Are there any implicit location clues — street names, landmarks, area codes, neighbourhood names, nearby named places?" Maximum 2 re-extraction attempts. If still LOW after 2 attempts, signal is stored with the LOW flag and Agent 2 attempts clustering by proximity to existing signals only.

**Discard path:**
If `is_disaster_related == false`, the signal is stored in `discarded_signals` with Agent 1's reasoning and the pipeline halts for this signal. No further agent calls.

---

### 7.2 Agent 2 — Crisis Detection, Confidence Scoring & Impact Analysis

**Trigger:** Called by Agent 1 after a valid signal is stored. Also runs on a 2-minute sweep for pending clusters.

**Input:** The newly stored signal + all signals from the last 2 hours within 50km sharing the same event_type OR within cosine similarity threshold of 0.75 (semantic clustering).

**Step 1 — Deduplication:**
Checks if a crisis event already exists for this location and event type within the last 6 hours. If yes, adds the new signal to the existing crisis's signals subcollection, recalculates confidence, and updates the crisis document. No duplicate events.

**Step 2 — Semantic clustering:**
Groups signals by cosine similarity on their embedding vectors (threshold: 0.75) AND geographic proximity (within 50km). event_type is a secondary grouping signal. This means semantically similar posts about the same situation cluster together even if Agent 1 extracted slightly different event_type values.

**Step 3 — Confidence calculation:**
Runs the full scoring engine (Section 6) against the cluster. Produces numeric confidence score and severity level.

**Step 4 — Impact analysis:**
Regardless of whether a crisis is created, Agent 2 generates an `impact_analysis` object for any cluster above confidence 35. This uses Gemini to estimate real-world consequences based on crisis type, severity, location, and a pre-seeded city population dataset:

```json
{
  "affected_population_estimate": 85000,
  "infrastructure_blocked": ["Canal Road", "Gulberg Main Boulevard"],
  "casualty_risk": "MEDIUM",
  "economic_impact_estimate": "PKR 3-7M per hour",
  "services_disrupted": ["road_access", "drainage", "electricity_risk"]
}
```

These numbers are LLM-estimated — not actuarial precision, but specific enough to be meaningful and displayable. They appear in the Flutter detail sheet as the Impact card.

**Step 5 — Decision:**
- confidence < 45: store in `pending_clusters`, wait for more signals. No crisis event.
- confidence ≥ 45, no existing crisis: create new crisis event document. Firestore write triggers Flutter map pin drop.
- confidence ≥ 45, existing crisis: update confidence, severity, and impact_analysis. Flutter UI updates pin colour if severity changed.

**Conditional Loop 2 — Severity recheck for borderline cases:**
If confidence is between 55–65 and Agent 3 is about to plan a HIGH-severity response, Cloud Workflows pauses Agent 3 and sends the cluster back to Agent 2 with the latest signals for a fresh evaluation. Agent 2 either confirms HIGH or downgrades to MEDIUM. This prevents a 3-unit emergency dispatch for what is actually minor waterlogging.

**Agent 2 reasoning log entry (written to crisis document):**
```json
{
  "agent": "crisis_detection",
  "timestamp": "ISO8601",
  "signals_evaluated": 7,
  "semantic_clustering_used": true,
  "confidence_breakdown": {
    "base_scores": 65,
    "geographic_bonus": 22,
    "temporal_bonus": 18,
    "source_diversity_bonus": 18,
    "media_bonus": 15,
    "total_raw": 138,
    "capped_at": 100
  },
  "decision": "CREATE_CRISIS_EVENT",
  "severity": "CRITICAL",
  "impact_analysis_generated": true
}
```

---

### 7.3 Agent 3 — Response Planning

**Trigger:** Fires after Agent 2 creates or updates a crisis to HIGH or CRITICAL severity. MEDIUM severity events receive an advisory only — no full Agent 3 planning.

**Input:** Full crisis event document including event_type, location, severity, confidence, and impact_analysis.

**What Agent 3 does:**
Calls Gemini 1.5 Pro with full crisis context. Generates exactly 3 coordinated response actions using function calling. Actions are selected based on crisis type and severity — not hardcoded. A FLOOD in a residential area gets different actions than a FIRE in an industrial zone.

**Action types:**

`ROUTE_REDIRECT` — for FLOOD, ROAD_BLOCKAGE, ACCIDENT, EARTHQUAKE. Specifies: affected road/area, recommended alternate route, reason. Agent 4 uses Directions API to render this on the map.

`EMERGENCY_DISPATCH` — for all CRITICAL events. Specifies: service type (ambulance / fire / rescue / police), unit count, target location, priority.

`ALERT_BROADCAST` — for all events above MEDIUM. Specifies: alert message in English and Urdu, target geographic radius (km), estimated affected population, broadcast channel (FCM / SMS simulation / radio simulation).

`RESOURCE_ALLOCATION` — for FLOOD, EARTHQUAKE, HEATWAVE. Specifies: resource type (evacuation buses / relief camps / water tankers / medical supplies), quantity, staging location.

`HOSPITAL_PREPAREDNESS` — for ACCIDENT, EARTHQUAKE, FIRE at CRITICAL severity. Specifies: hospital name (from pre-seeded city hospital list), alert level, expected casualty range.

**Conditional Loop 3 — Agent 4 replanning:**
If Agent 4 determines an action is unexecutable (no hospitals within 15km, no viable alternate route), it returns a `REPLAN_REQUIRED` flag to Agent 3 with the specific constraint. Agent 3 generates a replacement action. Maximum 1 replan per action per crisis event.

**Agent 3 reasoning log entry:**
```json
{
  "agent": "response_planning",
  "timestamp": "ISO8601",
  "crisis_type": "FLOOD",
  "severity": "CRITICAL",
  "location": "Gulberg, Lahore",
  "actions_selected": ["ROUTE_REDIRECT", "EMERGENCY_DISPATCH", "ALERT_BROADCAST"],
  "selection_reasoning": "Flood in dense urban area with vehicles stranded (from impact_analysis). Route redirect is highest priority to prevent further entrapment. Emergency rescue for stranded occupants. Alert broadcast to warn approaching commuters."
}
```

---

### 7.4 Agent 4 — Action Simulation & Execution

**Trigger:** Called by Agent 3 immediately after actions are planned.

**Input:** Three planned actions from Agent 3 plus full crisis event context including impact_analysis.

**Per action type — what Agent 4 simulates:**

**ROUTE_REDIRECT:**
Calls the Directions API for both the affected route and the alternate route. Writes a `route_status` document to Firestore:
```json
{
  "before": { "route": "Canal Road Lahore", "status": "OPEN", "avg_delay_min": 45, "vehicles_affected": 200 },
  "after":  { "route": "Canal Road Lahore", "status": "BLOCKED_FLOOD",
               "alternate": "Jail Road via Ferozepur Road", "status": "ACTIVE",
               "avg_delay_min": 12, "vehicles_affected": 0, "rescue_eta_min": 8 }
}
```
Flutter reads this and renders: red polyline on blocked route, green polyline on alternate route, before/after metric cards with specific numbers.

**EMERGENCY_DISPATCH:**
Creates a dispatch ticket in `emergency_tickets` Firestore collection:
```json
{
  "ticket_id": "TKT-2847",
  "crisis_id": "...",
  "service_type": "RESCUE",
  "unit_count": 3,
  "dispatch_location": "Gulberg Fire Station",
  "target_location": "Canal Road, Gulberg",
  "eta_minutes": 8,
  "status": "DISPATCHED",
  "created_at": "ISO8601"
}
```
Flutter reads these `emergency_tickets` and renders them in the **Dispatch Command Center** screen, proving the physical orchestration of the AI's plans.

**ALERT_BROADCAST:**
Calls Firebase Cloud Messaging Admin SDK. Sends a real push notification to the Flutter app with crisis type, location, alert message in English and Urdu, and severity colour. The notification physically arrives on the demo device during recording. Also writes a simulated SMS log and radio broadcast log to the crisis document.

**RESOURCE_ALLOCATION:**
Creates a `resource_deployment` document with resource type, quantity, staging location, target area, estimated arrival time.

**HOSPITAL_PREPAREDNESS:**
Creates a `hospital_alert` document with hospital name, alert level, preparation instructions, expected capacity needed.

**Quantified impact metrics (all action types):**
Agent 4 generates `impact_metrics` for before/after comparison. These are LLM-estimated but specific:
```json
{
  "before": { "avg_delay_minutes": 45, "vehicles_stranded": 200, "rescue_eta": null, "at_risk_population": 85000 },
  "after":  { "avg_delay_minutes": 12, "vehicles_stranded": 0, "rescue_eta_minutes": 8, "alerted_population": 50000 }
}
```
These render as before/after comparison cards in the Flutter detail sheet.

**Crisis document updates:**
- `status`: DETECTED → RESPONDING
- `actions_executed`: array of execution log objects
- `impact_metrics`: before/after quantified metrics
- `system_state_before`: human-readable summary
- `system_state_after`: human-readable summary

**Agent 4 reasoning log entry:**
```json
{
  "agent": "action_executor",
  "timestamp": "ISO8601",
  "actions_executed": 3,
  "replan_triggered": false,
  "execution_log": [
    { "action": "ROUTE_REDIRECT", "status": "SIMULATED", "firestore_doc": "route_status/lahore_canal_road" },
    { "action": "EMERGENCY_DISPATCH", "status": "SIMULATED", "ticket_id": "TKT-2847" },
    { "action": "ALERT_BROADCAST", "status": "SENT", "fcm_message_id": "fcm://..." }
  ],
  "state_before": "Canal Road open, 200 vehicles in flood zone, no units dispatched, no alerts sent",
  "state_after": "Canal Road blocked, traffic rerouted via Jail Road, 3 rescue units ETA 8 min, 50,000 users alerted"
}
```

---

### 7.5 Cloud Workflows Orchestration YAML (Skeleton)

```yaml
main:
  steps:
    - ingest_signal:
        call: agent1_extract
        args: { signal: ${signal_input} }
        result: extracted

    - check_extraction:
        switch:
          - condition: ${extracted.is_disaster_related == false}
            next: discard_signal
          - condition: ${extracted.location_confidence == "LOW"}
            next: reextract_signal

    - geocode:
        call: geocoding_api
        args: { location_raw: ${extracted.location_raw} }
        result: geocoded

    - embed_and_store:
        call: embed_signal
        args: { extracted: ${extracted}, geocoded: ${geocoded} }
        result: signal_stored

    - detect_crisis:
        call: agent2_detect
        args: { signal: ${signal_stored} }
        result: crisis

    - check_severity_borderline:
        switch:
          - condition: ${crisis.confidence >= 55 and crisis.confidence <= 65}
            next: severity_recheck
          - condition: ${crisis.severity == "MEDIUM"}
            next: issue_advisory
          - condition: ${crisis.severity in ["HIGH", "CRITICAL"]}
            next: plan_response

    - plan_response:
        call: agent3_plan
        args: { crisis: ${crisis} }
        result: planned_actions

    - execute_actions:
        call: agent4_execute
        args: { actions: ${planned_actions}, crisis: ${crisis} }
        result: execution_log

    - check_replan:
        switch:
          - condition: ${execution_log.replan_required == true}
            next: plan_response
          - condition: true
            next: stream_to_bigquery

    - stream_to_bigquery:
        call: bq_stream
        args: { crisis: ${crisis}, log: ${execution_log} }

    - post_detection_grounding:
        call: gemini_search_grounding
        args: { crisis_id: ${crisis.crisis_id} }

    - discard_signal:
        call: store_discarded
        args: { signal: ${extracted} }

    - reextract_signal:
        call: agent1_extract
        args: { signal: ${signal_input}, retry: true }
        result: extracted
        next: geocode
```

---

## 8. Data Layer

### 8.1 Cloud Firestore — Live State

Primary real-time database. Flutter holds an open snapshot listener on `crisis_events`. All agent writes propagate to the app in under 500ms.

**Collections:**

`crisis_events` — one document per active or recent crisis.

```
crisis_id              string
type                   string    FLOOD | FIRE | ROAD_BLOCKAGE | HEATWAVE | ACCIDENT |
                                 EARTHQUAKE | LANDSLIDE | STORM | INFRASTRUCTURE_FAILURE
city                   string
district               string
country                string    ISO code
lat                    float
lng                    float
severity               string    CRITICAL | HIGH | MEDIUM
confidence             int       0–100
status                 string    DETECTED | RESPONDING | RESOLVING | RESOLVED
signal_count           int       count of signals in subcollection (not array)
signal_source_summary  object    { bluesky: 3, rss: 1, weather: 1, traffic: 1 }
impact_analysis        object    affected_population, infrastructure_blocked,
                                 casualty_risk, economic_impact, services_disrupted
impact_metrics         object    before/after quantified metrics from Agent 4
agent_reasoning        array     reasoning trace entries from all 4 agents
actions_planned        array     Agent 3 output
actions_executed       array     Agent 4 simulation logs
route_changes          array     before/after route_status document refs
dispatch_tickets       array     emergency ticket IDs
broadcast_logs         array     FCM message IDs + simulated broadcast logs
system_state_before    string
system_state_after     string
created_at             timestamp
updated_at             timestamp
resolved_at            timestamp (nullable)
```

`crisis_events/{id}/signals` — **subcollection** (not embedded array). Prevents 1MB document limit. Parent document holds `signal_count` and `signal_source_summary` for quick display. Flutter lazy-loads the subcollection only when the user expands "Contributing Signals" in the detail sheet.

Signal document fields:
```
signal_id              string
source_type            string
raw_text               string    displayed in Flutter UI — original language
normalized_text        string    null if Roman Urdu or English
source_language        string
translation_used       boolean
embedding              array     float vector from Text Embeddings API
base_confidence_score  int
source_metadata        object
is_simulated           boolean
extracted_at           timestamp
```

`incoming_signals` — raw signals from Agent 1 before clustering. Useful for signal feed screen.
`pending_clusters` — clusters below detection threshold. Shows near-miss situations.
`emergency_tickets` — dispatch ticket documents.
`route_status` — one document per named corridor, updated by Agent 4.
`resource_deployments` — resource allocation documents.
`hospital_alerts` — hospital preparedness documents.
`discarded_signals` — filtered signals with Agent 1's rejection reasoning.

### 8.2 BigQuery — Historical Analytics

All Firestore crisis events and signals stream to BigQuery via Firestore's native BigQuery export extension. Enables:
- Historical crisis frequency by city, type, country, and time period
- Signal volume by source type over time
- Average confidence scores and response times
- A statistics panel in the Flutter Analytics Screen

Gemini can answer natural language queries against BigQuery: "How many flood events in Karachi this month?" → Gemini generates SQL → BigQuery executes → result displayed in app.

### 8.3 Cloud Storage

Bucket: `gs://ciro-hackathon-2026-artifacts`

```
/antigravity-artifacts/    all Antigravity plan, trace, walkthrough exports
/signal-media/             photos from manual reports
/demo-scenarios/           pre-scripted signal sequence JSON files
/simulated-feeds/          simulated_pmd_feed.json, simulated_traffic.json, etc.
/exports/                  BigQuery export CSVs for submission
```

---

## 9. Maps & Geospatial Layer

### 9.1 Google Maps SDK for Android

The hero UI. Crisis events render as custom BitmapDescriptor markers color-coded by severity:
```
CRITICAL → Red pin with pulse animation
HIGH     → Orange pin
MEDIUM   → Yellow pin
RESOLVING→ Yellow pin fading
RESOLVED → Green pin, fades out after 30 seconds
```

**Global view:** centered on (20°N, 0°E), zoom 2.5. All active global crises. Default on app open.

**Pakistan view:** Dedicated button — zooms and filters to Pakistan (30°N, 70°E, zoom 5.5). Higher pin density, city-level granularity.

**Traffic layer:** Google Maps traffic overlay (red/yellow/green road coloring) is rendered on the map at all times, giving real-time visual context for congestion signals. When a traffic signal contributes to a crisis, the specific congested corridor is labeled.

### 9.2 Directions API

When Agent 4 executes ROUTE_REDIRECT, Flutter calls the Directions API for both the affected route and the alternate. Renders: red polyline on blocked route, green polyline on alternate. Text overlays: "Canal Road — BLOCKED (Flood)" and "Use: Jail Road via Ferozepur Road". This is the most visually compelling before/after in the demo.

### 9.3 Geocoding API

Called server-side in Agent 1's Step 2 (Cloud Function). Converts informal location strings to lat/lng. Handles Pakistani neighbourhood names, road intersections, and landmark references. Falls back to city-level if district fails.

### 9.4 Routes API (Traffic Signals)

Polled every 10 minutes for monitored road corridors. Returns duration vs duration_in_traffic. Congestion ratio triggers traffic signals into the Pub/Sub pipeline. The same API call that generates the signal also provides the baseline travel time used in Agent 4's before/after impact_metrics.

---

## 10. Flutter App — Frontend

### 10.1 Screens

**Map Screen (primary)**
The interactive crisis map. Persistent status bar at top with LIVE/SIMULATED mode toggle (see Section 11). Floating action button for manual crisis reporting. Crisis count badge. Bottom navigation: Global ↔ Pakistan. Traffic layer toggle.

**Crisis Detail Sheet**
DraggableScrollableSheet on map pin tap. Contains:
- Crisis type icon + severity badge
- Confidence score with visual progress bar
- Impact card: affected_population, infrastructure_blocked, casualty_risk, economic_impact
- Before/After metric cards with numbers from impact_metrics
- Contributing Signals section (lazy-loaded from subcollection): each signal shows raw_text in original language, source icon, language tag badge (ROMAN URDU / ARABIC / ENGLISH etc.), timestamp, base_confidence_score contribution, and is_simulated flag
- Response Actions section: 3 actions with status indicators (PLANNED / EXECUTING / SIMULATED)
- Route visualisation: embedded mini-map showing blocked and alternate routes
- Agent Reasoning expandable: full agent_reasoning array, each entry formatted as a readable timeline

**Signal Feed Screen**
Reverse-chronological list of all incoming signals in the last 24 hours. Shows raw_text in original language, source icon, source_language badge, extracted event_type, whether it contributed to a crisis or was discarded, and is_simulated flag.

**Report Disaster Screen**
Manual signal submission. Features a full form for users to report a crisis from the field:
- **What Happened**: Multi-line text area for describing the incident in any language.
- **Crisis Type**: Horizontal chip selector (Flood, Fire, Accident, Road, Heatwave).
- **Location**: Two options - 'Use GPS' (auto-detects and displays coordinates/address) or 'Pick on Map' (opens a modal to place a pin).
- **Photo**: Optional camera/gallery attachment.
Submits directly to Agent 1 with a loading overlay ("Sending to CIRO Intelligence Layer...") and success state.

**Volunteer Alert Screen**
Full-screen emergency alert interface intended for registered volunteers/responders in proximity to a detected crisis. Displays:
- Bold urgent heading ("Urgent Help Needed")
- Crisis details (e.g., "Flash Flood in Gulberg")
- Distance and ETA to the incident
- Two large action buttons: "I can help" (Accept) or "Decline"
This screen simulates the end-user responder app experience triggered by Agent 3's planned actions.

**Analytics Screen**
BigQuery-powered statistics. Total crises by type, country, city. Signal volume by source. Average response times. Natural language query input powered by Gemini + BigQuery.

**Agent Trace Screen**
Judge-facing screen. Shows the Cloud Workflows execution graph for the most recent crisis event as an interactive node diagram. Each agent step is a tappable node showing full input, output, and reasoning trace. Exists to satisfy "Agent Trace / Logs" requirement interactively within the app itself.

### 10.2 Flutter Packages

```
google_maps_flutter       Maps SDK, custom markers, polylines, traffic layer
cloud_firestore           real-time snapshot listener on crisis_events
firebase_messaging        FCM push notification reception
flutter_riverpod          StreamProvider wrapping Firestore listener
dio                       HTTP client for Cloud Run API calls
google_fonts              typography
flutter_animate           pin drop animations, CRITICAL pulse effect
cached_network_image      source logos, signal media thumbnails
intl                      date/time formatting, locale-aware display
```

---

## 11. Simulation Mode

Simulation mode is a first-class feature — not a demo hack. It exists because live signal ingestion cannot be guaranteed to trigger a crisis event during a 5-minute demo window. It also makes the system demonstrable independently of real API availability.

### 11.1 Flutter Status Bar

A persistent status bar at the top of the Map Screen contains two pill buttons:

```
🟢 LIVE SIGNALS    |    ⚪ SIMULATED
```

**LIVE mode (green pill active):**
Real Cloud Scheduler pollers are running. The status bar shows source health indicators — one icon per signal source (Bluesky, YouTube, RSS, Weather, Traffic, PMD). Each icon has a dot: green = successfully polled in last 10 minutes, yellow = stale (>10 min since last poll), red = poller error. Tapping a source icon shows its last poll timestamp and result count. This is the signal health dashboard — judges can see in real time which sources are feeding data.

**SIMULATED mode (white pill active):**
Tapping opens a bottom sheet with a scenario selector and a "Start Simulation" button. Selecting a scenario and pressing start triggers a Cloud Function that replays a pre-scripted signal sequence from Cloud Storage. Signals arrive one by one into the Pub/Sub pipeline with realistic time delays between them — exactly as if they were coming from real sources. The full agent pipeline (Agent 1 → 2 → 3 → 4) runs identically. The map pin drops when confidence crosses the threshold. Everything downstream is real — only the signal origin is scripted.

Simulated signals have `is_simulated: true` in Firestore and display a small "SIM" badge in the Contributing Signals section of the detail sheet. Transparent and honest.

### 11.2 Why Both Modes Use the Same Pipeline

The pipeline has zero awareness of simulation mode. The Pub/Sub message schema is identical. Agent 1 receives the same input structure. Firestore documents look the same. The only difference is `is_simulated: true` on the signal document. This means the demo is a genuine demonstration of the real system — not a mocked UI.

### 11.3 Simulated Signal Sequences

Each demo scenario has a JSON file in Cloud Storage (`/demo-scenarios/scenario_01_lahore_flood.json`) defining the signal sequence:

```json
{
  "scenario_name": "Lahore Flash Flood",
  "signals": [
    { "delay_seconds": 0, "source_type": "weather", "payload": { "city": "Lahore", "rainfall_mm_hr": 72 } },
    { "delay_seconds": 45, "source_type": "bluesky", "payload": { "raw_text": "yaar G-10 mein pani bhar gaya serious hai" } },
    { "delay_seconds": 90, "source_type": "bluesky", "payload": { "raw_text": "Canal Road completely flooded avoid" } },
    { "delay_seconds": 120, "source_type": "traffic", "payload": { "corridor": "Canal Road Lahore", "congestion_ratio": 4.2 } },
    { "delay_seconds": 150, "source_type": "rss", "payload": { "headline": "Flash floods reported in Gulberg, Lahore", "source": "geo.tv" } }
  ]
}
```

The Cloud Function replays these with their specified delays, injecting each into the appropriate Pub/Sub topic. By signal 3 (at 90 seconds), confidence typically crosses 45 and the map pin drops live during the demo.

---

## 12. Infrastructure & DevOps

### 12.1 Project

GCP Project ID: `ciro-hackathon-2026`
Region: `asia-south1` (Mumbai — lowest latency to Pakistan)
Billing: hackathon credits

### 12.2 Eventarc Advanced

Sits between Pub/Sub and Cloud Workflows. Configured with:
- One Bus resource receiving messages from all six Pub/Sub topics
- Six Pipeline resources — one per topic — each with a filter dropping non-disaster-adjacent signals before they reach the agent pipeline
- Direct trigger to Cloud Workflows
- Retry policy: linear backoff, max 5 attempts

Why Eventarc over raw Pub/Sub push: filtering happens pre-pipeline, reducing unnecessary Gemini API calls. Named pipeline resources are visible in Cloud Console — appear in the agent trace and make the architecture readable to judges.

### 12.3 Cloud Workflows

Orchestrates the 4-agent pipeline as a structured YAML workflow. Each step has explicit input/output mapping. The execution graph in Cloud Console shows SUCCESS / RUNNING / FAILED per node — screenshot and submitted as an artifact. Conditional branches for all three feedback loops are visible in the graph.

### 12.4 Cloud Run

Hosts the agent pipeline as a containerised Python 3.12 service. Stateless, auto-scales to zero. IAM-authenticated — only Eventarc and Cloud Workflows can invoke it. Deployed via Antigravity's Cloud Run MCP server.

### 12.5 Cloud Functions

```
poller_bluesky              every 5 min via Cloud Scheduler
poller_youtube              every 30 min via Cloud Scheduler
poller_rss                  every 5 min via Cloud Scheduler
poller_weather              every 10 min via Cloud Scheduler
poller_pmd                  every 15 min via Cloud Scheduler (with simulated fallback)
poller_traffic              every 10 min via Cloud Scheduler (Routes API + simulated fallback)
manual_report_receiver      HTTP trigger (Flutter POST)
decay_scheduler             every 60 min via Cloud Scheduler
simulation_replay           HTTP trigger (Flutter simulation mode button)
gemini_grounding_enricher   HTTP trigger (called by Cloud Workflows post-detection step)
```

### 12.6 Secret Manager

Stores: Maps API key, OpenWeatherMap API key, YouTube Data API key, FCM server key. All injected as environment variables at Cloud Run runtime. No secrets in source code.

### 12.7 Cloud Logging + Cloud Trace

All Cloud Run agent steps emit structured JSON logs: agent_name, crisis_id, signal_id, step_name, input_summary, output_summary, duration_ms. Cloud Trace shows the full multi-step call graph for a crisis lifecycle. Both exported as submission artifacts.

### 12.8 Cloud Build + Artifact Registry

Cloud Build trigger on git push to main. Builds Docker image, pushes to Artifact Registry, deploys to Cloud Run. Auto-deploy throughout the sprint.

---

## 13. Development Environment — Antigravity

### 13.1 What Antigravity Is

Google's AI-native IDE — a VS Code fork with Gemini 3.1 Pro as its reasoning engine. All CIRO code is written, planned, and deployed through Antigravity's Agent Manager. It generates plan artifacts, walkthrough artifacts, and reasoning traces at every mission — these ARE the "Agent Trace / Logs" submission deliverable.

### 13.2 Configuration

`.antigravity/rules.md`:
```markdown
# CIRO Project Rules

## Google Cloud
- Project ID: ciro-hackathon-2026
- Region: asia-south1
- Always use this project for all deployments

## Artifact Storage
- Save ALL plan artifacts to: _antigravity_artifacts/plans/
- Save ALL walkthrough artifacts to: _antigravity_artifacts/walkthroughs/
- Save ALL agent trace exports to: _antigravity_artifacts/traces/
- After every completed mission write a summary markdown to
  _antigravity_artifacts/traces/ named: YYYY-MM-DD_HH-MM_<task>.md
- Never delete anything from _antigravity_artifacts/

## Review Policy
- Always generate Plan artifact before executing
- Wait for approval before running terminal commands
- Label every artifact with task name and date

## Stack
- Flutter for mobile (flutter_app/)
- Python 3.12 for backend (backend/)
- Firestore for live state, BigQuery for analytics
- Cloud Workflows + Vertex AI Agent Builder for orchestration
- Eventarc Advanced for event routing
```

### 13.3 Model Selection

Gemini 3.1 Pro (High) — architecture, complex features, agent prompt engineering, Cloud Workflows YAML, schema design.
Gemini 3 Flash — Flutter boilerplate, Cloud Function scaffolding, README generation, test files.

### 13.4 Mission Naming Convention

```
01_project_scaffold
02_pubsub_eventarc_setup
03_signal_poller_bluesky
04_signal_poller_youtube
05_signal_poller_rss
06_signal_poller_weather_traffic_pmd
07_language_detection_routing
08_cloud_translation_integration
09_text_embeddings_integration
10_cloud_workflows_orchestrator
11_agent1_extraction
12_agent2_detection_scoring_impact
13_agent3_response_planning
14_agent4_action_simulation
15_decay_scheduler
16_gemini_grounding_enricher
17_flutter_map_screen
18_flutter_crisis_detail_sheet
19_flutter_signal_feed
20_flutter_report_disaster
21_flutter_analytics_bigquery
22_flutter_agent_trace_screen
23_flutter_simulation_mode
24_demo_scenarios_seed
25_fcm_push_notifications
26_demo_video_prep
27_readme_and_submission
```

---

## 14. Submission Artifacts Strategy

**Working Prototype:** Flutter APK built and signed by Antigravity. Connects to live Cloud Run and Firestore.

**Demo Video (4 minutes):**
- Open: global map with 2 pre-seeded international crises visible (California wildfire, Istanbul earthquake pins)
- Switch to Pakistan view: 1 pre-seeded Karachi crisis visible
- Activate Simulated mode: select Lahore Flood scenario, press Start
- Watch signals arrive one by one in Signal Feed screen (split screen or screen recording)
- Show Cloud Logging panel alongside: Bluesky signal payload → Pub/Sub → Agent 1 extraction log → Agent 2 confidence calculation → Firestore write
- Map pin drops on Lahore (CRITICAL, red, pulse animation)
- FCM push notification arrives on device
- Tap pin: detail sheet opens — show raw Urdu signals with language badges, confidence breakdown, impact card, before/after metrics, route polylines on map
- Open Agent Trace Screen: show Cloud Workflows execution graph, tap Agent 2 node to show reasoning log
- Close: BigQuery analytics screen with aggregate statistics

**Agent Trace / Logs:**
1. `_antigravity_artifacts/` — all Antigravity plan, walkthrough, trace artifacts from every mission
2. Cloud Workflows execution graph screenshots — visual proof of orchestration
3. Vertex AI Agent Builder execution logs — exported JSON from Agent Builder console
4. Cloud Logging structured logs — full pipeline execution for one demo crisis event as JSON export

**README:** Generated by Antigravity mission 27. Covers architecture overview, tech stack, setup instructions, Antigravity usage evidence, assumptions, and artifact bucket link.

---

## 15. Demo Scenarios

**Scenario 1 — Lahore Flash Flood (CRITICAL, confidence: 94)**
Location: Gulberg, Lahore, PK (31.5204°N, 74.3587°E)
Signals: 3 Bluesky Roman Urdu posts, Geo News RSS article, OpenWeatherMap 72mm/hr rainfall, PMD Punjab flood advisory, Canal Road traffic congestion 4.2x
Actions: Route redirect Canal Road → Jail Road (Directions API polyline rendered), 3 rescue units dispatched (TKT-2847), FCM alert broadcast
Impact: 85,000 affected population, Canal Road and Gulberg Main blocked, PKR 3-7M/hr economic impact
Before/After: avg_delay 45min → 12min, 200 vehicles stranded → 0, rescue ETA null → 8min

**Scenario 2 — Karachi Road Blockage (HIGH, confidence: 71)**
Location: Saddar, Karachi, PK (24.8607°N, 67.0011°E)
Signals: 2 Bluesky Roman Urdu posts, ARY News RSS, YouTube video 18k views
Actions: Alternate route M.A. Jinnah Road, traffic warden dispatch

**Scenario 3 — Islamabad Heatwave (MEDIUM, confidence: 58)**
Location: G-10, Islamabad, PK (33.6844°N, 73.0479°E)
Signals: 2 English social posts, OWM temperature spike 46°C
Actions: Advisory only (MEDIUM severity) — FCM public advisory, hospital preparedness

**Scenario 4 — California Wildfire (CRITICAL, confidence: 88) — Global demo**
Location: Los Angeles County, CA, USA (34.0522°N, 118.2437°W)
Signals: 5 Bluesky posts, 2 Reuters/AP RSS articles, YouTube video 120k views
Actions: Evacuation route redirect, emergency dispatch, alert broadcast

**Scenario 5 — Istanbul Earthquake (HIGH, confidence: 79) — Global demo**
Location: Istanbul, Turkey (41.0082°N, 28.9784°E)
Signals: 3 Turkish social posts (Cloud Translation NMT), BBC RSS article
Actions: Hospital preparedness, emergency dispatch, resource allocation

---

## 16. Assumptions

These assumptions are explicitly acknowledged and the system degrades gracefully when they do not hold:

**External API availability:** Bluesky, YouTube, OpenWeatherMap, and Google Maps Routes API are assumed available during the demo. If any fail, their simulated fallback takes over automatically with identical output schema. The Flutter status bar shows which sources are live vs simulated at all times.

**Roman Urdu handling:** Gemini 1.5 Pro is assumed to understand Roman Urdu natively without NMT translation. This is based on Gemini's known training data and empirical testing. If a Roman Urdu post is misunderstood by Agent 1, the `extraction_confidence` will be low and the signal will be stored with LOW confidence flags — it will not incorrectly boost a crisis event.

**Geocoding of informal locations:** The Geocoding API is assumed to resolve common Pakistani neighbourhood names, road names, and area codes. Names that fail geocoding fall back to city-level coordinates. Agent 1's re-extraction loop may surface better location strings on retry.

**FCM on demo device:** Firebase Cloud Messaging is assumed to work on the demo Android device with Google Play Services. The demo device is tested before recording.

**Signal ingestion during demo:** Live signal ingestion may not organically produce a crisis event during a 5-minute demo window. Simulation mode exists specifically for this — it is not a workaround but a designed feature. The pipeline is identical in both modes.

**Confidence scoring calibration:** The confidence score thresholds and bonus values are calibrated for the demo scenarios. Real-world deployment would require tuning against historical data. The system is designed to make this tunable via a configuration document without code changes.

**NMT translation quality:** Cloud Translation NMT is assumed to produce semantically adequate translations for formal Urdu, Arabic, French, Spanish, and Turkish. Translation is used only as a comprehension aid — Gemini receives the raw original text as ground truth in all cases.

**BigQuery streaming latency:** Firestore-to-BigQuery streaming export is assumed to have under 60 seconds latency. Analytics screen data may be up to 1 minute behind live crisis state.

---

## 17. Evaluation Criteria Mapping

**Use of Google Antigravity — 25%**
Antigravity is the sole development environment. All code written inside it. Cloud Run deployment via Antigravity's Cloud Run MCP server. Every mission produces plan + walkthrough + trace artifacts stored in `_antigravity_artifacts/`. Vertex AI Agent Builder (within GCP) hosts the formal agent workflow. All submission trace artifacts are Antigravity-generated.

**Agentic Reasoning & Coordination — 20%**
Four agents with single responsibilities, explicit inputs/outputs, and structured reasoning logged at each step. Cloud Workflows provides a visible orchestration graph. Three conditional feedback loops create genuine agent interaction: Agent 1 re-extraction on low confidence, Agent 3 severity recheck via Agent 2, Agent 4 replanning back to Agent 3. Agents communicate via Firestore shared state — decoupled and traceable. All reasoning is logged in structured JSON in agent_reasoning array on every crisis document.

**Situation Detection & Analysis — 20%**
Seven independent signal sources with different credibility weights. Multi-factor confidence scoring with geographic, temporal, source diversity, media, and traffic bonuses. Semantic embedding clustering — signals grouped by meaning, not keywords. Multilingual signal handling: Roman Urdu and English go directly to Gemini; formal Urdu/Arabic/other go through NMT with both texts sent to agents. Raw multilingual signals displayed in Flutter UI. Confidence decay handles situation resolution. Post-detection Gemini Search Grounding enriches confidence with live web evidence.

**Action Planning & Simulation — 15%**
Five action types: ROUTE_REDIRECT, EMERGENCY_DISPATCH, ALERT_BROADCAST, RESOURCE_ALLOCATION, HOSPITAL_PREPAREDNESS. Agent 3 selects contextually — not hardcoded responses. Agent 4 produces real Firestore state changes, real FCM notifications, real Directions API polylines. Quantified before/after impact_metrics with specific numbers. Replanning loop if an action is unexecutable. Traffic congestion before/after is visible on the map via Routes API data.

**Technical Implementation — 10%**
Clean layered architecture. Eventarc Advanced for intelligent pre-pipeline filtering. Cloud Workflows for traceable orchestration with conditional branches. BigQuery for historical analytics. Signals subcollection prevents Firestore 1MB limit. Secret Manager for all credentials. Confidence decay via scheduled Cloud Function. Simulated fallbacks for all external sources with graceful degradation.

**Innovation & UX — 10%**
Global + Pakistan dual-view map. Raw multilingual signals with language badges in the detail sheet — authentic, compelling, unique. Agent Trace screen — judges explore the reasoning pipeline interactively inside the app. Simulation mode with signal health dashboard shows which sources are live in real time. Confidence decay — system knows when crises resolve, not just when they start. Semantic embedding clustering over keyword matching. Traffic layer integrated into the map UI. Natural language BigQuery queries in the analytics screen.

---

## 18. Full Tech Stack Reference

**Development:** Google Antigravity IDE (Gemini 3.1 Pro + Flash)

**Mobile:** Flutter 3.x / Dart — Android APK

**Agent Orchestration:** Vertex AI Agent Builder + Cloud Workflows (conditional branching, feedback loops)

**Agent LLM:** Vertex AI Gemini 1.5 Pro (function calling, chain-of-thought, multimodal for stretch goal)

**Semantic Embeddings:** Vertex AI Text Embeddings API (text-embedding-004)

**Event Routing:** Google Cloud Pub/Sub (6 topics) + Eventarc Advanced (pre-pipeline filtering)

**Signal Pollers:** Cloud Functions (Python) + Cloud Scheduler (per-source cadence)

**Backend Runtime:** Python 3.12 on Cloud Run (IAM-authenticated, auto-scales to zero)

**Language Detection:** Cloud Translation API (detection only — no translation for Roman Urdu / English)

**Translation:** Cloud Translation NMT (formal Urdu, Arabic, and other languages only — as comprehension aid, not ground truth)

**Traffic Signals:** Google Maps Routes API (congestion ratio per corridor) + simulated fallback

**Realtime Database:** Cloud Firestore (crisis_events + subcollections)

**Historical Analytics:** BigQuery + Gemini natural language SQL

**Push Notifications:** Firebase Cloud Messaging (FCM)

**Maps:** Google Maps SDK for Android + Directions API + Geocoding API + Routes API + Traffic Layer

**Post-detection Enrichment:** Vertex AI Gemini with Google Search Grounding

**Storage:** Cloud Storage (artifacts, simulated feeds, demo scenarios, signal media)

**Secrets:** Secret Manager (all API keys injected at runtime)

**Logging:** Cloud Logging + Cloud Trace (structured JSON, multi-step call graph)

**CI/CD:** Cloud Build + Artifact Registry

**Region:** asia-south1 (Mumbai) — primary. Crisis events stored with global lat/lng.

**Signal Sources (Live):** Bluesky AT Protocol · YouTube Data API v3 · RSS (Dawn, Geo, ARY, BBC, Reuters, AP) · OpenWeatherMap · Google Maps Routes API · Pakistan Meteorological Department

**Signal Sources (Simulated Fallback):** simulated_pmd_feed · simulated_traffic_api · pre-scripted social/news/weather JSON sequences

---

*Document version: 2.0 — Pre-build, all gaps resolved*
*Last updated: May 2026*
*Author: Daniyal Jamil | CIRO — AISeekho Antigravity Hackathon 2026*
