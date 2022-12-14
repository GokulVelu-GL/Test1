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
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:dropdownfield/dropdownfield.dart';
import '../../../string.dart';
import '../main_hawb.dart';
import 'package:http/http.dart' as http;

class AddMasterAWB extends StatefulWidget {
  @override
  _AddMasterAWBState createState() => _AddMasterAWBState();
}

class _AddMasterAWBState extends State<AddMasterAWB> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            S.of(context).AddMasterAirWaybill,

            //  "Add Master Air Waybill"
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      S.of(context).Add,

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
                            textColor: Theme.of(context).backgroundColor,
                            elevation: 5,
                            onPressed: () {
                              if (_awbForm.currentState.validate()) {

                                insertAWBList();
                                Navigator.push(context, HomeScreenRoute(MyEawb()));
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
        ));
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
          "weight": weight,
          "FlightList_id": 16,
        }
        ));
    result = json.decode(response.body);
    if (result['message'] == 'token expired') {
      refreshToken();
      insertAWBList();
      Fluttertoast.showToast(
          msg: 'AWB Number Added',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white
      );
    } else {
      result = json.decode(response.body);
      print(prefs.getString('token'));
      print("@@@@@@@@@@@@@@@@@");
      if (response.statusCode == 201) {
        print("insert...................."+result);
        // insertAWB();
        Fluttertoast.showToast(
            msg: 'AWB Number Added',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white
        );
        // Scaffold.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text("AWB Number Added"),
        //     duration: Duration(seconds: 1),
        //   ),
        // );
        // _showMessage(
        //     S.of(context).AWBNumberAdded
        //     //"AWB Number Added"
        //     ,
        //     Colors.green,
        //     Colors.white);
        Navigator.push(context, HomeScreenRoute(MyEawb()));
       //   Navigator.of(context).push(MyEawb());
        print("Data inserted");
      } else {
        Fluttertoast.showToast(
            msg: 'AWB Number Added Failed',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
             timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white
        );
        Navigator.push(context, HomeScreenRoute(MyEawb()));
        print("Failed");
        // Scaffold.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text("AWB Number Added Failed"),
        //     duration: Duration(seconds: 1),
        //   ),
        // );
        // _showMessage(
        //     S.of(context).AWBNumberAddedFailed
        //     //"AWB Number Added Failed"
        //     ,
        //     Colors.red,
        //     Colors.white);
        print("Data insertion failed");
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

  // airlineTF() {
  //   //final focus = FocusNode();
  //   return TextFormField(
  //     textInputAction: TextInputAction.next,
  //     keyboardType: TextInputType.number,
  //     maxLength: 3,
  //     //focusNode: focus,
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
  //         airline = value;
  //       });
  //     },
  //   );
  // }

  airlineTF() {

    return TypeAheadFormField<AirlineCode>(
      getImmediateSuggestions: true,
        suggestionsCallback: AirlineCodeApi.getAirlineCode,
        itemBuilder: (context, AirlineCode suggestion) {
          final code = suggestion;
          return ListTile(
            title: Text(code.airlineCode),
            subtitle: Text(code.airlineName),
          );
        },
        validator: (value) {
          if (value.isEmpty) {
            return S.of(context).SelectaAirline;
            //'Select a Airline';
          }
          return null;
        },
        textFieldConfiguration: TextFieldConfiguration(
          maxLength: 3,
          controller: this.airlineController,
          inputFormatters: [AllCapitalCase()],
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
              labelText: S.of(context).Airline,
              labelStyle: TextStyle(color: Theme.of(context).accentColor)
            //'Airline',
          ),
        ),
        onSuggestionSelected: (AirlineCode suggestion) {
          this.airlineController.text = suggestion.airlinePrifix;
          airline = suggestion.airlinePrifix;
          //
        },
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        // onSuggestionSelected: (AirlineCode suggestion) {
        //
        //     this.airlineController.text = suggestion.airlinePrifix;
        //     airline = suggestion.airlinePrifix;
        //
        //   print("airline 001"+airline);
        //
        // }
        );
  }

  masterAWBTF() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      maxLength: 8,
      // inputFormatters: [AllCapitalCase()],
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
          labelText: S.of(context).MasterAWB,
          labelStyle: TextStyle(color: Theme.of(context).accentColor)
        //'Master AWB',
      ),
      validator: (value) {
        if (value.isEmpty || value == null) {
          print("object");
          return S.of(context).PleaseEntertheAWBNo;
          //"Please Enter the AWB No";
        } else if (value.length != 8) {
          return S.of(context).AWBnumbermustbe8digit;
          //"AWB number must be 8 digit";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          masterAWB = value;
          //print('${masterAWB}');
        });
      },
    );
  }

  originTF() {
    return TypeAheadFormField<AirportCode>(
        suggestionsCallback: AirportApi.getAirportCode,
        itemBuilder: (context, AirportCode suggestion) {
          final code = suggestion;
          return ListTile(
            title: Text(code.airportCode),
            subtitle: Text(code.airportName),
          );
        },
        validator: (value) {
          if (value.isEmpty) {
            return S.of(context).SelectaOrigin;
            //'Select a Origin';
          }
          return null;
        },
        textFieldConfiguration: TextFieldConfiguration(
          inputFormatters: [AllCapitalCase()],
          controller: this.originController,
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
              labelText: S.of(context).Origin,
              labelStyle: TextStyle(color: Theme.of(context).accentColor)
            //'Origin',
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onSuggestionSelected: (AirportCode suggestion) {
          if (suggestion.airportCode == null &&
              suggestion.airportName == null) {
            return S.of(context).WrongCode;
            //'Worong Code';
          } else {
            this.originController.text = suggestion.airportCode;
            origin = suggestion.airportCode;
            print(origin);
          }
        }
        );
  }

  destinationTF() {
    final focus = FocusNode();
    return TypeAheadFormField<AirportCode>(
        suggestionsCallback: AirportApi.getAirportCode,
        itemBuilder: (context, AirportCode suggestion) {
          final code = suggestion;
          return ListTile(
            title: Text(code.airportCode),
            subtitle: Text(code.airportName),
          );
        },
        validator: (value) {
          if (value.isEmpty) {
            return S.of(context).SelectaDestination;
            //'Select a Destination';
          }
          return null;
        },
        textFieldConfiguration: TextFieldConfiguration(
          controller: this.destinationController,
          inputFormatters: [AllCapitalCase()],
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
              labelText: S.of(context).Destination,
              labelStyle: TextStyle(color: Theme.of(context).accentColor)
            //'Destination',
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onSuggestionSelected: (AirportCode suggestion) {
          this.destinationController.text = suggestion.airportCode;
          destination = suggestion.airportCode;
          print(destination);
        });
  }

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
  //     controller: TextEditingController(text: origin),
  //     textSubmitted: (text) => setState(() {
  //       if (text != "") {
  //         origin = text;
  //         print(origin);
  //       }
  //     }),
  //     key: key,
  //   );
  // }

  // originTF() {
  //   return TextFormField(
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
  //         origin = value;
  //       });
  //     },
  //   );
  // }

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
  //     controller: TextEditingController(text: destination),
  //     textSubmitted: (text) => setState(() {
  //       if (text != "") {
  //         destination = text;
  //         //print(destination);
  //       }
  //     }),
  //     key: key,
  //   );
  // }

  // destinationTF() {
  //   return TextFormField(
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
  //         destination = value;
  //       });
  //     },
  //   );
  // }

  shipmentTF() {
    return TextFormField(
      initialValue: shipment,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      inputFormatters: [AllCapitalCase()],
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
          labelText: S.of(context).Shipment,
          labelStyle: TextStyle(color: Theme.of(context).accentColor)
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
          labelText: S.of(context).Pieces,
          labelStyle: TextStyle(color: Theme.of(context).accentColor)
        //'Pieces',
      ),
      validator: (value) {
        if (value.isEmpty || value == null) {
          return S.of(context).PleaseEnterthepieces;
          //"Please Enter the pieces";
        }
        return null;
      },
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
          labelText: S.of(context).Weight,
          labelStyle: TextStyle(color: Theme.of(context).accentColor)
        //'Weight',
      ),
      validator: (value) {
        if (value.isEmpty || value == null) {
          return S.of(context).PleaseEntertheweight;
          //"Please Enter the weight";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          weight = value;
        });
      },
    );
  }

  weightUnitTF() {
    return DropdownButton<String>(
      icon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).accentColor,
      ),
      value: weightUnit,
      items: ['K', 'L'].map<DropdownMenuItem<String>>(
            (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value,
                style: TextStyle(color: Theme.of(context).accentColor)),
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
