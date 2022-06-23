import 'package:brindavan_student/view/authentication/reset.dart';
import 'package:brindavan_student/services/auth.dart';
import 'package:brindavan_student/utils/constants.dart';
import 'package:brindavan_student/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  const Login({required this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //
  final AuthService _auth = AuthService();
  //
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  bool _pageLoading = false;
  bool isHiddenPassword = true;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  //
  @override
  Widget build(BuildContext context) {
    var enabledBorder = OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).hintColor));
    var fillColor = Theme.of(context).cardColor;
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            resizeToAvoidBottomInset: true,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: backgroundImage,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  spreadRadius: 0,
                                  blurRadius: 16,
                                  offset: const Offset(
                                      0, 16), // changes position of shadow
                                ),
                              ],
                            ),
                            child: logo,
                          ).p12(),
                          Container(
                            child: 'Login'
                                .text
                                .xl5
                                .fontWeight(FontWeight.bold)
                                .make(),
                          ).py16(),
                          Container(
                            child: 'Access account'.text.base.make(),
                          ).py1(),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                'if you\'re new/'.text.base.make(),
                                InkWell(
                                  child: 'create account'
                                      .text
                                      .base
                                      .color(Theme.of(context).primaryColor)
                                      .underline
                                      .make(),
                                  onTap: () {
                                    widget.toggleView();
                                  },
                                ),
                              ],
                            ).py12(),
                          ).py1(),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Enter Email',
                                labelText: 'Email',
                                prefixIcon: const Icon(Icons.mail),
                                enabledBorder: enabledBorder,
                                fillColor: fillColor),
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'This field is required';
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ).px32().py12(),
                          TextFormField(
                            obscureText: isHiddenPassword,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Enter Password',
                                labelText: 'Password',
                                suffixIcon: InkWell(
                                  onTap: _togglePasswordView,
                                  child: const Icon(Icons.visibility),
                                ),
                                prefixIcon: const Icon(Icons.vpn_key),
                                enabledBorder: enabledBorder,
                                fillColor: fillColor),
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'This field is required';
                              } else if (val.length < 6) {
                                return 'Password mush be greater than 6 charecters';
                              }
                              return null;
                            },
                          ).px32().py12(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ResetScreen()));
                            },
                            child: 'forgot password?'
                                .text
                                .base
                                .underline
                                .color(Theme.of(context).primaryColor)
                                .make(),
                          ).p12(),
                          ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 10,
                                    primary: Theme.of(context).primaryColor,
                                    onPrimary: Colors.black.withOpacity(0.05),
                                  ),
                                  onPressed: !_pageLoading
                                      ? () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              _pageLoading = true;
                                            });
                                            dynamic result = await _auth
                                                .signInWithEmailAndPassword(
                                                    email, password);
                                            if (!result) {
                                              setState(() {
                                                error =
                                                    'Either email is not registered or password is wrong';
                                                _pageLoading = false;
                                              });
                                            } else {
                                              loading = true;
                                            }
                                          }
                                        }
                                      : null,
                                  child: 'LOGIN'
                                      .text
                                      .sm
                                      .bold
                                      .white
                                      .make()
                                      .p16()
                                      .px1())
                              .p16(),
                          _pageLoading
                              ? const CircularProgressIndicator()
                              : Container(),
                          error.text.red500.center.make().px24().py12()
                        ],
                      ).p12().py64(),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }
}
