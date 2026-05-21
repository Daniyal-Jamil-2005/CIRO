import json
import uuid
from datetime import datetime, timezone
import functions_framework
from google.cloud import firestore

# Initialize Firestore
db = firestore.Client()

@functions_framework.cloud_event
def detect_crisis(cloud_event):
    """
    Cloud Event function triggered by Firestore document creation in 'signals' collection.
    Acts as Agent 2: Aggregates signals and determines if a Crisis should be created/updated.
    """
    print(f"Triggered by Firestore event: {cloud_event['id']}")
    
    # In a real implementation, you would query recent signals in the same location
    # and use Vertex AI to determine if they correlate to a single Crisis event.
    # For the hackathon, we will simply map the new signal to a Crisis directly.
    
    # Extract the Firestore document data from the cloud event
    # (The data payload structure depends on the exact Eventarc trigger used)
    # This is a simplified extraction for demonstration
    try:
        payload = cloud_event.data
        if 'value' in payload and 'fields' in payload['value']:
            fields = payload['value']['fields']
            
            # Simple parsing of Firestore fields
            signal_id = fields.get('signal_id', {}).get('stringValue', 'unknown')
            location = fields.get('extracted_location', {}).get('stringValue', 'Unknown Location')
            event_type = fields.get('extracted_event', {}).get('stringValue', 'Unknown Event')
            
            print(f"Processing signal {signal_id} at {location} for {event_type}")
            
            # --- AGENT 2 LOGIC ---
            # Check if an active crisis exists at this location
            crises_ref = db.collection('crises')
            query = crises_ref.where('location', '==', location).where('status', '==', 'ACTIVE').limit(1)
            results = query.stream()
            
            crisis_doc = None
            for doc in results:
                crisis_doc = doc
                break
                
            if crisis_doc:
                # Update existing crisis
                crisis_data = crisis_doc.to_dict()
                print(f"Correlated to existing crisis: {crisis_data['crisis_id']}")
                
                # Update logic (e.g., increase confidence)
                crisis_ref = crises_ref.document(crisis_data['crisis_id'])
                crisis_ref.update({
                    'signals_count': firestore.Increment(1),
                    'last_updated': datetime.now(timezone.utc).isoformat()
                })
            else:
                # Create a new crisis
                crisis_id = str(uuid.uuid4())
                print(f"Detected NEW crisis. Generating ID: {crisis_id}")
                
                new_crisis = {
                    'crisis_id': crisis_id,
                    'title': f"{event_type} - {location}",
                    'type': event_type,
                    'location': location,
                    'status': 'ACTIVE',
                    'severity': 'HIGH', # Default, Agent 3 will refine this
                    'signals_count': 1,
                    'confidence_score': 75,
                    'created_at': datetime.now(timezone.utc).isoformat(),
                    'last_updated': datetime.now(timezone.utc).isoformat(),
                    'agent_2_status': 'DETECTED',
                    'agent_3_status': 'PENDING'
                }
                crises_ref.document(crisis_id).set(new_crisis)
                print(f"Crisis {crisis_id} created.")
                
    except Exception as e:
        print(f"Error in Agent 2 detection logic: {e}")
