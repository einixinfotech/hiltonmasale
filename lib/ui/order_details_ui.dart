import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hilton_masale/common/common.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/network/api.dart';
import 'package:hilton_masale/response/get_order_details_response.dart';

class OrderDetailsUI extends StatefulWidget {
  late String id;
  late String orderId;

  OrderDetailsUI(this.id, this.orderId);

  @override
  _OrderDetailsUIState createState() => _OrderDetailsUIState();
}

class _OrderDetailsUIState extends State<OrderDetailsUI> {
  List<Response> _listOfItemsInTheOrder = [];
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details of order ID: ${widget.id}"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: _listOfItemsInTheOrder.length,
                    itemBuilder:
                        (BuildContext contextListViewBuilder, int index) {
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 4),
                                  child: Text(
                                    "Name",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Text(
                                  _listOfItemsInTheOrder[index].name!,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4, bottom: 4),
                                      child: Text(
                                        "Quantity",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _listOfItemsInTheOrder[index].quantity!,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 4),
                                  child: Text(
                                    "Price",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Text(
                                  _listOfItemsInTheOrder[index]
                                      .totalrate
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ),
    );
  }

  @override
  void initState() {
    super.initState();

    getOrderDetails();
  }

  void getOrderDetails() {
    Map<String, String> formData = {"orderid": widget.id};
    print(formData);

    setState(() {
      _isLoading = true;
      getOrderDetailsApi(formData).then((value) {
        setState(() {
          _isLoading = false;
          var responseData = jsonDecode(value.body);
          print(responseData[Common.successKey]);
          if (responseData[Common.successKey]) {
            GetOrderDetailsResponse response =
                GetOrderDetailsResponse.fromJson(jsonDecode(value.body));
            _listOfItemsInTheOrder = response.response!;
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            showSnackBar(context, "Server error please try again later", 1500);
          } else {
            showSnackBar(context, responseData[Common.responseKey], 1500);
          }
        });
      }).catchError((onError) {
        setState(() {
          _isLoading = false;
          print("getOrderDetailsApiError: $onError");
        });
      });
    });
  }
}
