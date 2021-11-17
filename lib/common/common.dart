import 'package:flutter/cupertino.dart';
import 'package:hilton_masale/models/cart_model.dart';
import 'package:hilton_masale/response/user_details_response.dart';

class Common {
  static bool isLoggedIn = false;
  static final String isLoggedInKey = "isLoggedIn";
  static final String tokenKey = "userToken";
  static final String dataKey = "data";
  static final String responseKey = "response";
  static final String successKey = "success";
  static final String userIdKey = "userId";
  static final String userMobileNumberKey = "userMobile";
  static String selectedAddressId = "";
  static String selectedAddress = "";
  static final String messageKey = "message";
  static String? userToken;
  static UserDetailsResponse currentUser = UserDetailsResponse();

  static String? userId, userMobile, userEmail;
  static ValueNotifier<double> totalPrice = ValueNotifier<double>(0.00);
  static ValueNotifier<List<CartModel>> cartItems = ValueNotifier<List<CartModel>>([]);

  static Map<String, dynamic> placeOrderData = {};

  static void getTotalAmount() {
    totalPrice.value = 0.00;
    for (CartModel cart in Common.cartItems.value) {
      totalPrice.value += cart.quantity * cart.rate;
    }
  }
}
