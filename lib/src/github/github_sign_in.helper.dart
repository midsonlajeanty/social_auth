import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:social_auth/src/social_auth_user.dart';
import 'package:social_auth/src/config/constants.dart';
import 'package:social_auth/src/exception.dart';
import 'package:social_auth/src/github/github_sign_in.screen.dart';


class GitHubSignInHelper{
  final String clientId;
  final String clientSecret;
  final String redirectUrl;

  final String scope = "read:user,user:email";

  GitHubSignInHelper({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUrl,
  });

  Future<SocialAuthUser> signIn(BuildContext context) async {
    final authCode = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GithubSignInScreen(url: _buildAuthorizeUrl)
      )
    );

    if (authCode == null) {
      throw AuthenticationCanceled();
    } else if (authCode is Exception) {
      throw AuthenticationError(authCode.toString());
    }

    final auth = await getAccessToken(authCode as String);

    final account = await request(Constants.gitHubUserProfilURL, auth: auth);

    if(account['email'] == null){
      final emails = await request(Constants.gitHubUserEmailURL, auth: auth);

      final emailMap = emails.firstWhere((map) => map['primary'] && map['verified']);

      if(emailMap != null){
        account['email'] = emailMap['email'];
      }else{
        throw Exception("Sorry, account have not verified email address"); 
      }
    }

    return SocialAuthUser.fromGithubAccount(account);
  }

  Future<Map> getAccessToken(String code) async {
    final response = await http.post(
      Uri.parse(Constants.gitHubAccessTokenURL),
      headers: {'Accept': 'application/json',},
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'code': code,
      },
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get access token');
    }
  }

  Future<dynamic> request(String url, {Map? auth}) async {
    final headers = {'Accept': 'application/json',};
    if (auth != null){
      headers['Authorization'] = "${auth['token_type']} ${auth['access_token']}";
    }

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401){
      throw Exception('Unauthorize');
    }else {
      throw Exception('Failed to get GRithub User Info');
    }
  }

  String get _buildAuthorizeUrl => 
    "${Constants.gitHubAuthorizeURL}?client_id=$clientId&redirect_uri=$redirectUrl&scope=$scope&allow_signup=true";
}