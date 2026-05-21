import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegionNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void setGlobal(bool value) => state = value;
}

final regionProvider = NotifierProvider<RegionNotifier, bool>(
  RegionNotifier.new,
);

// ─── Global Crises (pre-populated on launch) ───
class CrisesNotifier extends Notifier<List<Map<String, dynamic>>> {
  @override
  List<Map<String, dynamic>> build() => [
    {
      'crisis_id': 'crisis-pk-flood',
      'title': 'Flash Flood',
      'severity': 'CRITICAL',
      'status': 'ACTIVE',
      'location': 'Gulberg, Lahore',
      'lat': 31.5204,
      'lng': 74.3587,
      'confidence_score': 94,
      'last_updated': '2 min ago',
      'response_plan':
          '1. Evacuate low-lying areas in Gulberg.\n2. Dispatch high-capacity pumps to MM Alam Road.\n3. Reroute traffic via Canal Road.\n4. Alert local hospitals for potential waterborne diseases.',
    },
    {
      'crisis_id': 'crisis-pk-heat',
      'title': 'Extreme Heatwave',
      'severity': 'HIGH',
      'status': 'ACTIVE',
      'location': 'Jacobabad, Sindh',
      'lat': 28.2810,
      'lng': 68.4376,
      'confidence_score': 88,
      'last_updated': '5 min ago',
      'response_plan':
          '1. Open emergency cooling centers.\n2. Deploy water tankers across Jacobabad.\n3. Alert healthcare facilities for heat stroke patients.\n4. Issue public advisory via loudspeakers.',
    },
    {
      'crisis_id': 'crisis-au-wildfire',
      'title': 'Bushfire',
      'severity': 'CRITICAL',
      'status': 'ACTIVE',
      'location': 'Blue Mountains, NSW',
      'lat': -33.7150,
      'lng': 150.3119,
      'confidence_score': 91,
      'last_updated': '8 min ago',
      'response_plan':
          '1. Evacuate residents in Katoomba and Leura.\n2. Deploy Rural Fire Service aerial tankers.\n3. Establish firebreak along Great Western Highway.\n4. Open evacuation centres at Penrith RSL.',
    },
    {
      'crisis_id': 'crisis-us-grid',
      'title': 'Power Grid Failure',
      'severity': 'HIGH',
      'status': 'ACTIVE',
      'location': 'Houston, Texas',
      'lat': 29.7604,
      'lng': -95.3698,
      'confidence_score': 79,
      'last_updated': '12 min ago',
      'response_plan':
          '1. Activate backup generators at hospitals.\n2. Dispatch utility repair crews to downtown substation.\n3. Issue rolling blackout schedule.\n4. Open community warming centres.',
    },
    {
      'crisis_id': 'crisis-jp-earthquake',
      'title': 'Earthquake 6.2M',
      'severity': 'CRITICAL',
      'status': 'ACTIVE',
      'location': 'Osaka, Japan',
      'lat': 34.6937,
      'lng': 135.5023,
      'confidence_score': 96,
      'last_updated': '1 min ago',
      'response_plan':
          '1. Issue tsunami advisory for Osaka Bay.\n2. Deploy JSDF rapid-response units.\n3. Activate structural assessment teams for critical infrastructure.\n4. Open evacuation routes to elevated ground.',
    },
    {
      'crisis_id': 'crisis-br-landslide',
      'title': 'Landslide',
      'severity': 'HIGH',
      'status': 'ACTIVE',
      'location': 'Petrópolis, Brazil',
      'lat': -22.5113,
      'lng': -43.1779,
      'confidence_score': 82,
      'last_updated': '15 min ago',
      'response_plan':
          '1. Evacuate hillside communities.\n2. Deploy search-and-rescue teams.\n3. Close BR-040 highway.\n4. Establish triage point at Petrópolis General Hospital.',
    },
    {
      'crisis_id': 'crisis-pk-smog',
      'title': 'Toxic Smog Alert',
      'severity': 'HIGH',
      'status': 'ACTIVE',
      'location': 'DHA, Lahore',
      'lat': 31.4810,
      'lng': 74.3727,
      'confidence_score': 85,
      'last_updated': '3 min ago',
      'response_plan':
          '1. Issue AQI red alert via SMS.\n2. Close schools in DHA Phase 5–8.\n3. Deploy industrial emission inspectors.\n4. Distribute N95 masks at public buildings.',
    },
  ];

  void addCrisis(Map<String, dynamic> crisis) {
    state = [crisis, ...state];
  }
}

final crisesProvider =
    NotifierProvider<CrisesNotifier, List<Map<String, dynamic>>>(
      CrisesNotifier.new,
    );

// ─── Emergency Tickets (pre-populated on launch) ───
class TicketsNotifier extends Notifier<List<Map<String, dynamic>>> {
  @override
  List<Map<String, dynamic>> build() => [
    {
      'service': 'Traffic Police',
      'status': 'Alerted',
      'action': 'Rerouting MM Alam Road',
      'eta': '5 mins',
      'icon': 'siren',
    },
    {
      'service': 'Rescue 1122',
      'status': 'Dispatched',
      'action': 'Heavy duty pumps deployed',
      'eta': '12 mins',
      'icon': 'flame',
    },
    {
      'service': 'Edhi Ambulance',
      'status': 'En Route',
      'action': 'Standby near Gulberg',
      'eta': '8 mins',
      'icon': 'heartPulse',
    },
    {
      'service': 'WASA Lahore',
      'status': 'Dispatched',
      'action': 'Drainage crew mobilised',
      'eta': '20 mins',
      'icon': 'droplet',
    },
    {
      'service': 'Pakistan Red Crescent',
      'status': 'Alerted',
      'action': 'Relief camp setup',
      'eta': '35 mins',
      'icon': 'shield',
    },
    {
      'service': 'NSW Rural Fire Service',
      'status': 'Dispatched',
      'action': 'Aerial tanker deployed',
      'eta': '18 mins',
      'icon': 'flame',
    },
    {
      'service': 'ERCOT Grid Ops',
      'status': 'Monitoring',
      'action': 'Load shedding rotation',
      'eta': 'N/A',
      'icon': 'zap',
    },
  ];

  void addTickets(List<Map<String, dynamic>> tickets) {
    state = [...tickets, ...state];
  }
}

final ticketsProvider =
    NotifierProvider<TicketsNotifier, List<Map<String, dynamic>>>(
      TicketsNotifier.new,
    );

// ─── Signal Feed (pre-populated on launch) ───
final signalsProvider = Provider<List<Map<String, dynamic>>>(
  (ref) => [
    {
      'raw_text':
          '🚨 Gulberg mein paani agya hai bohot tez! MM Alam Road band ho gaya. #LahoreFlood',
      'source': 'TWITTER',
      'event_type_hint': 'FLOOD',
      'location_hint': 'Gulberg, Lahore',
      'language': 'ROMAN URDU',
      'credibility_score': 89,
      'time_ago': '2m ago',
    },
    {
      'raw_text':
          'ALERT: Temperature in Jacobabad has crossed 52°C – highest in 2 years. Heat stroke cases surging.',
      'source': 'WEATHER',
      'event_type_hint': 'HEATWAVE',
      'location_hint': 'Jacobabad, Sindh',
      'language': 'ENGLISH',
      'credibility_score': 94,
      'time_ago': '5m ago',
    },
    {
      'raw_text':
          'Massive bushfire spreading across Blue Mountains. Smoke visible from Sydney CBD. Evacuations ordered.',
      'source': 'NEWS',
      'event_type_hint': 'WILDFIRE',
      'location_hint': 'Blue Mountains, NSW',
      'language': 'ENGLISH',
      'credibility_score': 92,
      'time_ago': '8m ago',
    },
    {
      'raw_text':
          'Power outage across downtown Houston. Traffic lights out on I-45. ERCOT investigating grid instability.',
      'source': 'TWITTER',
      'event_type_hint': 'INFRASTRUCTURE',
      'location_hint': 'Houston, Texas',
      'language': 'ENGLISH',
      'credibility_score': 76,
      'time_ago': '12m ago',
    },
    {
      'raw_text':
          '大阪で震度6強の地震発生。津波注意報発令中。 Translation: Strong earthquake in Osaka. Tsunami advisory issued.',
      'source': 'NEWS',
      'event_type_hint': 'EARTHQUAKE',
      'location_hint': 'Osaka, Japan',
      'language': 'JAPANESE',
      'credibility_score': 97,
      'time_ago': '1m ago',
    },
    {
      'raw_text':
          'Raat 2 baje DHA Phase 6 mein saans lena mushkil. AQI 480+. Bachon ko ghar mein rakhein. #LahoreSmog',
      'source': 'BLUESKY',
      'event_type_hint': 'AIR QUALITY',
      'location_hint': 'DHA, Lahore',
      'language': 'ROMAN URDU',
      'credibility_score': 83,
      'time_ago': '3m ago',
    },
    {
      'raw_text':
          'Heavy rainfall forecast for Karachi over next 48hrs. NDMA issues pre-emptive urban flooding advisory.',
      'source': 'WEATHER',
      'event_type_hint': 'FLOOD',
      'location_hint': 'Karachi, Sindh',
      'language': 'ENGLISH',
      'credibility_score': 88,
      'time_ago': '18m ago',
    },
    {
      'raw_text':
          'Petrópolis hill collapse after 3 days of rain. BR-040 blocked. Emergency services overwhelmed.',
      'source': 'NEWS',
      'event_type_hint': 'LANDSLIDE',
      'location_hint': 'Petrópolis, Brazil',
      'language': 'ENGLISH',
      'credibility_score': 85,
      'time_ago': '15m ago',
    },
    {
      'raw_text':
          'Canal Road pe traffic jam 3 ghante se! Koi rasta nahi. Police kahan hai? #LahoreTraffic',
      'source': 'TWITTER',
      'event_type_hint': 'TRAFFIC',
      'location_hint': 'Canal Road, Lahore',
      'language': 'ROMAN URDU',
      'credibility_score': 71,
      'time_ago': '25m ago',
    },
    {
      'raw_text':
          'Wind gusts of 120km/h detected near Katoomba. RFS upgrading fire danger to catastrophic.',
      'source': 'WEATHER',
      'event_type_hint': 'WILDFIRE',
      'location_hint': 'Katoomba, NSW',
      'language': 'ENGLISH',
      'credibility_score': 90,
      'time_ago': '10m ago',
    },
  ],
);
