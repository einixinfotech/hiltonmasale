import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hilton_masale/common/common.dart';
import 'package:hilton_masale/db/cart_database.dart';
import 'package:hilton_masale/models/cart_model.dart';
import 'package:hilton_masale/res/values/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

void enableFullScreenUI() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    statusBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
  ));
}

Future<void> clearCart() async {
  print("clearCart");
  CartDatabase.instance.getListOfItemsInCart().then((value) {
    for (CartModel currentItem in value) {
      CartDatabase.instance.delete(currentItem.productId);
    }
  });
}

void enableNormalUI() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    // navigation bar color
    statusBarColor: Colors.transparent,
    // status bar color
    statusBarBrightness: Brightness.light,
    //status bar brightness
    statusBarIconBrightness: Brightness.light,
    //status barIcon Brightness
    //systemNavigationBarDividerColor: Colors.greenAccent,
    //Navigation bar divider color
    systemNavigationBarIconBrightness: Brightness.light,
    //navigation bar icon
  ));
}

void showSnackBar(
    BuildContext context, String message, int durationInMilliseconds) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: Duration(milliseconds: durationInMilliseconds),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showActionSnackBar(BuildContext context, String message, String action,
    Function functionToPerform, int durationInMilliseconds) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: Duration(milliseconds: durationInMilliseconds),
    action: SnackBarAction(
        label: action,
        textColor: primaryColor,
        onPressed: () {
          functionToPerform();
        }),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<void> logout(BuildContext context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.clear();
  Common.isLoggedIn = false;
  // todo
  /* Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (builder) => WelcomeUI()), (route) => false);*/
}

void pushToNewRoute(BuildContext context, Widget routeName) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => routeName));
}

void pushToNewRouteAndClearAll(BuildContext context, Widget routeName) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (_) => routeName), (route) => false);
}

void showLoadingDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
        Container(
            child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text("Please wait..."),
        )),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
