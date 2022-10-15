import 'package:social_auth/src/exception.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_auth/src/social_auth_user.dart';

class GoogleSignInHelper{
  
  final SignInOption signInOption;
  final List<String> scopes;
  final String? hostedDomain;
  final String? clientId;
  final String? serverClientId;
  final bool forceCodeForRefreshToken;

  late final GoogleSignIn _googleSignIn;

  GoogleSignInHelper({
    this.signInOption = SignInOption.standard,
    this.scopes = const <String>[],
    this.hostedDomain,
    this.clientId,
    this.serverClientId,
    this.forceCodeForRefreshToken = false,
  }){
    _googleSignIn = GoogleSignIn(
      signInOption: signInOption,
      scopes: scopes,
      clientId: clientId,
      serverClientId: serverClientId,
      hostedDomain: hostedDomain,
    );
  }


  Future<SocialAuthUser> signIn() async {
    GoogleSignInAccount? account;

    try{
      account = await _googleSignIn.signIn();
    } catch(e){
      throw AuthenticationError(e.toString());
    }

    if(account == null){
      throw AuthenticationCanceled();
    }else{
      return SocialAuthUser.fromGoogleAccount(account);
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  Future<void> disconnect() async {
    await _googleSignIn.disconnect();
  }
}