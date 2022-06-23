import 'dart:convert';

import 'package:brindavan_student/models/dynamicFormModel.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../models/gSheetsCred.dart';
import '../../../utils/constants.dart';

class DynamicFormPAge extends StatefulWidget {
  final DynamicFormData? formData;
  const DynamicFormPAge({Key? key, required this.formData}) : super(key: key);

  @override
  State<DynamicFormPAge> createState() => _DynamicFormPAgeState();
}

class _DynamicFormPAgeState extends State<DynamicFormPAge> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String msg = '';
  //
  // List<dynamic> formData = [
  //   {"type": "s", "fieldName": "usn"},
  //   {"type": "s", "fieldName": "name"},
  //   {"type": "i", "fieldName": "marks"},
  //   {"type": "i", "fieldName": "cgpa"},
  // ];
  int _count = 0;
  String? _result;
  List<dynamic>? _values;

  @override
  void initState() {
    super.initState();
    _count = widget.formData!.form.length;
    _values = [];
    _result = "";
  }

  @override
  Widget build(BuildContext context) {
    var data = widget.formData;
    var enabledBorder = OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).hintColor));
    var fillColor = Theme.of(context).cardColor;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: data!.name.text.make(),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _count++;
                });
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                setState(() {
                  _count = 0;
                });
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: _count,
                      itemBuilder: (context, index) {
                        var fieldName = data.form[index]["fieldName"];
                        var type = data.form[index]["type"];
                        return _row(
                            index, enabledBorder, fillColor, fieldName, type);
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 10,
                            primary: Theme.of(context).primaryColor,
                            onPrimary: Colors.black.withOpacity(0.05),
                          ),
                          onPressed: !_loading
                              ? () async {
                                  setState(() {
                                    _loading = true;
                                  });
                                  await UserSheetsApi(
                                          spreadsheetId: data.formId,
                                          sheetName: data.sheetName)
                                      .init();
                                  _values!.sort(
                                      (a, b) => (a['id']).compareTo(b['id']));
                                  Map<String, dynamic> formDataValues = {};
                                  if (_formKey.currentState!.validate()) {
                                    for (int i = 0; i < _values!.length; i++) {
                                      formDataValues.addEntries([
                                        MapEntry(
                                            data.form[i]['fieldName']
                                                .toString(),
                                            _values![i][data.form[i]
                                                    ['fieldName']
                                                .toString()])
                                      ]);

                                      dynamic result = await UserSheetsApi(
                                              spreadsheetId: data.formId,
                                              sheetName: data.sheetName)
                                          .insert(formDataValues);

                                      print(result);

                                      if (result != null) {
                                        setState(() {
                                          _loading = false;
                                          msg = "data updated successfully";
                                        });
                                      }
                                    }
                                  } else {
                                    setState(() {
                                      _loading = false;
                                    });
                                  }
                                }
                              : null,
                          child: 'SUBMIT'.text.sm.bold.white.make().p16().px1())
                      .p16(),
                  _loading ? const CircularProgressIndicator() : msg.text.make()
                ],
              ),
            ),
          )),
    );
  }

  _row(int key, var enabledBorder, var fillColor, var fieldName, var type) {
    return TextFormField(
      decoration: textInputDecoration.copyWith(
          hintText: 'Enter $fieldName',
          labelText: '$fieldName',
          enabledBorder: enabledBorder,
          fillColor: fillColor),
      onChanged: (val) => {_onUpdate(key, fieldName, val, type)},
      validator: (val) {
        bool stringMatch = RegExp('[a-zA-Z]').hasMatch(val!.trim());
        bool number = RegExp(r'\d').hasMatch(val.trim());
        if (val.isEmpty) {
          return 'This field is required';
        } else if (type == "i") {
          if (!number) {
            return 'Enter only numbers from 0-9';
          }
        } else if (type == "s") {
          if (!stringMatch) {
            return 'Enter only characters from a-b or A-B';
          }
        }

        return null;
      },
    ).py(8);
  }

  _onUpdate(int key, var fieldName, dynamic val, var type) {
    int foundKey = -1;
    for (var map in _values!) {
      if (map.containsKey('id')) {
        if (map['id'] == key) {
          foundKey = key;
          break;
        }
      }
    }
    if (-1 != foundKey) {
      _values!.removeWhere((map) {
        return map['id'] == foundKey;
      });
    }

    if (type == "i") {
      int.parse(val);
    }
    Map<String, dynamic> json = {"id": key, fieldName.toString(): val};

    _values!.add(json);

    setState(() {
      _result = _prittyPrint(_values);
    });
  }

  String _prittyPrint(jsonObject) {
    var encoder = const JsonEncoder.withIndent('     ');
    return encoder.convert(jsonObject);
  }
}
