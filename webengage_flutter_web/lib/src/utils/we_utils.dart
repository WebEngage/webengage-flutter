import 'dart:js_util' as js_util;

import 'package:webengage_flutter_platform_interface/webengage_flutter_platform_interface.dart';

import 'we_constants.dart';

Map<String, dynamic> convertJsObjectToMap(object) {
  if (object == null) {
    return {};
  }
  var dartObject = js_util.dartify(object);

  return (dartObject as Map).map((key, value) {
    return MapEntry(key.toString(), value as dynamic);
  }).cast<String, dynamic>();
}

class WEWebUtils {
  dynamic _webEngageInstance;
  Object? _window;
  bool _isLogPrintedFirstTime = false;

  // Private constructor
  WEWebUtils._privateConstructor();

  // Single shared instance
  static final WEWebUtils _instance = WEWebUtils._privateConstructor();

  // Factory constructor to return the singleton instance
  factory WEWebUtils() => _instance;

  /// Initializes the utility with the window object
  void init(Object window) {
    _window = window;
  }

  /// Retrieves or initializes the WebEngage instance
  dynamic getWebEngageInstance() {
    if (_webEngageInstance == null && _window != null) {
      _webEngageInstance = js_util.getProperty(_window!, WEB_WEBENGAGE);
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
