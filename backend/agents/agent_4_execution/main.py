import json
import uuid
from datetime import datetime, timezone
import functions_framework
from google.cloud import firestore

# Initialize Firestore
db = firestore.Client()

@functions_framework.cloud_event
def execute_response(cloud_event):
    """
    Cloud Event function triggered by Firestore document update in 'crises' collection.
    Acts as Agent 4: Action Simulation & Execution.
    Reads the response plan and generates emergency_tickets.
    """
    print(f"Triggered by Firestore event on crises (Agent 4): {cloud_event['id']}")
    
    try:
        payload = cloud_event.data
        if 'value' in payload and 'fields' in payload['value']:
            fields = payload['value']['fields']
            
            crisis_id = fields.get('crisis_id', {}).get('stringValue')
            if not crisis_id:
                return
                
            agent_4_status = fields.get('agent_4_status', {}).get('stringValue', '')
            
            # Only process if Agent 4 is pending
            if agent_4_status != 'PENDING':
                return
                
            response_plan = fields.get('response_plan', {}).get('stringValue', '')
            severity = fields.get('severity', {}).get('stringValue', 'MEDIUM')
            location = fields.get('location', {}).get('stringValue', 'UNKNOWN')
            
            print(f"Agent 4 executing plan for Crisis {crisis_id} at {location}")
            
            # --- AGENT 4 LOGIC ---
            # In production, Vertex AI reads the response plan and structures
            # specific JSON API calls to different dispatch services.
            # Here, we parse the severity and plan to create tickets.
            
            tickets = []
            
            if severity == "CRITICAL" and "Water" in response_plan:
                tickets.extend([
                    {"service": "Traffic Police", "status": "Alerted", "action": "Rerouting traffic", "eta": "5 mins", "icon": "siren"},
                    {"service": "Rescue 1122", "status": "Dispatched", "action": "Heavy duty pumps", "eta": "12 mins", "icon": "flame"},
                    {"service": "Edhi Ambulance", "status": "Standby", "action": "Medical support", "eta": "N/A", "icon": "heartPulse"}
                ])
            elif severity == "CRITICAL" and "Fire" in response_plan:
                tickets.extend([
                    {"service": "Fire Brigade", "status": "Dispatched", "action": "Extinguishing fire", "eta": "4 mins", "icon": "flame"},
                    {"service": "Traffic Police", "status": "Alerted", "action": "Clearing roads", "eta": "2 mins", "icon": "siren"}
                ])
            else:
                tickets.append({"service": "Local Police", "status": "Dispatched", "action": "Assessment", "eta": "10 mins", "icon": "siren"})
                
            # Write tickets to Firestore subcollection or a separate collection
            batch = db.batch()
            for t in tickets:
                ticket_id = str(uuid.uuid4())
                ticket_ref = db.collection('emergency_tickets').document(ticket_id)
                batch.set(ticket_ref, {
                    'ticket_id': ticket_id,
                    'crisis_id': crisis_id,
                    'service': t['service'],
                    'status': t['status'],
                    'action': t['action'],
                    'eta': t['eta'],
                    'icon': t['icon'],
                    'created_at': datetime.now(timezone.utc).isoformat()
                })
            
            # Update crisis status
            crisis_ref = db.collection('crises').document(crisis_id)
            batch.update(crisis_ref, {
                'agent_4_status': 'EXECUTED',
                'status': 'RESPONDING' # System level status update
            })
            
            batch.commit()
            print(f"Successfully executed plan for Crisis {crisis_id}. Generated {len(tickets)} tickets.")
            
    except Exception as e:
        print(f"Error in Agent 4 execution logic: {e}")
