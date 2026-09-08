import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/location_repository.dart';
import '../data/poi_repository.dart';
import '../domain/location_service.dart';
import 'map_view.dart';

/// The app's landing screen: a full-screen map with POI pins and the user's
/// current location.
///
/// The concrete map implementation (Google / OSM) is resolved from
/// [mapBackendProvider], so this screen stays provider-agnostic.
class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backend = ref.watch(mapBackendProvider);
    final pois = ref.watch(poiListProvider);
    final location = ref.watch(currentLocationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Psinder — mapa')),
      body: Stack(
        children: [
          MapView.forBackend(
            backend,
            initialCamera: kKrakowInitialCamera,
            pois: pois,
            userLocation: location.asData?.value,
          ),
          if (location.hasError)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _LocationNotice(error: location.error!),
            ),
        ],
      ),
    );
  }
}

/// Non-blocking banner explaining why the blue dot is missing.
class _LocationNotice extends StatelessWidget {
  const _LocationNotice({required this.error});

  final Object error;

  String get _message {
    if (error is! LocationException) {
      return 'Nie udało się ustalić Twojej lokalizacji.';
    }
    switch ((error as LocationException).reason) {
      case LocationUnavailable.serviceDisabled:
        return 'Włącz usługi lokalizacji, aby zobaczyć swoją pozycję na mapie.';
      case LocationUnavailable.permissionDenied:
        return 'Psinder potrzebuje dostępu do lokalizacji, aby pokazać Twoją '
            'pozycję na mapie.';
      case LocationUnavailable.permissionDeniedForever:
        return 'Dostęp do lokalizacji jest zablokowany. Włącz go w ustawieniach '
            'systemu.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      color: scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.location_off, color: scheme.onSurfaceVariant, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _message,
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
