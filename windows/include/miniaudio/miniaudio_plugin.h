#ifndef FLUTTER_PLUGIN_MINIAUDIO_PLUGIN_H_
#define FLUTTER_PLUGIN_MINIAUDIO_PLUGIN_H_

#include <flutter_plugin_registrar.h>
#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FLUTTER_PLUGIN_EXPORT __declspec(dllimport)
#endif

#define MA_API FLUTTER_PLUGIN_EXPORT
#include "../../../src/miniaudio.h"

#if defined(__cplusplus)
extern "C" {
#endif

FLUTTER_PLUGIN_EXPORT void MiniaudioPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar);

FLUTTER_PLUGIN_EXPORT void MiniAudioReadDecoderDataCallback(ma_device* pDevice, void* pOutput, const void* pInput, ma_uint32 frameCount);
#if defined(__cplusplus)
}  // extern "C"
#endif

#endif  // FLUTTER_PLUGIN_MINIAUDIO_PLUGIN_H_
