import 'package:brindavan_student/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:brindavan_student/utils/loading.dart';

class UserInactive extends StatefulWidget {
  const UserInactive({Key? key}) : super(key: key);

  @override
  State<UserInactive> createState() => _UserInactiveState();
}

class _UserInactiveState extends State<UserInactive> {
  @override
  Widget build(BuildContext context) {
    bool loading = false;
    final AuthService auth = AuthService();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          'You have been temporarly blocked by institution!'
              .text
              .xl
              .red500
              .bold
              .center
              .make(),
          'You can sign out for now'.text.bold.make(),
          ElevatedButton(
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                await auth.signOut();
              },
              child: 'Sign out'.text.make())
        ],
      ),
    );
  }
}
