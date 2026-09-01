import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../domain/poi.dart';

/// Camera position the map opens at: the Main Square in Kraków, Poland.
const CameraPosition kKrakowInitialCamera = CameraPosition(
  target: LatLng(50.06143, 19.93658),
  zoom: 14,
);

/// Hard-coded seed data — three real restaurants in Kraków.
///
/// This stands in for the Firestore `points` collection until the backend
/// exists. Keep the shape identical to [Poi] so swapping the source later
/// is a drop-in change.
const List<Poi> _krakowRestaurants = [
  Poi(
    id: 'wierzynek',
    title: 'Restauracja Wierzynek',
    description: 'Rynek Główny 16 — historyczna restauracja polskiej kuchni.',
    position: LatLng(50.06153, 19.93770),
  ),
  Poi(
    id: 'miod-malina',
    title: 'Miód Malina',
    description: 'ul. Grodzka 40 — kuchnia polska i śródziemnomorska.',
    position: LatLng(50.05625, 19.93843),
  ),
  Poi(
    id: 'starka',
    title: 'Starka Restaurant & Vodka Bar',
    description: 'ul. Józefa 14, Kazimierz — kuchnia polska i domowe nalewki.',
    position: LatLng(50.04907, 19.94520),
  ),
];

/// Source of POIs displayed on the map.
///
/// Today it returns the hard-coded list; later this provider will be
/// overridden with a Firestore-backed implementation (radius queries via
/// geoflutterfire2).
final poiListProvider = Provider<List<Poi>>((ref) => _krakowRestaurants);
