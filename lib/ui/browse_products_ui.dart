import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:hilton_masale/common/common.dart';
import 'package:hilton_masale/db/cart_database.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/models/cart_model.dart';
import 'package:hilton_masale/network/api.dart';
import 'package:hilton_masale/res/strings/strings.dart';
import 'package:hilton_masale/res/values/colors.dart';
import 'package:hilton_masale/response/categories_response.dart'
    as SelectedCategory;
import 'package:hilton_masale/response/get_list_of_tabs_response.dart';
import 'package:hilton_masale/response/products_by_category_response.dart';
import 'package:hilton_masale/response/products_response.dart' as Product;

class BrowseProductsUI extends StatefulWidget {
  late SelectedCategory.Response selectedCategory;

  BrowseProductsUI(this.selectedCategory);

  @override
  _BrowseProductsUIState createState() => _BrowseProductsUIState();
}

class _BrowseProductsUIState extends State<BrowseProductsUI>
    with TickerProviderStateMixin {
  int initPosition = 0;
  bool _isTabLoading = true, _isProductsLoading = false;
  List<Product.Response> listOfProducts = [];
  List<Response> listOfSubCategories = [];
  String _variantDropDownValue = 'Select a Packaging';
  List<String> _listOfProductVariants = [
    'Select a Packaging',
    '200gm',
    '1Kg',
    '5Kg'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ValueListenableBuilder(
              valueListenable: Common.cartItems,
              builder: (context, value, child) {
                return InkWell(
                  onTap: () {},
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
        title: Text(widget.selectedCategory.name!),
      ),
      body: _isTabLoading
          ? Center(child: CircularProgressIndicator())
          : CustomTabView(
              initPosition: initPosition,
              itemCount: listOfSubCategories.length,
              tabBuilder: (context, index) =>
                  Tab(text: listOfSubCategories[index].name),
              pageBuilder: (context, index) => _isProductsLoading
                  ? Center(child: CircularProgressIndicator())
                  : Center(
                      child: listOfProducts.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: listOfProducts.length,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 110,
                                            height: 120,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 4),
                                              child: listOfProducts[index]
                                                          .image ==
                                                      "https://patanjali.einixinfotech.com/storage/product/"
                                                  ? ClipRRect(
                                                      child: Image.asset(
                                                        imagePath +
                                                            "launcher_icon.png",
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                    )
                                                  : ClipRRect(
                                                      child: FadeInImage
                                                          .assetNetwork(
                                                      image:
                                                          listOfProducts[index]
                                                              .image!,
                                                      fit: BoxFit.fitWidth,
                                                      placeholder: imagePath +
                                                          "launcher_icon.png",
                                                    )),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 8),
                                                Text(
                                                  listOfProducts[index].name!,
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
                                                  "₹ ${listOfProducts[index].rate}",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Text(
                                                      listOfProducts[index]
                                                              .stock! +
                                                          " in stock",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2,
                                                    )),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                DropdownButton<String>(
                                                  value: _variantDropDownValue,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      _variantDropDownValue =
                                                          newValue!;
                                                    });
                                                  },
                                                  items: _listOfProductVariants.map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: SizedBox(
                                                    width: 128,
                                                    child:
                                                        ValueListenableBuilder(
                                                      valueListenable:
                                                          Common.cartItems,
                                                      builder:
                                                          (BuildContext context,
                                                              value,
                                                              dynamic child) {
                                                        return addOrChangeQuantity(
                                                            listOfProducts[
                                                                index],
                                                            index,
                                                            Common.cartItems
                                                                .value);
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
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            )),
              onPositionChange: (index) {
                /* setState(() {
                  listOfProducts.clear();
                });*/
                initPosition = index;
                String selectedCategoryId =
                    listOfSubCategories[index].categoryId!;
                // getProductsForSelectedCategory(int.parse(selectedCategoryId));
                print("onPositionChangeCalled");
                print('current position: $index');
                print("selectedCategoryId $selectedCategoryId");
              },
              onScroll: (position) {
                /*  Future.delayed(Duration(milliseconds: 200), () {
                  setState(() {
                    listOfProducts.clear();
                  });
                });*/
                print(position);
              }),
    );
  }

  @override
  void initState() {
    super.initState();
    // getProductsForSelectedCategory(int.parse(widget.selectedCategory.categoryId!));
    getProductsByCategoryData();
    // getListOfTabs();
  }

  ProductsByCategoryResponse response = ProductsByCategoryResponse();

  getProductsByCategoryData(){
    Map<String,dynamic> formData = {
      "catid":widget.selectedCategory.categoryId
    };
    getProductsByCategoryApi(formData).then((value){

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

/*  void getProductsForSelectedCategory(int selectedCategoryId) {
    setState(() {
      _isProductsLoading = true;
      listOfProducts.clear();
      print("getProductsForSelectedCategory");
      Map<String, int> formData = {"catid": selectedCategoryId};
      getPopularProductsApi(formData).then((value) {
        setState(() {
          _isProductsLoading = false;
          var responseData = jsonDecode(value.body);

          if (responseData[Common.successKey]) {
            Product.GetProductsResponse response =
                Product.GetProductsResponse.fromJson(jsonDecode(value.body));
            listOfProducts = response.response!;
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            showSnackBar(context, "Server error please try again later", 1500);
          } else {
            showSnackBar(context, responseData[Common.responseKey], 1500);
          }
        });
      }).catchError((onError) {
        setState(() {
          _isProductsLoading = false;
          print("getPopularProductsApiError: $onError");
        });
      });
    });
  }*/

  /*void getListOfTabs() {
    print("getListOfTabs");
    setState(() {
      _isTabLoading = true;

      Map<String, String> formData = {
        "categoryid": widget.selectedCategory.categoryId!
      };

      getListOfTabsApi(formData).then((value) {
        print("getListOfTabsApi ${value.statusCode}");
        setState(() {
          _isTabLoading = false;
          var responseData = jsonDecode(value.body);
          if (responseData[Common.successKey]) {
            response = GetListOfTabs.fromJson(jsonDecode(value.body));
            listOfSubCategories = response.response!;
          } else {
            showSnackBar(context, responseData[Common.responseKey], 1500);
          }
        });
      }).catchError((onError) {
        setState(() {
          _isTabLoading = false;
          print("getListOfTabsApiError: $onError");
        });
      });
    });
  }*/

  Widget addOrChangeQuantity(
      Product.Response item, int index, List<CartModel> value) {
    print("CartSize Home " + value.length.toString());

    if (value.isNotEmpty) {
      CartModel? currentItemCart;
      for (CartModel currentCartItem in value) {
        if (int.parse(item.productid.toString()) ==
            int.parse(currentCartItem.productId.toString())) {
          //alreadyInCart = true;
          item.hasInCart = true;
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
                side: BorderSide(color: Colors.black, width: 1)),
            elevation: 0,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: FlatButton(
                      padding: EdgeInsets.only(right: 2),
                      onPressed: () {
                        _changeQuantity(currentItemCart!, false, item);
                      },
                      child: Icon(
                        Icons.remove,
                        color: primaryColor,
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
                        _changeQuantity(currentItemCart!, true, item);
                      },
                      child: Icon(
                        Icons.add,
                        color: primaryColor,
                        size: 15,
                      )),
                ),
              ],
            ),
          ),
        );
      } else {
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
                      return primaryColor;
                    return primaryColor; // Use the component's default.
                  },
                ),
              ),
            ));
      }
    } else {
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
                    return primaryColor;
                  return primaryColor; // Use the component's default.
                },
              ),
            ),
          ));
    }
  }

  Future<void> _changeQuantity(
      CartModel itemCart, bool isIncrement, Product.Response item) async {
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

  Future<void> removeItem(CartModel itemCart, Product.Response item) async {
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

  Future<void> addProductToCart(Product.Response selectedProduct) async {
    setState(() {
      selectedProduct.hasInCart = true;
    });
    print(
        "addProductToCartFromHomeScreen ${selectedProduct.productid.toString() + " selectedProductID"}");
    try {
      CartModel item = CartModel(selectedProduct.productid, 1,
          selectedProduct.rate, selectedProduct.name, selectedProduct.image);
      await CartDatabase.instance.create(item);
      getCartItems();
    } catch (error) {
      print("addProductToCartFromHomeScreenUI_Error $error");
    }
  }
}

class CustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;

  CustomTabView({
    required this.itemCount,
    required this.tabBuilder,
    required this.pageBuilder,
    required this.onPositionChange,
    required this.onScroll,
    required this.initPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
  late TabController controller;
  late int _currentCount;
  late int _currentPosition;

  @override
  void initState() {
    print("initState CustomTabView");
    _currentPosition = widget.initPosition;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation!.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation!.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      _currentPosition = widget.initPosition;

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation!.addListener(onScroll);
      });
    } else
      controller.animateTo(widget.initPosition);

    super.didUpdateWidget(oldWidget);

    print("Position: $_currentCount");
  }

  @override
  void dispose() {
    controller.animation!.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: TabBar(
            isScrollable: true,
            controller: controller,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).hintColor,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
            tabs: List.generate(
              widget.itemCount,
              (index) => widget.tabBuilder(context, index),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              widget.itemCount,
              (index) => widget.pageBuilder(context, index),
            ),
          ),
        ),
      ],
    );
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll(controller.animation!.value);
    }
  }

  Future<void> addProductToCart(Product.Response selectedProduct) async {
    setState(() {
      selectedProduct.hasInCart = true;
    });
    print(
        "addProductToCartFromHomeScreen ${selectedProduct.productid.toString() + " selectedProductID"}");
    try {
      CartModel item = CartModel(selectedProduct.productid, 1,
          selectedProduct.rate, selectedProduct.name, selectedProduct.image);
      await CartDatabase.instance.create(item);
      getCartItems();
    } catch (error) {
      print("addProductToCartFromHomeScreenUI_Error $error");
    }
  }

  Future<List<CartModel>> getCartItems() async {
    await CartDatabase.instance.getListOfItemsInCart().then((value) {
      Common.cartItems.value = value;

      return value;
    });
    return [];
  }

  Future<void> removeItem(CartModel itemCart, Product.Response item) async {
    await CartDatabase.instance.delete(itemCart.productId);
    item.hasInCart = false;
  }
}
