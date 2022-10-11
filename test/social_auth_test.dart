import 'package:flutter_test/flutter_test.dart';
import 'package:social_auth/social_auth.dart';
import 'package:social_auth/social_auth_platform_interface.dart';
import 'package:social_auth/social_auth_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSocialAuthPlatform
    with MockPlatformInterfaceMixin
    implements SocialAuthPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SocialAuthPlatform initialPlatform = SocialAuthPlatform.instance;

  test('$MethodChannelSocialAuth is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSocialAuth>());
  });

  test('getPlatformVersion', () async {
    SocialAuth socialAuthPlugin = SocialAuth();
    MockSocialAuthPlatform fakePlatform = MockSocialAuthPlatform();
    SocialAuthPlatform.instance = fakePlatform;

    expect(await socialAuthPlugin.getPlatformVersion(), '42');
  });
}
