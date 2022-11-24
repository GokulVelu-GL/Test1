import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rooster/formatter.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/ui/eawb/static/custom_background.dart';
import 'package:rooster/ui/eawb/shippers_certification.dart';

class CarriersExecution extends StatefulWidget {
  CarriersExecution({Key key}) : super(key: key);

  @override
  _CarriersExecutionState createState() => _CarriersExecutionState();
}

class _CarriersExecutionState extends State<CarriersExecution> {
  final _carriersExecutionFormKey = GlobalKey<FormState>();

  FocusNode _carriersExecutionRemarksFocusNode = FocusNode();
  FocusNode _executedOnFocusNode = FocusNode();
  FocusNode _atPlaceFocusNode = FocusNode();
  FocusNode _signatureOfIssuingCarrierOrItsAgentFocusNode = FocusNode();
  bool value = false;

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
              name: S.of(context).Carriersexecution,
              help:IconButton(
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
                                      leading: Icon(Icons.calendar_month,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Flight Date"),
                                      subtitle: Text("Numeric representation of a day in a month\nExample: 15AUG2022"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.note_alt,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Signature"),
                                      subtitle: Text("Name of signatory \nExample: K. WILSON"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.add_location,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Place"),
                                      subtitle: Text("Location of individual or company involved in the movement of a consignment\nExample: LONDON"),
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
              //"Carriers Execution",
              previous: ShippersCertification(),
              child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _carriersExecutionFormKey,
                      child: SingleChildScrollView(
                          child: Column(
                        children: <Widget>[
                          //carriersExecutionRemarks(model),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: this.value,
                                onChanged: (bool value) {
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
                                  setState(() {

                                    this.value = value;
                                    model.executedOn =   '${DateTime.now().day}${month[DateTime.now().month-1]}${DateTime.now().year}';
                                    // '${month[_date.month - 1]}-${_date.day}-${_date.year}';
                                  });

                                },
                              ),
                              Text("Current Date",
                              style: TextStyle(
                                color: Theme.of(context).accentColor
                              ),
                              )
                            ],
                          ),
                          executedOn(model),
                          atPlace(model),
                          signatureOfIssuingCarrierOrItsAgent(model),
                        ],
                      )),
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  carriersExecutionRemarks(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.carriersExecutionRemarks,
        focusNode: _carriersExecutionRemarksFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _carriersExecutionRemarksFocusNode,
              _executedOnFocusNode);
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
                gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).CarriersExecutionRemarks
            //'Carriers Execution Remarks',
            ),
        onChanged: (text) {
          model.carriersExecutionRemarks = text;
        },
      ),
    );
  }

  executedOn(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Container(
        // margin: EdgeInsets.all(10.0),
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
              model.executedOn =   '${_date.day}${month[_date.month - 1]}${_date.year}';
                  // '${month[_date.month - 1]}-${_date.day}-${_date.year}';
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
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: Theme.of(context).accentColor)),
                labelText: 'AWB Issue Date *',
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
                  Text(model.executedOn),
                Icon(
                      Icons.date_range,
                      color: Theme.of(context).accentColor,
                      // color: Colors.deepPurple,
                    ),
                ],///
              )
              // child: ListTile(
              //   title: Text(model.executedOn),
              //   trailing: Icon(
              //     Icons.date_range,
              //     color: Theme.of(context).accentColor,
              //     // color: Colors.deepPurple,
              //   ),
              //
              //   // subtitle: Text(
              //   //
              //   //   // "Executed on (date)",
              //   //   S.of(context).FlightDate+" *",
              //   //   style: TextStyle(
              //   //     color: Theme.of(context).accentColor,
              //   //     //color: Colors.deepPurple
              //   //   ),
              //     // 'Flight Date'
              //   ),
              ),
            ),
          )

          // Container(
          //   child: Container(
          //
          //     decoration: BoxDecoration(
          //
          //       border: Border.all(
          //         width: 2,
          //         color: Theme.of(context).accentColor,
          //         //color: Colors.deepPurple,
          //         style: BorderStyle.solid,
          //       ),
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(8.0),
          //       ),
          //     ),
          //     child: ListTile(
          //       title: Text(model.executedOn),
          //       trailing: Icon(
          //         Icons.date_range,
          //         color: Theme.of(context).accentColor,
          //         // color: Colors.deepPurple,
          //       ),
          //       subtitle: Text(
          //
          //        // "Executed on (date)",
          //         S.of(context).FlightDate+" *",
          //         style: TextStyle(
          //           color: Theme.of(context).accentColor,
          //           //color: Colors.deepPurple
          //         ),
          //         // 'Flight Date'
          //       ),
          //     ),
          //   ),
          // )
          //
          //








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
      /*TextFormField(
        initialValue: model.executedOn,
        focusNode: _executedOnFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _executedOnFocusNode, _atPlaceFocusNode);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
              gapPadding: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText: 'Executed on (date)',
        ),
        onChanged: (text) {
          model.executedOn = text;
        },
      )*/

  }

  atPlace(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.atPlace,
        focusNode: _atPlaceFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _atPlaceFocusNode,
              _signatureOfIssuingCarrierOrItsAgentFocusNode);
        },
        decoration: InputDecoration(
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
            labelText: S.of(context).AtPlace+" *",
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.place,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
            // 'At (Place)',
            ),
        onChanged: (text) {
          model.atPlace = text;
        },
      ),
    );
  }

  signatureOfIssuingCarrierOrItsAgent(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.signatureOfIssuingCarrier,
        focusNode: _signatureOfIssuingCarrierOrItsAgentFocusNode,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _signatureOfIssuingCarrierOrItsAgentFocusNode.unfocus();
        },
        decoration: InputDecoration(
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
            labelText: S.of(context).SignatureofIssuingCarrieroritsAgent,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.note_alt,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
            //  'Signature of Issuing Carrier or its Agent',
            ),
        onChanged: (text) {
          model.signatureOfIssuingCarrier = text;
        },
      ),
    );
  }
}
