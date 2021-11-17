import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hilton_masale/common/common.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/network/api.dart';
import 'package:hilton_masale/response/order_details_response.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsUI extends StatefulWidget {
  final String orderId;

  OrderDetailsUI(this.orderId);

  @override
  _OrderDetailsUIState createState() => _OrderDetailsUIState();
}

class _OrderDetailsUIState extends State<OrderDetailsUI> {
  bool _isLoading = true;
  late OrderDetailsResponse response;
  List<Details> _listOfItemsInTheOrder = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details of order ID: ${widget.orderId}"),
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
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 4),
                                    child: Text(
                                      "Name: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      _listOfItemsInTheOrder[index].name!,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
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
                                          "Amount: ",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "₹" +
                                            _listOfItemsInTheOrder[index]
                                                .rate
                                                .toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 4),
                            child: Text(
                              "Delivery Charges: ",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(
                            "₹" + response.data!.dlcharge.toString(),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Text(
                                  "Discount: ",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Text(
                                "₹" + response.data!.discount.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: response.data!.promocode.toString() != "",
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 4),
                                  child: Text(
                                    "Promo Code: ",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Text(
                                  response.data!.promocode.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Text(
                                  "Delivery Address: ",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  response.data!.address.toString(),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Text(
                                  "Order Status: ",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                color: Color(int.parse(response.data!.color
                                    .toString()
                                    .replaceAll('#', '0xff'))),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    response.data!.status.toString(),
                                    style: TextStyle(
                                        backgroundColor: Color(int.parse(
                                            response.data!.color
                                                .toString()
                                                .replaceAll('#', '0xff'))),
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Text(
                                  "Subtotal: ",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Text(
                                "₹" + response.data!.subtotal.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Text(
                                  "Payment Mode: ",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Text(
                                response.data!.pmode.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: response.data!.dispatchno != " ",
                        child: Column(
                          children: [
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
                                        "Dispatch Number ",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      response.data!.dispatchno.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                onPressed: () => launch(
                                    response.data!.trackinglink.toString()),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.blue)),
                                child: Text("Track the package",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        letterSpacing: 0.6,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getOrderDetails();
  }

  void _getOrderDetails() {
    Map<String, String> formData = {"orderid": widget.orderId};

    setState(() {
      _isLoading = true;
      getOrderDetailsApi(formData).then((value) {
        print("orderresponseis ${value.body}");
        setState(() {
          _isLoading = false;
          var responseData = jsonDecode(value.body);
          if (value.statusCode == 200) {
            response = OrderDetailsResponse.fromJson(jsonDecode(value.body));
            _listOfItemsInTheOrder = response.data!.details!;
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
          print("getOrderDetailsApiError: $onError");
        });
      });
    });
  }
}
