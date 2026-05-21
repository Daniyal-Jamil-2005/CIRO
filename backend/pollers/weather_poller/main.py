import json
import os
import uuid
from datetime import datetime, timezone
from google.cloud import pubsub_v1
import functions_framework

publisher = pubsub_v1.PublisherClient()
PROJECT_ID = os.environ.get('GCP_PROJECT', os.environ.get('GOOGLE_CLOUD_PROJECT', 'YOUR_PROJECT_ID'))
TOPIC_ID = 'weather-signals'
TOPIC_PATH = publisher.topic_path(PROJECT_ID, TOPIC_ID)

MOCK_WEATHER_ALERTS = [
    {
        "src": "WEATHER",
        "lang": "ENGLISH",
        "text": "Rainfall spike 84mm/hr detected at Lahore station — exceeds 30-yr average.",
        "loc": "Lahore",
        "type": "FLOOD"
    }
]

@functions_framework.http
def poll_weather(request):
    """
    HTTP Cloud Function triggered by Cloud Scheduler.
    Simulates polling OpenWeatherMap API and publishes signals to Pub/Sub.
    """
    published_count = 0
    
    for alert in MOCK_WEATHER_ALERTS:
        signal_payload = {
            "signal_id": str(uuid.uuid4()),
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "source": alert["src"],
            "language": alert["lang"],
            "raw_text": alert["text"],
            "location_hint": alert["loc"],
            "event_type_hint": alert["type"],
            "is_simulated": True,
            "credibility_score": 20 # Higher base score for weather data
        }
        
        data_bytes = json.dumps(signal_payload).encode("utf-8")
        future = publisher.publish(TOPIC_PATH, data=data_bytes)
        future.result()
        published_count += 1
        
    return f"Successfully polled weather API. Published {published_count} simulated signals.", 200
