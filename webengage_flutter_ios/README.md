# webengage_flutter_ios

The iOS platform implementation of the [WebEngage Flutter SDK](https://github.com/WebEngage/webengage-flutter).

## Overview

This package is part of the WebEngage Flutter federated plugin architecture. It provides the iOS-specific implementation for user management, event tracking, push notifications, in-app messaging, and SDK security.

You should not need to add this package directly — it is automatically included when you add [`webengage_flutter`](https://pub.dev/packages/webengage_flutter) to your project.

## Requirements

- iOS 13.0+
- WebEngage iOS SDK 6.10.0+
- Flutter 3.0.0+

## Integration

This plugin supports both **CocoaPods** and **Swift Package Manager** for iOS dependency management.

### CocoaPods

No additional setup needed. The plugin's podspec declares the `WebEngage/Core` dependency automatically.

### Swift Package Manager

SPM support is included via `Package.swift`. Flutter will resolve the `webengage-ios-sdk` package automatically.

## Location Support

Location functionality has been moved to a separate plugin. If you need location tracking, add:

```yaml
dependencies:
  webengage_flutter_location: ^1.0.0
```

## License

See [LICENSE](LICENSE) for details.
