import 'dart:async';
import 'package:brindavan_student/services/auth.dart';
import 'package:brindavan_student/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? error = '';
  String? errorSuccess = '';
  bool _enable = true;
  bool loading = false;

  int _btnEnable = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: 'Password Reset'.text.white.make(),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            '${error}'.text.red700.center.make().px24(),
            '$errorSuccess'.text.green500.center.make().px24(),
            TextFormField(
              enabled: _enable,
              decoration: textInputDecoration.copyWith(
                  hintText: 'Enter Email', labelText: 'Email'),
              onChanged: (val) {
                setState(() {
                  email = val;
                });
              },
              validator: (val) {
                if (val!.isEmpty) {
                  return 'This field is required';
                } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(val)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ).px32().py12(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                                            elevation: 10,
                                            primary:
                                                Theme.of(context).primaryColor,
                                            onPrimary: Colors.grey,
                                            // shape: RoundedRectangleBorder(
                                            //   borderRadius:
                                            //       BorderRadius.circular(8),
                                            // ),
                                          ),
              child: 'RESET PASSWORD'.text.white.make().p16().px1(),
              onPressed: _btnEnable == 1
                  ? () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _enable = false;

                          _btnEnable = 0;
                        });
                        dynamic result = await _auth.resetPassword(email);
                        print(result);
                        if (result == false) {
                          setState(() {
                            _btnEnable = 1;

                            loading = true;
                            _enable = true;

                            error =
                                'Error sending password reset email to this link';
                          });
                        } else {
                          setState(() {
                            loading = true;
                            _btnEnable = 0;
                            _enable = false;
                            errorSuccess =
                                'Pasword Reset link successfully sent to ${email}';
                            email = '';
                            Timer(Duration(seconds: 6),
                                () => Navigator.of(context).pop());
                          });
                        }
                      }
                    }
                  : null,
            ).p16(),
            loading ? CircularProgressIndicator() : ''.text.make(),
          ],
        ).py32(),
      ),
    );
  }
}
