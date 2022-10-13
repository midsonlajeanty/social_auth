class SocialAuthUser {
  final int? id;
  final String email;
  final String fullname;
  final String? username;
  final String profileUrl;
  final String? token;

  SocialAuthUser({
    this.id,
    required this.email,
    required this.fullname,
    this.username,
    required this.profileUrl,
    this.token,
  });
}