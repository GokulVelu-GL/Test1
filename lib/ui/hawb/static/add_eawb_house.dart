// import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:rooster/formatter.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/fhl_model.dart';
import 'package:rooster/model/fhl_models/fhl_consignee_model.dart';
import 'package:rooster/model/fhl_models/fhl_shipper_model.dart';
import 'package:rooster/string.dart';
import 'package:rooster/ui/drodowns/special_code.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../drodowns/airport_code.dart';
import '../../drodowns/airport_code.dart';
import '../../drodowns/airport_code.dart';
import '../../drodowns/airport_code.dart';
import '../../drodowns/airport_code.dart';
import '../../drodowns/country_code.dart';

class AddEawb extends StatefulWidget {
  final FHLModel fhlModel;
  final bool isView;
  var awbid;
  var houselist;

  AddEawb({this.fhlModel, @required this.isView, this.awbid, this.houselist});

  @override
  _AddEawbState createState() => _AddEawbState();
}

class _AddEawbState extends State<AddEawb> {
  final _addFHLHousesFormKey = new GlobalKey<FormState>();
  FHLModel _fhlModel;
  final TextEditingController ShipperCountryCode = TextEditingController();
  final TextEditingController ConsigneeCountryCode = TextEditingController();
  final TextEditingController RateCurrencyCode = TextEditingController();
  final TextEditingController CustomsCountryCode = TextEditingController();

  final TextEditingController houseOrigin = TextEditingController();
  final TextEditingController houseDestination = TextEditingController();
  final TextEditingController natureofgoodscontroller = TextEditingController();
  final TextEditingController DescriptionController = TextEditingController();

  //QuantityDetails
  final TextEditingController QuantityDetailsPiecesController =
      TextEditingController();
  final TextEditingController QuantityDetailsWeightController =
      TextEditingController();
  final TextEditingController QuantityDetailsSLACController =
      TextEditingController();

  final TextEditingController CustomsSecurityCountryCodeController =
      TextEditingController();
  final TextEditingController CustomsSecurityInfoIdentifierController =
      TextEditingController();
  final TextEditingController CustomsSecurityCSRCController =
      TextEditingController();
  final TextEditingController CustomsSecuritySCSRCController =
      TextEditingController();

  final TextEditingController ChargeDeclarationWeightValueController =
      TextEditingController();
  final TextEditingController ChargeDeclarationOtherChargesController =
      TextEditingController();
  final TextEditingController ChargeDeclarationCarriageValueController =
      TextEditingController();
  final TextEditingController ChargeDeclarationCustomsValueController =
      TextEditingController();
  final TextEditingController ChargeDeclarationInsuranceValueController =
      TextEditingController();

  final TextEditingController ShipperNameController = TextEditingController();
  final TextEditingController ShipperAddressController =
      TextEditingController();
  final TextEditingController ShipperPlaceController = TextEditingController();
  final TextEditingController ShipperPostcodeController =
      TextEditingController();
  final TextEditingController ShipperStateController = TextEditingController();

  final TextEditingController ConsigneeNameController = TextEditingController();
  final TextEditingController ConsigneeAddressController =
      TextEditingController();
  final TextEditingController ConsigneePlaceController =
      TextEditingController();
  final TextEditingController ConsigneePostcodeController =
      TextEditingController();
  final TextEditingController ConsigneeStateController =
      TextEditingController();

  // RateDescriptionItem list;
  List<Map<String, dynamic>> sippercontactList = [];
  List<Map<String, dynamic>> consigneecontactList = [];
  List<Map<String, dynamic>> specialCodeList = [];
  List<Map<String, dynamic>> hormoCodeList = [];
  final List<ShipperExpenseList> expenseList = [];
  final List<ConsigneeExpenseList> expenseL = [];
  final _ContactKey = GlobalKey<FormState>();
  String qDetailsPieces;
  final _consigneeContactkey = GlobalKey<FormState>();
  bool isLoaded = false;
  String Shipperflag;
  String Consigneeflag;

  TextEditingController Consigneecontype = new TextEditingController();
  TextEditingController Consigneecontact = new TextEditingController();
  TextEditingController houseDetailsNumberController =
      new TextEditingController();
  TextEditingController contype = new TextEditingController();

  TextEditingController Telecontroller = new TextEditingController();
  String flag;

  @override
  void initState() {
    _fhlModel = widget.fhlModel ?? new FHLModel();
    _fhlModel.houseDetailsNumber = "AGL1649";
    // ! Information....
    // pieces = widget.pieces ?? 0;
    // grossWeight = widget.grossWeight ?? 0;
    // grossWeightUnit = widget.grossWeightUnit ?? 'K';
    // rateClass = widget.rateClass ?? 'M';
    // itemNumber = widget.itemNumber ?? 0;
    // chargeableWeight = widget.chargeableWeight ?? 0;
    // rateCharge = widget.rateCharge ?? 0;
    // total = widget.total ?? 0;
    // autoCalculations = widget.autoCalculations ?? 'No';

    // // ! Nature and quantity of goods....
    // natureAndQuantity = widget.natureAndQuantity ?? '';
    // sippercontactList = widget.sippercontactList ?? new List<Map<String, dynamic>>();

    // // ! Extra description....
    // text = widget.text ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FHLModel>(builder: (context, model, child) {
      this.ShipperCountryCode.text = _fhlModel.shipperCode;
      this.ConsigneeCountryCode.text = _fhlModel.consigneeCode;
      this.CustomsCountryCode.text = _fhlModel.customsSecurityCountryCode;

      return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              S.of(context).AddHouse,
              //  "Add House"
            ),
            actions: <Widget>[
              IconButton(
                color: Theme.of(context).backgroundColor,
                onPressed: () {
                  showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: MaterialLocalizations.of(context)
                          .modalBarrierDismissLabel,
                      barrierColor: Colors.black45,
                      transitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (BuildContext buildContext,
                          Animation animation, Animation secondaryAnimation) {
                        return SafeArea(
                          child: Scaffold(
                            appBar: AppBar(
                              backgroundColor: Theme.of(context).primaryColor,
                              title: Text("Help"),
                              centerTitle: true,
                            ),
                            body: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 20),
                                  Text(
                                    "House Details",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.flight,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Airline Prefix"),
                                      subtitle: Text(
                                          "Coded representation of an airline\nExample: 176"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.flight,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("AWB Serial Number"),
                                      subtitle: Text(
                                          "A serial number allocated by an airline to identify a particular air cargo shipment and the associated Air Waybill\nExample: 01122474 "),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.flight_takeoff_sharp,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Origin and destination"),
                                      subtitle: Text(
                                          "Coded representation of a specific airport/city code \nExample: MLE"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.production_quantity_limits,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Nature of Goods"),
                                      subtitle: Text(
                                          "Description of the goods \nExample: Laptop"),
                                    ),
                                  ),
                                  Text(
                                    "Quantity Details",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.production_quantity_limits,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Pieces"),
                                      subtitle: Text(
                                          "Number of Loose Items and/or ULD’s as accepted for carriage\nExample: 8"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.monitor_weight,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Weight"),
                                      subtitle: Text(
                                          "Weight measure\nExample: 140.0"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.monitor_weight,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("WeightUnit"),
                                      subtitle:
                                          Text("Weight measure\nExample: K"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.monitor_weight,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("SLAC"),
                                      subtitle: Text(
                                          "Shippers load count. It's their own total count of number of pieces inside each pieces (like one pencil box contains 10 pencil)"),
                                    ),
                                  ),
                                  Text(
                                    "Customs Security",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.add_location,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Country Code"),
                                      subtitle: Text(
                                          "Coded representation of a country approved by ISO\nExample: IN"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.info,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Information Identifier"),
                                      subtitle: Text(
                                          "Code identifying a particular group of data elements\nExample: CNE"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.monitor_weight,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text(
                                          "Customs, Security and Regulatory Control Information Identifier"),
                                      subtitle: Text(
                                          "Coded indicator qualifying Customs, Security and Regulatory Control related information\nExample: A"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.monitor_weight,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text(
                                          "Supplementary Customs, Security and Regulatory Control Information"),
                                      subtitle: Text(
                                          "Supplementary information identifying a party or a location related to Customs, Security and Regulatory Control reporting requirements.\nmax length:35 \nExample: BCBP123"),
                                    ),
                                  ),
                                  Text(
                                    "Charge Declaration",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.money,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Currency Code"),
                                      subtitle: Text(
                                          "Coded representation of a currency approved by ISO \nExample: GBP"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.money,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Weight Value"),
                                      subtitle: Text(
                                          "Code indicating whether payment will be made at origin (prepaid) or at destination (collect)\nExample: P"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.money,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Other Charges"),
                                      subtitle: Text(
                                          "Code indicating whether payment will be made at origin (prepaid) or at destination (collect)\nExample: P"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.money,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Carriage Value"),
                                      subtitle: Text(
                                          "The value of a shipment declared for carriage purposes\nExample: 100.00 or No Value Declared (NVD)"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.money,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Insurance Value"),
                                      subtitle: Text(
                                          "The value of a shipment for insurance purposes\nExample: 100.00 or No Customs Value (NCV)"),
                                    ),
                                  ),
                                  Text(
                                    "Shipper",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.switch_account,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Account Number"),
                                      subtitle: Text(
                                          "Coded identification of a participant\nExample: ABC94269 "),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.contacts_rounded,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Name"),
                                      subtitle: Text(
                                          "Identification of individual or company involved in the movement of a consignment\nExample: ACE SHIPPING CO. "),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.add_location,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Country Code"),
                                      subtitle: Text(
                                          "Coded representation of a country approved by ISO\nExample: INR"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.my_location,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Address"),
                                      subtitle: Text(
                                          "Street address of individual or company involved in the movement of a consignment\nExample: WIGMORE STREET"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.place,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("State"),
                                      subtitle: Text(
                                          "Part of a country of an individual or company involved  in the movement of a consignment\nExample: QUE"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.code,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Post Code"),
                                      subtitle: Text(
                                          "Code allocated by national postal authority to identify location for mail delivery purposes\nExample: H3A 2R4"),
                                    ),
                                  ),
                                  Text(
                                    "Consignee",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.switch_account,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Account Number"),
                                      subtitle: Text(
                                          "Coded identification of a participant\nExample: ABC94269 "),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.contacts_rounded,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Name"),
                                      subtitle: Text(
                                          "Identification of individual or company involved in the movement of a consignment\nExample: ACE SHIPPING CO. "),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.add_location,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Country Code"),
                                      subtitle: Text(
                                          "Coded representation of a country approved by ISO\nExample: INR"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.my_location,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Address"),
                                      subtitle: Text(
                                          "Street address of individual or company involved in the movement of a consignment\nExample: WIGMORE STREET"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.place,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("State"),
                                      subtitle: Text(
                                          "Part of a country of an individual or company involved  in the movement of a consignment\nExample: QUE"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.code,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Post Code"),
                                      subtitle: Text(
                                          "Code allocated by national postal authority to identify location for mail delivery purposes\nExample: H3A 2R4"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                icon: Icon(
                  Icons.help,
                  color: Theme.of(context).backgroundColor,
                ),
              ),
              //IconButton(onPressed: () {}, icon: Icon(Icons.menu_open)),
              PopupMenuButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  elevation: 10,
                  itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          child: Column(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    // Navigator.pop(context);//popping the dialog after data is fetched
                                    print("1");
                                    print(_fhlModel.houseDetailsNumber);

                                    //   _fhlModel.notifyListeners();
                                    setState(() {
                                      // model.houseDetailsNumber="AJKL";
                                      //  this._fhlModel.houseDetailsNumber= "AGL1649";
                                      this.houseDetailsNumberController.text =
                                          "AGL1649";
                                      _fhlModel.houseDetailsNumber = this
                                          .houseDetailsNumberController
                                          .text;

                                      this.houseOrigin.text = "DEL";
                                      _fhlModel.houseDetailsOrigin =
                                          this.houseOrigin.text;

                                      this.houseDestination.text = "HAN";
                                      _fhlModel.houseDetailsDestination =
                                          this.houseDestination.text;

                                      this.natureofgoodscontroller.text =
                                          "LAPTOP";
                                      _fhlModel.houseDetailsNatureGoods =
                                          this.natureofgoodscontroller.text;

                                      this.DescriptionController.text =
                                          "HANDLE WITH CARE";
                                      _fhlModel.houseDetailsDescription =
                                          this.DescriptionController.text;

                                      this
                                          .QuantityDetailsPiecesController
                                          .text = "10";
                                      _fhlModel.quantityDetailsPieces = this
                                          .QuantityDetailsPiecesController
                                          .text;

                                      this
                                          .QuantityDetailsWeightController
                                          .text = "100";
                                      _fhlModel.quantityDetailsWeight = this
                                          .QuantityDetailsWeightController
                                          .text;

                                      this.QuantityDetailsSLACController.text =
                                          "10";
                                      _fhlModel.quantityDetailsSLAC = this
                                          .QuantityDetailsSLACController
                                          .text;

                                      this.CustomsCountryCode.text = "IN";
                                      _fhlModel.customsSecurityCountryCode =
                                          this.CustomsCountryCode.text;

                                      print(CustomsCountryCode.text);
                                      this
                                          .CustomsSecurityInfoIdentifierController
                                          .text = "SD";
                                      _fhlModel.customsSecurityInfoIdentifier = this
                                          .CustomsSecurityInfoIdentifierController
                                          .text;

                                      this.CustomsSecurityCSRCController.text =
                                          "ED";
                                      _fhlModel.customsSecurityCSRCIdentifier =
                                          this
                                              .CustomsSecurityCSRCController
                                              .text;

                                      this.CustomsSecuritySCSRCController.text =
                                          "ED";
                                      _fhlModel.customsSecuritySCSRCIdentifier =
                                          this
                                              .CustomsSecuritySCSRCController
                                              .text;

                                      this.RateCurrencyCode.text = "VND";
                                      _fhlModel.chargeDeclarationCurrencyCode =
                                          this.RateCurrencyCode.text;

                                      this
                                          .ChargeDeclarationWeightValueController
                                          .text = "P";
                                      _fhlModel.chargeDeclarationWeightValue = this
                                          .ChargeDeclarationWeightValueController
                                          .text;

                                      this
                                          .ChargeDeclarationOtherChargesController
                                          .text = "P";
                                      _fhlModel.chargeDeclarationOtherCharges = this
                                          .ChargeDeclarationOtherChargesController
                                          .text;

                                      this
                                          .ChargeDeclarationCarriageValueController
                                          .text = "10";
                                      _fhlModel.chargeDeclarationCarriageValue =
                                          this
                                              .ChargeDeclarationCarriageValueController
                                              .text;

                                      this
                                          .ChargeDeclarationCustomsValueController
                                          .text = "10";
                                      _fhlModel.chargeDeclarationCustomsValue = this
                                          .ChargeDeclarationCustomsValueController
                                          .text;

                                      this
                                          .ChargeDeclarationInsuranceValueController
                                          .text = "10";
                                      _fhlModel
                                              .chargeDeclarationInsuranceValue =
                                          this
                                              .ChargeDeclarationInsuranceValueController
                                              .text;

                                      this.ShipperNameController.text =
                                          "ABC94269";
                                      _fhlModel.shipperName =
                                          this.ShipperNameController.text;

                                      this.ShipperAddressController.text =
                                          "ACE SHIPPING CO";
                                      _fhlModel.shipperAddress =
                                          this.ShipperAddressController.text;

                                      this.ShipperStateController.text =
                                          "WIGMORE STREET";
                                      _fhlModel.shipperState =
                                          this.ShipperStateController.text;

                                      this.ShipperPlaceController.text = "QUE";
                                      _fhlModel.shipperPlace =
                                          this.ShipperPlaceController.text;

                                      this.ShipperCountryCode.text = "IN";
                                      _fhlModel.shipperCode =
                                          this.ShipperCountryCode.text;

                                      this.ShipperPostcodeController.text =
                                          "H3A284";
                                      _fhlModel.shipperPostCode =
                                          this.ShipperPostcodeController.text;

                                      this.ConsigneeNameController.text =
                                          "ABC94269";
                                      _fhlModel.consigneeName =
                                          this.ShipperPostcodeController.text;

                                      this.ConsigneeAddressController.text =
                                          "ACE SHIPPING CO";
                                      _fhlModel.consigneeAddress =
                                          this.ShipperPostcodeController.text;

                                      this.ConsigneePlaceController.text =
                                          "WIGMORE STREET";
                                      _fhlModel.consigneePlace =
                                          this.ShipperPostcodeController.text;

                                      this.ConsigneeStateController.text =
                                          "QUE";
                                      _fhlModel.consigneeState =
                                          this.ShipperPostcodeController.text;

                                      this.ConsigneeCountryCode.text = "VN";
                                      _fhlModel.consigneeCode =
                                          this.ShipperPostcodeController.text;

                                      this.ConsigneePostcodeController.text =
                                          "H3A284";
                                      _fhlModel.consigneePostCode =
                                          this.ShipperPostcodeController.text;

                                      specialCodeList = model.specialCode;
                                      loadHouseSampleData1(model);
                                      hormoCodeList = model.hormoCode;
                                      _fhlModel = model;
                                      isLoaded = true;
                                    });

                                    print(specialCodeList);
                                    // Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (BuildContext context) =>
                                    //             super.widget));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Row(children: [
                                      Icon(
                                        Icons.system_security_update,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      Text(
                                        S.of(context).HouseSampleData1,
                                        // "House Sample Data 1",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor),
                                        //S.of(context).SampleData1,
                                        // "Sample Data 1"
                                      )
                                    ]),
                                  )),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    this.houseDetailsNumberController.clear();

                                    this.houseDetailsNumberController.clear();
                                    this.houseOrigin.clear();
                                    this.houseDestination.clear();
                                    this.natureofgoodscontroller.clear();
                                    this.DescriptionController.clear();

                                    this
                                        .QuantityDetailsPiecesController
                                        .clear();
                                    this
                                        .QuantityDetailsWeightController
                                        .clear();
                                    this.QuantityDetailsSLACController.clear();

                                    this.CustomsCountryCode.clear();
                                    this
                                        .CustomsSecurityInfoIdentifierController
                                        .clear();
                                    this.CustomsSecurityCSRCController.clear();
                                    this.CustomsSecuritySCSRCController.clear();

                                    this.RateCurrencyCode.clear();
                                    this
                                        .ChargeDeclarationWeightValueController
                                        .clear();
                                    this
                                        .ChargeDeclarationOtherChargesController
                                        .clear();
                                    this
                                        .ChargeDeclarationCarriageValueController
                                        .clear();
                                    this
                                        .ChargeDeclarationCustomsValueController
                                        .clear();
                                    this
                                        .ChargeDeclarationInsuranceValueController
                                        .clear();

                                    this.ShipperNameController.clear();
                                    this.ShipperAddressController.clear();
                                    this.ShipperStateController.clear();
                                    this.ShipperPlaceController.clear();
                                    this.ShipperPostcodeController.clear();

                                    this.ConsigneeNameController.clear();
                                    this.ConsigneeAddressController.clear();
                                    this.ConsigneePlaceController.clear();
                                    this.ConsigneeStateController.clear();
                                    this.ConsigneePostcodeController.clear();

                                    isLoaded = false;
                                  });
                                },
                                child: Row(children: [
                                  Icon(
                                    Icons.clear,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  Text(
                                    // S.of(context).HouseSampleData1,
                                    "Clear Sample Data",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                    //S.of(context).SampleData1,
                                    // "Sample Data 1"
                                  )
                                ]),
                              )
                              // TextButton(
                              //     onPressed: () {
                              //       model.loadHouseSampleData1();
                              //       print(_fhlModel.houseDetailsNumber);
                              //       // notifyListeners();
                              //       setState(() {
                              //         specialCodeList = model.specialCode;
                              //         hormoCodeList = model.hormoCode;
                              //         _fhlModel = model;
                              //       });
                              //
                              //       print(specialCodeList);
                              //       // Navigator.pushReplacement(
                              //       //     context,
                              //       //     MaterialPageRoute(
                              //       //         builder: (BuildContext context) =>
                              //       //             super.widget));
                              //     },
                              //     child: Container(
                              //       decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(30.0),
                              //       ),
                              //       child: Row(children: [
                              //         Icon(
                              //           Icons.system_security_update,
                              //           color: Theme.of(context).accentColor,
                              //         ),
                              //         Text(
                              //           "House Sample Data 2",
                              //           style: TextStyle(
                              //               color: Theme.of(context).accentColor),
                              //           //S.of(context).SampleData1,
                              //           // "Sample Data 1"
                              //         )
                              //       ]),
                              //     )),
                            ],
                          ),
                        ),
                      ])
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _addFHLHousesFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ! _fhlModel.houseDetails....
                      buildHouseDetails(isLoaded),
                      // Divider(
                      //   thickness: 2,
                      //   indent: MediaQuery.of(context).size.width * 0.3,
                      //   endIndent: MediaQuery.of(context).size.width * 0.3,
                      // ),

                      // ! Special Requirements....
                      buildSpecialRequirements(),

                      // Divider(
                      //   thickness: 2,
                      //   indent: MediaQuery.of(context).size.width * 0.3,
                      //   endIndent: MediaQuery.of(context).size.width * 0.3,
                      // ),

                      // ! _fhlModel.qualityDetails....
                      buildQuantityDetails(isLoaded),
                      // Divider(
                      //   thickness: 2,
                      //   indent: MediaQuery.of(context).size.width * 0.3,
                      //   endIndent: MediaQuery.of(context).size.width * 0.3,
                      // ),

                      // ! Customs Security....
                      buildCustomsSecurity(isLoaded),

                      // Divider(
                      //   thickness: 2,
                      //   indent: MediaQuery.of(context).size.width * 0.3,
                      //   endIndent: MediaQuery.of(context).size.width * 0.3,
                      // ),

                      // ! ChargeDeclaration....
                      buildChargeDeclaration(isLoaded),
                      // Divider(
                      //   thickness: 2,
                      //   indent: MediaQuery.of(context).size.width * 0.3,
                      //   endIndent: MediaQuery.of(context).size.width * 0.3,
                      // ),

                      // ! Shipper....
                      buildShipper(isLoaded),
                      //
                      // Divider(
                      //   thickness: 2,
                      //   indent: MediaQuery.of(context).size.width * 0.3,
                      //   endIndent: MediaQuery.of(context).size.width * 0.3,
                      // ),

                      // ! Consignee....
                      buildConsignee(isLoaded),

                      // Divider(
                      //   thickness: 2,
                      //   indent: MediaQuery.of(context).size.width * 0.3,
                      //   endIndent: MediaQuery.of(context).size.width * 0.3,
                      // ),

                      buildDialogButtons(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void loadHouseSampleData1(FHLModel model) {
    // clearChargeDeclaration();
    // clearConsignee();
    // clearCustomsSecurity();
    // clearHouseDetails();
    // clearQuantityDetails();
    // clearShipper();
    // clearSpecialRequirement();
    // notifyListeners();
    //setStatus();
    //
    model.houseDetailsNumber = "AGL164911";
    model.houseDetailsDescription = "HANDLE WITH CARE";
    model.houseDetailsOrigin = "DEL";
    model.houseDetailsDestination = "HAN";
    // houseDetailsNatureGoods = "Laptops";
    sippercontactList = [];

    // specialRequirementSpecialCode = 'Q';
    // specialRequirementHarmonisedCode = '1244587000';
    // // specialCode.add({
    // //   'isSelected': false,
    // //   'specialcode': "DC",
    // // });
    model.specialCode = [
      {
        'isSelected': false,
        'specialcode': "DC",
      },
    ];
    //List<Map<String, dynamic>>
    model.hormoCode = [
      {
        'isSelected': false,
        'hormonisedcode': 'HRMC1',
      },
    ];

    model.quantityDetailsPieces = '10';
    model.quantityDetailsWeight = '100';
    model.quantityDetailsWeightUnit = "K";
    model.quantityDetailsSLAC = '1';

    model.customsSecurityCountryCode = 'IN';
    model.customsSecurityInfoIdentifier = 'SD';
    model.customsSecurityCSRCIdentifier = 'ED';
    model.customsSecuritySCSRCIdentifier = 'ED';

    model.chargeDeclarationCurrencyCode = 'INR';
    model.chargeDeclarationWeightValue = 'K';
    model.chargeDeclarationOtherCharges = 'C';
    model.chargeDeclarationCarriageValue = '25';
    model.chargeDeclarationCustomsValue = '45';
    model.chargeDeclarationInsuranceValue = '35';

    model.shipperName = 'NAVEEN';
    model.shipperAddress = 'KARIPUR';
    model.shipperPlace = 'KARIPUR';
    model.shipperState = 'KERALA';
    model.shipperCode = 'IN';
    model.shipperPostCode = '673647';
    model.shipperIdentifier = '';
    model.shipperNumber = '';
    //List<Map<String, dynamic>>
    sippercontactList = [];

    model.consigneeName = 'KARTHICK';
    model.consigneeAddress = '';
    model.consigneePlace = 'RAS AL-KHAIMAH';
    model.consigneeState = '';
    model.consigneeCode = 'AE';
    model.consigneePostCode = '654564';
    model.consigneeIdentifier = '';
    model.consigneeNumber = '';
    //List<Map<String, dynamic>>
    // consigneeContactList = [];
    // notifyListeners();
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
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).accentColor)),
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                    child: Text(
                      S.of(context).Discard,
                      style:
                          TextStyle(color: Theme.of(context).backgroundColor),
                      // "Discard"
                    ),
                  ),
                ),
                // ! ADD ....
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).accentColor)),
                      onPressed: () async {
                        if (_addFHLHousesFormKey.currentState.validate()) {
                          // _fhlModel.sippercontactList = sippercontactList;
                          // _fhlModel.consigneeContactList = consigneecontactList;
                          _fhlModel.specialCode = specialCodeList;

                          _fhlModel.newshipperContactList = expenseList;
                          _fhlModel.newconsigneeContactList = expenseL;
                          print("Length " +
                              _fhlModel.sippercontactList.length.toString());
                          //Navigator.of(context).pop(_fhlModel);
                          print(_fhlModel.houseDetailsNumber);
                          Navigator.pop(context, _fhlModel);
                          bool alreadyExistAWB = true;
                          List _searchResult = [];
                          print("object");
                          _searchResult.clear();
                          // if (text.isEmpty) {
                          //   setState(() {});
                          //   return;
                          // }

                          widget.houselist.forEach((gethouselist) {
                            print("Foreach'${gethouselist}'" +
                                _fhlModel.houseDetailsNumber);

                            if ((gethouselist["serialNumber"].toString() ==
                                    (_fhlModel.houseDetailsNumber))
                                // &&
                                // (getawblist["wayBillNumber"]
                                //     .toString() == (masterAWB)
                                // )
                                ) {
                              Fluttertoast.showToast(
                                  msg: 'House already exists',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 5,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                              alreadyExistAWB = false;
                            }
                          });
                          String result;
                         if (alreadyExistAWB == true) {
                             result =
                                await _fhlModel.insertFHL(widget.awbid);
                          }
                          print(result);

                          if (result == "sucess") {
                            Fluttertoast.showToast(
                                msg: 'House list added',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                // timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white);
                            // Scaffold.of(context).showSnackBar(
                            //   SnackBar(
                            //     content: Text("House list added"),
                            //     duration: Duration(seconds: 1),
                            //   ),
                            // );
                            // showMessage(
                            //     S.of(context).Houselistadded,
                            //     //"House list added",
                            //     Colors.green,
                            //     Colors.white);
                          } else {
                            Fluttertoast.showToast(
                                msg: 'House list added failed',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                // timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white);
                            // Scaffold.of(context).showSnackBar(
                            //   SnackBar(
                            //     content: Text("House list added failed"),
                            //     duration: Duration(seconds: 1),
                            //   ),
                            // );
                            // showMessage(
                            //     S.of(context).Houselistaddedfailed,
                            //     //"House list added failed",
                            //
                            //     Colors.red,
                            //     Colors.white);
                          }
                        }
                      },
                      child: Text(
                        S.of(context).Add,
                        style:
                            TextStyle(color: Theme.of(context).backgroundColor),
                        //"Add"
                      )),
                ),
              ],
            ),
          )
        : Container();
  }

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

  Widget buildConsignee(bool isloaded) {
    return Card(
      shape: new RoundedRectangleBorder(
          side: new BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(4.0)),
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
                  //decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
            ),

            // ! consigneeName....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                inputFormatters: [AllCapitalCase()],
                enabled: !widget.isView,
                controller: ConsigneeNameController,
                // initialValue: _fhlModel.consigneeName,
                onChanged: (value) {
                  _fhlModel.consigneeName = value;
                },
                decoration: InputDecoration(
                    helperText: (isloaded) ? "eg: XYZ" : "",
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
                    labelText: S.of(context).Name + "*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    suffixIcon: Icon(
                      Icons.contacts_rounded,
                      color: Theme.of(context).accentColor,
                      // color: Colors.deepPurple,
                    )
                    //'Name',
                    ),
              ),
            ),
            // (isloaded)?Text("eg: XYZ "):Text(""),

            // ! consigneeAddress...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                enabled: !widget.isView,
                controller: ConsigneeAddressController,
                //  initialValue: _fhlModel.consigneeAddress,
                onChanged: (value) {
                  _fhlModel.consigneeAddress = value;
                },
                inputFormatters: [AllCapitalCase()],
                decoration: InputDecoration(
                    helperText: (isloaded) ? "eg: RAS AL-KHAIMAH" : "",
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
                    labelText: S.of(context).StreetAddress + "*",
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
            // (isloaded)?Text("eg: RAS AL-KHAIMAH "):Text(""),

            // ! consigneePlace...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                enabled: !widget.isView,
                controller: ConsigneePlaceController,
                // initialValue: _fhlModel.consigneePlace,
                onChanged: (value) {
                  _fhlModel.consigneePlace = value;
                },
                inputFormatters: [AllCapitalCase()],
                decoration: InputDecoration(
                    helperText: (isloaded) ? "eg: RAS AL-KHAIMAH" : "",
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
                    labelText: S.of(context).Place + "*",
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
            // (isloaded)?Text("eg: RAS AL-KHAIMAH "):Text(""),

            // ! consigneeState...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                enabled: !widget.isView,
                controller: ConsigneeStateController,
                // initialValue: _fhlModel.consigneeState,
                onChanged: (value) {
                  _fhlModel.consigneeState = value;
                },
                inputFormatters: [AllCapitalCase()],
                decoration: InputDecoration(
                    helperText: (isloaded) ? "" : "",
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
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // ! consigneeCode....
                  // Expanded(
                  //   child: Column(
                  //     children: [
                  //       TextFormField(
                  //         enabled: !widget.isView,
                  //         initialValue: _fhlModel.consigneeCode,
                  //         onChanged: (value) {
                  //           _fhlModel.consigneeCode = value;
                  //         },
                  //         inputFormatters: [AllCapitalCase()],
                  //         maxLength: 2,
                  //         decoration: InputDecoration(
                  //             helperText: (isloaded)?"eg: AE":"",
                  //             enabledBorder: OutlineInputBorder(
                  //               borderSide: BorderSide(
                  //                   color: Theme.of(context).accentColor),
                  //               borderRadius:
                  //               BorderRadius.all(Radius.circular(8.0)),
                  //             ),
                  //             //border: InputBorder.none,
                  //             focusedBorder: OutlineInputBorder(
                  //               borderSide: BorderSide(
                  //                   color: Theme.of(context).accentColor),
                  //               borderRadius:
                  //               BorderRadius.all(Radius.circular(8.0)),
                  //             ),
                  //             border: OutlineInputBorder(
                  //                 gapPadding: 2.0,
                  //                 borderRadius:
                  //                 BorderRadius.all(Radius.circular(8.0))),
                  //             labelText: S.of(context).CountryCode,
                  //             labelStyle:
                  //             TextStyle(color: Theme.of(context).accentColor)
                  //           //'Country Code',
                  //         ),
                  //       ),
                  //       // (isloaded)?Text("eg: AE "):Text(""),
                  //     ],
                  //   ),
                  //
                  // ),

                  Expanded(
                    child: Container(
                      child: TypeAheadFormField<CountryCode>(
                        getImmediateSuggestions: true,
                        suggestionsCallback: CountryCodeApi.getCountryCode,
                        itemBuilder: (context, CountryCode suggestion) {
                          final code = suggestion;
                          // print(code.countryName);
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
                          controller: ConsigneeCountryCode,
                          onChanged: (value) {
                            _fhlModel.consigneeCode = ConsigneeCountryCode.text;
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
                              helperText: (isloaded) ? "eg: AE" : "",
                              isDense: true,
                              border: OutlineInputBorder(
                                  gapPadding: 2.4,
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
                              labelText: S.of(context).CountryCode + " *",
                              labelStyle: new TextStyle(
                                  color: Theme.of(context).accentColor,
                                  // color: Colors.deepPurple,
                                  fontSize: 16.0),
                              suffixIcon: Icon(
                                Icons.add_location,
                                color: Theme.of(context).accentColor,
                                // color: Colors.deepPurple,
                              )
                              //'Country Code',
                              // suffixIcon: Icon(
                              //   Icons.add_location,
                              //   color: Theme.of(context).accentColor,
                              //   // color: Colors.deepPurple,
                              // )
                              ),
                        ),
                        suggestionsBoxDecoration:
                            SuggestionsBoxDecoration(elevation: 2.0),
                        onSuggestionSelected: (CountryCode suggestion) {
                          // if (suggestion.countryCode == null &&
                          //     suggestion.countryName == null) {
                          //   return
                          //     S.of(context).WrongAWBNumber;
                          //   //'Worong AWB Number';
                          // } else {
                          this.ConsigneeCountryCode.text =
                              suggestion.countryCode;
                          _fhlModel.consigneeCode = suggestion.countryCode;
                          // }
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

                  SizedBox(
                    width: 5,
                  ),
                  // ! consigneePostCode....
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          enabled: !widget.isView,
                          controller: ConsigneePostcodeController,
                          //  initialValue: _fhlModel.consigneePostCode,
                          onChanged: (value) {
                            _fhlModel.consigneePostCode = value;
                          },
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              helperText: (isloaded) ? "eg: 654564" : "",
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
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor),
                              suffixIcon: Icon(
                                Icons.code,
                                color: Theme.of(context).accentColor,
                                // color: Colors.deepPurple,
                              )
                              //'Post Code',
                              ),
                        ),
                        // (isloaded)?Text("eg: 654564"):Text(""),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // // ! consigneeIdentifier...
            // Padding(
            //   padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
            //   child: TextFormField(
            //     enabled: !widget.isView,
            //     initialValue: _fhlModel.consigneeIdentifier,
            //     onChanged: (value) {
            //       _fhlModel.consigneeIdentifier = value;
            //     },
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder(
            //           gapPadding: 2.0,
            //           borderRadius: BorderRadius.all(Radius.circular(8.0))),
            //       labelText: 'Identifier',
            //     ),
            //   ),
            // ),

            // // ! consigneeNumber...
            // Padding(
            //   padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
            //   child: TextFormField(
            //     keyboardType: TextInputType.number,
            //     enabled: !widget.isView,
            //     initialValue: _fhlModel.consigneeNumber,
            //     onChanged: (value) {
            //       _fhlModel.consigneeNumber = value;
            //     },
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder(
            //           gapPadding: 2.0,
            //           borderRadius: BorderRadius.all(Radius.circular(8.0))),
            //       labelText: 'Contact Number',
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
                Expanded(
                  flex: 2,
                  child: IconButton(
                    color: Theme.of(context).accentColor,
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _showConsigneeContactDialog();
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
                          leading: e.Consignee_Contact_Type == "Email"
                              ? Icon(
                                  Icons.email,
                                  color: Theme.of(context).accentColor,
                                )
                              : Icon(
                                  Icons.phone,
                                  color: Theme.of(context).accentColor,
                                ),
                          // leading: Icon(
                          //   Icons.phone,
                          //   color: Theme.of(context).accentColor,
                          // ),
                          // title: Text(
                          //   '${e.Consignee_Contact_Detail}',
                          // ),
                          title: Text(
                            (e.Consignee_Contact_Type == "Email")
                                ? ' ' + '${e.Consignee_Contact_Detail}'
                                : '${e.flag}' + '${e.Consignee_Contact_Detail}',
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
                                    title: Center(
                                        child: Text(S.of(context).Delete
                                            // 'Delete'
                                            )),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                              // S.of(context).Wouldyouliketodeleteshippercontact
                                              'Would you like to delete shipper contact '),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                          //  S.of(context).Confirm,
                                          'Confirm',
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
                                          //  'Cancel',
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
          ],
        ),
      ),
    );
  }

  Widget buildShipper(bool isloaded) {
    return Card(
      shape: new RoundedRectangleBorder(
          side: new BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(4.0)),
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
                  // decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
            ),

            // ! shipperName....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                enabled: !widget.isView,
                controller: ShipperNameController,
                //initialValue: _fhlModel.shipperName,
                onChanged: (value) {
                  _fhlModel.shipperName = value;
                },
                inputFormatters: [AllCapitalCase()],
                decoration: InputDecoration(
                    helperText: (isloaded) ? "eg: ABC " : "",
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
                    labelText: S.of(context).Name + "*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    suffixIcon: Icon(
                      Icons.contacts_rounded,
                      color: Theme.of(context).accentColor,
                      // color: Colors.deepPurple,
                    )
                    //'Name',
                    ),
              ),
            ),
            // (isloaded)?Text("eg: ABC "):Text(""),

            // ! shipperAddress...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                enabled: !widget.isView,
                controller: ShipperAddressController,
                //  initialValue: _fhlModel.shipperAddress,
                onChanged: (value) {
                  _fhlModel.shipperAddress = value;
                },
                inputFormatters: [AllCapitalCase()],
                decoration: InputDecoration(
                    helperText: (isloaded) ? "eg: KARIPUR " : "",
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
                    labelText: S.of(context).StreetAddress + "*",
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
            // (isloaded)?Text("eg: KARIPUR "):Text(""),

            // ! shipperPlace...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                enabled: !widget.isView,
                controller: ShipperPlaceController,
                //  initialValue: _fhlModel.shipperPlace,
                onChanged: (value) {
                  _fhlModel.shipperPlace = value;
                },
                inputFormatters: [AllCapitalCase()],
                decoration: InputDecoration(
                    helperText: (isloaded) ? "eg: KARIPUR " : "",
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
                    labelText: S.of(context).Place + "*",
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
            // (isloaded)?Text("eg: KARIPUR "):Text(""),

            // ! shipperState...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                enabled: !widget.isView,
                controller: ShipperStateController,
                // initialValue: _fhlModel.shipperState,
                onChanged: (value) {
                  _fhlModel.shipperState = value;
                },
                inputFormatters: [AllCapitalCase()],
                decoration: InputDecoration(
                    helperText: (isloaded) ? "eg: KERALA " : "",
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
            // (isloaded)?Text("eg: KERALA "):Text(""),

            // ! houseDetailsOrigin, houseDetailsDestination....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Row(
                children: [
                  // ! shipperCode....
                  // Expanded(
                  //   child: TextFormField(
                  //     enabled: !widget.isView,
                  //     initialValue: _fhlModel.shipperCode,
                  //     onChanged: (value) {
                  //       _fhlModel.shipperCode = value;
                  //     },
                  //     inputFormatters: [AllCapitalCase()],
                  //     maxLength: 2,
                  //     decoration: InputDecoration(
                  //         helperText:(isloaded)?"eg: IN":"",
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
                          controller: ShipperCountryCode,
                          onChanged: (value) {
                            _fhlModel.shipperCode = ShipperCountryCode.text;
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
                              helperText: (isloaded) ? "eg: IN" : "",
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
                              labelText: S.of(context).CountryCode + "*",
                              labelStyle: new TextStyle(
                                  color: Theme.of(context).accentColor,
                                  // color: Colors.deepPurple,
                                  fontSize: 16.0),
                              //'Country Code',
                              suffixIcon: Icon(
                                Icons.add_location,
                                color: Theme.of(context).accentColor,
                                // color: Colors.deepPurple,
                              )),
                        ),
                        suggestionsBoxDecoration:
                            SuggestionsBoxDecoration(elevation: 2.0),
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
                  SizedBox(
                    width: 5,
                  ),
                  // ! shipperPostCode....
                  Expanded(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      enabled: !widget.isView,
                      controller: ShipperPostcodeController,
                      //   initialValue: _fhlModel.shipperPostCode,
                      onChanged: (value) {
                        _fhlModel.shipperPostCode = value;
                      },
                      maxLength: 6,
                      decoration: InputDecoration(
                          helperText: (isloaded) ? "eg: 673647 " : "",
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
            // (isloaded)?Text("eg: IN "):Text(""),

            //Add multiple contact list
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
                //   //       sippercontactList
                //   //           .removeWhere((element) => element['isSelected']);
                //   //     });
                //   //   },
                //   // ),
                // ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () async {
                        final name = await _showDialogContact();
                        if (name == null || name.isEmpty) return;
                        setState(() {
                          //  this.name = name;
                        });
                      }),
                  // child: IconButton(
                  //   color: Theme.of(context).accentColor,
                  //   icon: Icon(Icons.add),
                  //   onPressed: () {
                  //     setState(() {
                  //       sippercontactList.add({
                  //         'isSelected': false,
                  //         'Shipper_Contact_Type': 'Telegram',
                  //         'Shipper_Contact_Detail': 0,
                  //       });
                  //     });
                  //   },
                  // ),
                ),
              ],
            ),
            //SHipper contact bnumber
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
                          leading: e.Shipper_Contact_Type == "Email"
                              ? Icon(
                                  Icons.email,
                                  color: Theme.of(context).accentColor,
                                )
                              : Icon(
                                  Icons.phone,
                                  color: Theme.of(context).accentColor,
                                ),
                          title: Text(
                            (e.Shipper_Contact_Type == "Email")
                                ? ' ' + '${e.Shipper_Contact_Detail}'
                                : '${e.flag}' + '${e.Shipper_Contact_Detail}',
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
                                            S
                                                .of(context)
                                                .Wouldyouliketodeleteshippercontactnumber,
                                            //    'Would you like to delete shipper contact number'
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                          S.of(context).Confirm,

                                          ///'Confirm',
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
                                          //'Cancel',
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
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.horizontal,
            //     child: Builder(
            //       builder: (context) => DataTable(
            //
            //         dataRowColor: MaterialStateProperty.resolveWith<Color>(
            //             (Set<MaterialState> states) {
            //           if (states.contains(MaterialState.selected))
            //             return Theme.of(context)
            //                 .accentColor
            //                 .withOpacity(0.5);
            //           return null; // Use the default value.
            //         }),
            //         showCheckboxColumn: false,
            //         //columnSpacing: 15,
            //         decoration: BoxDecoration(
            //           border:Border(
            //               right: Divider.createBorderSide(context, width: 5.0),
            //               left: Divider.createBorderSide(context, width: 5.0)
            //           ),
            //         ),
            //         columns: [
            //           DataColumn(
            //               label: Text(
            //             S.of(context).Type,
            //             style: TextStyle(
            //               color: Theme.of(context).accentColor,
            //             ),
            //             //'Type'
            //           )),
            //           DataColumn(
            //               label: Text(
            //             S.of(context).ContactNumber,
            //             style: TextStyle(
            //               color: Theme.of(context).accentColor,
            //             ),
            //             // 'Contact Number'
            //           )),
            //         ],
            //         rows: List<DataRow>.generate(
            //           sippercontactList.length,
            //           (index) => newDataRow(index),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            //! shipperNumber...
          ],
        ),
      ),
    );
  }

  Widget buildSpecialRequirements() {
    print(_fhlModel.specialCode);
    return Card(
      shape: new RoundedRectangleBorder(
          side: new BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(4.0)),
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
                  //  decoration: TextDecoration.underline,
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
                            S.of(context).SpecialCode + "*",
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
                              label: Text(
                            S.of(context).HarmonisedCode + "*",
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
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
            //   child: Text(
            //     "Special Requirements",
            //     style: TextStyle(
            //       decoration: TextDecoration.underline,
            //       fontWeight: FontWeight.w700,
            //       fontSize: 20.0,
            //     ),
            //   ),
            // ),
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
            //             initialValue: _fhlModel.specialRequirementSpecialCode,
            //             onChanged: (value) {
            //               _fhlModel.specialRequirementSpecialCode = value;
            //             },
            //             decoration: InputDecoration(
            //               border: OutlineInputBorder(
            //                   gapPadding: 2.0,
            //                   borderRadius:
            //                       BorderRadius.all(Radius.circular(8.0))),
            //               labelText: 'Special Code',
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
            //             initialValue:
            //                 _fhlModel.specialRequirementHarmonisedCode,
            //             onChanged: (value) {
            //               _fhlModel.specialRequirementHarmonisedCode = value;
            //             },
            //             decoration: InputDecoration(
            //               border: OutlineInputBorder(
            //                   gapPadding: 2.0,
            //                   borderRadius:
            //                       BorderRadius.all(Radius.circular(8.0))),
            //               labelText: 'Harmonised Code',
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

  Widget buildChargeDeclaration(bool isloaded) {
    return Card(
      shape: new RoundedRectangleBorder(
          side: new BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(4.0)),
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
                        suffixIcon: Icon(Icons.money,
                            size: 23, color: Theme.of(context).accentColor),
                        contentPadding:
                            EdgeInsets.fromLTRB(15.0, 28.0, 20.0, 10.0),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor,
                                width: 1.0)),
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
                        labelText: S.of(context).CurrencyCode + "*",
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
                      _fhlModel.chargeDeclarationCurrencyCode =
                          suggestion.currencyCode;
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
                    })),
            // Padding(
            //   padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
            //   child: TextFormField(
            //     textInputAction: TextInputAction.next,
            //     keyboardType: TextInputType.text,
            //     inputFormatters: [AllCapitalCase()],
            //     maxLength: 2,
            //     enabled: !widget.isView,
            //     initialValue: _fhlModel.chargeDeclarationCurrencyCode,
            //     onChanged: (value) {
            //       _fhlModel.chargeDeclarationCurrencyCode = value;
            //     },
            //     validator: (value) {
            //       if (value.isEmpty || value == null) {
            //         return S.of(context).EntertheCurrencyCode;
            //         //"Enter the Currency Code";
            //       }
            //       return null;
            //     },
            //     decoration: InputDecoration(
            //         helperText:  (isloaded)?"eg: RS ":"",
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
            //         labelStyle: TextStyle(color: Theme.of(context).accentColor),
            //         suffixIcon: Icon(
            //           Icons.money,
            //           color: Theme.of(context).accentColor,
            //           //color: Colors.deepPurple,
            //         )
            //       //'Currency Code',
            //     ),
            //   ),
            // ),
            // (isloaded)?Text("eg: RS "):Text(""),

            // ! chargeDeclarationWeightValue....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                inputFormatters: [AllCapitalCase()],
                maxLength: 1,
                enabled: !widget.isView,
                controller: ChargeDeclarationWeightValueController,
                // initialValue: _fhlModel.chargeDeclarationWeightValue,
                onChanged: (value) {
                  _fhlModel.chargeDeclarationWeightValue = value;
                },
                // validator: (value) {
                //   if (value.isEmpty || value == null) {
                //     return S.of(context).EntertheWeightValue;
                //     //"Enter the Weight Value";
                //   }
                //   return null;
                // },
                decoration: InputDecoration(
                    helperText: (isloaded) ? "eg: K " : "",
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
                    labelText: S.of(context).WeightValue + "*",
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
            // (isloaded)?Text("eg: K "):Text(""),

            // ! chargeDeclarationOtherCharges....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                inputFormatters: [AllCapitalCase()],
                maxLength: 1,
                enabled: !widget.isView,
                controller: ChargeDeclarationOtherChargesController,
                // initialValue: _fhlModel.chargeDeclarationOtherCharges,
                onChanged: (value) {
                  _fhlModel.chargeDeclarationOtherCharges = value;
                },
                // validator: (value) {
                //   if (value.isEmpty || value == null) {
                //     return S.of(context).EntertheOtherCharges;
                //     //"Enter the Other Charges";
                //   }
                //   return null;
                // },
                decoration: InputDecoration(
                    helperText: (isloaded) ? "eg: C " : "",
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
                    labelText: S.of(context).OtherCharges + "*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    suffixIcon: Icon(
                      Icons.money,
                      color: Theme.of(context).accentColor,
                      //color: Colors.deepPurple,
                    )
                    //'Other Charges',
                    ),
              ),
            ),
            // (isloaded)?Text("eg: C "):Text(""),

            // ! chargeDeclarationCarriageValue....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                inputFormatters: [AllCapitalCase()],
                maxLength: 3,
                enabled: !widget.isView,
                controller: ChargeDeclarationCarriageValueController,
                // initialValue: _fhlModel.chargeDeclarationCarriageValue,
                onChanged: (value) {
                  _fhlModel.chargeDeclarationCarriageValue = value;
                },
                // validator: (value) {
                //   if (value.isEmpty || value == null) {
                //     return S.of(context).EntertheCarriageValue;
                //     //"Enter the Carriage Value";
                //   }
                //   return null;
                // },
                decoration: InputDecoration(
                    helperText: (isloaded) ? "eg: 25 " : "",
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
                    labelText: S.of(context).CarriageValue + "*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    suffixIcon: Icon(
                      Icons.money,
                      color: Theme.of(context).accentColor,
                      //color: Colors.deepPurple,
                    )
                    //'Carriage Value',
                    ),
              ),
            ),
            // (isloaded)?Text("eg: 25 "):Text(""),

            // ! chargeDeclarationCustomsValue....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                inputFormatters: [AllCapitalCase()],
                maxLength: 3,
                enabled: !widget.isView,
                controller: ChargeDeclarationCustomsValueController,
                // initialValue: _fhlModel.chargeDeclarationCustomsValue,
                onChanged: (value) {
                  _fhlModel.chargeDeclarationCustomsValue = value;
                },
                // validator: (value) {
                //   if (value.isEmpty || value == null) {
                //     return S.of(context).EntertheCustomsValue;
                //     //"Enter the Customs Value";
                //   }
                //   return null;
                // },
                decoration: InputDecoration(
                    helperText: (isloaded) ? "eg: 45 " : "",
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
                    labelText: S.of(context).CustomsValue + "*",
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
            // (isloaded)?Text("eg: 45 "):Text(""),

            // ! chargeDeclarationInsuranceValue....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                inputFormatters: [AllCapitalCase()],
                maxLength: 3,
                enabled: !widget.isView,
                controller: ChargeDeclarationInsuranceValueController,
                //  initialValue: _fhlModel.chargeDeclarationInsuranceValue,
                onChanged: (value) {
                  _fhlModel.chargeDeclarationInsuranceValue = value;
                },
                // validator: (value) {
                //   if (value.isEmpty || value == null) {
                //     return S.of(context).EntertheInsuranceValue;
                //     //"Enter the Insurance Value";
                //   }
                //   return null;
                // },
                decoration: InputDecoration(
                    helperText: (isloaded) ? "eg: 35 " : "",
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
                    labelText: S.of(context).InsuranceValue + "*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    suffixIcon: Icon(
                      Icons.money,
                      color: Theme.of(context).accentColor,
                      // color: Colors.deepPurple,
                    )
                    //'Insurance Value',
                    ),
              ),
            ),
            // (isloaded)?Text("eg: 35 "):Text(""),
          ],
        ),
      ),
    );
  }

  Widget buildCustomsSecurity(bool isloaded) {
    return Card(
      shape: new RoundedRectangleBorder(
          side: new BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Text(
                S.of(context).CustomsSecurity,

                // "Customs Security",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  // decoration: TextDecoration.underline,
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
                  controller: CustomsCountryCode,
                  // onChanged: (value) {
                  //   _fhlModel.customsSecurityCountryCode= value;
                  //       CustomsCountryCode.text=value;
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
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
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
                      )),
                ),
                suggestionsBoxDecoration:
                    SuggestionsBoxDecoration(elevation: 2.0),
                onSuggestionSelected: (CountryCode suggestion) {
                  // if (suggestion.countryCode == null &&
                  //     suggestion.countryName == null) {
                  //   return
                  //     S.of(context).WrongAWBNumber;
                  //   //'Worong AWB Number';
                  // } else {
                  this.CustomsCountryCode.text = suggestion.countryCode;
                  _fhlModel.customsSecurityCountryCode = suggestion.countryCode;
                  // }
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
            //     textInputAction: TextInputAction.next,
            //     keyboardType: TextInputType.text,
            //     inputFormatters: [AllCapitalCase()],
            //     maxLength: 2,
            //     enabled: !widget.isView,
            //     initialValue: _fhlModel.customsSecurityCountryCode,
            //     onChanged: (value) {
            //       _fhlModel.customsSecurityCountryCode = value;
            //     },
            //     validator: (value) {
            //       if (value.isEmpty || value == null) {
            //         return S.of(context).EntertheCountryCode;
            //         //"Enter the Country Code";
            //       }
            //       return null;
            //     },
            //     decoration: InputDecoration(
            //
            //         helperText: (isloaded)?"eg: IN":"",
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
            // (isloaded)?Text("eg: IN "):Text(""),

            // ! customsSecurityInfoIdentifier....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                inputFormatters: [AllCapitalCase()],
                maxLength: 3,
                enabled: !widget.isView,
                controller: CustomsSecurityInfoIdentifierController,
                //initialValue: _fhlModel.customsSecurityInfoIdentifier,
                onChanged: (value) {
                  _fhlModel.customsSecurityInfoIdentifier = value;
                },
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return S.of(context).EntertheInfoIdentifier;
                    //"Enter the Info Identifier";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    helperText: (isloaded) ? "eg: SD" : "",
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
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    suffixIcon: Icon(
                      Icons.info,
                      color: Theme.of(context).accentColor,
                      //color: Colors.deepPurple,
                    )
                    //'Info Identifier',
                    ),
              ),
            ),
            // (isloaded)?Text("eg: SD "):Text(""),

            // ! customsSecurityCSRCIdentifier....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                inputFormatters: [AllCapitalCase()],
                maxLength: 3,
                enabled: !widget.isView,
                controller: CustomsSecurityCSRCController,
                // initialValue: _fhlModel.customsSecurityCSRCIdentifier,
                onChanged: (value) {
                  _fhlModel.customsSecurityCSRCIdentifier = value;
                },
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return S.of(context).EntertheCSRCIdentifier;
                    //"Enter the CSRC Identifier";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    helperText: (isloaded) ? "eg: ED" : "",
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
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    suffixIcon: Icon(
                      Icons.monitor_weight_outlined,
                      color: Theme.of(context).accentColor,
                      // color: Colors.deepPurple,
                    )
                    //'CSRC Identifier',
                    ),
              ),
            ),
            // (isloaded)?Text("eg: ED "):Text(""),

            // ! customsSecuritySCSRCIdentifier....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                inputFormatters: [AllCapitalCase()],
                enabled: !widget.isView,
                controller: CustomsSecuritySCSRCController,
                // initialValue: _fhlModel.customsSecuritySCSRCIdentifier,
                onChanged: (value) {
                  _fhlModel.customsSecuritySCSRCIdentifier = value;
                },
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return S.of(context).EntertheSCSRCIdentifier;
                    //"Enter the SCSRC Identifier";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    helperText: (isloaded) ? "eg: ED" : "",
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
                    labelText: S.of(context).SCSRCIdentifier + "*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    suffixIcon: Icon(
                      Icons.monitor_weight_outlined,
                      color: Theme.of(context).accentColor,
                      // color: Colors.deepPurple,
                    )
                    //'SCSRC Identifier',
                    ),
              ),
            ),
            // (isloaded)?Text("eg: ED "):Text(""),
          ],
        ),
      ),
    );
  }

  Widget buildQuantityDetails(bool isloaded) {
    return Card(
      shape: new RoundedRectangleBorder(
          side: new BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Text(
                S.of(context).QuantityDetails + "*",
                // "Quantity Details",
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
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                enabled: !widget.isView,
                controller: QuantityDetailsPiecesController,
                // initialValue: _fhlModel.quantityDetailsPieces,
                onChanged: (value) {
                  // value =qDetailsPieces;
                  // qDetailsPieces=value;
                  _fhlModel.quantityDetailsPieces = value;
                },
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return S.of(context).EnterthePieces;
                    //"Enter the Pieces";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    helperText: (isloaded) ? "eg: 10" : "",
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
                    labelText: S.of(context).Pieces + "*",
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
            // (isloaded)?Text("eg: 10 "):Text(""),

            // ! houseDetailsOrigin, houseDetailsDestination....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Row(
                children: [
                  // ! _fhlModel.quantityDetailsWeight....
                  Expanded(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      enabled: !widget.isView,
                      controller: QuantityDetailsWeightController,
                      // initialValue: _fhlModel.quantityDetailsWeight,
                      onChanged: (value) {
                        _fhlModel.quantityDetailsWeight = value;
                      },
                      validator: (value) {
                        if (value.isEmpty || value == null) {
                          return S.of(context).EntertheWeight;
                          //"Enter the Weight";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          helperText: (isloaded) ? "eg: 100" : "",
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
                          labelText: S.of(context).Weight + "*",
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
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Theme.of(context).accentColor),
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
                              _fhlModel.quantityDetailsWeightUnit,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                    ),
                    flex: 3,
                  ),
                ],
              ),
            ),
            // (isloaded)?Text("eg: 100 "):Text(""),

            // ! houseDetailsDescription...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                enabled: !widget.isView,
                controller: QuantityDetailsSLACController,
                //initialValue: _fhlModel.quantityDetailsSLAC,
                onChanged: (value) {
                  _fhlModel.quantityDetailsSLAC = value;
                },
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return S.of(context).EntertheSLAC;
                    //"Enter the SLAC";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    helperText: (isloaded) ? "eg: 1" : "",
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
            // (isloaded)?Text("eg: 1 "):Text(""),
          ],
        ),
      ),
    );
  }

  Widget buildHouseDetails(bool isloaded) {
    return Card(
      shape: new RoundedRectangleBorder(
          side: new BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Text(
                S.of(context).HouseDetails + "*",
                //"House Details",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  // decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
            ),

            // ! houseDetailsNumber....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                inputFormatters: [AllCapitalCase()],
                maxLength: 12,
                enabled: !widget.isView,
                controller: houseDetailsNumberController,
                // initialValue:_fhlModel.houseDetailsNumber,
                onChanged: (value) {
                  setState(() {
                    _fhlModel.houseDetailsNumber = value;
                    _fhlModel.houseDetailsNumber =
                        houseDetailsNumberController.text;

                    print(_fhlModel.houseDetailsNumber);
                    print(isloaded);
                  });
                },
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return S.of(context).EntertheHouseNo;
                    //"Enter the House No";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    helperText: (isloaded) ? "eg: AGL1649 " : "",
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
                    labelText: S.of(context).HouseNumber,
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    suffixIcon: Icon(
                      Icons.flight,
                      color: Theme.of(context).accentColor,
                      //color: Colors.deepPurple,
                    )
                    //'House Number',
                    ),
              ),
            ),
            // (isloaded)?Text("eg: AGL1649 "):Text(""),

            // ! houseDetailsOrigin, houseDetailsDestination....
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ! houseDetailsOrigin....
                  Expanded(
                    child: originTF(isLoaded),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  // ! houseDetailsDestination....
                  Expanded(
                    child: destinationTF(isLoaded),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                inputFormatters: [AllCapitalCase()],
                maxLength: 12,
                enabled: !widget.isView,
                controller: natureofgoodscontroller,
                //initialValue: _fhlModel.houseDetailsNatureGoods,
                // initialValue: _fhlModel.houseDetailsNatureGoods,
                onChanged: (value) {
                  _fhlModel.houseDetailsNatureGoods = value;
                },
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return S.of(context).EntertheNatureOfGoods;
                    //"Enter the Nature Of Goods";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    helperText: (isloaded) ? "eg: Laptops " : "",
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
                    labelText: S.of(context).NatureOfGoods + "*",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    suffixIcon: Icon(
                      Icons.monitor_weight,
                      color: Theme.of(context).accentColor,
                      //color: Colors.deepPurple,
                    )
                    //'Nature Of Goods',
                    ),
              ),
            ),
            // (isloaded)?Text("eg:Laptops"):Text(""),

            // ! houseDetailsDescription...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                inputFormatters: [AllCapitalCase()],
                enabled: !widget.isView,
                //    initialValue: "eg: Handle with care",
                controller: DescriptionController,
                // initialValue: _fhlModel.houseDetailsDescription,
                onChanged: (value) {
                  _fhlModel.houseDetailsDescription = value;
                },
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return S.of(context).EntertheDescription;
                    //"Enter the Description";
                  }
                  return null;
                },
                maxLines: 8,
                decoration: InputDecoration(
                    helperText: (isloaded) ? "eg: Handle with care" : "",
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
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    suffixIcon: Icon(
                      Icons.monitor_weight,
                      color: Theme.of(context).accentColor,
                      //color: Colors.deepPurple,
                    )
                    //'Description',
                    ),
              ),
            ),
            // (isloaded)?Text("eg: Handle with care "):Text(""),
          ],
        ),
      ),
    );
  }

  destinationTF(bool isloaded) {
    // this.houseDestination.text = _fhlModel.houseDetailsDestination;
    return TypeAheadField<AirportCode>(
        suggestionsCallback: AirportApi.getAirportCode,
        itemBuilder: (context, AirportCode suggestion) {
          final code = suggestion;
          return ListTile(
            title: Text(code.airportCode,
                style: TextStyle(color: Theme.of(context).accentColor)),
            subtitle: Text(code.airportName,
                style: TextStyle(color: Theme.of(context).accentColor)),
          );
        },
        textFieldConfiguration: TextFieldConfiguration(
          controller: this.houseDestination,
          inputFormatters: [AllCapitalCase()],
          decoration: InputDecoration(
              helperText: (isloaded) ? "eg: RKT" : "",
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
              labelText: S.of(context).Destination + "*",
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
          this.houseDestination.text = suggestion.airportCode;
          _fhlModel.houseDetailsDestination = suggestion.airportCode;
          //
        });
  }

  originTF(bool isloaded) {
    //this.houseOrigin.text = _fhlModel.houseDetailsOrigin;
    return TypeAheadField<AirportCode>(
        suggestionsCallback: AirportApi.getAirportCode,
        itemBuilder: (context, AirportCode suggestion) {
          final code = suggestion;
          return ListTile(
            title: Text(code.airportCode,
                style: TextStyle(color: Theme.of(context).accentColor)),
            subtitle: Text(code.airportName,
                style: TextStyle(color: Theme.of(context).accentColor)),
          );
        },
        textFieldConfiguration: TextFieldConfiguration(
          controller: this.houseOrigin,
          inputFormatters: [AllCapitalCase()],
          decoration: InputDecoration(
              helperText: (isloaded) ? "eg: CCJ" : "",
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
              labelText: S.of(context).Origin + "*",
              labelStyle: TextStyle(color: Theme.of(context).accentColor),
              suffixIcon: Icon(
                Icons.flight_takeoff,
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
              )
              //'Origin',
              ),
        ),
        onSuggestionSelected: (AirportCode suggestion) {
          this.houseOrigin.text = suggestion.airportCode;
          _fhlModel.houseDetailsOrigin = suggestion.airportCode;
          //
        });
  }

  newDataRow(int dimensionIndex) {
    contype.text = sippercontactList[dimensionIndex]['Shipper_Contact_Type'];
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
              //         this.houseOrigin.text = _fhlModel.houseDetailsOrigin;
              TypeAheadField<ContactType>(
                  suggestionsCallback: ContacTypeApi.getContactType,
                  itemBuilder: (context, ContactType suggestion) {
                    final code = suggestion;
                    return ListTile(
                      title: Text(code.contactType,
                          style:
                              TextStyle(color: Theme.of(context).accentColor)),
                      subtitle: Text(code.contactCode,
                          style:
                              TextStyle(color: Theme.of(context).accentColor)),
                    );
                  },
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: contype,
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
                        labelText: S.of(context).Origin,
                        labelStyle:
                            TextStyle(color: Theme.of(context).accentColor)
                        //'Origin',
                        ),
                  ),
                  onSuggestionSelected: (ContactType suggestion) {
                    sippercontactList[dimensionIndex]['Shipper_Contact_Type'] =
                        suggestion.contactCode;
                    contype.text = suggestion.contactCode;
                    //_fhlModel.houseDetailsOrigin = suggestion.airportCode;
                    //
                  })
              // DropdownButton<String>(
              //     icon: Icon(
              //       Icons.arrow_drop_down,
              //       color: Theme.of(context).accentColor,
              //     ),
              //     value: sippercontactList[dimensionIndex]
              //         ['Shipper_Contact_Type'],
              //     items: ['Telegram', 'WhatsApp', 'Fax', "Telephone"]
              //         .map<DropdownMenuItem<String>>((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Text(
              //           value,
              //           style: TextStyle(color: Theme.of(context).accentColor),
              //         ),
              //       );
              //     }).toList(),
              //     onChanged: (String text) {
              //       setState(() {
              //         sippercontactList[dimensionIndex]['Shipper_Contact_Type'] =
              //             text;
              //       });
              //     }),

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
            ),
          ),
        ]);
  }

  onSortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        sippercontactList.sort((a, b) => a['length'].compareTo(b['length']));
      } else {
        sippercontactList.sort((a, b) => b['length'].compareTo(a['length']));
      }
    }
  }

  newAddConsignee(int dimensionIndex) {
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

  onConsigneeSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        consigneecontactList.sort((a, b) => a['length'].compareTo(b['length']));
      } else {
        consigneecontactList.sort((a, b) => b['length'].compareTo(a['length']));
      }
    }
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
                  suggestionsCallback:
                      SpecialHandlingGroupApi.getSpecialHandlingCode,
                  itemBuilder: (context, SpecialHandlingGroup suggestion) {
                    final code = suggestion;
                    return ListTile(
                      title: Text(code.shgCode),
                      subtitle: Text(code.shgName),
                    );
                  },
                  // validator: (value) {
                  //   if (value.isEmpty) {
                  //     return 'Select a Special Handling Group';
                  //   }
                  //   return null;
                  // },
                  initialValue:
                      specialCodeList[dimensionIndex]['specialcode'] == ""
                          ? ''
                          : '${specialCodeList[dimensionIndex]['specialcode']}',
                  textFieldConfiguration: TextFieldConfiguration(
                    autofocus: false,

                    // controller: this.shgroupController,
                    inputFormatters: [AllCapitalCase()],
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(top: 20, left: 10, bottom: 20),
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: Theme.of(context).accentColor,
                                // color: Colors.deepPurple,
                                width: 2),
                            //gapPadding: 2.0,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).accentColor,
                            //   color: Colors.deepPurple
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        // border: OutlineInputBorder(
                        //     gapPadding: 2.0,
                        //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
                        labelText: S.of(context).SpecialHandlingGroup,
                        //"Special Handling Group",
                        labelStyle: new TextStyle(
                            color: Theme.of(context).accentColor,
                            // color: Colors.deepPurple,
                            fontSize: 16.0),
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Theme.of(context).accentColor,
                          // color: Colors.deepPurple,
                        )
                        // 'Destination',
                        ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSuggestionSelected: (SpecialHandlingGroup suggestion) {
                    specialCodeList[dimensionIndex]['specialcode'] =
                        suggestion.shgCode;
                    // model.awbConsigmentDestination = suggestion.shgCode;
                    //print(destination);
                  })),

          // TypeAheadFormField<SpecialCode>(
          //     suggestionsCallback: SpecialCodeApi.getSpecialCode,
          //     itemBuilder: (context, SpecialCode suggestion) {
          //       final code = suggestion;
          //       return ListTile(
          //         title: Text(
          //           code.codeType,
          //           style: TextStyle(color: Theme.of(context).accentColor),
          //         ),
          //         subtitle: Text(
          //           code.codeName,
          //           style: TextStyle(color: Theme.of(context).accentColor),
          //         ),
          //       );
          //     },
          //     validator: (value) {
          //       if (value.isEmpty) {
          //         return S.of(context).SelectaSpecialCode;
          //         //'Select a SpecialCode';
          //       }
          //       return null;
          //     },
          //     // initialValue:
          //     //     specialCodeList[dimensionIndex]['specialcode'] == ""
          //     //         ? ''
          //     //         : '${specialCodeList[dimensionIndex]['specialcode']}',
          //     textFieldConfiguration: TextFieldConfiguration(
          //       autofocus: false,
          //       controller: shcontroller,
          //       // inputFormatters: [AllCapitalCase()],
          //       decoration: InputDecoration(
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
          //         labelText:
          //         //"SPH",
          //         S.of(context).Sph,
          //         labelStyle:
          //         TextStyle(color: Theme.of(context).accentColor),
          //         //'SpecialCode',
          //       ),
          //     ),
          //     autovalidateMode: AutovalidateMode.onUserInteraction,
          //     onSuggestionSelected: (SpecialCode suggestion) {
          //       print(suggestion);
          //       this.shcontroller.text = suggestion.codeType;
          //       specialCodeList[dimensionIndex]['specialcode'] =
          //           suggestion.codeType;
          //       //print(destination);
          //     })
          // DataColumn(label: Text('Length')),
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
                ),
              ),
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
              "Add Shipper Contact",
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
            // Center(
            //   child: Container(
            //     height: 100,
            //     child: Image.network(
            //       "https://icons.iconarchive.com/icons/designcontest/ecommerce-business/256/admin-icon.png",
            //       //"https://www.pngarea.com/pngm/4/5041637_beard-png-professional-business-man-icon-png-download.png",
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
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
                          labelText: "Type",
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
                            labelText: "Email",
                            labelStyle:
                                TextStyle(color: Theme.of(context).accentColor),
                            hintText: "Enter the Email"),
                        controller: Telecontroller,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the email address';
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
                          labelText: S.of(context).PhoneNumber,
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
                            int flagOffset = 0x1F1E6;
                            int asciiOffset = 0x41;

                            String country = phone.countryISOCode;

                            int firstChar = country.codeUnitAt(0) -
                                asciiOffset +
                                flagOffset;
                            int secondChar = country.codeUnitAt(1) -
                                asciiOffset +
                                flagOffset;
                            // countrcode=phone.countryISOCode;
                            Shipperflag = String.fromCharCode(firstChar) +
                                String.fromCharCode(secondChar);
                            Telecontroller.text = phone.completeNumber;
                          });
                          //   //when phone number country code is changed
                          //   print(phone.completeNumber); //get complete number
                          //   print(phone.countryCode); // get country code only
                          //   print(phone.number); // only phone number
                        },
                      ))
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
                  if (_ContactKey.currentState.validate()) {
                    addTele(contype.text, Telecontroller.text, Shipperflag
                        // _Teletype
                        //Teletypecontroller.text
                        );
                    Navigator.pop(context);
                  }
                  Telecontroller.clear();
                  contype.clear();
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

  void addTele(String Tdescription, String TeleNumber, String shipperflag) {
    final expense = ShipperExpenseList(
        Shipper_Contact_Type: Tdescription,
        Shipper_Contact_Detail: TeleNumber,
        flag: Shipperflag);
    setState(() {
      expenseList.add(expense);
    });
  }

  void addConsignee(
      String Tdescription, String TeleNumber, String consigneeflag) {
    final expense = ConsigneeExpenseList(
        Consignee_Contact_Type: Tdescription,
        Consignee_Contact_Detail: TeleNumber,
        flag: consigneeflag);
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
              //S.of(context).AddConsigneeNumber,
              "Add Consignee Contact",
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
                          labelText: S.of(context).Type,
                          //"Type",
                          //S.of(context).Origin,
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
                          labelText: S.of(context).EmailId,
                          //"Email",
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          hintText: S.of(context).Enteremail,
                          //"Enter the Email"
                        ),
                        controller: Consigneecontact,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).Pleaseentertheemailaddress;
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
                          labelText: S.of(context).PhoneNumber,
                          //'Phone Number',
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        initialCountryCode: 'IN', //default contry code
                        onChanged: (phone) {
                          setState(() {
                            int flagOffset = 0x1F1E6;
                            int asciiOffset = 0x41;

                            String country = phone.countryISOCode;

                            int firstChar = country.codeUnitAt(0) -
                                asciiOffset +
                                flagOffset;
                            int secondChar = country.codeUnitAt(1) -
                                asciiOffset +
                                flagOffset;
                            //   countrcode=phone.countryISOCode;
                            Consigneeflag = String.fromCharCode(firstChar) +
                                String.fromCharCode(secondChar);
                            //initialCountryCode = phone.countryCode as String;
                            Consigneecontact.text = phone.completeNumber;
                          });
                          //when phone number country code is changed
                          // print(phone.completeNumber); //get complete number
                          // print(phone.countryCode); // get country code only
                          // print(phone.number); // only phone number
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
                    addConsignee(Consigneecontype.text, Consigneecontact.text,
                        Consigneeflag
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
                  //"Submit",
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                )),
          ],
        ),
      );
}
