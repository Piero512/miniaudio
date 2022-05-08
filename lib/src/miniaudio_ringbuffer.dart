import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'miniaudio_ffi.dart';

class MiniAudioPCMRingBuffer {
  final MiniAudioFfi ffi;
  final Pointer<ma_pcm_rb> _ptr;

  MiniAudioPCMRingBuffer._(this.ffi, this._ptr);

  factory MiniAudioPCMRingBuffer.managed({
    required MiniAudioFfi ffi,
    required int format,
    required int frameCount,
    required int channels,
  }) {
    final pcmRingBuffer = malloc.call<ma_pcm_rb>();
    ffi.ma_pcm_rb_init(
        format, channels, frameCount, nullptr, nullptr, pcmRingBuffer);
    return MiniAudioPCMRingBuffer._(ffi, pcmRingBuffer);
  }

  void addSamples<T extends TypedData>(T samples) {
    using((alloc) {
      final bytesPerSample = ffi.ma_get_bytes_per_sample(_ptr.ref.format);
      final frameSize = bytesPerSample * _ptr.ref.channels;
      final sizeInFrames = samples.lengthInBytes ~/ frameSize;
      final pSizeInFrames = alloc.call<Uint32>()..value = sizeInFrames;
      final ppBufferOut = alloc.call<IntPtr>();
      // Setting the requested frames to write to the ring buffer.
      // And getting a pointer to the write end.
      ffi.ma_pcm_rb_acquire_write(
          _ptr, pSizeInFrames, ppBufferOut.cast<Pointer<Void>>());
      // Now pSizeinFrames has the allowed size to write and ppBufferOut has the write end of the buffer.
      if (ppBufferOut.value != nullptr.address) {
        final buffersize = pSizeInFrames.value * frameSize;
        final pBufferOut = Pointer.fromAddress(ppBufferOut.value);
        switch (samples.runtimeType) {
          case Uint8List:
            final outBuffer = pBufferOut
                .cast<Uint8>()
                .asTypedList(buffersize ~/ sizeOf<Uint8>());
            outBuffer.setRange(0, outBuffer.length, samples as Uint8List);
            break;
          case Uint16List:
            final outBuffer = pBufferOut
                .cast<Uint16>()
                .asTypedList(buffersize ~/ sizeOf<Uint16>());
            outBuffer.setRange(0, outBuffer.length, samples as Uint16List);
            break;
          case Uint32List:
            final outBuffer = pBufferOut
                .cast<Uint32>()
                .asTypedList(buffersize ~/ sizeOf<Uint32>());
            outBuffer.setRange(0, outBuffer.length, samples as Uint32List);
            break;
          case Float32List:
            final outBuffer = pBufferOut
                .cast<Float>()
                .asTypedList(buffersize ~/ sizeOf<Float>());
            outBuffer.setRange(0, outBuffer.length, samples as Float32List);
            break;
          default:
            throw UnsupportedError(
                "This type of typed data is unsupported.${samples.runtimeType.toString()}");
        }
        ffi.ma_pcm_rb_commit_write(
            _ptr, pSizeInFrames.value, pBufferOut.cast<Void>());
      }
    });
  }

  T readSamples<T extends TypedData>(int framesToRead) {
    return using((alloc) {
      final bytesPerSample = ffi.ma_get_bytes_per_sample(_ptr.ref.format);
      final frameSize = bytesPerSample * _ptr.ref.channels;
      final pSizeInFrames = alloc.call<Uint32>();
      final ppBufferIn = alloc.call<IntPtr>();
      // Setting the requested frames to read from the ring buffer.
      // and getting the read pointer.
      ffi.ma_pcm_rb_acquire_read(
          _ptr, pSizeInFrames, ppBufferIn.cast<Pointer<Void>>());
      if (ppBufferIn.value != nullptr.address) {
        final bufferSize = pSizeInFrames.value * frameSize;
        final pBufferIn = Pointer.fromAddress(ppBufferIn.value);
        late T readSamples;
        switch (T) {
          case Uint8List:
            readSamples = Uint8List.fromList(pBufferIn
                .cast<Uint8>()
                .asTypedList(bufferSize ~/ sizeOf<Uint8>())) as T;
            break;
          case Uint16List:
            readSamples = Uint16List.fromList(pBufferIn
                .cast<Uint16>()
                .asTypedList(bufferSize ~/ sizeOf<Uint16>())) as T;
            break;
          case Uint32List:
            readSamples = Uint32List.fromList(pBufferIn
                .cast<Uint32>()
                .asTypedList(bufferSize ~/ sizeOf<Uint32>())) as T;
            break;
          case Float32List:
            readSamples = Float32List.fromList(pBufferIn
                .cast<Float>()
                .asTypedList(bufferSize ~/ sizeOf<Float>())) as T;
            break;
          default:
            throw UnsupportedError(
                "Can't read frames with type ${T.runtimeType.toString()}");
        }
        ffi.ma_pcm_rb_commit_read(
            _ptr, pSizeInFrames.value, pBufferIn.cast<Void>());
        return readSamples;
      } else {
        throw OutOfMemoryError();
      }
    });
  }
}
