import 'dart:js_util' as js_util;

import 'package:webengage_flutter_web/src/utils/constants.dart';

import '../webengage_flutter_web.dart';

extension WebengageFlutterWebExtension on WebengageFlutterWeb {
  Future<void> performUserAction(String action, dynamic args) async {
    user = js_util.getProperty(webengage, WEB_METHOD_NAME_USER);
    print("performUserAction $action $args");
    if (user != null) {
      try {
        if (args is! List) {
          args = [args]; // Wrap it in a list if it's not a list
        }
        js_util.callMethod(user, action, args);
      } catch (e) {
        print("Error calling $action: $e");
      }
    } else {
      print("User object is null.");
    }
    return Future.value();
  }

  Future<void> performUserAttributeAction(dynamic args) async {
    var action = WEB_METHOD_NAME_SET_ATTRIBUTE;
    print("performUserAction ${WEB_METHOD_NAME_SET_ATTRIBUTE} $args");
    if (user != null) {
      try {
        if (args is! List) {
          args = [args];
        }
        js_util.callMethod(user, action, args);
      } catch (e) {
        print("Error calling $action: $e");
      }
    } else {
      print("User object is null.");
    }
    return Future.value();
  }

  Future<void> performTrackEvent(String eventName, dynamic eventData) async {
    var action = WEB_METHOD_NAME_TRACK;
    print("performUserAction track $eventName $eventData");
    if (webengage != null) {
      try {
        if (eventData != null) {
          var jsEventData = js_util.jsify(eventData);
          js_util.callMethod(webengage, action, [eventName, jsEventData]);
        } else {
          js_util.callMethod(webengage, action, [eventName]);
        }
      } catch (e) {
        print("Error calling $action: $e");
      }
    } else {
      print("User object is null.");
    }
    return Future.value();
  }

  Future<void> performTrackScreen(String screenName, dynamic screenData) async {
    var action = WEB_METHOD_NAME_SCREEN;
    print("performUserAction track $screenName $screenData");
    if (webengage != null) {
      try {
        if (screenData != null) {
          var jsEventData = js_util.jsify(screenName);
          js_util.callMethod(webengage, action, [screenName, jsEventData]);
        } else {
          js_util.callMethod(webengage, action, [screenName]);
        }
      } catch (e) {
        print("Error calling $action: $e");
      }
    } else {
      print("User object is null.");
    }
    return Future.value();
  }
}
