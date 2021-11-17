class OrderDetailsResponse {
  bool? success;
  String? message;
  Data? data;

  OrderDetailsResponse({
      this.success, 
      this.message, 
      this.data});

  OrderDetailsResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class Data {
  List<Details>? details;
  int? dlcharge;
  int? discount;
  String? dispatchno;
  String? trackinglink;
  String? pmode;
  int? subtotal;
  String? promocode;
  String? address;
  String? status;
  String? color;

  Data({
      this.details, 
      this.dlcharge, 
      this.discount, 
      this.dispatchno, 
      this.trackinglink, 
      this.pmode, 
      this.subtotal, 
      this.promocode, 
      this.address, 
      this.status, 
      this.color});

  Data.fromJson(dynamic json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details?.add(Details.fromJson(v));
      });
    }
    dlcharge = json['dlcharge'];
    discount = json['discount'];
    dispatchno = json['dispatchno'];
    trackinglink = json['trackinglink'];
    pmode = json['pmode'];
    subtotal = json['subtotal'];
    promocode = json['promocode'];
    address = json['address'];
    status = json['status'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (details != null) {
      map['details'] = details?.map((v) => v.toJson()).toList();
    }
    map['dlcharge'] = dlcharge;
    map['discount'] = discount;
    map['dispatchno'] = dispatchno;
    map['trackinglink'] = trackinglink;
    map['pmode'] = pmode;
    map['subtotal'] = subtotal;
    map['promocode'] = promocode;
    map['address'] = address;
    map['status'] = status;
    map['color'] = color;
    return map;
  }

}

class Details {
  String? name;
  int? wrate;
  int? mrp;
  int? rate;

  Details({
      this.name, 
      this.wrate, 
      this.mrp, 
      this.rate});

  Details.fromJson(dynamic json) {
    name = json['name'];
    wrate = json['wrate'];
    mrp = json['mrp'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['wrate'] = wrate;
    map['mrp'] = mrp;
    map['rate'] = rate;
    return map;
  }

}