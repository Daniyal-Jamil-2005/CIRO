import base64
import json
import os
import uuid
import functions_framework
from google.cloud import firestore

# Initialize Firestore
db = firestore.Client()

@functions_framework.cloud_event
def extract_signal(cloud_event):
    """
    Cloud Event function triggered by Pub/Sub.
    Acts as Agent 1: Extracts signal metadata and saves to Firestore.
    In a full production setup, this would call Vertex AI to extract semantic meaning.
    """
    print(f"Received event with ID: {cloud_event['id']} and type {cloud_event['type']}")
    
    # Extract the Pub/Sub message
    pubsub_message = cloud_event.data["message"]
    
    if "data" in pubsub_message:
        message_data = base64.b64decode(pubsub_message["data"]).decode("utf-8")
        try:
            signal = json.loads(message_data)
            print(f"Processing signal: {signal}")
            
            # --- AGENT 1 LOGIC PLACEHOLDER ---
            # Here you would typically send signal['raw_text'] to Vertex AI (Gemini)
            # to extract precise locations, sentiment, and event type.
            # For this hackathon step, we assume the simulated pollers already
            # provided structured hints (location_hint, event_type_hint).
            
            # Enrich signal with Agent 1 extraction results
            signal['extracted_location'] = signal.get('location_hint', 'Unknown')
            signal['extracted_event'] = signal.get('event_type_hint', 'Unknown')
            signal['agent_1_status'] = 'PROCESSED'
            
            # Write to Firestore (this will trigger Agent 2 via another Eventarc/trigger)
            signal_ref = db.collection('signals').document(signal['signal_id'])
            signal_ref.set(signal)
            
            print(f"Signal {signal['signal_id']} successfully saved to Firestore.")
            
        except Exception as e:
            print(f"Error processing message: {e}")
            
    else:
        print("No data found in Pub/Sub message.")
