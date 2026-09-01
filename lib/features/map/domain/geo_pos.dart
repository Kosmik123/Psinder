/// Backend-neutral geographic position.
///
/// The app never passes a provider-specific coordinate type (Google's
/// `LatLng`, latlong2's `LatLng`, …) across feature boundaries — only this.
/// Each [map view implementation] converts at its own edge.
class GeoPos {
  const GeoPos(this.lat, this.lng);

  final double lat;
  final double lng;

  @override
  bool operator ==(Object other) =>
      other is GeoPos && other.lat == lat && other.lng == lng;

  @override
  int get hashCode => Object.hash(lat, lng);

  @override
  String toString() => 'GeoPos($lat, $lng)';
}

/// Backend-neutral initial camera framing for a map.
class MapCamera {
  const MapCamera({required this.target, required this.zoom});

  final GeoPos target;
  final double zoom;
}
