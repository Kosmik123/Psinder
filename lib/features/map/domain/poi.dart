import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A point of interest shown on the map.
///
/// Mirrors the planned Firestore `points/{pointId}` document
/// (lat, lng, title, description, imageUrl, createdBy). For now instances
/// are hard-coded; later they will be deserialized from Firestore.
class Poi {
  const Poi({
    required this.id,
    required this.title,
    required this.description,
    required this.position,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String description;
  final LatLng position;
  final String? imageUrl;

  Marker toMarker() {
    return Marker(
      markerId: MarkerId(id),
      position: position,
      infoWindow: InfoWindow(title: title, snippet: description),
    );
  }
}
