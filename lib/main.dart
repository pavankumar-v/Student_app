import 'package:brindavan_student/models/gSheetsCred.dart';
import 'package:brindavan_student/models/user.dart';
import 'package:brindavan_student/provider/data_provider.dart';
import 'package:brindavan_student/view/splash_creen.dart';
import 'package:brindavan_student/services/auth.dart';
import 'package:brindavan_student/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  await Firebase.initializeApp();
  await UserSheetsApi(sheetName: '', spreadsheetId: '').init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DataProvider()),
        // Provider(create: (context) => DataProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePrefrence.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
          builder: (BuildContext context, value, Widget? child) {
        return StreamProvider<MyUser?>.value(
          catchError: (_, __) => null,
          initialData: null,
          value: AuthService().user,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            home: const SplashScreen(),
          ),
        );
      }),
    );
  }
}
