import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sams_flutter_share/sams_flutter_share.dart';

void main() {
  const MethodChannel channel = MethodChannel('sams_flutter_share');

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
    expect(await SamsFlutterShare.platformVersion, '42');
  });
}
