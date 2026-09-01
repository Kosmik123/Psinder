import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/poi_repository.dart';

/// The app's landing screen: a full-screen Google Map with POI pins.
class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pois = ref.watch(poiListProvider);
    final markers = pois.map((poi) => poi.toMarker()).toSet();

    return Scaffold(
      appBar: AppBar(title: const Text('Psinder — mapa')),
      body: GoogleMap(
        initialCameraPosition: kKrakowInitialCamera,
        markers: markers,
        myLocationButtonEnabled: false,
      ),
    );
  }
}
