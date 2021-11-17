class HomeCategoriesResponse {
  bool? success;
  String? message;
  List<HomeCategoryData>? data;

  HomeCategoriesResponse({this.success, this.message, this.data});

  HomeCategoriesResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <HomeCategoryData>[];
      json['data'].forEach((v) {
        data!.add(new HomeCategoryData.fromJson(v));
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

class HomeCategoryData {
  int? id;
  String? name;
  String? image;

  HomeCategoryData({this.id, this.name, this.image});

  HomeCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}