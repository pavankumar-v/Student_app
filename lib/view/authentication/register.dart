import 'package:brindavan_student/services/auth.dart';
import 'package:brindavan_student/services/database.dart';
import 'package:brindavan_student/utils/constants.dart';
import 'package:brindavan_student/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //

  //
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool _pageLoading = false;
  bool isHiddenPassword = true;

  //Text Field
  String? usn;
  String? branch;
  String? email;
  String? password;
  String error = '';
  @override
  Widget build(BuildContext context) {
    var enabledBorder = OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).hintColor));
    var fillColor = Theme.of(context).cardColor;
    return loading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Theme.of(context).backgroundColor,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
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
                            child: 'Register'
                                .text
                                .xl5
                                .fontWeight(FontWeight.bold)
                                .make(),
                          ).py16(),
                          Container(
                            child: 'Create account'.text.base.make(),
                          ).py1(),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                'Already Registered?/'.text.base.make(),
                                InkWell(
                                  child: 'Login Here'
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
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r"\s\b|\b\s"))
                                  ],
                                  maxLength: 10,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'Enter USN',
                                      labelText: 'USN',
                                      prefixIcon:
                                          const Icon(Icons.badge_rounded),
                                      enabledBorder: enabledBorder,
                                      fillColor: fillColor,
                                      counter: const SizedBox.shrink()),
                                  onChanged: (val) async {
                                    setState(() {
                                      usn = val;
                                    });
                                  },
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'This field is required';
                                    } else if (!RegExp(
                                            r"1BO+([0-9]{2})+([A-Z]{2})+[0-9]{3}")
                                        .hasMatch(val.toUpperCase())) {
                                      return 'Enter valid USN';
                                    } else if (val.length > 11) {
                                      return 'Enter valid USN';
                                    }
                                    return null;
                                  },
                                ).px32().py12().w64(context),
                                SizedBox(
                                  width: 110,
                                  height: 60,
                                  child: DropdownButtonFormField(
                                    decoration: textInputDecoration.copyWith(
                                        fillColor: fillColor,
                                        enabledBorder: enabledBorder,
                                        hintText: 'branch'),
                                    items: <String>[
                                      "CSE",
                                      "ISE",
                                      "ECE",
                                      "CIV",
                                      "MECH",
                                      "ISE",
                                    ].map<DropdownMenuItem<String>>(
                                        (String? value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (value) => setState(
                                        () => branch = value as String),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'select branch';
                                      }
                                      return null;
                                    },
                                  ),
                                )
                              ]),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Enter Email',
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.mail),
                              fillColor: fillColor,
                              enabledBorder: enabledBorder,
                            ),
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
                              fillColor: fillColor,
                              labelText: 'Password',
                              suffixIcon: InkWell(
                                onTap: _togglePasswordView,
                                child: const Icon(Icons.visibility),
                              ),
                              prefixIcon: const Icon(Icons.vpn_key),
                              enabledBorder: enabledBorder,
                            ),
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
                          ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor),
                                  onPressed: !_pageLoading
                                      ? () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            print(usn);
                                            setState(() {
                                              _pageLoading = true;
                                            });
                                            dynamic result = await _db.checkUsn(
                                                usn!.toLowerCase(), branch!);
                                            print(result);

                                            if (result == null) {
                                              setState(() {
                                                error = 'Unable to register';
                                                _pageLoading = false;
                                              });
                                            }

                                            if (result) {
                                              dynamic authResult = await _auth
                                                  .registerWithEmailAndPassword(
                                                      email!,
                                                      password!,
                                                      usn!.toLowerCase(),
                                                      branch!);
                                              if (!authResult) {
                                                setState(() {
                                                  error =
                                                      'The email address is already in use by another account';
                                                  _pageLoading = false;
                                                });
                                              } else {
                                                loading = true;
                                              }
                                            } else {}
                                          }
                                        }
                                      : null,
                                  child: 'REGISTER'
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
