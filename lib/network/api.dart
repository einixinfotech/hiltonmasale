import 'dart:async';
import 'dart:convert';

import 'package:hilton_masale/common/common.dart';
import 'package:http/http.dart' as http;
// http://192.168.1.117:8080/hiltonmasala/public/api

String baseUrl = "hilton.einixworld.online";

Future<http.Response> getCategoriesApi(Map<String, String> formData) async {
  final response = await http.post(Uri.https(baseUrl, "/api/apiCategories.php"),
      body: formData);
  return response;
}

Future<http.Response> getCarouselImagesApi(Map<String, String> formData) async {
  final response = await http.post(Uri.https(baseUrl, "/api/getSlider"),
      body: jsonEncode(formData));
  return response;
}

Future<http.Response> placeOrderApi(Map<String, dynamic> formData) async {
  final response = await http.post(Uri.https(baseUrl, "/api/placeOrder"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Common.userToken}'
      },
      body: jsonEncode(formData));
  return response;
}

Future<http.Response> getDeliveryChargesApi(
    Map<String, dynamic> formData) async {
  final response = await http.post(Uri.https(baseUrl, "/api/getUpdatedCart"),
      body: jsonEncode(formData));
  return response;
}

Future<http.Response> getDiscountCouponsApi(
    Map<String, String> formData) async {
  final response = await http.post(Uri.https(baseUrl, "/api/getCoupons"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Common.userToken}'
      },
      body: formData);
  return response;
}

Future<http.Response> updateOrderStatusApi(
    Map<String, dynamic> formData) async {
  final response = await http.post(Uri.https(baseUrl, "/api/updateOnlineOrder"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Common.userToken}'
      },
      body: formData);
  return response;
}

Future<http.Response> getHomeProductsApi() async {
  final response = await http.post(Uri.https(baseUrl, "/api/getHomeOrders"));
  return response;
}

Future<http.Response> getPopularProductsApi(Map<String, int> formData) async {
  final response = await http.post(
      Uri.https(baseUrl, "/apiCategoryProduct.php"),
      body: jsonEncode(formData));
  return response;
}

Future<http.Response> getListOfTabsApi(Map<String, String> formData) async {
  final response = await http.post(Uri.https(baseUrl, "/api/apiSubCatProducts.php"), body: formData);
  return response;
}

Future<http.Response> sendOTPApi(Map<String, dynamic> formData) async {
  final response =
      await http.post(Uri.http(baseUrl, "/api/sendOtp"), body: formData);
  return response;
}

Future<http.Response> verifyOtpApi(Map<String, dynamic> formData) async {
  final response =
      await http.post(Uri.http(baseUrl, "/api/verifyOtp"), body: formData);
  return response;
}

Future<http.Response> getStatesApi() async {
  final response = await http.post(Uri.http(baseUrl, "/api/getState"));
  return response;
}

Future<http.Response> searchProductsApi(Map<String, String> formData) async {
  final response =
      await http.post(Uri.https(baseUrl, "/api/searchProduct"), body: formData);
  return response;
}

Future<http.Response> getOrdersApi(Map<String, String> formData) async {
  final response = await http.post(Uri.https(baseUrl, "/api/getOrders"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Common.userToken}'
      },
      body: jsonEncode(formData));
  return response;
}

Future<http.Response> getListOfUsersOrdersApi() async {
  final response = await http.post(Uri.https(baseUrl, "api/getOrders"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Common.userToken}'
      });
  return response;
}

Future<http.Response> getOrderDetailsApi(Map<String, String> formData) async {
  final response = await http.post(Uri.https(baseUrl, "api/getOrderDetails"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Common.userToken}'
      },
      body: formData);
  return response;
}

Future<http.Response> getUserAddressApi() async {
  final response = await http
      .post(Uri.https(baseUrl, "/api/apiCustomerAddress.php"), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${Common.userToken}'
  });
  return response;
}

Future<http.Response> deleteAddressApi(Map<String, String> formData) async {
  final response = await http
      .post(Uri.https(baseUrl, "/api/apiDeleteAddress.php"), body: formData);
  return response;
}

Future<http.Response> getUserAddressesApi() async {
  final response = await http.post(Uri.https(baseUrl, "/api/getUserAddress"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Common.userToken}'
      });
  return response;
}

Future<http.Response> addUserAddressApi(Map<String, String> formData) async {
  final response = await http.post(Uri.https(baseUrl, "/api/addUserAddress"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Common.userToken}'
      },
      body: formData);
  return response;
}

Future<http.Response> getListOfStatesApi() async {
  final response = await http.post(Uri.https(baseUrl, "/api/getState"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Common.userToken}'
      });
  return response;
}

Future<http.Response> getListOfCitiesApi(Map<String, String> formData) async {
  final response = await http.post(Uri.https(baseUrl, "/api/getCity"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Common.userToken}'
      },
      body: formData);
  return response;
}

Future<http.Response> updateUserAddressApi(Map<String, String> formData) async {
  final response = await http.post(Uri.https(baseUrl, "/api/updateUserAddress"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Common.userToken}'
      },
      body: formData);
  return response;
}

Future<http.Response> getRedeemHistory() async {
  final response = await http.post(Uri.https(baseUrl, "/api/redeemCouponHistory"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Common.userToken}'
      },
  );
  return response;
}

Future<http.Response> applyRedeem(Map<String,dynamic> formData) async {
  final response = await http.post(Uri.https(baseUrl, "/api/redeemCoupon"),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Common.userToken}'
    },body: formData,
  );
  return response;
}
Future<http.Response> getHomeCategoriesApi() async {
  final response = await http.post(Uri.https(baseUrl, "/api/getCategories"));
  return response;
}

Future<http.Response> getProductsByCategoryApi(Map<String,dynamic> formData) async {
  final response = await http.post(Uri.https(baseUrl, "/api/getCategoryProducts"),body: formData);
  return response;
}

Future<http.Response> getProductsDetailsApi(Map<String,dynamic> formData) async {
  final response = await http.post(Uri.https(baseUrl, "/api/getProductDetails"),body: formData);
  return response;
}

Future<http.Response> getUserDetailsApi() async {
  final response = await http.post(Uri.https(baseUrl, "/api/userdetails"),headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${Common.userToken}'
  });
  return response;
}

Future<http.Response> getWalletHistoryApi() async {
  final response = await http.post(Uri.https(baseUrl, "/api/walletHistory"),headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${Common.userToken}'
  });
  return response;
}

Future<http.Response> addWalletBalanceApi(Map<String,dynamic> formData) async {
  final response = await http.post(Uri.https(baseUrl, "/api/placeWalletOrder"),
      headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${Common.userToken}'
  },body: formData);
  return response;
}

Future<http.Response> getWalletStatusApi(Map<String,dynamic> formData) async {
  final response = await http.post(Uri.https(baseUrl, "/api/updateWalletPayment"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Common.userToken}'
      },body: formData);
  return response;
}

Future<http.Response> updateProfileApi(Map<String,dynamic> formData) async {
  final response = await http.post(Uri.https(baseUrl, "/api/updateProfile"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Common.userToken}'
      },body: formData);
  return response;
}


