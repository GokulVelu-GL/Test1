import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/ui/eawb/consignee.dart';
import 'package:rooster/ui/eawb/static/custom_background.dart';
import 'package:rooster/ui/eawb/routing_and_flight_bookings.dart';

import '../../formatter.dart';

class IssuingCarriersAgent extends StatefulWidget {
  IssuingCarriersAgent({Key key}) : super(key: key);

  @override
  _IssuingCarriersAgentState createState() => _IssuingCarriersAgentState();
}

class _IssuingCarriersAgentState extends State<IssuingCarriersAgent> {
  final _issuingCarriersAgentFormKey = GlobalKey<FormState>();

  FocusNode _issuingCarriersAgentAccountNumberFocusNode = FocusNode();
  FocusNode _issuingCarriersAgentNameFocusNode = FocusNode();
  FocusNode _issuingCarriersAgentCityFocusNode = FocusNode();
  FocusNode _issuingCarriersAgentPlaceFocusNode = FocusNode();
  FocusNode _issuingCarriersAgentCassAddFocusNode = FocusNode();
  FocusNode _issuingCarriersAgentIataCodeFocusNode = FocusNode();

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
              previous: Consignee(),
              next: RoutingAndFlightBookings(),
              name: S.of(context).Issuingcarriersagent,
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
                                      leading: Icon(Icons.location_city,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Account Number"),
                                      subtitle: Text("Coded identification of a participant\n Example: ABC94269 "),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.contacts_rounded,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Name"),
                                      subtitle: Text("Identification of individual or company involved in the movement of a consignment\nExample: ACE SHIPPING CO. "),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.add_location_rounded,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Place"),
                                      subtitle: Text("Location of individual or company involved in the movement of a consignment\nExample: LONDON"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.location_city,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("CASS Address"),
                                      subtitle: Text("Code issued by IATA to identify individual agent locations for CASS billing purposes\nExample: 1234"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.code,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("IATA Code"),
                                      subtitle: Text("Code issued by IATA to identify each IATA Cargo Agent whose name is entered on the Cargo Agency List\nExample: 1234567"),
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
              //"Issuing Carriers Agent",
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _issuingCarriersAgentFormKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          accountNumber(model),
                          name(model),
                          city(model),
                          place(model),
                          cassAddress(model),
                          iataCode(model),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
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

  name(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.issuingCarrierAgentName,
        focusNode: _issuingCarriersAgentNameFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        // onFieldSubmitted: (value) {
        //   _fieldFocusChange(context, _issuingCarriersAgentNameFocusNode,
        //       _issuingCarriersAgentCityFocusNode);
        // },
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
                //  color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).Name+" *",
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.contacts_rounded,
              color: Theme.of(context).accentColor,
              //color: Colors.deepPurple,
            )
            //'Name',
            ),
        onChanged: (text) {
          setState(() {
            model.issuingCarrierAgentName = text;
          });
        },
      ),
    );
  }

  city(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.issuingCarrierAgentCity,
        focusNode: _issuingCarriersAgentCityFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        // onFieldSubmitted: (value) {
        //   _fieldFocusChange(context, _issuingCarriersAgentNameFocusNode,
        //       _issuingCarriersAgentIataCodeFocusNode);
        // },
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
            // borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).City,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.location_city,
              color: Theme.of(context).accentColor,
              //   color: Colors.deepPurple,
            )
            //'City',
            ),
        onChanged: (text) {
          setState(() {
            model.issuingCarrierAgentCity = text;
          });
        },
      ),
    );
  }

  place(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.issuingCarrierAgentPlace,
        //focusNode: _issuingCarriersAgentNameFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        // onFieldSubmitted: (value) {
        //   _fieldFocusChange(context, _issuingCarriersAgentNameFocusNode,
        //       _issuingCarriersAgentCityFocusNode);
        // },
        decoration: InputDecoration(
            isDense: true,
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
                //  color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).Place+" *",
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.place_outlined,
              color: Theme.of(context).accentColor,
              //  color: Colors.deepPurple,
            )
            //'Place',
            ),
        onChanged: (text) {
          setState(() {
            model.issuingCarrierAgentPlace = text;
          });
        },
      ),
    );
  }

  iataCode(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.issuingCarrierAgentIATACode,
        //focusNode: _issuingCarriersAgentIataCodeFocusNode,
        //In FWB, Under Agent data block  IATA Cargo Agent Numeric Code is a 7 digit numeric code
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        maxLength: 7,
        inputFormatters: [
          AllCapitalCase(),
          LengthLimitingTextInputFormatter(3)
        ],
        // onFieldSubmitted: (value) {
        //   _fieldFocusChange(context, _issuingCarriersAgentIataCodeFocusNode,
        //       _issuingCarriersAgentAccountNumberFocusNode);
        // },
        decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,
                    //color: Colors.deepPurple
                    width: 2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).accentColor,
                //  color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).IATACode,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.code,
              color: Theme.of(context).accentColor,
              //  color: Colors.deepPurple,
            )
            //'IATA Code',
            ),
        onChanged: (text) {
          setState(() {
            model.issuingCarrierAgentIATACode = text;
          });
        },
      ),
    );
  }

  cassAddress(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.issuingCarrierAgentCassAddress,
        //focusNode: _issuingCarriersAgentNameFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        // onFieldSubmitted: (value) {
        //   _fieldFocusChange(context, _issuingCarriersAgentNameFocusNode,
        //       _issuingCarriersAgentCityFocusNode);
        // },
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
            labelText: S.of(context).CASSAddress,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.location_city,
              color: Theme.of(context).accentColor,
              //  color: Colors.deepPurple,
            )
            //'CASS Address',
            ),
        onChanged: (text) {
          setState(() {
            model.issuingCarrierAgentCassAddress = text;
          });
        },
      ),
    );
  }

  accountNumber(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.issuingCarrierAgentAccountNumber,
        //focusNode: _issuingCarriersAgentAccountNumberFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        onFieldSubmitted: (value) {
          _issuingCarriersAgentAccountNumberFocusNode.unfocus();
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
            labelText: S.of(context).AccountNumber,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //  color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.location_city,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
            //'Account Number',
            ),
        onChanged: (text) {
          setState(() {
            model.issuingCarrierAgentAccountNumber = text;
          });
        },
      ),
    );
  }
}
