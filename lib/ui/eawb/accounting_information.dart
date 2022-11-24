import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:rooster/formatter.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/ui/eawb/static/custom_background.dart';
import 'package:rooster/ui/eawb/issuer.dart';
import 'package:rooster/ui/eawb/optional_shipping_information.dart';

import '../drodowns/AccId_code.dart';

class AccountingInformation extends StatefulWidget {
  AccountingInformation({Key key}) : super(key: key);

  @override
  _AccountingInformationState createState() => _AccountingInformationState();
}

class _AccountingInformationState extends State<AccountingInformation> {
  var groupid = [
    "CRN",
    "CRD",
    "CRI",
    "GEN",
    "GBL",
    "MCO",
    "STL",
    "RET",
    "SRN"
  ];
  String AccountIdDescription="";

  var  acc_id;


  final _accountingInformationFormKey = GlobalKey<FormState>();

  FocusNode _accountingInformationByFocusNode = FocusNode();

  int _accountingInformationMaxLineCount;

   TextEditingController AccIdController = TextEditingController();



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
              previous: Issuer(),
              next: OptionalShippingInformation(),
              name:
              S.of(context).Accountinginformation,
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
                                      leading: Icon(Icons.insert_drive_file,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Account Id"),
                                      subtitle: Text("Coded identification of a participant\nExample: AAA"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.details,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Details"),
                                      subtitle: Text("Detail of accounting information\nExample: PAYMENT BY CERTIFIED CHEQUE"),
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
              //"Accounting Information",
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Form(
                    key: _accountingInformationFormKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          IconButton(onPressed: (){
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title:  Center(
                                  child: Text("Account id Dropdown",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Card(
                                        child: ListTile(
                                          title: Text("CRN",
                                            style: TextStyle(
                                                color: Theme.of(context).accentColor
                                            ),
                                          ),
                                          subtitle: Text("Credit Card Number (see GEN6)",
                                            style: TextStyle(
                                                color: Theme.of(context).accentColor
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                      Card(
                                        child: ListTile(
                                          title: Text("CRD",
                                            style: TextStyle(
                                                color: Theme.of(context).accentColor
                                            ),
                                          ),
                                          subtitle: Text("Credit Card Expiry Date",
                                            style: TextStyle(
                                                color: Theme.of(context).accentColor
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                      Card(
                                        child: ListTile(
                                          title: Text("CRI",
                                            style: TextStyle(
                                                color: Theme.of(context).accentColor
                                            ),
                                          ),
                                          subtitle: Text("Credit Card Issuance Name (Name Shown on the Credit Card)",
                                            style: TextStyle(
                                                color: Theme.of(context).accentColor
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                      Card(
                                        child: ListTile(
                                          title: Text("GEN",
                                            style: TextStyle(
                                                color: Theme.of(context).accentColor
                                            ),
                                          ),
                                          subtitle: Text("General Information",
                                            style: TextStyle(
                                                color: Theme.of(context).accentColor
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                      Card(
                                        child: ListTile(
                                          title: Text("GBL",
                                            style: TextStyle(
                                                color: Theme.of(context).accentColor
                                            ),
                                          ),
                                          subtitle: Text("Government Bill of Lading",
                                            style: TextStyle(
                                                color: Theme.of(context).accentColor
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                      Card(
                                        child: ListTile(
                                          title: Text("STL",
                                            style: TextStyle(
                                                color: Theme.of(context).accentColor
                                            ),
                                          ),
                                          subtitle: Text("Mode of Settlement",
                                            style: TextStyle(
                                                color: Theme.of(context).accentColor
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                      Card(
                                        child: ListTile(
                                          title: Text("RET",
                                            style: TextStyle(
                                                color: Theme.of(context).accentColor
                                            ),
                                          ),
                                          subtitle: Text("Return to Origin",
                                            style: TextStyle(
                                                color: Theme.of(context).accentColor
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                      Card(
                                        child: ListTile(
                                          title: Text("SRN",
                                            style: TextStyle(
                                                color: Theme.of(context).accentColor
                                            ),
                                          ),
                                          subtitle: Text("Shipper’s Reference Number",
                                            style: TextStyle(
                                                color: Theme.of(context).accentColor
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
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
                          accountingInformationId(model),
                          accountingInformationBy(model)
                        ],
                      )
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

  accountingInformationBy(EAWBModel model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        maxLines: _accountingInformationMaxLineCount,
        initialValue: model.accountingInformationDetails,
        focusNode: _accountingInformationByFocusNode,
        textInputAction: TextInputAction.newline,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _accountingInformationMaxLineCount =
              _accountingInformationMaxLineCount + 1;
        },
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,
                  // color: Colors.deepPurple,
                    width:2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(8.0))
            ),
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
          labelText:
          S.of(context).Details,
            labelStyle:
            new TextStyle(
                color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(Icons.details,
              color: Theme.of(context).accentColor,
             // color: Colors.deepPurple,
            )
          //'Details',
        ),
        onChanged: (text) {
          setState(() {
            model.accountingInformationDetails = text;
          });
        },
      ),
    );
  }

  accountingInformationId(EAWBModel model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TypeAheadField<AccId>(
          suggestionsCallback: AccIdCodeApi.getAccIdCode,
          itemBuilder: (context, AccId suggestion) {
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

           controller: AccIdController,
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
                suffixText: AccountIdDescription,
                labelText: "Account Id",
    suffixIcon: Icon(
                Icons.contact_page,
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
              ),
                //S.of(context).Origin,
                labelStyle:
                TextStyle(color: Theme.of(context).accentColor)
              //'Origin',
            ),
          ),
          onSuggestionSelected: (AccId suggestion) {
            setState(() {
              AccountIdDescription= suggestion.meaning;
              AccIdController.text = suggestion.abbrcode;
              model.accountingInformationId= suggestion.abbrcode;
            });

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
    //           // labelStyle: textStyle,
    //           errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
    //           hintText: 'Please select expense',
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
    //               // color: Colors.deepPurple
    //             ),
    //             borderRadius: BorderRadius.circular(8.0),
    //           ),
    //           // border: OutlineInputBorder(
    //           //     gapPadding: 2.0,
    //           //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
    //           labelText:
    //           S.of(context).AccountId,
    //           //S.of(context).DeclaredValueforCarriage,
    //           labelStyle: new TextStyle(
    //               color: Theme.of(context).accentColor,
    //               //color: Colors.deepPurple,
    //               fontSize: 16.0),
    //           suffixIcon: Icon(
    //             Icons.money,
    //             color: Theme.of(context).accentColor,
    //             // color: Colors.deepPurple,
    //           ),
    //         ),
    //
    //         // border: OutlineInputBorder(
    //         //
    //         //     borderRadius: BorderRadius.circular(5.0))),
    //         isEmpty: acc_id == '',
    //         child: DropdownButtonHideUnderline(
    //           child: DropdownButton<String>(
    //
    //             value: acc_id,
    //             isDense: true,
    //             onChanged: (String newValue) {
    //               setState(() {
    //                 acc_id = newValue;
    //                 model.accountingInformationId=newValue;
    //                 //    state.didChange(newValue);
    //               });
    //             },
    //             items: groupid.map((String value) {
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




    // return Container(
    //   margin: EdgeInsets.all(10.0),
    //   child: TextFormField(
    //     initialValue: model.accountingInformationId,
    //     textInputAction: TextInputAction.newline,
    //     inputFormatters: [AllCapitalCase()],
    //
    //     decoration: InputDecoration(
    //         enabledBorder: OutlineInputBorder(
    //             borderSide: new BorderSide(
    //                 color: Theme.of(context).accentColor,
    //                 // color: Colors.deepPurple,
    //                 width:2),
    //             //gapPadding: 2.0,
    //             borderRadius: BorderRadius.all(Radius.circular(8.0))
    //         ),
    //         focusedBorder: OutlineInputBorder(
    //           borderSide: BorderSide(width: 2,
    //             color: Theme.of(context).accentColor,
    //             // color: Colors.deepPurple
    //           ),
    //           borderRadius: BorderRadius.circular(8.0),
    //         ),
    //         // border: OutlineInputBorder(
    //         //     gapPadding: 2.0,
    //         //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
    //         labelText:
    //       S.of(context).AccountId,
    //         // "Account Id",
    //         // S.of(context).Details,
    //         labelStyle:
    //         new TextStyle(
    //             color: Theme.of(context).accentColor,
    //             // color: Colors.deepPurple,
    //             fontSize: 16.0),
    //         suffixIcon: Icon(Icons.insert_drive_file,
    //           color: Theme.of(context).accentColor,
    //           // color: Colors.deepPurple,
    //         )
    //       //'Details',
    //     ),
    //     onChanged: (text) {
    //       setState(() {
    //         model.accountingInformationId = text;
    //       });
    //     },
    //   ),
    // );
  }
}
