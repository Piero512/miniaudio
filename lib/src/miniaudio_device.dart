import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'miniaudio_ffi.dart';

class MiniAudioDevice {
  final Pointer<ma_device> _ptr;
  final MiniAudioFfi ffi;
  bool disposed = false;
  MiniAudioDevice._(this.ffi, this._ptr);

  factory MiniAudioDevice.playbackDevice(
    MiniAudioFfi ffi, {
    required int playbackFormat,
    required int channels,
    required int sampleRate,
    required ma_device_callback_proc dataCallback,
    required Pointer<Void> userData,
  }) {
    final device = malloc.call<ma_device>();
    final deviceConfig = malloc.call<ma_device_config>()
      ..ref = ffi.ma_device_config_init(ma_device_type.ma_device_type_playback);
    deviceConfig.ref.playback.format = playbackFormat;
    deviceConfig.ref.playback.channels = channels;
    deviceConfig.ref.sampleRate = sampleRate;
    deviceConfig.ref.dataCallback = dataCallback;
    deviceConfig.ref.pUserData = userData;
    ffi.ma_device_init(nullptr, deviceConfig, device);
    return MiniAudioDevice._(ffi, device);
  }

  factory MiniAudioDevice.defaultPlaybackDevice(MiniAudioFfi ffi,
      {required ma_device_callback_proc dataCallback,
      required Pointer<Void> userData}) {
    return MiniAudioDevice.playbackDevice(
      ffi,
      playbackFormat: ma_format.ma_format_unknown,
      channels: 0,
      sampleRate: 0,
      dataCallback: dataCallback,
      userData: userData,
    );
  }

  int startDevice() {
    assert(disposed == false, "Can't stop playback on a disposed device");
    return ffi.ma_device_start(_ptr);
  }

  int stopDevice() {
    assert(disposed == false, "Can't stop playback on a disposed device");
    return ffi.ma_device_stop(_ptr);
  }

  void uninit() {
    if (!disposed) {
      ffi.ma_device_uninit(_ptr);
      malloc.free(_ptr);
      disposed = true;
    }
  }
}
