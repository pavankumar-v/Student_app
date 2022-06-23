import 'package:flutter/material.dart';
import 'package:brindavan_student/utils/constants.dart';
import 'package:velocity_x/velocity_x.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['loading..'.text.base.make(), loader]),
        ),
      ),
    );
  }
}
