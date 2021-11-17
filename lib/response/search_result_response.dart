class SearchResultResponse {
  bool? success;
  String? message;
  List<Data>? data;

  SearchResultResponse({this.success, this.message, this.data});

  SearchResultResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  int? productid;
  String? name;
  int? stock;
  int? discount;
  int? mrp;
  int? rate;
  int? wholesaleRate;
  List<Images>? images;
  String? image;
  List<Varient>? varient;
  String? category;
  Varient? _selectedVariant;
  bool? hasInCart = false;

  int? categoryid;

  Data(
      {this.productid,
      this.name,
      this.stock,
      this.discount,
      this.mrp,
      this.rate,
      this.wholesaleRate,
      this.images,
      this.image,
      this.varient,
      this.category,
      this.categoryid,
      this.hasInCart});
  Varient? get selectedVariant => _selectedVariant;

  set selectedVariant(Varient? value) {
    _selectedVariant = value;
  }

  Data.fromJson(dynamic json) {
    productid = json['productid'];
    name = json['name'];
    stock = json['stock'];
    discount = json['discount'];
    mrp = json['mrp'];
    rate = json['rate'];
    wholesaleRate = json['wholesale_rate'];
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images?.add(Images.fromJson(v));
      });
    }
    image = json['image'];
    if (json['varient'] != null) {
      varient = [];
      json['varient'].forEach((v) {
        varient?.add(Varient.fromJson(v));
      });
    }
    category = json['category'];
    categoryid = json['categoryid'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['productid'] = productid;
    map['name'] = name;
    map['stock'] = stock;
    map['discount'] = discount;
    map['mrp'] = mrp;
    map['rate'] = rate;
    map['wholesale_rate'] = wholesaleRate;
    if (images != null) {
      map['images'] = images?.map((v) => v.toJson()).toList();
    }
    map['image'] = image;
    if (varient != null) {
      map['varient'] = varient?.map((v) => v.toJson()).toList();
    }
    map['category'] = category;
    map['categoryid'] = categoryid;
    return map;
  }
}

class Varient {
  int? id;
  dynamic? size;
  String? uom;
  int? mrp;
  int? rate;
  int? wrate;
  dynamic? image;
  String? description;

  Varient(
      {this.id,
      this.size,
      this.uom,
      this.mrp,
      this.rate,
      this.wrate,
      this.image,
      this.description});

  Varient.fromJson(dynamic json) {
    id = json['id'];
    size = json['size'];
    uom = json['uom'];
    mrp = json['mrp'];
    rate = json['rate'];
    wrate = json['wrate'];
    image = json['image'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['size'] = size;
    map['uom'] = uom;
    map['mrp'] = mrp;
    map['rate'] = rate;
    map['wrate'] = wrate;
    map['image'] = image;
    map['description'] = description;
    return map;
  }
}

class Images {
  String? image;

  Images({this.image});

  Images.fromJson(dynamic json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['image'] = image;
    return map;
  }
}
