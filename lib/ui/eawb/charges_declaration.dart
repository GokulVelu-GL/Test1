import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:rooster/formatter.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/string.dart';
import 'package:rooster/ui/drodowns/airport_code.dart';
import 'package:rooster/ui/eawb/static/custom_background.dart';
import 'package:rooster/ui/eawb/handling_information.dart';
import 'package:rooster/ui/eawb/optional_shipping_information.dart';

class ChargesDeclaration extends StatefulWidget {
  ChargesDeclaration({Key key}) : super(key: key);

  @override
  _ChargesDeclarationState createState() => _ChargesDeclarationState();
}

class _ChargesDeclarationState extends State<ChargesDeclaration> {
  final _chargesDeclarationFormKey = GlobalKey<FormState>();
  String flag;

  FocusNode _chargesDeclarationCurrencyFocusNode = FocusNode();
  FocusNode _chargesDeclarationCHGSCodeFocusNode = FocusNode();
  FocusNode _chargesDeclarationValueForCarriageFocusNode = FocusNode();
  FocusNode _chargesDeclarationValueForCustomsFocusNode = FocusNode();
  FocusNode _chargesDeclarationAmountOfInsuranceFocusNode = FocusNode();

  List<bool> _wtValChargesSelected = List.generate(2, (_) => false);
  List<bool> _otherChargesSelected = List.generate(2, (_) => false);
  TextEditingController currecyCodeController = new TextEditingController();
  TextEditingController chargeCodeController = new TextEditingController();
  TextEditingController valueofCarriage = new TextEditingController();
  TextEditingController valueofCustom = new TextEditingController();
  TextEditingController valueofInsurence = new TextEditingController();

  List<String> fields = ["PPD", "COLL"];
  String CHGSCodeDescription = "";
  var _currencies = [
    "CC",
    "CZ",
    "CG",
    "PP",
    "PX",
    "PZ",
    "PG",
    "Salary"
  ];
  var  _currentSelectedValue="CC";

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
                    previous: OptionalShippingInformation(),
                    next: HandlingInformation(),
                    name: S.of(context).Chargesdeclaration,
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
                                            leading: Icon(Icons.code,
                                              color: Theme.of(context).accentColor,
                                            ),
                                            title: Text("Currency Code"),
                                            subtitle: Text("Coded representation of a currency approved by ISO \nExample: AED "),
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            leading: Icon(Icons.code,
                                              color: Theme.of(context).accentColor,
                                            ),
                                            title: Text("Charge Code"),
                                            subtitle: Text("Code identifying a method of payment of charges \nExample: CC"),
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            leading: Icon(Icons.contacts,
                                              color: Theme.of(context).accentColor,
                                            ),
                                            title: Text("Declared Value for Carriage"),
                                            subtitle: Text("The value of a shipment declared for carriage purposes\nExample: 99 or No Value Declared(NVD)"),
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            leading: Icon(Icons.dashboard_customize,
                                              color: Theme.of(context).accentColor,
                                            ),
                                            title: Text("Declared Value for Customs"),
                                            subtitle: Text("The value of a shipment for Customs purposes \nExample: 120 or No Customs Value (NCV)"),
                                          ),
                                        ),  Card(
                                          child: ListTile(
                                            leading: Icon(Icons.dashboard_customize,
                                              color: Theme.of(context).accentColor,
                                            ),
                                            title: Text("Amount of Insurance"),
                                            subtitle: Text("The value of a shipment for insurance purposes\nExample: 1000.00"),
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
                    //"Charges Declaration",
                    child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: _chargesDeclarationFormKey,
                            child: SingleChildScrollView(
                                child: Column(
                              children: <Widget>[
                                IconButton(onPressed: (){
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title:  Center(
                                        child: Text("Charge Code Description",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Card(
                                              child: ListTile(
                                                title: Text("CC",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                ),
                                                subtitle: Text("All Charges Collect",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                ),
                                              ),
                                            ), Card(
                                              child: ListTile(
                                                title: Text("CZ",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                ),
                                                subtitle: Text("All Charges Collect by Credit Card",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ), Card(
                                              child: ListTile(
                                                title: Text("CG",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                ),
                                                subtitle: Text("All Charges Collect by GBL",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  // textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ), Card(
                                              child: ListTile(
                                                title: Text("PP",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                ),
                                                subtitle: Text("All Charges Prepaid Cash",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                ),
                                              ),
                                            ), Card(
                                              child: ListTile(
                                                title: Text("PX",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("All Charges Prepaid Credit",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ), Card(
                                              child: ListTile(
                                                title: Text("PZ",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("All Charges Prepaid by Credit Card",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),
                                            Card(
                                              child: ListTile(
                                                title: Text("PG",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("All Charges Prepaid by GBL",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),
                                            Card(
                                              child: ListTile(
                                                title: Text("CP",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("Destination Collect Cash",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),  Card(
                                              child: ListTile(
                                                title: Text("CX",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("Destination Collect Credit",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),  Card(
                                              child: ListTile(
                                                title: Text("CM",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("Destination Collect by MCO",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ), Card(
                                              child: ListTile(
                                                title: Text("NC",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("No Charge",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ), Card(
                                              child: ListTile(
                                                title: Text("NT",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("No Weight Charge — Other Charges Collect",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),
                                            Card(
                                              child: ListTile(
                                                title: Text("NZ",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("No Weight Charge — Other Charges Prepaid by Credit Card",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),
                                            Card(
                                              child: ListTile(
                                                title: Text("NG",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("No Weight Charge — Other Charges Prepaid by GBL",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),
                                            Card(
                                              child: ListTile(
                                                title: Text("NP",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("No Weight Charge — Other Charges Prepaid Cash",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),    Card(
                                              child: ListTile(
                                                title: Text("NX",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("No Weight Charge — Other Charges Prepaid Credit",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),
                                            Card(
                                              child: ListTile(
                                                title: Text("CA",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("Partial Collect Credit — Partial Prepaid Cash",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ), Card(
                                              child: ListTile(
                                                title: Text("CB",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("Partial Collect Credit — Partial Prepaid Credit",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            )
                                            ,Card(
                                              child: ListTile(
                                                title: Text("CE",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("Partial Collect Credit Card — Partial Prepaid Cash",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),Card(
                                              child: ListTile(
                                                title: Text("CH",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("Partial Collect Credit Card — Partial Prepaid Credit",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),Card(
                                              child: ListTile(
                                                title: Text("PC",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("Partial Prepaid Cash — Partial Collect Cash",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),Card(
                                              child: ListTile(
                                                title: Text("PD",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("Partial Prepaid Credit — Partial Collect Cash",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),Card(
                                              child: ListTile(
                                                title: Text("PH",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("Partial Prepaid Credit Card — Partial Collect Credit",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),Card(
                                              child: ListTile(
                                                title: Text("PE",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("Partial Prepaid Credit Card — Partial Collect Cash",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),
                                            Card(
                                              child: ListTile(
                                                title: Text("PF",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),),
                                                subtitle: Text("Partial Prepaid Credit Card — Partial Collect Credit Card",
                                                  style: TextStyle(
                                                      color: Theme.of(context).accentColor
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        Center(
                                          child: TextButton(

                                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor),

                                            ),
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: Text("Close",
                                              style: TextStyle(
                                                  color: Theme.of(context).backgroundColor
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }, icon: Icon(Icons.help,
                                  color: Theme.of(context).accentColor,
                                )),
                                currency(model),
                                chgsCode(model),

                                declaredValueForCarriage(model),
                                declaredValueForCustoms(model),
                                declaredAmountOfInsurance(model),
                                wtValCharges(model),
                                otherCharges(model)
                              ],
                            )),
                          ),
                        )),
                  ),
                ),
              ),
            ));
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  currency(model) {
    currecyCodeController.text = model.chargesDeclarationCurrency;
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
                  S.of(context).Selectacurrencycode;
                  //'Select a currency code';
              }
              return null;
            },
            textFieldConfiguration: TextFieldConfiguration(
              autofocus: false,
              focusNode: _chargesDeclarationCurrencyFocusNode,
              controller: this.currecyCodeController,
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
                      gapPadding: 2.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  // border: OutlineInputBorder(
                  //     gapPadding: 2.0,
                  //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).CurrencyCode+" *",
                  prefixText: flag,
                  //"Currency Code",
                  labelStyle: new TextStyle(
                      color: Theme.of(context).accentColor,
                      // color: Colors.deepPurple,
                      fontSize: 16.0),
                  suffixIcon: Icon(
                    Icons.money,
                    size: 15,
                    color: Theme.of(context).accentColor,
                    // color: Colors.deepPurple,
                  )
                  // 'Destination',
                  ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onSuggestionSelected: (CurrencyCode suggestion) {
              this.currecyCodeController.text = suggestion.currencyCode;
              model.chargesDeclarationCurrency = suggestion.currencyCode;
              setState(() {
                int flagOffset = 0x1F1E6;
                int asciiOffset = 0x41;

                String country =
                    currecyCodeController.text;
                int firstChar = country.codeUnitAt(0) - asciiOffset + flagOffset;
                int secondChar = country.codeUnitAt(1) - asciiOffset + flagOffset;

                flag =
                    String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
              });

              //print(destination);
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

  chgsCode(model) {

    chargeCodeController.text=model.chargesDeclarationCHGSCode;
    print('Currency Code ${StringData.currencyCode}');
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TypeAheadField<CHGC>(
          suggestionsCallback: CHGSCApi.getCHGSType,
          itemBuilder: (context, CHGC suggestion) {
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
            controller: chargeCodeController,
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
                labelText: "CHGS Code",
                suffixText: CHGSCodeDescription,
                //S.of(context).Origin,
                labelStyle:
                TextStyle(color: Theme.of(context).accentColor)
              //'Origin',
            ),
          ),
          onSuggestionSelected: (CHGC suggestion) {

            // sippercontactList[index]['Shipper_Contact_Type'] =
            //     suggestion.contactCode;
            setState(() {
              chargeCodeController.text = suggestion.abbrcode;
              CHGSCodeDescription= suggestion.meaning;
              model.chargesDeclarationCHGSCode=suggestion.abbrcode;

            });
            //_fhlModel.houseDetailsOrigin = suggestion.airportCode;
            //
          }),
    );

    //   Container(
    //   margin: EdgeInsets.all(10.0),
    //   child: FormField<String>(
    //     builder: (FormFieldState<String> state) {
    //       return InputDecorator(
    //         decoration: InputDecoration(
    //
    //             // labelStyle: textStyle,
    //             errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
    //             hintText: 'Please select expense',
    //             enabledBorder: OutlineInputBorder(
    //             borderSide: new BorderSide(
    //             color: Theme.of(context).accentColor,
    //             // color: Colors.deepPurple,
    //             width: 2
    //             ),
    //             //gapPadding: 2.0,
    //             borderRadius: BorderRadius.all(Radius.circular(8.0))),
    //             focusedBorder: OutlineInputBorder(
    //             borderSide: BorderSide(
    //             width: 2,
    //             color: Theme.of(context).accentColor,
    //             // color: Colors.deepPurple
    //             ),
    //             borderRadius: BorderRadius.circular(8.0),
    //             ),
    //             // border: OutlineInputBorder(
    //             //     gapPadding: 2.0,
    //             //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
    //             labelText:
    //             S.of(context).CHGSCode,
    //             //S.of(context).DeclaredValueforCarriage,
    //             labelStyle: new TextStyle(
    //             color: Theme.of(context).accentColor,
    //       //color: Colors.deepPurple,
    //       fontSize: 16.0),
    //       suffixIcon: Icon(
    //       Icons.money,
    //       color: Theme.of(context).accentColor,
    //       // color: Colors.deepPurple,
    //       ),
    //         ),
    //
    //             // border: OutlineInputBorder(
    //             //
    //             //     borderRadius: BorderRadius.circular(5.0))),
    //         isEmpty: _currentSelectedValue == '',
    //         child: DropdownButtonHideUnderline(
    //           child: DropdownButton<String>(
    //             value: _currentSelectedValue,
    //             isDense: true,
    //             onChanged: (String newValue) {
    //               setState(() {
    //                 _currentSelectedValue = newValue;
    //                 model.chargesDeclarationCHGSCode=newValue;
    //             //    state.didChange(newValue);
    //               });
    //             },
    //             items: _currencies.map((String value) {
    //               return DropdownMenuItem<String>(
    //                 value: value,
    //                 child: Text(value),
    //               );
    //             }).toList(),
    //           ),
    //         ),
    //       );
    //     },
    //
    //   ),
    // );

  }

  declaredValueForCarriage(model) {
    if (model.chargesDeclarationValueForCarriage.toString().isEmpty ||
        model.chargesDeclarationValueForCarriage == null) {
      valueofCarriage.text = "NVD";
    } else {
      valueofCarriage.text =
          model.chargesDeclarationValueForCarriage.toString();
    }

    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        //initialValue: model.chargesDeclarationValueForCarriage,
        controller: valueofCarriage,
        focusNode: _chargesDeclarationValueForCarriageFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          if (value.isEmpty || value == null) {
            setState(() {
              valueofCarriage.text = "NVD";
              print("validatore");
            });
          }
          _fieldFocusChange(
              context,
              _chargesDeclarationValueForCarriageFocusNode,
              _chargesDeclarationValueForCustomsFocusNode);
        },
        validator: (value) {
          if (value.isEmpty || value == null) {
            setState(() {
              valueofCarriage.text = "NVD";
              print("validatore");
            });
          }
          return null;
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
            labelText: S.of(context).DeclaredValueforCarriage,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.contacts,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
            //'Declared Value for carriage',
            ),
        onChanged: (text) {
          // if (text.isEmpty || text == null) {
          //   setState(() {
          //     valueofCarriage.text = "NVD";
          //   });
          // }

          model.chargesDeclarationValueForCarriage = valueofCarriage.text;
        },
        onSaved: (text) {
          if (text.isEmpty || text == null) {
            setState(() {
              valueofCarriage.text = "NVD";
            });
          }

          model.chargesDeclarationValueForCarriage = valueofCarriage.text;
        },
      ),
    );
  }

  declaredValueForCustoms(model) {
    if (model.chargesDeclarationValueForCustoms.toString().isEmpty ||
        model.chargesDeclarationValueForCustoms == null) {
      valueofCustom.text = "NCV";
    } else {
      valueofCustom.text = model.chargesDeclarationValueForCustoms.toString();
    }
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        //initialValue: model.chargesDeclarationValueForCustoms,
        controller: valueofCustom,
        focusNode: _chargesDeclarationValueForCustomsFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          if (value.isEmpty || value == null) {
            setState(() {
              valueofCustom.text = "NCV";
              print("validatore");
            });
          }
          _fieldFocusChange(
              context,
              _chargesDeclarationValueForCustomsFocusNode,
              _chargesDeclarationAmountOfInsuranceFocusNode);
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
                //color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).DeclaredValueforCustoms,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.dashboard_customize,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
            //'Declared Value for customs',
            ),
        onChanged: (text) {
          // if (text.isEmpty || text == null) {
          //   model.chargesDeclarationValueForCustoms = "NCV";
          // }
          model.chargesDeclarationValueForCustoms = valueofCustom.text;
        },
        onSaved: (text) {
          if (text.isEmpty || text == null) {
            setState(() {
              valueofCustom.text = "NCV";
            });
          }

          model.chargesDeclarationValueForCustoms = valueofCustom.text;
        },
      ),
    );
  }

  declaredAmountOfInsurance(model) {
    if (model.chargesDeclarationAmountOfInsurance.toString().isEmpty ||
        model.chargesDeclarationAmountOfInsurance == null) {
      model.chargesDeclarationAmountOfInsurance = "XXX";
      valueofInsurence.text = "XXX";
    } else {
      valueofInsurence.text =
          model.chargesDeclarationAmountOfInsurance.toString();
    }
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        // initialValue: model.chargesDeclarationAmountOfInsurance.toString() == ""
        //     ? "XXX"
        //     : model.chargesDeclarationAmountOfInsurance,
        controller: valueofInsurence,
        focusNode: _chargesDeclarationAmountOfInsuranceFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          if (value.isEmpty || value == null) {
            setState(() {
              valueofInsurence.text = "XXX";
              print("validatore");
            });
          }
          _chargesDeclarationAmountOfInsuranceFocusNode.unfocus();
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
                //color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).DeclaredAmountofInsurance,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.dashboard_customize,
              color: Theme.of(context).accentColor,
              //color: Colors.deepPurple,
            )
            //'Declared Amount of Insurance',
            ),
        onChanged: (text) {
          // if (text.isEmpty || text == null) {
          //   model.chargesDeclarationAmountOfInsurance = "XXX";
          // }
          model.chargesDeclarationAmountOfInsurance = valueofInsurence.text;
        },
        onSaved: (text) {
          if (text.isEmpty || text == null) {
            setState(() {
              valueofInsurence.text = "XXX";
            });
          }

          model.chargesDeclarationAmountOfInsurance = valueofInsurence.text;
        },
      ),
    );
  }

  wtValCharges(EAWBModel model) {
    if (model.chargesDeclarationWTVALCharges != "") {
      if (model.chargesDeclarationWTVALCharges == "PPD") {
        _wtValChargesSelected[0] = true;
      } else {
        _wtValChargesSelected[1] = true;
      }
    }
    return Container(
        margin: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              S.of(context).WTVALCharges,
              //"WT/VAL Charges"

              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  //color: Colors.deepPurple,
                  fontWeight: FontWeight.w500,
                  fontSize: 17.0),
            ),
            ToggleButtons(
                children: List.generate(fields.length, (index) {
                  return Text(
                    fields[index],
                    style: TextStyle(fontWeight: FontWeight.w500),
                  );
                }),
                borderWidth: 2,
                color: Theme.of(context).primaryColor,
                borderColor: Theme.of(context).accentColor,
                fillColor: Theme.of(context).accentColor,
                selectedColor: Colors.white,
                selectedBorderColor: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(5.0),
                onPressed: (int index) {
                  setState(() {
                    _wtValChargesSelected[index % 2] =
                        !_wtValChargesSelected[index % 2];
                    _wtValChargesSelected[(index + 1) % 2] =
                        !_wtValChargesSelected[index % 2];
                    model.chargesDeclarationWTVALCharges = fields[
                        _wtValChargesSelected[index] ? index : (index + 1) % 2];
                    //swap prepaid and collect

                    if(model.chargesDeclarationWTVALCharges =="PPD"){
                      int totalppostpaid=0;
                      int totalpprepaid=0;
                      model.chargeSummaryWeightChargePrepaid=
                          model.chargeSummaryWeightChargePostpaid;

                      totalpprepaid=
                          int.parse(model.chargeSummaryWeightChargePrepaid)+
                          int.parse(model.chargeSummaryValuationChargePrepaid)+
                          int.parse(model.chargeSummaryTaxPrepaid)+
                              (int.parse(model.chargeSummaryDueAgentPrepaid)+
                          int.parse(model.chargeSummaryDueCarrierPrepaid));

                      model.chargeSummaryTotalPrepaid=totalpprepaid.toString();
                          //(int.parse(model.chargeSummaryWeightChargePrepaid)).toString();
                      model.chargeSummaryWeightChargePostpaid="0";
                      totalppostpaid=
                          int.parse(model.chargeSummaryWeightChargePostpaid)+
                              int.parse(model.chargeSummaryValuationChargePostpaid)+
                              int.parse(model.chargeSummaryTaxPostpaid)+
                              int.parse(model.chargeSummaryDueAgentPostpaid)+
                              int.parse(model.chargeSummaryDueCarrierPostpaid);

                      model.chargeSummaryTotalPostpaid=totalppostpaid.toString();

                    }
                    if(model.chargesDeclarationWTVALCharges =="COLL"){
                      int totalppostpaid=0;
                      int totalprepaid=0;
                      model.chargeSummaryWeightChargePostpaid=model.chargeSummaryWeightChargePrepaid;

                      print("Weight:"+model.chargeSummaryWeightChargePostpaid);
                      print("Tax:"+model.chargeSummaryTaxPostpaid);
                      print("due agent:"+model.chargeSummaryDueAgentPostpaid);
                      print("due carier:"+model.chargeSummaryDueCarrierPostpaid);

                      totalppostpaid=
                          int.parse(model.chargeSummaryWeightChargePostpaid)+
                      int.parse(model.chargeSummaryValuationChargePostpaid)+
                      int.parse(model.chargeSummaryTaxPostpaid)+
                      int.parse(model.chargeSummaryDueAgentPostpaid)+
                      int.parse(model.chargeSummaryDueCarrierPostpaid);

                      model.chargeSummaryTotalPostpaid=totalppostpaid.toString();
                      model.chargeSummaryWeightChargePrepaid="0";
                      totalprepaid=
                          int.parse(model.chargeSummaryWeightChargePrepaid)+
                              int.parse(model.chargeSummaryValuationChargePrepaid)+
                              int.parse(model.chargeSummaryTaxPrepaid)+
                              int.parse(model.chargeSummaryDueAgentPrepaid)+
                              int.parse(model.chargeSummaryDueCarrierPrepaid);
                      model.chargeSummaryTotalPrepaid=totalprepaid.toString();

                    }

                  });
                },
                isSelected: _wtValChargesSelected)
          ],
        ));
  }

  otherCharges(EAWBModel model) {
    if (model.chargesDeclarationOtherCharges != "") {
      if (model.chargesDeclarationOtherCharges == "PPD") {
        _otherChargesSelected[0] = true;
      } else {
        _otherChargesSelected[1] = true;
      }
    }
    return Container(
        margin: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              S.of(context).OtherCharges,
              // "Other Charges",
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  //  color: Colors.deepPurple,
                  fontWeight: FontWeight.w500,
                  fontSize: 17.0),
            ),
            ToggleButtons(
                children: List.generate(fields.length, (index) {
                  return Text(
                    fields[index],
                    style: TextStyle(fontWeight: FontWeight.w500),
                  );
                }),
                borderWidth: 2,
                color: Theme.of(context).primaryColor,
                borderColor: Theme.of(context).accentColor,
                fillColor: Theme.of(context).accentColor,
                selectedColor: Colors.white,
                selectedBorderColor: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(5.0),
                onPressed: (int index) {
                  setState(() {
                    _otherChargesSelected[index % 2] =
                        !_otherChargesSelected[index % 2];
                    _otherChargesSelected[(index + 1) % 2] =
                        !_otherChargesSelected[index % 2];
                    model.chargesDeclarationOtherCharges = fields[
                        _otherChargesSelected[index] ? index : (index + 1) % 2];
                    //  ! Swap of prepaid and collect....
                    if (model.chargesDeclarationOtherCharges == 'PPD') {
                      int TotalPrePaidppd=0;
                      int TotalPostPaidcoll=0;
                      model.chargeSummaryDueAgentPrepaid =
                          model.chargeSummaryDueAgentPostpaid;

                      model.chargeSummaryDueCarrierPrepaid =
                          model.chargeSummaryDueCarrierPostpaid;
                      TotalPrePaidppd = int.parse( model.chargeSummaryTotalPrepaid.toString())+ int.parse( model.chargeSummaryDueAgentPrepaid.toString())+ int.parse( model.chargeSummaryDueCarrierPrepaid.toString());
                      model.chargeSummaryTotalPrepaid = TotalPrePaidppd.toString();
    //if(model.chargeSummaryDueCarrierPostpaid=="0") {
      TotalPostPaidcoll =
         // TotalPrepaid =
          int.parse(model.chargeSummaryWeightChargePostpaid)+ int.parse(model.chargeSummaryValuationChargePostpaid)+int.parse(model.chargeSummaryTaxPostpaid);
          // int.parse(model.chargeSummaryTotalPostpaid.toString()) -
          //     int.parse(model.chargeSummaryDueAgentPrepaid.toString()) -
          //     int.parse(model.chargeSummaryDueCarrierPrepaid.toString());

      model.chargeSummaryTotalPostpaid = TotalPostPaidcoll.toString();
      //     model.chargeSummaryTotalPrepaid ;
      model.chargeSummaryDueAgentPostpaid = '0';
      model.chargeSummaryDueCarrierPostpaid = '0';
   // }
                      // model.chargeSummaryTotalPostpaid = '0';
                    } else {
                      // if(model.chargeSummaryDueAgentPostpaid=="0"){
                      //   model.chargeSummaryTotalPostpaid =
                      //       (int.parse(model.chargeSummaryTotalPostpaid)   +
                      //   int.parse(model.chargeSummaryTotalPrepaid)).toString();
                      // }
                      int TotalPrepaid=0;
                       int TotalPostPaid=0;
                      model.chargeSummaryDueAgentPostpaid =
                          model.chargeSummaryDueAgentPrepaid;

                      model.chargeSummaryDueCarrierPostpaid =
                          //TotalPostPaid.toString();
                        model.chargeSummaryDueCarrierPrepaid;

                        TotalPostPaid = int.parse(
                            model.chargeSummaryTotalPostpaid.toString()) +
                            int.parse(
                                model.chargeSummaryDueAgentPrepaid.toString()) +
                            int.parse(model.chargeSummaryDueCarrierPrepaid
                                .toString());
                        model.chargeSummaryTotalPostpaid =
                            TotalPostPaid.toString();

                    //   model.chargeSummaryTotalPrepaid =model.chargeSummaryTotalPrepaid;
                      // (int.parse(model.chargeSummaryTotalPrepaid)+20).toString();
                          //(
    // if(model.chargeSummaryDueCarrierPrepaid=="0") {
      TotalPrepaid =
      int.parse(model.chargeSummaryWeightChargePrepaid)
          + int.parse(model.chargeSummaryValuationChargePrepaid)+int.parse(model.chargeSummaryTaxPrepaid);
          // int.parse(model.chargeSummaryTotalPrepaid) -
          // int.parse(model.chargeSummaryDueAgentPrepaid) -
          // int.parse(model.chargeSummaryDueCarrierPrepaid);
      //).toString();
      print(TotalPrepaid.toString());
      model.chargeSummaryTotalPrepaid = TotalPrepaid.toString();
      model.chargeSummaryDueAgentPrepaid = '0';
      model.chargeSummaryDueCarrierPrepaid = '0';
   // }
                    }
                  });
                },
                isSelected: _otherChargesSelected)
          ],
        ));
  }
}
