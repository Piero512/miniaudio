#import "MiniaudioPlugin.h"
#if __has_include(<miniaudio/miniaudio-Swift.h>)
#import <miniaudio/miniaudio-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "miniaudio-Swift.h"
#endif

@implementation MiniaudioPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMiniaudioPlugin registerWithRegistrar:registrar];
}
@end
