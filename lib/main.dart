
import 'package:flutter/material.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/res/style/style.dart';
import 'package:hilton_masale/res/values/colors.dart';
import 'package:hilton_masale/ui/splash_screen_ui.dart';

void main() {
  enableFullScreenUI();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hilton Masala',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: swatchColor,
          primaryColor: primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(button: buttonTextStyle, headline6: productListTitle)),
      home: SplashScreenUI(),
    );
  }
}
