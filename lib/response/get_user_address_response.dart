class UserAddressResponse {
  bool? success;
  bool? error;
  List<Response>? response;

  UserAddressResponse({this.success, this.error, this.response});

  UserAddressResponse.fromJson(Map<String, dynamic> json) {
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
  String? addressid;
  String? userid;
  String? country;
  String? state;
  String? city;
  String? cityid;
  String? pincode;
  String? landmark;
  String? mobile;
  String? address;
  String? name;

  Response(
      {this.addressid,
      this.userid,
      this.country,
      this.state,
      this.city,
      this.cityid,
      this.pincode,
      this.landmark,
      this.mobile,
      this.address,
      this.name});

  Response.fromJson(Map<String, dynamic> json) {
    addressid = json['addressid'];
    userid = json['userid'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    cityid = json['cityid'];
    pincode = json['pincode'];
    landmark = json['landmark'];
    mobile = json['mobile'];
    address = json['address'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addressid'] = this.addressid;
    data['userid'] = this.userid;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['cityid'] = this.cityid;
    data['pincode'] = this.pincode;
    data['landmark'] = this.landmark;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['name'] = this.name;
    return data;
  }
}
