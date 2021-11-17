import 'package:flutter/material.dart';
import 'package:hilton_masale/common/common.dart';
import 'package:hilton_masale/db/cart_database.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/models/cart_model.dart';
import 'package:hilton_masale/ui/home_screen_ui.dart';
import 'package:hilton_masale/ui/orders_ui.dart';
import 'package:lottie/lottie.dart';

class ThankYouUI extends StatefulWidget {
  final title;

  ThankYouUI({this.title});

  @override
  _ThankYouUIState createState() => _ThankYouUIState();
}

class _ThankYouUIState extends State<ThankYouUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 60,
                child: IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 25,
                    ),
                    onPressed: () {
                      pushToNewRouteAndClearAll(context, HomeScreeUI());
                    })),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Thank you",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 32,
                        letterSpacing: 0.6,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Lottie.asset(
                    "assets/lottie/placed_success.json",
                    repeat: true,
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Yay!",
                  ),
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  FlatButton(
                    minWidth: 200,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.5, color: Colors.green)),
                    onPressed: () {
                      pushToNewRouteAndClearAll(context, OrdersUI());
                    },
                    child: Text(
                      "Browse more".toUpperCase(),
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          letterSpacing: 1,
                          color: Colors.green[600],
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<CartModel>> getCartItems() async {
    List<CartModel> list = [];
    await CartDatabase.instance.getListOfItemsInCart().then((value) {
      Common.cartItems.value = value;
      list = value;
      return list;
    });
    return list;
  }
}
