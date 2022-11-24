import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:rooster/formatter.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/screenroute.dart';
import 'package:rooster/ui/drodowns/airline_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../string.dart';
import '../../drodowns/airport_code.dart';
import '../main_hawb.dart';
import 'package:http/http.dart' as http;

class EditHawb extends StatefulWidget {
  String wayBillNumber;
  String awbid;
  String prefix;
  String origin;
  String destination;
  String shipment;
  String pieces;
  String weight;
  String weightUnit;

  EditHawb(this.prefix, this.wayBillNumber, this.awbid, this.destination,
      this.origin, this.shipment, this.pieces, this.weight, this.weightUnit);

  @override
  _EditHawbState createState() => _EditHawbState();
}

class _EditHawbState extends State<EditHawb> {
  final _awbForm = GlobalKey<FormState>();

  final TextEditingController editoriginController = TextEditingController();
  final TextEditingController editdestinationController =
      TextEditingController();
  final TextEditingController editairlineController = TextEditingController();
  // String airline;
  // String masterAWB;
  // String origin;
  // String destination;
  // String shipment;
  // String pieces;
  // String weight;
  // String weightUnit;

  @override
  Widget build(BuildContext context) {
    // airline = widget.prefix;
    // masterAWB = widget.wayBillNumber;
    // origin = widget.origin;
    // destination = widget.destination;
    // shipment = widget.shipment;
    // pieces = widget.pieces;
    // weight = widget.weight;
    // weightUnit = widget.weightUnit;

    return Scaffold(
      appBar: AppBar(
       backgroundColor: Theme.of(context).primaryColor,
        title: Text(
         S.of(context).UpdateAWB,
          //  "Update AWB "
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
                  S.of(context).Update,
                  //"Update",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20),
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
                          insertAWBList();
                        },
                        child: Text(
                          S.of(context).Update,
                          style: TextStyle(
                          //  color: Theme.of(context).accentColor
                          ),
                          // "Update"
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
    var response = await http.put(StringData.awblistAPI,
        headers: <String, String>{
          'x-access-tokens': prefs.getString('token'),
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "id": '${widget.awbid}',
          "prefix": '${widget.prefix}',
          "wayBillNumber": '${widget.wayBillNumber}',
          "origin": '${widget.origin}',
          "destination": '${widget.destination}',
          "shipmentcode": '${widget.shipment}',
          "pieces": '${widget.pieces}',
          "weightcode": '${widget.weightUnit}',
          "weight": '${widget.weight}'
        }));

    result = json.decode(response.body);
    print(result);
    print('${widget.awbid}');
    if (result['message'] == 'token expired') {
      refreshToken();
      // insertAWBList();
    } else {
      result = json.decode(response.body);
      print(prefs.getString('token'));
      print("@@@@@@@@@@@@@@@@@");
      if (response.statusCode == 202) {
        print(result);
        SnackBar(
          content: Text(
            S.of(context).DataUpdated,
          //    "Data Updated"
          ),
          duration: Duration(seconds: 1),
        );
        Navigator.push(context, HomeScreenRoute(MyEawb()));
        print("Data Updated");
      } else {
        SnackBar(
          content: Text(
            S.of(context).Datainsertionfailed,
            //"Data insertion faild"
          ),
          duration: Duration(seconds: 10),
        );
        print("Data insertion failed");
      }
    }
    return result;
  }

  // airlineTF() {
  //   return TextFormField(
  //     initialValue: widget.prefix,
  //     textInputAction: TextInputAction.next,
  //     keyboardType: TextInputType.number,
  //     maxLength: 3,
  //     validator: (value) {
  //       if (value.isEmpty || value == null) {
  //         return "Please Enter the Airline code";
  //       } else if (value.length != 3) {
  //         return "Please Enter the 3 degit Airline Code";
  //       }
  //       return null;
  //     },
  //     // inputFormatters: [AllCapitalCase()],
  //     decoration: InputDecoration(
  //       border: OutlineInputBorder(
  //           gapPadding: 2.0,
  //           borderRadius: BorderRadius.all(Radius.circular(8.0))),
  //       labelText: 'Airline',
  //     ),
  //     onChanged: (value) {
  //       setState(() {
  //         widget.prefix = value;
  //       });
  //     },
  //   );
  // }

  airlineTF() {
    this.editairlineController.text = widget.prefix;
    final focus = FocusNode();
    return TypeAheadFormField<AirlineCode>(
        suggestionsCallback: AirlineCodeApi.getAirlineCode,
        itemBuilder: (context, AirlineCode suggestion) {
          final code = suggestion;
          return ListTile(
            title: Text(code.airlineCode,
            style: TextStyle(
              color: Theme.of(context).accentColor
            ),
            ),
            subtitle: Text(code.airlineName,
              style: TextStyle(
                  color: Theme.of(context).accentColor
              ),),
          );
        },
        validator: (value) {
          if (value.isEmpty) {
            return
              S.of(context).SelectaAirline;
              //'Select a Airline';
          }
          return null;
        },
        textFieldConfiguration: TextFieldConfiguration(
          maxLength: 3,
          controller: this.editairlineController,
          inputFormatters: [AllCapitalCase()],
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color:Theme.of(context).accentColor),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            //border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color:Theme.of(context).accentColor),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            border: OutlineInputBorder(
                gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).Airline,
              labelStyle: TextStyle(
                  color: Theme.of(context).accentColor
              )
            //'Airline',
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onSuggestionSelected: (AirlineCode suggestion) {
          this.editairlineController.text = suggestion.airlinePrifix;
          widget.prefix = suggestion.airlinePrifix;
          print(widget.prefix);
        });
  }

  masterAWBTF() {
    return TextFormField(
      initialValue: widget.wayBillNumber,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      maxLength: 8,
      validator: (value) {
        if (value.isEmpty || value == null) {
          print("object");
          return
            S.of(context).PleaseEntertheAWBNo;
            //"Please Enter the AWB No";
        } else if (value.length != 8) {
          return
            S.of(context).AWBnumbermustbe8digit;
            //"AWB number must be 8 digit";
        }
        return null;
      },
      // inputFormatters: [AllCapitalCase()],
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color:Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          //border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color:Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          border: OutlineInputBorder(
              gapPadding: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText: S.of(context).MasterAWB,
          labelStyle: TextStyle(
              color: Theme.of(context).accentColor
          )
          //'Master AWB',
          ),
      onChanged: (value) {
        setState(() {
          widget.wayBillNumber = value;
          //print('${masterAWB}');
        });
      },
    );
  }

  originTF() {
    this.editoriginController.text = widget.origin;

    return TypeAheadField<AirportCode>(
        suggestionsCallback: AirportApi.getAirportCode,
        itemBuilder: (context, AirportCode suggestion) {
          final code = suggestion;
          return ListTile(
            title: Text(code.airportCode),
            subtitle: Text(code.airportName),
          );
        },
        textFieldConfiguration: TextFieldConfiguration(
          controller: this.editoriginController,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color:Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color:Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            border: OutlineInputBorder(
                gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).Origin,
              labelStyle: TextStyle(
                  color: Theme.of(context).accentColor
              )
            //'Origin',
          ),
        ),
        onSuggestionSelected: (AirportCode suggestion) {
          this.editoriginController.text = suggestion.airportCode;
          widget.origin = suggestion.airportCode;
          //
        }
        );
  }

  // originTF() {
  //   return TextFormField(
  //     initialValue: widget.origin,
  //     textInputAction: TextInputAction.next,
  //     keyboardType: TextInputType.text,
  //     inputFormatters: [AllCapitalCase()],
  //     decoration: InputDecoration(
  //       border: OutlineInputBorder(
  //           gapPadding: 2.0,
  //           borderRadius: BorderRadius.all(Radius.circular(8.0))),
  //       labelText: 'Origin',
  //     ),
  //     onChanged: (value) {
  //       setState(() {
  //         widget.origin = value;
  //       });
  //     },
  //   );
  // }

  destinationTF() {
    this.editdestinationController.text = widget.destination;
    return TypeAheadField<AirportCode>(
        suggestionsCallback: AirportApi.getAirportCode,
        itemBuilder: (context, AirportCode suggestion) {
          final code = suggestion;
          return ListTile(
            title: Text(code.airportCode),
            subtitle: Text(code.airportName),
          );
        },
        textFieldConfiguration: TextFieldConfiguration(
          controller: this.editdestinationController,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color:Theme.of(context).accentColor),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            //border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color:Theme.of(context).accentColor),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            border: OutlineInputBorder(
                gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).Destination,
              labelStyle: TextStyle(
                  color: Theme.of(context).accentColor
              )
            //'Destination',
          ),
        ),
        onSuggestionSelected: (AirportCode suggestion) {
          this.editdestinationController.text = suggestion.airportCode;
          widget.destination = suggestion.airportCode;
          //print(destination);
        });
  }

  // destinationTF() {
  //   return TextFormField(
  //     initialValue: widget.destination,
  //     textInputAction: TextInputAction.next,
  //     keyboardType: TextInputType.text,
  //     inputFormatters: [AllCapitalCase()],
  //     decoration: InputDecoration(
  //       border: OutlineInputBorder(
  //           gapPadding: 2.0,
  //           borderRadius: BorderRadius.all(Radius.circular(8.0))),
  //       labelText: 'Destination',
  //     ),
  //     onChanged: (value) {
  //       setState(() {
  //         widget.destination = value;
  //       });
  //     },
  //   );
  // }

  shipmentTF() {
    return TextFormField(
      initialValue: widget.shipment,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      inputFormatters: [AllCapitalCase()],
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color:Theme.of(context).accentColor),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        //border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color:Theme.of(context).accentColor),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        border: OutlineInputBorder(
            gapPadding: 2.0,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        labelText: S.of(context).Shipment,
          labelStyle: TextStyle(
              color: Theme.of(context).accentColor
          )
        //'Shipment',
      ),
      onChanged: (value) {
        setState(() {
          widget.shipment = value;
        });
      },
    );
  }

  piecesTF() {
    return TextFormField(
      initialValue: widget.pieces,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      inputFormatters: [AllCapitalCase()],
      validator: (value) {
        if (value.isEmpty || value == null) {
          return
            S.of(context).PleaseEnterthepieces;
            //"Please Enter the pieces";
        }
        return null;
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color:Theme.of(context).accentColor),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        //border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color:Theme.of(context).accentColor),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        border: OutlineInputBorder(
            gapPadding: 2.0,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        labelText: S.of(context).Pieces,
          labelStyle: TextStyle(
              color: Theme.of(context).accentColor
          )

        //'Pieces',
      ),
      onChanged: (value) {
        setState(() {
          widget.pieces = value;
        });
      },
    );
  }

  weightTF() {
    return TextFormField(
      initialValue: widget.weight,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      inputFormatters: [AllCapitalCase()],
      validator: (value) {
        if (value.isEmpty || value == null) {
          return
            S.of(context).PleaseEntertheweight;
            //"Please Enter the weight";
        }
        return null;
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color:Theme.of(context).accentColor),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        //border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color:Theme.of(context).accentColor),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        border: OutlineInputBorder(
            gapPadding: 2.0,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        labelText: S.of(context).Weight,
          labelStyle: TextStyle(
              color: Theme.of(context).accentColor
          )
        //'Weight',
      ),
      onChanged: (value) {
        setState(() {
          widget.weight = value;
        });
      },
    );
  }

  weightUnitTF() {
    return DropdownButton<String>(
      icon: Icon(Icons.arrow_drop_down,
      color: Theme.of(context).accentColor,
      ),
      value: widget.weightUnit,
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
            widget.weightUnit = text;
          },
        );
      },
    );
  }
}
