# Backend Deployment Script for CIRO Google Cloud
# This script deploys all pollers and agents to Google Cloud Functions.

Write-Host "Deploying Social Signal Poller..."
gcloud functions deploy social-poller `
  --gen2 `
  --runtime=python311 `
  --region=us-central1 `
  --source=./pollers/social_poller `
  --entry-point=poll_social `
  --trigger-http `
  --allow-unauthenticated

Write-Host "Deploying Weather Signal Poller..."
gcloud functions deploy weather-poller `
  --gen2 `
  --runtime=python311 `
  --region=us-central1 `
  --source=./pollers/weather_poller `
  --entry-point=poll_weather `
  --trigger-http `
  --allow-unauthenticated

Write-Host "Deploying Agent 1 (Extraction)..."
gcloud functions deploy agent-1-extraction `
  --gen2 `
  --runtime=python311 `
  --region=us-central1 `
  --source=./agents/agent_1_extraction `
  --entry-point=extract_signal `
  --trigger-topic=social-signals

Write-Host "Deploying Agent 2 (Detection)..."
gcloud functions deploy agent-2-detection `
  --gen2 `
  --runtime=python311 `
  --region=us-central1 `
  --source=./agents/agent_2_detection `
  --entry-point=detect_crisis `
  --trigger-event-filters="type=google.cloud.firestore.document.v1.created" `
  --trigger-event-filters="database=(default)" `
  --trigger-event-filters-path-pattern="document=signals/{signal_id}"

Write-Host "Deploying Agent 3 (Planning)..."
gcloud functions deploy agent-3-planning `
  --gen2 `
  --runtime=python311 `
  --region=us-central1 `
  --source=./agents/agent_3_planning `
  --entry-point=plan_response `
  --trigger-event-filters="type=google.cloud.firestore.document.v1.written" `
  --trigger-event-filters="database=(default)" `
  --trigger-event-filters-path-pattern="document=crises/{crisis_id}"

Write-Host "Deploying Agent 4 (Execution)..."
gcloud functions deploy agent-4-execution `
  --gen2 `
  --runtime=python311 `
  --region=us-central1 `
  --source=./agents/agent_4_execution `
  --entry-point=execute_response `
  --trigger-event-filters="type=google.cloud.firestore.document.v1.written" `
  --trigger-event-filters="database=(default)" `
  --trigger-event-filters-path-pattern="document=crises/{crisis_id}"

Write-Host "All deployments initiated! Note: Firestore Eventarc triggers require the database to be enabled in Native mode."
