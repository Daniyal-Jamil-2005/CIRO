import json
import os
import uuid
from datetime import datetime, timezone
from google.cloud import pubsub_v1
import functions_framework

# Initialize Pub/Sub Publisher
publisher = pubsub_v1.PublisherClient()
PROJECT_ID = os.environ.get('GCP_PROJECT', os.environ.get('GOOGLE_CLOUD_PROJECT', 'YOUR_PROJECT_ID'))
TOPIC_ID = 'social-signals'
TOPIC_PATH = publisher.topic_path(PROJECT_ID, TOPIC_ID)

MOCK_SOCIAL_POSTS = [
    {
        "src": "BLUESKY",
        "lang": "ROMAN URDU",
        "text": "Gulberg main paani bohat zyada hai, gari nahi chal rahi. MM Alam band hai.",
        "loc": "Lahore, Gulberg",
        "type": "FLOOD"
    },
    {
        "src": "BLUESKY",
        "lang": "ENGLISH",
        "text": "Traffic is completely jammed near Liberty. I can see water up to the tires.",
        "loc": "Lahore, Liberty",
        "type": "FLOOD"
    },
    {
        "src": "BLUESKY",
        "lang": "ROMAN URDU",
        "text": "Road totally blocked Ferozepur road pe. Accident hai shayad.",
        "loc": "Lahore, Ferozepur Road",
        "type": "ROAD_BLOCKAGE"
    }
]

@functions_framework.http
def poll_social(request):
    """
    HTTP Cloud Function triggered by Cloud Scheduler.
    Simulates polling Bluesky/Twitter and publishes signals to Pub/Sub.
    """
    published_count = 0
    
    for post in MOCK_SOCIAL_POSTS:
        # Create the standardized signal payload
        signal_payload = {
            "signal_id": str(uuid.uuid4()),
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "source": post["src"],
            "language": post["lang"],
            "raw_text": post["text"],
            "location_hint": post["loc"],
            "event_type_hint": post["type"],
            "is_simulated": True,
            "credibility_score": 10 # Base score for social media
        }
        
        # Publish to Pub/Sub
        data_bytes = json.dumps(signal_payload).encode("utf-8")
        future = publisher.publish(TOPIC_PATH, data=data_bytes)
        future.result() # Wait for publish to succeed
        published_count += 1
        
    return f"Successfully polled social media. Published {published_count} simulated signals.", 200
