import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;
import 'package:webengage_flutter_platform_interface/webengage_flutter_platform_interface.dart';

import 'we_constants.dart';

Map<String, dynamic> convertJsObjectToMap(JSAny? object) {
  if (object == null) {
    return {};
  }
  final dartObject = object.dartify();
  if (dartObject is Map) {
    return dartObject.map((key, value) {
      return MapEntry(key.toString(), value as dynamic);
    }).cast<String, dynamic>();
  }
  return {};
}

class WEWebUtils {
  JSObject? _webEngageInstance;
  bool _initialized = false;
  bool _isLogPrintedFirstTime = false;

  // Private constructor
  WEWebUtils._privateConstructor();

  // Single shared instance
  static final WEWebUtils _instance = WEWebUtils._privateConstructor();

  // Factory constructor to return the singleton instance
  factory WEWebUtils() => _instance;

  /// Initializes the utility
  void init() {
    _initialized = true;
  }

  /// Retrieves or initializes the WebEngage instance
  JSObject? getWebEngageInstance() {
    if (_webEngageInstance == null && _initialized) {
      final jsWindow = web.window as JSObject;
      final instance = jsWindow[WEB_WEBENGAGE];
      if (instance != null) {
        _webEngageInstance = instance as JSObject;
      }
    }
    return _webEngageInstance;
  }

  /// Checks if WebEngage is properly configured
  bool isWebEngageAdded() {
    if (_webEngageInstance == null) {
      if (!_isLogPrintedFirstTime) {
        _isLogPrintedFirstTime = true;
        WELogger.e("WebEngage SDK is incorrectly configured.");
      }
      return false;
    }
    return true;
  }
}
