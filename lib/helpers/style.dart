import 'package:flutter/material.dart';

//*******************  FONT COLOR   ************//
const Color bodyTextColor = Color(0xff202124);
const Color subtitleTextColor = Color(0xff424242);
const Color buttonTextColor = Colors.white;
var primaryColor = Color(0xffffffff);
var titleColor = Color(0xff333333);
var primaryAccentColor = Color(0xff006064);
var successBtn = Color(0xff00C853);
var failedBtn = Color(0xffd50000);
const Color btnColor = Color(0xff00c16e);
final Color grey = Color(0xff8e8e8e);

//*******************  FONT SIZE   ************//
const double bodyTextSize = 14;
const double titleTextSize = 16;
const double headingTextSize = 28;
const double subtitleTextSize = 12;
const double appbarTextSize = 18;

//*******************  FONT SIZE   ************//
const double buttonWidgetSize = 45;

//*******************  FONT FAMILY   ************//
const String fontDefault = 'OpenSans';

//*******************  TEXT STYLE   ************//

const appbarTextStyle = TextStyle(
    fontFamily: fontDefault,
    fontSize: appbarTextSize,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.7,
    wordSpacing: 1,
    height: 1.5,
    color: buttonTextColor);

const headingTextStyle = TextStyle(
    fontFamily: fontDefault,
    fontSize: headingTextSize,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.3,
    wordSpacing: 1,
    height: 1.5,
    color: bodyTextColor);

const headingLightTextStyle = TextStyle(
    fontFamily: fontDefault,
    fontSize: headingTextSize,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.3,
    wordSpacing: 1,
    height: 1.5,
    color: buttonTextColor);
const titleTextStyle = TextStyle(
    fontFamily: fontDefault,
    fontSize: titleTextSize,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    wordSpacing: 1,
    height: 1.5,
    color: bodyTextColor);

const subtitleTextStyle = TextStyle(
    fontFamily: fontDefault,
    fontSize: subtitleTextSize,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    wordSpacing: 1,
    height: 1.5,
    color: subtitleTextColor);

const bodyTextStyle = TextStyle(
    fontFamily: fontDefault,
    fontSize: bodyTextSize,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    wordSpacing: 1,
    height: 1.5,
    color: bodyTextColor);

const flatTextStyle = TextStyle(
    fontFamily: fontDefault,
    fontSize: bodyTextSize,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
    wordSpacing: 1,
    color: btnColor);

const buttonTextStyle = TextStyle(
  fontSize: bodyTextSize,
  fontWeight: FontWeight.w600,
  letterSpacing: 1,
  wordSpacing: 1.3,
  height: 1.5,
  color: buttonTextColor,
);

const TextStyle productListTitle = TextStyle(
  fontWeight: FontWeight.w400,
  letterSpacing: 0.5,
  height: 1.3,
  color: Color(0xff333333),
  wordSpacing: 1,
  fontSize: 12,
);

const TextStyle txtButton = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    letterSpacing: 0.6,
    color: Color(0xff006064),
    fontWeight: FontWeight.w500);
