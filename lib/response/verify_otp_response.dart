class VerifyOtpResponse {
  bool? success;
  bool? error;
  String? userid;
  String? mobile;
  int? ismember;
  String? status;
  String? response;

  VerifyOtpResponse(
      {this.success,
      this.error,
      this.userid,
      this.mobile,
      this.ismember,
      this.status,
      this.response});

  VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    userid = json['userid'];
    mobile = json['mobile'];
    ismember = json['ismember'];
    status = json['status'];
    response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['error'] = this.error;
    data['userid'] = this.userid;
    data['mobile'] = this.mobile;
    data['ismember'] = this.ismember;
    data['status'] = this.status;
    data['response'] = this.response;
    return data;
  }
}
