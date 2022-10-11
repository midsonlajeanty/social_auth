import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'social_auth_platform_interface.dart';

/// An implementation of [SocialAuthPlatform] that uses method channels.
class MethodChannelSocialAuth extends SocialAuthPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('social_auth');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
