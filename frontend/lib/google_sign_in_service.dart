import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: 'YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com',
  );
  Future<GoogleSignInAccount?> signIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        // 여기에서 추가적인 사용자 정보를 가져올 수 있습니다.
        final GoogleSignInAuthentication auth = await account.authentication;
        final String? accessToken = auth.accessToken;
        // accessToken을 사용하여 추가 작업을 수행할 수 있습니다.
      }
      return account;
    } catch (error) {
      print('Google Sign-In Error: $error');
      return null;
    }
  }

  Future<void> signOut() => _googleSignIn.signOut();
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;
}
