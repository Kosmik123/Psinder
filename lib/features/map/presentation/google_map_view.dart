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
    super.userLocation,
  });

  @override
  Widget build(BuildContext context) {
    // Once [userLocation] is non-null the app has already resolved the runtime
    // permission, so it is safe to switch on Google's native blue-dot layer
    // (and its recenter button).
    final hasLocation = userLocation != null;
    return gmaps.GoogleMap(
      initialCameraPosition: gmaps.CameraPosition(
        target: gmaps.LatLng(initialCamera.target.lat, initialCamera.target.lng),
        zoom: initialCamera.zoom,
      ),
      markers: pois.map(_toMarker).toSet(),
      myLocationEnabled: hasLocation,
      myLocationButtonEnabled: hasLocation,
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
