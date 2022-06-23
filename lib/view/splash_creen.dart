import 'dart:async';
import 'package:brindavan_student/view/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:brindavan_student/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Wrapper())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.08),
                      spreadRadius: 0,
                      blurRadius: 9,
                      offset: const Offset(0, 10), // changes position of shadow
                    ),
                  ],
                ),
                child: logo,
              ).p12(),
              'Brindavan Student App'.text.size(30).bold.white.make().p12(),
              loader,
            ],
          ),
        ));
  }
}
