// Basic smoke test for the Psinder app.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:psinder_app/features/map/data/location_repository.dart';
import 'package:psinder_app/features/map/domain/geo_pos.dart';
import 'package:psinder_app/features/map/domain/location_service.dart';
import 'package:psinder_app/main.dart';

/// Never emits — keeps the map's location layer idle during widget tests
/// instead of hitting the real platform channel.
class _IdleLocationService implements LocationService {
  @override
  Stream<GeoPos> positionStream() => const Stream.empty();

  @override
  Future<GeoPos> currentPosition() => Completer<GeoPos>().future;
}

void main() {
  testWidgets('App renders the map screen with its app bar', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          locationServiceProvider.overrideWithValue(_IdleLocationService()),
        ],
        child: const PsinderApp(),
      ),
    );

    expect(find.text('Psinder — mapa'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });
}
