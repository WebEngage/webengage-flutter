import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

/// Bridge for handling JavaScript method calls from both `webview_flutter` and `flutter_inappwebview`.
class WebEngageJSBridge {
  /// JavaScript channel name used by `webview_flutter`.
  static const String jsChannelName = _Constants.jsChannelName;

  /// Handles message from `webview_flutter` JavaScript channel.
  static void handleWebViewFlutterMessage(String message) {
    if (message.isEmpty) {
      debugPrint('[WebEngageBridge] Received empty message');
      return;
    }

    try {
      final decoded = json.decode(message);

      if (decoded is! Map || !decoded.containsKey('method')) {
        debugPrint(
            '[WebEngageBridge] Invalid message format: missing "method"');
        return;
      }

      final String method = decoded['method']?.toString() ?? '';
      final List<dynamic> args =
          decoded['args'] is List ? List<dynamic>.from(decoded['args']) : [];

      if (method.isEmpty) {
        debugPrint('[WebEngageBridge] Empty method name received');
        return;
      }

      _dispatch(method, args);
    } catch (e, stackTrace) {
      debugPrint('[WebEngageBridge] Failed to parse message: $e\n$stackTrace');
    }
  }

  /// Handles message from `flutter_inappwebview`'s JavaScript handler.
  static void handleInAppWebViewMessage(List<dynamic>? args) {
    if (args == null || args.isEmpty) {
      debugPrint(
          '[WebEngageBridge] Received null or empty args from InAppWebView');
      return;
    }

    final dynamic methodCandidate = args[0];
    if (methodCandidate is! String || methodCandidate.trim().isEmpty) {
      debugPrint(
          '[WebEngageBridge] Invalid or empty method name in args: $methodCandidate');
      return;
    }

    final String method = methodCandidate.trim();
    final List<dynamic> methodArgs = args.length > 1 ? args.sublist(1) : [];

    _dispatch(method, methodArgs);
  }

  /// Dispatches a method call to the appropriate WebEngage plugin function.
  static void _dispatch(String method, List<dynamic> args) {
    switch (method) {
      case _Constants.methodLogin:
        final userId = args.isNotEmpty ? args[0] : null;
        if (userId != null) WebEngagePlugin.userLogin(userId);
        break;

      case _Constants.methodLogout:
        WebEngagePlugin.userLogout();
        break;

      case _Constants.methodScreen:
        final screenName = args.isNotEmpty ? args[0] : null;
        final screenData = args.length > 1 ? args[1] : null;
        WebEngagePlugin.trackScreen(screenName, screenData);
        break;

      case _Constants.methodSetAttribute:
        final attributes = args.isNotEmpty ? args[0] : null;
        if (attributes != null) WebEngagePlugin.setUserAttributes(attributes);
        break;

      case _Constants.methodTrackEvent:
        final eventName = args.isNotEmpty ? args[0] : null;
        final eventData = args.length > 1 ? args[1] : null;
        WebEngagePlugin.trackEvent(eventName, eventData);
        break;

      default:
        debugPrint("WebEngageJSBridge: Unknown method '$method'");
        break;
    }
  }
}

/// Holds constants used for WebEngage JS bridge.
class _Constants {
  static const String jsChannelName = "webengage_flutter";
  static const String methodLogin = "Login";
  static const String methodLogout = "Logout";
  static const String methodScreen = "screen";
  static const String methodSetAttribute = "setAttribute";
  static const String methodTrackEvent = "trackEvent";
}
