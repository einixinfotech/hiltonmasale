import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hilton_masale/common/common.dart';
import 'package:hilton_masale/components/empty_screen.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/network/api.dart';
import 'package:hilton_masale/response/redeem_history_response.dart';

class ReferAndEarnUI extends StatefulWidget {
  const ReferAndEarnUI({Key? key}) : super(key: key);

  @override
  _ReferAndEarnUIState createState() => _ReferAndEarnUIState();
}

class _ReferAndEarnUIState extends State<ReferAndEarnUI> with TickerProviderStateMixin{

  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Redeem Coupon"),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "Redeem",),
              Tab(text: "History",),
            ],
          ),
        ),

        body: TabBarView(
          controller: _tabController,
          children: [
            RedeemTab(),
            HistoryTab()
          ],
        )
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

}


class RedeemTab extends StatefulWidget {
  RedeemTab({Key? key}) : super(key: key);

  @override
  _RedeemTabState createState() => _RedeemTabState();
}

class _RedeemTabState extends State<RedeemTab> {
  bool _isLoading = false;
  TextEditingController _redeemCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Image.asset("assets/images/refer.png"),
                SizedBox(height: 40),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Total Earned: ₹187",
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r"[A-Z0-9]+")
                    ),
                  ],
                  validator: MultiValidator([
                    RequiredValidator(
                        errorText: 'Please enter a redeem code')
                  ]),
                  controller: _redeemCodeController,
                  cursorColor: Colors.black,
                  textCapitalization: TextCapitalization.characters,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter a redeem code",
                    contentPadding: EdgeInsets.only(left: 8),
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    //prefixIcon: Icon(Icons.text_rotate_up),
                    enabled: true,
                    //prefix: Image.asset("assets/images/rupee.png",width: _size.width/18,height: _size.width/18,color: Colors.grey,)
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _isLoading ? Center(child: CircularProgressIndicator()) :
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        applyRedeemCoupon();
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Color(0xffc22f10))),
                    child: Text('Validate',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: _size.width / 20,
                            letterSpacing: 0.3)),
                  ),
                ),
                // SizedBox(
                //   height: 20,
                // ),
                // Align(
                //   alignment: Alignment.center,
                //   child: Text(
                //     "Share your referral link using: ",
                //     textAlign: TextAlign.justify,
                //     style: TextStyle(
                //         color: Color(0xff333333),
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold),
                //   ),
                // ),
                // SizedBox(
                //   height: 24,
                // ),
                // Row(
                //   children: [
                //     Expanded(
                //       flex: 1,
                //       child: Column(
                //         mainAxisSize: MainAxisSize.min,
                //         children: <Widget>[
                //           IconButton(
                //               onPressed: () {},
                //               icon: Image.asset(
                //                 "assets/images/whatsapp.png",
                //                 width: 32,
                //                 height: 32,
                //               )),
                //           Text("WhatsApp",
                //               style: TextStyle(fontSize: 12)),
                //         ],
                //       ),
                //     ),
                //     SizedBox(
                //       width: 32,
                //     ),
                //     Expanded(
                //       flex: 1,
                //       child: Column(
                //         mainAxisSize: MainAxisSize.min,
                //         children: <Widget>[
                //           IconButton(
                //               onPressed: () {},
                //               icon: Image.asset(
                //                 "assets/images/facebook.png",
                //                 width: 32,
                //                 height: 32,
                //               )),
                //           Text(
                //             "Facebook",
                //             style: TextStyle(fontSize: 12),
                //             textAlign: TextAlign.center,
                //           ),
                //         ],
                //       ),
                //     ),
                //     SizedBox(
                //       width: 28,
                //     ),
                //     Expanded(
                //       flex: 1,
                //       child: Column(
                //         mainAxisSize: MainAxisSize.min,
                //         children: <Widget>[
                //           IconButton(
                //               onPressed: () {},
                //               icon: Image.asset(
                //                 "assets/images/instagram.png",
                //                 width: 32,
                //                 height: 32,
                //               )),
                //           Text(
                //             "Instagram",
                //             style: TextStyle(fontSize: 12),
                //             textAlign: TextAlign.center,
                //           ),
                //         ],
                //       ),
                //     ),
                //     SizedBox(
                //       width: 28,
                //     ),
                //     Expanded(
                //       flex: 1,
                //       child: Column(
                //         mainAxisSize: MainAxisSize.min,
                //         children: <Widget>[
                //           IconButton(
                //               onPressed: () {},
                //               icon: Image.asset(
                //                 "assets/images/more.png",
                //                 width: 32,
                //                 height: 32,
                //               )),
                //           Text(
                //             "More",
                //             style: TextStyle(fontSize: 12),
                //             textAlign: TextAlign.center,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
            ),
            ),
      ],),
    );
  }

  applyRedeemCoupon(){
    Map<String, dynamic> formData = {
      "code": _redeemCodeController.text.trim(),
    };
    setState(() {
      _isLoading = true;
    });
    applyRedeem(formData).then((value){
      var responseData = jsonDecode(value.body);
      if (value.statusCode == 200) {
        showSnackBar(context, "Redeem coupon applied successfully", 1500);
      } else if (value.statusCode >= 500 && value.statusCode <= 599) {
        showSnackBar(context, "server error", 1500);
      } else if (value.statusCode == 401) {
        showSnackBar(context, "Session expired, please login again", 2000);
        Future.delayed(Duration(milliseconds: 2000), () {
          logout(context);
        });
      } else {
        print(responseData[Common.messageKey]);
        showSnackBar(context, responseData[Common.messageKey], 1500);
      }
      setState(() {
        _isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        print("getListOfCitiesFromCountry: $onError");
        _isLoading = false;
      });
    });
  }
}

class HistoryTab extends StatefulWidget {
  const HistoryTab({Key? key}) : super(key: key);

  @override
  _HistoryTabState createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {

  @override
  void initState() {
    super.initState();
    getRedeemHistoryData();
  }

  bool isLoading = false;
  RedeemHistoryResponse response = RedeemHistoryResponse();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? Center(child: CircularProgressIndicator()) :
          (response.data?.length??0) > 0 ?
      ListView.builder(
        shrinkWrap: true,
        itemCount: response.data?.length??0,
          itemBuilder: (context,index){
            return Container(
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
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Text(
                  //     "OrderId: #${response.data[index].!}",
                  //     style: Theme.of(context).textTheme.subtitle,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Date: ${response.data?[index].createdAt??""}",
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Coupon: ${response.data?[index].coupon??""}",
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Coupon Type: ${response.data?[index].type??""}",
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Remark: ${response.data?[index].remark??""}",
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Amount: " +
                          "₹" +
                          response.data![index].amount.toString(),
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            );
          }):EmptyScreenUI("No History!", false),
    );
  }

  Widget tiles({required String heading,required String value}){
    return Row(children: [
      Text(heading),
      Text(value),
    ]);
  }

  getRedeemHistoryData(){
    setState(() {
      isLoading = true;
    });
    getRedeemHistory().then((value) {
      var responseData = jsonDecode(value.body);
      if (value.statusCode == 200) {
        response = RedeemHistoryResponse.fromJson(jsonDecode(value.body));
      } else if (value.statusCode >= 500 && value.statusCode <= 599) {
        showSnackBar(context, "Can't get list of states: server error", 1500);
      } else if (value.statusCode == 401) {
        showSnackBar(context, "Session expired, please login again", 2000);
        Future.delayed(Duration(milliseconds: 2000), () {
          logout(context);
        });
      } else {
        print(responseData[Common.messageKey]);
        showSnackBar(context, responseData[Common.messageKey], 1500);
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        print("getListOfCitiesFromCountry: $onError");
        isLoading = false;
      });
    });
  }
}