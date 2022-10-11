import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'social_auth_method_channel.dart';

abstract class SocialAuthPlatform extends PlatformInterface {
  /// Constructs a SocialAuthPlatform.
  SocialAuthPlatform() : super(token: _token);

  static final Object _token = Object();

  static SocialAuthPlatform _instance = MethodChannelSocialAuth();

  /// The default instance of [SocialAuthPlatform] to use.
  ///
  /// Defaults to [MethodChannelSocialAuth].
  static SocialAuthPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SocialAuthPlatform] when
  /// they register themselves.
  static set instance(SocialAuthPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
