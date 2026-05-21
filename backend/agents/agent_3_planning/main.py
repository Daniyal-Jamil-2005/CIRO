import json
from datetime import datetime, timezone
import functions_framework
from google.cloud import firestore

# Initialize Firestore
db = firestore.Client()

@functions_framework.cloud_event
def plan_response(cloud_event):
    """
    Cloud Event function triggered by Firestore document update/create in 'crises' collection.
    Acts as Agent 3: Evaluates severity and creates a Response Plan.
    """
    print(f"Triggered by Firestore event on crises: {cloud_event['id']}")
    
    try:
        payload = cloud_event.data
        if 'value' in payload and 'fields' in payload['value']:
            fields = payload['value']['fields']
            
            crisis_id = fields.get('crisis_id', {}).get('stringValue')
            if not crisis_id:
                return
                
            agent_3_status = fields.get('agent_3_status', {}).get('stringValue', '')
            
            # Only process if Agent 3 hasn't processed this crisis state yet
            if agent_3_status == 'COMPLETED':
                print("Agent 3 already processed this state. Skipping.")
                return
                
            event_type = fields.get('type', {}).get('stringValue', 'UNKNOWN')
            location = fields.get('location', {}).get('stringValue', 'UNKNOWN')
            
            print(f"Agent 3 analyzing {event_type} at {location} (Crisis ID: {crisis_id})")
            
            # --- AGENT 3 LOGIC ---
            # In production, Vertex AI would generate the response plan based on
            # SOP documents and real-time context.
            
            response_plan = ""
            severity = "HIGH"
            
            if event_type == "FLOOD":
                severity = "CRITICAL"
                response_plan = "Requires Heavy Water Extraction & Traffic Control. Alerting 3 services based on severity."
            elif event_type == "ROAD_BLOCKAGE":
                severity = "MEDIUM"
                response_plan = "Reroute traffic around the blockage. Dispatching traffic wardens."
            elif event_type == "FIRE":
                severity = "CRITICAL"
                response_plan = "Immediate fire brigade dispatch required. Evacuate surrounding 100m."
            else:
                response_plan = "Dispatch standard assessment team."
                
            # Update the crisis with the plan
            crisis_ref = db.collection('crises').document(crisis_id)
            crisis_ref.update({
                'severity': severity,
                'response_plan': response_plan,
                'agent_3_status': 'COMPLETED',
                'agent_4_status': 'PENDING' # Pass to Agent 4
            })
            
            print(f"Response plan generated for Crisis {crisis_id}")
            
    except Exception as e:
        print(f"Error in Agent 3 planning logic: {e}")
