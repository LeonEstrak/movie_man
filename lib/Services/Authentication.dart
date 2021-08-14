import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  /// The Instance of FirebaseAuth
  static FirebaseAuth auth = FirebaseAuth.instance;
  static final _googleSignIn = GoogleSignIn();

  static GoogleSignInAccount? _user;

  static GoogleSignInAccount? get user => _user;

  /// Sign in with Google OAuth using a popup
  static Future signInWithGoogle() async {
    try {
      /// Opens the `Sign In with Google` pop up
      final googleUser = await _googleSignIn.signIn();

      /// In case the user chooses not to sign in
      if (googleUser == null) return;
      _user = googleUser;

      /// When the user has successfully signed in, retrieve the auth details
      final googleAuth = await googleUser.authentication;

      /// Create credentials for signing in
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      /// Sign in using the credentials
      await auth.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
  }

  /// Revokes Authentication, Signs out the user, Notifies the CheckAuthentication Widget
  static Future signOut() async {
    try {
      /// Revoke authentication
      await _googleSignIn.disconnect();

      /// Sign Out the User and notify the auth change the `StreamBuilder` in
      /// the `CheckAuthentication` Widget
      auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
