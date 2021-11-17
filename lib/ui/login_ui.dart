import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/res/values/colors.dart';

class LoginUI extends StatefulWidget {
  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _mobileNumberController = new TextEditingController();
  late ScrollController _scrollController;
  bool isButtonEnabled = false, _isLoading = false;
  var _isVisible;

  bool isEmpty() {
    setState(() {
      if (_mobileNumberController.text.length == 10) {
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
    enableNormalUI();
    initializeControllers();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "login".toUpperCase(),
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                "Enter your mobile number",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: _mobileNumberController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                cursorHeight: 20,
                maxLines: 1,
                style: Theme.of(context).textTheme.headline1,
                onSubmitted: null,
                onChanged: (val) {
                  setState(() {
                    isEmpty();
                  });
                },
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Mobile number",
                  counterText: "",
                ),
              ),
              SizedBox(
                height: 50,
              ),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      child: RaisedButton(
                        elevation: 0,
                        onPressed: isButtonEnabled
                            ? () {
                                sendOTP();
                              }
                            : null,
                        child: Text(
                          isButtonEnabled
                              ? "continue".toUpperCase()
                              : "Enter mobile number",
                          style: Theme.of(context).textTheme.button,
                        ),
                        disabledColor: Colors.red[100],
                        color: isButtonEnabled ? primaryColor : Colors.red[100],
                      )),
            ],
          ),
        ),
      ),
    );
  }

  void initializeControllers() {
    setState(() {
      _scrollController = new ScrollController();
      _isVisible = true;
      _scrollController.addListener(() {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisible)
            setState(() {
              _isVisible = false;
            });
        }
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!_isVisible)
            setState(() {
              _isVisible = true;
            });
        }
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.idle) {
          if (!_isVisible)
            setState(() {
              _isVisible = true;
            });
        }
      });
    });
  }

  void sendOTP() {}
}
