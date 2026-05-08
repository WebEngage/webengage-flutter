import 'package:flutter_test/flutter_test.dart';
import 'package:webengage_flutter_location/webengage_flutter_location_platform_interface.dart';
import 'package:webengage_flutter_location/webengage_flutter_location_method_channel.dart';

void main() {
  test('MethodChannelWeLocationFlutter is the default instance', () {
    expect(
      WeLocationFlutterPlatform.instance,
      isInstanceOf<MethodChannelWeLocationFlutter>(),
    );
  });
}
