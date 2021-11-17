import 'package:flutter/material.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/response/order_response.dart';
import 'package:hilton_masale/ui/order_detail_ui.dart';

class OrderItems extends StatefulWidget {
  List<Data> listOfUserOrders;

  OrderItems(this.listOfUserOrders);

  @override
  _OrderItemsState createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.listOfUserOrders.length,
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => pushToNewRoute(
              context, OrderDetailsUI(widget.listOfUserOrders[index].orderid!)),
          child: Container(
            margin: EdgeInsets.all(6),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 3.0,
                    offset: Offset(0, 0),
                    spreadRadius: 3.0,
                  ),
                ]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "OrderId: #${widget.listOfUserOrders[index].orderid!}",
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Date: ${widget.listOfUserOrders[index].createdAt!}",
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Order status:",
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        color: Color(int.parse(widget
                            .listOfUserOrders[index].color!
                            .toString()
                            .replaceAll('#', '0xff'))),

                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 10),
                        child: Text(
                          widget.listOfUserOrders[index].status!.toString(),
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    //   child: Text(
                    //     widget.listOfUserOrders[index].status!.toString(),
                    //     style: TextStyle(
                    //         fontFamily: 'OpenSans',
                    //         fontSize: 10,
                    //         color: Color(int.parse(widget
                    //             .listOfUserOrders[index].color!
                    //             .replaceAll('#', '0xff'))),
                    //         fontWeight: FontWeight.w500),
                    //   ),
                    // ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Total amount: " +
                        "₹" +
                        widget.listOfUserOrders[index].amount!.toString(),
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int color(String value) {
    return int.parse(value.replaceAll("#", ""));
  }
}
