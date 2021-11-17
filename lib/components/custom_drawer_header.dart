import 'package:flutter/material.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/res/strings/strings.dart';
import 'package:hilton_masale/ui/cart_ui.dart';
import 'package:hilton_masale/ui/orders_ui.dart';
import 'package:hilton_masale/ui/profile_ui.dart';
import 'package:hilton_masale/ui/wallet_ui.dart';

class CustomDrawerHeader extends StatelessWidget {
  final String userName, userEmailAddress, userMobile;

  CustomDrawerHeader(this.userName, this.userEmailAddress, this.userMobile);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.red.shade700,
      height: size.width / 2,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userName,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(userEmailAddress, style: TextStyle(color: Colors.white)),
                  Text(
                    userMobile,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.white54,
                      onTap: () => pushToNewRoute(context, WalletUI()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance_wallet_rounded,
                            color: Colors.white,
                          ),
                          Text(
                            "Wallet",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.white54,
                      onTap: () => pushToNewRoute(context, CartUI()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_rounded,
                            color: Colors.white,
                          ),
                          Text(
                            "Cart",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.white54,
                      onTap: () => pushToNewRoute(context, OrdersUI()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.list_rounded,
                            color: Colors.white,
                          ),
                          Text(
                            "Orders",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.white54,
                      onTap: () => pushToNewRoute(context, ProfileUI()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          Text(
                            "Account",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
