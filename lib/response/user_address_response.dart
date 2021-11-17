class UserAddressResponse {
  bool? success;
  String? message;
  List<Data>? data;

  UserAddressResponse({
      this.success, 
      this.message, 
      this.data});

  UserAddressResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Data {
  int? id;
  String? city;
  int? state;
  String? cityName;
  String? stateName;
  String? pincode;
  String? longitude;
  String? latitude;
  String? address;
  String? floor;
  String? landmark;
  String? addresstype;
  String? name;
  String? mobile;
  int? isdefault;

  Data({
      this.id, 
      this.city, 
      this.state, 
      this.cityName, 
      this.stateName, 
      this.pincode, 
      this.longitude, 
      this.latitude, 
      this.address, 
      this.floor, 
      this.landmark, 
      this.addresstype, 
      this.name, 
      this.mobile, 
      this.isdefault});

  Data.fromJson(dynamic json) {
    id = json['id'];
    city = json['city'];
    state = json['state'];
    cityName = json['cityName'];
    stateName = json['stateName'];
    pincode = json['pincode'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    address = json['address'];
    floor = json['floor'];
    landmark = json['landmark'];
    addresstype = json['addresstype'];
    name = json['name'];
    mobile = json['mobile'];
    isdefault = json['isdefault'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['city'] = city;
    map['state'] = state;
    map['cityName'] = cityName;
    map['stateName'] = stateName;
    map['pincode'] = pincode;
    map['longitude'] = longitude;
    map['latitude'] = latitude;
    map['address'] = address;
    map['floor'] = floor;
    map['landmark'] = landmark;
    map['addresstype'] = addresstype;
    map['name'] = name;
    map['mobile'] = mobile;
    map['isdefault'] = isdefault;
    return map;
  }

}