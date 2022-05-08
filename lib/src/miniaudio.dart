import 'dart:ffi';
import 'dart:io';

import 'package:miniaudio/src/miniaudio_ringbuffer.dart';

import 'miniaudio_decode.dart';
import 'miniaudio_device.dart';
import 'miniaudio_ffi.dart';

class MiniAudio {
  static MiniAudioFfi ffi = _getMiniAudioDLL();

  static MiniAudioFfi _getMiniAudioDLL() {
    if (Platform.isAndroid || Platform.isLinux) {
      return MiniAudioFfi(DynamicLibrary.open('libminiaudio.so'));
    } else if (Platform.isMacOS) {
      return MiniAudioFfi(DynamicLibrary.open('libminiaudio.dylib'));
    } else if (Platform.isIOS) {
      var lib = DynamicLibrary.open('miniaudio.framework/miniaudio');
      return MiniAudioFfi(lib);
    }
    return MiniAudioFfi(DynamicLibrary.executable());
  }

  static MiniAudioDecoder openDecoder(String path) {
    return MiniAudioDecoder.openPath(ffi, path);
  }

  /// Initializes a default miniaudio device for playback.
  /// The [dataCallback] parameter must be able to be called from any thread
  /// so you need to get this function pointer from another piece of C code
  /// in your project. Or wait until isolate-independent FFI code is added to Dart.
  static MiniAudioDevice getDefaultPlaybackDevice(
      ma_device_callback_proc dataCallback, Pointer<Void> userData) {
    return MiniAudioDevice.defaultPlaybackDevice(
      ffi,
      dataCallback: dataCallback,
      userData: userData,
    );
  }

  static MiniAudioPCMRingBuffer getNewRingBuffer(
      int sampleFormat, int frameCount, int channels) {
    return MiniAudioPCMRingBuffer.managed(
      ffi: ffi,
      format: sampleFormat,
      frameCount: frameCount,
      channels: channels,
    );
  }
}
