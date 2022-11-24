import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:rooster/formatter.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/string.dart';
import 'package:rooster/ui/drodowns/airport_code.dart';
import 'package:rooster/ui/eawb/charges_summary.dart';
import 'package:rooster/ui/eawb/static/custom_background.dart';
import 'package:rooster/ui/eawb/other_charges.dart';

class CcChargesInDestinationCurrency extends StatefulWidget {
  CcChargesInDestinationCurrency({Key key}) : super(key: key);

  @override
  _CcChargesInDestinationCurrencyState createState() =>
      _CcChargesInDestinationCurrencyState();
}

class _CcChargesInDestinationCurrencyState
    extends State<CcChargesInDestinationCurrency> {
  final _ccChargesInDestinationCurrencyFormKey = GlobalKey<FormState>();

  FocusNode _currencyConversionRatesFocusNode = FocusNode();
  FocusNode _chargesAtDestinationFocusNode = FocusNode();
  FocusNode _ccChargesInDestCurrencyFocusNode = FocusNode();
  FocusNode _totalCollectChargesFocusNode = FocusNode();

  TextEditingController destCurrencyCode = new TextEditingController();
  TextEditingController destCurrencyRate = new TextEditingController();
  TextEditingController totalCollectCharge = new TextEditingController();
  TextEditingController ccChargeinDest = new TextEditingController();
  String flag;

  // @override
  // void dispose() {
  //   destCurrencyRate.dispose();
  //   destCurrencyCode.dispose();
  //   totalCollectCharge.dispose();
  //   ccChargeinDest.dispose();
  //   super.dispose();
  // }

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
              name: S.of(context).CCchargesindestinationcurrency,
              help:   IconButton(
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
                                      leading: Icon(Icons.money,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Total Prepaid"),
                                      subtitle: Text("An amount of money \nExample: 100 "),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.code,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Currency Code"),
                                      subtitle: Text("Coded representation of a currency approved by ISO \nExample: AED "),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.money,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Currency Conversion Rates"),
                                      subtitle: Text("The rate at which one specified currency is expressed in another specified currency \nExample: 3"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.money,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("CC Charge in Dest Currency "),
                                      subtitle: Text("An amount of money\nExample: 99"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.money,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Charge At Destination"),
                                      subtitle: Text("An amount of money \nExample: 120"),
                                    ),
                                  ),  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.money,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Total Collect Charges"),
                                      subtitle: Text("An amount of money\nExample: 100"),
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
              //"Cc Charges In Destination Currency",
              next: OtherCharges(),
              previous: ChargesSummary(),
              child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _ccChargesInDestinationCurrencyFormKey,
                      child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[

                              Container(
                             margin: EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder( //<-- 3. SEE HERE
                                side: BorderSide(
                                  color: Theme.of(context).accentColor,
                                  width: 2.0,
                                ),
                              ),
                              child: ListTile(
                                trailing: Icon(Icons.money,
                                color: Theme.of(context).accentColor,
                                ),
                                title: Text("Total Collect",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                ),
                                ),
                                subtitle: Text(
                                    model.chargeSummaryTotalPostpaid
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          destCurrency(model),
                          currencyConversionRates(model),
                          ccChargesInDestCurrency(model),
                          chargesAtDestination(model),
                          totalCollectCharges(model),
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

  destCurrency(model) {
    destCurrencyCode.text = model.destCurrencyCode;
    return Container(
        margin: EdgeInsets.all(10.0),
        child: TypeAheadFormField<CurrencyCode>(
            suggestionsCallback: CurrencyAPI.getCurrencyCode,
            itemBuilder: (context, CurrencyCode suggestion) {
              final code = suggestion;
              return ListTile(
                title: Text(code.currencyCode),
                subtitle: Text(code.currencyName),
              );
            },
            validator: (value) {
              if (value.isEmpty) {
                return
                    S.of(context).SelectacurrencyName;

                  //'Select a currency Name';
              }
              return null;
            },
            textFieldConfiguration: TextFieldConfiguration(
              autofocus: false,
              controller: this.destCurrencyCode,
              inputFormatters: [AllCapitalCase()],
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
                      //   color: Colors.deepPurple
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  // border: OutlineInputBorder(
                  //     gapPadding: 2.0,
                  //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).CurrencyCode+" *",
                  //"Currency Code",
                  labelStyle: new TextStyle(
                      color: Theme.of(context).accentColor,
                      // color: Colors.deepPurple,
                      fontSize: 16.0),
                  suffixIcon: Icon(
                    Icons.money,
                    color: Theme.of(context).accentColor,
                    // color: Colors.deepPurple,
                  ),
                prefixText: flag,
                  // 'Destination',
                  ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onSuggestionSelected: (CurrencyCode suggestion) {
              this.destCurrencyCode.text = suggestion.currencyCode;
              model.destCurrencyCode = suggestion.currencyCode;
              //model.chargeSummaryTotalPostpaid
              //to convert originCurrency to USD
              var baseCurrencyExchangeRate = StringData.getCurrencyrate(
                  "USD", model.chargesDeclarationCurrency);
              var toCurrencyExchangeRate =
                  StringData.getCurrencyrate("USD", model.destCurrencyCode);
              double quotedUSDValue, quotedToCurrencyValue;

              if (baseCurrencyExchangeRate != null &&
                  toCurrencyExchangeRate != null) {
                quotedUSDValue =
                    (1.00 * int.tryParse(model.chargeSummaryTotalPostpaid)) /
                        double.tryParse(baseCurrencyExchangeRate);
                quotedToCurrencyValue =
                    (double.tryParse(toCurrencyExchangeRate) * quotedUSDValue) /
                        1.00;
                model.baseCurencyrate = baseCurrencyExchangeRate;
                setState(() {
                  this.ccChargeinDest.text =
                      quotedToCurrencyValue.toString().substring(0, 5);
                  this.destCurrencyRate.text =
                      toCurrencyExchangeRate.toString();
                  model.currencyConversionRates = destCurrencyRate.text;
                  model.ccChargesInDest = ccChargeinDest.text;
                  totalCollectCharge.text =
                      (double.tryParse(model.ccChargesInDest) +
                              double.tryParse(model.chargesAtDest))
                          .toString();
                  int flagOffset = 0x1F1E6;
                  int asciiOffset = 0x41;

                  String country =
                      destCurrencyCode.text;

                  int firstChar = country.codeUnitAt(0) - asciiOffset + flagOffset;
                  int secondChar = country.codeUnitAt(1) - asciiOffset + flagOffset;

                  flag =
                      String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
                });
              }

              print('Rate:${baseCurrencyExchangeRate}');
            })
        // TextFormField(
        //   initialValue: model.chargesDeclarationCurrency,
        //   focusNode: _chargesDeclarationCurrencyFocusNode,
        //   textInputAction: TextInputAction.next,
        //   keyboardType: TextInputType.text,
        //   inputFormatters: [AllCapitalCase()],
        //   onFieldSubmitted: (value) {
        //     _fieldFocusChange(context, _chargesDeclarationCurrencyFocusNode,
        //         _chargesDeclarationCHGSCodeFocusNode);
        //   },
        //   decoration: InputDecoration(
        //     enabledBorder: OutlineInputBorder(
        //         borderSide: new BorderSide(
        //             color: Theme.of(context).accentColor,
        //           //color: Colors.deepPurple,
        //             width:2),
        //         //gapPadding: 2.0,
        //         borderRadius: BorderRadius.all(Radius.circular(8.0))
        //     ),
        //     focusedBorder: OutlineInputBorder(
        //       borderSide: BorderSide(width: 2,
        //         color: Theme.of(context).accentColor,
        //         // color: Colors.deepPurple
        //       ),
        //       borderRadius: BorderRadius.circular(8.0),
        //     ),
        //     // border: OutlineInputBorder(
        //     //     gapPadding: 2.0,
        //     //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
        //     labelText:
        //         S.of(context).Currency,
        //       labelStyle:
        //       new TextStyle(
        //           color: Theme.of(context).accentColor,
        //         // color: Colors.deepPurple,
        //           fontSize: 16.0),
        //       suffixIcon: Icon(Icons.money,
        //         color: Theme.of(context).accentColor,

        //         // color: Colors.deepPurple,
        //       )
        //     //'Currency',
        //   ),
        //   onChanged: (text) {
        //     model.chargesDeclarationCurrency = text;
        //   },
        // ),
        );
  }

  currencyConversionRates(model) {
    destCurrencyRate.text = model.currencyConversionRates;
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: destCurrencyRate,
        focusNode: _currencyConversionRatesFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _currencyConversionRatesFocusNode,
              _chargesAtDestinationFocusNode);
        },
        decoration: InputDecoration(
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
            labelText: S.of(context).CurrencyConversionRates,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.money,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
            //'Currency Conversion Rates',
            ),
        onChanged: (text) {
          model.currencyConversionRates = text;
        },
      ),
    );
  }

  chargesAtDestination(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.chargesAtDest,
        focusNode: _chargesAtDestinationFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _chargesAtDestinationFocusNode,
              _ccChargesInDestCurrencyFocusNode);
        },
        decoration: InputDecoration(
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
            labelText: S.of(context).ChargesAtDestination,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.money,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
            //'Charges At Destination',
            ),
        onChanged: (text) {
          model.chargesAtDest = text;
          totalCollectCharge.text = (double.tryParse(ccChargeinDest.text) +
                  double.tryParse(model.chargesAtDest))
              .toString();
        },
      ),
    );
  }

  ccChargesInDestCurrency(model) {
    ccChargeinDest.text = model.ccChargesInDest;
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: ccChargeinDest,
        focusNode: _ccChargesInDestCurrencyFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _ccChargesInDestCurrencyFocusNode,
              _totalCollectChargesFocusNode);
        },
        decoration: InputDecoration(
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
            labelText: S.of(context).CCChargesInDestCurrency,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.money,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
            //'CC Charges In Dest. Currency',
            ),
        onChanged: (text) {
          model.ccChargesInDest = text;
        },
      ),
    );
  }

  totalCollectCharges(model) {
    totalCollectCharge.text = model.totalCollect;
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: totalCollectCharge,
        focusNode: _totalCollectChargesFocusNode,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _totalCollectChargesFocusNode.unfocus();
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
            labelText: S.of(context).TotalCollectCharges,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.money,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
            //'Total Collect Charges',
            ),
        onChanged: (text) {
          model.totalCollect = text;
        },
      ),
    );
  }
}
