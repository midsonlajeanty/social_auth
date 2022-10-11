
import 'social_auth_platform_interface.dart';

class SocialAuth {
  Future<String?> getPlatformVersion() {
    return SocialAuthPlatform.instance.getPlatformVersion();
  }
}
