import 'get_home_products_response.dart';

class GetProductsResponse {
  bool? success;
  bool? error;
  List<Response>? response;

  GetProductsResponse({this.success, this.error, this.response});

  GetProductsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    if (json['data'] != null) {
      response = <Response>[];
      json['data'].forEach((v) {
        response!.add(new Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['error'] = this.error;
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  dynamic category;
  dynamic categoryid;
  dynamic productid;
  dynamic name;
  dynamic stock;
  dynamic discount;
  dynamic image;
  dynamic images;
  dynamic mrp;
  dynamic rate;
  dynamic wholesaleRate;
  //dynamic varient;
  Varient? _selectedVariant;
  List<Varient>? varient;
  bool? hasInCart;

  Response(
      {this.category,
      this.categoryid,
      this.productid,
      this.name,
      this.stock,
      this.discount,
      this.image,
      this.images,
      this.mrp,
      this.rate,
      this.wholesaleRate,
      this.varient,
      this.hasInCart});

  Varient? get selectedVariant => _selectedVariant;

  set selectedVariant(Varient? value) {
    _selectedVariant = value;
  }

  Response.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    categoryid = json['categoryid'];
    productid = json['productid'];
    name = json['name'];
    stock = json['stock'];
    discount = json['discount'];
    image = json['image'];
    images = json['images'];

    mrp = json['mrp'];
    rate = json['rate'];
    wholesaleRate = json['wholesale_rate'];
    varient = json['varient'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['categoryid'] = this.categoryid;
    data['productid'] = this.productid;
    data['name'] = this.name;
    data['stock'] = this.stock;
    data['discount'] = this.discount;
    data['image'] = this.image;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    data['mrp'] = this.mrp;
    data['rate'] = this.rate;
    data['wholesale_rate'] = this.wholesaleRate;
    if (varient != null) {
      data['varient'] = varient?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
