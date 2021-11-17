import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportAndHelpUI extends StatefulWidget {
  @override
  _SupportAndHelpUIState createState() => _SupportAndHelpUIState();
}

class _SupportAndHelpUIState extends State<SupportAndHelpUI> {
  bool _isLoading = false;

  TextEditingController _mobileController = TextEditingController();
  TextEditingController _whatsAppController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  String mobile = "";
  String aboutUs = "";
  String whatsApp = "";
  String address = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Get assistance",
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Select any desired method to contact us",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              dialNumber();
                            },
                            child: TextFormField(
                              enabled: false,
                              keyboardType: TextInputType.emailAddress,
                              controller: _mobileController,
                              style: Theme.of(context).textTheme.bodyText2,
                              decoration: InputDecoration(
                                labelText: "Call us on:",
                                counterText: "",
                                prefixIcon: Icon(Icons.phone),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          InkWell(
                            onTap: () {
                              whatsAppMessage();
                            },
                            child: TextFormField(
                              enabled: false,
                              maxLines: 1,
                              keyboardType: TextInputType.name,
                              controller: _whatsAppController,
                              style: Theme.of(context).textTheme.bodyText2,
                              decoration: InputDecoration(
                                labelText: "Message us on WhatsApp:",
                                counterText: "",
                                prefixIcon: Icon(Icons.message),
                              ),
                            ),
                          ),
                        /*  SizedBox(
                            height: 16,
                          ),
                          InkWell(
                            onTap: () {
                              openMaps();
                            },
                            child: TextFormField(
                              enabled: false,
                              maxLines: 2,
                              keyboardType: TextInputType.streetAddress,
                              controller: _addressController,
                              style: Theme.of(context).textTheme.bodyText2,
                              decoration: InputDecoration(
                                labelText: "Address",
                                counterText: "",
                                prefixIcon: Icon(Icons.message),
                              ),
                            ),
                          ),*/
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            aboutUs,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                height: 1.4,
                                letterSpacing: 0.6),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          /*_isLoading
                        ? CircularProgressIndicator()
                        : Container(
                      height: 44,
                      width: 256,
                      child: MaterialButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              checkReferralCode();
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          color: Colors.green,
                          child: Text(
                            "Register".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                letterSpacing: 1.2,
                                wordSpacing: 2,
                                fontWeight: FontWeight.w800),
                          )),
                    ),*/
                          SizedBox(height: 8)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    _whatsAppController.text = "9992897076";
    mobile = "+919992897076";
    _mobileController.text = "9992897076";
    aboutUs =
        "if you have query to be addressed by Hilton Team, We are available 9-5 Monday to Friday";
    address = "Einix Infotech, Hisar Rd, Sirsa, Haryana 125055";
    _addressController.text = address;
  }

  void dialNumber() {
    launch("tel://$mobile");
  }

  void whatsAppMessage() {
    launch("https://wa.me/91$whatsApp/?text=${Uri.parse("Dear Developer, ")}");
  }
}
