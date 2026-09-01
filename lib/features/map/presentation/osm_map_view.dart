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
  });

  @override
  Widget build(BuildContext context) {
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
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.mimal.psinder_app',
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
