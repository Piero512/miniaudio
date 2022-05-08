import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
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
    var ptr = calloc.call<ma_decoder>();
    var pathCString = path.toNativeUtf8();
    var result =
        ffi.ma_decoder_init_file(pathCString.cast<Int8>(), nullptr, ptr);
    if (result == MA_SUCCESS) {
      malloc.free(pathCString);
      return MiniAudioDecoder(ptr, ffi);
    } else {
      var readableError =
          ffi.ma_result_description(result).cast<Utf8>().toDartString();
      print(
          "ma_decode: Error while trying to open file for decoding: $readableError");
      malloc.free(ptr);
      malloc.free(pathCString);
      throw readableError;
    }
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
