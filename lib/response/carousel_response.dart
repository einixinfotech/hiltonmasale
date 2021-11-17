class CarouselResponse {
  bool? success;
  String? message;
  List<Data>? data;

  CarouselResponse({this.success, this.message, this.data});

  CarouselResponse.fromJson(Map<String, dynamic> json) {
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
  String? image;
  int? type;
  int? catid;
  String? description;
  String? name;
  String? sliderType;

  Data(
      {this.image,
        this.type,
        this.catid,
        this.description,
        this.name,
        this.sliderType});

  Data.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    type = json['type'];
    catid = json['catid'];
    description = json['description'];
    name = json['name'];
    sliderType = json['slider_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['type'] = this.type;
    data['catid'] = this.catid;
    data['description'] = this.description;
    data['name'] = this.name;
    data['slider_type'] = this.sliderType;
    return data;
  }
}