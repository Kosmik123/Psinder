import 'geo_pos.dart';

/// Why the app cannot show the user's location.
enum LocationUnavailable {
  /// Device-wide location services are turned off.
  serviceDisabled,

  /// The user declined the runtime permission prompt (can be asked again).
  permissionDenied,

  /// Permission is denied permanently — the user must enable it in settings.
  permissionDeniedForever,
}

/// Raised by a [LocationService] when a position cannot be obtained.
class LocationException implements Exception {
  const LocationException(this.reason);

  final LocationUnavailable reason;

  @override
  String toString() => 'LocationException($reason)';
}

/// Backend-neutral access to the device's location.
///
/// Implementations live in the data layer and own every plugin-specific type
/// (`geolocator`'s `Position`, `LocationPermission`, …). Callers depend only on
/// [GeoPos] and [LocationException], mirroring how [MapView] keeps map-provider
/// types out of the rest of the app.
abstract interface class LocationService {
  /// Resolves service + permission state, then emits the device position
  /// every time it moves far enough to matter.
  ///
  /// Emits a [LocationException] as a stream error if a fix is unavailable.
  Stream<GeoPos> positionStream();

  /// One-shot current position. Throws [LocationException] on failure.
  Future<GeoPos> currentPosition();
}
