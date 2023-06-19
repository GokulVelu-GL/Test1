import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/ui/drodowns/airport_code.dart';
import 'package:rooster/ui/eawb/notify.dart';
import 'package:rooster/ui/eawb/shipper.dart';
import 'package:rooster/ui/eawb/static/custom_background.dart';
import 'package:rooster/ui/eawb/issuer.dart';
import 'package:rooster/ui/eawb/routing_and_flight_bookings.dart';

import '../../formatter.dart';
import 'consignee.dart';

class AwbConsignmentDetails extends StatefulWidget {
  AwbConsignmentDetails({Key key}) : super(key: key);

  @override
  _AwbConsignmentDetailsState createState() => _AwbConsignmentDetailsState();
}

class _AwbConsignmentDetailsState extends State<AwbConsignmentDetails> {
  List<String> weightunitlist=[
    "K",
    "L"
  ];
   // entitlement = ["K", "L"];
  String _chosenValue = 'K';
  List<String> volumeunitlist=[
    "S",
    "CC",
    "CF",
    "CI",
    "MC"
  ]; List<String> densitylist=[
   "DG"
  ];
  // entitlement = ["K", "L"];
  String volumeunit = 'CC';
  String densityunit ="DG";

  int _value=1;
  final _awbConsignmentDetailsFormKey = GlobalKey<FormState>();

  final TextEditingController VolumeCodeController = TextEditingController();


  FocusNode _awbConsignmentDetailsAwbFocusNode = FocusNode();
  FocusNode _awbConsignmentDetailsDepAirportCodeFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer<EAWBModel>(
        builder: (context, model, child) => WillPopScope(
              onWillPop: () async {
                model.setStatus();
                return true;
              },
              child: Scaffold(
                body: SafeArea(


                  child: CustomBackground(
                    // previous: RoutingAndFlightBookings(),
                    next: Shipper(),
                    name: S.of(context).AwbConsignmentdetails,
                    help:    IconButton(
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
                                            title: Text("Airline Prefix"),
                                            subtitle: Text("Coded representation of an airline\nExample: 176"),
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            leading: Icon(Icons.flight,
                                              color: Theme.of(context).accentColor,
                                            ),
                                            title: Text("AWB Serial Number"),
                                            subtitle: Text("A serial number allocated by an airline to identify a particular air cargo shipment and the associated Air Waybill\nExample: 01122474 "),
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            leading: Icon(Icons.flight_takeoff_sharp,
                                              color: Theme.of(context).accentColor,
                                            ),
                                            title: Text("Origin and destination"),
                                            subtitle: Text("Coded representation of a specific airport/city code \nExample: MLE"),
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            leading: Icon(Icons.production_quantity_limits,
                                              color: Theme.of(context).accentColor,
                                            ),
                                            title: Text("Pieces"),
                                            subtitle: Text("Number of Loose Items and/or ULD’s as accepted for carriage\nExample: 8"),
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            leading: Icon(Icons.monitor_weight,
                                              color: Theme.of(context).accentColor,
                                            ),
                                            title: Text("Weight"),
                                            subtitle: Text("Weight measure\nExample: 140.0"),
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            leading: Icon(Icons.monitor_weight,
                                              color: Theme.of(context).accentColor,
                                            ),
                                            title: Text("WeightUnit"),
                                            subtitle: Text("Weight measure\nExample: K"),
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            leading: Icon(Icons.production_quantity_limits,
                                              color: Theme.of(context).accentColor,
                                            ),
                                            title: Text("DensityGroup"),
                                            subtitle: Text("Code indicating approximate density of goods\nExample: 9"),
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            leading: Icon(Icons.production_quantity_limits,
                                              color: Theme.of(context).accentColor,
                                            ),
                                            title: Text("Density Indicator"),
                                            subtitle: Text("Code indicating density group\nExample: DG (Density Group)"),
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            leading: Icon(Icons.production_quantity_limits,
                                              color: Theme.of(context).accentColor,
                                            ),
                                            title: Text("Volume"),
                                            subtitle: Text("Cubic measure of a consignment\nExample: 12.00"),
                                          ),
                                        ), Card(
                                          child: ListTile(
                                            leading: Icon(Icons.production_quantity_limits,
                                              color: Theme.of(context).accentColor,
                                            ),
                                            title: Text("VolumeUnit"),
                                            subtitle: Text("Code indicating unit of volume\nExample: CC(Cubic Centimetres),\nCF(Cubic Feet), CI(Cubic Inches),\nMC(Metres Cubic) "),
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
                    //"AWB Consignment Details",
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _awbConsignmentDetailsFormKey,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // volumeCodeTF(model),
                                // IconButton(onPressed: (){
                                //   showDialog(
                                //     context: context,
                                //     builder: (ctx) => AlertDialog(
                                //       shape: RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.all(Radius.circular(30.0))),
                                //       title: Container(
                                //               padding: EdgeInsets.only(left: 15.0,
                                //                   top: 10.0,bottom: 10.0,
                                //                   right: 15.0),
                                //               child: Center(child: Text("Help")),
                                //               decoration: BoxDecoration(
                                //                 shape: BoxShape.rectangle,
                                //                 borderRadius: BorderRadius.all(Radius.circular(12)),
                                //                 // border: Border.all(
                                //                 //     color: Theme.of(context).backgroundColor, width: _resizableController.value * 10),
                                //               ),
                                //             ),
                                //
                                //       content: Column(
                                //         mainAxisSize: MainAxisSize.min,
                                //         children: [
                                //           Card(
                                //             child: ListTile(
                                //               leading: Icon(Icons.flight,
                                //                 color: Theme.of(context).accentColor,
                                //               ),
                                //               title: Text("Airline Prefix"),
                                //               subtitle: Text("Coded representation of an airline"),
                                //             ),
                                //           ),
                                //           Card(
                                //             child: ListTile(
                                //               leading: Icon(Icons.flight,
                                //                 color: Theme.of(context).accentColor,
                                //               ),
                                //               title: Text("AWB Serial Number"),
                                //               subtitle: Text("A serial number allocated by an airline to identify a particular air cargo shipment and the associated Air Waybill"),
                                //             ),
                                //           ),
                                //           Card(
                                //             child: ListTile(
                                //               leading: Icon(Icons.monetization_on_rounded,
                                //                 color: Theme.of(context).accentColor,
                                //               ),
                                //               title: Text("Origin and destination"),
                                //               subtitle: Text("Coded representation of a specific airport/city code"),
                                //             ),
                                //           ),
                                //           Card(
                                //             child: ListTile(
                                //               leading: Text("Trail"),
                                //               title: Text("Trail user not allowed to use mandatory pages"),
                                //             ),
                                //           ),
                                //           Card(
                                //             child: ListTile(
                                //               leading: Text("Gold",style:
                                //               TextStyle(
                                //                   color: Colors.orangeAccent
                                //               ),),
                                //               title: Text("user can access all page"),
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //       actions: <Widget>[
                                //         TextButton(
                                //           onPressed: () {
                                //             Navigator.of(ctx).pop();
                                //           },
                                //           child: Center(
                                //             child: Container(
                                //               padding: const EdgeInsets.all(14),
                                //               child:  Text("Close",
                                //                 style: TextStyle(
                                //                   color: Theme.of(context).accentColor,
                                //                 ),
                                //               ),
                                //             ),
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   );
                                // }, icon: Icon(Icons.help)),
                                awbNumber(model),
                                //depAirportCode(model),
                                originTF(model),
                                SizedBox(
                                  height: 4,
                                ),
                                destinationTF(model),
                                SizedBox(
                                  height: 4,
                                ),
                                piecesTF(model),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child:weightTF(model),),
                                    Expanded(child: weightUnitTF(model),)
                                  ],
                                ),

                                // SizedBox(
                                //   height: 4,
                                // ),

                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    for (int i = 1; i <= 2; i++)
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            i==1?'Volume':"Density",
                                            style: Theme.of(context).textTheme.subtitle1.copyWith(color: i == 5 ? Colors.black38 : Colors.black),
                                          ),
                                          leading: Radio(
                                            value: i,
                                            groupValue: _value,
                                            activeColor: Theme.of(context).accentColor,
                                            onChanged: i == 5 ?0 : (int value) {
                                              setState(() {
                                                _value = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                               _value==1? Column(
                                 children: [
                                   volumeCodeTF(model),
                                   volumeTF(model),
                                   Container(
                                     height: 200,
                                   )
                                 ],
                               ): Row(
                                 children: [
                                Expanded(
                                  flex: 4,
                                  child:densityGroupTF(model),),
                                   Expanded(child: DensityCodeTF(model)),

                                 ],
                               ),

                                 // _value==1?  Text(""): densityIndicator(model),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }

  awbNumber(EAWBModel model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.awbConsigmentDetailsAWBNumber == ''
            ? model.awbConsigmentDetailsAWBNumber
            : '${model.awbConsigmentDetailsAWBNumber.substring(0, 3)}${model.awbConsigmentDetailsAWBNumber.substring(3)}',
        focusNode: _awbConsignmentDetailsAwbFocusNode,
        validator: (value) {
          if (value.length == 12) value = value.substring(0, 12);
          if (value.isEmpty) return
              S.of(context).GiveAWBNumbertocreateorretriveeAWB;

          //"Give AWB Number to create or retrive eAWB";
          if (value.length != 12)
            return
              S.of(context).AWBnumbershouldbe12including;
              "AWB number should be 12 including '-'";
          if (value.indexOf("-") != 3)
            return
              S.of(context).EntervalidAWBnumbereg15078596324;
              //"Enter valid AWB number - eg: 150-78596324";
          return null;
        },
        onFieldSubmitted: (value) {
          if (_awbConsignmentDetailsFormKey.currentState.validate()) {
            setState(() {
              model.awbConsigmentDetailsAWBNumber = value;
              print(value);
            });
          } else {
            print("Error in AWB Number");
          }
          _fieldFocusChange(context, _awbConsignmentDetailsAwbFocusNode,
              _awbConsignmentDetailsDepAirportCodeFocusNode);
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(12),
          MaskTextInputFormatter(
            mask: "###-########",
            filter: {"#": RegExp(r'[0-9]')},
          )
        ],
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          // helperText:"*",
          //   helperStyle: TextStyle(
          //     color: Colors.red
          //   ),
            counterStyle: TextStyle(color: Colors.black),
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,

                  //color: Colors.deepPurple,
                    width: 2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(8.0),
                ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2,
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10),
            // ),
            hintText: "___-________",
            labelText: S.of(context).AWBnumber+" *",
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.flight_takeoff,
              color: Theme.of(context).accentColor,
              //  color: Colors.deepPurple,
            )),

        //"AWB-Number"),
        maxLength: 12,
        // maxLengthEnforced: true,
      ),
    );
  }

  depAirportCode(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.awbConsigmentDetailsDepAirportCode,
        focusNode: _awbConsignmentDetailsDepAirportCodeFocusNode,
        maxLength: 3,
        // maxLengthEnforced: true,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.characters,
        textInputAction: TextInputAction.done,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _awbConsignmentDetailsDepAirportCodeFocusNode.unfocus();
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
              borderSide: BorderSide(width: 2,
                color: Theme.of(context).accentColor,
                //  color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).DepAirportCode,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.flight_takeoff,
              color: Theme.of(context).accentColor,
              //color: Colors.deepPurple,
            )
            // 'Dep. Airport Code',
            ),
        onChanged: (text) {
          setState(() {
            model.awbConsigmentDetailsDepAirportCode = text;
          });
        },
      ),
    );
  }

  final _awbForm = GlobalKey<FormState>();
  String origin;
  String destination;
  String densityGroup;
  String volume;
  String volumeCode = 'K';
  String pieces;
  String weight;
  String weightUnit = 'K';
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController densityindicator = TextEditingController();

  // final TextEditingController volumeController = TextEditingController();
  // final TextEditingController piecesController = TextEditingController();
  // final TextEditingController weightController = TextEditingController();
  // final TextEditingController densityGroupController = TextEditingController();

  originTF(model) {
    this.originController.text = model.awbConsigmentOriginPrefix;
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
                  S.of(context).SelectaOrigin;
                  //'Select a Origin';
              }
              return null;
            },
            //initialValue: origin,
            textFieldConfiguration: TextFieldConfiguration(
              inputFormatters: [AllCapitalCase()],
              controller: this.originController,
              decoration: InputDecoration(
                  isDense: true,
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
                      //color: Colors.deepPurple
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  // border: OutlineInputBorder(
                  //     gapPadding: 2.0,
                  //     borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  labelText: S.of(context).Origin+" *",
                  labelStyle:
                      new TextStyle(
                          color: Theme.of(context).accentColor,
                        //  color: Colors.deepPurple,
                          fontSize: 16.0),
                  suffixIcon: Icon(
                    Icons.flight_takeoff,
                    color: Theme.of(context).accentColor,
                    //  color: Colors.deepPurple,
                  )

                  //'Origin',
                  ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onSuggestionSelected: (AirportCode suggestion) {
              if (suggestion.airportCode == null &&
                  suggestion.airportName == null) {
                return
                  S.of(context).WorongAWBNumber;
                  //'Worong AWB Number';
              } else {
                this.originController.text = suggestion.airportCode;
                model.awbConsigmentOriginPrefix = suggestion.airportCode;
                //print(origin);
              }
            }
            ));
  }

  destinationTF(model) {
    final focus = FocusNode();
    this.destinationController.text = model.awbConsigmentDestination;
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
                  S.of(context).SelectaDestination;
                  //'Select a Destination';
              }
              return null;
            },
            textFieldConfiguration: TextFieldConfiguration(
              autofocus: false,
              focusNode: focus,
              controller: this.destinationController,
              inputFormatters: [AllCapitalCase()],
              decoration: InputDecoration(
                  isDense: true,
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
                  // border: OutlineInputBorder(
                  //     gapPadding: 2.0,
                  //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText: S.of(context).Destination +" *",
                  labelStyle:
                      new TextStyle(
                          color: Theme.of(context).accentColor,
                        // color: Colors.deepPurple,
                          fontSize: 16.0),
                  suffixIcon: Icon(
                    Icons.flight_land,
                    color: Theme.of(context).accentColor,
                    // color: Colors.deepPurple,
                  )
                  // 'Destination',
                  ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onSuggestionSelected: (AirportCode suggestion) {
              this.destinationController.text = suggestion.airportCode;
              model.awbConsigmentDestination = suggestion.airportCode;
              //print(destination);
            }));
  }

  piecesTF(model) {
    pieces = model.awbConsigmentPices;
    return Container(
        margin: EdgeInsets.all(10.0),
        child: TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          inputFormatters: [AllCapitalCase()],
          decoration: InputDecoration(
              isDense: true,
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      new BorderSide(
                          color: Theme.of(context).accentColor,
                        //  color: Colors.deepPurple,
                          width: 2),
                  //gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2,
                  color: Theme.of(context).accentColor,
                  //  color: Colors.deepPurple
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              // border: OutlineInputBorder(
              //     gapPadding: 2.0,
              //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText: S.of(context).Pieces+" *",
              labelStyle:
                  new TextStyle(
                      color: Theme.of(context).accentColor,
                    // color: Colors.deepPurple,
                      fontSize: 16.0),
              suffixIcon: Icon(
                Icons.production_quantity_limits,
                color: Theme.of(context).accentColor,
               // color: Colors.deepPurple,
              )
              //'Pieces',
              ),
          initialValue: pieces != null ? pieces : "",
          validator: (value) {
            if (value.isEmpty || value == null) {
              return
                S.of(context).PleaseEnterthepieces;
                //"Please Enter the pieces";
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              model.awbConsigmentPices = value;
            });
          },
        ));
  }

  densityIndicator(model) {
    // densityIndicator = model.awbConsigmentPices;
    return Container(
        margin: EdgeInsets.all(10.0),
        child: TextFormField(
          controller: densityindicator,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          inputFormatters: [AllCapitalCase()],
          decoration: InputDecoration(
              isDense: true,
              enabledBorder: OutlineInputBorder(
                  borderSide:
                  new BorderSide(
                      color: Theme.of(context).accentColor,
                      //  color: Colors.deepPurple,
                      width: 2),
                  //gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2,
                  color: Theme.of(context).accentColor,
                  //  color: Colors.deepPurple
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              // border: OutlineInputBorder(
              //     gapPadding: 2.0,
              //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText:
              'Density Indicator',
              //S.of(context).Pieces,
              labelStyle:
              new TextStyle(
                  color: Theme.of(context).accentColor,
                  // color: Colors.deepPurple,
                  fontSize: 16.0),
              suffixIcon: Icon(
                Icons.production_quantity_limits,
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
              )
            //'Pieces',
          ),
          // initialValue: pieces != null ? pieces : "",
          validator: (value) {
            if (value.isEmpty || value == null) {
              return
                S.of(context).PleaseEnterthepieces;
              //"Please Enter the pieces";
            }
            return null;
          },
          // onChanged: (value) {
          //   setState(() {
          //     model.awbConsigmentPices = value;
          //   });
          // },
        ));
  }

  densityGroupTF(model) {
    densityGroup = model.awbConsigmentDensity;
    return Container(
        margin: EdgeInsets.all(10.0),
        child: TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          inputFormatters: [AllCapitalCase()],
          decoration: InputDecoration(
              isDense: true,
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
                  // color: Colors.deepPurple
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              // border: OutlineInputBorder(
              //     gapPadding: 2.0,
              //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText: S.of(context).DensityGroup,
              labelStyle:
                  new TextStyle(
                      color: Theme.of(context).accentColor,
                    //  color: Colors.deepPurple,
                      fontSize: 16.0),
              suffixIcon: Icon(
                Icons.production_quantity_limits,
                color: Theme.of(context).accentColor,
               // color: Colors.deepPurple,
              )
              //     'Density Group',
              ),
          validator: (value) {
            if (value.isEmpty || value == null) {
              return
                S.of(context).PleaseEnterthedensity;
                //"Please Enter the density";
            }
            return null;
          },
          initialValue: densityGroup != null ? densityGroup : "",
          onChanged: (value) {
            setState(() {
              model.awbConsigmentDensity = value;
            });
          },
        ));
  }


  weightTF(model) {
    weight = model.awbConsigmentWeight;
    return Container(
        margin: EdgeInsets.all(10.0),
        child: TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          inputFormatters: [AllCapitalCase()],
          decoration: InputDecoration(
              isDense: true,
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      new BorderSide(
                          color: Theme.of(context).accentColor,
                        //color: Colors.deepPurple,
                          width: 2),
                  //gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2,
                  color: Theme.of(context).accentColor,
                  //  color: Colors.deepPurple
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              // border: OutlineInputBorder(
              //     gapPadding: 2.0,
              //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText: S.of(context).Weight+" *",
              labelStyle:
                  new TextStyle(
                      color: Theme.of(context).accentColor,
                    //color: Colors.deepPurple,
                      fontSize: 16.0),
              suffixIcon: Icon(
                Icons.monitor_weight,
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
              )
              //'Weight',
              ),
          validator: (value) {
            if (value.isEmpty || value == null) {
              return
                S.of(context).PleaseEntertheweight;
                //"Please Enter the weight";
            }
            return null;
          },
          initialValue: weight != null ? weight : "",
          onChanged: (value) {
            setState(() {
              model.awbConsigmentWeight = value;
            });
          },
        ));
  }

  volumeTF(model) {
    volume = model.awbConsigmentVolume;
    return Container(
        margin: EdgeInsets.all(10.0),
        child: TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          inputFormatters: [AllCapitalCase()],
          decoration: InputDecoration(
              isDense: true,
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
              // border: OutlineInputBorder(
              //     gapPadding: 2.0,
              //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText: S.of(context).Volume,
              labelStyle:
                  new TextStyle(
                      color: Theme.of(context).accentColor,
                    //color: Colors.deepPurple,
                      fontSize: 16.0),
              suffixIcon: Icon(
                Icons.production_quantity_limits,
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
              )
              //'Volume',
              ),
          validator: (value) {
            if (value.isEmpty || value == null) {
              return
                S.of(context).PleaseEntertheVolume;
                //"Please Enter the Volume";
            }
            return null;
          },
          initialValue: volume != null ? volume : "",
          onChanged: (value) {
            setState(() {
              model.awbConsigmentVolume = value;
            });
          },
        ));
  }

  volumeCodeTF(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TypeAheadField<Volume>(
          suggestionsCallback: VolumeCodeApi.getVolumeCode,
          itemBuilder: (context, Volume suggestion) {
            final code = suggestion;
            return ListTile(
              title: Text(code.abbrcode,
                  style: TextStyle(
                      color: Theme.of(context).accentColor)),
              subtitle: Text(code.meaning,
                  style: TextStyle(
                      color: Theme.of(context).accentColor)),
            );
          },
          textFieldConfiguration: TextFieldConfiguration(
            inputFormatters: [AllCapitalCase()],
            controller: VolumeCodeController,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                      width: 2
                  ),
                  borderRadius:
                  BorderRadius.all(Radius.circular(8.0)),
                ),
                //border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                      width: 2
                  ),
                  borderRadius:
                  BorderRadius.all(Radius.circular(8.0)),
                ),
                border: OutlineInputBorder(
                    gapPadding: 2.0,
                    borderRadius:
                    BorderRadius.all(Radius.circular(8.0))),
                labelText: "Volume Unit",
                //S.of(context).Origin,
                labelStyle:
                TextStyle(color: Theme.of(context).accentColor)
              //'Origin',
            ),
          ),
          onSuggestionSelected: (Volume suggestion) {

            // sippercontactList[index]['Shipper_Contact_Type'] =
            //     suggestion.contactCode;
            VolumeCodeController.text = suggestion.abbrcode;
            //_fhlModel.houseDetailsOrigin = suggestion.airportCode;
            //
          }),
    );
    // return Container(
    //   margin: EdgeInsets.all(5.0),
    //   child: DropdownButton<String>(
    //       icon: Icon(Icons.arrow_drop_down),
    //       value: volumeunit,
    //       items: volumeunitlist.map<DropdownMenuItem<String>>(
    //               (String value) {
    //             return DropdownMenuItem<String>(
    //               value: value,
    //               child: Text(value),
    //             );
    //           }).toList(),
    //       onChanged: (String text) {
    //         setState(() {
    //           volumeunit = text;
    //           model.awbConsigmentDensity = text;
    //           print(densityunit);
    //         });
    //       }),
    // );
  }

  DensityCodeTF(model) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: DropdownButton<String>(
          icon: Visibility (visible:false, child: Icon(Icons.arrow_downward)),
          //icon: Icon(Icons.arrow_drop_down),
          value: densityunit,
          items: densitylist.map<DropdownMenuItem<String>>(
                  (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
          onChanged: (String text) {
            setState(() {
              densityunit = text;
              model.awbConsigmentDensity = text;
              print(densityunit);
            });
          }),
    );
  }

  weightUnitTF(model) {
    return Container(
        margin: EdgeInsets.all(10.0),
     child:   DropdownButton<String>(
         icon: Icon(Icons.arrow_drop_down),
         value: _chosenValue,
         items: weightunitlist.map<DropdownMenuItem<String>>(
                 (String value) {
               return DropdownMenuItem<String>(
                 value: value,
                 child: Text(value),
               );
             }).toList(),
         onChanged: (String text) {
           setState(() {

             _chosenValue = text;
             model.awbConsigmentWeightCode = text;
             print(_chosenValue);
           });
         })
    );
        // child: DropdownButton<String>(
        //   isDense: true,
        //   icon: Icon(Icons.arrow_drop_down),
        //   value: weightUnit,
        //   items: ['K', 'L'].map<DropdownMenuItem<String>>(
        //     (String value) {
        //       return DropdownMenuItem<String>(
        //         value: value,
        //         child: Text(value),
        //       );
        //     },
        //   ).toList(),
        //   onChanged: (String text) {
        //     setState(
        //       () {
        //         model.awbConsigmentWeightCode = text;
        //       },
        //     );
        //   },
        // ));
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
