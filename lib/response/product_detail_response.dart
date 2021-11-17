import 'package:hilton_masale/response/get_home_products_response.dart';

class ProductsDetailsResponse {
  bool? success;
  String? message;
  ProductsData? data;

  ProductsDetailsResponse({this.success, this.message, this.data});

  ProductsDetailsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new ProductsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}