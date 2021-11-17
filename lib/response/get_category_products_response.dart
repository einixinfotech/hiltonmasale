import 'package:hilton_masale/models/product_colors_model.dart';
import 'package:hilton_masale/models/product_size_model.dart';

class GetCategoryProductResponse {
  bool? success;
  String? message;
  List<Data>? data;

  GetCategoryProductResponse({this.success, this.message, this.data});

  GetCategoryProductResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  dynamic mrp;
  dynamic rate;
  int? defaultselected;
  List<ProductColors>? productColors;
  List<Sizes>? sizes;
  List<Image>? image;
  String? description;
  dynamic rating;

  Data(
      {this.id,
      this.name,
      this.mrp,
      this.rate,
      this.defaultselected,
      this.productColors,
      this.sizes,
      this.image,
      this.description,
      this.rating});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mrp = json['mrp'];
    rate = json['rate'];
    defaultselected = json['defaultselected'];
    if (json['productColors'] != null) {
      productColors = <ProductColors>[];
      json['productColors'].forEach((v) {
        productColors!.add(new ProductColors.fromJson(v));
      });
    }
    if (json['sizes'] != null) {
      sizes = <Sizes>[];
      json['sizes'].forEach((v) {
        sizes!.add(new Sizes.fromJson(v));
      });
    }
    if (json['image'] != null) {
      image = <Image>[];
      json['image'].forEach((v) {
        image!.add(new Image.fromJson(v));
      });
    }
    description = json['description'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mrp'] = this.mrp;
    data['rate'] = this.rate;
    data['defaultselected'] = this.defaultselected;
    if (this.productColors != null) {
      data['productColors'] =
          this.productColors!.map((v) => v.toJson()).toList();
    }
    if (this.sizes != null) {
      data['sizes'] = this.sizes!.map((v) => v.toJson()).toList();
    }
    if (this.image != null) {
      data['image'] = this.image!.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    data['rating'] = this.rating;
    return data;
  }
}

class Image {
  String? image;

  Image({this.image});

  Image.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    return data;
  }
}
