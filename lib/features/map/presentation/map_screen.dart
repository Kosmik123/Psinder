import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/poi_repository.dart';
import 'map_view.dart';

/// The app's landing screen: a full-screen map with POI pins.
///
/// The concrete map implementation (Google / OSM) is resolved from
/// [mapBackendProvider], so this screen stays provider-agnostic.
class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backend = ref.watch(mapBackendProvider);
    final pois = ref.watch(poiListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Psinder — mapa')),
      body: MapView.forBackend(
        backend,
        initialCamera: kKrakowInitialCamera,
        pois: pois,
      ),
    );
  }
}
