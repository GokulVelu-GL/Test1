import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rooster/model/manifest_bulkModel.dart';
import 'package:rooster/ui/homescreen/flight_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../string.dart';

class ManifestModel with ChangeNotifier {
  String carrieerCode;
  String manifestFlight;
  DateTime departureDate;
  List<ManifestBulkModel> bulkList = [];

  Future<dynamic> getFlight(
      String carrierCode, String flightNo, String date) async {
    var result;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(StringData.flightlistAPI);
    final request = http.Request("OPTIONS", url);
    request.headers.addAll(<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-access-tokens': prefs.getString('token')
    });
    request.body = jsonEncode({
      "carriercode": flightNo.substring(0, 1),
      "flightnumber": flightNo.substring(2),
      "departuredate": departureDate,
      "airport_code1": "",
      "airport_code2": "",
      "airport_code3": "",
      "airport_code4": "",
      "airport_code5": "",
      "airport_code6": "",
      "airport_code7": "",
      "airport_code8": ""
    });
    result = await request.send();
    final respStr = await result.stream.bytesToString();
    result = jsonDecode(respStr);
    print(result);
    if (result['message'] == 'token expired') {
      refreshToken();
      getFlight(carrierCode, flightNo, date);
    } else {
      //getAWBlist();
      print(prefs.getString('token'));
    }
    try {
      print("flight List Details " + '${result["flight"][0]}');
      var flightdata = result["flight"][0];
      carrieerCode = flightdata['carriercode'].toString();
      manifestFlight = flightdata['flightnumber'];
      departureDate = new DateFormat("dd-MM-y").parseStrict("12-05-2022");
      return "true";
    } catch (e) {
      print(e);
    }
    return "false";
  }

  Future<String> printeManifest(
      ManifestModel model, String emailId, var segmentList) async {
    // String jsonList = jsonEncode(otherChargesList);
    print(model.departureDate);
    //ManifestModel model;
    print(emailId);

    SharedPreferences prefs =
        await SharedPreferences.getInstance(); // ! get SharedPreferences....
    var response = await http.post(StringData.manifestPdfAPI,
        headers: {
          'x-access-tokens': prefs.getString('token'),
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            "ReceiverMailAddress": emailId.toString(),
            //"dronaeawb1@gmail.com,gokulvelu16@gmail.com",
            "ManifestJSON": {
              "FFM_Aircraft_Identification_Day": "",
              "FFM_Aircraft_Identification_Month": "",
              "FFM_Flight_Identification_CarrierCode": carrieerCode,
              "FFM_Flight_Identification_Day": //"19",
                  model.departureDate.day.toString(),
              "FFM_Flight_Identification_FlightNumber": model.manifestFlight,
              "FFM_Flight_Identification_Month":
                  model.departureDate.month.toString(),
              "FFM_Flight_Identification_Time": "",
              // "FFM_Flight_Identification_Time":
              //     model.departureDate.hour.toString() +
              //         ":" +
              //         model.departureDate.minute
              //             .toString(), //departureDate.toString(),
              "FFM_Flight_Identification_Year":
                  model.departureDate.year.toString(),
              "FFM_Message_SequenceNumber": "1",
              "FFM_PointOfLoading_Aircraft_Registeration": "",
              "FFM_PointOfLoading_AirportCode": "CJB",
              "FFM_PointOfLoading_AirportCode_Arrival": "",
              "FFM_PointOfLoading_ISO_Country_Code": "",
              "FFM_Standard_MessageIdentifier": "FFM",
              "FFM_TypeVersionNumber": "8",
              "RT_ExportGeneralManifestNo": "",
              "RT_ForOfficeUseRemarks": "",
              "RT_ImportGeneralManifestNo": "",
              "RT_InternalRemarks": "",
              "RT_ManifestRemarks": "",
              "RT_Manifest_Generated_By_DateTime": "",
              "RT_Manifest_Generated_By_UserId": "",
              "RT_Manifest_Generated_By_UserName": "",
              "RT_Manifest_Generated_By_User_Digital_SignatureId": "",
              "Segment": [
                {
                  //"Bulk_Consignment_details": bulkList,
                  "Bulk_Consignment_details": [
                    {
                      "FFM_AWB_Identification_AWB_SerialNumber": "00122485",
                      "FFM_AWB_Identification_AirlinePrefix": "176",
                      "FFM_Aircraft_Identification_Day": "",
                      "FFM_Aircraft_Identification_Month": "",
                      "FFM_AirportCode_Destination": "DXB",
                      "FFM_AirportCode_Origin": "BLR",
                      "FFM_Consignment_Detail_DensityGroup": "",
                      "FFM_Consignment_Detail_DensityIndicator": "",
                      "FFM_Consignment_Detail_NatureOfGoods": "GARMENTS",
                      "FFM_Consignment_Detail_NumberOfPieces": "4",
                      "FFM_Consignment_Detail_Quantity_Detail_Weight": "800",
                      "FFM_Consignment_Detail_Quantity_Detail_Weight_Code": "K",
                      "FFM_Consignment_Detail_Shipment_Description_Code": "T",
                      "FFM_Consignment_Detail_Special_Handling_Code1": "",
                      "FFM_Consignment_Detail_Special_Handling_Code2": "",
                      "FFM_Consignment_Detail_Special_Handling_Code3": "",
                      "FFM_Consignment_Detail_Special_Handling_Code4": "",
                      "FFM_Consignment_Detail_Special_Handling_Code5": "",
                      "FFM_Consignment_Detail_Special_Handling_Code6": "",
                      "FFM_Consignment_Detail_Special_Handling_Code7": "",
                      "FFM_Consignment_Detail_Special_Handling_Code8": "",
                      "FFM_Consignment_Detail_Special_Handling_Code9": "",
                      "FFM_Consignment_Detail_TotalConsignment_NumberOfPieces":
                          "",
                      "FFM_Consignment_Detail_TotalConsignment_Shipment_Description_Code":
                          "",
                      "FFM_Consignment_Detail_VolumeAmount": "4.8",
                      "FFM_Consignment_Detail_VolumeCode": "MC",
                      "FFM_Consignment_Onward_Movement_Information": [],
                      "FFM_CustomsOrigin_Code": "",
                      "FFM_Dimension_Details": [],
                      "FFM_First_Other_Service_Information": "",
                      "FFM_OtherCustoms_Information": [],
                      "FFM_PointOfLoading_Aircraft_Registeration": "",
                      "FFM_PointOfLoading_AirportCode_Arrival": "",
                      "FFM_PointOfLoading_ISO_Country_Code": "",
                      "FFM_Second_Other_Service_Information": "",
                      "RT_BillofEntryNo": "",
                      "RT_CustomsExaminationDateTime": "",
                      "RT_CustomsExaminationIndicator": "",
                      "RT_CustomsExaminationOfficerName": "",
                      "RT_CustomsExaminationOrderNo": "",
                      "RT_CustomsRemarks": "",
                      "RT_ForOfficeUseRemarks": "",
                      "RT_InternalRemarks": "",
                      "RT_ManifestRemarks": "",
                      "RT_PhysicalVerification": "",
                      "RT_ScanType": "",
                      "RT_Scanned_Indicator": "",
                      "RT_ShippingBillNo": ""
                    }
                  ],

                  "FFM_PointOfUnLoading_AirportCode": "DXB",
                  "FFM_PointOfUnLoading_Arrival_Day": "",
                  "FFM_PointOfUnLoading_Arrival_Month": "",
                  "FFM_PointOfUnLoading_Arrival_Time": "",
                  "FFM_PointOfUnLoading_Departure_Day": "",
                  "FFM_PointOfUnLoading_Departure_Month": "",
                  "FFM_PointOfUnLoading_Departure_Time": "",
                  "FFM_PointOfUnLoading_Nil_Cargo_Code": "",
                  "RT_ExportGeneralManifestNo": "",
                  "RT_ForOfficeUseRemarks": "",
                  "RT_ImportGeneralManifestNo": "",
                  "RT_InternalRemarks": "",
                  "RT_ManifestRemarks": "",
                  "ULD_Consignment_details": [
                    {
                      "Consignment_details": [
                        {
                          "FFM_AWB_Identification_AWB_SerialNumber": "00123060",
                          "FFM_AWB_Identification_AirlinePrefix": "176",
                          "FFM_Aircraft_Identification_Day": "",
                          "FFM_Aircraft_Identification_Month": "",
                          "FFM_AirportCode_Destination": "DXB",
                          "FFM_AirportCode_Origin": "CJB",
                          "FFM_Consignment_Detail_DensityGroup": "",
                          "FFM_Consignment_Detail_DensityIndicator": "",
                          "FFM_Consignment_Detail_NatureOfGoods":
                              "MACHINE PARTS",
                          "FFM_Consignment_Detail_NumberOfPieces": "3",
                          "FFM_Consignment_Detail_Quantity_Detail_Weight":
                              "120",
                          "FFM_Consignment_Detail_Quantity_Detail_Weight_Code":
                              "K",
                          "FFM_Consignment_Detail_Shipment_Description_Code":
                              "P",
                          "FFM_Consignment_Detail_Special_Handling_Code1": "",
                          "FFM_Consignment_Detail_Special_Handling_Code2": "",
                          "FFM_Consignment_Detail_Special_Handling_Code3": "",
                          "FFM_Consignment_Detail_Special_Handling_Code4": "",
                          "FFM_Consignment_Detail_Special_Handling_Code5": "",
                          "FFM_Consignment_Detail_Special_Handling_Code6": "",
                          "FFM_Consignment_Detail_Special_Handling_Code7": "",
                          "FFM_Consignment_Detail_Special_Handling_Code8": "",
                          "FFM_Consignment_Detail_Special_Handling_Code9": "",
                          "FFM_Consignment_Detail_TotalConsignment_NumberOfPieces":
                              "5",
                          "FFM_Consignment_Detail_TotalConsignment_Shipment_Description_Code":
                              "T",
                          "FFM_Consignment_Detail_VolumeAmount": "1.2",
                          "FFM_Consignment_Detail_VolumeCode": "MC",
                          "FFM_CustomsOrigin_Code": "",
                          "FFM_Dimension_Details": [],
                          "FFM_First_Other_Service_Information": "",
                          "FFM_OtherCustoms_Information": [],
                          "FFM_PointOfLoading_Aircraft_Registeration": "",
                          "FFM_PointOfLoading_AirportCode_Arrival": "",
                          "FFM_PointOfLoading_ISO_Country_Code": "",
                          "FFM_Second_Other_Service_Information": "",
                          "FFM_ULD_Consignment_Onward_Movement_Information": [],
                          "RT_BillofEntryNo": "",
                          "RT_CustomsExaminationDateTime": "",
                          "RT_CustomsExaminationIndicator": "",
                          "RT_CustomsExaminationOfficerName": "",
                          "RT_CustomsExaminationOrderNo": "",
                          "RT_CustomsRemarks": "",
                          "RT_ForOfficeUseRemarks": "",
                          "RT_InternalRemarks": "",
                          "RT_ManifestRemarks": "",
                          "RT_PhysicalVerification": "",
                          "RT_ScanType": "",
                          "RT_Scanned_Indicator": "",
                          "RT_ShippingBillNo": ""
                        },
                        {
                          "FFM_AWB_Identification_AWB_SerialNumber": "00123023",
                          "FFM_AWB_Identification_AirlinePrefix": "176",
                          "FFM_Aircraft_Identification_Day": "",
                          "FFM_Aircraft_Identification_Month": "",
                          "FFM_AirportCode_Destination": "DXB",
                          "FFM_AirportCode_Origin": "CJB",
                          "FFM_Consignment_Detail_DensityGroup": "",
                          "FFM_Consignment_Detail_DensityIndicator": "",
                          "FFM_Consignment_Detail_NatureOfGoods":
                              "COMPACT DISCS",
                          "FFM_Consignment_Detail_NumberOfPieces": "7",
                          "FFM_Consignment_Detail_Quantity_Detail_Weight": "70",
                          "FFM_Consignment_Detail_Quantity_Detail_Weight_Code":
                              "K",
                          "FFM_Consignment_Detail_Shipment_Description_Code":
                              "P",
                          "FFM_Consignment_Detail_Special_Handling_Code1": "",
                          "FFM_Consignment_Detail_Special_Handling_Code2": "",
                          "FFM_Consignment_Detail_Special_Handling_Code3": "",
                          "FFM_Consignment_Detail_Special_Handling_Code4": "",
                          "FFM_Consignment_Detail_Special_Handling_Code5": "",
                          "FFM_Consignment_Detail_Special_Handling_Code6": "",
                          "FFM_Consignment_Detail_Special_Handling_Code7": "",
                          "FFM_Consignment_Detail_Special_Handling_Code8": "",
                          "FFM_Consignment_Detail_Special_Handling_Code9": "",
                          "FFM_Consignment_Detail_TotalConsignment_NumberOfPieces":
                              "10",
                          "FFM_Consignment_Detail_TotalConsignment_Shipment_Description_Code":
                              "T",
                          "FFM_Consignment_Detail_VolumeAmount": "0.13",
                          "FFM_Consignment_Detail_VolumeCode": "MC",
                          "FFM_CustomsOrigin_Code": "",
                          "FFM_Dimension_Details": [],
                          "FFM_First_Other_Service_Information": "",
                          "FFM_OtherCustoms_Information": [],
                          "FFM_PointOfLoading_Aircraft_Registeration": "",
                          "FFM_PointOfLoading_AirportCode_Arrival": "",
                          "FFM_PointOfLoading_ISO_Country_Code": "",
                          "FFM_Second_Other_Service_Information": "",
                          "FFM_ULD_Consignment_Onward_Movement_Information": [],
                          "RT_BillofEntryNo": "",
                          "RT_CustomsExaminationDateTime": "",
                          "RT_CustomsExaminationIndicator": "",
                          "RT_CustomsExaminationOfficerName": "",
                          "RT_CustomsExaminationOrderNo": "",
                          "RT_CustomsRemarks": "",
                          "RT_ForOfficeUseRemarks": "",
                          "RT_InternalRemarks": "",
                          "RT_ManifestRemarks": "",
                          "RT_PhysicalVerification": "",
                          "RT_ScanType": "",
                          "RT_Scanned_Indicator": "",
                          "RT_ShippingBillNo": ""
                        }
                      ],
                      "FFM_ULD_Onward_Movement_Information": [],
                      "ULD_Description_LineIdentifier": "ULD",
                      "ULD_Loading_Indicator": "",
                      "ULD_Owner_Code": "EK",
                      "ULD_Remarks": "",
                      "ULD_Serial_Number": "04001",
                      "ULD_Type": "AKE"
                    },
                    {
                      "Consignment_details": [
                        {
                          "FFM_AWB_Identification_AWB_SerialNumber": "00123082",
                          "FFM_AWB_Identification_AirlinePrefix": "176",
                          "FFM_Aircraft_Identification_Day": "",
                          "FFM_Aircraft_Identification_Month": "",
                          "FFM_AirportCode_Destination": "DXB",
                          "FFM_AirportCode_Origin": "CJB",
                          "FFM_Consignment_Detail_DensityGroup": "",
                          "FFM_Consignment_Detail_DensityIndicator": "",
                          "FFM_Consignment_Detail_NatureOfGoods": "LAPTOPS",
                          "FFM_Consignment_Detail_NumberOfPieces": "80",
                          "FFM_Consignment_Detail_Quantity_Detail_Weight":
                              "300",
                          "FFM_Consignment_Detail_Quantity_Detail_Weight_Code":
                              "K",
                          "FFM_Consignment_Detail_Shipment_Description_Code":
                              "T",
                          "FFM_Consignment_Detail_Special_Handling_Code1":
                              "VAL",
                          "FFM_Consignment_Detail_Special_Handling_Code2": "",
                          "FFM_Consignment_Detail_Special_Handling_Code3": "",
                          "FFM_Consignment_Detail_Special_Handling_Code4": "",
                          "FFM_Consignment_Detail_Special_Handling_Code5": "",
                          "FFM_Consignment_Detail_Special_Handling_Code6": "",
                          "FFM_Consignment_Detail_Special_Handling_Code7": "",
                          "FFM_Consignment_Detail_Special_Handling_Code8": "",
                          "FFM_Consignment_Detail_Special_Handling_Code9": "",
                          "FFM_Consignment_Detail_TotalConsignment_NumberOfPieces":
                              "",
                          "FFM_Consignment_Detail_TotalConsignment_Shipment_Description_Code":
                              "",
                          "FFM_Consignment_Detail_VolumeAmount": "0.7",
                          "FFM_Consignment_Detail_VolumeCode": "MC",
                          "FFM_CustomsOrigin_Code": "",
                          "FFM_Dimension_Details": [],
                          "FFM_First_Other_Service_Information": "",
                          "FFM_OtherCustoms_Information": [],
                          "FFM_PointOfLoading_Aircraft_Registeration": "",
                          "FFM_PointOfLoading_AirportCode_Arrival": "",
                          "FFM_PointOfLoading_ISO_Country_Code": "",
                          "FFM_Second_Other_Service_Information": "",
                          "FFM_ULD_Consignment_Onward_Movement_Information": [],
                          "RT_BillofEntryNo": "",
                          "RT_CustomsExaminationDateTime": "",
                          "RT_CustomsExaminationIndicator": "",
                          "RT_CustomsExaminationOfficerName": "",
                          "RT_CustomsExaminationOrderNo": "",
                          "RT_CustomsRemarks": "",
                          "RT_ForOfficeUseRemarks": "",
                          "RT_InternalRemarks": "",
                          "RT_ManifestRemarks": "",
                          "RT_PhysicalVerification": "",
                          "RT_ScanType": "",
                          "RT_Scanned_Indicator": "",
                          "RT_ShippingBillNo": ""
                        }
                      ],
                      "FFM_ULD_Onward_Movement_Information": [],
                      "ULD_Description_LineIdentifier": "ULD",
                      "ULD_Loading_Indicator": "",
                      "ULD_Owner_Code": "EK",
                      "ULD_Remarks": "",
                      "ULD_Serial_Number": "04002",
                      "ULD_Type": "PAP"
                    }
                  ]
                }
              ]
            }
          },
        ));

    // response = await http.get(StringData.fileEAWBAPI(response.body),
    //     headers: {'x-access-tokens': prefs.getString('token')});

    var data = response.bodyBytes;

    //Get external storage directory
    Directory directory = await getExternalStorageDirectory();
    //Get directory path
    String path = directory.path;
    //Create an empty file to write PDF data
    File file = File('$path/Output.pdf');
    //file.copy(response.body);
    //file.openWrite()
    //Write PDF data
    await file.writeAsBytes(data, flush: true);
    //Open the PDF document in mobile
    //OpenFile.open(response.body);
    OpenFile.open('$path/Output.pdf');

    //return "Data";
  }
}
