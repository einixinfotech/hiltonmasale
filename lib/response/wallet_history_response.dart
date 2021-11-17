class WalletHistoryResponse {
  bool? success;
  String? message;
  List<Data>? data;

  WalletHistoryResponse({this.success, this.message, this.data});

  WalletHistoryResponse.fromJson(Map<String, dynamic> json) {
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
  int? amount;
  String? remark;
  String? refId;
  String? type;
  String? createdAt;

  Data(
      {this.id,
        this.amount,
        this.remark,
        this.refId,
        this.type,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    remark = json['remark'];
    refId = json['ref_id'];
    type = json['type'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['remark'] = this.remark;
    data['ref_id'] = this.refId;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    return data;
  }
}