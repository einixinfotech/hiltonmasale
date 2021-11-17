import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hilton_masale/common/common.dart';
import 'package:hilton_masale/components/custom_drawer_header.dart';
import 'package:hilton_masale/components/video_player_init.dart';
import 'package:hilton_masale/db/cart_database.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/models/cart_model.dart';
import 'package:hilton_masale/network/api.dart';
import 'package:hilton_masale/res/strings/strings.dart';
import 'package:hilton_masale/res/style/style.dart';
import 'package:hilton_masale/response/carousel_response.dart' as Carousel;
import 'package:hilton_masale/response/get_home_products_response.dart';
import 'package:hilton_masale/response/home_categories_response.dart';
import 'package:hilton_masale/ui/cart_ui.dart';
import 'package:hilton_masale/ui/product_detail_screen.dart';
import 'package:hilton_masale/ui/products_by_category_screen.dart';
import 'package:hilton_masale/ui/refer_and_earn.dart';
import 'package:hilton_masale/ui/refer_earn_screen.dart';
import 'package:hilton_masale/ui/search_result_ui.dart';
import 'package:hilton_masale/ui/support_and_help_ui.dart';
import 'package:hilton_masale/ui/welcome_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'address_ui.dart';
import 'orders_ui.dart';

class HomeScreeUI extends StatefulWidget {
  const HomeScreeUI({Key? key}) : super(key: key);

  @override
  _HomeScreeUIState createState() => _HomeScreeUIState();
}

class _HomeScreeUIState extends State<HomeScreeUI> {
  bool _isLoading = false, _isCarouselLoading = false;
  List<Carousel.Data> _listOfCarouselImages = [];
  List<ProductsData> _listOfHomeProducts = [];
  TextEditingController _searchController = TextEditingController();
  SharedPreferences? sharedPreferences = null;

  int varientIndex = 0;

  Future<bool> onWillPop() async {
    showExitDialog();
    return false;
  }

  showExitDialog() {
    showDialog(
        // backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Exit App"),
            content: Text("Are you sure, you want to exit this app?"),
            actions: [
              ButtonTheme(
                focusColor: Colors.blue[200],
                child: TextButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    },
                    child: Text("No")),
              ),
              ButtonTheme(
                hoverColor: Colors.blue[200],
                child: TextButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                      // Navigator.pop(context);
                    },
                    child: Text("Yes")),
              ),
            ],
          );
        });
  }

  List<HomeCategoryData> _listOfCategories = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Home Screen"),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: IconButton(
                icon: Icon(Icons.card_giftcard),
                onPressed: () {
                  if (Common.isLoggedIn) {
                    pushToNewRoute(context, ReferAndEarnUI());
                  } else {
                    showSnackBar(context, "Login First!", 1500);
                  }
                },
              ),
            ),
            ValueListenableBuilder(
                valueListenable: Common.cartItems,
                builder: (context, value, child) {
                  return InkWell(
                    onTap: () {
                      pushToNewRoute(context, CartUI());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0, top: 8.0),
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
                    onFieldSubmitted: _pushToSearchResults,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          }),
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: "Search for your favorites!",
                      prefixIcon: Icon(Icons.search, color: Colors.black87),
                    ),
                  ),
                ),
              ),
              preferredSize: Size.fromHeight(60.0)),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Common.isLoggedIn
                  ? CustomDrawerHeader(
                      "Hilton Agro Foods",
                      "hiltonagrofoods@gmail.com",
                      sharedPreferences != null
                          ? sharedPreferences!.getString(Common.userMobileNumberKey)!
                          : "")
                  : UserAccountsDrawerHeader(
                      accountName: Text("Hilton Agro"),
                      accountEmail: Text("hiltonagrofoods@gmail.com"),
                    ),
              ListTile(
                leading: Icon(Icons.home_rounded),
                title: Text(
                  "Home",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {},
              ),
              Visibility(
                visible: !Common.isLoggedIn,
                child: ListTile(
                  leading: Icon(Icons.shopping_cart_rounded),
                  title: Text(
                    "My Cart",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    pushToNewRoute(context, CartUI());
                  },
                ),
              ),
              Visibility(
                visible: Common.isLoggedIn,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.library_books),
                      title: Text(
                        "My Orders",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () => pushToNewRoute(context, OrdersUI()),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on_rounded),
                      title: Text(
                        "My Addresses",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () => pushToNewRoute(
                          context, AddressUI(false, "Saved Addresses")),
                    ),
                    ListTile(
                      leading: Icon(Icons.card_giftcard),
                      title: Text(
                        "Redeem Coupon",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        if (Common.isLoggedIn) {
                          pushToNewRoute(context, ReferAndEarnUI());
                        } else {
                          showSnackBar(context, "Login First!", 1500);
                        }
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.call),
                title: Text(
                  "Support",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () => pushToNewRoute(context, SupportAndHelpUI()),
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text(
                  "Refer and Earn",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {

                  if (Common.isLoggedIn) {
                    pushToNewRoute(context, ReferEarnScreen());
                  }else{
                    Navigator.pop(context);
                    showSnackBar(context, "Login First!", 1500);
                  }
                }
              ),
              ListTile(
                leading: Common.isLoggedIn
                    ? Icon(Icons.exit_to_app_rounded)
                    : Icon(Icons.login),
                title: Text(
                  Common.isLoggedIn ? "Log out" : "Log in",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  if (Common.isLoggedIn) {
                    setState(() {
                      logout(context);
                    });
                  } else {
                    pushToNewRoute(context, WelcomeUI());
                  }
                },
              ),
            ],
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: _isCarouselLoading
                          ? Center(child: CircularProgressIndicator())
                          : CarouselSlider.builder(
                              itemCount: _listOfCarouselImages.length,
                              options: CarouselOptions(
                                  viewportFraction: 1.0,
                                  enlargeCenterPage: true,
                                  autoPlay: true,
                                  aspectRatio: 2.5),
                              itemBuilder: (BuildContext context, int index,
                                  int realIndex) {
                                return InkWell(
                                  onTap: () {},
                                  child:
                                      _listOfCarouselImages[index].sliderType ==
                                              "image"
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                image: NetworkImage(
                                                  _listOfCarouselImages[index]
                                                      .image!,
                                                ),
                                                fit: BoxFit.fill,
                                              )),
                                            )
                                          : VideoPlayerInit(
                                              url: _listOfCarouselImages[index]
                                                      .image ??
                                                  ""),
                                );
                              },
                            ),
                    ),
                    isCategoriesLoading
                        ? Center(child: CircularProgressIndicator())
                        : _listOfCategories.length > 0
                            ? Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 10),
                                        child: Text("Shop By Categories",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: fontDefault,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.2,
                                                wordSpacing: 1,
                                                height: 1.5,
                                                backgroundColor: Colors.white
                                                    .withOpacity(0.78),
                                                color: Colors.black
                                                    .withOpacity(0.8))),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    color: Colors.white,
                                    child: GridView.builder(
                                      padding: EdgeInsets.all(4),
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: _listOfCategories.length,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisSpacing: 4,
                                              crossAxisCount: 3,
                                              mainAxisSpacing: 0.00,
                                              childAspectRatio: 150 / 150),
                                      itemBuilder: (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            print(_listOfCategories[index].id.toString());
                                            pushToNewRoute(
                                                context,
                                                ProductsByCategory(
                                                  catId:
                                                      _listOfCategories[index].id.toString(),
                                                  catName: _listOfCategories[index].name.toString(),
                                                ));
                                          },
                                          child: Container(
                                            height: 120,
                                            width: 150,
                                            child: Column(
                                              children: [
                                                Card(
                                                  margin: EdgeInsets.zero,
                                                  elevation: 0.4,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          height: 90,
                                                          width: 150,
                                                          child: ClipRRect(
                                                              child: _listOfCategories[
                                                                              index]
                                                                          .image ==
                                                                      "https://patanjali.einixinfotech.com/storage/category/"
                                                                  ? Image.asset(
                                                                      imagePath +
                                                                          "brand_logo.png",
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    )
                                                                  : ClipRRect(
                                                                      child: FadeInImage
                                                                          .assetNetwork(
                                                                      image: _listOfCategories[
                                                                              index]
                                                                          .image!,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      placeholder:
                                                                          imagePath +
                                                                              "brand_logo.png",
                                                                    )))),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(2),
                                                        alignment:
                                                            Alignment.center,
                                                        height: 30,
                                                        child: Text(
                                                          _listOfCategories[
                                                                  index]
                                                              .name!,
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.center,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 12,
                                                              letterSpacing:
                                                                  0.6,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 20),
                          child: Text("Trending Products",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: fontDefault,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                  wordSpacing: 1,
                                  height: 1.5,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.78),
                                  color: Colors.black.withOpacity(0.8))),
                        ),
                      ],
                    ),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _listOfHomeProducts.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailsScreen(
                                        productId: _listOfHomeProducts[index]
                                            .id
                                            .toString())));
                          },
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
                                              image: _listOfHomeProducts[index]
                                                  .image![0]
                                                  .image!,
                                              fit: BoxFit.contain,
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
                                          value: _listOfHomeProducts[index]
                                                      .selectedVariant ==
                                                  null
                                              ? _listOfHomeProducts[index]
                                                  .varient![0]
                                              : _listOfHomeProducts[index]
                                                  .selectedVariant,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _listOfHomeProducts[index]
                                                  .selectedVariant = newValue;
                                            });
                                          },
                                          items: _listOfHomeProducts[index]
                                              .varient!
                                              .map<DropdownMenuItem<Varient>>(
                                                  (Varient value) {
                                            return DropdownMenuItem<Varient>(
                                              value: value,
                                              child: Text(value.size
                                                      .toString() +
                                                  " ${value.uom} ( ₹ ${value.rate} )"),
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
                                        ),
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
                    // Container(
                    //   color: Colors.white,
                    //   child: GridView.builder(
                    //     padding: EdgeInsets.all(4),
                    //     physics: BouncingScrollPhysics(),
                    //     shrinkWrap: true,
                    //     itemCount: _listOfCategories.length,
                    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //         crossAxisSpacing: 4,
                    //         crossAxisCount: 3,
                    //         mainAxisSpacing: 0.00,
                    //         childAspectRatio: 150 / 150),
                    //     itemBuilder: (BuildContext context, int index) {
                    //       return InkWell(
                    //         onTap: () {
                    //           pushToNewRoute(context,
                    //               BrowseProductsUI(_listOfCategories[index]));
                    //         },
                    //         child: Container(
                    //           height: 120,
                    //           width: 150,
                    //           child: Column(
                    //             children: [
                    //               Card(
                    //                 margin: EdgeInsets.zero,
                    //                 elevation: 0.4,
                    //                 child: Column(
                    //                   children: [
                    //                     Container(
                    //                         height: 90,
                    //                         width: 150,
                    //                         child: ClipRRect(
                    //                             child: _listOfCategories[index]
                    //                                 .image ==
                    //                                 "https://patanjali.einixinfotech.com/storage/category/"
                    //                                 ? Image.asset(
                    //                               imagePath +
                    //                                   "brand_logo.png",
                    //                               fit: BoxFit.fill,
                    //                             )
                    //                                 : ClipRRect(
                    //                                 child: FadeInImage
                    //                                     .assetNetwork(
                    //                                   image: _listOfCategories[
                    //                                   index]
                    //                                       .image!,
                    //                                   fit: BoxFit.fill,
                    //                                   placeholder: imagePath +
                    //                                       "brand_logo.png",
                    //                                 )))),
                    //                     Container(
                    //                       padding: EdgeInsets.all(2),
                    //                       alignment: Alignment.center,
                    //                       height: 30,
                    //                       child: Text(
                    //                         _listOfCategories[index].name!,
                    //                         maxLines: 2,
                    //                         textAlign: TextAlign.center,
                    //                         overflow: TextOverflow.ellipsis,
                    //                         style: TextStyle(
                    //                             fontFamily: 'Poppins',
                    //                             fontSize: 12,
                    //                             letterSpacing: 0.6,
                    //                             color: Colors.black,
                    //                             fontWeight: FontWeight.w500),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    getCarouselImages();
    getHomeProducts();
    getHomeCategories();
  }

  void getCarouselImages() {
    Map<String, String> formData = {"vendorid": "1"};
    setState(() {
      _isCarouselLoading = true;

      getCarouselImagesApi(formData).then((value) {
        print(value.request);
        print(value.statusCode);
        setState(() {
          _isCarouselLoading = false;
          var responseData = jsonDecode(value.body);
          if (responseData[Common.successKey]) {
            Carousel.CarouselResponse response =
                Carousel.CarouselResponse.fromJson(jsonDecode(value.body));
            _listOfCarouselImages = response.data!;
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            showSnackBar(context, "Server error please try again later", 1500);
          } else {
            showSnackBar(context, responseData[Common.responseKey], 1500);
          }
        });
      }).catchError((onError) {
        setState(() {
          _isCarouselLoading = false;
          print("getCarouselImagesApiError: $onError");
        });
      });
    });
  }

  void _pushToSearchResults(String searchQuery) {
    pushToNewRoute(context, SearchResultsUI(searchQuery));
  }

  Future<void> _changeQuantity(CartModel itemCart, bool isIncrement, int index,
      ProductsData item) async {
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

  Widget addOrChangeQuantity(
      ProductsData item, int index, List<CartModel> value) {
    if (value.isNotEmpty) {
      CartModel? currentItemCart = null;
      for (CartModel currentCartItem in value) {
        if (item.selectedVariant != null &&
            int.parse(item.selectedVariant!.id.toString()) ==
                int.parse(currentCartItem.productId.toString())) {
          item.hasInCart = true;
          // i = true;
          currentItemCart = currentCartItem;
          print(
              "selected varient is  for testing ${item.varient![varientIndex].name} found in cart");
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
    } else {
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

  Future<void> addProductToCart(ProductsData selectedProduct) async {
    setState(() {
      selectedProduct.hasInCart = true;
    });
    if (selectedProduct.selectedVariant == null) {
      selectedProduct.selectedVariant = selectedProduct.varient![0];
    }
    print(
        "addProductToCartFromHomeScreen ${selectedProduct.id.toString() + "selectedProductID"}");
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
            selectedProduct.image![0].image);
      } else {
        print("iam here ");
        item = CartModel(selectedProduct.id.toString(), 1, selectedProduct.rate,
            selectedProduct.name, selectedProduct.image![0]);
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

  Future<void> getHomeProducts() async {
    sharedPreferences = await SharedPreferences.getInstance();
    getHomeProductsApi().then((value) {
      if (value.statusCode == 200) {
        GetHomeProductsResponse response =
            GetHomeProductsResponse.fromJson(jsonDecode(value.body));
        setState(() {
          _listOfHomeProducts = response.data!;
        });
      } else {
        print(value.statusCode);
      }
    });
  }

  bool isCategoriesLoading = false;
  void getHomeCategories() {
    setState(() {
      isCategoriesLoading = true;
    });
    getHomeCategoriesApi().then((value) {
      setState(() {
        isCategoriesLoading = false;
      });
      if (value.statusCode == 200) {
        HomeCategoriesResponse response =
            HomeCategoriesResponse.fromJson(jsonDecode(value.body));
        setState(() {
          _listOfCategories = response.data!;
        });
      } else {
        print(value.statusCode);
      }
    });
  }
}
