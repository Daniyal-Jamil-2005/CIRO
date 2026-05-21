import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../theme.dart';
import '../../providers/app_state.dart';
import '../components/global_components.dart';
import 'crisis_detail_sheet.dart';
import '../../utils/crisis_display.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;

  final CameraPosition _globalPos = const CameraPosition(
    target: LatLng(20.0, 0.0),
    zoom: 2.5,
  );

  final CameraPosition _pakistanPos = const CameraPosition(
    target: LatLng(30.0, 70.0),
    zoom: 5.5,
  );

  void _toggleRegion() {
    final nextGlobal = !ref.read(regionProvider);
    ref.read(regionProvider.notifier).setGlobal(nextGlobal);
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(nextGlobal ? _globalPos : _pakistanPos),
    );
  }

  Set<Marker> _buildMarkers(List<Map<String, dynamic>> crises) {
    return crises
        .map((crisis) {
          final level = CrisisDisplay.severity(crisis);
          double hue = BitmapDescriptor.hueYellow;
          if (level == 'CRITICAL') hue = BitmapDescriptor.hueRed;
          if (level == 'HIGH') hue = BitmapDescriptor.hueOrange;
          if (level == 'RESOLVING' || level == 'RESOLVED')
            hue = BitmapDescriptor.hueGreen;

          final lat = (crisis['lat'] as num?)?.toDouble() ?? 0.0;
          final lng = (crisis['lng'] as num?)?.toDouble() ?? 0.0;
          if (lat == 0.0 && lng == 0.0) {
            return null;
          }

          return Marker(
            markerId: MarkerId(
              (crisis['crisis_id'] ?? crisis.hashCode.toString()).toString(),
            ),
            position: LatLng(lat, lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(hue),
            onTap: () => CrisisDetailSheet.show(context, crisis),
          );
        })
        .whereType<Marker>()
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final crisesList = ref.watch(crisesProvider);
    final isGlobal = ref.watch(regionProvider);
    return Scaffold(
      backgroundColor: CiroColors.creamBg,
      body: Stack(
        children: [
          // Background Real Map
          GoogleMap(
            initialCameraPosition: isGlobal ? _globalPos : _pakistanPos,
            trafficEnabled: true,
            buildingsEnabled: true,
            mapType: MapType.normal,
            markers: _buildMarkers(crisesList),
            onMapCreated: (controller) => _mapController = controller,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
          ),

          // Status Strip
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            right: 12,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: CiroColors.greyBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // LIVE Mode Indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBE2E2),
                          border: Border.all(color: const Color(0xFFF1C5C5)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: CiroColors.danger,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'LIVE',
                              style: TextStyle(
                                color: Color(0xFF8B2A2A),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Source Dots
                      const SourceDots(),
                      // Bell Icon
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            LucideIcons.bell,
                            size: 18,
                            color: CiroColors.greyDark,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: CiroColors.danger,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Toggle
                GestureDetector(
                  onTap: _toggleRegion,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: CiroColors.greyBorder),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: isGlobal
                                  ? CiroColors.navyLight
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.globe,
                                  size: 12,
                                  color: isGlobal
                                      ? Colors.white
                                      : CiroColors.greyText,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Global',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isGlobal
                                        ? Colors.white
                                        : CiroColors.greyText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: !isGlobal
                                  ? CiroColors.navyLight
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Pakistan',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: !isGlobal
                                    ? Colors.white
                                    : CiroColors.greyText,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Crisis Tiles
          if (crisesList.isNotEmpty)
            Positioned(
              left: 12,
              right: 12,
              bottom: 96,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: CiroTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Detected crises',
                          style: TextStyle(
                            fontSize: 10,
                            color: CiroColors.greyText,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                          ),
                        ),
                        Text(
                          '${crisesList.length} active',
                          style: const TextStyle(
                            fontSize: 10,
                            color: CiroColors.tealDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 96,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: crisesList.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final crisis = crisesList[index];
                          final severity = CrisisDisplay.severity(crisis);
                          final title = CrisisDisplay.title(crisis);
                          final location = CrisisDisplay.location(crisis);
                          final confidence = CrisisDisplay.confidence(crisis);
                          final typeLabel = CrisisDisplay.typeLabel(crisis);

                          return GestureDetector(
                            onTap: () =>
                                CrisisDetailSheet.show(context, crisis),
                            child: Container(
                              width: 245,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: CiroColors.greyBorder,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 34,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFBE2E2),
                                          borderRadius: BorderRadius.circular(
                                            11,
                                          ),
                                        ),
                                        child: CrisisIcon(
                                          type: typeLabel,
                                          size: 17,
                                          color: CiroColors.danger,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    title,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          CiroColors.navyText,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                SeverityBadge(level: severity),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              location,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: CiroColors.greyText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ConfBar(value: confidence),
                                  const SizedBox(height: 6),
                                  Text(
                                    CrisisDisplay.lastUpdated(crisis),
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: CiroColors.greyText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Dispatch FAB
          Positioned(
            right: 16,
            bottom: 160,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/dispatch'),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.radioTower,
                  color: CiroColors.tealDark,
                  size: 24,
                ),
              ),
            ),
          ),

          // Bottom Nav
          const BottomNav(active: 'Map'),
        ],
      ),
    );
  }
}
