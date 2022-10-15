import 'package:google_sign_in/google_sign_in.dart';

class SocialAuthUser {
  final String? id;
  final String? email;
  final String fullname;
  final String? username;
  final String profileUrl;

  SocialAuthUser({
    this.id,
    this.email,
    required this.fullname,
    this.username,
    required this.profileUrl,
  });

  factory SocialAuthUser.fromGoogleAccount(GoogleSignInAccount account){
    return SocialAuthUser(
      id: account.id,
      fullname: account.displayName ?? "",
      email: account.email,
      profileUrl: account.photoUrl ?? "",
    );
  }

  factory SocialAuthUser.fromGithubAccount(Map account){
    return SocialAuthUser(
      id: account['id'].toString(),
      fullname: account['name'] ?? account['login'],
      email: account['email'],
      username: account['login'],
      profileUrl: account['avatar_url'],
    );
  }

  @override
  String toString() {
    return 'SocialAuthUser{id: $id, email: $email, fullname: $fullname, username: $username, profileUrl: $profileUrl}';
  }
}