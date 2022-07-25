import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

var primaryColor = Vx.hexToColor('#1B62DB');
//LOADER
var loader = SizedBox(
  height: 2.0,
  width: 100.0,
  child: LinearProgressIndicator(
      // value: animation.value,
      color: Colors.white,
      backgroundColor: primaryColor),
).p12();

// INPUT DECORATION
var textInputDecoration = InputDecoration(
  errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.0)),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primaryColor, width: 2.0),
  ),
  filled: true,
  focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.0)),
);

// BACKGROUND IMAGE
const backgroundImage = BoxDecoration(
  image: DecorationImage(
    // colorFilter:
    //     ColorFilter.mode(Colors.white.withOpacity(0.05), BlendMode.dstATop),
    image: AssetImage(
      'assets/images/background-01.png',
    ),
    fit: BoxFit.cover,
  ),
);

//LOGO
final logo = Card(
  semanticContainer: true,
  clipBehavior: Clip.antiAliasWithSaveLayer,
  shape: RoundedRectangleBorder(
    side: const BorderSide(color: Colors.white, width: 0),
    borderRadius: BorderRadius.circular(25.0),
  ),
  margin: const EdgeInsets.all(0.0),
  elevation: 0.0,
  color: Colors.white,
  child: Padding(
    padding: const EdgeInsets.all(10),
    child: Image.asset(
      'assets/images/logo.png',
      fit: BoxFit.cover,
      width: 60,
      height: 60,
    ),
  ),
);

SnackBar snackbar(context, message, duration) {
  SnackBar snackBar = SnackBar(
    backgroundColor: Theme.of(context).colorScheme.onBackground,
    dismissDirection: DismissDirection.down,
    duration: Duration(seconds: duration),
    behavior: SnackBarBehavior.floating,
    content:
        "$message".text.color(Theme.of(context).colorScheme.background).make(),
  );
  return snackBar;
}
