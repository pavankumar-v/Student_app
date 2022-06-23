import 'dart:async';
import 'package:brindavan_student/view/wrapper.dart';
import 'package:brindavan_student/services/auth.dart';
import 'package:brindavan_student/services/database.dart';
import 'package:brindavan_student/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  final AuthService _auth = AuthService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  late User user;
  late Timer timer;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    user = auth.currentUser!;
    user.sendEmailVerification();

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                "An email has been sent to ${user.email} please verify"
                    .text
                    .center
                    .make()
                    .p12(),
                "Do not close the App. \n You will be automatically redirected to the home screen after you verify your email."
                    .text
                    .red500
                    .center
                    .make()
                    .p12(),
              ],
            ),
          );
  }

  Future<dynamic> getUsn() async {
    try {
      return await _db
          .collection('users')
          .doc(user.uid)
          .get()
          .then((value) => value.data()!['usn']);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user.reload();

    if (user.emailVerified) {
      dynamic usn = await getUsn();
      print('usn:' + usn);
      // getUsn();
      dynamic result = await DatabaseService().setUsnUsed(usn.toString());

      print('hello' + result.toString());
      timer.cancel();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => const Wrapper()));
    }
  }
}
