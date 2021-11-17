import 'package:flutter/material.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/res/strings/strings.dart';
import 'package:hilton_masale/res/values/colors.dart';
import 'package:lottie/lottie.dart';

import '../ui/home_screen_ui.dart';

class EmptyScreenUI extends StatefulWidget {
  String emptyMessage;
  bool isButtonVisible;

  EmptyScreenUI(this.emptyMessage, this.isButtonVisible);

  @override
  _EmptyScreenUIState createState() => _EmptyScreenUIState();
}

class _EmptyScreenUIState extends State<EmptyScreenUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Lottie.asset(emptyAnim, repeat: false),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              widget.emptyMessage,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800]),
            ),
            SizedBox(
              height: 40,
            ),
            Visibility(
                visible: widget.isButtonVisible,
                child: Container(
                  height: 40,
                  width: 200,
                  child: ElevatedButton(
                    // onPressed: () => pushToNewRouteAndClearAll(context, HomeScreeUI()),
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                    ),
                    child: Text(
                      "Shop now".toUpperCase(),
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
