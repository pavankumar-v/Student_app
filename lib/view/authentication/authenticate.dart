import 'package:brindavan_student/view/authentication/login.dart';
import 'package:brindavan_student/view/authentication/register.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = false;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }
   
  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return Login(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
      
    }
  }
}
