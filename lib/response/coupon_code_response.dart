class CouponCodeResponse {
  bool? success;
  String? message;
  List<CouponData>? data;

  CouponCodeResponse({this.success, this.message, this.data});

  CouponCodeResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CouponData>[];
      json['data'].forEach((v) {
        data!.add(new CouponData.fromJson(v));
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

class CouponData {
  String? code;
  String? msg;
  String? enddate;

  CouponData({this.code, this.msg, this.enddate});

  CouponData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    enddate = json['enddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['enddate'] = this.enddate;
    return data;
  }
}
