#import "LaravelEcho2Plugin.h"
#if __has_include(<laravel_echo2/laravel_echo2-Swift.h>)
#import <laravel_echo2/laravel_echo2-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "laravel_echo2-Swift.h"
#endif

@implementation LaravelEcho2Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLaravelEcho2Plugin registerWithRegistrar:registrar];
}
@end
