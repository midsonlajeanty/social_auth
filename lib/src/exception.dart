class AuthenticationCanceled implements Exception{
  final String message;
  AuthenticationCanceled({this.message = "Authentication Canceled"});
}

class AuthenticationError implements Exception{
  final dynamic errors;
  AuthenticationError(this.errors);
}