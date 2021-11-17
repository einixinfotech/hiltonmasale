import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hilton_masale/common/common.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/helpers/style.dart';
import 'package:hilton_masale/network/api.dart';
import 'package:hilton_masale/response/get_list_of_cities_response.dart'
    as City;
import 'package:hilton_masale/response/get_states_response.dart';
import 'package:hilton_masale/response/user_address_response.dart' as Address;

class AddAddressUI extends StatefulWidget {
  bool isEditAddress = false;
  Address.Data? selectedAddress;

  AddAddressUI(this.isEditAddress, this.selectedAddress);

  @override
  _AddAddressUIState createState() => _AddAddressUIState();
}

final formKey = GlobalKey<FormState>();

class _AddAddressUIState extends State<AddAddressUI> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _landmarkController = TextEditingController();
  TextEditingController _houseNumberOrFloorController = TextEditingController();
  TextEditingController _pinCodeController = TextEditingController();
  int _addressTypeValue = 0;
  bool _isLoading = false, _isLoadingCity = false;
  final _formKey = GlobalKey<FormState>();
  List<Data> _listOfStates = [];
  List<City.Data> _listOfCities = [];
  int _selectedState = -1, _selectedCity = -1;
  String selectedState = "", selectedCity = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditAddress
              ? "Edit Address"
              : "Add delivery Address".toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              fontFamily: 'OpenSans'),
        ),
      ),
      body: WillPopScope(
        onWillPop: _handleBackPressed,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              Form(
                  autovalidate: true,
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 16.0, right: 16.0),
                        child: TextFormField(
                          autovalidate: true,
                          controller: _nameController,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Name is required'),
                            PatternValidator(r'^[a-zA-Z]',
                                errorText: 'Please enter a valid Name')
                          ]),
                          keyboardType: TextInputType.name,
                          //focusNode: nodeOne,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black38, //this has no effect
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: "Name (Required)* ",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 16.0, right: 16.0),
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          autovalidateMode: AutovalidateMode.always,
                          controller: _mobileController,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Phone is required'),
                            MinLengthValidator(10,
                                errorText: 'Phone must be 10 digits long'),
                          ]),
                          maxLength: 10,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black38,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: "Phone number (Required)*",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 16.0, right: 16.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          controller: _addressController,
                          textInputAction: TextInputAction.next,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Required*'),
                            /*PatternValidator(r'^[a-zA-Z]',
                                errorText: 'Please enter a valid Name')*/
                          ]),
                          keyboardType: TextInputType.streetAddress,
                          //focusNode: nodeOne,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black38, //this has no effect
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: "Complete Address",
                          ),
                        ),
                      ),
                      _isLoading
                          ? Center(
                              child: SizedBox(
                                  height: 32,
                                  width: 32,
                                  child: CircularProgressIndicator()),
                            )
                          : InkWell(
                              onTap: () {
                                _showListOfStates();
                              },
                              child: TextFormField(
                                enabled: false,
                                maxLength: 6,
                                keyboardType: TextInputType.phone,
                                style: Theme.of(context).textTheme.body1,
                                decoration: InputDecoration(
                                  labelText: _selectedState == -1
                                      ? "State"
                                      : selectedState,
                                  counterText: "",
                                  prefixIcon: Icon(Icons.location_city),
                                ),
                              ),
                            ),
                      _isLoadingCity
                          ? Center(
                              child: SizedBox(
                                  height: 32,
                                  width: 32,
                                  child: CircularProgressIndicator()),
                            )
                          : InkWell(
                              onTap: () {
                                _showCities();
                              },
                              child: TextFormField(
                                enabled: false,
                                maxLength: 6,
                                style: Theme.of(context).textTheme.body1,
                                decoration: InputDecoration(
                                  labelText: _selectedCity == -1
                                      ? "City"
                                      : selectedCity,
                                  counterText: "",
                                  prefixIcon: Icon(Icons.location_city),
                                ),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 16.0, right: 16.0),
                        child: TextFormField(
                          autovalidate: true,
                          controller: _pinCodeController,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Required*'),
                            MinLengthValidator(6,
                                errorText: "Pin Code must be at least 6 digits")
                            /*PatternValidator(r'^[a-zA-Z]',
                                errorText: 'Please enter a valid Name')*/
                          ]),
                          keyboardType: TextInputType.number,
                          //focusNode: nodeOne,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black38, //this has no effect
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: "Area Pin Code",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 16.0, right: 16.0),
                        child: TextFormField(
                          autovalidate: true,
                          controller: _landmarkController,
                          textInputAction: TextInputAction.next,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Required*'),
                            /*PatternValidator(r'^[a-zA-Z]',
                                errorText: 'Please enter a valid Name')*/
                          ]),
                          keyboardType: TextInputType.name,
                          //focusNode: nodeOne,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black38, //this has no effect
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: "Landmark",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 16.0, right: 16.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.disabled,
                          controller: _houseNumberOrFloorController,
                          textInputAction: TextInputAction.next,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Required*'),
                          ]),
                          keyboardType: TextInputType.name,
                          //focusNode: nodeOne,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black38, //this has no effect
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: "Floor/House Number ",
                          ),
                        ),
                      ),
                      /*  Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16.0, left: 16.0, right: 16.0),
                                    child: TextFormField(
                                      autovalidate: true,
                                      controller: cityController,
                                      textInputAction: TextInputAction.next,
                                      validator: MultiValidator([
                                        RequiredValidator(errorText: 'required'),
                                        PatternValidator(r'^[a-zA-Z]',
                                            errorText:
                                                'Please enter a valid City name')
                                      ]),
                                      keyboardType: TextInputType.name,
                                      //focusNode: nodeOne,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors
                                                .black38, //this has no effect
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        labelText: "City (Required)* ",
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16.0, right: 16.0),
                                    child: TextFormField(
                                      autovalidate: true,
                                      textInputAction: TextInputAction.next,
                                      controller: pinCodeController,
                                      validator: MultiValidator([
                                        RequiredValidator(
                                            errorText: 'Pin code is required'),
                                        MinLengthValidator(6,
                                            errorText:
                                                'Pin code must be 6 digits long'),
                                      ]),
                                      maxLength: 6,
                                      keyboardType: TextInputType.number,
                                      //focusNode: nodeOne,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors
                                                .black38, //this has no effect
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        labelText: "Pincode * ",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),*/
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Text(
                          "Type of address",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              fontFamily: 'OpenSans'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: ChoiceChip(
                                label: Text("Home"),
                                selected: _addressTypeValue == 0,
                                selectedColor: Colors.green,
                                onSelected: (bool value) {
                                  setState(() {
                                    _addressTypeValue =
                                        _addressTypeValue == 0 ? 1 : 0;
                                  });
                                },
                                backgroundColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: ChoiceChip(
                                label: Text("Work"),
                                selected: _addressTypeValue == 1,
                                selectedColor: Colors.green,
                                onSelected: (bool value) {
                                  setState(() {
                                    _addressTypeValue =
                                        _addressTypeValue == 0 ? 1 : 0;
                                  });
                                },
                                backgroundColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 45,
          width: MediaQuery.of(context).size.width,
          child: FlatButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (_selectedState == -1) {
                  showSnackBar(context, "Please select your state", 1500);
                } else if (_selectedCity == -1) {
                  showSnackBar(context, "Please select your city", 1500);
                } else {
                  if (widget.isEditAddress) {
                    _updateAddress();
                  } else {
                    _addAddress();
                  }
                }
              }
            },
            color: btnColor,
            child: Text(
              widget.isEditAddress
                  ? "Update".toUpperCase()
                  : "Save".toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void _addAddress() {
    Map<String, String> formData = {
      "latitude": "0.00",
      "longitude": "0.00",
      "name": _nameController.text,
      "mobile": _mobileController.text,
      "floor": _houseNumberOrFloorController.text,
      "address": _addressController.text,
      "landmark": _landmarkController.text,
      "addresstype": _addressTypeValue == 0 ? "Home" : "Work",
      "state": _selectedState.toString(),
      "city": _selectedCity.toString(),
      "pincode": _pinCodeController.text
    };

    showLoadingDialog(context);
    print(formData);
    addUserAddressApi(formData).then((value) {
      var responseData = jsonDecode(value.body);
      Navigator.pop(context);
      _isLoading = false;
      if (value.statusCode == 200) {
        Navigator.pop(context, true);
      } else if (value.statusCode >= 500 && value.statusCode <= 599) {
        showSnackBar(context, "Can't add address: server error", 1500);
      } else if (value.statusCode == 401) {
        showSnackBar(context, "Session expired, please login again", 2000);
        Future.delayed(Duration(milliseconds: 2000), () {
          logout(context);
        });
      } else {
        showSnackBar(context, responseData[Common.messageKey], 1500);
      }
    }).catchError((onError) {
      Navigator.pop(context);
      print("addUserAddressApiError: $onError");
    });
  }

  @override
  void initState() {
    super.initState();
    _getListOfStates();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    _houseNumberOrFloorController.dispose();
  }

  void _getListOfStates() {
    setState(() {
      _isLoading = true;
      getListOfStatesApi().then((value) {
        setState(() {
          print("state response is ${value.body}");
          var responseData = jsonDecode(value.body);
          _isLoading = false;
          if (value.statusCode == 200) {
            GetStatesResponse response =
                GetStatesResponse.fromJson(jsonDecode(value.body));
            _listOfStates = response.data!;
            if (widget.isEditAddress && widget.selectedAddress != null) {
              _setData();
            }
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            showSnackBar(
                context, "Can't get list of states: server error", 1500);
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
          print("getListOfStatesFromCountry: $onError");
          _isLoading = false;
        });
      });
    });
  }

  void _showListOfStates() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setPopupState) {
            return AlertDialog(
              title: Text("Select your state",
                  style: TextStyle(color: Colors.black87, fontSize: 18)),
              content: Container(
                width: double.maxFinite,
                child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _listOfStates.length,
                    itemBuilder: (BuildContext contextListView, int index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            print(_listOfStates[index].name);
                            _selectedState = _listOfStates[index].id!;
                            selectedState = _listOfStates[index].name!;
                            _getListOfCities(_selectedState);
                            Navigator.pop(context);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Ink(
                            width: double.maxFinite,
                            height: 32,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(_listOfStates[index].name!,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18)),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            );
          },
        );
      },
    );
  }

  void _getListOfCities(int stateId) {
    Map<String, String> formData = {"stateid": stateId.toString()};
    setState(() {
      _isLoadingCity = true;
      getListOfCitiesApi(formData).then((value) {
        setState(() {
          print("list of city is ${value.body}");
          var responseData = jsonDecode(value.body);
          _isLoadingCity = false;
          if (value.statusCode == 200) {
            City.GetListOfCities response =
                City.GetListOfCities.fromJson(jsonDecode(value.body));
            _listOfCities = response.data!;
            if (_listOfCities.isNotEmpty) {
              _listOfCities.forEach((element) {
                if (element.id == int.parse(widget.selectedAddress!.city!)) {
                  print("YAYAYAYAY" + element.name!);
                  selectedCity = element.name!;
                  _selectedCity = element.id!;
                }
              });
            }
          } else if (value.statusCode >= 500 && value.statusCode <= 599) {
            showSnackBar(
                context, "Can't get list of states: server error", 1500);
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
          print("getListOfCitiesFromCountry: $onError");
          _isLoadingCity = false;
        });
      });
    });
  }

  void _showCities() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setPopupState) {
            return AlertDialog(
              title: Text("Select your City",
                  style: TextStyle(color: Colors.black87, fontSize: 18)),
              content: Container(
                width: double.maxFinite,
                child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _listOfCities.length,
                    itemBuilder: (BuildContext contextListView, int index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            print(_listOfCities[index].name);
                            _selectedCity = _listOfCities[index].id!;
                            selectedCity = _listOfCities[index].name!;
                            print(_selectedCity);
                            Navigator.pop(context);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Ink(
                            width: double.maxFinite,
                            height: 32,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(_listOfCities[index].name!,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18)),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            );
          },
        );
      },
    );
  }

  void _setData() {
    _nameController.text = widget.selectedAddress!.name!;
    _mobileController.text = widget.selectedAddress!.mobile!;
    _addressController.text = widget.selectedAddress!.address!;
    _landmarkController.text = widget.selectedAddress!.landmark!;
    _houseNumberOrFloorController.text = widget.selectedAddress!.floor!;
    _addressTypeValue = widget.selectedAddress!.addresstype == "Work" ? 1 : 0;
    if (_listOfStates.isNotEmpty) {
      _listOfStates.forEach((element) {
        if (element.id == widget.selectedAddress!.state) {
          print("YAYAYAYAY" + element.name!);
          selectedState = element.name!;
          _selectedState = element.id!;
          _getListOfCities(_selectedState);
        }
      });
    }
  }

  void _updateAddress() {
    Map<String, String> formData = {
      "latitude": "0.00",
      "longitude": "0.00",
      "name": _nameController.text,
      "mobile": _mobileController.text,
      "floor": _houseNumberOrFloorController.text,
      "address": _addressController.text,
      "landmark": _landmarkController.text,
      "addresstype": _addressTypeValue == 0 ? "Home" : "Work",
      "state": _selectedState.toString(),
      "city": _selectedCity.toString(),
      "addressid": widget.selectedAddress!.id.toString(),
      "pincode": _pinCodeController.text
    };

    showLoadingDialog(context);
    print(formData);
    updateUserAddressApi(formData).then((value) {
      print("update response is ${value.body}");
      var responseData = jsonDecode(value.body);

      Navigator.pop(context);
      _isLoading = false;
      if (value.statusCode == 200) {
        Navigator.pop(context, true);
      } else if (value.statusCode >= 500 && value.statusCode <= 599) {
        showSnackBar(context, "Can't update address: server error", 1500);
      } else if (value.statusCode == 401) {
        showSnackBar(context, "Session expired, please login again", 2000);
        Future.delayed(Duration(milliseconds: 2000), () {
          logout(context);
        });
      } else {
        showSnackBar(context, responseData[Common.messageKey], 1500);
      }
    }).catchError((onError) {
      Navigator.pop(context);
      print("updateUserAddressApiError: $onError");
    });
  }

  Future<bool> _handleBackPressed() async {
    Navigator.pop(context, false);
    return true;
  }
}
