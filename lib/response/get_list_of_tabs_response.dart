class GetListOfTabs {
  bool? success;
  int? total;
  bool? error;
  List<Response>? response;

  GetListOfTabs({this.success, this.total, this.error, this.response});

  GetListOfTabs.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    total = json['total'];
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
    data['total'] = this.total;
    data['error'] = this.error;
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  String? name;
  String? categoryId;

  Response({this.name, this.categoryId});

  Response.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    return data;
  }
}
