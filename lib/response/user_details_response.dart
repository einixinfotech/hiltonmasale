class UserDetailsResponse {
  bool? success;
  String? message;
  UserData? data;

  UserDetailsResponse({this.success, this.message, this.data});

  UserDetailsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserData {
  String? name;
  String? mobile;
  String? email;
  String? type;
  String? address;
  String? firmname;
  String? shareLink;
  String? gstno;
  int? fssai;
  String? referalcode;
  int? wallet;
  int? referpoints;

  UserData(
      {this.name,
        this.mobile,
        this.email,
        this.type,
        this.address,
        this.firmname,
        this.shareLink,
        this.gstno,
        this.fssai,
        this.referalcode,
        this.wallet,
        this.referpoints});

  UserData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    type = json['type'];
    address = json['address'];
    firmname = json['firmname'];
    shareLink = json['share_link'];
    gstno = json['gstno'];
    fssai = json['fssai'];
    referalcode = json['referalcode'];
    wallet = json['wallet'];
    referpoints = json['referpoints'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['type'] = this.type;
    data['address'] = this.address;
    data['firmname'] = this.firmname;
    data['share_link'] = this.shareLink;
    data['gstno'] = this.gstno;
    data['fssai'] = this.fssai;
    data['referalcode'] = this.referalcode;
    data['wallet'] = this.wallet;
    data['referpoints'] = this.referpoints;
    return data;
  }
}
