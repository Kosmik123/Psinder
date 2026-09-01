import 'geo_pos.dart';

/// A point of interest shown on the map.
///
/// Mirrors the planned Firestore `points/{pointId}` document
/// (lat, lng, title, description, imageUrl, createdBy). For now instances
/// are hard-coded; later they will be deserialized from Firestore.
///
/// Deliberately free of any map-provider types — rendering a [Poi] as a
/// Google marker or a flutter_map marker is the job of the concrete
/// `MapView` implementation.
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
  final GeoPos position;
  final String? imageUrl;
}
