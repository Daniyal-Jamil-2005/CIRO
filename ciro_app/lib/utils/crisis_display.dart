String? _cleanText(dynamic value) {
  final text = value?.toString().trim();
  if (text == null || text.isEmpty || text.toLowerCase() == 'null') {
    return null;
  }
  return text;
}

String _headlineCase(String value) {
  return value
      .toLowerCase()
      .split(RegExp(r'[_\s-]+'))
      .where((part) => part.isNotEmpty)
      .map((part) => part[0].toUpperCase() + part.substring(1))
      .join(' ');
}

class CrisisDisplay {
  static const Map<String, String> _typeLabels = {
    'FLOOD': 'Flash Flood',
    'FIRE': 'Fire',
    'ROAD_BLOCKAGE': 'Road Blockage',
    'HEATWAVE': 'Heatwave',
    'ACCIDENT': 'Accident',
    'EARTHQUAKE': 'Earthquake',
    'LANDSLIDE': 'Landslide',
    'STORM': 'Storm',
    'INFRASTRUCTURE_FAILURE': 'Infrastructure Failure',
    'UNKNOWN': 'Unknown Event',
  };

  static String typeCode(Map<String, dynamic> crisis) {
    final direct = _normalizeType(
      _cleanText(crisis['type']) ??
          _cleanText(crisis['event_type']) ??
          _cleanText(crisis['event_type_hint']) ??
          _cleanText(crisis['extracted_event']) ??
          _cleanText(crisis['crisis_type']),
    );
    if (direct != null) {
      return direct;
    }

    final title = _cleanText(crisis['title']);
    final inferred = _inferFromText(title);
    return inferred ?? 'UNKNOWN';
  }

  static String typeLabel(Map<String, dynamic> crisis) {
    final code = typeCode(crisis);
    return _typeLabels[code] ?? _headlineCase(code);
  }

  static String title(Map<String, dynamic> crisis) {
    final title = _cleanText(crisis['title']);
    if (title != null) {
      return title;
    }
    return typeLabel(crisis);
  }

  static String location(Map<String, dynamic> crisis) {
    final direct = _cleanText(crisis['location']) ?? _cleanText(crisis['location_raw']) ?? _cleanText(crisis['location_hint']);
    if (direct != null) {
      return direct;
    }

    final district = _cleanText(crisis['district']);
    final city = _cleanText(crisis['city']);
    final country = _cleanText(crisis['country']);

    final pieces = <String>[
      if (district != null) district,
      if (city != null && city != district) city,
      if (country != null && country.toUpperCase() != 'PK' && country.toUpperCase() != 'PAKISTAN') country,
    ];

    if (pieces.isNotEmpty) {
      return pieces.join(', ');
    }

    return 'Unknown Location';
  }

  static String status(Map<String, dynamic> crisis) {
    return _cleanText(crisis['status']) ?? 'ACTIVE';
  }

  static String severity(Map<String, dynamic> crisis) {
    return (_cleanText(crisis['severity']) ?? 'MEDIUM').toUpperCase();
  }

  static int confidence(Map<String, dynamic> crisis) {
    final raw = crisis['confidence_score'] ?? crisis['confidence'] ?? crisis['base_confidence_score'];
    if (raw is num) {
      return raw.round().clamp(0, 100);
    }

    final parsed = int.tryParse(_cleanText(raw) ?? '');
    return (parsed ?? 0).clamp(0, 100);
  }

  static String lastUpdated(Map<String, dynamic> crisis) {
    return _cleanText(crisis['last_updated']) ?? _cleanText(crisis['updated_at']) ?? _cleanText(crisis['created_at']) ?? 'just now';
  }

  static String summary(Map<String, dynamic> crisis) {
    return '${location(crisis)} · ${typeLabel(crisis)}';
  }

  static String? _normalizeType(String? raw) {
    final text = raw?.toUpperCase().trim();
    if (text == null || text.isEmpty) {
      return null;
    }

    const aliases = <String, String>{
      'WILDFIRE': 'FIRE',
      'BUSHFIRE': 'FIRE',
      'FIRE': 'FIRE',
      'FLOOD': 'FLOOD',
      'FLASH FLOOD': 'FLOOD',
      'HEAT': 'HEATWAVE',
      'HEATWAVE': 'HEATWAVE',
      'ROAD': 'ROAD_BLOCKAGE',
      'TRAFFIC': 'ROAD_BLOCKAGE',
      'BLOCKAGE': 'ROAD_BLOCKAGE',
      'ROAD_BLOCKAGE': 'ROAD_BLOCKAGE',
      'ACCIDENT': 'ACCIDENT',
      'CRASH': 'ACCIDENT',
      'COLLISION': 'ACCIDENT',
      'EARTHQUAKE': 'EARTHQUAKE',
      'QUAKE': 'EARTHQUAKE',
      'LANDSLIDE': 'LANDSLIDE',
      'STORM': 'STORM',
      'CYCLONE': 'STORM',
      'HURRICANE': 'STORM',
      'TYPHOON': 'STORM',
      'INFRASTRUCTURE': 'INFRASTRUCTURE_FAILURE',
      'INFRASTRUCTURE_FAILURE': 'INFRASTRUCTURE_FAILURE',
      'POWER': 'INFRASTRUCTURE_FAILURE',
      'GRID': 'INFRASTRUCTURE_FAILURE',
      'OUTAGE': 'INFRASTRUCTURE_FAILURE',
      'UNKNOWN': 'UNKNOWN',
    };

    if (aliases.containsKey(text)) {
      return aliases[text];
    }

    for (final entry in aliases.entries) {
      if (text.contains(entry.key)) {
        return entry.value;
      }
    }

    return null;
  }

  static String? _inferFromText(String? text) {
    final value = text?.toUpperCase();
    if (value == null || value.isEmpty) {
      return null;
    }

    const keywords = [
      ('FLOOD', 'FLOOD'),
      ('WATER', 'FLOOD'),
      ('PANI', 'FLOOD'),
      ('FIRE', 'FIRE'),
      ('BUSHFIRE', 'FIRE'),
      ('WILDFIRE', 'FIRE'),
      ('HEAT', 'HEATWAVE'),
      ('ROAD', 'ROAD_BLOCKAGE'),
      ('TRAFFIC', 'ROAD_BLOCKAGE'),
      ('ACCIDENT', 'ACCIDENT'),
      ('CRASH', 'ACCIDENT'),
      ('EARTHQUAKE', 'EARTHQUAKE'),
      ('QUAKE', 'EARTHQUAKE'),
      ('LANDSLIDE', 'LANDSLIDE'),
      ('STORM', 'STORM'),
      ('CYCLONE', 'STORM'),
      ('POWER', 'INFRASTRUCTURE_FAILURE'),
      ('GRID', 'INFRASTRUCTURE_FAILURE'),
      ('OUTAGE', 'INFRASTRUCTURE_FAILURE'),
    ];

    for (final entry in keywords) {
      if (value.contains(entry.$1)) {
        return entry.$2;
      }
    }

    return null;
  }
}