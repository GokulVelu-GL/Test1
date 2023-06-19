import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rooster/formatter.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/string.dart';
import 'package:rooster/ui/eawb/main_eawb.dart';
import 'package:rooster/screenroute.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EAWB extends StatefulWidget {
  EAWB({Key key}) : super(key: key);

  @override
  _EAWBState createState() => _EAWBState();
}

class _EAWBState extends State<EAWB> {
  var _expand = false;

  var _card = GlobalKey();
  //
  // List<String> tabs = [
  //   "Shipper",
  //   "Consignee",
  //   "Issuing carrier's agent",
  //   "Routing and flight bookings",
  //   "Awb Consignment details",
  //   "Issuer",
  //   "Accounting information",
  //   "Optional Shipping Information",
  //   "Charges declaration",
  //   "Handling information",
  //   "Rate description",
  //   "Charges summary",
  //   "CC charges in destination currency",
  //   "Other Charges",
  //   "Shipper's certification",
  //   "Carrier's execution"
  // ];

  final _awbForm = GlobalKey<FormState>();

  String _eAWBNumber = "";

  void _displayCreateAWBDialog(String awbnumber) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: 300,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            fit: StackFit.loose,
            children: <Widget>[
              Transform.translate(
                offset: Offset(0, -50),
                child: ClipOval(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: FittedBox(
                      alignment: Alignment.center,
                      child: Image.asset("assets/images/logo.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, 60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        S.of(context).UpdateWaybillNumber,
                        // "Update Waybill Number",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Container(
                        height: 100,
                        child: Center(
                            child: Text(
                          S.of(context).WouldyouliketoupdateAirWaybil,
                          //"Would you like to update Air Waybill?"
                        ))),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor)),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  HomeScreenRoute(MainEAWB(
                                    awbNumber: _eAWBNumber,
                                  )));
                              // Navigator.push(
                              //     context, HomeScreenRoute(MainEAWB()));
                            },
                            child: Text(
                              S.of(context).Yes,
                              // "Yes"
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              S.of(context).Cancel,
                              //"Cancel"
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loaderDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void _getAWBData(EAWBModel model) async {
    print("object");
    if (_awbForm.currentState.validate()) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(prefs.getString('token'));
      _loaderDialog();
      try {
        if (_eAWBNumber.isNotEmpty || _eAWBNumber != null) {
          String id = await model.getAWBid(_eAWBNumber);
          if (id == null) {
            //Navigator.pop(context);
            Navigator.of(context, rootNavigator: true).pop('dialog');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:Text('Please To create a Awb number'),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            String result = await model.getEAWB(id);
            if (result == 'New Air Waybill Number') {
              Navigator.pop(context);
              model.awbConsigmentDetailsAWBNumber = _eAWBNumber;
              _displayCreateAWBDialog(_eAWBNumber);
            }
            if (result == 'Not Valid AWB Number') {
              Navigator.pop(context);
              Navigator.of(context, rootNavigator: true).pop('dialog');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:Text("Not Valid AWB Number"),
                  duration: Duration(seconds: 2),
                ),
              );
            }
            if (result == 'AWB Number Loaded') {
              Navigator.pop(context);
              model.awbConsigmentDetailsAWBNumber = _eAWBNumber;
              Navigator.push(
                  context,
                  HomeScreenRoute(MainEAWB(
                    awbNumber: _eAWBNumber,
                  )));
            }
          }
        }
      } catch (e) {
        print(e);
        Navigator.of(context, rootNavigator: true).pop('dialog');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:Text("API Error"),
            duration: Duration(seconds: 2),
          ),
        );

        Navigator.pop(context);
      }
    }
  }

  _showDialogAWB(EAWBModel model) {
    model.clearEAWB();

    Future.delayed(Duration(milliseconds: 500), () {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            height: 300,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              fit: StackFit.loose,
              children: <Widget>[
                Transform.translate(
                  offset: Offset(0, -50),
                  child: ClipOval(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: FittedBox(
                        alignment: Alignment.center,
                        child: Image.asset("assets/images/logo.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, 60),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          S.of(context).EnterAWBnumber,
                          // "Enter AWB number",
                          style: TextStyle(fontSize: 20
                          ,
                          color:Theme.of(context).accentColor,),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Form(
                        key: _awbForm,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            validator: (value) {
                              print(value);
                              if (value.length == 13)
                                value = value.substring(0, 12);
                              if (value.isEmpty)
                                return "Give AWB Number to\ncreate or retrieve eAWB";
                              if (value.length != 12)
                                return "AWB number should be 12 including '-'";
                              if (value.indexOf("-") != 3)
                                return "Not proper AWB number\neg: 150-78596324";
                              if (!value.endsWith(
                                  '${int.parse(value.substring(4, value.length - 1)) % 7}'))
                                return "Not Valid AWB Number.";
                              return null;
                            },
                            onChanged: (value) => setState(() {
                              _eAWBNumber = value;
                            }),
                            onEditingComplete: () {
                              _getAWBData(model);
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(12),
                              MaskTextInputFormatter(
                                mask: "###-########",
                                filter: {"#": RegExp(r'[0-9]')},
                              )
                              // added AWB formatter....
                            ],
                            keyboardType: TextInputType.number,

                            cursorColor: Theme.of(context).primaryColor,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    new BorderSide(
                                        color: Theme.of(context).accentColor,
                                        // color: Colors.deepPurple,
                                        width: 2),
                                    //gapPadding: 2.0,
                                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2,
                                    color: Theme.of(context).accentColor,
                                    //   color: Colors.deepPurple
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              border: OutlineInputBorder(

                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "___-________",
                              labelText: S.of(context).AWBnumber,
                              labelStyle: TextStyle(
                                color: Theme.of(context).accentColor,
                              )
                              // "AWB-Number"
                            ),
                            maxLength: 12,
                            // maxLengthEnforced: true,
                          ),
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor)),
                        // color: Theme.of(context).accentColor,
                        // textColor: Theme.of(context).backgroundColor,
                        // elevation: 5,
                        onPressed: () {
                          print(model.awbConsigmentDetailsAWBNumber);
                          _getAWBData(model);

                          // Navigator.pop(context);
                          // model.awbConsigmentDetailsAWBNumber = _eAWBNumber;
                          // Navigator.push(
                          //     context,
                          //     HomeScreenRoute(MainEAWB(
                          //       awbNumber: _eAWBNumber,
                          //     )));
                          //Navigator.push(context, HomeScreenRoute(MainEAWB()));
                        },
                        child: Text(
                          S.of(context).Search,
                          // "Search"
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String Shipper = S.of(context).Shipper;
    String Consignee = S.of(context).Consignee;
    String Issuingcarriersagent = S.of(context).Issuingcarriersagent;
    String Routingandflightbookings = S.of(context).Routingandflightbookings;
    String AwbConsignmentdetails = S.of(context).AwbConsignmentdetails;
    String AlsoNotify = S.of(context).AlsoNotify;
    String Issuer = S.of(context).Issuer;
    String Accountinginformation = S.of(context).Accountinginformation;
    String OptionalShippingInformation =
        S.of(context).OptionalShippingInformation;
    String Chargesdeclaration = S.of(context).Chargesdeclaration;
    String Handlinginformation = S.of(context).Handlinginformation;
    String Ratedescription = S.of(context).Ratedescription;
    String Chargessummary = S.of(context).Chargessummary;
    String CCchargesindestinationcurrency =
        S.of(context).CCchargesindestinationcurrency;
    String OtherCharges = S.of(context).OtherCharges;
    String Shipperscertification = S.of(context).Shipperscertification;
    String Carriersexecution = S.of(context).Carriersexecution;

    List<String> items = [
      Shipper,
      Consignee,
      Issuingcarriersagent,
      Routingandflightbookings,
      AwbConsignmentdetails,
      AlsoNotify,
      Issuer,
      Accountinginformation,
      OptionalShippingInformation,
      Chargesdeclaration,
      Handlinginformation,
      Ratedescription,
      Chargessummary,
      CCchargesindestinationcurrency,
      OtherCharges,
      Shipperscertification,
      Carriersexecution
    ];
    return Consumer<EAWBModel>(
      builder: (BuildContext context, model, Widget child) {
        return Stack(
          children: <Widget>[
            Card(
              key: _card,
              color: Theme.of(context).backgroundColor,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              child: AnimatedContainer(
                // width: 130,
                // height: _expand ? 300 : 130,
                duration: Duration(milliseconds: 200),
              ),
            ),
            GestureDetector(
              onTap: () {
                _showDialogAWB(model);
              },
              onLongPress: () {
                _showDialogAWB(model);
              },
              child: Card(
                color: Theme.of(context).backgroundColor,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Container(
                  width: 90,
                  height: 90,
                  child: Center(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // SizedBox(
                            //   height: 10,
                            // ),
                            Image(
                              width: 39.0,
                              color: Theme.of(context).accentColor,
                              image: AssetImage(
                                "assets/homescreen/eawb.png"
                                //  "https://cdn.iconscout.com/icon/free/png-64/e-way-bill-1817343-1538217.png"
                                  // "https://cdn.iconscout.com/icon/free/png-64/e-way-bill-1817316-1538184.png"
                                  //   "https://cdn-icons-png.flaticon.com/512/4301/4301590.png"),
                                  ),
                            ),
                            SizedBox(
                              height: 05,
                            ),
                            Text(
                              S.of(context).eAWB,
                              //"eAWB",
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                //color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
