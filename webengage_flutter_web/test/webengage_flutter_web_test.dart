import 'package:flutter_test/flutter_test.dart';
import 'package:webengage_flutter_web/webengage_flutter_web.dart';
import 'package:webengage_flutter_platform_interface/webengage_flutter_platform_interface.dart';

void main() {
  test('registerWith sets WEFlutterWeb as the platform instance', () {
    WEFlutterWeb.registerWith();
    expect(WEPlatformInterface.instance, isA<WEFlutterWeb>());
  });
}
