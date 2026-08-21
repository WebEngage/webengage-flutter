import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

/// Bridge for handling JavaScript method calls from both `webview_flutter` and `flutter_inappwebview`.
class WebEngageJSBridge {
  WebEngageJSBridge._();

  /// JavaScript channel name used by `webview_flutter`.
  static const String jsChannelName = _Constants.jsChannelName;

  /// Lookup map for internal `we_` prefixed attribute handlers.
  static final Map<String, void Function(dynamic)> _internalAttributeHandlers =
      {
    'we_first_name': (v) => WebEngagePlugin.setUserFirstName(v),
    'we_last_name': (v) => WebEngagePlugin.setUserLastName(v),
    'we_email': (v) => WebEngagePlugin.setUserEmail(v),
    'we_birth_date': (v) => WebEngagePlugin.setUserBirthDate(v),
    'we_phone': (v) => WebEngagePlugin.setUserPhone(v),
    'we_gender': (v) => WebEngagePlugin.setUserGender(v),
    'we_company': (v) => WebEngagePlugin.setUserCompany(v),
    'we_hashed_email': (v) => WebEngagePlugin.setUserHashedEmail(v),
    'we_hashed_phone': (v) => WebEngagePlugin.setUserHashedPhone(v),
    'we_push_opt_in': (v) => WebEngagePlugin.setUserOptIn('push', v),
    'we_sms_opt_in': (v) => WebEngagePlugin.setUserOptIn('sms', v),
    'we_email_opt_in': (v) => WebEngagePlugin.setUserOptIn('email', v),
    'we_whatsapp_opt_in': (v) => WebEngagePlugin.setUserOptIn('whatsapp', v),
    'we_viber_opt_in': (v) => WebEngagePlugin.setUserOptIn('viber', v),
  };

  /// Handles message from `webview_flutter` JavaScript channel.
  static void handleWebViewFlutterMessage(String message) {
    if (message.isEmpty) {
      debugPrint('[WebEngageBridge] Received empty message');
      return;
    }

    try {
      final decoded = json.decode(message);

      if (decoded is! Map<String, dynamic> ||
          !decoded.containsKey('method')) {
        debugPrint(
            '[WebEngageBridge] Invalid message format: missing "method"');
        return;
      }

      final String? method = decoded['method'] as String?;
      if (method == null || method.isEmpty) {
        debugPrint('[WebEngageBridge] Empty method name received');
        return;
      }

      final List<dynamic> args =
          decoded['args'] is List ? decoded['args'] as List<dynamic> : const [];

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
    final List<dynamic> methodArgs = args.length > 1 ? args.sublist(1) : const [];
    debugPrint('[WebEngageBridge] method name in args: $method $methodArgs');
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
        if (screenName == null) break;
        final screenData = args.length > 1 ? args[1] as Map<String, dynamic>? : null;
        WebEngagePlugin.trackScreen(screenName, screenData);
        break;

      case _Constants.methodSetAttribute:
        _handleSetAttribute(args);
        break;

      case _Constants.methodTrackEvent:
        final eventName = args.isNotEmpty ? args[0] : null;
        if (eventName == null) break;
        final eventData = args.length > 1 ? args[1] as Map<String, dynamic>? : null;
        WebEngagePlugin.trackEvent(eventName, eventData);
        break;

      default:
        debugPrint("[WebEngageBridge] Unknown method '$method'");
        break;
    }
  }

  /// Processes `setAttribute` calls, splitting internal `we_` attributes
  /// from custom user attributes.
  static void _handleSetAttribute(List<dynamic> args) {
    if (args.isEmpty || args[0] is! Map) return;

    final Map<dynamic, dynamic> attributes = args[0] as Map<dynamic, dynamic>;
    final Map<String, dynamic> userAttributes = {};

    for (final entry in attributes.entries) {
      final String key = entry.key.toString();

      if (key.startsWith('we_')) {
        final handler = _internalAttributeHandlers[key];
        if (handler != null) {
          handler(entry.value);
        } else {
          debugPrint(
              '[WebEngageBridge] Internal attribute not handled: $key = ${entry.value}');
        }
      } else {
        userAttributes[key] = entry.value;
      }
    }

    if (userAttributes.isNotEmpty) {
      WebEngagePlugin.setUserAttributes(userAttributes);
    }
  }
}

/// Holds constants used for WebEngage JS bridge.
class _Constants {
  _Constants._();

  static const String jsChannelName = 'webengage_flutter';
  static const String methodLogin = 'login';
  static const String methodLogout = 'logout';
  static const String methodScreen = 'screen';
  static const String methodSetAttribute = 'setAttribute';
  static const String methodTrackEvent = 'trackEvent';
}
