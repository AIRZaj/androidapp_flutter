# Książka adresowa UAM Fizyka

## Projekt na zajęcia "Programowanie aplikacji Mobilnych"

Grupa: [Szymon](https://github.com/SzymonNadbrzezny), [Jakub](https://www.github.com/jaknie10), [Patryk](https://github.com/patchaq), [Rafał](https://github.com/RafalKiljan)

## Building the App

### Prerequisites

- Flutter SDK (version 3.19.0 or higher)
- Android Studio
- JDK 17

### Local Build

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter build apk --release` to create a release APK

### GitHub Release

The app is automatically built and released when a new tag is pushed to the repository.

To create a new release:

1. Update the version in `pubspec.yaml`
2. Create and push a new tag:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
3. The GitHub Action will automatically build and create a new release with the APK

## Features

- Address book
- News feed
- Interactive map
- Author information
