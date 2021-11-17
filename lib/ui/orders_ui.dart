import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hilton_masale/common/common.dart';
import 'package:hilton_masale/components/empty_screen.dart';
import 'package:hilton_masale/components/my_order_item.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/network/api.dart';
import 'package:hilton_masale/response/order_response.dart';
import 'package:hilton_masale/ui/home_screen_ui.dart';

class OrdersUI extends StatefulWidget {
  @override
  _OrdersUIState createState() => _OrdersUIState();
}

class _OrdersUIState extends State<OrdersUI> {
  bool _isLoading = false;
  List<Data> _listOfUserOrders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
        automaticallyImplyLeading: false,
        leading: InkWell(
            // onTap: () => pushToNewRoute(context, HomeScreeUI()),
          onTap: ()=>Navigator.pop(context),
            child: Icon(Icons.arrow_back)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _listOfUserOrders.isEmpty
              ? EmptyScreenUI("You have no orders!", true)
              : MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        Visibility(
                          visible: false,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    alignment: Alignment.center,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.sort,
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "sort".toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        OrderItems(_listOfUserOrders),
                      ],
                    ),
                  ),
                ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getListOfUserOrders();
  }

  void _getListOfUserOrders() {
    setState(() {
      _isLoading = true;

      getListOfUsersOrdersApi().then((value) {
        var responseData = jsonDecode(value.body);
        print(responseData);
        setState(() {
          _isLoading = false;
          if (value.statusCode == 200) {
            OrdersResponse response =
                OrdersResponse.fromJson(jsonDecode(value.body));
            _listOfUserOrders = response.data!;
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            showSnackBar(context, "Can't get your orders: server error", 1500);
          } else if (value.statusCode == 401) {
            showSnackBar(context, "Session expired, please login again", 2000);
            Future.delayed(Duration(milliseconds: 2000), () {
              logout(context);
            });
          } else {
            showSnackBar(context, responseData[Common.messageKey], 1500);
          }
        });
      }).catchError((onError) {
        setState(() {
          _isLoading = false;
          print("getListOfUsersOrdersApiError: $onError");
        });
      });
    });
  }
}
