import 'package:brindavan_student/view/wrapper.dart';
import 'package:brindavan_student/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:brindavan_student/models/user.dart';
import 'package:brindavan_student/services/database.dart';
import 'package:brindavan_student/utils/constants.dart';

class EnterDetails extends StatefulWidget {
  final UserData userData;
  // ignore: use_key_in_widget_constructors
  const EnterDetails({required this.userData});

  @override
  State<EnterDetails> createState() => _EnterDetailsState();
}

class _EnterDetailsState extends State<EnterDetails> {
  // final nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? _fullName;

  int? _sem;

  String? _section;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final DatabaseService db = DatabaseService();
    var enabledBorder = OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).hintColor));
    var fillColor = Theme.of(context).cardColor;

    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: 'Enter Details'.text.make(),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 30,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Full Name',
                          labelText: 'Full Name',
                          enabledBorder: enabledBorder,
                          fillColor: fillColor,
                          counter: const SizedBox.shrink()),
                      onChanged: (val) {
                        // entryController.text = val;
                        setState(() {
                          _fullName = val.toUpperCase();
                        });
                      },
                      // controller: nameController,
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return 'This field is required';
                        } else if (!RegExp(r"[A-Za-z\s]+$")
                            .hasMatch(val.trim().toUpperCase())) {
                          return 'Special characters & numbers not allowed';
                        } else if (!val
                            .trim()
                            .contains(RegExp(r"[A-Za-z]+$"))) {
                          return 'Invalid name';
                        } else if (val.trim().length < 4) {
                          return 'Enter Valid Name';
                        }

                        return null;
                      },
                    ),
                    DropdownButtonFormField<int>(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Select sem',
                          enabledBorder: enabledBorder,
                          fillColor: fillColor),
                      items: <int>[1, 2, 3, 4, 5, 6, 7, 8]
                          .map<DropdownMenuItem<int>>((int? value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _sem = value as int),
                      validator: (value) {
                        if (value == null) {
                          return 'select sem';
                        }
                        return null;
                      },
                    ).pLTRB(0, 5, 0, 12),
                    DropdownButtonFormField<String>(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Select section',
                          enabledBorder: enabledBorder,
                          fillColor: fillColor),
                      items: <String>[
                        'A',
                        'B',
                        'C',
                      ].map<DropdownMenuItem<String>>((String? value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _section = value),
                      validator: (value) {
                        if (value == null) {
                          return 'select sem';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              primary: Theme.of(context).primaryColor,
                              onPrimary: Colors.grey,
                              // shape: RoundedRectangleBorder(
                              //   borderRadius:
                              //       BorderRadius.circular(8),
                              // ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                print(_sem);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => const Wrapper()));
                                dynamic result =
                                    await DatabaseService(sem: _sem!.toString())
                                        .updateUserData(
                                            widget.userData.usn,
                                            _fullName!,
                                            _sem!.toInt(),
                                            _section!,
                                            widget.userData.branch);

                                print(result);
                              }
                            },
                            child: 'SUBMIT'.text.white.make().p16().px1())
                        .p(20),
                  ],
                ),
              ).p16(),
            ),
          );
  }
}
