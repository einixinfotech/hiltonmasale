import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hilton_masale/common/common.dart';
import 'package:hilton_masale/components/empty_screen.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/helpers/style.dart';
import 'package:hilton_masale/network/api.dart';
import 'package:hilton_masale/response/user_address_response.dart';

import 'add_address_ui.dart';

class AddressUI extends StatefulWidget {
  bool isSelectingAddress = false;
  String title = "Saved Address";

  AddressUI(this.isSelectingAddress, this.title);

  @override
  _AddressUIState createState() => _AddressUIState();
}

class _AddressUIState extends State<AddressUI> {
  bool _isLoading = false;
  List<Data> _listOfUserAddresses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title.toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              fontFamily: 'OpenSans'),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshListOfAddress,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        side:
                            BorderSide(color: Colors.green.shade200, width: 1),
                      ),
                      color: Color(0xffF1F8E9),
                      onPressed: () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AddAddressUI(false, null)));
                        print("welcomeBack");
                        if (result != null && result) {
                          showSnackBar(context, "Success", 1500);
                          _getListOfUserAddresses();
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.green,
                            size: 20,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "add address".toUpperCase(),
                            style: TextStyle(color: Colors.green, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _isLoading ? Center(child: CircularProgressIndicator())
                : _listOfUserAddresses.length > 0 ? ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: _listOfUserAddresses.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (widget.isSelectingAddress) {
                            setState(() {
                              if (Common.selectedAddressId == "") {
                                Common.selectedAddressId =
                                    _listOfUserAddresses[index]
                                        .id
                                        .toString();
                                Common.selectedAddress =
                                _listOfUserAddresses[index]
                                    .address!;
                              } else {
                                Common.selectedAddressId = "";
                              }
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              color: widget.isSelectingAddress
                                  ? Common.selectedAddressId ==
                                  _listOfUserAddresses[index]
                                      .id
                                      .toString()
                                  ? Colors.blue
                                  : Colors.white
                                  : Colors.white,
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _listOfUserAddresses[index]
                                                .name! +
                                                " (${_listOfUserAddresses[index].addresstype})",
                                            style: TextStyle(
                                                color: widget
                                                    .isSelectingAddress
                                                    ? Common.selectedAddressId ==
                                                    _listOfUserAddresses[
                                                    index]
                                                        .id
                                                        .toString()
                                                    ? Colors.white
                                                    : Colors.black
                                                    : Colors.black,
                                                fontWeight:
                                                FontWeight.w600,
                                                fontSize: 14,
                                                fontFamily: 'OpenSans'),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            "${_listOfUserAddresses[index].address! + ", " + _listOfUserAddresses[index].cityName! + ", " + _listOfUserAddresses[index].stateName! + " " + _listOfUserAddresses[index].pincode!}",
                                            style: TextStyle(
                                              color: widget
                                                  .isSelectingAddress
                                                  ? Common.selectedAddressId ==
                                                  _listOfUserAddresses[
                                                  index]
                                                      .id
                                                      .toString()
                                                  ? Colors.white
                                                  : grey
                                                  : Colors.grey,
                                              fontWeight:
                                              FontWeight.w400,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            _listOfUserAddresses[index]
                                                .mobile!,
                                            style: TextStyle(
                                                color: widget
                                                    .isSelectingAddress
                                                    ? Common.selectedAddressId ==
                                                    _listOfUserAddresses[
                                                    index]
                                                        .id
                                                        .toString()
                                                    ? Colors.white
                                                    : grey
                                                    : grey,
                                                fontWeight:
                                                FontWeight.w600,
                                                fontSize: 12,
                                                fontFamily: 'OpenSans'),
                                          ),
                                        ],
                                      )),
                                  TextButton(
                                    onPressed: () async {
                                      var result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => AddAddressUI(
                                                  true,
                                                  _listOfUserAddresses[
                                                  index])));
                                      if (result!) {
                                        _getListOfUserAddresses();
                                      }
                                    },
                                    child: Text(
                                      "Edit".toUpperCase(),
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: widget.isSelectingAddress
                                            ? Common.selectedAddressId ==
                                            _listOfUserAddresses[
                                            index]
                                                .id
                                                .toString()
                                            ? Colors.black
                                            : Colors.red
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _showConfirmationDialog(
                                          _listOfUserAddresses[index]
                                              .id!);
                                    },
                                    child: Text(
                                      "Delete".toUpperCase(),
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: widget.isSelectingAddress
                                            ? Common.selectedAddressId ==
                                            _listOfUserAddresses[
                                            index]
                                                .id
                                                .toString()
                                            ? Colors.black
                                            : Colors.red
                                            : Colors.red,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      );
                    }) : EmptyScreenUI("Your address list is empty", false)
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: Common.selectedAddressId != "" && widget.isSelectingAddress,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 45,
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              color: btnColor,
              child: Text(
                "Deliver here".toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getListOfUserAddresses();
    print(widget.isSelectingAddress);
  }

  void _getListOfUserAddresses() {
    setState(() {
      _isLoading = true;
      print("usertokenis ${Common.userToken}");
      getUserAddressesApi().then((value) {
        print("_getListOfUserAddresses ${value.body}");
        var responseData = jsonDecode(value.body);
        setState(() {
          _isLoading = false;
          if (value.statusCode == 200) {
            UserAddressResponse response =
                UserAddressResponse.fromJson(jsonDecode(value.body));
            _listOfUserAddresses = response.data!;
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            showSnackBar(
                context, "Can't get saved addresses: server error", 1500);
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
          print("getUserAddressesApiError: $onError");
        });
      });
    });
  }

  Future<void> _refreshListOfAddress() async {
    _getListOfUserAddresses();
  }

  void _showConfirmationDialog(int addressId) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setPopupState) {
            return AlertDialog(
              title: const Text('Are you sure?'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text("You wouldn't be able to revert this change")
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Confirm delete',
                      style: TextStyle(color: Color(0xffff0303))),
                  onPressed: () {
                    _deleteAddress(addressId);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteAddress(int addressId) {
    print(addressId);
    setState(() {
      _isLoading = true;
      Map<String, String> formData = {"addressid": addressId.toString()};
      deleteAddressApi(formData).then((value) {
        setState(() {
          var responseData = jsonDecode(value.body);
          _isLoading = false;

          if (value.statusCode == 200) {
            Common.selectedAddress = "";
            Common.selectedAddressId = "";
            _listOfUserAddresses.clear();
            _getListOfUserAddresses();
            showSnackBar(context, "Success", 1500);
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            Navigator.pop(context);
            showSnackBar(context, responseData[Common.messageKey], 1500);
            showSnackBar(context, "Server error please try again later", 1500);
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
          print("deleteAddressApiError: $onError");
          _isLoading = false;
        });
      });
    });
  }
}
