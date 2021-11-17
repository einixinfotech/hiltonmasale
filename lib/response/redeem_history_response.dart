class RedeemHistoryResponse {
  bool? success;
  String? message;
  List<Data>? data;

  RedeemHistoryResponse({this.success, this.message, this.data});

  RedeemHistoryResponse.fromJson(Map<String, dynamic> json) {
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
  int? userid;
  int? amount;
  String? coupon;
  String? remark;
  String? refId;
  String? type;
  String? createdAt;
  String? updatedAt;
  int? status;

  Data(
      {this.id,
        this.userid,
        this.amount,
        this.coupon,
        this.remark,
        this.refId,
        this.type,
        this.createdAt,
        this.updatedAt,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    amount = json['amount'];
    coupon = json['coupon'];
    remark = json['remark'];
    refId = json['ref_id'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['amount'] = this.amount;
    data['coupon'] = this.coupon;
    data['remark'] = this.remark;
    data['ref_id'] = this.refId;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    return data;
  }
}