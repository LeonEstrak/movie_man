import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static final googleSignIn = GoogleSignIn();

  static GoogleSignInAccount? _user;

  static GoogleSignInAccount? get user => _user;

  static Future signInWithGoogle() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await auth.signInWithCredential(credential);
  }

  static Future signOut() async {
    await googleSignIn.disconnect();
    auth.signOut();
  }
}
