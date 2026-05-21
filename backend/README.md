# CIRO Backend - Agent Pipeline & Pollers

The CIRO backend implements a multi-stage agent architecture for crisis intelligence processing, combined with external data pollers for continuous signal ingestion.

## Architecture Overview

```
Data Sources
    ├── Social Media Poller → (Raw signals)
    └── Weather Poller → (Weather data)
            ↓
Agent Pipeline
    ├─ Agent 1: Extraction → (Normalize & enrich)
    ├─ Agent 2: Detection → (Classify & validate)
    ├─ Agent 3: Planning → (Generate response)
    └─ Agent 4: Execution → (Dispatch & track)
            ↓
Firebase Firestore
    ├─ crises collection
    ├─ signals collection
    ├─ tickets collection
    └─ dispatch_logs collection
```

## Agent Pipeline

### Agent 1: Extraction (`agent_1_extraction/`)
**Responsibility**: Ingest raw data and normalize into crisis signals

- **Input**: Raw events from pollers
- **Process**:
  - Parse semi-structured data
  - Extract location, timestamp, source
  - Compute initial confidence scores
  - Enrich with geographic metadata
- **Output**: Normalized signal documents
- **Mains Methods**: `extract_raw_data()`, `normalize_signal()`

### Agent 2: Detection (`agent_2_detection/`)
**Responsibility**: Classify events and determine if crisis-level

- **Input**: Extracted signals
- **Process**:
  - Apply ML/rule-based classifiers
  - Categorize event type (FIRE, FLOOD, EARTHQUAKE, etc.)
  - Validate against known false positives
  - Assign severity level (LOW, MEDIUM, HIGH, CRITICAL)
  - Validate geographic boundary constraints
- **Output**: Crisis documents with confidence scores
- **Main Methods**: `classify_event()`, `validate_crisis()`, `assign_severity()`

### Agent 3: Planning (`agent_3_planning/`)
**Responsibility**: Generate response strategies

- **Input**: Validated crises
- **Process**:
  - Query historical similar events
  - Apply response templates
  - Identify affected assets/populations
  - Generate response roadmaps
  - Prioritize action items
- **Output**: Response plans with estimated impact
- **Main Methods**: `generate_response_plan()`, `validate_plan()`, `estimate_impact()`

### Agent 4: Execution (`agent_4_execution/`)
**Responsibility**: Execute response plans and track dispatch

- **Input**: Response plans
- **Process**:
  - Route to appropriate dispatch centers
  - Create actionable tickets
  - Notify stakeholders
  - Track execution status
  - Log outcomes for post-crisis analysis
- **Output**: Dispatch tickets and execution logs
- **Main Methods**: `dispatch_plan()`, `create_tickets()`, `update_status()`, `log_outcome()`

## Data Pollers

### Social Media Poller (`social_poller/`)
Continuously monitors social media for crisis signals.

**Configuration** (`main.py`):
```python
POLLING_INTERVAL = 300  # seconds (5 minutes)
SOURCES = ['twitter', 'reddit', 'telegram']  # Configured APIs
KEYWORDS = ['emergency', 'disaster', 'crisis', 'alert', ...]
```

**Input**: Social media APIs (Twitter, Reddit, Telegram)
**Output**: Raw signal documents in `signals/raw` Firestore collection

**Key Functions**:
- `fetch_tweets()`: Poll Twitter API
- `fetch_reddit()`: Poll Reddit disaster subreddits
- `parse_signal()`: Extract location, time, event type from posts
- `store_signal()`: Write to Firestore

### Weather Poller (`weather_poller/`)
Ingests real-time weather data to detect atmospheric crises.

**Configuration** (`main.py`):
```python
POLLING_INTERVAL = 600  # seconds (10 minutes)
WEATHER_API = "openweathermap"  # or weatherapi, etc.
REGIONS = ['pakistan', 'middle-east', 'south-asia']
ALERT_THRESHOLDS = {
    'wind_speed_kmh': 120,
    'rainfall_mm_per_hour': 50,
    'temperature_c': 50
}
```

**Input**: OpenWeatherMap API, NOAA, local weather stations
**Output**: Atmospheric alerts in `signals/weather` Firestore collection

**Key Functions**:
- `fetch_weather()`: Poll weather service
- `detect_anomalies()`: Identify extreme conditions
- `generate_alert()`: Create weather signal
- `store_alert()`: Write to Firestore

## Setup & Installation

### Prerequisites
- Python 3.8+
- Firebase Admin SDK credentials (JSON key file)
- API keys for external services:
  - Twitter API (or Bearer token)
  - Reddit API (or credentials)
  - OpenWeatherMap API key
  - Telegram Bot token (optional)

### Installation

1. **Set up Python environment**:
```bash
python -m venv venv
source venv/Scripts/activate  # Windows: venv\Scripts\activate
```

2. **Install dependencies**:
```bash
pip install -r requirements.txt
```

3. **Configure environment variables** (create `.env`):
```bash
FIREBASE_PROJECT_ID=your-project-id
FIRESTORE_KEY_PATH=path/to/serviceAccountKey.json
TWITTER_API_KEY=your-twitter-key
TWITTER_API_SECRET=your-twitter-secret
TWITTER_BEARER_TOKEN=your-bearer-token
REDDIT_CLIENT_ID=your-reddit-id
REDDIT_CLIENT_SECRET=your-reddit-secret
OPENWEATHER_API_KEY=your-weather-key
TELEGRAM_BOT_TOKEN=your-bot-token
```

4. **Test individual agents**:
```bash
cd agent_1_extraction
python main.py

cd ../agent_2_detection
python main.py

# etc...
```

## Running the Pipeline

### Development (Sequential)

Run each agent manually in order:
```bash
# Terminal 1: Pollers (continuous)
cd pollers/social_poller
python main.py

# Terminal 2: Agent 1
cd agents/agent_1_extraction
python main.py --mode continuous

# Terminal 3: Agent 2
cd agents/agent_2_detection
python main.py --mode continuous

# (etc. for agents 3 & 4)
```

### Production Deployment

Use the deployment script for automated orchestration:
```powershell
# Windows PowerShell
./deploy_backend.ps1 --environment production --log-dir ./logs

# Output:
# [INFO] Starting social_poller...
# [INFO] Starting weather_poller...
# [INFO] Starting agent_1_extraction...
# [INFO] Starting agent_2_detection...
# [INFO] Starting agent_3_planning...
# [INFO] Starting agent_4_execution...
```

Or deploy as Docker services:
```bash
docker-compose -f docker-compose.backend.yml up -d
```

## API Specification

All agents expose a common REST endpoint for manual invocation:

### Submit Signal to Pipeline

**Endpoint**: `POST /pipeline/signal`

**Request**:
```json
{
  "title": "Flash Flood Alert",
  "description": "Heavy rainfall in Karachi, Sindh",
  "location": {"lat": 24.8607, "lng": 67.0011},
  "type": "FLOOD",
  "source": "twitter | reddit | weather | manual",
  "confidence": 0.75
}
```

**Response**:
```json
{
  "signal_id": "sig_abc123",
  "status": "processing",
  "pipeline_stages": {
    "extraction": "queued",
    "detection": "queued",
    "planning": "queued",
    "execution": "queued"
  }
}
```

### Get Pipeline Status

**Endpoint**: `GET /status`

**Response**:
```json
{
  "pollers": {
    "social_poller": {"status": "running", "last_poll": "2026-05-21T10:15:00Z"},
    "weather_poller": {"status": "running", "last_poll": "2026-05-21T10:16:00Z"}
  },
  "agents": {
    "agent_1_extraction": {"status": "processing", "queue_length": 3},
    "agent_2_detection": {"status": "idle", "queue_length": 0},
    "agent_3_planning": {"status": "processing", "queue_length": 1},
    "agent_4_execution": {"status": "processing", "queue_length": 2}
  },
  "firestore": {"connected": true, "latency_ms": 42}
}
```

## Monitoring & Logging

Logs are written to `./logs/` directory with per-agent log files:

```
logs/
├── social_poller.log
├── weather_poller.log
├── agent_1_extraction.log
├── agent_2_detection.log
├── agent_3_planning.log
└── agent_4_execution.log
```

**Log Level**: INFO (development), WARNING (production)

Real-time monitoring via Firebase Console:
- View all crises in `crises` collection
- Check signal ingestion in `signals` collection
- Monitor ticket creation in `tickets` collection

## Troubleshooting

### "Firebase connection failed"
- ✅ Verify `FIREBASE_PROJECT_ID` and `FIRESTORE_KEY_PATH` in `.env`
- ✅ Ensure service account JSON has Firestore read/write permissions
- ✅ Check firestore.rules allow the service account access

### "API Rate Limited"
- ✅ Reduce `POLLING_INTERVAL` in poller configs
- ✅ Upgrade API tier (Twitter Elevated, OpenWeatherMap Pro, etc.)
- ✅ Implement exponential backoff

### "Agents Not Processing"
- ✅ Check `./logs/` for error messages
- ✅ Verify Firestore has documents in source collections
- ✅ Run `./deploy_backend.ps1 --debug` for verbose output

## Performance Optimization

### Batch Processing
For high-volume scenarios, agents support batch modes:
```bash
python main.py --batch-size 100 --workers 4
```

### Caching
Agents cache classification models in memory to reduce latency:
```python
# agent_2_detection/main.py
from cache import CrisisClassifierCache
cache = CrisisClassifierCache(ttl_minutes=30)
```

### Async I/O
All Firestore operations use async clients to prevent blocking:
```python
# agent_3_planning/main.py
await firestore_client.collection('crises').add(plan_doc)
```

## Future Enhancements

- [ ] Machine learning models for improved event classification
- [ ] Multi-language NLP for social media parsing
- [ ] Real-time Firestore listeners (replace polling)
- [ ] Mobile push notifications for critical crises
- [ ] Integration with emergency services APIs (911, police, etc.)
- [ ] Historical analytics dashboard
- [ ] Cost optimization via scheduled off-peak polling

## Support & Debugging

For issues or questions:
1. Check `./logs/` for agent-specific errors
2. Review [CIRO_Project_Doc.md](../Antigravity%20traces/CIRO_Project_Doc.md) for schema reference
3. Open an issue on [GitHub Issues](https://github.com/Daniyal-Jamil-2005/CIRO/issues)

---

**Last Updated**: May 2026  
**Maintained By**: Daniyal Jamil
