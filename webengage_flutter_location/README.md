# webengage_flutter_location

A dependency-only Flutter plugin that adds the [WebEngage Location SDK](https://github.com/WebEngage/webengage-ios-sdk) to your iOS app via Swift Package Manager.

## Overview

This plugin does not expose any Dart API. Its sole purpose is to include the `WebEngageLocation` native module in your iOS build. Once added, the WebEngage SDK handles location tracking automatically.

## Installation

Add the plugin to your `pubspec.yaml`:

```yaml
dependencies:
  webengage_flutter_location: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Requirements

- iOS 13.0+
- WebEngage iOS SDK 6.10.0+

## License

See [LICENSE](LICENSE) for details.
