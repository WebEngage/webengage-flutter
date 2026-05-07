import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:webengage_flutter_platform_interface/webengage_flutter_platform_interface.dart';
import 'package:webengage_flutter_web/src/utils/we_constants.dart';

import '../../webengage_flutter_web.dart';
import '../utils/we_utils.dart';

extension WEWebExtension on WEFlutterWeb {
  Future<void> performUserAction(String action, List args) async {
    var instance = WEWebUtils().getWebEngageInstance();
    if (!WEWebUtils().isWebEngageAdded()) {
      return;
    }
    JSObject? user = instance![WEB_METHOD_NAME_USER] as JSObject?;
    if (user != null) {
      try {
        final jsArgs = args.map((e) => (e as Object?)?.jsify()).toList();
        user.callMethodVarArgs(action.toJS, jsArgs);
      } catch (e) {
        WELogger.e("Error calling $action: $e");
      }
    } else {
      WELogger.e("User object is null.");
    }
  }

  Future<void> performUserAttributeAction(dynamic args) async {
    var instance = WEWebUtils().getWebEngageInstance();
    if (!WEWebUtils().isWebEngageAdded()) {
      return;
    }
    var action = WEB_METHOD_NAME_SET_ATTRIBUTE;
    JSObject? user = instance![WEB_METHOD_NAME_USER] as JSObject?;
    if (user != null) {
      try {
        List argsList;
        if (args is List) {
          argsList = args;
        } else {
          argsList = [args];
        }
        final jsArgs = argsList.map((e) => (e as Object?)?.jsify()).toList();
        user.callMethodVarArgs(action.toJS, jsArgs);
      } catch (e) {
        WELogger.e("Error calling $action: $e");
      }
    } else {
      WELogger.e("User object is null.");
    }
  }

  Future<void> performTrackEvent(String eventName, dynamic eventData) async {
    var instance = WEWebUtils().getWebEngageInstance();
    if (!WEWebUtils().isWebEngageAdded()) {
      return;
    }
    var action = WEB_METHOD_NAME_TRACK;
    try {
      if (eventData != null) {
        final jsEventData = (eventData as Object).jsify();
        instance!.callMethodVarArgs(action.toJS, [eventName.toJS, jsEventData]);
      } else {
        instance!.callMethodVarArgs(action.toJS, [eventName.toJS]);
      }
    } catch (e) {
      WELogger.e("Error calling $action: $e");
    }
  }

  Future<void> performTrackScreen(String screenName, dynamic screenData) async {
    var instance = WEWebUtils().getWebEngageInstance();
    if (!WEWebUtils().isWebEngageAdded()) {
      return;
    }
    var action = WEB_METHOD_NAME_SCREEN;
    try {
      if (screenData != null) {
        final jsEventData = (screenData as Object).jsify();
        instance!
            .callMethodVarArgs(action.toJS, [screenName.toJS, jsEventData]);
      } else {
        instance!.callMethodVarArgs(action.toJS, [screenName.toJS]);
      }
    } catch (e) {
      WELogger.e("Error calling $action: $e");
    }
  }
}
