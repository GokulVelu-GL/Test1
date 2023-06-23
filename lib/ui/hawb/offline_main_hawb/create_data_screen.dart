import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/string.dart';
import '../../../formatter.dart';
import '../../../generated/l10n.dart';
import '../../drodowns/airline_code.dart';
import '../../drodowns/airport_code.dart';
import '../main_hawb.dart';
import '../static/add_master_eawb.dart';
import 'model_class.dart';
// String Offlineairline="";
// String OfflinemasterAWB="";
// String Offlineorigin="";
// String Offlinedestination="";
// String Offlineshipment="";
// String Offlinepieces="";
// String Offlineweight="";
// String OfflineweightUnit="N";
// bool Offlinestatus=true;

String iOfflineairline="";
String iOfflinemasterAWB="";
String iOfflineorigin="";
String iOfflinedestination="";
String iOfflineshipment="";
String iOfflinepieces="";
String iOfflineweight="";
String iOfflineweightUnit="N";
bool iOfflinestatus=true;


class CreateDataScreen extends StatefulWidget {
  const CreateDataScreen({Key key}) : super(key: key);

  @override
  State<CreateDataScreen> createState() => _CreateDataScreenState();
}

class _CreateDataScreenState extends State<CreateDataScreen> {
  String iOfflineairline="";
  String iOfflinemasterAWB="";
  String iOfflineorigin="";
  String iOfflinedestination="";
  String iOfflineshipment="";
  String iOfflinepieces="";
  String iOfflineweight="";
  String iOfflineweightUnit="N";
  bool iOfflinestatus=true;


  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
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

  // Future<Album>? _futureAlbum;
  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Consumer<EAWBModel>(
        builder: (BuildContext context,
        model, Widget child) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                title: Text(
                  S.of(context).AddMasterAirWaybill,

                  //  "Add Master Air Waybill"
                ),
                centerTitle: true,
              ),
              body:
              Center(
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
                                        child: airlineT(),
                                        flex: 3,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child:
                                        Padding(
                                          padding: const EdgeInsets.only(top: 20.0),
                                       child: masterAWBTF(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: originT(),
                                        flex: 3,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: destinationT(),
                                        flex: 3,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: shipmentTF(),
                                        flex: 3,
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
                                TextButton(
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor)),
                                  onPressed: () {
                                    if (_awbForm.currentState.validate()) {
                                      setState(() {
                                        Hive.openBox('AwbList');
                                        final value = AwbListOffline(
                                          airline: airline,
                                          masterAWB: masterAWB,
                                          shipment: shipment,
                                          origin: originController.text,
                                          destination: destinationController.text,
                                          pieces: pieces,
                                          weight: weight,
                                          weightUnit: weightUnit,
                                        );
                                        Hive.box('AwbList').add(value);
                                         iOfflineairline = airline;
                                         iOfflinemasterAWB = masterAWB;
                                         iOfflineorigin = originController.text;
                                         iOfflinedestination = destinationController.text;
                                         iOfflineshipment = shipment;
                                         iOfflinepieces = pieces;
                                         iOfflineweight = weight;
                                         iOfflineweightUnit = weightUnit;
                                         iOfflinestatus=true;
                                         print("offline data\n offline");
                                         print(OfflineweightUnit);
                                         print(Offlinepieces);



                                      });

                                      // insertAWBList();

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyEawb(),

                                          ));
                                      // Navigator.push(context, HomeScreenRoute(MyEawb()));
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
                                      style:TextStyle(
                                          color:Theme.of(context).backgroundColor
                                      )
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
          //     SingleChildScrollView(
          //       child: Padding(
          //         padding: const EdgeInsets.all(15),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.stretch,
          //           children: [
          //             TextField(
          //               controller: _nameController,
          //               decoration: const InputDecoration(labelText: 'Name'),
          //             ),
          //             const SizedBox(height: 30),
          //             TextField(
          //               controller: _ageController,
          //               decoration: const InputDecoration(labelText: 'Age'),
          //             ),
          //             const SizedBox(height: 30),
          //             TextField(
          //               controller: _phoneController,
          //               decoration: const InputDecoration(labelText: 'Phone'),
          //             ),
          //             const SizedBox(height: 50),
          //             ElevatedButton(
          //               onPressed: () {
          //                 Hive.openBox('AwbList');
          //                 final value = AwbListOffline(
          //                   airline: _nameController.text,
          //                   pieces: _ageController.text,
          //                   weight: _phoneController.text,
          //                 );
          //                 Hive.box('AwbList').add(value);
          //                 // insertAWBList();
          //                 // _futureAlbum = createAlbum(_nameController.text);
          //               },
          //
          //               child: const Text('Create'),
          //             ),
          //           ],
          //         ),
          //       ),
          // );
        }
    );
  }

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
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: TextFormField(
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
      ),
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
  airlineT() {
    return TextFormField(
      textInputAction: TextInputAction.next,
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
          airline = value;
        });
      },
    );
  }
  originT() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      maxLength: 3,
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
          labelText: S.of(context).Origin,
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
          origin = value;
        });
      },
    );
  }
  destinationT() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      maxLength: 3,
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
        //'Weight',
      ),
      validator: (value) {
        if (value.isEmpty || value == null) {
          return S.of(context).PleaseEntertheDestination;
          //"Please Enter the weight";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          destination = value;
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

String Offlineairline=iOfflineairline;
String OfflinemasterAWB=iOfflinemasterAWB;
String Offlineorigin=iOfflineorigin;
String Offlinedestination=iOfflinedestination;
String Offlineshipment=iOfflineshipment;
String Offlinepieces=iOfflinepieces;
String Offlineweight=iOfflineweight;
String OfflineweightUnit=iOfflineweightUnit;
bool Offlinestatus=iOfflinestatus;
