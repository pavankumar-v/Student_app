import 'package:brindavan_student/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({Key? key}) : super(key: key);

  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          
            ),
        title: Text('Theme'),
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Text('Dark Mode',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              Spacer(),
              Switch(
                value: themeChange.darkTheme,
                onChanged: (bool? value) {
                  setState(() {
                    themeChange.darkTheme = value!;
                  });
                  themeChange.darkTheme = value!;
                },
                activeColor: Theme.of(context).primaryColor,
              ),
            ],
          )),
    );
  }
}
