import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hilton_masale/common/common.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/network/api.dart';
import 'package:hilton_masale/res/values/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen_ui.dart';

class VerifyOtpUI extends StatefulWidget {
  String enteredPhoneNumber;
  String? name;
  String? type;
  String? address;
  String? firmname;
  String? gstno;
  String? password;
  String? fssai;
  String? state;
  String? city;
  String? otp;
  String? email;
  String? pincode;
  String? gender;
  String? sponsor;
  bool isRegistering;

  VerifyOtpUI(this.enteredPhoneNumber,
      {this.name,
      this.type,
      this.address,
      this.firmname,
        this.gender,
        this.password,
      this.gstno,
        this.sponsor,
        this.email,
        this.pincode,
      this.fssai,
      this.state,
      this.city,
        this.isRegistering = false,
      });

  @override
  _VerifyOtpUIState createState() => _VerifyOtpUIState();
}

class _VerifyOtpUIState extends State<VerifyOtpUI>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController controller;
  late Animation<double> animation;
  late Timer _timer;
  int _countDownTimer = 30;
  bool _isLoading = false, _isVerifying = false;

  TextEditingController _edtController1 = TextEditingController();
  TextEditingController _edtController2 = TextEditingController();
  TextEditingController _edtController3 = TextEditingController();
  TextEditingController _edtController4 = TextEditingController();
  TextEditingController _edtController5 = TextEditingController();
  TextEditingController _edtController6 = TextEditingController();

  bool isTaped = false;

  bool isButtonEnabled = false;

  bool isEmpty() {
    setState(() {
      if ((_edtController1.text.length == 1) &&
          (_edtController2.text.length == 1) &&
          (_edtController3.text.length == 1) &&
          (_edtController4.text.length == 1) &&
          (_edtController5.text.length == 1) &&
          (_edtController6.text.length == 1)) {
        isButtonEnabled = true;
      } else {
        isButtonEnabled = false;
      }
    });
    return isButtonEnabled;
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 4000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {});
    controller.repeat();
    startTimer();
  }

  @override
  void dispose() {
    controller.stop();
    _timer.cancel();
    super.dispose();
  }
  TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //howInSnackBar(Common.OTP);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 120,
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Verify your OTP".toUpperCase(),
                          style: Theme.of(context).textTheme.subtitle1),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "OTP sent to ${widget.enteredPhoneNumber}",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter OTP".toUpperCase(),
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    /*Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 0.0, right: 16),
                            child: TextField(
                                controller: _edtController1,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.subtitle2,
                                onSubmitted: null,
                                onChanged: (val) {
                                  setState(() {
                                    FocusScope.of(context).nextFocus();
                                    isEmpty();
                                  });
                                },
                                obscureText: false,
                                decoration: InputDecoration(
                                  counterText: "",
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                                controller: _edtController2,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.subtitle2,
                                onSubmitted: null,
                                onChanged: (val) {
                                  setState(() {
                                    FocusScope.of(context).nextFocus();
                                    isEmpty();
                                  });
                                },
                                obscureText: false,
                                decoration: InputDecoration(
                                  counterText: "",
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: TextField(
                                controller: _edtController3,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.subtitle2,
                                onSubmitted: null,
                                onChanged: (val) {
                                  // if (val == "") {
                                  //   FocusScope.of(context).previousFocus();
                                  // }else
                                  setState(() {
                                    FocusScope.of(context).nextFocus();
                                    isEmpty();
                                  });
                                },
                                obscureText: false,
                                decoration: InputDecoration(
                                  counterText: "",
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 0),
                            child: TextField(
                                controller: _edtController4,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.subtitle2,
                                onSubmitted: null,
                                onChanged: (val) {
                                  setState(() {
                                    FocusScope.of(context).nextFocus();
                                    isEmpty();
                                  });
                                },
                                obscureText: false,
                                decoration: InputDecoration(
                                  counterText: "",
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 0),
                            child: TextField(
                                controller: _edtController5,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.subtitle2,
                                onSubmitted: null,
                                onChanged: (val) {
                                  setState(() {
                                    FocusScope.of(context).nextFocus();
                                    isEmpty();
                                  });
                                },
                                obscureText: false,
                                decoration: InputDecoration(
                                  counterText: "",
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 0),
                            child: TextField(
                                controller: _edtController6,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.subtitle2,
                                onSubmitted: null,
                                onChanged: (val) {
                                  setState(() {
                                    FocusScope.of(context).nextFocus();
                                    isEmpty();
                                  });
                                },
                                obscureText: false,
                                decoration: InputDecoration(
                                  counterText: "",
                                )),
                          ),
                        ),
                      ],
                    ),

                  */
                    /*Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 0.0, right: 16),
                            child: TextField(
                                controller: _edtController1,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.subtitle2,
                                onSubmitted: null,
                                onChanged: (val) {
                                  setState(() {
                                    FocusScope.of(context).nextFocus();
                                    isEmpty();
                                  });
                                },
                                obscureText: false,
                                decoration: InputDecoration(
                                  counterText: "",
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                                controller: _edtController2,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.subtitle2,
                                onSubmitted: null,
                                onChanged: (val) {
                                  setState(() {
                                    FocusScope.of(context).nextFocus();
                                    isEmpty();
                                  });
                                },
                                obscureText: false,
                                decoration: InputDecoration(
                                  counterText: "",
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: TextField(
                                controller: _edtController3,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.subtitle2,
                                onSubmitted: null,
                                onChanged: (val) {
                                  // if (val == "") {
                                  //   FocusScope.of(context).previousFocus();
                                  // }else
                                  setState(() {
                                    FocusScope.of(context).nextFocus();
                                    isEmpty();
                                  });
                                },
                                obscureText: false,
                                decoration: InputDecoration(
                                  counterText: "",
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 0),
                            child: TextField(
                                controller: _edtController4,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.subtitle2,
                                onSubmitted: null,
                                onChanged: (val) {
                                  setState(() {
                                    FocusScope.of(context).nextFocus();
                                    isEmpty();
                                  });
                                },
                                obscureText: false,
                                decoration: InputDecoration(
                                  counterText: "",
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 0),
                            child: TextField(
                                controller: _edtController5,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.subtitle2,
                                onSubmitted: null,
                                onChanged: (val) {
                                  setState(() {
                                    FocusScope.of(context).nextFocus();
                                    isEmpty();
                                  });
                                },
                                obscureText: false,
                                decoration: InputDecoration(
                                  counterText: "",
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 0),
                            child: TextField(
                                controller: _edtController6,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.subtitle2,
                                onSubmitted: null,
                                onChanged: (val) {
                                  setState(() {
                                    FocusScope.of(context).nextFocus();
                                    isEmpty();
                                  });
                                },
                                obscureText: false,
                                decoration: InputDecoration(
                                  counterText: "",
                                )),
                          ),
                        ),
                      ],
                    ),*/
                    SizedBox(
                      height: 20,
                    ),
                    PinCodeTextField(
                      length: 6,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      animationType: AnimationType.fade,
                      enablePinAutofill: true,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.underline,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        selectedColor: Colors.blue.shade50,
                        activeColor: Colors.blue.shade50,
                        selectedFillColor: Colors.blue.shade50,
                        inactiveFillColor: Colors.white,
                        disabledColor: Colors.white,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                      ),
                      animationDuration: Duration(milliseconds: 300),
                      cursorColor: Colors.black,
                      backgroundColor: Colors.white,
                      enableActiveFill: true,
                      controller: _otpController,
                      onCompleted: (v) {
                        isButtonEnabled = true;
                        print("Completed: " + v);
                      },
                      beforeTextPaste: (text) {
                        return false;
                      },
                      appContext: context,
                      onChanged: (String value) {
                        setState(() {
                          if (value.length == 6) {
                            isButtonEnabled = true;
                          } else {
                            isButtonEnabled = false;
                          }
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _countDownTimer == 0 ? Container() :
                        Text(
                          _countDownTimer.toString() + " ".toUpperCase(),
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        _countDownTimer == 0
                            ? InkWell(
                                onTap: () {
                                  if (_countDownTimer == 0) {
                                    resendOTP();
                                  } else {
                                    showSnackBar(context, "Please wait...", 1500);
                                  }
                                },
                                child: _isLoading
                                    ? SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                            color: Colors.amber))
                                    : Text(
                                        "resend".toUpperCase(),
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            letterSpacing: 0.6,
                                            color: primaryColor,
                                            fontWeight: FontWeight.w500),
                                      ))
                            : Text("")
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    isTaped
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              LinearProgressIndicator(
                                minHeight: 45,
                                value: animation.value,
                                backgroundColor: Colors.red[100],
                                semanticsLabel: "Loading...",
                                semanticsValue: "Loading...",
                              ),
                              Text(
                                "Wait a movement",
                                style: Theme.of(context).textTheme.button,
                              ),
                            ],
                          )
                        : _isVerifying
                            ? Center(child: CircularProgressIndicator())
                            : SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 45,
                                child: RaisedButton(
                                  elevation: 0,
                                  onPressed: isButtonEnabled
                                      ? () {
                                          setState(() {
                                            print(_otpController.text);
                                            registerUser(_otpController.text.trim());
                                          });
                                        }
                                      : null,
                                  child: Text(
                                    isButtonEnabled
                                        ? "continue".toUpperCase()
                                        : "Enter OTP",
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                  disabledColor: Colors.redAccent,
                                  color: isButtonEnabled
                                      ? primaryColor
                                      : primaryColor,
                                ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_countDownTimer == 0) {
          setState(() {
            timer.cancel();
            _countDownTimer = 0;
          });
        } else {
          setState(() {
            _countDownTimer--;
            print(_countDownTimer);
          });
        }
      },
    );
  }

  void resendOTP() {
    setState(() {
      _isLoading = true;
      print(_isLoading);
      Map<String, String> formData = {"mobile": widget.enteredPhoneNumber,
        "name": "name",
        "type": "0",
        "address": "address",
        "firmname": "firmname",
        "gstno": "gstno",
        "fssai": "fssai",
        "state": "state",
        "city": "sirsa"};
      print(formData);

      sendOTPApi(formData).then((value) {
        setState(() {
          _isLoading = false;
          print(_isLoading);
          var responseData = jsonDecode(value.body);
          if (responseData[Common.successKey]) {
            var responseOTP = responseData['otp'];
            _countDownTimer = 1;
            startTimer();
            // showSnackBar(context, responseOTP.toString(), 1500);
            Future.delayed(const Duration(milliseconds: 1500), () {
              showSnackBar(context,
                  "Please check your phone again for the OTP: ${widget.enteredPhoneNumber}",
                  1500);
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
          print("sendOTPApiError: $onError");
        });
      });
    });
  }

  Future<void> registerUser(String enteredOTP) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print("regsterUser");
    setState(() {
      _isVerifying = true;
    });

    Map<String, String> registeringData = {
      "mobile": widget.enteredPhoneNumber,
      "otp": enteredOTP,
      "gendor": widget.gender??"",
      "name": widget.name!.isEmpty ? "" : widget.name??"",
      "type": widget.type!.isEmpty?"":widget.type??"",
      "address": widget.address!.isEmpty ? "" : widget.address ??"",
      "firmname": widget.firmname!.isEmpty ? "" : widget.firmname ??"",
      "gstno": widget.gstno!.isEmpty ? "" : widget.gstno ??"",
      "fssai": widget.fssai!.isEmpty ? "" : widget.fssai??"",
      "state": widget.state!.isEmpty ? "" : widget.state ??"",
      "city": widget.city!.isEmpty ? "" : widget.city ??"",
      "password": widget.password!.isEmpty ? "" : widget.password ??"",
      "email": widget.email!.isEmpty ? "" : widget.email ??"",
      "pincode": widget.pincode!.isEmpty ? "" : widget.pincode ??"",
      "sponsar": widget.sponsor!.isEmpty ? "" : widget.sponsor ??"",
    };

    Map<String, String> loggingData = {
      "mobile": widget.enteredPhoneNumber,
      "otp": enteredOTP,
      "name": "",
      "type": "",
      "address": "",
      "firmname": "",
      "gstno": "",
      "fssai": "",
      "state": "",
      "city": "",
    };
    print("verifyotopresponseis ${widget.isRegistering ? registeringData : loggingData}");

    verifyOtpApi(widget.isRegistering ? registeringData : loggingData).then((value) {
      print(registeringData);
      setState(() {
        _isVerifying = false;

        var responseData = jsonDecode(value.body);
        print("verifyotopresponseis ${value.body}");
        if (responseData[Common.successKey]) {
          var rs = responseData[Common.dataKey];
          sharedPreferences.setBool(Common.isLoggedInKey, true);
          sharedPreferences.setString(Common.tokenKey, rs["token"]);
          sharedPreferences.setString(Common.userMobileNumberKey, widget.enteredPhoneNumber);
          sharedPreferences.setString(Common.userEmail??"", widget.name??"");
          sharedPreferences.commit();
          print(rs['token']);
          Common.isLoggedIn = true;
          Common.userToken = rs['token'];
          pushToNewRouteAndClearAll(context, HomeScreeUI());
        } else if (value.statusCode >= 500 && value.statusCode <= 599) {
          showSnackBar(context, "Server error please try again later", 1500);
        } else {
          showSnackBar(context, responseData[Common.messageKey], 1500);
        }
      });
    }).catchError((onError) {
      setState(() {
        _isVerifying = false;
        print("verifyotopresponseis: $onError");
      });
    });
  }
}
