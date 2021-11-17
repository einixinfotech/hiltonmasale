class CategoriesResponse {
  bool? success;
  bool? error;
  List<Response>? response;

  CategoriesResponse({this.success, this.error, this.response});

  CategoriesResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
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
  String? categoryId;
  String? name;
  String? image;
  List<Subcat>? subcat;

  Response({this.categoryId, this.name, this.image, this.subcat});

  Response.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    name = json['name'];
    image = json['image'];
    if (json['subcat'] != null) {
      subcat = <Subcat>[];
      json['subcat'].forEach((v) {
        subcat!.add(new Subcat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['image'] = this.image;
    if (this.subcat != null) {
      data['subcat'] = this.subcat!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subcat {
  String? categoryId;
  String? name;
  String? parent;
  String? pname;
  String? image;

  Subcat({this.categoryId, this.name, this.parent, this.pname, this.image});

  Subcat.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    name = json['name'];
    parent = json['parent'];
    pname = json['pname'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['parent'] = this.parent;
    data['pname'] = this.pname;
    data['image'] = this.image;
    return data;
  }
}
