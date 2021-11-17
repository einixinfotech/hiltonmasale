class Sizes {
  int? isDefault;
  String? size;

  Sizes({this.isDefault, this.size});

  Sizes.fromJson(Map<String, dynamic> json) {
    isDefault = json['default'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['default'] = this.isDefault;
    data['size'] = this.size;
    return data;
  }
}
