import 'package:flutter_test/flutter_test.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

void main() {
  test('WebEngagePlugin is a singleton', () {
    final instance1 = WebEngagePlugin();
    final instance2 = WebEngagePlugin();
    expect(identical(instance1, instance2), isTrue);
  });

  test('WebEngagePlugin exposes push stream', () {
    final plugin = WebEngagePlugin();
    expect(plugin.pushStream, isNotNull);
  });

  test('WebEngagePlugin exposes anonymous action stream', () {
    final plugin = WebEngagePlugin();
    expect(plugin.anonymousActionStream, isNotNull);
  });

  test('WebEngagePlugin exposes track deeplink stream', () {
    final plugin = WebEngagePlugin();
    expect(plugin.trackDeeplinkStream, isNotNull);
  });
}
