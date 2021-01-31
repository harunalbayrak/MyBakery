import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign in with email&password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed in";
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email&password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      var x = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      x.user.uid;
      return x.user.uid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
