import 'dart:convert';

// import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:rooster/screenroute.dart';
import 'package:rooster/string.dart';
import 'package:rooster/ui/hawb/house_details.dart';
import 'package:rooster/ui/drodowns/AddContactDetails.dart';
import 'package:rooster/ui/hawb/static/edit_house_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'fhl_models/fhl_charge_declaration_model.dart';
import 'fhl_models/fhl_consignee_model.dart';
import 'fhl_models/fhl_customs_security_model.dart';
import 'fhl_models/fhl_house_details_model.dart';
import 'fhl_models/fhl_quantity_details_model.dart';
import 'fhl_models/fhl_shipper_model.dart';
import 'fhl_models/fhl_special_requirements_model.dart';

class FHLModel
    with
        ChangeNotifier,
        FHLChargeDeclarationModel,
        FHLConsigneeModel,
        FHLCustomsSecurityModel,
        FHLHouseDetailsModel,
        FHLQuantityDetailsModel,
        FHLShipperModel,
        FHLSpecialRequirementModel {
  clear() {
    clearChargeDeclaration();
    clearConsignee();
    clearCustomsSecurity();
    clearHouseDetails();
    clearQuantityDetails();
    clearShipper();
    clearSpecialRequirement();
  }

  Future<dynamic> updateFHL(int fhlawbid) async {
    var result;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Update FHL");

    sippercontactList.forEach(
        (item) => item.removeWhere((key, value) => key == "isSelected"));
    consigneeContactList.forEach(
        (item) => item.removeWhere((key, value) => key == "isSelected"));
    specialCode.forEach(
        (item) => item.removeWhere((key, value) => key == "isSelected"));
    hormoCode.forEach(
        (item) => item.removeWhere((key, value) => key == "isSelected"));
    print("iddddd"+fhlawbid.toString());

    print("Shipper contact list" +
        jsonEncode(sippercontactList) +
        jsonEncode(consigneeContactList));

    var response = await http.put(StringData.hawblistAPI,
        body: jsonEncode({
          "id": fhlawbid,
          "serialNumber": houseDetailsNumber,
          "origin": houseDetailsOrigin,
          "destination": houseDetailsDestination,
          "description": houseDetailsNatureGoods,
          "currencyCode": chargeDeclarationCurrencyCode,
          "weightVal": chargeDeclarationWeightValue,
          "charges": "C",
          "carriageValue": chargeDeclarationCarriageValue,
          "customsValue": chargeDeclarationCustomsValue,
          "insuranceValue": chargeDeclarationInsuranceValue,
          "s_name": shipperName,
          "s_address": shipperAddress,
          "s_place": shipperPlace,
          "s_state": shipperState,
          "s_countryCode": shipperCode,
          "s_postCode": shipperPostCode,
          "s_customertype": shipperIdentifier,
          "c_name": consigneeName,
          "c_address": consigneeAddress,
          "c_place": consigneePlace,
          "c_state": consigneeState,
          "c_countryCode": consigneeCode,
          "c_postCode": consigneePostCode,
          "c_customertype": "T",
          "pieces": 10,
          "weightCode": quantityDetailsWeightUnit,
          //"weight": int.tryParse(quantityDetailsWeight),
          //"SLAC": int.tryParse(quantityDetailsSLAC),
          "spl1": specialRequirementSpecialCode,
          "spl2": "",
          "spl3": "",
          "spl4": "",
          "spl5": "",
          "spl6": "",
          "spl7": "",
          "spl8": "",
          "spl9": "",
          "harmonisedCode1": specialRequirementHarmonisedCode,
          "harmonisedCode2": "FEGRG",
          "harmonisedCode3": "",
          "harmonisedCode4": "",
          "harmonisedCode5": "",
          "harmonisedCode6": "",
          "harmonisedCode7": "",
          "harmonisedCode8": "",
          "harmonisedCode9": "",
          "Extended_description": houseDetailsDescription,
          "customsSecurity": [
            {
              "countryCode": customsSecurityCountryCode,
              "informationIdentifier": customsSecurityInfoIdentifier,
              "csrcIdentifier": customsSecurityCSRCIdentifier,
              "scsrcInformation": customsSecuritySCSRCIdentifier
            },
            {
              "countryCode": "SK",
              "informationIdentifier": "SD",
              "csrcIdentifier": "ED",
              "scsrcInformation": "SD"
            }
          ],
          "contactshipper": sippercontactList.toList(),
          "consigneeContact": consigneeContactList.toList(),
        }),
        headers: {
          'x-access-tokens': prefs.getString('token'),
          'Content-Type': 'application/json; charset=UTF-8',
        });

     result = json.decode(response.body);
    if (response.statusCode == 200) {
      return "house added sucess";
    } else {
      return "failed";
    }
  }

  Future<String> insertFHL(String fhlawbid) async {
    var result;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // sippercontactList.forEach(
    //     (item) => item.removeWhere((key, value) => key == "isSelected"));
    // consigneeContactList.forEach(
    //     (item) => item.removeWhere((key, value) => key == "isSelected"));

    print(newshipperContactList);
    print(jsonEncode(newconsigneeContactList));

    specialCode.forEach(
        (item) => item.removeWhere((key, value) => key == "isSelected"));
    hormoCode.forEach(
        (item) => item.removeWhere((key, value) => key == "isSelected"));

    // print("Shipper contact list" +
    //     jsonEncode(sippercontactList) +
    //     jsonEncode(consigneeContactList));
    print(houseDetailsNumber);

    var response = await http.post(StringData.hawblistAPI,
        headers: {
          'x-access-tokens': prefs.getString('token'),
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "serialNumber": houseDetailsNumber,
          "origin": houseDetailsOrigin,
          "destination": houseDetailsDestination,
          "description": houseDetailsNatureGoods,
          "AWBList_id": fhlawbid,
          "currencyCode": chargeDeclarationCurrencyCode,
          "weightVal": chargeDeclarationWeightValue,
          "charges": "C",
          "carriageValue": chargeDeclarationCarriageValue,
          "customsValue": chargeDeclarationCustomsValue,
          "insuranceValue": chargeDeclarationInsuranceValue,
          "s_name": shipperName,
          "s_address": shipperAddress,
          "s_place": shipperPlace,
          "s_state": shipperState,
          "s_countryCode": shipperCode,
          "s_postCode": shipperPostCode,
          "s_customertype": shipperIdentifier,
          "c_name": consigneeName,
          "c_address": consigneeAddress,
          "c_place": consigneePlace,
          "c_state": consigneeState,
          "c_countryCode": consigneeCode,
          "c_postCode": consigneePostCode,
          "c_customertype": "T",
          "pieces": quantityDetailsPieces,
          "weightCode": quantityDetailsWeightUnit,
          "weight": quantityDetailsWeight,
          "SLAC": quantityDetailsSLAC,
          "spl1": "DC",
          //"spl1": specialCode[0]['specialcode'].toString(),
          "spl2": "",
          "spl3": "",
          "spl4": "",
          "spl5": "",
          "spl6": "",
          "spl7": "",
          "spl8": "",
          "spl9": "",
          "harmonisedCode1": "HRM1",
          //"harmonisedCode1": hormoCode[0]['hormonisedcode'].toString(),
          "harmonisedCode2": "",
          "harmonisedCode3": "",
          "harmonisedCode4": "",
          "harmonisedCode5": "",
          "harmonisedCode6": "",
          "harmonisedCode7": "",
          "harmonisedCode8": "",
          "harmonisedCode9": "",
          "Extended_description": houseDetailsDescription,
          "customsSecurity": [
            {
              "countryCode": customsSecurityCountryCode,
              "informationIdentifier": customsSecurityInfoIdentifier,
              "csrcIdentifier": customsSecurityCSRCIdentifier,
              "scsrcInformation": customsSecuritySCSRCIdentifier
            },
            {
              "countryCode": "SK",
              "informationIdentifier": "SD",
              "csrcIdentifier": "ED",
              "scsrcInformation": "SD"
            }
          ],
          "contactshipper": newshipperContactList,
          "consigneeContact": newconsigneeContactList,

          // "serialNumber": houseDetailsNumber,
          // "origin": "BLR",
          // "destination": "DXB",
          // "description": "gwegwgwg",
          // "AWBList_id": fhlawbid,
          // "currencyCode": "RS",
          // "weightVal": "K",
          // "charges": "C",
          // "carriageValue": "45",
          // "customsValue": "68",
          // "insuranceValue": "85",
          // "s_name": "Mithun",
          // "s_address": "asd",
          // "s_place": "dg",
          // "s_state": "TN",
          // "s_countryCode": "IN",
          // "s_postCode": "638108",
          // "s_customertype": "",
          // "c_name": "tqwe",
          // "c_address": "wetqwe",
          // "c_place": "wtwe",
          // "c_state": "wt",
          // "c_countryCode": "DE",
          // "c_postCode": "638151",
          // "c_customertype": "T",
          // "pieces": "45",
          // "weightCode": "K",
          // "weight": "69",
          // "SLAC": "1",
          // "spl1": "",
          // "spl2": "",
          // "spl3": "",
          // "spl4": "",
          // "spl5": "",
          // "spl6": "",
          // "spl7": "",
          // "spl8": "",
          // "spl9": "",
          // "harmonisedCode1": "",
          // "harmonisedCode2": "",
          // "harmonisedCode3": "",
          // "harmonisedCode4": "",
          // "harmonisedCode5": "",
          // "harmonisedCode6": "",
          // "harmonisedCode7": "",
          // "harmonisedCode8": "",
          // "harmonisedCode9": "",
          // "Extended_description": "saggagasgsdg",
          // "customsSecurity": [
          //   {
          //     "countryCode": "IN",
          //     "informationIdentifier": "SD",
          //     "csrcIdentifier": "ED",
          //     "scsrcInformation": "SD"
          //   },
          //   {
          //     "countryCode": "SK",
          //     "informationIdentifier": "SD",
          //     "csrcIdentifier": "ED",
          //     "scsrcInformation": "SD"
          //   }
          // ],
          // "contactshipper": [
          //   {
          //     "Shipper_Contact_Detail": "9597774279",
          //     "Shipper_Contact_Type": "TE"
          //   }
          // ],
          // "consigneeContact": [
          //   {
          //     "Consignee_Contact_Detail": "9597774278",
          //     "Consignee_Contact_Type": "TL"
          //   }
          // ]
        }),);

    //print("@@@@@@@@@@@@@@@@@");

     result = json.decode(response.body);
    print(result);
    print(fhlawbid);
    if (response.statusCode == 201 || response.statusCode == 200) {
      print(result);
      // Navigator.push(context, HomeScreenRoute(EditEawb("",id: fhlawbid)));
      print("Data inserted");

      return "sucess";
    } else {
      print("Data insertion failed" + result);
      return "faild";
    }
  }


  void loadHouseSampleData1() {
    clearChargeDeclaration();
    clearConsignee();
    clearCustomsSecurity();
    clearHouseDetails();
    clearQuantityDetails();
    clearShipper();
    clearSpecialRequirement();
    notifyListeners();
    //setStatus();

    houseDetailsNumber = "AGL1649";
    houseDetailsDescription = "Handle with care";
    houseDetailsOrigin = "CCJ";
    houseDetailsDestination = "RKT";
    houseDetailsNatureGoods = "Laptops";
    sippercontactList = [];

    specialRequirementSpecialCode = 'Q';
    specialRequirementHarmonisedCode = '1244587000';
    // specialCode.add({
    //   'isSelected': false,
    //   'specialcode': "DC",
    // });
    specialCode = [
      {
        'isSelected': false,
        'specialcode': "DC",
      },
    ];
    //List<Map<String, dynamic>>
    hormoCode = [
      {
        'isSelected': false,
        'hormonisedcode': 'HRMC1',
      },
    ];

    quantityDetailsPieces = '10';
    quantityDetailsWeight = '100';
    quantityDetailsWeightUnit = "K";
    quantityDetailsSLAC = '1';

    customsSecurityCountryCode = 'IN';
    customsSecurityInfoIdentifier = 'SD';
    customsSecurityCSRCIdentifier = 'ED';
    customsSecuritySCSRCIdentifier = 'ED';

    chargeDeclarationCurrencyCode = 'RS';
    chargeDeclarationWeightValue = 'K';
    chargeDeclarationOtherCharges = 'C';
    chargeDeclarationCarriageValue = '25';
    chargeDeclarationCustomsValue = '45';
    chargeDeclarationInsuranceValue = '35';

    shipperName = 'NAVEEN';
    shipperAddress = 'KARIPUR';
    shipperPlace = 'KARIPUR';
    shipperState = 'KERALA';
    shipperCode = 'IN';
    shipperPostCode = '673647';
    shipperIdentifier = '';
    shipperNumber = '';
    //List<Map<String, dynamic>>
    sippercontactList = [

    ];

    consigneeName = 'KARTHICK';
    consigneeAddress = '';
    consigneePlace = 'RAS AL-KHAIMAH';
    consigneeState = '';
    consigneeCode = 'AE';
    consigneePostCode = '654564';
    consigneeIdentifier = '';
    consigneeNumber = '';
    //List<Map<String, dynamic>>
    consigneeContactList = [];
    notifyListeners();
  }

  // void loadHouseSampleData() {
  //   // clearChargeDeclaration();
  //   // clearConsignee();
  //   // clearCustomsSecurity();
  //   // clearHouseDetails();
  //   // clearQuantityDetails();
  //   // clearShipper();
  //   // clearSpecialRequirement();
  //   // notifyListeners();
  //
  //   houseDetailsNumber = "AA1234";
  //   houseDetailsDescription = "Handle with care";
  //   houseDetailsOrigin = "CJB";
  //   houseDetailsDestination = "DXB";
  //   houseDetailsNatureGoods = "Laptop";
  //   sippercontactList = [];
  //
  //   specialRequirementSpecialCode = 'Q';
  //   specialRequirementHarmonisedCode = '1244587000';
  //   // specialCode.add({
  //   //   'isSelected': false,
  //   //   'specialcode': "DC",
  //   // });
  //   specialCode = [
  //     {
  //       'isSelected': false,
  //       'specialcode': "DC",
  //     },
  //   ];
  //   //List<Map<String, dynamic>>
  //   hormoCode = [
  //     {
  //       'isSelected': false,
  //       'hormonisedcode': 'HRMC1',
  //     },
  //   ];
  //
  //   quantityDetailsPieces = '10';
  //   quantityDetailsWeight = '200';
  //   quantityDetailsWeightUnit = "K";
  //   quantityDetailsSLAC = '20';
  //
  //   customsSecurityCountryCode = 'IN';
  //   customsSecurityInfoIdentifier = 'SHP';
  //   customsSecurityCSRCIdentifier = 'A';
  //   customsSecuritySCSRCIdentifier = 'AF';
  //
  //   chargeDeclarationCurrencyCode = 'RS';
  //   chargeDeclarationWeightValue = 'K';
  //   chargeDeclarationOtherCharges = 'P';
  //   chargeDeclarationCarriageValue = '45';
  //   chargeDeclarationCustomsValue = '62';
  //   chargeDeclarationInsuranceValue = '85';
  //
  //   shipperName = 'MAHOGANY PRIVATE LIMITED';
  //   shipperAddress = 'CHENNAI';
  //   shipperPlace = 'CHENNAI';
  //   shipperState = 'TAMIL NADU';
  //   shipperCode = 'IN';
  //   shipperPostCode = '654564';
  //   shipperIdentifier = '';
  //   shipperNumber = '';
  //   //List<Map<String, dynamic>>
  //   sippercontactList = [];
  //
  //   consigneeName = 'NAVEEN';
  //   consigneeAddress = 'TIRUPPUR';
  //   consigneePlace = 'TIRUPPUR';
  //   consigneeState = 'TAMIL NADU';
  //   consigneeCode = 'IN';
  //   consigneePostCode = '654564';
  //   consigneeIdentifier = '';
  //   consigneeNumber = '';
  //   //List<Map<String, dynamic>>
  //   consigneeContactList = [];
  //   notifyListeners();
  // }
  notifyListeners();
  // setStatus();
}
