import 'package:flutter_test/flutter_test.dart';
import 'package:webengage_flutter_ios/webengage_flutter_ios.dart';
import 'package:webengage_flutter_platform_interface/webengage_flutter_platform_interface.dart';

void main() {
  test('registerWith sets WEFlutterIos as the platform instance', () {
    WEFlutterIos.registerWith();
    expect(WEPlatformInterface.instance, isA<WEFlutterIos>());
  });
}
