# CIRO - Crisis Intelligence & Response Operations

A comprehensive crisis management platform combining real-time intelligence gathering, automated event detection, and coordinated response execution across mobile, backend, and web interfaces.

## Project Overview

CIRO is designed to detect, analyze, and respond to emerging crises in real-time. The system integrates:

- **Mobile App** (Flutter): Real-time crisis mapping, signal feed, and dispatch operations on iOS, Android, and web
- **Backend** (Python): Multi-stage agent pipeline for crisis extraction, detection, planning, and execution
- **External Integrations**: Social media polling, weather data feeds, and automated response dispatch
- **UI Framework**: Modern web interface for centralized monitoring (React/TypeScript/Vite)

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    CIRO System Architecture                 │
├─────────────────────────────────────────────────────────────┤
│  Frontend Layer                                             │
│  ├─ Flutter Mobile App (iOS/Android/Web)                   │
│  └─ React Web UI (Monitoring & Dashboards)                 │
├─────────────────────────────────────────────────────────────┤
│  Agent Pipeline (Python Backend)                            │
│  ├─ Agent 1: Extraction (Raw data ingestion)               │
│  ├─ Agent 2: Detection (Event classification)              │
│  ├─ Agent 3: Planning (Response strategy)                  │
│  └─ Agent 4: Execution (Dispatch & coordination)           │
├─────────────────────────────────────────────────────────────┤
│  Data Sources                                               │
│  ├─ Social Media Poller (Twitter, Reddit, etc.)            │
│  └─ Weather Poller (Real-time atmospheric data)            │
├─────────────────────────────────────────────────────────────┤
│  Data Store: Firebase Firestore                            │
│  └─ Crises, Signals, Tickets, Dispatch Records            │
└─────────────────────────────────────────────────────────────┘
```

## Project Structure

```
CIRO/
├── ciro_app/                    # Flutter mobile application
│   ├── lib/                     # Dart source code
│   │   ├── main.dart           # App entry point
│   │   ├── theme.dart          # Material Design 3 theming
│   │   ├── ui/                 # Screen & component widgets
│   │   ├── providers/          # Riverpod state management
│   │   ├── utils/              # Helpers (crisis display, formatting)
│   │   └── firebase_options.dart # Firebase config (generated)
│   ├── android/                # Android build configuration
│   ├── ios/                    # iOS build configuration
│   ├── web/                    # Web platform configuration
│   ├── assets/                 # Images, fonts, branding
│   └── pubspec.yaml           # Flutter dependencies
│
├── backend/                     # Python agent pipeline
│   ├── agents/                 # Multi-stage crisis processing
│   │   ├── agent_1_extraction/
│   │   ├── agent_2_detection/
│   │   ├── agent_3_planning/
│   │   └── agent_4_execution/
│   ├── pollers/               # External data ingestion
│   │   ├── social_poller/
│   │   └── weather_poller/
│   ├── requirements.txt       # Python dependencies
│   └── deploy_backend.ps1     # Deployment script
│
├── Ui/                        # React/TypeScript web interface
│   ├── src/
│   │   ├── main.tsx          # Web app entry
│   │   ├── app/              # Components & pages
│   │   └── styles/           # Global styling
│   ├── vite.config.ts        # Build configuration
│   └── package.json          # Node dependencies
│
├── Antigravity traces/        # Design specifications & documentation
│   ├── CIRO_Design_Spec.md   # UI/UX design guidelines
│   ├── CIRO_Project_Doc.md   # Technical architecture & schema
│   └── implementation_plan.md # Feature roadmap
│
└── .gitignore                # Git ignore rules
```

## Tech Stack

### Mobile (Flutter)
- **Framework**: Flutter 3.10+ for cross-platform (iOS, Android, Web)
- **State Management**: Riverpod 3.3+
- **Firebase**: Cloud Firestore for real-time data sync
- **Mapping**: Google Maps for crisis geo-visualization
- **UI**: Material Design 3 with custom Ciro theme
- **Icons**: Lucide Icons for consistent iconography

### Backend (Python)
- **Language**: Python 3.8+
- **API Framework**: Flask (configured for agent deployment)
- **Data Transfer**: JSON over REST
- **External APIs**: Twitter API, Weather API, Firebase Admin SDK
- **Scheduling**: APScheduler for poller tasks

### Web (React/TypeScript)
- **Framework**: React 18+ with TypeScript
- **Build Tool**: Vite for fast development
- **Styling**: PostCSS with custom design system
- **Component Library**: shadcn/ui patterns

## Getting Started

### Prerequisites
- Flutter SDK (3.10 or higher)
- Python 3.8+
- Firebase project with Firestore enabled
- Git

### Flutter Mobile App Setup

```bash
cd ciro_app
flutter pub get
flutter run
```

**Platform-Specific Setup:**

**Android:**
```bash
cd android
./gradlew build
```

**iOS:**
```bash
cd ios
pod install
open Runner.xcworkspace
```

**Web:**
```bash
flutter run -d chrome
```

See [ciro_app/README.md](ciro_app/README.md) for detailed mobile development instructions.

### Backend Setup

```bash
cd backend
pip install -r requirements.txt
python deploy_backend.ps1  # or invoke directly per agent
```

See [backend/README.md](backend/README.md) for agent pipeline details and API specifications.

### Web UI Setup

```bash
cd Ui
npm install
npm run dev
```

## Firebase Configuration

Before running the app, configure Firebase:

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable Firestore Database and Authentication
3. Add the configuration files:
   - **Android**: `ciro_app/android/app/google-services.json`
   - **iOS**: Upload to Firebase Console
   - **Web**: Environment variables or inline config

The app initializes Firebase automatically via `firebase_options.dart` (auto-generated).

## Data Schema

### Crisis Document (Firestore)
```dart
{
  "id": "string",
  "title": "string",
  "type": "FIRE | FLOOD | EARTHQUAKE | CYCLONE | LANDSLIDE | ...),
  "location": {"lat": double, "lng": double},
  "location_raw": "string",
  "severity": "LOW | MEDIUM | HIGH | CRITICAL",
  "confidence_score": double (0-100),
  "status": "ACTIVE | RESOLVED | MONITORING",
  "timestamp": DateTime,
  "description": "string (optional)",
  "response_plan": "string (JSON)",
  "affected_population": int,
  "last_updated": DateTime
}
```

See [CIRO_Project_Doc.md](Antigravity%20traces/CIRO_Project_Doc.md) for complete schema definitions.

## Development Workflow

### Making Changes

1. **Mobile**: Edit Dart files in `ciro_app/lib/`, then run `flutter run` or `flutter hot reload`
2. **Backend**: Edit Python files in `backend/agents/` or `backend/pollers/`
3. **Web**: Edit React components in `Ui/src/`, Vite watches for changes

### Building for Release

**Mobile APK (Android):**
```bash
cd ciro_app
flutter build apk --release
```

**Mobile App Bundle (Playstore):**
```bash
flutter build appbundle --release
```

**iOS (Archive):**
```bash
flutter build ios --release
```

**Web:**
```bash
cd Ui
npm run build
```

## Contributing

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Make your changes and test thoroughly
3. Commit with clear messages: `git commit -m "feat: add crisis detail pagination"`
4. Push and create a pull request

## Testing

### Mobile Tests
```bash
cd ciro_app
flutter test
```

### Backend Tests
```bash
cd backend
pytest
```

### Web Tests
```bash
cd Ui
npm test
```

## Known Issues & Future Work

- **Real-time sync**: Currently polling-based; consider WebSocket upgrade
- **Offline support**: Add local caching for crisis data when offline
- **Authentication**: Implement Firebase Auth UI (currently placeholder)
- **Analytics**: Add Mixpanel/Firebase Analytics for usage insights
- **Internationalization**: Support multiple languages (currently English-only)

## Documentation

- [Design Specifications](Antigravity%20traces/CIRO_Design_Spec.md) - UI/UX guidelines and mockups
- [Technical Architecture](Antigravity%20traces/CIRO_Project_Doc.md) - Database schema, APIs, integration points
- [Implementation Plan](Antigravity%20traces/implementation_plan.md) - Feature roadmap and milestone tracking
- [Walkthrough](Antigravity%20traces/walkthrough.md) - Step-by-step user and developer guides

## License

Proprietary - All rights reserved

## Contact & Support

- **Project Lead**: Daniyal Jamil
- **GitHub**: [@Daniyal-Jamil-2005](https://github.com/Daniyal-Jamil-2005)
- **Issues**: [GitHub Issues](https://github.com/Daniyal-Jamil-2005/CIRO/issues)

---

**Last Updated**: May 2026  
**Status**: Active Development
