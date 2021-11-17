class ProductColors {
  int? isDefault;
  String? productColor;

  ProductColors({this.isDefault, this.productColor});

  ProductColors.fromJson(Map<String, dynamic> json) {
    isDefault = json['default'];
    productColor = json['productColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['default'] = this.isDefault;
    data['productColor'] = this.productColor;
    return data;
  }
}