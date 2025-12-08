import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/gmail.send', // needed to send emails
  ],
);

Future<GoogleSignInAccount?> signInWithGoogle() async {
  try {
    final account = await _googleSignIn.signIn();
    return account;
  } catch (error) {
    print('Google Sign-In error: $error');
    return null;
  }
}

Future<Map<String, String>?> getGoogleTokens(GoogleSignInAccount account) async {
  final auth = await account.authentication;
  return {
    'accessToken': auth.accessToken ?? '',
    'idToken': auth.idToken ?? '',
    'email': account.email,
    'displayName': account.displayName ?? '',
  };
}
