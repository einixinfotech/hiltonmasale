import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hilton_masale/common/common.dart';
import 'package:hilton_masale/components/video_player_init.dart';
import 'package:hilton_masale/components/video_player_screen.dart';
import 'package:hilton_masale/components/view_photo.dart';
import 'package:hilton_masale/db/cart_database.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/models/cart_model.dart';
import 'package:hilton_masale/network/api.dart';
import 'package:hilton_masale/response/get_home_products_response.dart';
import 'package:hilton_masale/response/product_detail_response.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  const ProductDetailsScreen({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  Varient selectedVarient = Varient();
  bool _isLoading = false;
  ProductsDetailsResponse response = ProductsDetailsResponse();
  int _current = 0;
  int variantIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:  ValueListenableBuilder(
        valueListenable: Common.cartItems,
        builder: (BuildContext context,
            value, dynamic child) {
          return addOrChangeQuantity(
              selectedVarient,
              Common.cartItems.value);
        },
      ),
      appBar: AppBar(
        title: Text("Product Details"),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()) :
      Column(
        children: [
          Visibility(
            visible: response.data!.image!.isNotEmpty,
            child: Container(
              height: 190.0,
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider.builder(
                itemCount: response.data!.image?.length??0,
                options: CarouselOptions(
                  onPageChanged: (index,reason){
                    setState(() {
                      _current = index;
                    });
                  },
                  viewportFraction: 1.08,
                  enlargeCenterPage: true,
                  autoPlay: (response.data!.image?.length??0) == 1 ? false : true,
                  scrollPhysics: (response.data!.image?.length??0) == 1 ? NeverScrollableScrollPhysics() : ClampingScrollPhysics(),
                ),
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return GestureDetector(
                    onTap: (){
                      response.data!.image?[index].type == "image" ?
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context)=>ViewPhoto(url: response.data!.image?[index].image??"")))
                          : Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>VideoPlayerScreen(url: response.data!.image?[index].image??"")));
                    },
                    // onTap: _listOfCarouselImages[index].type==1 ? (){
                    //   Navigator.push(context, MaterialPageRoute(builder: (context)=>
                    //       GetProductsByCategoryScreen(_listOfCarouselImages[index].catid.toString(), _listOfCarouselImages[index].catid.toString())));
                    // }:(){},
                    child:  response.data!.image?[index].type == "image" ? Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 4, right: 4),
                      child: Container(
                        // decoration: BoxDecoration(
                        //     image: DecorationImage(
                        //       image: NetworkImage(
                        //         response.data?.image?[index].image??"",
                        //       ),
                        //       fit: BoxFit.fitHeight,
                        //     ),
                        // ),
                        child: Image.network(response.data!.image?[index].image??"",fit: BoxFit.fitHeight,errorBuilder:
                            (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Icon(Icons.broken_image,color: Colors.grey.shade400,size: 60,);
                        },
                            loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                        ),
                      ),
                    ):VideoPlayerInit(url: response.data!.image?[index].image??""),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        response.data!.varient?[variantIndex].name??"",
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 0.3,
                          wordSpacing: 1,
                          height: 1.5,
                        ),
                      ),
                      /*Text(
                          widget.item.category!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            letterSpacing: 0.3,
                            wordSpacing: 1,
                            height: 1.5,
                          ),
                        ),*/
                      Row(
                        children: [
                          Text(
                            "₹${response.data!.varient?[variantIndex].wrate}",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              wordSpacing: 1,
                              color: Colors.grey[900],
                              height: 1.5,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "₹${response.data!.varient?[variantIndex].mrp??""}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              letterSpacing: 0.3,
                              wordSpacing: 1,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          (response.data!.varient?.length??0) <= 1 ? Container() :
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(width: 1,color: Colors.black38),
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
            margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: DropdownButton<Varient>(
                value: selectedVarient,
                underline: Container(),
                isExpanded: true,
                onChanged: (val){
                  // selectedCity = CityData();
                  // selectedCity?.id = val?.id??0;
                  print(val!.id.toString());
                  setState(() {
                    variantIndex = response.data!.varient?.indexOf(val)??0;
                    selectedVarient = val;
                  });
                  // getSimilarProducts(selectedVarient?.id.toString()??"");
                  // getProductDetails(selectedVarient?.id.toString()??"");
                },
                hint: Text("Varients"),
                items: response.data!.varient!.map((e) {
                  return DropdownMenuItem(child: Text(e.name??''),value: e);
                }).toList()
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Product Description",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  letterSpacing: 0.3,
                  wordSpacing: 1,
                  height: 1.5,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                response.data!.varient?[variantIndex].description??"",
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 0.3,
                  height: 1.5,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          // Divider(),
        ],
      ),
    );
  }

  getDetails(){
    setState(() {
      _isLoading = true;
    });
    Map<String,dynamic> formData = {
      "product_id": widget.productId,
    };
    getProductsDetailsApi(formData).then((value) {
      setState(() {
        _isLoading = false;
      });
      var responseData = jsonDecode(value.body);
      if (value.statusCode == 200) {
        response = ProductsDetailsResponse.fromJson(jsonDecode(value.body));
        selectedVarient = response.data!.varient![0];
      }else if (value.statusCode >= 500 && value.statusCode <= 599) {
        showSnackBar(context, "Can't get Details: server error", 1500);
      } else if (value.statusCode == 401) {
        showSnackBar(context, "Session expired, please login again", 2000);
        Future.delayed(Duration(milliseconds: 2000), () {
          logout(context);
        });
      } else {
        showSnackBar(context, responseData[Common.messageKey], 1500);
      }
    }).catchError((onError){
      setState(() {
        print("getProductDetails: $onError");
        _isLoading = false;
      });
    });
  }
  Future<void> _changeQuantity(
      CartModel itemCart, bool isIncrement, Varient item) async {
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

  Future<void> removeItem(CartModel itemCart, Varient item) async {
    await CartDatabase.instance.delete(itemCart.productId);
    item.hasInCart = false;
  }

  Widget addOrChangeQuantity(Varient item, List<CartModel> value) {

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
                        _changeQuantity(currentItemCart!, false, item);
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
                        _changeQuantity(currentItemCart!, true, item);
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

  Future<void> addProductToCart(Varient selectedProduct) async {
    setState(() {
      selectedProduct.hasInCart = true;
    });
    if(selectedProduct.selectedVariant==null)
    {
      selectedProduct.selectedVariant=selectedProduct;
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

  Future<List<CartModel>> getCartItems() async {
    await CartDatabase.instance.getListOfItemsInCart().then((value) {
      Common.cartItems.value = value;

      return value;
    });
    return [];
  }
}
