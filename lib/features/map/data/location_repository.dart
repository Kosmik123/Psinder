import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../domain/geo_pos.dart';
import '../domain/location_service.dart';

/// [LocationService] backed by the `geolocator` plugin.
///
/// Works on Android, iOS, web and Windows with no extra wiring beyond the
/// per-platform permission strings (Android manifest, iOS `Info.plist`).
class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService();

  static const LocationSettings _settings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10, // metres of movement before a new fix is emitted
  );

  /// Throws [LocationException] unless services are on and permission granted.
  Future<void> _ensureUsable() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException(LocationUnavailable.serviceDisabled);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    switch (permission) {
      case LocationPermission.denied:
        throw const LocationException(LocationUnavailable.permissionDenied);
      case LocationPermission.deniedForever:
        throw const LocationException(
          LocationUnavailable.permissionDeniedForever,
        );
      case LocationPermission.whileInUse:
      case LocationPermission.always:
      case LocationPermission.unableToDetermine:
        return;
    }
  }

  @override
  Future<GeoPos> currentPosition() async {
    await _ensureUsable();
    final position = await Geolocator.getCurrentPosition(
      locationSettings: _settings,
    );
    return GeoPos(position.latitude, position.longitude);
  }

  @override
  Stream<GeoPos> positionStream() async* {
    await _ensureUsable();
    yield* Geolocator.getPositionStream(locationSettings: _settings)
        .map((p) => GeoPos(p.latitude, p.longitude));
  }
}

/// The app's active [LocationService]. Override in `ProviderScope.overrides`
/// (e.g. a fake in widget tests).
final locationServiceProvider = Provider<LocationService>(
  (ref) => const GeolocatorLocationService(),
);

/// Live device location for the map.
///
/// `null` (loading) until the first fix arrives; a [LocationException] surfaces
/// as [AsyncValue.error] so the UI can explain why the blue dot is missing.
final currentLocationProvider = StreamProvider<GeoPos>((ref) {
  return ref.watch(locationServiceProvider).positionStream();
});
