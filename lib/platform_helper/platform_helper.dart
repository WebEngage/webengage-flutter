/// Platform-specific helper for native method channel communication.
/// Handles WebEngage SDK initialization on native platforms (iOS/Android).
import 'package:flutter/services.dart';

/// Singleton helper class for platform channel communication.
class PlatformHelper {
  /// Private constructor for singleton pattern.
  PlatformHelper._privateConstructor();

  /// Static instance of the class.
  static final PlatformHelper _instance = PlatformHelper._privateConstructor();

  /// Factory constructor returns singleton instance.
  factory PlatformHelper() {
    return _instance;
  }

  /// Method channel for Flutter-Native communication.
  static const platform = MethodChannel('flutter_method_channel');

  /// Initializes WebEngage SDK on native platform.
  /// 
  /// [licenseCode] - WebEngage license code for the region.
  /// [env] - Environment identifier (US, IN, KSA).
  Future<void> initWebEngage(String licenseCode, String env) async {
    print("$licenseCode $env");
    try {
      final result = await platform.invokeMethod('initWebEngage', {
        'licenseCode': licenseCode,
        'env': env,
      });
    } catch (e) {
      print("Init error: $e");
    }
  }

  /// Clears stored region data from native platform.
  Future<void> clearData() async {
    try {
      final result = await platform.invokeMethod('clearData');
    } catch (e) {
      print("clearData: $e");
    }
  }
}
