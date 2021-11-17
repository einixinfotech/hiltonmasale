import 'package:flutter/material.dart';
import 'package:hilton_masale/common/common.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/res/strings/strings.dart';
import 'package:hilton_masale/res/values/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen_ui.dart';

class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({Key? key}) : super(key: key);

  @override
  _SplashScreenUIState createState() => _SplashScreenUIState();
}

class _SplashScreenUIState extends State<SplashScreenUI> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Color(0xfff9f9f9),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: size.width / 1,
                height: size.height / 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset("assets/images/launcher_icon.png"),
                ),
              ),
              CircularProgressIndicator()
            ],
          ),
        ),
      ),
      // bottomNavigationBar: InkWell(
      //   child: Container(
      //     color: primaryColor,
      //     child: Padding(
      //       padding: const EdgeInsets.all(12.0),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Text(
      //             "Powered by Einix Infotech",
      //             style: TextStyle(
      //                 fontFamily: 'Poppins',
      //                 fontSize: 16,
      //                 letterSpacing: 0.6,
      //                 color: Colors.white,
      //                 fontWeight: FontWeight.w500),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkIfUserIsLoggedIn().catchError((onError) {
      print("checkIfUserIsLoggedInError: $onError");
    });
  }

  Future<void> checkIfUserIsLoggedIn() async {
    print("Checking...");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey(Common.isLoggedInKey)) {
      print("Checking... Key Exists");
      if (sharedPreferences.getBool(Common.isLoggedInKey) != null) {
        print("Checking... Key is not null");
        if (sharedPreferences.getBool(Common.isLoggedInKey)!) {
          print(
              "Checking... isLoggedIn?: ${sharedPreferences.getBool(Common.isLoggedInKey)}");
          //Common.userId = sharedPreferences.getString(Common.userIdKey);
          Common.userMobile = sharedPreferences.getString(Common.userMobileNumberKey);
          Common.isLoggedIn = true;
          Common.userToken = sharedPreferences.getString(Common.tokenKey);
          proceedToHome();
        } else {
          proceedToHome();
        }
      } else {
        print("Checking... Key is null");
        proceedToHome();
      }
    } else {
      proceedToHome();
    }
  }

  void proceedToHome() {
    enableNormalUI();
    print("handleNewUser");
    Future.delayed(Duration(milliseconds: 2000), () {
      print("LOL");
      pushToNewRouteAndClearAll(context, HomeScreeUI());
    });
  }
}
