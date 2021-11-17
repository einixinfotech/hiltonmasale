class GetOrderDetailsResponse {
  bool? success;
  String? total;
  String? dlcharge;
  int? subtotal;
  bool? error;
  List<Response>? response;

  GetOrderDetailsResponse(
      {this.success,
        this.total,
        this.dlcharge,
        this.subtotal,
        this.error,
        this.response});

  GetOrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    total = json['total'];
    dlcharge = json['dlcharge'];
    subtotal = json['subtotal'];
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
    data['dlcharge'] = this.dlcharge;
    data['subtotal'] = this.subtotal;
    data['error'] = this.error;
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  String? id;
  String? name;
  String? rate;
  String? wrate;
  String? ismember;
  String? quantity;
  int? totalrate;
  int? totalwrate;

  Response(
      {this.id,
        this.name,
        this.rate,
        this.wrate,
        this.ismember,
        this.quantity,
        this.totalrate,
        this.totalwrate});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    rate = json['rate'];
    wrate = json['wrate'];
    ismember = json['ismember'];
    quantity = json['quantity'];
    totalrate = json['totalrate'];
    totalwrate = json['totalwrate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['rate'] = this.rate;
    data['wrate'] = this.wrate;
    data['ismember'] = this.ismember;
    data['quantity'] = this.quantity;
    data['totalrate'] = this.totalrate;
    data['totalwrate'] = this.totalwrate;
    return data;
  }
}
