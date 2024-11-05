import 'dart:js_util' as js_util;

import 'package:webengage_flutter_platform_interface/webengage_flutter_platform_interface.dart';
import 'package:webengage_flutter_web/src/utils/we_constants.dart';

import '../../webengage_flutter_web.dart';

extension WEWebExtension on WEFlutterWeb {
  Future<void> performUserAction(String action, dynamic args) async {
    user = js_util.getProperty(webengage, WEB_METHOD_NAME_USER);
    if (user != null) {
      try {
        if (args is! List) {
          args = [args]; // Wrap it in a list if it's not a list
        }
        js_util.callMethod(user, action, args);
      } catch (e) {
        WELogger.e("Error calling $action: $e");
      }
    } else {
      WELogger.e("User object is null.");
    }
    return Future.value();
  }

  Future<void> performUserAttributeAction(dynamic args) async {
    var action = WEB_METHOD_NAME_SET_ATTRIBUTE;
    user = js_util.getProperty(webengage, WEB_METHOD_NAME_USER);
    if (user != null) {
      try {
        if (args is! List) {
          args = [args];
        }
        js_util.callMethod(user, action, args);
      } catch (e) {
        WELogger.e("Error calling $action: $e");
      }
    } else {
      WELogger.e("User object is null.");
    }
    return Future.value();
  }

  Future<void> performTrackEvent(String eventName, dynamic eventData) async {
    var action = WEB_METHOD_NAME_TRACK;
    if (webengage != null) {
      try {
        if (eventData != null) {
          var jsEventData = js_util.jsify(eventData);
          js_util.callMethod(webengage, action, [eventName, jsEventData]);
        } else {
          js_util.callMethod(webengage, action, [eventName]);
        }
      } catch (e) {
        WELogger.e("Error calling $action: $e");
      }
    } else {
      WELogger.e("User object is null.");
    }
    return Future.value();
  }

  Future<void> performTrackScreen(String screenName, dynamic screenData) async {
    var action = WEB_METHOD_NAME_SCREEN;
    if (webengage != null) {
      try {
        if (screenData != null) {
          var jsEventData = js_util.jsify(screenName);
          js_util.callMethod(webengage, action, [screenName, jsEventData]);
        } else {
          js_util.callMethod(webengage, action, [screenName]);
        }
      } catch (e) {
        WELogger.e("Error calling $action: $e");
      }
    } else {
      WELogger.e("User object is null.");
    }
    return Future.value();
  }
}
