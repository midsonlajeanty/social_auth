class AuthenticationCanceled implements Exception{
  final String? message;
  AuthenticationCanceled({this.message});
}

class AuthenticationError implements Exception{
  final String error;
  AuthenticationError(this.error);
}