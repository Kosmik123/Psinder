import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;

import '../domain/poi.dart';
import 'map_view.dart';

/// [MapView] backed by OpenStreetMap raster tiles via `flutter_map`.
/// No API key required. Uses the public OSM tile server, which is fine for
/// development but must be swapped for a proper tile provider before release
/// (see the OSM tile usage policy).
class OsmMapView extends MapView {
  const OsmMapView({
    super.key,
    required super.initialCamera,
    required super.pois,
    super.userLocation,
  });

  @override
  Widget build(BuildContext context) {
    final location = userLocation;
    return FlutterMap(
      options: MapOptions(
        initialCenter: ll.LatLng(
          initialCamera.target.lat,
          initialCamera.target.lng,
        ),
        initialZoom: initialCamera.zoom,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tiles.openfreemap.org/natural_earth/ne2sr/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.mimal.psinder_app',
        ),
        if (location != null)
          MarkerLayer(
            markers: [
              Marker(
                point: ll.LatLng(location.lat, location.lng),
                width: 24,
                height: 24,
                child: const _MyLocationDot(),
              ),
            ],
          ),
        MarkerLayer(
          rotate: true,
          markers: pois.map(_toMarker).toList(),
        ),
      ],
    );
  }

  Marker _toMarker(Poi poi) {
    return Marker(
      point: ll.LatLng(poi.position.lat, poi.position.lng),
      width: 40,
      height: 40,
      alignment: Alignment.topCenter,
      child: Tooltip(
        message: '${poi.title}\n${poi.description}',
        child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
      ),
    );
  }
}

/// The familiar "current location" blue dot: a filled circle with a white
/// ring and a soft shadow so it stays legible over any map tile.
class _MyLocationDot extends StatelessWidget {
  const _MyLocationDot();

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF1A73E8);
    return Center(
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: blue,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 4, spreadRadius: 1),
          ],
        ),
      ),
    );
  }
}
