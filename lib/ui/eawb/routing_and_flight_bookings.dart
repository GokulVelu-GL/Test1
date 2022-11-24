import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:rooster/formatter.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/airport_model.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/screenroute.dart';
import 'package:rooster/ui/eawb/awb_consignment_details.dart';
import 'package:rooster/ui/eawb/notify.dart';
import 'package:rooster/ui/eawb/static/custom_background.dart';
import 'package:rooster/ui/eawb/issuing_carriers_agent.dart';

import '../drodowns/airport_code.dart';

class RoutingAndFlightBookings extends StatefulWidget {
  RoutingAndFlightBookings({Key key, this.airportList}) : super(key: key);
  final airportList;

  @override
  _RoutingAndFlightBookingsState createState() =>
      _RoutingAndFlightBookingsState();
}

class _RoutingAndFlightBookingsState extends State<RoutingAndFlightBookings> {
  final _routingAndFlightBookingsFormKey = GlobalKey<FormState>();
  GlobalKey<AutoCompleteTextFieldState<AirportModel>> _departureTextFieldKey =
          new GlobalKey(),
      _to1TextFieldKey = new GlobalKey(),
      _to2TextFieldKey = new GlobalKey(),
      _to3TextFieldKey = new GlobalKey(),
      _destinationTextFieldKey = new GlobalKey();
  FocusNode _routeAndFlightDepartureFocusNode = FocusNode();
  FocusNode _routeAndFlightTo1FocusNode = FocusNode();
  FocusNode _routeAndFlightBy1FocusNode = FocusNode();
  FocusNode _routeAndFlightTo2FocusNode = FocusNode();
  FocusNode _routeAndFlightBy2FocusNode = FocusNode();
  FocusNode _routeAndFlightTo3FocusNode = FocusNode();
  FocusNode _routeAndFlightBy3FocusNode = FocusNode();
  FocusNode _routeAndFlightDestinationFocusNode = FocusNode();
  FocusNode _routeAndFlightNumberOrDate1FocusNode = FocusNode();
//  FocusNode _routeAndFlightNumberOrDate2FocusNode = FocusNode();

  AutoCompleteTextField _departureTextField,
      _to1TextField,
      _to2TextField,
      _to3TextField,
      _destinationTextField;

  TextEditingController _departureController = TextEditingController();
  TextEditingController _to1Controller = TextEditingController();
  TextEditingController _to2Controller = TextEditingController();
  TextEditingController _to3Controller = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EAWBModel>(builder: (context, model, child) {
      return WillPopScope(
        onWillPop: () async {
          model.setStatus();
          return true;
        },
        child: Scaffold(
          body: SafeArea(
            child: CustomBackground(
              previous: IssuingCarriersAgent(),
              next: AlsoNotify(),
              name: S.of(context).Routingandflightbookings,
              help: IconButton(
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
                          Animation animation,
                          Animation secondaryAnimation) {
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
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.flight,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("To and By"),
                                      subtitle: Text("Coded identification approved by IATA for a carrier\nExample: RKT"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.flight,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Flight Number"),
                                      subtitle: Text("Number to identify a flight or a substitute flight\nExample: BA0541A"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.calendar_month,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Flight Date"),
                                      subtitle: Text("Numeric representation of a day in a month\nExample: 15AUG2022"),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                icon: Icon(Icons.help,
                  color: Theme.of(context).accentColor,
                ),

              ),
              //"Routing & Flight Bookings",
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _routingAndFlightBookingsFormKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          //departure(model),
                          to1(model),
                          by1(model),
                          to2(model),
                          by2(model),
                          to3(model),
                          by3(model),
                          // destination(model),
                          routeAndFlightNumber1(model),
                          routeAndFlightDate1(model),
                          routeAndFlightNumber2(model),
                          routeAndFlightDate2(model),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  nextButton(model) {
    return RaisedButton(
      color: Colors.white,
      textColor: Theme.of(context).primaryColor,
      elevation: 3,
      onPressed: () {
        FocusScope.of(context).unfocus();
        model.setStatus();
        Navigator.of(context)
            .pushReplacement(RightScreenRoute(AwbConsignmentDetails()));
      },
      child: Text("Next"),
    );
  }

  titleText(text) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24.0),
      ),
    );
  }

  previousButton(model) {
    return RaisedButton(
      color: Colors.white,
      textColor: Theme.of(context).primaryColor,
      elevation: 3,
      onPressed: () {
        FocusScope.of(context).unfocus();
        model.setStatus();
        Navigator.of(context)
            .pushReplacement(LeftScreenRoute(IssuingCarriersAgent()));
      },
      child: Text("Previous"),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // departure(EAWBModel model) {
  //   _departureController.text = model.routeAndFlightDeparture;
  //   _departureController.selection = TextSelection.fromPosition(TextPosition(
  //       offset: _departureController.text.length)); // ! set old Data....

  //   return Container(
  //     margin: EdgeInsets.all(10.0),
  //     child: _departureTextField = AutoCompleteTextField<AirportModel>(
  //       inputFormatters: [AllCapitalCase()],
  //       controller: _departureController,
  //       suggestionsAmount: 3,
  //       keyboardType: TextInputType.text,
  //       key: _departureTextFieldKey,
  //       focusNode: _routeAndFlightDepartureFocusNode,
  //       clearOnSubmit: false,
  //       suggestions: widget.airportList,
  //       decoration: InputDecoration(
  //         border: OutlineInputBorder(
  //             gapPadding: 2.0,
  //             borderRadius: BorderRadius.all(Radius.circular(8.0))),
  //         labelText: 'Departure',
  //       ),
  //       itemFilter: (suggestion, query) => suggestion.airportName
  //           .toLowerCase()
  //           .startsWith(query.toLowerCase()),
  //       itemSorter: (a, b) => a.airportName.compareTo(b.airportName),
  //       itemBuilder: (context, suggestion) => ListTile(
  //         title: Text(suggestion.airportName),
  //         subtitle: Text(suggestion.airportLocation),
  //         trailing: Text(suggestion.airportCode),
  //       ),
  //       itemSubmitted: (data) {
  //         setState(() {
  //           _departureTextField.textField.controller.text =
  //               model.routeAndFlightDeparture = data.airportName;
  //           model.awbConsigmentDetailsDepAirportCode = data
  //               .airportCode; // ! update the [awbConsigmentDetailsDepAirportCode]....
  //           _fieldFocusChange(context, _routeAndFlightDepartureFocusNode,
  //               _routeAndFlightTo1FocusNode);
  //         });
  //       },
  //     ),
  //   );
  // }

  // to1(model) {
  //   _to1Controller.text = model.routeAndFlightTo1;
  //   _to1Controller.selection = TextSelection.fromPosition(
  //       TextPosition(offset: _to1Controller.text.length));

  //   return Container(
  //     margin: EdgeInsets.all(10.0),
  //     child: _to1TextField = AutoCompleteTextField<AirportModel>(
  //       inputFormatters: [AllCapitalCase()],
  //       controller: _to1Controller,
  //       suggestionsAmount: 3,
  //       key: _to1TextFieldKey,
  //       focusNode: _routeAndFlightTo1FocusNode,
  //       clearOnSubmit: false,
  //       suggestions: widget.airportList,
  //       decoration: InputDecoration(
  //           isDense: true,
  //           enabledBorder: OutlineInputBorder(
  //               borderSide: new BorderSide(
  //                   color: Theme.of(context).accentColor,
  //                   //  color: Colors.deepPurple,
  //                   width: 2),
  //               //gapPadding: 2.0,
  //               borderRadius: BorderRadius.all(Radius.circular(8.0))),
  //           focusedBorder: OutlineInputBorder(
  //             borderSide: BorderSide(
  //               width: 2,
  //               color: Theme.of(context).accentColor,
  //               // color: Colors.deepPurple
  //             ),
  //             borderRadius: BorderRadius.circular(8.0),
  //           ),
  //           // border: OutlineInputBorder(
  //           //     gapPadding: 2.0,
  //           //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
  //           labelText: S.of(context).TO,
  //           labelStyle: new TextStyle(
  //               color: Theme.of(context).accentColor,
  //               // color: Colors.deepPurple,
  //               fontSize: 16.0),
  //           suffixIcon: Icon(
  //             Icons.flight_land,
  //             color: Theme.of(context).accentColor,
  //             // color: Colors.deepPurple,
  //           )
  //           //'TO',
  //           ),
  //       itemFilter: (suggestion, query) => suggestion.airportName
  //           .toLowerCase()
  //           .startsWith(query.toLowerCase()),
  //       itemSorter: (a, b) => a.airportName.compareTo(b.airportName),
  //       itemBuilder: (context, suggestion) => ListTile(
  //         title: Text(suggestion.airportName),
  //         subtitle: Text(suggestion.airportLocation),
  //         trailing: Text(suggestion.airportCode),
  //       ),
  //       itemSubmitted: (data) {
  //         setState(() {
  //           _to1TextField.textField.controller.text =
  //               model.routeAndFlightTo1 = data.airportCode;
  //           _fieldFocusChange(context, _routeAndFlightTo1FocusNode,
  //               _routeAndFlightBy1FocusNode);
  //         });
  //       },
  //     ),
  //   );
  // }

  to1(model) {
    _to1Controller.text = model.routeAndFlightTo1;
    _to1Controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _to1Controller.text.length));
    return Container(
        margin: EdgeInsets.all(10.0),
        child: TypeAheadFormField<AirportCode>(
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
                return
                  S.of(context).Selectaairportcode;
                  //'Select a airport code';
              }
              return null;
            },
            textFieldConfiguration: TextFieldConfiguration(
              inputFormatters: [AllCapitalCase()],
              controller: this._to1Controller,
              decoration: InputDecoration(
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          color: Theme.of(context).accentColor,
                          //  color: Colors.deepPurple,
                          width: 2),
                      //gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).accentColor,
                      // color: Colors.deepPurple
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  // border: OutlineInputBorder(
                  //     gapPadding: 2.0,
                  //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText: S.of(context).TO+" *",
                  labelStyle: new TextStyle(
                      color: Theme.of(context).accentColor,
                      // color: Colors.deepPurple,
                      fontSize: 16.0),
                  suffixIcon: Icon(
                    Icons.flight_land,
                    color: Theme.of(context).accentColor,
                    // color: Colors.deepPurple,
                  )
                  //'TO',
                  ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onSuggestionSelected: (AirportCode suggestion) {
              if (suggestion.airportCode == null &&
                  suggestion.airportName == null) {
                return
                    S.of(context).WrongCode;
                  //'Worong Code';
              } else {
                this._to1Controller.text = suggestion.airportCode;
                model.routeAndFlightTo1 = suggestion.airportCode;
                print(model.routeAndFlightTo1);
              }
            }));
  }

  by1(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.routeAndFlightBy1,
        focusNode: _routeAndFlightBy1FocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _routeAndFlightBy1FocusNode,
              _routeAndFlightTo2FocusNode);
        },
        decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,
                    // color: Colors.deepPurple,
                    width: 2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).ByfirstCarrier+" *",
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.flight_takeoff,
              color: Theme.of(context).accentColor,
              //color: Colors.deepPurple,
            )
            //'By first carrier',
            ),
        onChanged: (text) {
          setState(() {
            model.routeAndFlightBy1 = text;
          });
        },
      ),
    );
  }

  // to2(model) {
  //   _to2Controller.text = model.routeAndFlightTo2;
  //   _to2Controller.selection = TextSelection.fromPosition(
  //       TextPosition(offset: _to2Controller.text.length));

  //   return Container(
  //     margin: EdgeInsets.all(10.0),
  //     child: _to2TextField = AutoCompleteTextField<AirportModel>(
  //       inputFormatters: [AllCapitalCase()],
  //       controller: _to2Controller,
  //       suggestionsAmount: 3,
  //       key: _to2TextFieldKey,
  //       focusNode: _routeAndFlightTo2FocusNode,
  //       clearOnSubmit: false,
  //       suggestions: widget.airportList,
  //       decoration: InputDecoration(
  //           isDense: true,
  //           enabledBorder: OutlineInputBorder(
  //               borderSide: new BorderSide(
  //                   color: Theme.of(context).accentColor,
  //                   // color: Colors.deepPurple,
  //                   width: 2),
  //               //gapPadding: 2.0,
  //               borderRadius: BorderRadius.all(Radius.circular(8.0))),
  //           focusedBorder: OutlineInputBorder(
  //             borderSide: BorderSide(
  //               width: 2,
  //               color: Theme.of(context).accentColor,
  //               //  color: Colors.deepPurple
  //             ),
  //             borderRadius: BorderRadius.circular(8.0),
  //           ),
  //           // border: OutlineInputBorder(
  //           //     gapPadding: 2.0,
  //           //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
  //           labelText: S.of(context).TO,
  //           labelStyle: new TextStyle(
  //               color: Theme.of(context).accentColor,
  //               // color: Colors.deepPurple,
  //               fontSize: 16.0),
  //           suffixIcon: Icon(
  //             Icons.flight_land,
  //             color: Theme.of(context).accentColor,
  //             //    color: Colors.deepPurple,
  //           )
  //           //'TO',
  //           ),
  //       itemFilter: (suggestion, query) => suggestion.airportName
  //           .toLowerCase()
  //           .startsWith(query.toLowerCase()),
  //       itemSorter: (a, b) => a.airportName.compareTo(b.airportName),
  //       itemBuilder: (context, suggestion) => ListTile(
  //         title: Text(suggestion.airportName),
  //         subtitle: Text(suggestion.airportLocation),
  //         trailing: Text(suggestion.airportCode),
  //       ),
  //       itemSubmitted: (data) {
  //         setState(() {
  //           _to2TextField.textField.controller.text =
  //               model.routeAndFlightTo2 = data.airportCode;
  //           _fieldFocusChange(context, _routeAndFlightTo2FocusNode,
  //               _routeAndFlightBy2FocusNode);
  //         });
  //       },
  //     ),
  //   );
  // }

  to2(model) {
    _to2Controller.text = model.routeAndFlightTo2;
    _to2Controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _to2Controller.text.length));
    return Container(
        margin: EdgeInsets.all(10.0),
        child: TypeAheadFormField<AirportCode>(
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
                return
                  S.of(context).Selectaairportcode;
                  //'Select a airport code';
              }
              return null;
            },
            textFieldConfiguration: TextFieldConfiguration(
              inputFormatters: [AllCapitalCase()],
              controller: this._to2Controller,
              decoration: InputDecoration(
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          color: Theme.of(context).accentColor,
                          //  color: Colors.deepPurple,
                          width: 2),
                      //gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).accentColor,
                      // color: Colors.deepPurple
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  // border: OutlineInputBorder(
                  //     gapPadding: 2.0,
                  //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText: S.of(context).TO,
                  labelStyle: new TextStyle(
                      color: Theme.of(context).accentColor,
                      // color: Colors.deepPurple,
                      fontSize: 16.0),
                  suffixIcon: Icon(
                    Icons.flight_land,
                    color: Theme.of(context).accentColor,
                    // color: Colors.deepPurple,
                  )
                  //'TO',
                  ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onSuggestionSelected: (AirportCode suggestion) {
              if (suggestion.airportCode == null &&
                  suggestion.airportName == null) {
                return
                  S.of(context).WrongCode;
                  //'Worong Code';
              } else {
                this._to2Controller.text = suggestion.airportCode;
                model.routeAndFlightTo2 = suggestion.airportCode;
                print(model.routeAndFlightTo2);
              }
            }));
  }

  by2(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.routeAndFlightBy2,
        focusNode: _routeAndFlightBy2FocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _routeAndFlightBy2FocusNode,
              _routeAndFlightTo3FocusNode);
        },
        decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,
                    // color: Colors.deepPurple,
                    width: 2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).BY,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.flight_takeoff,
              color: Theme.of(context).accentColor,
              //  color: Colors.deepPurple,
            )
            //'By',
            ),
        onChanged: (text) {
          setState(() {
            model.routeAndFlightBy2 = text;
          });
        },
      ),
    );
  }

  to3(model) {
    _to3Controller.text = model.routeAndFlightTo3;
    _to3Controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _to3Controller.text.length));

    return Container(
        margin: EdgeInsets.all(10.0),
        child: TypeAheadFormField<AirportCode>(
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
                return
                  S.of(context).Selectaairportcode;
                  //'Select a airport code';
              }
              return null;
            },
            textFieldConfiguration: TextFieldConfiguration(
              inputFormatters: [AllCapitalCase()],
              controller: this._to3Controller,
              decoration: InputDecoration(
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                          color: Theme.of(context).accentColor,
                          //  color: Colors.deepPurple,
                          width: 2),
                      //gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).accentColor,
                      // color: Colors.deepPurple
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  // border: OutlineInputBorder(
                  //     gapPadding: 2.0,
                  //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText: S.of(context).TO,
                  labelStyle: new TextStyle(
                      color: Theme.of(context).accentColor,
                      // color: Colors.deepPurple,
                      fontSize: 16.0),
                  suffixIcon: Icon(
                    Icons.flight_land,
                    color: Theme.of(context).accentColor,
                    // color: Colors.deepPurple,
                  )
                  //'TO',
                  ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onSuggestionSelected: (AirportCode suggestion) {
              if (suggestion.airportCode == null &&
                  suggestion.airportName == null) {
                return
                  S.of(context).WrongCode;
                  //'Worong Code';
              } else {
                this._to3Controller.text = suggestion.airportCode;
                model.routeAndFlightTo3 = suggestion.airportCode;
                print(model.routeAndFlightTo3);
              }
            }));
  }

  by3(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.routeAndFlightBy3,
        focusNode: _routeAndFlightBy3FocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _routeAndFlightBy3FocusNode,
              _routeAndFlightDestinationFocusNode);
        },
        decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,
                    // color: Colors.deepPurple,
                    width: 2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).BY,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //  color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.flight_takeoff,
              color: Theme.of(context).accentColor,
              //  color: Colors.deepPurple,
            )
            //'By',
            ),
        onChanged: (text) {
          setState(() {
            model.routeAndFlightBy3 = text;
          });
        },
      ),
    );
  }

  // destination(model) {
  //   _destinationController.text = model.routeAndFlightDestination;
  //   _destinationController.selection = TextSelection.fromPosition(
  //       TextPosition(offset: _destinationController.text.length));

  //   return Container(
  //     margin: EdgeInsets.all(10.0),
  //     child: _destinationTextField = AutoCompleteTextField<AirportModel>(
  //       inputFormatters: [AllCapitalCase()],
  //       controller: _destinationController,
  //       suggestionsAmount: 3,
  //       key: _destinationTextFieldKey,
  //       focusNode: _routeAndFlightDestinationFocusNode,
  //       clearOnSubmit: false,
  //       keyboardType: TextInputType.text,
  //       suggestions: widget.airportList,
  //       decoration: InputDecoration(
  //         border: OutlineInputBorder(
  //             gapPadding: 2.0,
  //             borderRadius: BorderRadius.all(Radius.circular(8.0))),
  //         labelText: 'Destination',
  //       ),
  //       itemFilter: (suggestion, query) => suggestion.airportName
  //           .toLowerCase()
  //           .startsWith(query.toLowerCase()),
  //       itemSorter: (a, b) => a.airportName.compareTo(b.airportName),
  //       itemBuilder: (context, suggestion) => ListTile(
  //         title: Text(suggestion.airportName),
  //         subtitle: Text(suggestion.airportLocation),
  //         trailing: Text(suggestion.airportCode),
  //       ),
  //       itemSubmitted: (data) {
  //         setState(() {
  //           _destinationTextField.textField.controller.text =
  //               model.routeAndFlightDestination = data.airportCode;
  //           _fieldFocusChange(context, _routeAndFlightDestinationFocusNode,
  //               _routeAndFlightNumberOrDate1FocusNode);
  //         });
  //       },
  //     ),
  //   );
  // }

  routeAndFlightNumber1(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.routeAndFlightNumber1,
        focusNode: _routeAndFlightNumberOrDate1FocusNode,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _routeAndFlightNumberOrDate1FocusNode.unfocus();
        },
        decoration: InputDecoration(
            isDense: true,
            counterText: "Example : BA1234A/15AUG2020",
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,
                    //color: Colors.deepPurple,
                    width: 2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).Flightnumber1,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.flight,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )

            //'Flight Number 1',
            ),
        onChanged: (text) {
          setState(() {
            model.routeAndFlightNumber1 = text;
          });
        },
      ),
    );
  }

  routeAndFlightNumber2(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.routeAndFlightNumber2,
        focusNode: _routeAndFlightNumberOrDate1FocusNode,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _routeAndFlightNumberOrDate1FocusNode.unfocus();
        },
        decoration: InputDecoration(
            isDense: true,
            counterText: "Example : BA1234A/15AUG2020",
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,
                    //color: Colors.deepPurple,
                    width: 2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).Flightnumber2,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.flight,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
            //'Flight Number 2',
            ),
        onChanged: (text) {
          setState(() {
            model.routeAndFlightNumber2 = text;
          });
        },
      ),
    );
  }

  routeAndFlightDate1(model) {
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
            model.routeAndFlightDate1 =
                '${_date.day}${month[_date.month - 1]}${_date.year}';
          });
        },
        child: Container(
          // decoration: BoxDecoration(
          //
          //   border: Border.all(
          //     width: 2,
          //     color: Theme.of(context).accentColor,
          //     //color: Colors.deepPurple,
          //     style: BorderStyle.solid,
          //   ),
          //   borderRadius: BorderRadius.all(
          //     Radius.circular(8.0),
          //   ),
          // ),
          child: InputDecorator(
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Theme.of(context).accentColor)),
              labelText: 'Flight Date ',
              labelStyle:TextStyle(
                color:Theme.of(context).accentColor,
              ),
              enabledBorder:  OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide:  BorderSide(color:Theme.of(context).accentColor, width: 2.0),
              ),

            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(model.routeAndFlightDate1),
                Icon(
                  Icons.date_range,
                  color: Theme.of(context).accentColor,
                  // color: Colors.deepPurple,
                ),
              ],
            )
            // ListTile(
            //   title: Text(model.routeAndFlightDate1),
            //   trailing: Icon(
            //     Icons.date_range,
            //     color: Theme.of(context).accentColor,
            //     // color: Colors.deepPurple,
            //   ),
            //   // subtitle: Text(
            //   //
            //   //   // "Executed on (date)",
            //   //   S.of(context).FlightDate+" *",
            //   //   style: TextStyle(
            //   //     color: Theme.of(context).accentColor,
            //   //     //color: Colors.deepPurple
            //   //   ),
            //   // 'Flight Date'
            // ),
          ),
        ),



        // Container(
        //   decoration: BoxDecoration(
        //     border: Border.all(
        //       width: 2,
        //       color: Theme.of(context).accentColor,
        //       // color: Colors.deepPurple,
        //       style: BorderStyle.solid,
        //     ),
        //     borderRadius: BorderRadius.all(
        //       Radius.circular(8.0),
        //     ),
        //   ),
        //   child: ListTile(
        //     title: Text(model.routeAndFlightDate1),
        //     trailing: Icon(
        //       Icons.date_range,
        //       color: Theme.of(context).accentColor,
        //       //color: Colors.deepPurple,
        //     ),
        //     subtitle: Text(
        //       S.of(context).FlightDate,
        //       style: TextStyle(
        //         color: Theme.of(context).accentColor,
        //         // color: Colors.deepPurple
        //       ),
        //       // 'Flight Date'
        //     ),
        //   ),
        // )








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
      ),
    );
  }

  routeAndFlightDate2(model) {
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
            model.routeAndFlightDate2 =
                '${_date.day}${month[_date.month - 1]}${_date.year}';
          });
        },
          child: Container(
            // decoration: BoxDecoration(
            //
            //   border: Border.all(
            //     width: 2,
            //     color: Theme.of(context).accentColor,
            //     //color: Colors.deepPurple,
            //     style: BorderStyle.solid,
            //   ),
            //   borderRadius: BorderRadius.all(
            //     Radius.circular(8.0),
            //   ),
            // ),
            child: InputDecorator(
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Theme.of(context).accentColor)),
                labelText: 'Flight Date ',
                labelStyle:TextStyle(
                  color:Theme.of(context).accentColor,
                ),
                enabledBorder:  OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderSide:  BorderSide(color:Theme.of(context).accentColor, width: 2.0),
                ),

              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(model.routeAndFlightDate2),
                  Icon(
                    Icons.date_range,
                    color: Theme.of(context).accentColor,
                    // color: Colors.deepPurple,
                  ),
                ],
              )
              // ListTile(
              //   title: Text(model.routeAndFlightDate2),
              //   trailing: Icon(
              //     Icons.date_range,
              //     color: Theme.of(context).accentColor,
              //     // color: Colors.deepPurple,
              //   ),
              //   // subtitle: Text(
              //   //
              //   //   // "Executed on (date)",
              //   //   S.of(context).FlightDate+" *",
              //   //   style: TextStyle(
              //   //     color: Theme.of(context).accentColor,
              //   //     //color: Colors.deepPurple
              //   //   ),
              //   // 'Flight Date'
              // ),
            ),
          )
        // child: Container(
        //   decoration: BoxDecoration(
        //     border: Border.all(
        //       width: 2,
        //       color: Theme.of(context).accentColor,
        //       //color: Colors.deepPurple,
        //       style: BorderStyle.solid,
        //     ),
        //     borderRadius: BorderRadius.all(
        //       Radius.circular(8.0),
        //     ),
        //   ),
        //   child: ListTile(
        //     title: Text(model.routeAndFlightDate2),
        //     trailing: Icon(
        //       Icons.date_range,
        //       color: Theme.of(context).accentColor,
        //       // color: Colors.deepPurple
        //     ),
        //     subtitle: Text(
        //       S.of(context).FlightDate,
        //       style: TextStyle(
        //         color: Theme.of(context).accentColor,
        //         //color: Colors.deepPurple
        //       ),
        //       //  'Flight Date'
        //     ),
        //   ),
        // )
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
