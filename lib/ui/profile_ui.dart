import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hilton_masale/common/common.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/network/api.dart';
import 'package:hilton_masale/res/values/colors.dart';
import 'package:hilton_masale/response/user_details_response.dart';
import 'package:hilton_masale/response/get_list_of_cities_response.dart' as City;
import 'package:hilton_masale/response/get_states_response.dart';

class ProfileUI extends StatefulWidget {
  @override
  _ProfileUIState createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _fssaiController = TextEditingController();
  TextEditingController _gstNoController = TextEditingController();
  TextEditingController _firmNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _referCodeController = TextEditingController();

  UserDetailsResponse _userDetailsResponse = UserDetailsResponse();

  bool _isLoadingCity = false, _isStatesLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()) :SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _nameController,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Please provide a name')
                    ]),
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                      labelText: "Name",
                      counterText: "",
                      // prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: 'Please provide a email address'),
                      EmailValidator(
                          errorText: 'Please enter a valid Email-Address'),
                    ]),
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                      labelText: "Email",
                      counterText: "",
                      // prefixIcon: Icon(Icons.mail),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _fssaiController,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                      labelText: "Fssai",
                      counterText: "",
                      // prefixIcon: Icon(Icons.mail),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _gstNoController,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                      labelText: "GST NO",
                      counterText: "",
                      // prefixIcon: Icon(Icons.mail),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _firmNameController,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                      labelText: "Firm Name",
                      counterText: "",
                      // prefixIcon: Icon(Icons.mail),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.streetAddress,
                    controller: _addressController,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                      labelText: "Address",
                      counterText: "",
                      // prefixIcon: Icon(Icons.mail),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    enabled: false,
                    keyboardType: TextInputType.name,
                    controller: _referCodeController,
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                      labelText: "Refer Code",
                      counterText: "",
                      // prefixIcon: Icon(Icons.mail),
                    ),
                  ),
                  _isStatesLoading
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
                            : selectedStateName,
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
                            : selectedCityName,
                        counterText: "",
                        prefixIcon: Icon(Icons.location_city),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 56,
                          child: TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                 updateProfile();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return primaryColor;
                                  return primaryColor; // Use the component's default.
                                },
                              ),
                            ),
                            child: Text("Save / Update",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    letterSpacing: 0.3)),
                          ),
                        ),

                  SizedBox(
                    height: 18,
                  ),
                  /*_isLoading
                            ? CircularProgressIndicator()
                            : Container(
                          height: 44,
                          width: 256,
                          child: MaterialButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  checkReferralCode();
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              color: Colors.green,
                              child: Text(
                                "Register".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    letterSpacing: 1.2,
                                    wordSpacing: 2,
                                    fontWeight: FontWeight.w800),
                              )),
                        ),*/
                  SizedBox(height: 8),
                ],
              ),
            )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    _getListOfStates();
  }

  getUserData() {
    setState(() {
      _isLoading = true;
    });
    getUserDetailsApi().then((value) {
      setState(() {
        _isLoading = false;
      });
      if (value.statusCode == 200) {
        _userDetailsResponse = UserDetailsResponse.fromJson(jsonDecode(value.body));
        _referCodeController.text = _userDetailsResponse.data?.referalcode??"";
      } else {
        print(value.statusCode);
      }
    });
  }

  void updateProfile() {
    Map<String, String> formData = {
      "name": _nameController.text,
      "email": _emailController.text,
      "fssai": _fssaiController.text.isEmpty ? "":_fssaiController.text,
      "gstno": _gstNoController.text.isEmpty ? "" : _gstNoController.text,
      "firmname": _firmNameController.text.isEmpty ? "" : _firmNameController.text,
      "address": _addressController.text.isEmpty ? "" : _addressController.text,
      "city": selectedCityName.isEmpty ? "" : selectedCityName,
      "state": selectedStateName.isEmpty ? "" : selectedStateName,
    };
    print(formData);
    setState(() {
      _isLoading = true;
      updateProfileApi(formData).then((value) {
        var responseData = jsonDecode(value.body);
        print(jsonDecode(value.body));
        setState(() {
          _isLoading = false;
          if (value.statusCode == 200) {
            showSnackBar(context, "Success!", 1500);
            Future.delayed(Duration(milliseconds: 1500), () {
              Navigator.pop(context, true);
            });
          } else if (value.statusCode == 204) {
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
          print("updateProfileApiError: $onError");
        });
      });
    });
  }


  List<Data> _listOfStates = [];
  List<City.Data> _listOfCities = [];
  int _selectedState = -1, _selectedCity = -1;
  String selectedStateName = "", selectedCityName = "";

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
                            selectedCityName = _listOfCities[index].name!;
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
                            selectedStateName = _listOfStates[index].name!;
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
            City.GetListOfCities response = City.GetListOfCities.fromJson(jsonDecode(value.body));
            _listOfCities = response.data!;
            if (_listOfCities.isNotEmpty) {
              _listOfCities.forEach((element) {
                // if (element.id == int.parse(widget.selectedAddress!.city!)) {
                //   print("YAYAYAYAY" + element.name!);
                //   selectedCity = element.name!;
                //   _selectedCity = element.id!;
                // }
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
}
