import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rooster/formatter.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/screenroute.dart';
import 'package:rooster/ui/drodowns/airline_code.dart';
import 'package:rooster/ui/drodowns/airport_code.dart';
import 'package:rooster/ui/hawb/main_hawb.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:dropdownfield/dropdownfield.dart';
import '../../../string.dart';
import 'package:http/http.dart' as http;

class AddSlotBooking extends StatefulWidget {
  @override
  _AddSlotBookingState createState() => _AddSlotBookingState();
}

class _AddSlotBookingState extends State<AddSlotBooking> {
  final _awbForm = GlobalKey<FormState>();
  String airline;
  String masterAWB;
  String origin;
  String destination;
  String shipment = 'T';
  String pieces;
  String weight;
  String weightUnit = 'K';
  final TextEditingController originController = TextEditingController();
  final TextEditingController airlineController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  int terminalno = 00;
  String wareHouseLocation = "";
  String wareHouseZone = "";
  int carrierNo = 00;
  String slotBookDateandTime = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          S.of(context).SlotBooking,
          //"Slot Booking",
          //  "Add Master Air Waybill"
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  S.of(context).BookYourSlot,
                  // "Book Your Slot",
                  //"Add",
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Form(
                key: _awbForm,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      truckTerminalNo(),
                      truckwarehouselocation(),
                      truckwareHouseZone(),
                      carrierCodeNo(),
                      slotTime()
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).backgroundColor,
                        elevation: 5,
                        onPressed: () {
                          if (_awbForm.currentState.validate()) {
                            insertAWBList();
                          }
                          // Navigator.pop(
                          //   context,
                          //   {
                          //     'airline': airline ?? "",
                          //     'masterAWB': masterAWB ?? "",
                          //     'origin': origin ?? "",
                          //     'destination': destination ?? "",
                          //     'shipment': shipment ?? "TOTAL",
                          //     'pieces': double.parse(pieces) ?? 0.0,
                          //     'weight': double.parse(weight) ?? 0.0,
                          //     'unit': weightUnit,
                          //   },
                          // );
                        },
                        child: Text(
                          S.of(context).BookNow,
                          // "Book Now"
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> insertAWBList() async {
    var result;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(StringData.awblistAPI,
        headers: <String, String>{
          'x-access-tokens': prefs.getString('token'),
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "prefix": airline,
          "wayBillNumber": masterAWB,
          "origin": origin,
          "destination": destination,
          "shipmentcode": shipment,
          "pieces": pieces,
          "weightcode": weightUnit,
          "weight": weight
        }));
    result = json.decode(response.body);
    if (result['message'] == 'token expired') {
      refreshToken();
      insertAWBList();
    } else {
      result = json.decode(response.body);
      print(prefs.getString('token'));
      print("@@@@@@@@@@@@@@@@@");
      if (response.statusCode == 201) {
        print(result);
        Fluttertoast.showToast(
            msg: 'Your Slot Booked',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white
        );

        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text("Your Slot Booked"),
        // ));
        // insertAWB();
        // _showMessage(
        //     S.of(context).YourSlotBooked
        //     //"Your Slot Booked"
        //     , Colors.green, Colors.white);
        Navigator.push(context, HomeScreenRoute(MyEawb()));
        // Navigator.of(context).push(MyEawb());
        ///print("Data inserted");
      } else {
        Fluttertoast.showToast(
            msg: 'Slot Booking Failed',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white
        );

        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text("Slot Booking Failed"),
        // ));
        // _showMessage(
        //     S.of(context).SlotBookingFailed
        //   //"Slot Booking Failed "
        //     , Colors.red, Colors.white);
        print("Data insertion faild");
      }
    }
    return result;
  }
  //
  // void _showMessage(String message, Color bgcolor, txtcolor) {
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

  truckTerminalNo() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: terminalno.toString(),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,
                    //color: Colors.deepPurple,
                    width: 2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText:
            S.of(context).TerminalNo,
            //"Terminal No",
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontSize: 16.0),
            //'Name',
            suffixIcon: Icon(
              Icons.contacts_rounded,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )),
        onChanged: (text) {
          terminalno = text as int;
        },
      ),
    );
  }

  truckwareHouseZone() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: wareHouseZone,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,
                    //color: Colors.deepPurple,
                    width: 2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText:
            S.of(context).WarehouseZone,
            //"Warehouse Zone",
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontSize: 16.0),
            //'Name',
            suffixIcon: Icon(
              Icons.contacts_rounded,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )),
        onChanged: (text) {
          // model.setshipperName(text);
          // model.shipperName = text;
          wareHouseZone = text;
        },
      ),
    );
  }

  truckwarehouselocation() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: wareHouseLocation,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,
                    //color: Colors.deepPurple,
                    width: 2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText:
            S.of(context).WarehouseLocation,
            //"Warehouse Location",
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontSize: 16.0),
            //'Name',
            suffixIcon: Icon(
              Icons.contacts_rounded,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )),
        onChanged: (text) {
          // model.setshipperName(text);
          wareHouseLocation = text;
        },
      ),
    );
  }

  carrierCodeNo() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: "",
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,
                    //color: Colors.deepPurple,
                    width: 2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText:
            S.of(context).Sph,
            //"Sph",
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontSize: 16.0),
            //'Name',
            suffixIcon: Icon(
              Icons.contacts_rounded,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )),
        onChanged: (text) {
          // model.setshipperName(text);
          carrierNo = text as int;
        },
      ),
    );
  }

  slotTime() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () async {
          final month = [
            'JAN',
            'FEB',
            'MAR',
            'APR',
            'MAY',
            "JUNE",
            "JULY",
            'AUG',
            'SEPT',
            'OCT',
            'NOV',
            'DEC'
          ];
          DateTime _date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1000, 01, 01),
            lastDate: DateTime(DateTime.now().year + 1000, 01, 01),
          );
          _date = _date ?? DateTime.now();
          setState(() {
            slotBookDateandTime =
            '${_date.day}${month[_date.month - 1]}${_date.year}';
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: ListTile(
            title: Text(slotBookDateandTime),
            trailing: Icon(
              Icons.date_range,
              color: Theme.of(context).accentColor,
              //color: Colors.deepPurple,
            ),
            subtitle: Text(
              S.of(context).slotbookdateandtime,
              //  "slot book date and time",
              style: TextStyle(
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple
              ),
              // 'Flight Date'
            ),
          ),
        )
        /*TextFormField(
          initialValue: model.routeAndFlightNumberOrDate2,
          focusNode: _routeAndFlightNumberOrDate2FocusNode,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          inputFormatters: [AllCapitalCase()],
          onFieldSubmitted: (value) {
            _routeAndFlightNumberOrDate2FocusNode.unfocus();
          },
          decoration: InputDecoration(
            counterText: "Example : BA1234A/15AUG2020",
            border: OutlineInputBorder(
                gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: 'Flight Date',
          ),
          onChanged: (text) {
            setState(() {
              model.routeAndFlightNumberOrDate2 = text;
            });
          },
        )*/
        ,
      ),
    );
  }
}
