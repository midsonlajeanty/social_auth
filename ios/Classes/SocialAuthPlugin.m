#import "SocialAuthPlugin.h"
#if __has_include(<social_auth/social_auth-Swift.h>)
#import <social_auth/social_auth-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "social_auth-Swift.h"
#endif

@implementation SocialAuthPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSocialAuthPlugin registerWithRegistrar:registrar];
}
@end
