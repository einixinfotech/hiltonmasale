class OrdersResponse {
  bool? success;
  String? message;
  List<Data>? data;

  OrdersResponse({this.success, this.message, this.data});

  OrdersResponse.fromJson(Map<String, dynamic> json) {
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
  String? status;
  String? color;
  String? orderid;
  int? addressid;
  int? amount;
  int? dlcharge;
  String? comment;
  String? createdAt;

  Data(
      {this.status,
        this.color,
        this.orderid,
        this.addressid,
        this.amount,
        this.dlcharge,
        this.comment,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    color = json['color'];
    orderid = json['orderid'];
    addressid = json['addressid'];
    amount = json['amount'];
    dlcharge = json['dlcharge'];
    comment = json['comment'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['color'] = this.color;
    data['orderid'] = this.orderid;
    data['addressid'] = this.addressid;
    data['amount'] = this.amount;
    data['dlcharge'] = this.dlcharge;
    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    return data;
  }
}
