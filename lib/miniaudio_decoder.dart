
import 'dart:async';

import 'package:flutter/services.dart';

class MiniaudioDecoder {
  static const MethodChannel _channel =
      const MethodChannel('miniaudio_decoder');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
