import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hilton_masale/common/common.dart';
import 'package:hilton_masale/components/empty_screen.dart';
import 'package:hilton_masale/db/cart_database.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/models/cart_model.dart';
import 'package:hilton_masale/network/api.dart';
import 'package:hilton_masale/res/strings/strings.dart';
import 'package:hilton_masale/res/values/colors.dart';
import 'package:hilton_masale/response/search_result_response.dart';

class SearchResultsUI extends StatefulWidget {
  late String searchQuery;

  SearchResultsUI(this.searchQuery);

  @override
  _SearchResultsUIState createState() => _SearchResultsUIState();
}

class _SearchResultsUIState extends State<SearchResultsUI> {
  TextEditingController _searchController = TextEditingController();
  List<Data> _listOfSearchResult = [];
  int _state = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Results for \"${widget.searchQuery}\""),
        bottom: PreferredSize(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Container(
                height: 48,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.text,
                  controller: _searchController,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  onFieldSubmitted: _search,
                  decoration: InputDecoration(
                    suffixIcon: Visibility(
                      visible: _state != 0,
                      child: IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              _state = 0;
                              _searchController.clear();
                            });
                          }),
                    ),
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Search for Spices, Groceries and more",
                    prefixIcon: Icon(Icons.search, color: Colors.black87),
                  ),
                ),
              ),
            ),
            preferredSize: Size.fromHeight(60.0)),
      ),
      body: _state == 1
          ? Center(child: CircularProgressIndicator())
          : _state == 0
              ? Center(child: Text("Type your query in search bar "))
              : _state == 3
                  ? EmptyScreenUI("No products available", false)
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _listOfSearchResult.length,
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
                                      child: _listOfSearchResult[index].image ==
                                              "https://patanjali.einixinfotech.com/storage/product/"
                                          ? ClipRRect(
                                              child: Image.asset(
                                                imagePath + "launcher_icon.png",
                                                fit: BoxFit.fitWidth,
                                              ),
                                            )
                                          : ClipRRect(
                                              child: FadeInImage.assetNetwork(
                                              image: _listOfSearchResult[index].image?.toString()??"",
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 8),
                                        Text(
                                          _listOfSearchResult[index].name!,
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
                                          "₹ ${_listOfSearchResult[index].rate}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              _listOfSearchResult[index]
                                                      .stock!
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
                                          value: _listOfSearchResult[index].selectedVariant == null
                                              ? _listOfSearchResult[index].varient![0]
                                              : _listOfSearchResult[index].selectedVariant,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _listOfSearchResult[index].selectedVariant = newValue;
                                            });
                                          },
                                          items: _listOfSearchResult[index]
                                              .varient!
                                              .map<DropdownMenuItem<Varient>>(
                                                  (Varient value) {
                                            return DropdownMenuItem<Varient>(
                                              value: value,
                                              child: Text(value.size
                                                      .toString() +
                                                  " ${value.uom} ( ₹ ${value.rate})"),
                                            );
                                          }).toList(),
                                        ),
                                        SizedBox(
                                          height: 6,
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
                                                    _listOfSearchResult[index],
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
                    ),
    );
  }

  @override
  void initState() {
    super.initState();
    _search(widget.searchQuery);
  }

  void _search(String searchQuery) {
    Map<String, String> formData = {
      "keyword": searchQuery.trim(),
      "vendorid": "1"
    };
    setState(() {
      _state = 1;
      searchProductsApi(formData).then((value) {
        setState(() {
          widget.searchQuery = searchQuery;
          _state = 2;
          print("search result is ${value.body}");
          var responseData = jsonDecode(value.body);
          if (responseData[Common.successKey]) {
            SearchResultResponse response =
                SearchResultResponse.fromJson(jsonDecode(value.body));
            _listOfSearchResult = response.data!;
            if (_listOfSearchResult.isEmpty) {
              _state = 3;
            }
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            _listOfSearchResult.clear();
            _state = 0;
            print("searchQuery: $_state");
            showSnackBar(context, "Server error please try again later", 1500);
          } else {
            showSnackBar(context, responseData[Common.responseKey], 1500);
            _listOfSearchResult.clear();
            _state = 0;
            print("searchQuery: $_state");
          }
        });
      }).catchError((onError) {
        setState(() {
          _state = 0;
          print("searchProductsApiError: $onError");
        });
      });
    });
  }

  Widget addOrChangeQuantity(Data item, int index, List<CartModel> value) {
    print("CartSize Home " + value.length.toString());

    if (value.isNotEmpty) {
      CartModel? currentItemCart;
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
      CartModel itemCart, bool isIncrement, Data item) async {
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

  Future<void> removeItem(CartModel itemCart, Data item) async {
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

  Future<void> addProductToCart(Data selectedProduct) async {
    setState(() {
      selectedProduct.hasInCart = true;
    });
    if(selectedProduct.selectedVariant==null && selectedProduct.varient!.length>0)
    {
      selectedProduct.selectedVariant=selectedProduct.varient![0];
    }
    print("addProductToCartFromHomeScreen ${selectedProduct.productid.toString() + " selectedProductID"}");
    try {
      CartModel item;
      if (selectedProduct.selectedVariant != null) {
        item = CartModel(selectedProduct.selectedVariant!.id.toString(),
            1,
            selectedProduct.selectedVariant!.rate,
            selectedProduct.name! +
                selectedProduct.selectedVariant!.size.toString() +
                "-" +
                selectedProduct.selectedVariant!.uom.toString(),
            selectedProduct.image);
      }else{
        item = CartModel(
            selectedProduct.productid.toString(),
            1,
            selectedProduct!.rate,
            selectedProduct.name,
            selectedProduct!.image);
      }
      await CartDatabase.instance.create(item);
      getCartItems();
    } catch (error) {
      print("addProductToCartFromHomeScreenUI_Error $error");
    }
  }
}
