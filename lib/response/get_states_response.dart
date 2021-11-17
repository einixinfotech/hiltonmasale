class GetStatesResponse {
  bool? success;
  String? message;
  List<Data>? data;

  GetStatesResponse({this.success, this.message, this.data});

  GetStatesResponse.fromJson(Map<String, dynamic> json) {
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
  int? fcountryid;
  String? name;
  int? status;

  Data({this.id, this.fcountryid, this.name, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fcountryid = json['fcountryid'];
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fcountryid'] = this.fcountryid;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}
