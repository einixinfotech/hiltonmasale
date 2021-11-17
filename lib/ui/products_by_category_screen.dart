import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:hilton_masale/common/common.dart';
import 'package:hilton_masale/components/empty_screen.dart';
import 'package:hilton_masale/db/cart_database.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/models/cart_model.dart';
import 'package:hilton_masale/network/api.dart';
import 'package:hilton_masale/res/strings/strings.dart';
import 'package:hilton_masale/response/get_home_products_response.dart';

import 'cart_ui.dart';

class ProductsByCategory extends StatefulWidget {
  final String catName,catId;
  const ProductsByCategory({Key? key, required this.catName, required this.catId}) : super(key: key);

  @override
  _ProductsByCategoryState createState() => _ProductsByCategoryState();
}

class _ProductsByCategoryState extends State<ProductsByCategory> {

  List<ProductsData> _listOfHomeProducts = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.catName),
        actions: [
          ValueListenableBuilder(
              valueListenable: Common.cartItems,
              builder: (context, value, child) {
                return InkWell(
                  onTap: () {
                    pushToNewRoute(context, CartUI());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16, top: 8),
                    child: Badge(
                      toAnimate: true,
                      animationType: BadgeAnimationType.slide,
                      showBadge: Common.cartItems.value.isNotEmpty,
                      animationDuration: Duration(milliseconds: 300),
                      badgeColor: Colors.black,
                      alignment: Alignment.center,
                      position: BadgePosition.topEnd(),
                      badgeContent: ValueListenableBuilder(
                        valueListenable: Common.cartItems,
                        builder: (context, value, child) {
                          return Text(
                            Common.cartItems.value.length.toString(),
                            style: TextStyle(color: Colors.white),
                          );
                        },
                      ),
                      child: Icon(Icons.shopping_cart),
                    ),
                  ),
                );
              })
        ],
        // title: Text(widget.selectedCategory.name!),
      ),
      body: isLoading ? Center(child: CircularProgressIndicator())
     : _listOfHomeProducts.length > 0 ?
           ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _listOfHomeProducts.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 110,
                      height: 120,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 4),
                        child: _listOfHomeProducts[index].image ==
                            "https://patanjali.einixinfotech.com/storage/product/"
                            ? ClipRRect(
                          child: Image.asset(
                            imagePath + "launcher_icon.png",
                            fit: BoxFit.fitWidth,
                          ),
                        )
                            : ClipRRect(
                            child: FadeInImage.assetNetwork(
                              image: _listOfHomeProducts[index].image![0].image!,
                              fit: BoxFit.fitWidth,
                              placeholder:
                              imagePath + "launcher_icon.png",
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            _listOfHomeProducts[index].name!,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "₹ ${_listOfHomeProducts[index].rate}",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                _listOfHomeProducts[index]
                                    .wrate
                                    .toString() +
                                    " in stock",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2,
                              )),
                          SizedBox(
                            height: 6,
                          ),
                          DropdownButton<Varient>(
                            value: _listOfHomeProducts[index].selectedVariant == null
                                ? _listOfHomeProducts[index].varient![0]
                                : _listOfHomeProducts[index].selectedVariant,
                            onChanged: (newValue) {
                              setState(() {
                                _listOfHomeProducts[index].selectedVariant = newValue;
                              });
                            },
                            items: _listOfHomeProducts[index]
                                .varient!
                                .map<DropdownMenuItem<Varient>>(
                                    (Varient value) {
                                  return DropdownMenuItem<Varient>(
                                    value: value,
                                    child: Text(value.size.toString() +
                                        " ${value.uom} ( ₹ ${value.rate})"),
                                  );
                                }).toList(),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                              width: 128,
                              child: ValueListenableBuilder(
                                valueListenable: Common.cartItems,
                                builder: (BuildContext context,
                                    value, dynamic child) {
                                  return addOrChangeQuantity(
                                      _listOfHomeProducts[index],
                                      index,
                                      Common.cartItems.value);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ):EmptyScreenUI("No Products Found!", false),
    );
  }

  void getProducts() {
    setState(() {
      isLoading = true;
    });
    print(widget.catId);
    Map<String,dynamic> formData = {
      "catid": widget.catId
    };
    getProductsByCategoryApi(formData).then((value) {
      setState(() {
        isLoading = false;
      });
      var responseData = jsonDecode(value.body);
      if (value.statusCode == 200) {
        GetHomeProductsResponse response = GetHomeProductsResponse.fromJson(jsonDecode(value.body));
        setState(() {
          _listOfHomeProducts = response.data!;
        });
      } else if (value.statusCode >= 500 && value.statusCode <= 599) {
        showSnackBar(context, "Can't add address: server error", 1500);
      } else if (value.statusCode == 401) {
        showSnackBar(context, "Session expired, please login again", 2000);
        Future.delayed(Duration(milliseconds: 2000), () {
          logout(context);
        });
      } else {
        showSnackBar(context, responseData[Common.messageKey], 1500);
      }
    }).catchError((onError) {
      print("GetHomeProductsResponse: $onError");
    });
  }

  Widget addOrChangeQuantity(ProductsData item, int index, List<CartModel> value) {

    print("CartSize Home " + value.length.toString());

    if (value.isNotEmpty) {
      CartModel? currentItemCart = null;
      for (CartModel currentCartItem in value) {
        if (item.selectedVariant != null &&
            int.parse(item.selectedVariant!.id.toString()) ==
                int.parse(currentCartItem.productId.toString())) {
          item.hasInCart = true;
          // i = true;
          currentItemCart = currentCartItem;
          break;
        } else {
          item.hasInCart = false;
        }
      }
      if (item.hasInCart!) {
        return SizedBox(
          height: 40,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
                side: BorderSide(color: Colors.blueGrey, width: 1)),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: FlatButton(
                      padding: EdgeInsets.only(right: 2),
                      onPressed: () {
                        _changeQuantity(currentItemCart!, false, index, item);
                      },
                      child: Icon(
                        Icons.remove,
                        color: Colors.green,
                        size: 15,
                      )),
                ),
                Text(
                  currentItemCart == null
                      ? ""
                      : currentItemCart.quantity.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                Expanded(
                  flex: 1,
                  child: FlatButton(
                      padding: EdgeInsets.only(right: 2),
                      onPressed: () {
                        _changeQuantity(currentItemCart!, true, index, item);
                      },
                      child: Icon(
                        Icons.add,
                        color: Colors.green,
                        size: 15,
                      )),
                ),
              ],
            ),
          ),
        );
      }
      else {
        return SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: TextButton(
              onPressed: () {
                addProductToCart(item);
              },
              child: Text(
                "+ Add to Cart ",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    wordSpacing: 1.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Color(0xff237f52);
                      return Color(0xff237f52); // Use the component's default.
                    },
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                      ))),
            ));
      }
    }
    else {
      return SizedBox(
          height: 40,
          width: MediaQuery.of(context).size.width,
          child: TextButton(
            onPressed: () {
              setState(() {
                addProductToCart(item);
              });
            },
            child: Text(
              "+ Add to Cart ",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  wordSpacing: 1.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Color(0xff237f52);
                    return Color(0xff237f52); // Use the component's default.
                  },
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                    ))),
          ));
    }
  }

  Future<void> _changeQuantity(
      CartModel itemCart, bool isIncrement, int index, ProductsData item) async {
    if (isIncrement) {
      int quantity = itemCart.quantity + 1;
      print(quantity);
      CartModel item = CartModel(itemCart.productId, quantity, itemCart.rate,
          itemCart.productName, itemCart.productImage);
      await CartDatabase.instance.update(item);
    } else if (itemCart.quantity > 1 && itemCart.quantity >= 1) {
      int quantity = itemCart.quantity - 1;
      print(quantity);
      CartModel item = CartModel(itemCart.productId, quantity, itemCart.rate,
          itemCart.productName, itemCart.productImage);
      await CartDatabase.instance.update(item);
    } else if (itemCart.quantity == 1) {
      removeItem(itemCart, item);
    }

    getCartItems();
  }

  Future<void> removeItem(CartModel itemCart, ProductsData item) async {
    await CartDatabase.instance.delete(itemCart.productId);
    item.hasInCart = false;
  }

  Future<List<CartModel>> getCartItems() async {
    await CartDatabase.instance.getListOfItemsInCart().then((value) {
      Common.cartItems.value = value;

      return value;
    });
    return [];
  }

  Future<void> addProductToCart(ProductsData selectedProduct) async {
    setState(() {
      selectedProduct.hasInCart = true;
    });
    if(selectedProduct.selectedVariant==null && selectedProduct.varient!.length>0)
    {
      selectedProduct.selectedVariant=selectedProduct.varient![0];
    }
    print("addProductToCartFromHomeScreen ${selectedProduct.id.toString() + "selectedProductID"}");
    try {
      CartModel item;
      if (selectedProduct.selectedVariant != null) {

        item = CartModel(
            selectedProduct.selectedVariant!.id.toString(),
            1,
            selectedProduct.selectedVariant!.rate,
            selectedProduct.name! +
                selectedProduct.selectedVariant!.size.toString() +
                "-" +
                selectedProduct.selectedVariant!.uom.toString(),
            selectedProduct.image);
      } else {
        print("iam here ");
        item = CartModel(
            selectedProduct.id.toString(),
            1,
            selectedProduct.rate,
            selectedProduct.name,
            selectedProduct.image);
      }

      await CartDatabase.instance.create(item);
      getCartItems();
    } catch (error) {
      print("addProductToCartFromHomeScreenUI_Error $error");
    }
  }
}