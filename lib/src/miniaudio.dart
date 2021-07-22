import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'miniaudio_decode.dart';
import 'miniaudio_ffi.dart';

class MiniAudio {
  static MiniAudioFfi ffi = _getMiniAudioDLL();

  static MiniAudioFfi _getMiniAudioDLL() {
    if (Platform.isAndroid || Platform.isLinux) {
      return MiniAudioFfi(DynamicLibrary.open('libminiaudio.so'));
    } else if (Platform.isMacOS) {
      return MiniAudioFfi(DynamicLibrary.open('libminiaudio.dylib'));
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
}
