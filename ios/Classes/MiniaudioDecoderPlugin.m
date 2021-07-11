#import "MiniaudioDecoderPlugin.h"
#if __has_include(<miniaudio_decoder/miniaudio_decoder-Swift.h>)
#import <miniaudio_decoder/miniaudio_decoder-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "miniaudio_decoder-Swift.h"
#endif

@implementation MiniaudioDecoderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMiniaudioDecoderPlugin registerWithRegistrar:registrar];
}
@end
