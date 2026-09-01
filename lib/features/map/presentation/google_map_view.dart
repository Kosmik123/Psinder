import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

import '../domain/poi.dart';
import 'map_view.dart';

/// [MapView] backed by Google Maps. Requires a Maps API key configured per
/// platform (Android manifest, iOS AppDelegate, web `index.html`).
class GoogleMapView extends MapView {
  const GoogleMapView({
    super.key,
    required super.initialCamera,
    required super.pois,
  });

  @override
  Widget build(BuildContext context) {
    return gmaps.GoogleMap(
      initialCameraPosition: gmaps.CameraPosition(
        target: gmaps.LatLng(initialCamera.target.lat, initialCamera.target.lng),
        zoom: initialCamera.zoom,
      ),
      markers: pois.map(_toMarker).toSet(),
      myLocationButtonEnabled: false,
    );
  }

  gmaps.Marker _toMarker(Poi poi) {
    return gmaps.Marker(
      markerId: gmaps.MarkerId(poi.id),
      position: gmaps.LatLng(poi.position.lat, poi.position.lng),
      infoWindow: gmaps.InfoWindow(title: poi.title, snippet: poi.description),
    );
  }
}
