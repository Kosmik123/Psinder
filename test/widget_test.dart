// Basic smoke test for the Psinder app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:psinder_app/main.dart';

void main() {
  testWidgets('App renders the map screen with its app bar', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PsinderApp()));

    expect(find.text('Psinder — mapa'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });
}
