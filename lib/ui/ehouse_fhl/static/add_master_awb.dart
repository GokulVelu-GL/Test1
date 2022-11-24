import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rooster/formatter.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/string.dart';
import 'package:rooster/ui/hawb/main_hawb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddMasterAWBFHL extends StatefulWidget {
  @override
  _AddMasterAWBState createState() => _AddMasterAWBState();
}

class _AddMasterAWBState extends State<AddMasterAWBFHL> {
  final _awbForm = GlobalKey<FormState>();
  String airline;
  String masterAWB;
  String origin;
  String destination;
  String shipment = 'T';
  String pieces;
  String weight;
  String weightUnit = 'K';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AddMasterAirWaybill
            // "Add Master Air Waybill"
            ),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  S.of(context).Add,
                  // "Add",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Form(
                key: _awbForm,
                //autovalidate: false,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: airlineTF(),
                              flex: 3,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: masterAWBTF(),
                              flex: 7,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: originTF(),
                              flex: 4,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: destinationTF(),
                              flex: 4,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: shipmentTF(),
                              flex: 2,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: piecesTF(),
                              flex: 4,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: weightTF(),
                              flex: 4,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: weightUnitTF(),
                              flex: 2,
                            ),
                          ],
                        ),
                      ),
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
                        textColor: Colors.white,
                        elevation: 5,
                        onPressed: () {
                          insertAWB();
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
                          S.of(context).Submit,
                          //  "Submit"
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

  Future<dynamic> insertAWB() async {
    var result;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(StringData.insertawbAPI,
        body: {}, headers: {'x-access-tokens': prefs.getString('token')});
    //print("@@@@@@@@@@@@@@@@@");

    result = json.decode(response.body);

    //print(result);
    if (result['message'] == 'token expired') {
      refreshToken();
      insertAWB();
    } else {
      result = json.decode(response.body);
      print(prefs.getString('token'));
      print("@@@@@@@@@@@@@@@@@");
      if (response.statusCode == 201) {
        print("Data inserted Sucesess");
      } else {
        print("Data insertion failed");
      }

      //print("AWB List  ${result["awb"]}");
    }

    // print("AWB List " + result["awb"]);
    // final parsed = json.decode(response.body).cast<Map<String,String>>();
    return null;
  }

  airlineTF() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      maxLength: 3,
      // inputFormatters: [AllCapitalCase()],
      decoration: InputDecoration(
        border: OutlineInputBorder(
            gapPadding: 2.0,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        labelText: S.of(context).Airline,
        //'Airline',
      ),
      onChanged: (value) {
        setState(() {
          airline = value;
        });
      },
    );
  }

  masterAWBTF() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      maxLength: 8,
      // inputFormatters: [AllCapitalCase()],
      decoration: InputDecoration(
          border: OutlineInputBorder(
              gapPadding: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText: S.of(context).MasterAWB
          //'Master AWB',
          ),
      onChanged: (value) {
        setState(() {
          masterAWB = value;
        });
      },
    );
  }

  originTF() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      inputFormatters: [AllCapitalCase()],
      decoration: InputDecoration(
        border: OutlineInputBorder(
            gapPadding: 2.0,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        labelText: S.of(context).Origin,
        //'Origin',
      ),
      onChanged: (value) {
        setState(() {
          origin = value;
        });
      },
    );
  }

  destinationTF() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      inputFormatters: [AllCapitalCase()],
      decoration: InputDecoration(
        border: OutlineInputBorder(
            gapPadding: 2.0,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        labelText: S.of(context).Destination,
        //'Destination',
      ),
      onChanged: (value) {
        setState(() {
          destination = value;
        });
      },
    );
  }

  shipmentTF() {
    return TextFormField(
      initialValue: shipment,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      inputFormatters: [AllCapitalCase()],
      decoration: InputDecoration(
        border: OutlineInputBorder(
            gapPadding: 2.0,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        labelText: S.of(context).Shipment,
        //'Shipment',
      ),
      onChanged: (value) {
        setState(() {
          shipment = value;
        });
      },
    );
  }

  piecesTF() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      inputFormatters: [AllCapitalCase()],
      decoration: InputDecoration(
        border: OutlineInputBorder(
            gapPadding: 2.0,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        labelText: S.of(context).Pieces,
        //'Pieces',
      ),
      onChanged: (value) {
        setState(() {
          pieces = value;
        });
      },
    );
  }

  weightTF() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      inputFormatters: [AllCapitalCase()],
      decoration: InputDecoration(
        border: OutlineInputBorder(
            gapPadding: 2.0,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        labelText: S.of(context).Weight,
        //'Weight',
      ),
      onChanged: (value) {
        setState(() {
          weight = value;
        });
      },
    );
  }

  weightUnitTF() {
    return DropdownButton<String>(
      icon: Icon(Icons.arrow_drop_down),
      value: weightUnit,
      items: ['K', 'L'].map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        },
      ).toList(),
      onChanged: (String text) {
        setState(
          () {
            weightUnit = text;
          },
        );
      },
    );
  }
}
