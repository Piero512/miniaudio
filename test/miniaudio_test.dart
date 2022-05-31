import 'package:flutter_test/flutter_test.dart';
import 'package:miniaudio/miniaudio.dart';

void main() {
  test('Sanity test', () {
    expect(() => MiniAudio.ffi, isNotNull);
  });
}
