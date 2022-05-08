import 'dart:ffi';

import 'miniaudio_ffi.dart';

class MiniAudioDecoder {
  final MiniAudioFfi ffi;
  final Pointer<ma_decoder> decoder;
  bool finalized = false;
  static const _finalizedMessage = 'This instance is already finalized';
  MiniAudioDecoder(this.decoder, this.ffi) : assert(decoder != nullptr);

  void closeDecoder() {
    if (!finalized) {
      ffi.ma_decoder_uninit(decoder);
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
      return ffi.ma_decoder_read_pcm_frames(
          decoder, frameBuffer.cast<Void>(), framesToRead);
    }
    return -1;
  }
}
