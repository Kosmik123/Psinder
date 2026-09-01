import 'package:go_router/go_router.dart';

import '../features/map/presentation/map_screen.dart';

/// Central navigation config. Routes are added here as features land
/// (auth, friends, feed, chat).
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'map',
      builder: (context, state) => const MapScreen(),
    ),
  ],
);
