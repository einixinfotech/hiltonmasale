import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hilton_masale/common/common.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/network/api.dart';
import 'package:hilton_masale/res/strings/strings.dart';
import 'package:hilton_masale/res/values/colors.dart';
import 'package:hilton_masale/ui/home_screen_ui.dart';
import 'package:hilton_masale/ui/register_ui.dart';
import 'package:hilton_masale/ui/verify_otp_ui.dart';

class WelcomeUI extends StatefulWidget {
  const WelcomeUI({Key? key}) : super(key: key);

  @override
  _WelcomeUIState createState() => _WelcomeUIState();
}

class _WelcomeUIState extends State<WelcomeUI> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Image.asset(imagePath + "launcher_icon.png"),
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  maxLength: 10,
                  validator: MultiValidator([
                    RequiredValidator(
                        errorText: 'Please provide a phone number'),
                    LengthRangeValidator(
                        min: 10,
                        max: 10,
                        errorText: 'Please enter a valid phone number'),
                  ]),
                  keyboardType: TextInputType.phone,
                  controller: _mobileController,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: "Mobile number",
                    counterText: "",
                    prefixIcon: Icon(Icons.phone_android),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 56,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 50,
                                child: TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _login();
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.pressed))
                                          return primaryColor;
                                        return primaryColor; // Use the component's default.
                                      },
                                    ),
                                  ),
                                  child: Text("Login to continue",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          letterSpacing: 0.3)),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: SizedBox(
                                    height: 50,
                                    child: TextButton.icon(
                                      onPressed: () {
                                        pushToNewRoute(context, HomeScreeUI());
                                      },
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .all(Color(0xFFCDCDCD)),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              8))))),
                                      icon: Icon(
                                        Icons.home_rounded,
                                        color: Colors.black,
                                      ),
                                      label: Text(
                                        "Skip login",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            letterSpacing: 0.3),
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () => pushToNewRoute(context, RegisterUI()),
        child: Container(
          color: primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? Register",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      letterSpacing: 0.6,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() {
    setState(() {
      _isLoading = true;
      Map<String, String> formData = {
        "mobile": _mobileController.text,
        // "name": "name",
        // "type": "0",
        // "address": "address",
        // "firmname": "firmname",
        // "gstno": "gstno",
        // "fssai": "fssai",
        // "state": "state",
        // "city": "sirsa"
      };
      print("loginresponseis ${jsonEncode(formData)}");
      sendOTPApi(formData).then((value) async {
        setState(() {
          _isLoading = false;
          print("loginresponseis ${value.body}");
          var responseData = jsonDecode(value.body);
          if (responseData[Common.successKey]) {
            //  var responseOTP = responseData['otp'];
            // showSnackBar(context, responseOTP.toString(), 1500);

            Future.delayed(const Duration(milliseconds: 1500), () {
              showSnackBar(
                  context,
                  "OTP Sent on your number: ${_mobileController.text.trim()}",
                  1500);
              pushToNewRoute(
                  context,
                  VerifyOtpUI(
                      _mobileController.text.trim(),
                      // "name",
                      // "0",
                      // "address",
                      // "firmname",
                      // "gstno",
                      // "fssai",
                      // "state",
                      // "city"
                  ));
            });
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            showSnackBar(context, "Server error please try again later", 1500);
          } else {
            showSnackBar(context, responseData[Common.responseKey], 1500);
          }
        });
      }).catchError((onError) {
        setState(() {
          _isLoading = false;
          print("sendOTPApiApiError $onError");
        });
      });
    });
  }
}
