import 'dart:convert';
//
// import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/fhl_model.dart';
import 'package:rooster/model/fhl_models/fhl_consignee_model.dart';
import 'package:rooster/model/fhl_models/fhl_shipper_model.dart';
import 'package:rooster/string.dart';
import 'package:http/http.dart' as http;
import 'package:rooster/ui/drodowns/special_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../formatter.dart';
import '../../drodowns/airport_code.dart';
import '../../drodowns/country_code.dart';

Future<dynamic> getHouseDetails(String id) async {
  //List<String, dynamic> result;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.parse(StringData.hawblistAPI);
  final request = http.Request("GET", url);
  request.headers.addAll(<String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'x-access-tokens': prefs.getString('token')
  });
  request.body = jsonEncode({"id": id});
  var jsonData;
  var res = await request.send();
  final respStr = await res.stream.bytesToString();
  jsonData = jsonDecode(respStr);
  print("House Data ${jsonData}");
  return jsonData["hawb"];
}

class EditHouse extends StatefulWidget {
  final FHLModel fhlModel;
  final bool isView;
  final String id;

// EditHawb({Key key, this.fhlModel, this.isView}) : super(key: key);

  EditHouse({this.fhlModel, @required this.isView, this.id});

  @override
  _EditHawbState createState() => _EditHawbState();
}

class _EditHawbState extends State<EditHouse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Center(
              child: FutureBuilder(
                future: getHouseDetails(widget.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print("House Data ${snapshot.data}");
                    //getawblist=snapshot.data;
                    return UpdateHawb(
                      houseDetails: snapshot.data,
                      isView: false,
                      fhlModel: widget.fhlModel,
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      S.of(context).DataNotFound,
                      style: TextStyle(color: Theme.of(context).accentColor),
                      //"Data Not Found"
                    );
                  }

                  // By default, show a loading spinner
                  return CircularProgressIndicator();
                },
              ),
            )));
  }
}

class UpdateHawb extends StatefulWidget {
  final bool isView;
  var houseDetails;
  final FHLModel fhlModel;

  UpdateHawb({Key key, this.houseDetails, this.isView, this.fhlModel})
      : super(key: key);

  @override
  UpdateHawbState createState() => UpdateHawbState();
}

class UpdateHawbState extends State<UpdateHawb> {
  final TextEditingController RateCurrencyCode = TextEditingController();
   String flag;
  GlobalKey _editFHLHousesFormKey = new GlobalKey<FormState>();
  FHLModel _fhlModel;
  final TextEditingController edithouseOrigin = TextEditingController();
  final TextEditingController edithouseDestination = TextEditingController();
  List<Map<String, dynamic>> sippercontactList = [];
  List<Map<String, dynamic>> consigneecontactList = [];
  List<Map<String, dynamic>> specialCodeList = [];
  List<Map<String, dynamic>> hormoCodeList = [];
  final List<ShipperExpenseList> expenseList = [];
  final List<ConsigneeExpenseList> expenseL = [];
  final _ContactKey = GlobalKey<FormState>();
  final _consigneeContactkey = GlobalKey<FormState>();
  TextEditingController Consigneecontype = new TextEditingController();
  TextEditingController Consigneecontact = new TextEditingController();
  TextEditingController contype = new TextEditingController();
  TextEditingController Telecontroller = new TextEditingController();

  final TextEditingController ShipperCountryCode = TextEditingController();
  final TextEditingController ConsigneeCountryCode = TextEditingController();
  final TextEditingController CustomsCountryCode = TextEditingController();

  @override
  void initState() {
    _fhlModel = widget.fhlModel ?? new FHLModel();

    //consignee
    print(widget.houseDetails[0]["Consignee_Contact"]);
    _fhlModel.houseDetailsNumber = widget.houseDetails[0]["serialNumber"];
    _fhlModel.houseDetailsOrigin = widget.houseDetails[0]["origin"];
    _fhlModel.houseDetailsDestination = widget.houseDetails[0]["destination"];
    _fhlModel.houseDetailsNatureGoods = widget.houseDetails[0]["description"];

    _fhlModel.houseDetailsDescription = widget.houseDetails[0]["Extended_description"];

    _fhlModel.quantityDetailsPieces = widget.houseDetails[0]["pieces"].toString();

    _fhlModel.quantityDetailsWeight = widget.houseDetails[0]["weight"].toString();
    _fhlModel.quantityDetailsWeightUnit = widget.houseDetails[0]["weightCode"];
    _fhlModel.quantityDetailsSLAC = widget.houseDetails[0]["SLAC"].toString();

    _fhlModel.customsSecurityCountryCode =  widget.houseDetails[0]["CustomsSecurity"][0]
    ["countryCode"];
    this.CustomsCountryCode.text = _fhlModel.customsSecurityCountryCode;
    _fhlModel.customsSecurityInfoIdentifier =  widget.houseDetails[0]["CustomsSecurity"][0]
    ["informationIdentifier"];
    _fhlModel.customsSecurityCSRCIdentifier = widget.houseDetails[0]["CustomsSecurity"][0]
    ["csrcIdentifier"];
    _fhlModel.customsSecuritySCSRCIdentifier = widget.houseDetails[0]["CustomsSecurity"][0]
    ["scsrcInformation"];

    _fhlModel.chargeDeclarationCurrencyCode = widget.houseDetails[0]["currencyCode"];
    this.RateCurrencyCode.text = widget.houseDetails[0]["currencyCode"];
    _fhlModel.chargeDeclarationWeightValue = widget.houseDetails[0]["weightVal"];
    _fhlModel.chargeDeclarationOtherCharges = widget.houseDetails[0]["charges"];
    _fhlModel.chargeDeclarationCarriageValue = widget.houseDetails[0]["carriageValue"];
    _fhlModel.chargeDeclarationCustomsValue = widget.houseDetails[0]["customsValue"];
    _fhlModel.chargeDeclarationInsuranceValue = widget.houseDetails[0]["insuranceValue"];


    _fhlModel.shipperName = widget.houseDetails[0]["s_name"];

    _fhlModel.shipperAddress = widget.houseDetails[0]["s_address"];
    _fhlModel.shipperPlace = widget.houseDetails[0]["s_place"];
    _fhlModel.shipperCode = widget.houseDetails[0]["s_countryCode"];


    _fhlModel.shipperState = widget.houseDetails[0]["s_state"];
    _fhlModel.shipperPostCode = widget.houseDetails[0]["s_postCode"];
    _fhlModel.consigneeName = widget.houseDetails[0]["c_name"];
    _fhlModel.consigneeAddress = widget.houseDetails[0]["c_address"];
    _fhlModel.consigneePlace = widget.houseDetails[0]["c_place"];
    _fhlModel.consigneeState = widget.houseDetails[0]["c_state"];
    _fhlModel.consigneeCode = widget.houseDetails[0]["c_countryCode"];
    this.ConsigneeCountryCode.text =  _fhlModel.consigneeCode;
        _fhlModel.consigneePostCode = widget.houseDetails[0]["c_postCode"];


    consigneecontactList = new List<Map<String, dynamic>>.from(
        widget.houseDetails[0]["Consignee_Contact"]);
    consigneecontactList.forEach((element) {
      element.putIfAbsent("isSelFected", () {
        return false;
      });
    });
    print(consigneecontactList);

    //shipper
    print(widget.houseDetails[0]["Shipper_Contact"]);

    sippercontactList = new List<Map<String, dynamic>>.from(
        widget.houseDetails[0]["Shipper_Contact"]);
    sippercontactList.forEach((element) {
      element.putIfAbsent("isSelected", () {
        return false;
      });
    });
    print(sippercontactList);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.ShipperCountryCode.text=widget.houseDetails[0]["c_countryCode"];
    this.ConsigneeCountryCode.text=widget.houseDetails[0]["s_countryCode"];
    this.RateCurrencyCode.text=widget.houseDetails[0]["currencyCode"];
     this.CustomsCountryCode.text=widget.houseDetails[0]["CustomsSecurity"][0]
                    ["countryCode"];
    print(S.of(context).HouseNumber
        //"House Number"
        +
        widget.houseDetails[0]["serialNumber"]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(S.of(context).UpdateHouse
          //"Update House"
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _editFHLHousesFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ! _fhlModel.houseDetails....
                  buildHouseDetails(),

                  Divider(
                    thickness: 2,
                    indent: MediaQuery.of(context).size.width * 0.3,
                    endIndent: MediaQuery.of(context).size.width * 0.3,
                  ),

                  // ! Special Requirements....
                  buildSpecialRequirements(),

                  Divider(
                    thickness: 2,
                    indent: MediaQuery.of(context).size.width * 0.3,
                    endIndent: MediaQuery.of(context).size.width * 0.3,
                  ),

                  // ! _fhlModel.qualityDetails....
                  buildQuantityDetails(),

                  Divider(
                    thickness: 2,
                    indent: MediaQuery.of(context).size.width * 0.3,
                    endIndent: MediaQuery.of(context).size.width * 0.3,
                  ),

                  // ! Customs Security....
                  buildCustomsSecurity(),

                  Divider(
                    thickness: 2,
                    indent: MediaQuery.of(context).size.width * 0.3,
                    endIndent: MediaQuery.of(context).size.width * 0.3,
                  ),

                  // ! ChargeDeclaration....
                  buildChargeDeclaration(),

                  Divider(
                    thickness: 2,
                    indent: MediaQuery.of(context).size.width * 0.3,
                    endIndent: MediaQuery.of(context).size.width * 0.3,
                  ),

                  // ! Shipper....
                  buildShipper(),

                  Divider(
                    thickness: 2,
                    indent: MediaQuery.of(context).size.width * 0.3,
                    endIndent: MediaQuery.of(context).size.width * 0.3,
                  ),

                  // ! Consignee....
                  buildConsignee(),

                  Divider(
                    thickness: 2,
                    indent: MediaQuery.of(context).size.width * 0.3,
                    endIndent: MediaQuery.of(context).size.width * 0.3,
                  ),

                  buildDialogButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDialogButtons(BuildContext context) {
    return !widget.isView
        ? Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 15, right: 8),
            child: TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor)),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: Text(
                S.of(context).Discard,
                style: TextStyle(
                    color: Theme.of(context).backgroundColor
                ),
                //  "Discard"
              ),
            ),
          ),
          // ! ADD ....
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor)),
                onPressed: () {
                  _fhlModel.sippercontactList = sippercontactList;
                  _fhlModel.consigneeContactList = consigneecontactList;
                  _fhlModel.specialCode = specialCodeList;
                  _fhlModel.newshipperContactList = expenseList;
                  _fhlModel.newconsigneeContactList = expenseL;
                  print("Length " +
                      _fhlModel.sippercontactList.length.toString());
                  //Navigator.of(context).pop(_fhlModel);

                  print(_fhlModel.houseDetailsNumber);
                  Navigator.of(context).pop(_fhlModel);
                  var result =
                  _fhlModel.updateFHL(widget.houseDetails[0]['id'],widget.houseDetails[0]["CustomsSecurity"][0]
                  ["id"],);
                  print("iddddd"+(widget.houseDetails[0]['id']).toString());

                  print("resultttt");
                  print(result.toString());
                  // if (result.toString().contains("success")) {
                  //   Fluttertoast.showToast(
                  //       msg: 'House list edited',
                  //       toastLength: Toast.LENGTH_SHORT,
                  //       gravity: ToastGravity.BOTTOM,
                  //       // timeInSecForIosWeb: 1,
                  //       backgroundColor: Colors.green,
                  //       textColor: Colors.white
                  //   );
                  //   // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //   //   content: Text("House list edited"),
                  //   // ));
                  //   // showMessage(
                  //   //      S.of(context).Houselistedited,
                  //   //    // "House list edited",
                  //   //     Colors.green,
                  //   //     Colors.white);
                  // } else {
                  //   Fluttertoast.showToast(
                  //       msg: 'House list edited failed',
                  //       toastLength: Toast.LENGTH_SHORT,
                  //       gravity: ToastGravity.BOTTOM,
                  //       // timeInSecForIosWeb: 1,
                  //       backgroundColor: Colors.red,
                  //       textColor: Colors.white
                  //   );
                  //   // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //   //   content: Text("House list edited failed"),
                  //   // ));
                  //   // showMessage(
                  //   //     S.of(context).Houselisteditfailed,
                  //   //     //"House list edit faild",
                  //   //     Colors.red,
                  //   //     Colors.white);
                  // }
                },
                child: Text(
                  S.of(context).Update,
                  style:
                  TextStyle(color: Theme.of(context).backgroundColor
                  ),
                  //  "Update"
                )),
          ),
        ],
      ),
    )
        : Container();
  }
  //
  // void showMessage(String message, Color bgcolor, txtcolor) {
  //   if (!mounted) return;
  //   showFlash(
  //       context: context,
  //       duration: Duration(seconds: 3),
  //       builder: (_, controller) {
  //         return Flash(
  //           borderRadius: BorderRadius.circular(20),
  //           backgroundColor: bgcolor,
  //           controller: controller,
  //           position: FlashPosition.top,
  //           behavior: FlashBehavior.fixed,
  //           child: FlashBar(
  //             icon: Icon(
  //               Icons.flight_takeoff_outlined,
  //               size: 36.0,
  //               color: txtcolor,
  //             ),
  //             content: Text(
  //               message,
  //               textAlign: TextAlign.center,
  //               style: TextStyle(fontSize: 20, color: txtcolor),
  //             ),
  //           ),
  //         );
  //       });
  // }

  Widget buildConsignee() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Text(
                S.of(context).Consignee,
                //"Consignee",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                 // decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
            ),

            // ! consigneeName....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                inputFormatters: [AllCapitalCase()],
                enabled: !widget.isView,
                initialValue: widget.houseDetails[0]["c_name"],
                onChanged: (value) {
                  _fhlModel.consigneeName = value;
                },
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).Name+"*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor)
                  ,   suffixIcon: Icon(
                  Icons.contacts_rounded,
                  color: Theme.of(context).accentColor,
                  // color: Colors.deepPurple,
                )
                  //'Name',
                ),
              ),
            ),

            // ! consigneeAddress...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                inputFormatters: [AllCapitalCase()],
                initialValue: widget.houseDetails[0]["c_address"],
                onChanged: (value) {
                  _fhlModel.consigneeAddress = value;
                },
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).StreetAddress+"*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),

                    suffixIcon: Icon(
                      Icons.my_location,
                      color: Theme.of(context).accentColor,
                      //color: Colors.deepPurple,
                    )
                  //'Street Address',
                ),
              ),
            ),

            // ! consigneePlace...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                inputFormatters: [AllCapitalCase()],
                initialValue: widget.houseDetails[0]["c_place"],
                onChanged: (value) {
                _fhlModel.consigneePlace = value;
                },
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).Place+"*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    suffixIcon: Icon(
                      Icons.place,
                      color: Theme.of(context).accentColor,
                      //   color: Colors.deepPurple,
                    )
                  //'Place',
                ),
              ),
            ),
            // ! consigneeState...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: widget.houseDetails[0]["c_state"],
                inputFormatters: [AllCapitalCase()],
                onChanged: (value) {
                  _fhlModel.consigneeState = value;
                },
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).State,
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    suffixIcon: Icon(
                      Icons.place,
                      color: Theme.of(context).accentColor,
                      // color: Colors.deepPurple,
                    )
                  //'State',
                ),
              ),
            ),

            // ! consigneeCode, consigneeCode....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Row(
                children: [
                  // ! consigneeCode....
                  Expanded(
                    child: Container(
                      child: TypeAheadFormField<CountryCode>(

                        getImmediateSuggestions: true,
                        suggestionsCallback: CountryCodeApi.getCountryCode,
                        itemBuilder: (context, CountryCode suggestion) {
                          final code = suggestion;
                          print(code.countryName);
                          return ListTile(
                            title: Text(code.countryCode),
                            subtitle: Text(code.countryName),
                          );
                        },
                        // validator: (value) {
                        //   if (value.isEmpty) {
                        //     return
                        //       S.of(context).Selectacountrycode;
                        //     //'Select a country code';
                        //   }
                        //   return null;
                        // },

                        autovalidateMode: AutovalidateMode.always,
                        textFieldConfiguration: TextFieldConfiguration(
                          inputFormatters: [AllCapitalCase()],
                          enabled: !widget.isView,
                          controller:ConsigneeCountryCode,
                          // onChanged: (value) {
                          //   _fhlModel.consigneeCode = value;
                          //       ConsigneeCountryCode.text=value;
                          // },
                          // controller: this.shipperContact,
                          // style: TextStyle(
                          //   fontSize: 16,
                          // ),
                          // onChanged: (value) {
                          //   if (CountryCodeApi.checkifCountryCode(value) != null) {
                          //     model.shipperCountryCode = this.shipperContact.text;
                          //   }
                          // },
                          decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.fromLTRB(15.0, 28.0, 20.0, 10.0),
                              // contentPadding: EdgeInsets.all(),
                              // helperText:(isloaded)?"eg: IN":"",
                              isDense: true,
                              border: OutlineInputBorder(
                                  gapPadding: 2.0,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                              ),
                              //border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                              ),
                              labelText: S.of(context).CountryCode,
                              labelStyle: new TextStyle(
                                  color: Theme.of(context).accentColor,
                                  // color: Colors.deepPurple,
                                  fontSize: 16.0),
                              //'Country Code',
                              suffixIcon: Icon(
                                Icons.add_location,
                                color: Theme.of(context).accentColor,
                                // color: Colors.deepPurple,
                              )
                          ),
                        ),
                        suggestionsBoxDecoration: SuggestionsBoxDecoration(elevation: 2.0),
                        onSuggestionSelected: (CountryCode suggestion) {
                          if (suggestion.countryCode == null &&
                              suggestion.countryName == null) {
                            return
                              S.of(context).WrongAWBNumber;
                            //'Worong AWB Number';
                          } else {
                            this.ConsigneeCountryCode.text = suggestion.countryCode;
                            _fhlModel.consigneeCode= suggestion.countryCode;
                          }
                        },

                        // onSuggestionSelected: (CountryCode suggestion) {
                        //
                        //   this.shipperContact.text = suggestion.countryCode;
                        //   model.shipperCountryCode = suggestion.countryCode;
                        //   //print(origin);
                        // }
                      ),
                      // child: TextFormField(
                      //   initialValue: model.shipperCountryCode,
                      //   // focusNode: _shipperPlaceFocusNode,
                      //   maxLength: 3,
                      //   textInputAction: TextInputAction.next,
                      //   //keyboardType: TextInputType.number,

                      //   onFieldSubmitted: (value) {
                      //     // _fieldFocusChange(
                      //     //     context, _shipperNameFocusNode, _shipperAddressFocusNode);
                      //   },
                      //   decoration: InputDecoration(
                      //     border: OutlineInputBorder(
                      //         gapPadding: 2.0,
                      //         borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      //     labelText: 'Country Code',
                      //   ),
                      //   onChanged: (text) {
                      //     // model.setshipperName(text);
                      //     model.shipperCountryCode = text;
                      //   },
                      // ),
                    ),
                  ),
                  // Expanded(
                  //   child: TextFormField(
                  //     enabled: !widget.isView,
                  //     initialValue: widget.houseDetails[0]["c_countryCode"],
                  //     onChanged: (value) {
                  //       _fhlModel.consigneeCode = value;
                  //     },
                  //     decoration: InputDecoration(
                  //         enabledBorder: OutlineInputBorder(
                  //           borderSide: BorderSide(
                  //               color: Theme.of(context).accentColor),
                  //           borderRadius:
                  //           BorderRadius.all(Radius.circular(8.0)),
                  //         ),
                  //         //border: InputBorder.none,
                  //         focusedBorder: OutlineInputBorder(
                  //           borderSide: BorderSide(
                  //               color: Theme.of(context).accentColor),
                  //           borderRadius:
                  //           BorderRadius.all(Radius.circular(8.0)),
                  //         ),
                  //         border: OutlineInputBorder(
                  //             gapPadding: 2.0,
                  //             borderRadius:
                  //             BorderRadius.all(Radius.circular(8.0))),
                  //         labelText: S.of(context).CountryCode,
                  //         labelStyle:
                  //         TextStyle(color: Theme.of(context).accentColor)
                  //       //'Country Code',
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    width: 5,
                  ),
                  // ! consigneePostCode....
                  Expanded(
                    child: TextFormField(
                      enabled: !widget.isView,
                      initialValue: widget.houseDetails[0]["c_postCode"],
                      onChanged: (value) {
                        _fhlModel.consigneePostCode = value;
                     },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor),
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0)),
                          ),
                          //border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor),
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0)),
                          ),
                          border: OutlineInputBorder(
                              gapPadding: 2.0,
                              borderRadius:
                              BorderRadius.all(Radius.circular(8.0))),
                          labelText: S.of(context).PostCode,
                          labelStyle:
                          TextStyle(color: Theme.of(context).accentColor)
                        //'Post Code',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ! consigneeIdentifier...
            // Padding(
            //   padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
            //   child: TextFormField(
            //     enabled: !widget.isView,
            //     initialValue: widget.houseDetails[0]["Consignee_Contact"][0]
            //         ["Consignee_Contact_Type"],
            //     onChanged: (value) {
            //       _fhlModel.consigneeIdentifier = value;
            //     },
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder(
            //           gapPadding: 2.0,
            //           borderRadius: BorderRadius.all(Radius.circular(8.0))),
            //       labelText: S.of(context).Identifier,
            //       //'Identifier',
            //     ),
            //   ),
            // ),

            // // ! consigneeNumber...
            // Padding(
            //   padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
            //   child: TextFormField(
            //     keyboardType: TextInputType.number,
            //     enabled: !widget.isView,
            //     initialValue: widget.houseDetails[0]["Consignee_Contact"][0]
            //         ["Consignee_Contact_Detail"],
            //     onChanged: (value) {
            //       _fhlModel.consigneeNumber = value;
            //     },
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder(
            //           gapPadding: 2.0,
            //           borderRadius: BorderRadius.all(Radius.circular(8.0))),
            //       labelText: S.of(context).ContactNumber,
            //       //'Contact Number',
            //     ),
            //   ),
            // ),

            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Text(
                    S.of(context).AddContacts,
                    // 'Add Contacts',
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 17.0),
                  ),
                ),
                // Expanded(
                //   flex: 1,
                //   // child: IconButton(
                //   //   color: Theme.of(context).accentColor,
                //   //   icon: Icon(Icons.delete),
                //   //   onPressed: () {
                //   //     FocusScope.of(context).unfocus();
                //   //     setState(() {
                //   //       consigneecontactList
                //   //           .removeWhere((element) => element['isSelected']);
                //   //     });
                //   //   },
                //   // ),
                // ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    color: Theme.of(context).accentColor,
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _showConsigneeContactDialog();
                      // setState(() {
                      //   consigneecontactList.add({
                      //     'isSelected': false,
                      //     'Consignee_Contact_Type': "Telegram",
                      //     'Consignee_Contact_Detail': 0,
                      //   });
                      // });
                    },
                  ),
                ),
              ],
            ),
            Container(
              child: Column(
                children: expenseL.map((e) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Theme.of(context).backgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8.0,
                              offset: Offset(0.0, 5.0),
                            ),
                          ],
                        ),
                        width: 325,
                        child: ListTile(
                          leading: Icon(
                            Icons.phone,
                            color: Theme.of(context).accentColor,
                          ),
                          title: Text(
                            '${e.Consignee_Contact_Detail}',
                          ),
                          subtitle: Text(
                            '${e.Consignee_Contact_Type}',
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(child: Text(
                                        S.of(context).Delete
                                      //'Delete'
                                    )),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                              S.of(context).Wouldyouliketodeleteconsigneecontactnumber
                                            // 'Would you like to delete shipper contact number'
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                          S.of(context).Confirm,
                                          //  'Confirm',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        onPressed: () {
                                          Consigneecontactdelete(
                                              e.Consignee_Contact_Detail);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          S.of(context).Cancel,
                                          // 'Cancel',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              // Scontactdelete(e.title);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
            //   child: Column(
            //     children: [
            //       SingleChildScrollView(
            //         scrollDirection: Axis.horizontal,
            //         child: Builder(
            //           builder: (context) => DataTable(
            //             columnSpacing: 15,
            //             columns: [
            //               DataColumn(
            //                   label: Text(
            //                 S.of(context).Type,
            //                 style: TextStyle(
            //                   color: Theme.of(context).accentColor
            //                 ),
            //                 // 'Type'
            //               )),
            //               DataColumn(
            //                   label: Text(S.of(context).ContactNumber,
            //                     style: TextStyle(
            //                         color: Theme.of(context).accentColor
            //                     ),
            //                       //  'Contact Number'
            //                       )),
            //             ],
            //             rows: List<DataRow>.generate(
            //               consigneecontactList.length,
            //               (index) => newAddConsignee(index),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  newAddConsignee(int dimensionIndex) {
    print("object");
    return DataRow(
        key: ValueKey(consigneecontactList[dimensionIndex]),
        // ! Very Important key for Delete the value....
        selected: consigneecontactList[dimensionIndex]['isSelected'],
        onSelectChanged: (value) {
          setState(() {
            consigneecontactList[dimensionIndex]['isSelected'] =
            !consigneecontactList[dimensionIndex]['isSelected'];
          });
        },
        cells: [
          DataCell(DropdownButton<String>(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).accentColor,
              ),
              value: consigneecontactList[dimensionIndex]
              ['Consignee_Contact_Type'],
              items: ['Telegram', 'WhatApp', 'Telephone', "Fax"]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                );
              }).toList(),
              onChanged: (String text) {
                setState(() {
                  consigneecontactList[dimensionIndex]
                  ['Consignee_Contact_Type'] = text;
                });
              })
            // TextFormField(
            //   initialValue:
            //       consigneecontactList[dimensionIndex]['itentifier'] == ""
            //           ? ''
            //           : '${consigneecontactList[dimensionIndex]['itentifier']}',
            //   onChanged: (value) {
            //     setState(() {
            //       consigneecontactList[dimensionIndex]['itentifier'] = value;
            //     });
            //   },
            //   keyboardType: TextInputType.text,
            // ),
          ), // DataColumn(label: Text('Length')),
          DataCell(
            TextFormField(
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                //   border: OutlineInputBorder(
                //       // gapPadding: 2.0,
                //       // borderRadius: BorderRadius.all(Radius.circular(8.0))
                //       ),
                //   labelText: 'Number',
              ),
              initialValue: consigneecontactList[dimensionIndex]
              ['Consignee_Contact_Detail'] ==
                  0.0
                  ? ''
                  : '${consigneecontactList[dimensionIndex]['Consignee_Contact_Detail']}',
              onChanged: (value) {
                setState(() {
                  consigneecontactList[dimensionIndex]
                  ['Consignee_Contact_Detail'] = value;
                });
              },
              keyboardType: TextInputType.number,
            ),
          ),
        ]);
  }

  Widget buildShipper() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Text(
                S.of(context).Shipper,
                //"Shipper",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  //decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
            ),

            // ! shipperName....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: widget.houseDetails[0]["s_name"],
                onChanged: (value) {
                  _fhlModel.shipperName = value;
                },
                inputFormatters: [AllCapitalCase()],
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).Name+"*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor)
                    ,      suffixIcon: Icon(
                  Icons.contacts_rounded,
                  color: Theme.of(context).accentColor,
                  // color: Colors.deepPurple,
                )
                  //'Name',
                ),
              ),
            ),

            // ! shipperAddress...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: widget.houseDetails[0]["s_address"],
                onChanged: (value) {
                  _fhlModel.shipperAddress = value;
                },
                inputFormatters: [AllCapitalCase()],
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).StreetAddress+"*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    suffixIcon: Icon(
                      Icons.my_location,
                      color: Theme.of(context).accentColor,
                      //color: Colors.deepPurple,
                    )
                  //'Street Address',
                ),
              ),
            ),

            // ! shipperPlace...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: widget.houseDetails[0]["s_place"],
                onChanged: (value) {
                  _fhlModel.shipperPlace = value;
                },
                inputFormatters: [AllCapitalCase()],
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).Place+"*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    suffixIcon: Icon(
                      Icons.place,
                      color: Theme.of(context).accentColor,
                      //   color: Colors.deepPurple,
                    )
                  //'Place',
                ),
              ),
            ),
            // ! shipperState...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: widget.houseDetails[0]["s_state"],
                onChanged: (value) {
                  _fhlModel.shipperState = value;
               },
                inputFormatters: [AllCapitalCase()],
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).State,
                    labelStyle: TextStyle(color: Theme.of(context).accentColor) ,
                    suffixIcon: Icon(
                      Icons.place,
                      color: Theme.of(context).accentColor,
                      // color: Colors.deepPurple,
                    )
                  //'State',
                ),
              ),
            ),

            // ! houseDetailsOrigin, houseDetailsDestination....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Row(
                children: [
                  // ! shipperCode....
                  Expanded(
                    child: Container(
                      child: TypeAheadFormField<CountryCode>(

                        getImmediateSuggestions: true,
                        suggestionsCallback: CountryCodeApi.getCountryCode,
                        itemBuilder: (context, CountryCode suggestion) {
                          final code = suggestion;
                          print(code.countryName);
                          return ListTile(
                            title: Text(code.countryCode),
                            subtitle: Text(code.countryName),
                          );
                        },
                        // validator: (value) {
                        //   if (value.isEmpty) {
                        //     return
                        //       S.of(context).Selectacountrycode;
                        //     //'Select a country code';
                        //   }
                        //   return null;
                        // },

                        autovalidateMode: AutovalidateMode.always,
                        textFieldConfiguration: TextFieldConfiguration(
                          inputFormatters: [AllCapitalCase()],
                          enabled: !widget.isView,
                          controller:ShipperCountryCode,
                          // onChanged: (value) {
                          //   _fhlModel.shipperCode = ShipperCountryCode.text;
                          // },
                          // controller: this.shipperContact,
                          // style: TextStyle(
                          //   fontSize: 16,
                          // ),
                          // onChanged: (value) {
                          //   if (CountryCodeApi.checkifCountryCode(value) != null) {
                          //     model.shipperCountryCode = this.shipperContact.text;
                          //   }
                          // },
                          decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.fromLTRB(15.0, 28.0, 20.0, 10.0),
                              // contentPadding: EdgeInsets.all(),
                              // helperText:(isloaded)?"eg: IN":"",
                              isDense: true,
                              border: OutlineInputBorder(
                                  gapPadding: 2.0,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                              ),
                              //border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                              ),
                              labelText: S.of(context).CountryCode,
                              labelStyle: new TextStyle(
                                  color: Theme.of(context).accentColor,
                                  // color: Colors.deepPurple,
                                  fontSize: 16.0),
                              //'Country Code',
                              suffixIcon: Icon(
                                Icons.add_location,
                                color: Theme.of(context).accentColor,
                                // color: Colors.deepPurple,
                              )
                          ),
                        ),
                        suggestionsBoxDecoration: SuggestionsBoxDecoration(elevation: 2.0),
                        onSuggestionSelected: (CountryCode suggestion) {
                          // if (suggestion.countryCode == null &&
                          //     suggestion.countryName == null) {
                          //   return
                          //     S.of(context).WrongAWBNumber;
                          //   //'Worong AWB Number';
                          // } else {
                            this.ShipperCountryCode.text = suggestion.countryCode;
                            _fhlModel.shipperCode = suggestion.countryCode;
                          //}
                        },

                        // onSuggestionSelected: (CountryCode suggestion) {
                        //
                        //   this.shipperContact.text = suggestion.countryCode;
                        //   model.shipperCountryCode = suggestion.countryCode;
                        //   //print(origin);
                        // }
                      ),
                      // child: TextFormField(
                      //   initialValue: model.shipperCountryCode,
                      //   // focusNode: _shipperPlaceFocusNode,
                      //   maxLength: 3,
                      //   textInputAction: TextInputAction.next,
                      //   //keyboardType: TextInputType.number,

                      //   onFieldSubmitted: (value) {
                      //     // _fieldFocusChange(
                      //     //     context, _shipperNameFocusNode, _shipperAddressFocusNode);
                      //   },
                      //   decoration: InputDecoration(
                      //     border: OutlineInputBorder(
                      //         gapPadding: 2.0,
                      //         borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      //     labelText: 'Country Code',
                      //   ),
                      //   onChanged: (text) {
                      //     // model.setshipperName(text);
                      //     model.shipperCountryCode = text;
                      //   },
                      // ),
                    ),
                  ),
                  // Expanded(
                  //   child: TextFormField(
                  //     enabled: !widget.isView,
                  //     initialValue: widget.houseDetails[0]["s_countryCode"],
                  //     onChanged: (value) {
                  //       _fhlModel.shipperCode = value;
                  //     },
                  //     decoration: InputDecoration(
                  //         enabledBorder: OutlineInputBorder(
                  //           borderSide: BorderSide(
                  //               color: Theme.of(context).accentColor),
                  //           borderRadius:
                  //           BorderRadius.all(Radius.circular(8.0)),
                  //         ),
                  //         //border: InputBorder.none,
                  //         focusedBorder: OutlineInputBorder(
                  //           borderSide: BorderSide(
                  //               color: Theme.of(context).accentColor),
                  //           borderRadius:
                  //           BorderRadius.all(Radius.circular(8.0)),
                  //         ),
                  //         border: OutlineInputBorder(
                  //             gapPadding: 2.0,
                  //             borderRadius:
                  //             BorderRadius.all(Radius.circular(8.0))),
                  //         labelText: S.of(context).CountryCode,
                  //         labelStyle:
                  //         TextStyle(color: Theme.of(context).accentColor)
                  //       //'Country Code',
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    width: 5,
                  ),
                  // ! shipperPostCode....
                  Expanded(
                    child: TextFormField(
                      enabled: !widget.isView,
                      initialValue: widget.houseDetails[0]["s_postCode"],
                      onChanged: (value) {
                        _fhlModel.shipperPostCode = value;
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor),
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0)),
                          ),
                          //border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor),
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0)),
                          ),
                          border: OutlineInputBorder(
                              gapPadding: 2.0,
                              borderRadius:
                              BorderRadius.all(Radius.circular(8.0))),
                          labelText: S.of(context).PostCode,
                          labelStyle:
                          TextStyle(color: Theme.of(context).accentColor),
     suffixIcon: Icon(
    Icons.code,
    color: Theme.of(context).accentColor,
    // color: Colors.deepPurple,
    )
                        //'Post Code',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // // ! shipperIdentifier...
            // Padding(
            //   padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
            //   child: TextFormField(
            //     enabled: !widget.isView,
            //     initialValue: widget.houseDetails[0]["Shipper_Contact"][0]
            //         ["Shipper_Contact_Type"],
            //     onChanged: (value) {
            //       _fhlModel.shipperIdentifier = value;
            //     },
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder(
            //           gapPadding: 2.0,
            //           borderRadius: BorderRadius.all(Radius.circular(8.0))),
            //       labelText:
            //       S.of(context).Identifier,
            //       //'Identifier',
            //     ),
            //   ),
            // ),

            // // ! shipperNumber...
            // Padding(
            //   padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
            //   child: TextFormField(
            //     keyboardType: TextInputType.number,
            //     enabled: !widget.isView,
            //     initialValue: widget.houseDetails[0]["Shipper_Contact"][0]
            //         ["Shipper_Contact_Detail"],
            //     onChanged: (value) {
            //       _fhlModel.shipperNumber = value;
            //     },
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder(
            //           gapPadding: 2.0,
            //           borderRadius: BorderRadius.all(Radius.circular(8.0))),
            //       labelText:
            //       S.of(context).ContactNumber,
            //       //'Contact Number',
            //     ),
            //   ),
            // ),

            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Text(
                    S.of(context).AddContacts,
                    // 'Add Contacts',
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 17.0),
                  ),
                ),
                // Expanded(
                //   flex: 1,
                //   child: IconButton(
                //     color: Theme.of(context).accentColor,
                //     icon: Icon(Icons.delete),
                //     onPressed: () {
                //       FocusScope.of(context).unfocus();
                //       setState(() {
                //         sippercontactList
                //             .removeWhere((element) => element['isSelected']);
                //       });
                //     },
                //   ),
                // ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    color: Theme.of(context).accentColor,
                    icon: Icon(Icons.add),
                    onPressed: () async {
                      final name = await _showDialogContact();
                      if (name == null || name.isEmpty) return;
                      setState(() {
                        // this.name = name;
                      });
                      // setState(() {
                      //   sippercontactList.add({
                      //     'isSelected': false,
                      //     'Shipper_Contact_Type': 'Telegram',
                      //     'Shipper_Contact_Detail': 0,
                      //   });
                      // });
                    },
                  ),
                ),
              ],
            ),
            Container(
              child: Column(
                children: expenseList.map((e) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Theme.of(context).backgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8.0,
                              offset: Offset(0.0, 5.0),
                            ),
                          ],
                        ),
                        width: 325,
                        child: ListTile(
                          leading: Icon(
                            Icons.phone,
                            color: Theme.of(context).accentColor,
                          ),
                          title: Text(
                            '${e.Shipper_Contact_Detail}',
                          ),
                          subtitle: Text(
                            '${e.Shipper_Contact_Type}',
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(child: Text('Delete')),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                              'Would you like to delete shipper contact number'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                          'Confirm',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        onPressed: () {
                                          Scontactdelete(
                                              e.Shipper_Contact_Detail);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          S.of(context).Cancel,
                                          // 'Cancel',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              // Scontactdelete(e.title);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
            //   child: Column(
            //     children: [
            //       SingleChildScrollView(
            //         scrollDirection: Axis.horizontal,
            //         child: Builder(
            //           builder: (context) => DataTable(
            //             dataRowColor: MaterialStateProperty
            //                 .resolveWith<Color>(
            //                     (Set<MaterialState> states) {
            //                   if (states
            //                       .contains(MaterialState.selected))
            //                     return Theme.of(context).accentColor.withOpacity(0.5);
            //                   return null; // Use the default value.
            //                 }),
            //             showCheckboxColumn: false,
            //             columnSpacing: 15,
            //             columns: [
            //               DataColumn(
            //                   label: Text(
            //                 S.of(context).Type,
            //                 style: TextStyle(
            //                  color: Theme.of(context).accentColor
            //                 ),
            //                 //'Type'
            //               )),
            //               DataColumn(
            //                   label: Text(
            //                 S.of(context).ContactNumber,
            //                     style: TextStyle(
            //                         color: Theme.of(context).accentColor
            //                     ),
            //
            //                 // 'Contact Number'
            //               )),
            //             ],
            //             rows: List<DataRow>.generate(
            //               sippercontactList.length,
            //               (index) => newDataRow(index),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  newDataRow(int dimensionIndex) {
    return DataRow(
        key: ValueKey(sippercontactList[dimensionIndex]),
        // ! Very Important key for Delete the value....
        selected: sippercontactList[dimensionIndex]['isSelected'],
        onSelectChanged: (value) {
          setState(() {
            sippercontactList[dimensionIndex]['isSelected'] =
            !sippercontactList[dimensionIndex]['isSelected'];
          });
        },
        cells: [
          DataCell(
            DropdownButton<String>(
                icon: Icon(Icons.arrow_drop_down),
                value: sippercontactList[dimensionIndex]
                ['Shipper_Contact_Type'],
                items: ['Telegram', 'WhatsApp', 'Telephone', "Fax"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  );
                }).toList(),
                onChanged: (String text) {
                  setState(() {
                    sippercontactList[dimensionIndex]['Shipper_Contact_Type'] =
                        text;
                  });
                }),

            //   TextFormField(
            //     initialValue:
            //         sippercontactList[dimensionIndex]['itentifier'] == ""
            //             ? ''
            //             : '${sippercontactList[dimensionIndex]['itentifier']}',
            //     onChanged: (value) {
            //       setState(() {
            //         sippercontactList[dimensionIndex]['itentifier'] = value;
            //       });
            //     },
            //     keyboardType: TextInputType.text,
            //     // decoration: InputDecoration(
            //     //   border: OutlineInputBorder(
            //     //       // gapPadding: 2.0,
            //     //       // borderRadius: BorderRadius.all(Radius.circular(8.0))
            //     //       ),
            //     //   labelText: 'Itentifier',
            //     // ),
            //   ),
            // ), // DataColumn(label: Text('Length')
          ),
          DataCell(
            TextFormField(
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                //   border: OutlineInputBorder(
                //       // gapPadding: 2.0,
                //       // borderRadius: BorderRadius.all(Radius.circular(8.0))
                //       ),
                //   labelText: 'Number',
              ),
              initialValue: sippercontactList[dimensionIndex]
              ['Shipper_Contact_Detail'] ==
                  0.0
                  ? ''
                  : '${sippercontactList[dimensionIndex]['Shipper_Contact_Detail']}',
              onChanged: (value) {
                setState(() {
                  sippercontactList[dimensionIndex]['Shipper_Contact_Detail'] =
                      value;
                });
              },
              keyboardType: TextInputType.number,
              // decoration: InputDecoration(
              //   border: OutlineInputBorder(
              //       // gapPadding: 2.0,
              //       // borderRadius: BorderRadius.all(Radius.circular(8.0))
              //       ),
              //   labelText: 'Number',
              // ),
            ),
          ),
        ]);
  }

  Widget buildSpecialRequirements() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Text(
                S.of(context).SpecialRequirements,

                // "Special Requirements",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                 // decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Text(
                    S.of(context).AddSpecialCode,
                    style: TextStyle(color: Theme.of(context).accentColor),

                    //  "Add Special Code"
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    color: Theme.of(context).accentColor,
                    icon: Icon(
                      Icons.delete,
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        specialCodeList
                            .removeWhere((element) => element['isSelected']);
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: IconButton(
                    color: Theme.of(context).accentColor,
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        specialCodeList.add({
                          'isSelected': false,
                          'specialcode': "",
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Builder(
                      builder: (context) => DataTable(
                        columnSpacing: 5,
                        columns: [
                          DataColumn(
                              label: Text(
                                S.of(context).SpecialCode,
                                style:
                                TextStyle(color: Theme.of(context).accentColor),
                                // 'Special Code'
                              )),
                        ],
                        rows: List<DataRow>.generate(
                          specialCodeList.length,
                              (index) => addSpecialCode(index),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Text(
                    S.of(context).AddHormonizedCode,
                    style: TextStyle(color: Theme.of(context).accentColor),
                    //  "Add Hormonized Code"
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    color: Theme.of(context).accentColor,
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        hormoCodeList
                            .removeWhere((element) => element['isSelected']);
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    color: Theme.of(context).accentColor,
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        hormoCodeList.add({
                          'isSelected': false,
                          'hormonisedcode': "",
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Builder(
                      builder: (context) => DataTable(
                        columnSpacing: 15,
                        columns: [
                          DataColumn(
                              label: Text(S.of(context).HarmonisedCode,
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor)
                                //  'Harmonised Code'
                              )),
                        ],
                        rows: List<DataRow>.generate(
                          hormoCodeList.length,
                              (index) => addHormoCode(index),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
            //   child: Row(
            //     children: [
            //       // ! specialRequirementSpecialCode....
            //       Expanded(
            //         child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: TextFormField(
            //             keyboardType: TextInputType.text,
            //             inputFormatters: [AllCapitalCase()],
            //             maxLength: 3,
            //             enabled: !widget.isView,
            //             initialValue: widget.houseDetails[0]["spl1"],
            //             onChanged: (value) {
            //               _fhlModel.specialRequirementSpecialCode = value;
            //             },
            //             decoration: InputDecoration(
            //               border: OutlineInputBorder(
            //                   gapPadding: 2.0,
            //                   borderRadius:
            //                       BorderRadius.all(Radius.circular(8.0))),
            //               labelText: S.of(context).SpecialCode,
            //               //'Special Code',
            //             ),
            //           ),
            //         ),
            //       ),
            //       // ! specialRequirementHarmonisedCode....
            //       Expanded(
            //         child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: TextFormField(
            //             keyboardType: TextInputType.text,
            //             inputFormatters: [AllCapitalCase()],
            //             maxLength: 12,
            //             enabled: !widget.isView,
            //             initialValue: widget.houseDetails[0]["harmonisedCode1"],
            //             onChanged: (value) {
            //               _fhlModel.specialRequirementHarmonisedCode = value;
            //             },
            //             decoration: InputDecoration(
            //               border: OutlineInputBorder(
            //                   gapPadding: 2.0,
            //                   borderRadius:
            //                       BorderRadius.all(Radius.circular(8.0))),
            //               labelText: S.of(context).HarmonisedCode,
            //               //'Harmonised Code',
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  TextEditingController shcontroller = new TextEditingController();
  addSpecialCode(int dimensionIndex) {
    return DataRow(
        key: ValueKey(specialCodeList[dimensionIndex]),
        // ! Very Important key for Delete the value....
        selected: specialCodeList[dimensionIndex]['isSelected'],
        onSelectChanged: (value) {
          setState(() {
            specialCodeList[dimensionIndex]['isSelected'] =
            !specialCodeList[dimensionIndex]['isSelected'];
          });
        },
        cells: [
          DataCell(
            // TextFormField(
            //   initialValue: specialCodeList[dimensionIndex]['specialcode'] == ""
            //       ? ''
            //       : '${specialCodeList[dimensionIndex]['specialcode']}',
            //   onChanged: (value) {
            //     setState(() {
            //       specialCodeList[dimensionIndex]['specialcode'] = value;
            //     });
            //   },
            //   keyboardType: TextInputType.text,
            //   inputFormatters: [AllCapitalCase()],
            //   maxLength: 3,
            //),

              TypeAheadFormField<SpecialHandlingGroup>(
                  suggestionsCallback: SpecialHandlingGroupApi.getSpecialHandlingCode,
                  itemBuilder: (context, SpecialHandlingGroup suggestion) {
                    final code = suggestion;
                    return ListTile(
                      title: Text(code.shgCode,
                          style:
                          TextStyle(color: Theme.of(context).accentColor)),
                      subtitle: Text(code.shgName,
                          style:
                          TextStyle(color: Theme.of(context).accentColor)),
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return
                        S.of(context).SelectaSpecialCode;
                      //'Select a SpecialCode';
                    }
                    return null;
                  },
                  // initialValue:
                  //     specialCodeList[dimensionIndex]['specialcode'] == ""
                  //         ? ''
                  //         : '${specialCodeList[dimensionIndex]['specialcode']}',
                  textFieldConfiguration: TextFieldConfiguration(
                    autofocus: false,
                    controller: shcontroller,
                    // inputFormatters: [AllCapitalCase()],
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        //border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        border: OutlineInputBorder(
                            gapPadding: 2.0,
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0))),
                        labelText: S.of(context).SpecialCode,
                        labelStyle:
                        TextStyle(color: Theme.of(context).accentColor)
                      //'SpecialCode',
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSuggestionSelected: (SpecialHandlingGroup suggestion) {
                    print(suggestion);
                    this.shcontroller.text = suggestion.shgCode;
                    specialCodeList[dimensionIndex]['specialcode'] =
                        suggestion.shgCode;
                    //print(destination);
                  })), // DataColumn(label: Text('Length')),
        ]);
  }

  addHormoCode(int index) {
    return DataRow(
        key: ValueKey(hormoCodeList[index]),
        // ! Very Important key for Delete the value....
        selected: hormoCodeList[index]['isSelected'],
        onSelectChanged: (value) {
          setState(() {
            hormoCodeList[index]['isSelected'] =
            !hormoCodeList[index]['isSelected'];
          });
        },
        cells: [
          DataCell(
            TextFormField(
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                    ),
                  )),
              initialValue: hormoCodeList[index]['hormonisedcode'] == ""
                  ? ''
                  : '${hormoCodeList[index]['hormonisedcode']}',
              onChanged: (value) {
                setState(() {
                  hormoCodeList[index]['hormonisedcode'] = value;
                });
              },
              keyboardType: TextInputType.text,
              inputFormatters: [AllCapitalCase()],
              maxLength: 12,
            ),
          ),
        ]);
  }

  Widget buildChargeDeclaration() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Text(
                S.of(context).Chargesdeclaration,

                //"Charges Declaration",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                //  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
            ),

            // ! chargeDeclarationCurrencyCode....
            Container(
                padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
                // margin: EdgeInsets.only(left: 40.0,right: 40.0),
                child: TypeAheadFormField<CurrencyCode>(

                    suggestionsCallback: CurrencyAPI.getCurrencyCode,
                    itemBuilder: (context, CurrencyCode suggestion) {
                      final code = suggestion;
                      return ListTile(
                        title: Text(code.currencyCode),
                        subtitle: Text(code.currencyName),
                      );
                    },
                    // validator: (value) {
                    //   if (value.isEmpty) {
                    //     return
                    //       S.of(context).SelectacurrencyName;
                    //
                    //     //'Select a currency Name';
                    //   }
                    //   return null;
                    // },
                    textFieldConfiguration: TextFieldConfiguration(
                      autofocus: false,
                      controller: RateCurrencyCode,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [AllCapitalCase()],
                      decoration: InputDecoration(
                        isDense: true,
                        suffixIcon:
                        Icon(Icons.money,
                            size: 23,
                            color: Theme.of(context).accentColor),
                        contentPadding:
                        EdgeInsets.fromLTRB(15.0, 28.0, 20.0, 10.0),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                            BorderSide(color: Theme.of(context).accentColor, width: 1.0)),
                        // enabledBorder: OutlineInputBorder(
                        //     borderSide: new BorderSide(
                        //         color: Theme.of(context).accentColor,
                        //         // color: Colors.deepPurple,
                        //         width: 1),
                        //      //gapPadding: 20.0,
                        //     borderRadius: BorderRadius.all(Radius.circular(15.0))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Theme.of(context).accentColor,
                            //   color: Colors.deepPurple
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        // border: OutlineInputBorder(
                        //     gapPadding: 2.0,
                        //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
                        labelText:
                        S.of(context).CurrencyCode+"*",
                        //"Currency Code",
                        prefixText: flag,
                        labelStyle: new TextStyle(
                            color: Theme.of(context).accentColor,
                            // color: Colors.deepPurple,
                            fontSize: 16.0),

                        // contentPadding: EdgeInsets.all(19.0),
                        // prefixIcon: Icon(
                        //   Icons.money,
                        //   size: 25,
                        //   color: Theme.of(context).accentColor,
                        //   // color: Colors.deepPurple,
                        // )
                        // 'Destination',
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSuggestionSelected: (CurrencyCode suggestion) {
                      // if (suggestion.currencyCode == null &&
                      //     suggestion.currencyName == null) {
                      //   return
                      //     S.of(context).WrongCode;
                      //   //'Worong Code';
                      // } else {
                        this.RateCurrencyCode.text = suggestion.currencyName;

                        String Currency = suggestion.currencyName;
                        print(Currency);
                    //  }
                      RateCurrencyCode.text = suggestion.currencyCode;
                      _fhlModel.chargeDeclarationCurrencyCode  = suggestion.currencyCode;
                      //  //model.chargeSummaryTotalPostpaid
                      //  //to convert originCurrency to USD
                      // var  baseCurrencyExchangeRate = StringData.getCurrencyrate(
                      //      "USD",ConvertCurr.text);
                      //  // var toCurrencyExchangeRate =
                      //  // StringData.getCurrencyrate("USD", currencycontroller.text);
                      //
                      //  //quotedToCurrencyValue;
                      //
                      //  if (baseCurrencyExchangeRate != null
                      //  //&&
                      //  //    toCurrencyExchangeRate != null
                      //  ) {
                      //   double quotedUSDValue =
                      //        (1.00 * int.tryParse(_controller.text)) /
                      //            double.tryParse(baseCurrencyExchangeRate);
                      //    // quotedToCurrencyValue =
                      //    //     (double.tryParse(toCurrencyExchangeRate) * quotedUSDValue) /
                      //    //         1.00;
                      //    // baseCurencyrate = baseCurrencyExchangeRate;
                      //  }
                    })
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
            //   child: TextFormField(
            //     keyboardType: TextInputType.text,
            //     inputFormatters: [AllCapitalCase()],
            //     maxLength: 2,
            //     enabled: !widget.isView,
            //     initialValue: widget.houseDetails[0]["currencyCode"],
            //     onChanged: (value) {
            //       _fhlModel.chargeDeclarationCurrencyCode = value;
            //     },
            //     decoration: InputDecoration(
            //         enabledBorder: OutlineInputBorder(
            //           borderSide:
            //           BorderSide(color: Theme.of(context).accentColor),
            //           borderRadius: BorderRadius.all(Radius.circular(8.0)),
            //         ),
            //         //border: InputBorder.none,
            //         focusedBorder: OutlineInputBorder(
            //           borderSide:
            //           BorderSide(color: Theme.of(context).accentColor),
            //           borderRadius: BorderRadius.all(Radius.circular(8.0)),
            //         ),
            //         border: OutlineInputBorder(
            //             gapPadding: 2.0,
            //             borderRadius: BorderRadius.all(Radius.circular(8.0))),
            //         labelText: S.of(context).CurrencyCode,
            //         labelStyle: TextStyle(color: Theme.of(context).accentColor)
            //       //'Currency Code',
            //     ),
            //   ),
            // ),

            // ! chargeDeclarationWeightValue....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                inputFormatters: [AllCapitalCase()],
                maxLength: 1,
                enabled: !widget.isView,
                initialValue: widget.houseDetails[0]["weightVal"],
                onChanged: (value) {
                  _fhlModel.chargeDeclarationWeightValue = value;
               },
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).WeightValue+"*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    suffixIcon: Icon(
                      Icons.money,
                      color: Theme.of(context).accentColor,
                      //color: Colors.deepPurple,
                    )
                  //'Weight Value',
                ),
              ),
            ),

            // ! chargeDeclarationOtherCharges....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                inputFormatters: [AllCapitalCase()],
                maxLength: 3,
                enabled: !widget.isView,
                initialValue: widget.houseDetails[0]["charges"],
                onChanged: (value) {
                  _fhlModel.chargeDeclarationOtherCharges = value;
               },
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).OtherCharges+"*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor)
                 , suffixIcon: Icon(
                  Icons.money,
                  color: Theme.of(context).accentColor,
                  //color: Colors.deepPurple,
                )
                  //'Other Charges',
                ),
              ),
            ),

            // ! chargeDeclarationCarriageValue....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                inputFormatters: [AllCapitalCase()],
                maxLength: 3,
                enabled: !widget.isView,
                initialValue: widget.houseDetails[0]["carriageValue"],
                onChanged: (value) {
                  _fhlModel.chargeDeclarationCarriageValue = value;
               },
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).CarriageValue+"*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor)
                ,  suffixIcon: Icon(
                  Icons.money,
                  color: Theme.of(context).accentColor,
                  //color: Colors.deepPurple,
                )
                  //'Carriage Value',
                ),
              ),
            ),

            // ! chargeDeclarationCustomsValue....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                inputFormatters: [AllCapitalCase()],
                maxLength: 3,
                enabled: !widget.isView,
                initialValue: widget.houseDetails[0]["customsValue"],
                onChanged: (value) {
                  _fhlModel.chargeDeclarationCustomsValue = value;
               },
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).CustomsValue+"*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                  suffixIcon: Icon(
                  Icons.money,
                  color: Theme.of(context).accentColor,
                  //color: Colors.deepPurple,
                )
                  //'Customs Value',
                ),
              ),
            ),

            // ! chargeDeclarationInsuranceValue....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                inputFormatters: [AllCapitalCase()],
                maxLength: 3,
                enabled: !widget.isView,
                initialValue: widget.houseDetails[0]["insuranceValue"],
                onChanged: (value) {
                  _fhlModel.chargeDeclarationInsuranceValue = value;
                },
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).InsuranceValue+"*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    suffixIcon: Icon(
                      Icons.money,
                      color: Theme.of(context).accentColor,
                      //color: Colors.deepPurple,
                    )
                  //'Insurance Value',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomsSecurity() {
    print(widget.houseDetails[0]["CustomsSecurity"]);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Text(
                S.of(context).CustomsSecurity,
                //"Customs Security",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                //  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
            ),

            // ! customsSecurityCountryCode....
            Container(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TypeAheadFormField<CountryCode>(

                getImmediateSuggestions: true,
                suggestionsCallback: CountryCodeApi.getCountryCode,
                itemBuilder: (context, CountryCode suggestion) {
                  final code = suggestion;
                  print(code.countryName);
                  return ListTile(
                    title: Text(code.countryCode),
                    subtitle: Text(code.countryName),
                  );
                },
                // validator: (value) {
                //   if (value.isEmpty) {
                //     return
                //       S.of(context).Selectacountrycode;
                //     //'Select a country code';
                //   }
                //   return null;
                // },

                autovalidateMode: AutovalidateMode.always,
                textFieldConfiguration: TextFieldConfiguration(
                  inputFormatters: [AllCapitalCase()],
                  enabled: !widget.isView,
                  controller:CustomsCountryCode,
                  onChanged: (value) {
                    _fhlModel.customsSecurityCountryCode= CustomsCountryCode.text;
                 },
                  // controller: this.shipperContact,
                  // style: TextStyle(
                  //   fontSize: 16,
                  // ),
                  // onChanged: (value) {
                  //   if (CountryCodeApi.checkifCountryCode(value) != null) {
                  //     model.shipperCountryCode = this.shipperContact.text;
                  //   }
                  // },
                  decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.fromLTRB(15.0, 28.0, 20.0, 10.0),
                      // contentPadding: EdgeInsets.all(),
                      // helperText:(isloaded)?"eg: IN":"",
                      isDense: true,
                      border: OutlineInputBorder(
                          gapPadding: 2.0,
                          borderRadius:
                          BorderRadius.all(Radius.circular(8.0))),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).accentColor),
                        borderRadius:
                        BorderRadius.all(Radius.circular(8.0)),
                      ),
                      //border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).accentColor),
                        borderRadius:
                        BorderRadius.all(Radius.circular(8.0)),
                      ),
                      labelText: S.of(context).CountryCode,
                      labelStyle: new TextStyle(
                          color: Theme.of(context).accentColor,
                          // color: Colors.deepPurple,
                          fontSize: 16.0),
                      //'Country Code',
                      suffixIcon: Icon(
                        Icons.add_location,
                        size: 25,
                        color: Theme.of(context).accentColor,
                        // color: Colors.deepPurple,
                      )
                  ),
                ),
                suggestionsBoxDecoration: SuggestionsBoxDecoration(elevation: 2.0),
                onSuggestionSelected: (CountryCode suggestion) {
                  // if (suggestion.countryCode == null &&
                  //     suggestion.countryName == null) {
                  //   return
                  //     S.of(context).WrongAWBNumber;
                  //   //'Worong AWB Number';
                  // } else {
                    this.CustomsCountryCode.text = suggestion.countryCode;
                    _fhlModel.customsSecurityCountryCode= suggestion.countryCode;
                //  }
                },

                // onSuggestionSelected: (CountryCode suggestion) {
                //
                //   this.shipperContact.text = suggestion.countryCode;
                //   model.shipperCountryCode = suggestion.countryCode;
                //   //print(origin);
                // }
              ),
              // child: TextFormField(
              //   initialValue: model.shipperCountryCode,
              //   // focusNode: _shipperPlaceFocusNode,
              //   maxLength: 3,
              //   textInputAction: TextInputAction.next,
              //   //keyboardType: TextInputType.number,

              //   onFieldSubmitted: (value) {
              //     // _fieldFocusChange(
              //     //     context, _shipperNameFocusNode, _shipperAddressFocusNode);
              //   },
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(
              //         gapPadding: 2.0,
              //         borderRadius: BorderRadius.all(Radius.circular(8.0))),
              //     labelText: 'Country Code',
              //   ),
              //   onChanged: (text) {
              //     // model.setshipperName(text);
              //     model.shipperCountryCode = text;
              //   },
              // ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
            //   child: TextFormField(
            //     keyboardType: TextInputType.text,
            //     inputFormatters: [AllCapitalCase()],
            //     maxLength: 2,
            //     enabled: !widget.isView,
            //     initialValue: widget.houseDetails[0]["CustomsSecurity"][0]
            //     ["countryCode"],
            //     onChanged: (value) {
            //       _fhlModel.customsSecurityCountryCode = value;
            //     },
            //     decoration: InputDecoration(
            //         enabledBorder: OutlineInputBorder(
            //           borderSide:
            //           BorderSide(color: Theme.of(context).accentColor),
            //           borderRadius: BorderRadius.all(Radius.circular(8.0)),
            //         ),
            //         //border: InputBorder.none,
            //         focusedBorder: OutlineInputBorder(
            //           borderSide:
            //           BorderSide(color: Theme.of(context).accentColor),
            //           borderRadius: BorderRadius.all(Radius.circular(8.0)),
            //         ),
            //         border: OutlineInputBorder(
            //             gapPadding: 2.0,
            //             borderRadius: BorderRadius.all(Radius.circular(8.0))),
            //         labelText: S.of(context).CountryCode,
            //         labelStyle: TextStyle(color: Theme.of(context).accentColor),
            //         suffixIcon: Icon(
            //           Icons.add_location,
            //           color: Theme.of(context).accentColor,
            //           // color: Colors.deepPurple,
            //         )
            //       //'Country Code',
            //     ),
            //   ),
            // ),

            // ! customsSecurityInfoIdentifier....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                inputFormatters: [AllCapitalCase()],
                maxLength: 3,
                enabled: !widget.isView,
                initialValue: widget.houseDetails[0]["CustomsSecurity"][0]
                ["informationIdentifier"],
                onChanged: (value) {
                  _fhlModel.customsSecurityInfoIdentifier = value;

                },
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).InfoIdentifier,
                    labelStyle: TextStyle(color: Theme.of(context).accentColor)
             ,  suffixIcon: Icon(
                  Icons.info,
                  color: Theme.of(context).accentColor,
                  //color: Colors.deepPurple,
                )
                  //'Info Identifier',
                ),
              ),
            ),

            // ! customsSecurityCSRCIdentifier....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                inputFormatters: [AllCapitalCase()],
                maxLength: 3,
                enabled: !widget.isView,
                initialValue: widget.houseDetails[0]["CustomsSecurity"][0]
                ["csrcIdentifier"],
                onChanged: (value) {
                  _fhlModel.customsSecurityCSRCIdentifier = value;

                },
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).CSRCIdentifier,
                    labelStyle: TextStyle(color: Theme.of(context).accentColor)
                    ,suffixIcon: Icon(
                  Icons.monitor_weight_outlined,
                  color: Theme.of(context).accentColor,
                  // color: Colors.deepPurple,
                )
                  //'CSRC Identifier',
                ),
              ),
            ),

            // ! customsSecuritySCSRCIdentifier....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                inputFormatters: [AllCapitalCase()],
                enabled: !widget.isView,
                initialValue: widget.houseDetails[0]["CustomsSecurity"][0]
                ["scsrcInformation"],
                onChanged: (value) {
                  _fhlModel.customsSecuritySCSRCIdentifier = value;

                },
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).SCSRCIdentifier+"*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor)
                    , suffixIcon: Icon(
                  Icons.monitor_weight_outlined,
                  color: Theme.of(context).accentColor,
                  // color: Colors.deepPurple,
                )
                  //'SCSRC Identifier',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuantityDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Text(
                S.of(context).QuantityDetails+"*",
                //"Quantity Details",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  //decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
            ),

            // ! _fhlModel.quantityDetailsPieces....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                enabled: !widget.isView,
                initialValue: widget.houseDetails[0]["pieces"].toString(),
                onChanged: (value) {
                  _fhlModel.quantityDetailsPieces = value;
                },
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).Pieces+"*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    suffixIcon: Icon(
                      Icons.production_quantity_limits,
                      color: Theme.of(context).accentColor,
                      // color: Colors.deepPurple,
                    )
                  //'Pieces',
                ),
              ),
            ),

            // ! houseDetailsOrigin, houseDetailsDestination....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Row(
                children: [
                  // ! _fhlModel.quantityDetailsWeight....
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      enabled: !widget.isView,
                      initialValue: widget.houseDetails[0]["weight"].toString(),
                      onChanged: (value) {
                        _fhlModel.quantityDetailsWeight = value;
                      },
                      decoration: InputDecoration(

                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor),
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0)),
                          ),
                          //border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor),
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0)),
                          ),
                          border: OutlineInputBorder(
                              gapPadding: 2.0,
                              borderRadius:
                              BorderRadius.all(Radius.circular(8.0))),
                          labelText: S.of(context).Weight+"*",
                          labelStyle:
                          TextStyle(color: Theme.of(context).accentColor),
                          suffixIcon: Icon(
                            Icons.monitor_weight,
                            color: Theme.of(context).accentColor,
                            // color: Colors.deepPurple,
                          )
                        //'Weight',
                      ),
                    ),
                    flex: 7,
                  ),
                  // ! houseDetailsDestination....
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: !widget.isView
                          ? DropdownButton<String>(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(context).accentColor,
                          ),
                          value: _fhlModel.quantityDetailsWeightUnit,
                          items: [
                            'K',
                            'L'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              ),
                            );
                          }).toList(),
                          onChanged: (String text) {
                            setState(() {
                              _fhlModel.quantityDetailsWeightUnit = text;
                           });
                          })
                          : Text(
                        widget.houseDetails[0]["weightCode"],
                        style: TextStyle(
                            color: Theme.of(context).accentColor),
                      ),
                    ),
                    flex: 3,
                  ),
                ],
              ),
            ),

            // ! houseDetailsDescription...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                enabled: !widget.isView,
                initialValue: widget.houseDetails[0]["SLAC"].toString(),
                onChanged: (value) {
                  _fhlModel.quantityDetailsSLAC = value;
               },
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).SLAC,
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    suffixIcon: Icon(
                      Icons.monitor_weight,
                      color: Theme.of(context).accentColor,
                      // color: Colors.deepPurple,
                    )
                  //'SLAC',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHouseDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Text(
                S.of(context).HouseDetails,
                // "House Details",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  //decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
            ),

            // ! houseDetailsNumber....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                inputFormatters: [AllCapitalCase()],
                keyboardType: TextInputType.text,
                maxLength: 12,
                enabled: !widget.isView,
                initialValue: widget.houseDetails[0]["serialNumber"],
                onChanged: (value) {

                  _fhlModel.houseDetailsNumber = widget.houseDetails[0]["serialNumber"];
                  _fhlModel.houseDetailsNumber = value;
                },
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).HouseNumber+"*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor)
                  ,   suffixIcon: Icon(
                  Icons.flight,
                  color: Theme.of(context).accentColor,
                  //color: Colors.deepPurple,
                )
                  //'House Number',
                ),
              ),
            ),

            // ! houseDetailsOrigin, houseDetailsDestination....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Row(
                children: [
                  // ! houseDetailsOrigin....
                  Expanded(
                    child: originTF(),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  // ! houseDetailsDestination....
                  Expanded(
                    child: destinationTF(),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                inputFormatters: [AllCapitalCase()],
                keyboardType: TextInputType.text,
                maxLength: 12,
                enabled: !widget.isView,
                initialValue: widget.houseDetails[0]["description"],
                onChanged: (value) {
                  _fhlModel.houseDetailsNatureGoods = value;
               },
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).NatureOfGoods+"*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor)
                  ,suffixIcon: Icon(
                  Icons.monitor_weight,
                  color: Theme.of(context).accentColor,
                  //color: Colors.deepPurple,
                )
                  //'Nature Of Goods',
                ),
              ),
            ),

            // ! houseDetailsDescription...

            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                inputFormatters: [AllCapitalCase()],
                enabled: !widget.isView,
                initialValue: widget.houseDetails[0]["Extended_description"],
                onChanged: (value) {
                  _fhlModel.houseDetailsDescription = value;
                },
                maxLines: 8,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    labelText: S.of(context).Description,
                    labelStyle: TextStyle(color: Theme.of(context).accentColor)
                    ,suffixIcon: Icon(
                  Icons.monitor_weight,
                  color: Theme.of(context).accentColor,
                  //color: Colors.deepPurple,
                )

                  //'Description',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  destinationTF() {

        this.edithouseDestination.text = widget.houseDetails[0]["destination"];

    return TypeAheadField<AirportCode>(
        suggestionsCallback: AirportApi.getAirportCode,
        itemBuilder: (context, AirportCode suggestion) {
          final code = suggestion;
          return ListTile(
            title: Text(
              code.airportCode,
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            subtitle: Text(code.airportName),
          );
        },
        textFieldConfiguration: TextFieldConfiguration(
          inputFormatters: [AllCapitalCase()],
          controller: this.edithouseDestination,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              border: OutlineInputBorder(
                  gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText: S.of(context).Destination+"*",
              labelStyle: TextStyle(color: Theme.of(context).accentColor),
              suffixIcon: Icon(
                Icons.flight_land,
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
              )
            //'Destination',
          ),
        ),
        onSuggestionSelected: (AirportCode suggestion) {
          this.edithouseDestination.text = suggestion.airportCode;
          _fhlModel.houseDetailsDestination = suggestion.airportCode;
          //
        });
  }

  originTF() {

    this.edithouseOrigin.text = widget.houseDetails[0]["origin"];

    return TypeAheadField<AirportCode>(
        suggestionsCallback: AirportApi.getAirportCode,
        itemBuilder: (context, AirportCode suggestion) {
          final code = suggestion;
          return ListTile(
            title: Text(
              code.airportCode,
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            subtitle: Text(
              code.airportName,
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          );
        },
        textFieldConfiguration: TextFieldConfiguration(
          inputFormatters: [AllCapitalCase()],
          controller: this.edithouseOrigin,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              border: OutlineInputBorder(
                  gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText: S.of(context).Origin+"*",
              labelStyle: TextStyle(color: Theme.of(context).accentColor)
            ,suffixIcon: Icon(
            Icons.flight_takeoff,
            color: Theme.of(context).accentColor,
            // color: Colors.deepPurple,
          )

            //'Origin',
          ),
        ),
        onSuggestionSelected: (AirportCode suggestion) {
          this.edithouseOrigin.text = suggestion.airportCode;
          _fhlModel.houseDetailsOrigin = suggestion.airportCode;
          //
        });
  }

  void Scontactdelete(String title) {
    setState(() {
      expenseList
          .removeWhere((element) => element.Shipper_Contact_Detail == title);
    });
  }

  Future<String> _showDialogContact() => showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Stack(children: [
        Text(
          S.of(context).AddMobileNumber,
          // "Add Mobile Number",
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
      ]),
      content: Form(
        key: _ContactKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TypeAheadField<ContactType>(
                suggestionsCallback: ContacTypeApi.getContactType,
                itemBuilder: (context, ContactType suggestion) {
                  final code = suggestion;
                  return ListTile(
                    title: Text(code.contactType,
                        style: TextStyle(
                            color: Theme.of(context).accentColor)),
                    subtitle: Text(code.contactCode,
                        style: TextStyle(
                            color: Theme.of(context).accentColor)),
                  );
                },
                textFieldConfiguration: TextFieldConfiguration(
                  controller: contype,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).accentColor),
                        borderRadius:
                        BorderRadius.all(Radius.circular(8.0)),
                      ),
                      //border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).accentColor),
                        borderRadius:
                        BorderRadius.all(Radius.circular(8.0)),
                      ),
                      border: OutlineInputBorder(
                          gapPadding: 2.0,
                          borderRadius:
                          BorderRadius.all(Radius.circular(8.0))),
                      labelText:
                      S.of(context).Type,
                      //"Type",
                      //S.of(context).Origin,
                      labelStyle:
                      TextStyle(color: Theme.of(context).accentColor)
                    //'Origin',
                  ),
                ),
                onSuggestionSelected: (ContactType suggestion) {
                  List.generate(
                      sippercontactList.length,
                          (index) => sippercontactList[index]
                      ['Shipper_Contact_Type'] =
                          suggestion.contactCode);
                  // sippercontactList[index]['Shipper_Contact_Type'] =
                  //     suggestion.contactCode;
                  contype.text = suggestion.contactType;
                  //_fhlModel.houseDetailsOrigin = suggestion.airportCode;
                  //
                }),
            SizedBox(
              height: 10,
            ),
            contype.text == "Email"
                ? TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).accentColor),
                  borderRadius:
                  BorderRadius.all(Radius.circular(10.0)),
                ),
                //border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).accentColor),
                  borderRadius:
                  BorderRadius.all(Radius.circular(10.0)),
                ),
                labelText:
                S.of(context).EmailId,
                //"Email",
                labelStyle:
                TextStyle(color: Theme.of(context).accentColor),
                hintText:
                S.of(context).Enteremail,
                //"Enter the Email"
              ),
              controller: Telecontroller,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return
                    S.of(context).Pleaseentertheemailaddress;
                  //'Please enter the email address';
                }
                return null;
              },
            )
                : Container(
                child: IntlPhoneField(
                  //controller: Telecontroller,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor),
                      // borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor),
                      // borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),

                    //decoration for Input Field
                    labelText:
                    S.of(context).PhoneNumber,
                    //'Phone Number',
                    labelStyle:
                    TextStyle(color: Theme.of(context).accentColor),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode:
                  'IN', //default contry code, NP for Nepal
                  onChanged: (phone) {
                    setState(() {
                      Telecontroller.text = phone.completeNumber;
                    });
                    //   //when phone number country code is changed
                    //   print(phone.completeNumber); //get complete number
                    //   print(phone.countryCode); // get country code only
                    //   print(phone.number); // only phone number
                  },
                )),
            // TextFormField(
            //   // initialValue: mailList[dimensionIndex]
            //   // ['Shipper_Contact_Detail'] ==
            //   //     0.0
            //   //     ? ''
            //   //     : '${mailList[dimensionI
            //   //     ndex]}',
            //   // onChanged: (value) {
            //   //   setState(() {
            //   //     mailList[dimensionIndex]=
            //   //         value;
            //   //   });
            //   // },
            //   autofocus: true,
            //   decoration: InputDecoration(hintText: "Enter the Tele"),
            //   controller: Telecontroller,
            //   keyboardType: TextInputType.phone,
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter the Number';
            //     }
            //     return null;
            //   },
            // ),

            // DropdownButton<String>(
            //   hint: Text("type"),
            //   value: _Teletype,
            //   items: <String>['Whatsapp',
            //     'Telegram',
            //     'Fax',]
            //       .map((String value) {
            //     return new DropdownMenuItem<String>(
            //       value: value,
            //       child: new Text(value),
            //     );
            //   }).toList(),
            //   onChanged: (String val) {
            //     setState(() {
            //       _Teletype = val;
            //     });
            //   },
            // ),
          ],
        ),
      ),
      actions: [
        TextButton(
            child: Text(
              S.of(context).Cancel,
              // 'Cancel',
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        TextButton(
            onPressed: () {
              if (_ContactKey.currentState.validate()) {
                addTele(Telecontroller.text, contype.text
                  // _Teletype
                  //Teletypecontroller.text
                );
                Navigator.pop(context);
              }
              Telecontroller.clear();
              contype.clear();
              // Navigator.of(context).pop(Emailcontroller.text);
              // Emailcontroller.clear();
            },
            child: Text(

              S.of(context).Submit,
              // "Submit",
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            )),
      ],
    ),
  );

  void addTele(String TeleNumber, String Tdescription) {
    final expense = ShipperExpenseList(
      Shipper_Contact_Type: Tdescription,
      Shipper_Contact_Detail: TeleNumber,
    );
    setState(() {
      expenseList.add(expense);
    });
  }

  void addConsignee(String TeleNumber, String Tdescription) {
    final expense = ConsigneeExpenseList(
      Consignee_Contact_Type: Tdescription,
      Consignee_Contact_Detail: TeleNumber,
    );
    setState(() {
      expenseL.add(expense);
    });
  }

  //Consignee..
  void Consigneecontactdelete(String title) {
    setState(() {
      expenseL
          .removeWhere((element) => element.Consignee_Contact_Detail == title);
    });
  }

  Future<String> _showConsigneeContactDialog() => showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Stack(children: [
        Text(
          S.of(context).AddConsigneeNumber,
          //"Add Consignee Number",
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
      ]),
      content: Form(
        key: _consigneeContactkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TypeAheadField<ContactType>(
                suggestionsCallback: ContacTypeApi.getContactType,
                itemBuilder: (context, ContactType suggestion) {
                  final code = suggestion;
                  return ListTile(
                    title: Text(code.contactType,
                        style: TextStyle(
                            color: Theme.of(context).accentColor)),
                    subtitle: Text(code.contactCode,
                        style: TextStyle(
                            color: Theme.of(context).accentColor)),
                  );
                },
                textFieldConfiguration: TextFieldConfiguration(
                  controller: Consigneecontype,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).accentColor),
                        borderRadius:
                        BorderRadius.all(Radius.circular(8.0)),
                      ),
                      //border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).accentColor),
                        borderRadius:
                        BorderRadius.all(Radius.circular(8.0)),
                      ),
                      border: OutlineInputBorder(
                          gapPadding: 2.0,
                          borderRadius:
                          BorderRadius.all(Radius.circular(8.0))),
                      labelText:

                      //"Type",
                      S.of(context).Type,
                      labelStyle:
                      TextStyle(color: Theme.of(context).accentColor)
                    //'Origin',
                  ),
                ),
                onSuggestionSelected: (ContactType suggestion) {
                  List.generate(
                      consigneecontactList.length,
                          (index) => consigneecontactList[index]
                      ['Consignee_Contact_Type'] =
                          suggestion.contactCode);
                  // sippercontactList[index]['Shipper_Contact_Type'] =
                  //     suggestion.contactCode;
                  Consigneecontype.text = suggestion.contactType;
                  //_fhlModel.houseDetailsOrigin = suggestion.airportCode;
                  //
                }),
            SizedBox(
              height: 10,
            ),
            Consigneecontype.text == "Email"
                ? TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor),
                    borderRadius:
                    BorderRadius.all(Radius.circular(10.0)),
                  ),
                  //border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor),
                    borderRadius:
                    BorderRadius.all(Radius.circular(10.0)),
                  ),
                  labelText:
                  S.of(context).EmailId,
                  //"Email",
                  labelStyle:
                  TextStyle(color: Theme.of(context).accentColor),
                  hintText:
                  S.of(context).Enteremail
                //    "Enter the Email"
              ),
              controller: Consigneecontact,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return
                    S.of(context).Pleaseentertheemailaddress;
                  //'Please enter the email address';
                }
                return null;
              },
            )
                : Container(
                child: IntlPhoneField(
                  //controller: Consigneecontact,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor),
                      // borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor),
                      // borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),

                    //decoration for Input Field
                    labelText:
                    S.of(context).PhoneNumber,
                    //'Phone Number',
                    labelStyle:
                    TextStyle(color: Theme.of(context).accentColor),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode:
                  'IN', //default contry code, NP for Nepal
                  onChanged: (phone) {
                    setState(() {
                      Consigneecontact.text = phone.completeNumber;
                    });
                    //   //when phone number country code is changed
                    //   print(phone.completeNumber); //get complete number
                    //   print(phone.countryCode); // get country code only
                    //   print(phone.number); // only phone number
                  },
                )),
          ],
        ),
      ),
      actions: [
        TextButton(
            child: Text(

              S.of(context).Cancel,
              //'Cancel',
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        TextButton(
            onPressed: () {
              if (_consigneeContactkey.currentState.validate()) {
                addConsignee(Consigneecontact.text, Consigneecontype.text
                  // _Teletype
                  //Teletypecontroller.text
                );
                Navigator.pop(context);
              }
              Consigneecontact.clear();
              Consigneecontype.clear();
              // Navigator.of(context).pop(Emailcontroller.text);
              // Emailcontroller.clear();
            },
            child: Text(
              S.of(context).Submit,
              // "Submit",
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            )),
      ],
    ),
  );
}




// destinationTF() {
//   GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
//   String currentText = "";
//   return SimpleAutoCompleteTextField(
//     decoration: InputDecoration(
//       border: OutlineInputBorder(
//           gapPadding: 2.0,
//           borderRadius: BorderRadius.all(Radius.circular(8.0))),
//       labelText: 'Destination',
//     ),
//     suggestions: StringData.airportCode,
//     textChanged: (text) => currentText = text,
//     clearOnSubmit: true,
//     controller:
//         TextEditingController(text: widget.houseDetails[0]["destination"]),
//     textSubmitted: (text) => setState(() {
//       if (text != "") {
//         _fhlModel.houseDetailsDestination = text;
//         //print(destination);
//       }
//     }),
//     key: key,
//   );
// }

// originTF() {
//   GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
//   String currentText = "";
//   return SimpleAutoCompleteTextField(
//     decoration: InputDecoration(
//       border: OutlineInputBorder(
//           gapPadding: 2.0,
//           borderRadius: BorderRadius.all(Radius.circular(8.0))),
//       labelText: 'Origin',
//     ),
//     suggestions: StringData.airportCode,
//     textChanged: (text) => currentText = text,
//     clearOnSubmit: true,
//     controller: TextEditingController(text: widget.houseDetails[0]["origin"]),
//     textSubmitted: (text) => setState(() {
//       if (text != "") {
//         _fhlModel.houseDetailsOrigin = text;
//         currentText = text;
//         print(_fhlModel.houseDetailsOrigin);
//       }
//     }),
//     key: key,
//   );
// }

