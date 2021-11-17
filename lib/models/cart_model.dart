class CartModel {
  dynamic _productId;
  dynamic _quantity;
  dynamic _rate;
  dynamic _productName;
  dynamic _productImage;


  CartModel(this._productId, this._quantity, this._rate, this._productName,
      this._productImage);

  CartModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    quantity = json['quantity'];
    rate = json['rate'];
    productName = json['productName'];
    productImage = json['imageUrl'];
  }

  dynamic get productId => _productId;

  set productId(dynamic value) {
    _productId = value;
  }

  Map<String, Object?> toJson() => {
        'productId': productId,
        'quantity': quantity,
        'rate': rate,
        'productName': productName,
        'imageUrl': productImage
      };

  dynamic get quantity => _quantity;

  dynamic get productImage => _productImage;

  set productImage(dynamic value) {
    _productImage = value;
  }

  dynamic get productName => _productName;

  set productName(dynamic value) {
    _productName = value;
  }

  dynamic get rate => _rate;

  set rate(dynamic value) {
    _rate = value;
  }

  set quantity(dynamic value) {
    _quantity = value;
  }
}
