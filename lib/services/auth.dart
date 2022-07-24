import 'package:brindavan_student/models/user.dart';
import 'package:brindavan_student/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on firebase user
  MyUser? _userFromFirebaseUser(User user) {
    return user != null ? MyUser(uid: user.uid, email: user.email) : null;
  }

  //auth changes user stream
  Stream<MyUser?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));
  }

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      User? user = result.user;
      print(user!.uid);

      _userFromFirebaseUser(user);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, String usn, String branch) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      User? user = result.user;
      await DatabaseService().updateUserData(usn, '', 0, '', branch);
      _userFromFirebaseUser(user!);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return e.toString();
    }
  }

  //Send password reset mail
  Future resetPassword(email) async {
    try {
      return _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
