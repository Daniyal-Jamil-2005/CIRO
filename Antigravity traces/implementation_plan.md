# CIRO Flutter App Implementation Plan

This document outlines the plan to build the CIRO Flutter application based on your `CIRO_Design_Spec.md`, `CIRO_Project_Doc.md`, and the React mock in the `Ui` folder.

## User Review Required

> [!IMPORTANT]  
> Please review this plan before I begin writing the Flutter code. Once approved, I will initialize the Flutter project and start implementing the screens. 

#### [MODIFY] `lib/ui/screens/map_screen.dart`
- Convert from `StatelessWidget` to a `ConsumerStatefulWidget`.
- Replace the mock `MapBg` and `Pin` widgets with the real `GoogleMap` widget.
- **Real-time Map Layers**: Since you have the APIs enabled, we will turn on `trafficEnabled: true` to natively display Google's real-time red/yellow/green traffic congestion lines across the globe! We will also enable `buildingsEnabled: true` to leverage the 3D map data.
- Implement `crisesStreamProvider` listener to fetch real-time crisis documents from Firestore.
- Map the crises to `Marker` objects. These simulated AI markers will drop directly on top of the real map and real traffic data, creating a perfect hybrid demo. Color-code them based on severity using `BitmapDescriptor.defaultMarkerWithHue`.

## Open Questions

1. Do you want me to initialize the Flutter project with a specific state management solution (e.g., Riverpod, Provider, or simply stateful widgets for the mock phase)? Riverpod is highly recommended for scalability.
2. Are you comfortable with me placing the new Flutter project at `f:/Work/CIRO by daniyal/ciro_app`?
3. The React mock uses `lucide-react` icons. Should I use the `lucide_icons` package in Flutter, or stick to standard Material/Cupertino icons?
4. I will create a copy of all artifacts (like this plan and task lists) in the `Antigravity traces` folder as requested. Does that sound good?

## Proposed Changes

### Project Setup
- **Initialize Flutter App:** Run `flutter create ciro_app --org com.ciro` in the root workspace directory.
- **Dependencies:** Add essential packages like `lucide_icons`, `flutter_animate` (for animations mentioned in the design spec), `google_maps_flutter` (for the map), and `flutter_riverpod` (if you approve).

### Architecture & Components
- **`lib/theme.dart`**: Define the specific color palette (Navy, Cream, Tan, Teal, etc.) derived from the React mock inline styles.
- **`lib/ui/components/`**: Reusable global components:
  - `BottomNav`, `TopBar`
  - `SeverityBadge`, `CrisisIcon`, `ConfBar`
  - `MapBg` (A custom painter or SVG wrapper for the mock background before using real Google Maps)
  - `Pin` (Map marker UI)
  - `Chip`, `TanButton`

### Screen Implementation
I will systematically recreate the 12 screens from the React mock into Flutter, maintaining the exact visual hierarchy and animations:
- `S1Onboarding`: PageView with illustrations and dots.
- `S2Map`: Map background, custom Pins, Status Bar Strip, and Floating Action Button.
- `S3Detail`: DraggableScrollableSheet for crisis details.
- `S4DeepDive`: Full crisis analysis screen.
- `S5Feed`: Live signal feed list.
- `S6Trace`: Agent execution graph and timeline.
- `S7Analytics`: BigQuery statistics dashboard.
- `S8Report`, `S9Notifications`, `S10Settings`, `S11Sim`, `S12More`.

## Verification Plan

### Automated Tests
- Build the Flutter project (`flutter build apk --debug`) to ensure it compiles without errors.

### Manual Verification
- Run the app on the Android emulator to visually verify the layout, animations, and transitions.
- Verify that the bottom navigation works seamlessly between screens.
- Check the draggable behavior of the Crisis Detail Sheet (S3).
