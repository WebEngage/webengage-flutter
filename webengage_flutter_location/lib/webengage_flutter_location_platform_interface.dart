import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'webengage_flutter_location_method_channel.dart';

/// Platform interface for webengage_flutter_location.
///
/// This plugin is dependency-only (it pulls in the WebEngage Location SDK
/// via SPM). No platform methods are defined.
abstract class WeLocationFlutterPlatform extends PlatformInterface {
  WeLocationFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static WeLocationFlutterPlatform _instance = MethodChannelWeLocationFlutter();

  static WeLocationFlutterPlatform get instance => _instance;

  static set instance(WeLocationFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}
