import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hilton_masale/common/common.dart';
import 'package:hilton_masale/components/empty_screen.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/network/api.dart';
import 'package:hilton_masale/response/coupon_code_response.dart';
import 'package:hilton_masale/response/user_details_response.dart';
import 'package:hilton_masale/response/wallet_history_response.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class WalletUI extends StatefulWidget {
  @override
  _WalletUIState createState() => _WalletUIState();
}

class _WalletUIState extends State<WalletUI> {
  bool _isLoading = false,
      _isAddingMoneyToWallet = false,
      _isUpdatingDetails = false;
  bool historyLoading = false;
  late Size _size;
  TextEditingController _amountController = TextEditingController();
  TextEditingController _promoCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  static const platform = const MethodChannel("razorpay_flutter");
  late Razorpay _razorpay;
  String orderId = "";

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xffc22f10)),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            color: Colors.white,
            width: _size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add money to",
                        style: TextStyle(
                            fontSize: _size.width / 22,
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        "My Wallet",
                        style: TextStyle(
                            fontSize: _size.width / 12,
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      _isUpdatingDetails
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator())
                          : Text(
                              "Available balance ₹100",
                              style: TextStyle(
                                fontSize: _size.width / 26,
                              ),
                            ),
                      SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        controller: _amountController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r"^\d+\.?\d{0,2}")),
                        ],
                        validator: MultiValidator(
                            [RequiredValidator(errorText: 'Enter an amount')]),
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: _size.width / 16,
                          fontWeight: FontWeight.w800,
                        ),
                        decoration: new InputDecoration(
                          hintText: "Amount",
                          contentPadding: EdgeInsets.only(left: 8),
                          hintStyle: TextStyle(
                            fontSize: _size.width / 14,
                            fontWeight: FontWeight.w800,
                          ),
                          //prefixIcon: Icon(Icons.text_rotate_up),
                          prefixText: "₹",
                          enabled: true,
                          //prefix: Image.asset("assets/images/rupee.png",width: _size.width/18,height: _size.width/18,color: Colors.grey,)
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"[A-Z0-9]+")),
                        ],
                        controller: _promoCodeController,
                        cursorColor: Colors.black,
                        textCapitalization: TextCapitalization.characters,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        decoration: new InputDecoration(
                          hintText: "Enter a promo code",
                          contentPadding: EdgeInsets.only(left: 8),
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                          //prefixIcon: Icon(Icons.text_rotate_up),
                          enabled: true,
                          //prefix: Image.asset("assets/images/rupee.png",width: _size.width/18,height: _size.width/18,color: Colors.grey,)
                        ),
                      ),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            getAvailablePromoCodes();
                          }
                        },
                        child: Text(
                          "See available promo codes",
                          style: TextStyle(
                              fontSize: _size.width / 24,
                              fontWeight: FontWeight.w500,
                              color: Color(0xffc22f10)),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      _isAddingMoneyToWallet
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: TextButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    addMoneyToWallet();
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Color(0xffc22f10);
                                      return Color(
                                          0xffc22f10); // Use the component's default.
                                    },
                                  ),
                                ),
                                child: Text("Gateway under approval",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: _size.width / 20,
                                        letterSpacing: 0.3)),
                              ),
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Recent History".toUpperCase(),
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: _size.width / 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1)),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                historyLoading
                    ? Center(child: CircularProgressIndicator())
                    : (_walletHistoryResponse.data?.length ?? 0) > 0
                        ? ListView.builder(
                            itemCount: _walletHistoryResponse.data?.length ?? 0,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder:
                                (contextListViewBuilder, indexListViewBuilder) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        blurRadius: 3.0,
                                        offset: Offset(0, 0),
                                        spreadRadius: 3.0,
                                      ),
                                    ]),
                              );
                            },
                          )
                        : EmptyScreenUI("No History!", false),
                /*ListView.builder(
                            itemCount: listOfTransactions.length,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (_, index) {
                              return Container(
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: _size.width,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      color: Colors.blueGrey[50],
                                      child: Text("June 10,2021 to be removed",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: _size.width / 26,
                                              fontWeight: FontWeight.normal,
                                              letterSpacing: 0.3)),
                                    ),
                                    Container(
                                      color: Colors.blueGrey[50],
                                      child: ,
                                    ),
                                  ],
                                ),
                              );
                            },
                          )*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //  getTransactionHistory();
    initializeRazorPay();
    getWalletHistoryData();
  }

  WalletHistoryResponse _walletHistoryResponse = WalletHistoryResponse();

  getWalletHistoryData() {
    setState(() {
      historyLoading = true;
    });
    getWalletHistoryApi().then((value) {
      setState(() {
        historyLoading = false;
      });
      var responseData = jsonDecode(value.body);
      if (value.statusCode == 200) {
        _walletHistoryResponse = WalletHistoryResponse.fromJson(jsonDecode(value.body));
      } else if (value.statusCode >= 500 && value.statusCode <= 599) {
        showSnackBar(context, "Can't get saved addresses: server error", 1500);
      } else if (value.statusCode == 401) {
        showSnackBar(context, "Session expired, please login again", 2000);
        Future.delayed(Duration(milliseconds: 2000), () {
          logout(context);
        });
      } else {
        showSnackBar(context, responseData[Common.messageKey], 1500);
      }
    });
  }

  void initializeRazorPay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    showLoaderDialog(context);
    updatePaymentStatus("success");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showLoaderDialog(context);
     updatePaymentStatus("failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // todo _handleExternalWallet
  }

  void showLoaderDialog(BuildContext context) {
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

  void showPromoCodes() {
    showModalBottomSheet(
        context: context,
        builder: (contextBottomSheet) {
          return StatefulBuilder(
            builder: (context, setBottomSheetState) {
              return SizedBox(
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      child: Text(
                        "Apply Promo Code",
                        style: TextStyle(
                            fontSize: _size.width / 20,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                          itemCount: listOfPromoCodes.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: _size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  margin: const EdgeInsets.all(8.0),
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        new BoxShadow(
                                          color: Colors.black54,
                                          blurRadius: 1.0,
                                        ),
                                      ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color:
                                                          Colors.greenAccent),
                                                  color: Colors.green
                                                      .withOpacity(0.99)),
                                              width: 120,
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Text(
                                                    listOfPromoCodes[index].code!.toUpperCase(),
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 12,
                                                        letterSpacing: 1,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: true,
                                              child: TextButton(
                                                onPressed: () {
                                                  _promoCodeController.text = listOfPromoCodes[index].code!;

                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Apply".toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Expires on: " + (listOfPromoCodes[index].enddate??""),
                                          style: TextStyle(
                                              fontSize: _size.width / 28,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Divider(),
                                        Text(
                                          listOfPromoCodes[index].msg??"",
                                          style: TextStyle(
                                              fontSize: _size.width / 28,
                                              color: Colors.grey[700],
                                              letterSpacing: 0.2,
                                              wordSpacing: 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  CouponCodeResponse _couponCodeResponse = CouponCodeResponse();
  List<CouponData> listOfPromoCodes = [];

void getAvailablePromoCodes() {
    showLoaderDialog(context);
    Map<String, String> formData = {"type": "Cashback"};

    setState(() {
      getDiscountCouponsApi(formData).then((value) {
        print(value.statusCode);
        var responseData = jsonDecode(value.body);
        setState(() {
          print(responseData[Common.dataKey]);
          if (value.statusCode == 200) {
            if (responseData[Common.dataKey].isNotEmpty) {
              CouponCodeResponse _couponCodeResponse = CouponCodeResponse.fromJson(jsonDecode(value.body));
              listOfPromoCodes = _couponCodeResponse.data!;
              showPromoCodes();
            } else {
              print("else");
              Navigator.pop(context);
              showSnackBar(context, "No coupons available", 1500);
            }
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            showSnackBar(context, "Can't fetch coupons, server error!", 1500);
          } else if (value.statusCode == 204) {
            showSnackBar(context, "Session expired, please login again", 2000);
            Future.delayed(Duration(milliseconds: 2000), () {
              logout(context);
            });
          } else {
            showSnackBar(context, responseData[Common.messageKey], 1500);
          }
        });
      }).catchError((onError) {
        setState(() {
          print("getCouponsApiError: $onError");
        });
      });
    });
  }

void addMoneyToWallet() {
    _isAddingMoneyToWallet = true;
    Map<String, String> formData = {"amount": _amountController.text.trim()};
    if (_promoCodeController.text.isNotEmpty) {
      Map<String, String> appliedPromoCode = {
        "promocode": _promoCodeController.text
      };
      // formData.addAll(appliedPromoCode);
    }
    print(formData);
    setState(() {
      _isAddingMoneyToWallet = true;
      addWalletBalanceApi(formData).then((value) {
        setState(() {
          _isAddingMoneyToWallet = false;
          var responseData = jsonDecode(value.body);

          if (value.statusCode == 200) {
            showSnackBar(context, "Success Added money, open razorPay", 1500);
            placeRazorPayOrder(responseData);
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            showSnackBar(context, "Server error please try again later", 1500);
          } else if (value.statusCode == 204) {
            showSnackBar(context, "Session expired, please login again", 2000);
            Future.delayed(Duration(milliseconds: 2000), () {
              logout(context);
            });
          } else {
            showSnackBar(context, responseData[Common.messageKey], 1500);
          }
        });
      }).catchError((onError) {
        setState(() {
          _isAddingMoneyToWallet = false;
          print("addMoneyToWalletApiError: $onError");
        });
      });
    });
  }

void placeRazorPayOrder(responseData) {
    RegExp regex = RegExp(r"([.]*0)(?!.*\d)");
    double money = double.parse(responseData["data"]["amount"].toString());
    double tMoney = money * 100;
    String stringMoney = tMoney.toString().replaceAll(regex, '');
    int totalMoney = int.parse(stringMoney);
    orderId = responseData["data"]["orderid"];
    var options = {
      'key': responseData["data"]["apikey"],
      'amount': money * 100,
      'name': 'Hilton',
      'orderId': responseData["data"]["orderid"],
      'description': 'Add money to wallet',
      'prefill': {
        'contact': '${Common.userMobile}',
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    print(options);

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

void updatePaymentStatus(String paymentStatus) {
    Map<String, String> formData = {
      "order_id": orderId,
      "payment_status": paymentStatus
    };

    print("updatePaymentStatus $formData");

    getWalletStatusApi(formData).then((value) {
      var responseData = jsonDecode(value.body);
      print("updatedPaymentStatus: ${responseData[Common.successKey]}");

      if (value.statusCode == 200) {
        updateUserDetails();
        Navigator.pop(context);
        showSnackBar(context, responseData[Common.messageKey], 1500);
      } else if (value.statusCode >= 500 && value.statusCode <= 599) {
        updateUserDetails();
        Navigator.pop(context);
        showSnackBar(context, responseData[Common.messageKey], 1500);
        showSnackBar(context, "Server error please try again later", 1500);
      } else if (value.statusCode == 204) {
        showSnackBar(context, "Session expired, please login again", 2000);
        Future.delayed(Duration(milliseconds: 2000), () {
          logout(context);
        });
      } else {
        updateUserDetails();
        Navigator.pop(context);
        showSnackBar(context, responseData[Common.messageKey], 1500);
      }
    }).catchError((onError) {
      updateUserDetails();
      print("updateWalletTransactionStatusApiError: $onError");
    });
  }

Future<void> updateUserDetails() async {
    orderId = "";
    _amountController.clear();
    _promoCodeController.clear();
    getUserDetailsApi().then((value) {
      var responseData = jsonDecode(value.body);
      if (value.statusCode == 200) {
        UserDetailsResponse response = UserDetailsResponse.fromJson(jsonDecode(value.body));
        Common.currentUser = response;
      } else if (value.statusCode >= 500 && value.statusCode <= 599) {
        showSnackBar(context, "Server error, try again later", 1500);
      } else if (value.statusCode == 204) {
        showSnackBar(context, "Session expired, please login again", 2000);
        Future.delayed(Duration(milliseconds: 2000), () {
          logout(context);
        });
      } else {
        showSnackBar(context, responseData[Common.messageKey], 1500);
        Future.delayed(Duration(milliseconds: 2000), () {
          logout(context);
        });
      }
    }).catchError((onError) {
      print("getUserDetailsApiError: $onError");
    });
  }
}
