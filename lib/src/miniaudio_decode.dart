import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'miniaudio_ffi.dart';

class MiniAudioDecoder implements Finalizable {
  static NativeFinalizer? _decoderFinalizer;
  static final Finalizer<Pointer<ma_decoder>> _allocFinalizer =
      Finalizer((ptr) => malloc.free(ptr));
  final MiniAudioFfi ffi;
  final Pointer<ma_decoder> decoder;
  bool finalized = false;
  static const _finalizedMessage = 'This instance is already finalized';
  MiniAudioDecoder._(
    this.ffi,
    this.decoder,
  ) : assert(decoder != nullptr);

  factory MiniAudioDecoder.openPath(MiniAudioFfi ffi, String path) {
    _decoderFinalizer ??=
        NativeFinalizer(ffi.addresses.ma_decoder_uninit.cast());
    return using((alloc) {
      var decoder = calloc.call<ma_decoder>();
      var pathCString = path.toNativeUtf8(allocator: alloc);
      var result =
          ffi.ma_decoder_init_file(pathCString.cast<Int8>(), nullptr, decoder);
      if (result == ma_result.MA_SUCCESS) {
        final retval = MiniAudioDecoder._(ffi, decoder);
        _decoderFinalizer?.attach(
          retval,
          decoder.cast(),
          detach: retval,
          externalSize: sizeOf<ma_decoder>(),
        );
        _allocFinalizer.attach(retval, decoder, detach: retval);
        return retval;
      } else {
        var readableError =
            ffi.ma_result_description(result).cast<Utf8>().toDartString();
        malloc.free(decoder);
        throw ArgumentError.value(path, 'path', readableError);
      }
    });
  }

  void closeDecoder() {
    if (!finalized) {
      _allocFinalizer.detach(this);
      _decoderFinalizer?.detach(this);
      ffi.ma_decoder_uninit(decoder);
      malloc.free(decoder);
    }
    finalized = true;
  }

  int get sampleSize {
    assert(finalized != true, _finalizedMessage);
    return ffi.ma_get_bytes_per_sample(decoder.ref.outputFormat);
  }

  int get frameSize => sampleSize * channelCount;

  int get channelCount {
    assert(finalized != true, _finalizedMessage);
    return decoder.ref.outputChannels;
  }

  /// Read frames from decoder
  /// params:
  ///
  /// [frameBuffer] buffer to receive the frames
  ///
  /// [frameBufferSize]  size (in bytes) of the buffer passed before
  ///
  /// [framesToRead] frames to read.
  ///
  /// You should have allocated at least [framesToRead] * [frameSize] bytes in this buffer.
  /// otherwise, the operation will be aborted.
  ///
  /// Returns the amount of frames read or -1 if the buffer isn't big enough.
  int readFrames(
      Pointer<Uint8> frameBuffer, int frameBufferSize, int framesToRead) {
    assert(finalized != true, _finalizedMessage);
    if (frameSize * framesToRead <= frameBufferSize) {
      return using((alloc) {
        final Pointer<Uint64> framesRead = alloc.call();
        return ffi.ma_decoder_read_pcm_frames(
            decoder, frameBuffer.cast<Void>(), framesToRead, framesRead);
      });
    }
    return -1;
  }
}
