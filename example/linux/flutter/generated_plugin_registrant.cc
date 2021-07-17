//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <miniaudio_decoder/miniaudio_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) miniaudio_decoder_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "MiniaudioPlugin");
  miniaudio_plugin_register_with_registrar(miniaudio_decoder_registrar);
}
