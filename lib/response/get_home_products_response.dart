class GetHomeProductsResponse {
  bool? success;
  String? message;
  List<ProductsData>? data;

  GetHomeProductsResponse({this.success, this.message, this.data});

  GetHomeProductsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductsData>[];
      json['data'].forEach((v) {
        data!.add(new ProductsData.fromJson(v));
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

class ProductsData {
  int? id;
  String? name;
  int? mrp;
  int? rate;
  int? wrate;
  int? stock;
  int? discount;
  int? wholesaleRate;
  String? description;
  Varient? _selectedVariant;
  List<ImageData>? image;
  List<Varient>? varient;
  List<Category>? category;
  bool? hasInCart = false;

  ProductsData(
      { this.id,
        this.name,
        this.mrp,
        this.rate,
        this.wrate,
        this.stock,
        this.discount,
        this.wholesaleRate,
        this.description,
        this.image,
        this.varient,
        this.hasInCart,
        this.category});

  Varient? get selectedVariant => _selectedVariant;

  set selectedVariant(Varient? value) {
    _selectedVariant = value;
  }

  ProductsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mrp = json['mrp'];
    rate = json['rate'];
    wrate = json['wrate'];
    stock = json['stock'];
    discount = json['discount'];
    wholesaleRate = json['wholesale_rate'];
    description = json['description'];
    if (json['image'] != null) {
      image = <ImageData>[];
      json['image'].forEach((v) {
        image!.add(new ImageData.fromJson(v));
      });
    }
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
    data['stock'] = this.stock;
    data['discount'] = this.discount;
    data['wholesale_rate'] = this.wholesaleRate;
    data['description'] = this.description;
    if (this.image != null) {
      data['image'] = this.image!.map((v) => v.toJson()).toList();
    }
    if (this.varient != null) {
      data['varient'] = this.varient!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageData {
  String? image;
  String? type;

  ImageData({this.image, this.type});

  ImageData.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['type'] = this.type;
    return data;
  }
}

class Varient {
  int? id;
  String? size;
  String? uom;
  String? name;
  int? mrp;
  int? rate;
  int? wrate;
  int? discount;
  List<ImageData>? image;
  String? description;
  Varient? _selectedVariant;
  bool? hasInCart = false;

  Varient(
      {this.id,
        this.size,
        this.uom,
        this.name,
        this.mrp,
        this.rate,
        this.wrate,
        this.discount,
        this.image,
        this.description,
        this.hasInCart,
      });

  Varient? get selectedVariant => _selectedVariant;

  set selectedVariant(Varient? value) {
    _selectedVariant = value;
  }

  Varient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    size = json['size'];
    uom = json['uom'];
    name = json['name'];
    mrp = json['mrp'];
    rate = json['rate'];
    wrate = json['wrate'];
    discount = json['discount'];
    if (json['image'] != null) {
      image =<ImageData>[];
      json['image'].forEach((v) {
        image!.add(ImageData.fromJson(v));
      });
    }
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['size'] = this.size;
    data['uom'] = this.uom;
    data['name'] = this.name;
    data['mrp'] = this.mrp;
    data['rate'] = this.rate;
    data['wrate'] = this.wrate;
    data['discount'] = this.discount;
    if (this.image != null) {
      data['image'] = this.image!.map((v) => v.toJson()).toList();
    }
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