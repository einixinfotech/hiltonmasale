class ProductsByCategoryResponse {
  bool? success;
  String? message;
  List<ProductsByIdData>? data;

  ProductsByCategoryResponse({this.success, this.message, this.data});

  ProductsByCategoryResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductsByIdData>[];
      json['data'].forEach((v) {
        data!.add(new ProductsByIdData.fromJson(v));
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

class ProductsByIdData {
  int? id;
  String? name;
  int? mrp;
  int? rate;
  int? wrate;
  String? image;
  String? description;
  List<Varient>? varient;
  List<Category>? category;

  ProductsByIdData(
      {this.id,
        this.name,
        this.mrp,
        this.rate,
        this.wrate,
        this.image,
        this.description,
        this.varient,
        this.category});

  ProductsByIdData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mrp = json['mrp'];
    rate = json['rate'];
    wrate = json['wrate'];
    image = json['image'];
    description = json['description'];
    if (json['varient'] != null) {
      varient = <Varient>[];
      json['varient'].forEach((v) {
        varient!.add(new Varient.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mrp'] = this.mrp;
    data['rate'] = this.rate;
    data['wrate'] = this.wrate;
    data['image'] = this.image;
    data['description'] = this.description;
    if (this.varient != null) {
      data['varient'] = this.varient!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Varient {
  int? id;
  String? size;
  String? uom;
  int? mrp;
  int? rate;
  int? wrate;
  String? image;
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

  Varient.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['size'] = this.size;
    data['uom'] = this.uom;
    data['mrp'] = this.mrp;
    data['rate'] = this.rate;
    data['wrate'] = this.wrate;
    data['image'] = this.image;
    data['description'] = this.description;
    return data;
  }
}

class Category {
  int? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}