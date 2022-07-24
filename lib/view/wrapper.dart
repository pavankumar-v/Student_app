import 'package:brindavan_student/models/user.dart';
import 'package:brindavan_student/provider/data_provider.dart';
import 'package:brindavan_student/view/authentication/authenticate.dart';
import 'package:brindavan_student/view/authentication/verify.dart';
import 'package:brindavan_student/view/main/navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    final auth = FirebaseAuth.instance;
    late User? curUser;
    curUser = auth.currentUser;
    // ignore: avoid_print

    if (user == null) {
      return const Authenticate();
    } else if (curUser!.emailVerified) {
      return Scaffold(
        body: StreamBuilder<UserData?>(
            stream: DataProvider().userData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active &&
                  snapshot.hasData) {
                return ChangeNotifierProvider(
                    create: (context) => DataProvider(
                        branch: snapshot.data!.branch,
                        sem: snapshot.data!.sem.toString(),
                        section: snapshot.data!.section),
                    child: const Navigate());
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(
                  child: Text("Something Went Wrong"),
                );
              }
            }),
      );
    } else {
      return const VerifyScreen();
    }
  }
}
