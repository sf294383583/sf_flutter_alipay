import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sf_flutter_alipay/sf_flutter_alipay.dart';

void main() {
  const MethodChannel channel = MethodChannel('sf_flutter_alipay');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await SfFlutterAlipay.platformVersion, '42');
  });
}
