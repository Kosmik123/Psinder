import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/geo_pos.dart';
import '../domain/poi.dart';
import 'google_map_view.dart';
import 'osm_map_view.dart';

/// Which map rendering backend to use.
enum MapBackend {
  /// Google Maps (`google_maps_flutter`). Needs an API key on every platform.
  google,

  /// OpenStreetMap tiles via `flutter_map`. No API key required.
  openStreetMap,
}

/// Selects the active map backend.
///
/// Defaults to [MapBackend.openStreetMap] so the app runs with zero configuration.
/// Override this provider (e.g. in `ProviderScope.overrides`) to switch to
/// Google Maps once a key is wired up.
final mapBackendProvider = Provider<MapBackend>((ref) => MapBackend.openStreetMap);

/// One interface, many implementations.
///
/// A [MapView] is a widget that renders [pois] on an interactive map framed
/// by [initialCamera]. Concrete subclasses ([GoogleMapView], [OsmMapView])
/// own all provider-specific types and conversions; callers depend only on
/// this class and the backend-neutral [Poi] / [MapCamera] models.
abstract class MapView extends StatelessWidget {
  const MapView({
    super.key,
    required this.initialCamera,
    required this.pois,
  });

  final MapCamera initialCamera;
  final List<Poi> pois;

  /// Builds the concrete [MapView] for [backend].
  factory MapView.forBackend(
    MapBackend backend, {
    Key? key,
    required MapCamera initialCamera,
    required List<Poi> pois,
  }) {
    switch (backend) {
      case MapBackend.google:
        return GoogleMapView(
          key: key,
          initialCamera: initialCamera,
          pois: pois,
        );
      case MapBackend.openStreetMap:
        return OsmMapView(
          key: key,
          initialCamera: initialCamera,
          pois: pois,
        );
    }
  }
}
