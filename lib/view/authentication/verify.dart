import 'dart:async';
import 'package:brindavan_student/view/wrapper.dart';
import 'package:brindavan_student/services/auth.dart';
import 'package:brindavan_student/services/database.dart';
import 'package:brindavan_student/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velocity_x/velocity_x.dart';

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
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.done,
                    size: 30,
                    color: Colors.white,
                  ).p20().card.circular.color(Colors.green).make(),
                  "Verify Email".text.bold.xl2.lineHeight(1.5).make(),
                  "Verification link sent to \n ${user.email}"
                      .text
                      .lg
                      .lineHeight(1.5)
                      .center
                      .make()
                      .p12(),
                  "Stay On Page".text.bold.xl.center.make().p12(),

                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: Container(
                  //     margin: const EdgeInsets.all(5),
                  //     width: double.infinity,
                  //     child: ElevatedButton(
                  //       onPressed: () async {
                  //         setState(() {
                  //           loading = true;
                  //         });
                  //         await _auth.signOut();
                  //       },
                  //       child: "Sign Out".text.lg.make().py16(),
                  //     ).p12(),
                  //   ),
                  // ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height / 3,
                      color: Theme.of(context).colorScheme.background,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            "If you are facing any issues :"
                                .text
                                .xl
                                .bold
                                .color(Theme.of(context).hintColor)
                                .make(),

                            "1. Try checking your spam for the email verification link 📧"
                                .text
                                .lg
                                .make()
                                .py12(),
                            "2. Try Signing out and signing in again."
                                .text
                                .lg
                                .make()
                                .py12(),
                            InkWell(
                              child: 'sign out'
                                  .text
                                  .base
                                  .color(Theme.of(context).primaryColor)
                                  .underline
                                  .make(),
                              onTap: () async {
                                Navigator.pop(context);
                                setState(() {
                                  loading = true;
                                });

                                await _auth.signOut();
                              },
                            ),
                            "3. Raise issue if any of the following doesn't work"
                                .text
                                .lg
                                .make()
                                .py12(),
                            InkWell(
                              child: 'Rise Issue'
                                  .text
                                  .base
                                  .color(Theme.of(context).primaryColor)
                                  .underline
                                  .make(),
                              onTap: () async {
                                Navigator.pop(context);
                              },
                            ),
                            // ElevatedButton(
                            //   child: const Text('Close BottomSheet'),
                            //   onPressed: () => Navigator.pop(context),
                            // )
                          ],
                        ).p12(),
                      ),
                    );
                  },
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.info_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user.reload();

    if (user.emailVerified) {
      dynamic user = await DatabaseService().getDetails();
      // getUsn();
      dynamic result = await DatabaseService().setUsnUsed(
          user['usn'].toString().toLowerCase(),
          user['branch'].toString().toLowerCase());
      print(result.toString());
      timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Wrapper()));
    }
  }
}
