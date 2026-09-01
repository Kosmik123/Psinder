# psinder_app

Mobilna aplikacja Flutter — interaktywna mapa społecznościowa z punktami zainteresowań (POI).

## Stan projektu

Etap 1 (obecny): klient startowy. Po uruchomieniu wyświetla się pełnoekranowa mapa
wycentrowana na Krakowie z 3 hard-kodowanymi pinezkami restauracji.

Warstwa mapy jest **polimorficzna**: jeden interfejs `MapView`, dwie implementacje —
OpenStreetMap (domyślna, bez klucza) oraz Google Maps (wymaga klucza API).

Kolejne etapy: Firebase (Auth, Firestore, Storage, Messaging), role admin/user,
znajomi, posty, czat 1:1.

## Stack

- Flutter + Dart, state management: **Riverpod** (`flutter_riverpod`)
- Nawigacja: **go_router**
- Mapy: **flutter_map** (OpenStreetMap) + **google_maps_flutter** za wspólnym
  interfejsem; docelowo + geoflutterfire2 do zapytań geograficznych
- Backend (później): Firebase

## Struktura `lib/`

```
lib/
  main.dart                          # ProviderScope + MaterialApp.router
  app/router.dart                    # konfiguracja go_router
  features/
    map/
      domain/
        geo_pos.dart                 # GeoPos, MapCamera — typy neutralne wobec backendu
        poi.dart                     # model POI (odpowiednik points/{pointId})
      data/poi_repository.dart       # poiListProvider, kKrakowInitialCamera — dane hard-kodowane
      presentation/
        map_view.dart                # abstract MapView + MapView.forBackend() + mapBackendProvider
        osm_map_view.dart            # implementacja OpenStreetMap (flutter_map)
        google_map_view.dart         # implementacja Google Maps (google_maps_flutter)
        map_screen.dart              # ekran startowy — wybiera implementację wg mapBackendProvider
```

## Wybór backendu mapy

Domyślnie `MapBackend.osm` — działa bez żadnej konfiguracji. Aby przełączyć na
Google Maps, nadpisz `mapBackendProvider`:

```dart
ProviderScope(
  overrides: [mapBackendProvider.overrideWithValue(MapBackend.google)],
  child: const PsinderApp(),
)
```

## Konfiguracja klucza Google Maps (potrzebna tylko dla `MapBackend.google`)

Klucz nie jest trzymany w repo.

**Android:** w `android/local.properties` (plik jest w `.gitignore`) dodaj:

```
MAPS_API_KEY=twoj_klucz_api
```

`build.gradle.kts` wstrzykuje go do `AndroidManifest.xml` przez `manifestPlaceholders`.

**iOS:** w `ios/Runner/AppDelegate.swift` dodaj `import GoogleMaps` oraz
`GMSServices.provideAPIKey("twoj_klucz_api")` w `didFinishLaunchingWithOptions`.

**Web:** w `web/index.html` odkomentuj tag `<script src="https://maps.googleapis.com/maps/api/js?key=...">`
i podmień `YOUR_GOOGLE_MAPS_API_KEY`. Klucz jest widoczny w kodzie klienta —
ogranicz go przez **HTTP referrer** w Cloud Console.

Klucz API musi mieć włączone odpowiednie API w Google Cloud Console:
**Maps SDK for Android**, **Maps SDK for iOS**, **Maps JavaScript API** (web).

## Uruchomienie

```
flutter pub get
flutter run
```
