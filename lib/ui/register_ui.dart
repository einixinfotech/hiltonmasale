import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hilton_masale/helpers/helper_functions.dart';
import 'package:hilton_masale/network/api.dart';
import 'package:hilton_masale/res/strings/strings.dart';
import 'package:hilton_masale/res/values/colors.dart';
import 'package:hilton_masale/ui/verify_otp_ui.dart';

class RegisterUI extends StatefulWidget {
  const RegisterUI({Key? key}) : super(key: key);

  @override
  _RegisterUIState createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  bool _isPasswordSecure = true, _isConfirmPasswordSecure = true;
  List<String> _listOfUserTypes = [
        'Select a User Type',
        'User',
        'Wholesaler',
        'Distributor'
      ],
      _listOfGenders = ['Specify Your Gender', 'Male', 'Female', 'Others'],
      _listOfStates = ['Select State', 'Haryana', 'Delhi', 'Chandigarh'],
      _listOfCities = ['Select a City', 'Sirsa', 'Faridabad', 'Gurugram'];
  String _userTypeDropDownValue = 'Select a User Type',
      _genderTypeDropDownValue = 'Specify Your Gender',
      _stateDropDownValue = 'Select State',
      _cityDropDownValue = 'Select a City';
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _fssaiIdController = TextEditingController();
  TextEditingController _gstNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _pinCodeController = TextEditingController();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _firmNameController = TextEditingController();
  TextEditingController _sponsorController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        var formate1 = "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
        _confirmPasswordController.text = formate1.toString();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _userTypeDropDownValue,
                  onChanged: (newValue) {
                    setState(() {
                      _userTypeDropDownValue = newValue!;
                    });
                  },
                  items: _listOfUserTypes
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _genderTypeDropDownValue,
                  onChanged: (newValue) {
                    setState(() {
                      _genderTypeDropDownValue = newValue!;
                    });
                  },
                  items: _listOfGenders
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _nameController,
                  validator: MultiValidator(
                      [RequiredValidator(errorText: 'Please provide a name')]),
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                      labelText: "Name",
                      counterText: "",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 5.0),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: MultiValidator([
                    EmailValidator(errorText: "Please provide an email"),
                    RequiredValidator(
                        errorText: 'Please provide an Email-Address')
                  ]),
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                      labelText: "Email-address",
                      counterText: "",
                      prefixIcon: Icon(Icons.email_rounded),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 5.0),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: _mobileController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 10,
                  maxLines: 1,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Please provide a mobile number')
                  ]),
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                      labelText: "Mobile",
                      counterText: "",
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 5.0),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _sponsorController,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                      labelText: "Sponsor",
                      counterText: "",
                      prefixIcon: Icon(Icons.info_outline),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 5.0),
                      ),
                  ),
                ),
              ),
              /*Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLength: 16,
                  obscureText: _isPasswordSecure,
                  style: TextStyle(fontSize: 16),
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Please provide a password'),
                    LengthRangeValidator(
                        min: 8,
                        max: 16,
                        errorText:
                            'Your password must have at least 8 characters'),
                  ]),
                  keyboardType: TextInputType.visiblePassword,
                  controller: _currentPasswordController,
                  decoration: InputDecoration(
                      labelText: "Password",
                      counterText: "",
                      suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordSecure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: _isPasswordSecure
                                ? Color(0xff949494)
                                : primaryColor,
                          ),
                          onPressed: () {
                            print("CLICK");
                            setState(() {
                              if (_isPasswordSecure) {
                                _isPasswordSecure = false;
                              } else {
                                _isPasswordSecure = true;
                              }
                            });
                          }),
                      prefixIcon: Icon(Icons.lock_open_outlined),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5.0),
                      )),
                ),
              ),*/
              InkWell(
                onTap: (){
                  _selectDate(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IgnorePointer(
                    child: TextFormField(
                        maxLength: 16,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _confirmPasswordController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Please provide a date')
                        ]),
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: 'Date',
                          prefixIcon: Icon(
                            Icons.date_range,
                            size: 24,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 5.0),
                          ),
                        )),
                  ),
                ),
              ),
              Visibility(
                visible: _userTypeDropDownValue != "User",
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _firmNameController,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'Please provide a firm name')
                        ]),
                        style: Theme.of(context).textTheme.bodyText2,
                        decoration: InputDecoration(
                            labelText: "Firm Name",
                            counterText: "",
                            prefixIcon: Icon(Icons.work),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColor, width: 5.0),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLength: 14,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: _fssaiIdController,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'Please provide FSSAI Number'),
                        ]),
                        style: Theme.of(context).textTheme.bodyText2,
                        decoration: InputDecoration(
                            labelText: "FSSAI Number",
                            counterText: "",
                            prefixIcon: Icon(Icons.dialpad_rounded),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColor, width: 5.0),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _gstNumberController,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'Please provide GST Number')
                        ]),
                        style: Theme.of(context).textTheme.bodyText2,
                        decoration: InputDecoration(
                            labelText: "GST Number",
                            counterText: "",
                            prefixIcon: Icon(Icons.dialpad_rounded),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColor, width: 5.0),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _stateDropDownValue,
                        onChanged: (newValue) {
                          setState(() {
                            _stateDropDownValue = newValue!;
                          });
                        },
                        items: _listOfStates.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _cityDropDownValue,
                        onChanged: (newValue) {
                          setState(() {
                            _cityDropDownValue = newValue!;
                          });
                        },
                        items: _listOfCities
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _addressController,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'Please provide an Address')
                        ]),
                        style: Theme.of(context).textTheme.bodyText2,
                        decoration: InputDecoration(
                            labelText: "Firm Address",
                            counterText: "",
                            prefixIcon: Icon(Icons.location_city),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColor, width: 5.0),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _pinCodeController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'Please provide a Area Pin Code')
                        ]),
                        style: Theme.of(context).textTheme.bodyText2,
                        decoration: InputDecoration(
                            labelText: "Area Pin code",
                            counterText: "",
                            prefixIcon: Icon(Icons.location_on_rounded),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColor, width: 5.0),
                            )),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 56,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _register();
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryColor),
                  ),
                  child: Text("Register",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 0.3)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // todo _getListOfStates();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _fssaiIdController.dispose();
    _gstNumberController.dispose();
    _addressController.dispose();
    _sponsorController.dispose();
    _pinCodeController.dispose();
    _currentPasswordController.dispose();
    _confirmPasswordController.dispose();
    _firmNameController.dispose();
    super.dispose();
  }

  void _register() {
    showLoadingDialog(context);
    Map<String, String> formData = {
      "name": _nameController.text.isEmpty ? "" : _nameController.text,
      "mobile": _mobileController.text.isEmpty ? "" : _mobileController.text,
      "email": _emailController.text.isEmpty ? "" : _emailController.text,
      "dob": _confirmPasswordController.text.isEmpty ? "" : _confirmPasswordController.text,
      "sponsor": _sponsorController.text.isEmpty ? "" : _sponsorController.text,
      "type": _userTypeDropDownValue == "User"
          ? "0"
          : _userTypeDropDownValue == "Wholesaler"
              ? "1"
              : "2",
      "address": _addressController.text.isEmpty ? "" : _addressController.text,
      "gendor": _genderTypeDropDownValue,
      "firmname": _firmNameController.text.isEmpty ? "" : _firmNameController.text,
      "gstno": _gstNumberController.text.isEmpty ? "" : _gstNumberController.text,
      "fssai": _fssaiIdController.text.isEmpty ? "" :_fssaiIdController.text,
      "state": "",
      "city": "",
      "pincode": "",

    };
    print(formData);
    sendOTPApi(formData).then((value) {
      var responseData = jsonDecode(value.body);
      Navigator.pop(context);
      if (value.statusCode == 200) {
        pushToNewRoute(
            context,
            VerifyOtpUI(
                _mobileController.text,
                name: _nameController.text,
                type: _userTypeDropDownValue == "User"
                    ? "0"
                    : _userTypeDropDownValue == "Wholesaler"
                    ? "1"
                    : "2",
                address: _addressController.text,
                gender: _genderTypeDropDownValue,
                firmname: _firmNameController.text,
                gstno: _gstNumberController.text,
                fssai: _fssaiIdController.text,
                isRegistering: true,
                state: _stateDropDownValue.toString(),
                email: _emailController.text,
                password: _confirmPasswordController.text,
                pincode: _pinCodeController.text,
                sponsor: _sponsorController.text,
                city: _cityDropDownValue.toString()));
      } else if (value.statusCode >= 500 && value.statusCode <= 599) {
        showSnackBar(context, serverErrorMessage, 1500);
      } else {
        showSnackBar(context, responseData[messageKey], 1500);
      }
    }).catchError((onError) {
      Navigator.pop(context);
      showSnackBar(context, parsingDataErrorMessage, 1500);
      print("sendOTPApiError: $onError");
    });
  }
}
