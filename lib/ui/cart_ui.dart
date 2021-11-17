import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hilton_masale/common/common.dart';
import 'package:hilton_masale/components/empty_screen.dart';
import 'package:hilton_masale/db/cart_database.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/models/cart_model.dart';
import 'package:hilton_masale/models/item_model.dart';
import 'package:hilton_masale/network/api.dart';
import 'package:hilton_masale/response/coupon_code_response.dart';
import 'package:hilton_masale/response/user_details_response.dart';
import 'package:hilton_masale/ui/address_ui.dart';
import 'package:hilton_masale/ui/thank_you_ui.dart';
import 'package:hilton_masale/ui/welcome_ui.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartUI extends StatefulWidget {
  @override
  _CartUIState createState() => _CartUIState();
}

class _CartUIState extends State<CartUI> {
  UserDetailsResponse userResponse = UserDetailsResponse();
  bool isUserDataLoading = false;

  int deliveryCharges = 0, _selectedPaymentMethod = 0;
  bool _isLoading = false,
      _useCouponCode = false,
      _isAppliedPromoCode = false,
      _useReferPoint = false,
      close = false;
  dynamic deliveryChargesToShow,
      itemTotalPriceToShow,
      totalPriceToShow,
      redeemPoints,
      discountToShow = 0;
  double totalPrice = 0.00, finalPrice = 0.00, finalPriceToBePaid = 0.00;
  TextEditingController _promoCodeController = TextEditingController();
  List<CouponData> _listOfPromoCodes = [];
  String _orderId = "";
  static const platform = const MethodChannel("razorpay_flutter");
  late Razorpay _razorpay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.fromLTRB(2, 2, 2, 20),
          margin: EdgeInsets.fromLTRB(2, 2, 2, 200),
          color: Colors.grey[100],
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              Card(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 9,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "DELIVERING TO".toUpperCase(),
                                style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blueGrey),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  Common.selectedAddress == ""
                                      ? "No delivery address selected"
                                      : Common.selectedAddress,
                                  style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 12,
                                      color: Colors.black87),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () async {
                          if (Common.isLoggedIn) {
                            var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AddressUI(
                                        true, "Select a delivery Address")));
                            if (result != null && result) {
                              setState(() {
                                getCartItems().then((value) {
                                  Common.getTotalAmount();
                                });
                              });
                            }
                          } else {
                            showActionSnackBar(context,
                                "You need to be logged in first", "Login", () {
                              pushToNewRoute(context, WelcomeUI());
                            }, 2000);
                          }
                        },
                        child: Text(
                          "Change".toUpperCase(),
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.deepOrange),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Common.cartItems.value.isEmpty
                  ? EmptyScreenUI("Your cart is empty", true)
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: Common.cartItems.value.length,
                      itemBuilder: (context, index) {
                        return ValueListenableBuilder(
                          valueListenable: Common.cartItems,
                          builder: (BuildContext context, List<CartModel> value,
                              Widget? child) {
                            return Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(Common
                                                  .cartItems
                                                  .value[index]
                                                  .productImage
                                                  .toString()))),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              Common.cartItems.value[index]
                                                  .productName
                                                  .toString(),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Text(
                                            "₹" +
                                                Common
                                                    .cartItems.value[index].rate
                                                    .toString(),
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    height: 40,
                                    child: Card(
                                      color: Colors.blue,
                                      elevation: 0,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: TextButton(
                                                onPressed: () =>
                                                    _changeQuantity(
                                                        Common.cartItems
                                                            .value[index],
                                                        false),
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Colors.white,
                                                  size: 15,
                                                )),
                                          ),
                                          Text(
                                            Common
                                                .cartItems.value[index].quantity
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: TextButton(
                                                onPressed: () =>
                                                    _changeQuantity(
                                                        Common.cartItems
                                                            .value[index],
                                                        true),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 15,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      }),
              Common.cartItems.value.isNotEmpty
                  ? _isLoading
                      ? LinearProgressIndicator(color: Colors.black)
                      : Column(
                          children: [
                            Container(
                              height: 45,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.local_shipping_rounded),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "Delivery charges: ₹${deliveryChargesToShow.toString()}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 1,
                                          color: Colors.blue),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                  : Text(""),
              Visibility(
                visible: Common.isLoggedIn && Common.cartItems.value.isNotEmpty,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: Checkbox(
                              value: _useCouponCode,
                              onChanged: (newValue) {
                                setState(() {
                                  _isAppliedPromoCode = false;
                                  _useCouponCode = newValue!;
                                  print(_useCouponCode);
                                  if (!_useCouponCode) {
                                    _promoCodeController.clear();
                                  }
                                  getCartPrice();
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "Use a promo code",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: Checkbox(
                              value: _useReferPoint,
                              onChanged: (newValue) {
                                setState(() {
                                  _useReferPoint = newValue!;
                                  print(_useReferPoint.toString());
                                  getCartPrice();
                                });
                              },
                            ),
                          ),
                          isUserDataLoading
                              ? CircularProgressIndicator()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "Use refer points" +
                                        " ₹${userResponse.data?.referpoints.toString() == null ? "0" : userResponse.data?.referpoints.toString()}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                _useCouponCode
                    ? discountToShow.toString() == "0"
                    ? _isAppliedPromoCode
                    ? _promoCodeController.text
                    .trim()
                    .isNotEmpty
                    ? "Invalid Code"
                    : ""
                    : ""
                    : "-₹" +
                    double.parse(discountToShow.toString())
                        .round()
                        .toString()
                    : "",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Visibility(
                visible: _useCouponCode && Common.cartItems.value.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            _getAvailablePromoCodes();
                          },
                          child: Text(
                            "Show available coupons",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width / 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue),
                          ),
                        ),
                      ),
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r"[A-Z0-9]+")),
                        ],
                        controller: _promoCodeController,
                        onChanged: _setValue,
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
                      _isLoading
                          ? Center(
                              child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator()),
                            ))
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Colors.blue;
                                      return Colors
                                          .blue; // Use the component's default.
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  getCartPrice();
                                },
                                child: Text("Apply".toUpperCase(),
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        letterSpacing: 0.6,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                              ))
                    ],
                  ),
                ),
              ),
              userResponse.data?.referpoints.toString() == null ||
                      userResponse.data?.referpoints.toString() == "0"
                  ? Container()
                  : Container(
                      height: 45,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "Refer Points: -₹${userResponse.data?.referpoints.toString() == null ? "0" : userResponse.data?.referpoints.toString()}",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 1,
                                  color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
      bottomSheet: Visibility(
        visible: Common.cartItems.value.isNotEmpty,
        child: Container(
          child: Wrap(
            children: [
              Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.credit_card),
                    tileColor: _selectedPaymentMethod == 0
                        ? Colors.blue.shade50.withOpacity(0.8)
                        : Colors.white,
                    onTap: () {
                      setState(() {
                        if (_selectedPaymentMethod != 0) {
                          _selectedPaymentMethod = 0;
                        }
                      });
                      getCartPrice();
                    },
                    title: Text(
                      "Credit and Debit Cards",
                      style: Theme.of(context).textTheme.title,
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      size: 16,
                    ),
                  ),
                  Visibility(
                    visible: true, // todo enable/disable COD
                    child: ListTile(
                      leading: Icon(Icons.monetization_on_rounded),
                      tileColor: _selectedPaymentMethod == 1
                          ? Colors.blue.shade50.withOpacity(0.8)
                          : Colors.white,
                      onTap: () {
                        setState(() {
                          if (_selectedPaymentMethod != 1) {
                            _selectedPaymentMethod = 1;
                          }
                        });
                        getCartPrice();
                      },
                      title: Text(
                        "Cash on Delivery",
                        style: Theme.of(context).textTheme.title,
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: Common.cartItems.value.isNotEmpty,
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "total".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 8,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "₹$totalPriceToShow",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            if (Common.selectedAddressId == "") {
                              showSnackBar(context,
                                  "Please select a delivery address", 1500);
                            } else {
                              placeOrder();
                              // pushToNewRoute(
                              //     context,
                              //     PaymentUI(
                              //       totalAmountToPay:
                              //           totalPriceToShow.toString(),
                              //     ));
                            }
                          },
                          child: Container(
                            height: 50,
                            color: Colors.green,
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Checkout".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCartItems().then((value) {
      print("initStateGetCartItems");
      Common.getTotalAmount();
    });
    getUserData();
    initializeRazorPay();
  }

  getUserData() {
    setState(() {
      isUserDataLoading = true;
    });
    getUserDetailsApi().then((value) {
      setState(() {
        isUserDataLoading = false;
      });
      var responseData = jsonDecode(value.body);
      print(responseData.toString());
      if (value.statusCode == 200) {
        userResponse = UserDetailsResponse.fromJson(jsonDecode(value.body));
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

  Future<void> _changeQuantity(CartModel cartItem, bool isIncrement) async {
    print(isIncrement);
    if (isIncrement) {
      int quantity = cartItem.quantity + 1;
      print(quantity);
      CartModel item = CartModel(cartItem.productId, quantity, cartItem.rate,
          cartItem.productName, cartItem.productImage);
      // print(item.quantity);
      await CartDatabase.instance.update(item);
    } else if (cartItem.quantity > 1 && cartItem.quantity >= 1) {
      int quantity = cartItem.quantity - 1;
      print(quantity);
      CartModel item = CartModel(cartItem.productId, quantity, cartItem.rate,
          cartItem.productName, cartItem.productImage);
      // print(item.quantity);
      await CartDatabase.instance.update(item);
    } else if (cartItem.quantity == 1) {
      await CartDatabase.instance.delete(cartItem.productId);
    }

    getCartItems().then((value) {
      Common.getTotalAmount();
    });
  }

  Future<List<CartModel>> getCartItems() async {
    await CartDatabase.instance.getListOfItemsInCart().then((value) {
      Common.cartItems.value = value;
      print("Cart " + value.length.toString());
      getCartPrice();
      return value;
    });

    return [];
  }

  void getCartPrice() {
    FocusScope.of(context).unfocus();
    print("getCartPrice");
    setState(() {
      _isLoading = true;
    });

    List<ItemModel> listOfItems = [];
    Common.cartItems.value.forEach((element) {
      ItemModel item =
          ItemModel(element.productId.toString(), element.quantity);
      listOfItems.add(item);
    });
    Map<String, dynamic> formData = {
      "cartdata": listOfItems,
      "addressid":
          Common.selectedAddressId == "" ? "0" : Common.selectedAddressId,
      "promocode": _useCouponCode
          ? _promoCodeController.text.isNotEmpty
              ? _promoCodeController.text
              : "test"
          : "test",
      "comment": "",
      "usepoints": _useReferPoint,
      "pmode": _selectedPaymentMethod == 0 ? "online" : "cod"
    };

    Map<String, dynamic> placeOrderData = {
      "cartdata": listOfItems,
      "promocode": _useCouponCode
          ? _promoCodeController.text.isNotEmpty
              ? _promoCodeController.text
              : "test"
          : "test",
      "usepoints": _useReferPoint,
      "comment": ""
      /*,
      "usepoints": _usingWallet ? walletAmountUsed.abs() : false,
      "discount": _useCouponCode ? discount : 0*/
    };
    /*print(walletAmountUsed);
    print("useWallet? $_usingWallet");*/
    print(placeOrderData);

    Common.placeOrderData = placeOrderData;

    print("formData: ${jsonEncode(formData)}");

    getDeliveryChargesApi(formData).then((value) {
      print("getDeliveryChargesApi ${value.statusCode}");
      print("getDeliveryChargesApi${value.body.toString()}");
      setState(() {
        _isLoading = false;
        var responseData = jsonDecode(value.body);
        if (value.statusCode == 200) {
          var data = responseData[Common.dataKey];
          //  deliveryCharges = data['dlcharge'];
          deliveryChargesToShow = data['dlcharge'];
          itemTotalPriceToShow = data['subtotal'];
          totalPriceToShow = data['total'];
          discountToShow = data['discount'];
          redeemPoints = data['redeempoints'];
          print(totalPriceToShow);
          if (_useCouponCode) {
            _isAppliedPromoCode = true;
          }
        }
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
      print("getDeliveryChargesApiError: $onError");
    });
  }

  void _getAvailablePromoCodes() {
    _showLoadingDialog(context);
    Map<String, String> formData = {"type": "Discount"};
    print(formData);
    getDiscountCouponsApi(formData).then((value) {
      setState(() {
        print("getDiscountCouponsApi: ${value.statusCode}");
        Navigator.pop(context);
        var responseData = jsonDecode(value.body);
        if (value.statusCode == 200) {
          CouponCodeResponse response =
              CouponCodeResponse.fromJson(jsonDecode(value.body));
          _listOfPromoCodes = response.data!;
          showPromoCodes();
        } else if (value.statusCode >= 500 && value.statusCode <= 599) {
          showSnackBar(context, "Can't get coupon codes: server error", 1500);
        } else {
          showSnackBar(context, responseData[Common.messageKey], 1500);
        }
      });
    }).catchError((onError) {
      setState(() {
        Navigator.pop(context);
        print("getDiscountCouponsApiError: $onError");
      });
    });
  }

  void _showLoadingDialog(BuildContext context) {
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
                        "Apply coupon code",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 20,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                          itemCount: _listOfPromoCodes.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  margin: const EdgeInsets.all(8.0),
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black54,
                                          blurRadius: 1.0,
                                        ),
                                      ]),
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
                                                    _listOfPromoCodes[index]
                                                        .code!
                                                        .toUpperCase(),
                                                    /*"SAAGSABJI50".toUpperCase(),*/
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
                                            TextButton(
                                              onPressed: () {
                                                _promoCodeController.text =
                                                    _listOfPromoCodes[index]
                                                        .code!;
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
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Expires on: " +
                                              _listOfPromoCodes[index].enddate!,
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  28,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Divider(),
                                        Text(
                                          _listOfPromoCodes[index].msg!,
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  28,
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

  void _setValue(String value) {
    setState(() {
      _isAppliedPromoCode = false;
    });
  }

  @override
  void dispose() {
    close = true;
    super.dispose();
  }

  void placeOrder() {
    Map<String, dynamic> data = {
      "addressid": int.parse(Common.selectedAddressId)
    };
    Map<String, dynamic> paymentMode = {
      "pmode": _selectedPaymentMethod == 0 ? "online" : "cod"
    };

    Common.placeOrderData.addAll(data);
    Common.placeOrderData.addAll(paymentMode);
    print("placeOrderData: ${jsonEncode(Common.placeOrderData)}");

    /*if (_selectedPaymentMethod != 0) {
      showSnackBar(
          context,
          "COD is not availiable now , please try after some time or continue with online payment.",
          1500);
      return;
    }*/

    setState(() {
      _isLoading = true;
      print(Common.placeOrderData);
      placeOrderApi(Common.placeOrderData).then((value) {
        var responseData = jsonDecode(value.body);
        print("placeOrderApiStatusCode: ${value.statusCode}");
        print(responseData);
        print(Common.userToken);
        if (!close) {
          setState(() {
            if (value.statusCode == 200) {
              if (_selectedPaymentMethod == 0) {
                var data = responseData[Common.dataKey];
                print("data: $data");
                // online Success
                _orderId = data["orderid"];
                print("placeOrderApiResponse: ${data["total"]}");
                print("placeOrderApiResponse: ${data["apikey"]}");
                print("placeOrderApiResponse: ${data["orderid"]}");
                placeRazorPayOrder(data["total"], data["apikey"]);
              } else {
                _isLoading = false;
                Common.selectedAddressId = "";
                Common.selectedAddress = "";
                clearCart();
                pushToNewRouteAndClearAll(
                    context,
                    ThankYouUI(
                      title: "Thank you",
                    ));
              }
            } else if (value.statusCode >= 500 && value.statusCode <= 599) {
              _isLoading = false;
              showSnackBar(context, "Can't place order: server error", 1500);
            } else if (value.statusCode == 401) {
              _isLoading = false;
              showSnackBar(
                  context, "Session expired, please login again", 2000);
              Future.delayed(Duration(milliseconds: 2000), () {
                logout(context);
              });
            } else {
              _isLoading = false;
              showSnackBar(context, responseData[Common.messageKey], 1500);
            }
          });
        }
      }).catchError((onError) {
        print("placeOrderApiError: $onError");
        if (!close) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    });
  }

  void initializeRazorPay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void placeRazorPayOrder(dynamic totalAmount, String razorPayApiKey) {
    print("placeRazorPayOrder" + totalAmount.toString());
    print(totalAmount);
    print("razorPayApiKey" + razorPayApiKey);
    RegExp regex = RegExp(r"([.]*0)(?!.*\d)");
    double money = double.parse(totalAmount.toString());
    double tMoney = money * 100;
    String stringMoney = tMoney.toString().replaceAll(regex, '');
    int totalMoney = int.parse(stringMoney);

    var options = {
      'key': razorPayApiKey,
      'amount': totalMoney,
      'name': 'Hilton Agro Foods ',
      'orderId': _orderId,
      'description': 'Your order from Hilto Agro Foods',
      /*'prefill': {
        'contact':
            '${Common.currentUser!.mobile}' */ /*, 'email': 'test@razorpay.com'*/ /*
      },*/
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

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _isLoading = false;
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("_handlePaymentSuccess");
    Map<String, String> formData = {"orderid": _orderId};
    print("updateOrderStatusApiFormData: $formData");
    updateOrderStatusApi(formData).then((value) {
      var responseData = jsonDecode(value.body);
      print("updateOrderStatusApi: ${value.statusCode}");
      print("updateOrderResponse: $responseData");

      setState(() {
        _isLoading = false;
      });
      if (value.statusCode == 200) {
        Common.selectedAddressId = "";
        Common.selectedAddress = "";
        showSnackBar(context, "Order placed", 1500);
        clearCart();
        pushToNewRouteAndClearAll(
            context,
            ThankYouUI(
              title: "Thank you",
            ));
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
    }).catchError((onError) {
      setState(() {
        print("updateOrderStatusApiError: $onError");
        _isLoading = false;
      });
    });
  }

  Future<void> createPDF() async {}
}
