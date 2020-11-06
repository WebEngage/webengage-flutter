import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webengage_flutter/webengage_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('webengage_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await WebEngagePlugin.platformVersion, '42');
  });
}
