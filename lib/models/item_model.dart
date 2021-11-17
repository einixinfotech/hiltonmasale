class ItemModel {
  String _productid;
  int _quantity;

  ItemModel(this._productid, this._quantity);

  int get quantity => _quantity;

  set quantity(int value) {
    _quantity = value;
  }

  String get productid => _productid;

  set productid(String value) {
    _productid = value;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productid'] = this._productid;
    data['quantity'] = this.quantity;
    return data;
  }
}
