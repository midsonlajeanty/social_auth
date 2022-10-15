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
  final String scope;

  GitHubSignInHelper({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUrl,
    this.scope = "read:user",
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
    } else {
      final authCredentials = await _getAccessToken(authCode as String);

      final account = await _getAccountInfo(authCredentials);

      return SocialAuthUser.fromGithubAccount(account);
    }
  }

  Future<Map> _getAccessToken(String code) async {
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

  Future<Map> _getAccountInfo(Map credentials) async {
    final response = await http.get(
      Uri.parse(Constants.gitHubUserURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': "${credentials['token_type']} ${credentials['access_token']}"
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401){
      throw Exception('Unauthorize');
    }else {
      throw Exception('Failed to get user info');
    }
  }

  String get _buildAuthorizeUrl => 
    "${Constants.gitHubAuthorizeURL}?client_id=$clientId&redirect_uri=$redirectUrl&scope=$scope&allow_signup=true";
}