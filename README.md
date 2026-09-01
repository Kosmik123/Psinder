# psinder_app

Mobilna aplikacja Flutter — interaktywna mapa społecznościowa z punktami zainteresowań (POI).

## Stan projektu

Etap 1 (obecny): klient startowy. Po uruchomieniu wyświetla się pełnoekranowa mapa
Google wycentrowana na Krakowie z 3 hard-kodowanymi pinezkami restauracji.

Kolejne etapy: Firebase (Auth, Firestore, Storage, Messaging), role admin/user,
znajomi, posty, czat 1:1.

## Stack

- Flutter + Dart, state management: **Riverpod** (`flutter_riverpod`)
- Nawigacja: **go_router**
- Mapy: **google_maps_flutter** (docelowo + geoflutterfire2 do zapytań geograficznych)
- Backend (później): Firebase

## Struktura `lib/`

```
lib/
  main.dart                       # ProviderScope + MaterialApp.router
  app/router.dart                 # konfiguracja go_router
  features/
    map/
      domain/poi.dart             # model POI (odpowiednik points/{pointId})
      data/poi_repository.dart     # poiListProvider — na razie dane hard-kodowane
      presentation/map_screen.dart # ekran startowy z GoogleMap
```

## Konfiguracja klucza Google Maps

Klucz nie jest trzymany w repo. 

**Android:** w `android/local.properties` (plik jest w `.gitignore`) dodaj:

```
MAPS_API_KEY=twoj_klucz_api
```

`build.gradle.kts` wstrzykuje go do `AndroidManifest.xml` przez `manifestPlaceholders`.

**iOS:** w `ios/Runner/AppDelegate.swift` dodaj `import GoogleMaps` oraz
`GMSServices.provideAPIKey("twoj_klucz_api")` w `didFinishLaunchingWithOptions`
(najlepiej czytając klucz z pliku spoza repo lub z `.xcconfig`).

**Web:** w `web/index.html` podmień `YOUR_GOOGLE_MAPS_API_KEY` w tagu
`<script src="https://maps.googleapis.com/maps/api/js?key=...">`. Klucz jest
widoczny w kodzie klienta — ogranicz go przez **HTTP referrer** w Cloud Console.

Klucz API musi mieć włączone odpowiednie API w Google Cloud Console:
**Maps SDK for Android**, **Maps SDK for iOS**, **Maps JavaScript API** (web).

## Uruchomienie

```
flutter pub get
flutter run
```
