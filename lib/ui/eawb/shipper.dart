import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:rooster/formatter.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/model/eawb_models/shipper_model.dart';
import 'package:rooster/ui/drodowns/airport_code.dart';
import 'package:rooster/ui/eawb/consignee.dart';
import 'package:rooster/ui/drodowns/country_code.dart';
import 'package:rooster/ui/eawb/static/custom_background.dart';

import 'awb_consignment_details.dart';

class Shipper extends StatefulWidget {
  Shipper({Key key}) : super(key: key);

  @override
  _ShipperState createState() => _ShipperState();
}

class _ShipperState extends State<Shipper> {
  String countrcode;
  String flag;
  final _shipperFormKey = GlobalKey<FormState>();
  //
  List<Map<String, dynamic>> sippercontactList = [];

  FocusNode _shipperAccountNumberFocusNode = FocusNode();
  FocusNode _shipperNameFocusNode = FocusNode();
  FocusNode _shipperPlaceFocusNode = FocusNode();
  FocusNode _shipperAddressFocusNode = FocusNode();
  TextEditingController contype = new TextEditingController();
  TextEditingController Telecontroller = new TextEditingController();
  final _ContactKey = GlobalKey<FormState>();
   List<ShipperExpenseList> expenseList = [];

  int _addressMaxLinesCount;
  final TextEditingController shipperContact = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<EAWBModel>(builder: (context, model, child) {
      return WillPopScope(
        onWillPop: () async {
          model.setStatus();
          expenseList=model.newshipperContactList;
          return true;
        },
        child: Scaffold(
          body: SafeArea(
            child: CustomBackground(
              previous: AwbConsignmentDetails(),
              next: Consignee(),
              name: S.of(context).Shipper,
              help:  IconButton(
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
                                      leading: Icon(Icons.switch_account,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Account Number"),
                                      subtitle: Text("Coded identification of a participant\nExample: ABC94269 "),
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
                                      leading: Icon(Icons.add_location,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Country Code"),
                                      subtitle: Text("Coded representation of a country approved by ISO\nExample: INR"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.my_location,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Address"),
                                      subtitle: Text("Street address of individual or company involved in the movement of a consignment\nExample: WIGMORE STREET"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.place,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("State"),
                                      subtitle: Text("Part of a country of an individual or company involved  in the movement of a consignment\nExample: QUE"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.code,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Post Code"),
                                      subtitle: Text("Code allocated by national postal authority to identify location for mail delivery purposes\nExample: H3A 2R4"),
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
              //"Shipper",
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _shipperFormKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          accountNumber(model),
                          name(model),
                          countryCode(model),
                          address(model),
                          place(model),
                          state(model),
                          postCode(model),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Text(
                                  S.of(context).AddContacts,
                                  // 'Add Contacts',
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CircleAvatar(
                                  backgroundColor: Theme.of(context).accentColor,
                                  radius: 20,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                    onPressed: () {
                                      _showDialogContact(model);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Container(
                            child: Column(
                              children: model.newshipperContactList.map((e) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        color:
                                            Theme.of(context).backgroundColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 8.0,
                                            offset: Offset(0.0, 5.0),
                                          ),
                                        ],
                                      ),
                                      width: 325,
                                      child: ListTile(
                                        leading:e.Shipper_Contact_Type == "Email"? Icon(
                                          Icons.email,
                                          color: Theme.of(context).accentColor,
                                        ):Icon ( Icons.phone,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        title: Text(
                                        (e.Shipper_Contact_Type == "Email")?' ' + '${e.Shipper_Contact_Detail}':'${e.flag}'
                                              + '${e.Shipper_Contact_Detail}',
                                        ),
                                        subtitle: Text('${e.Shipper_Contact_Type}',
                                        ),
                                        trailing: IconButton(
                                          onPressed: () {
                                            return showDialog<void>(
                                              context: context,
                                              barrierDismissible:
                                                  false, // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Center(
                                                      child: Text(
                                                          S.of(context).Delete
                                                          //'Delete'
                                                      )),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text(
                                                          S.of(context).Wouldyouliketodeleteshippercontactnumber
                                                          // 'Would you like to delete shipper contact number'
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text(

                                                       S.of(context).Cancel,
                                                       // 'Cancel',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text(
                                                       S.of(context).Confirm,
                                                        // 'Confirm',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor),
                                                      ),
                                                      onPressed: () {
                                                        Scontactdelete(e
                                                            .Shipper_Contact_Detail,model);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            // Scontactdelete(e.title);
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
                          //   child: Column(
                          //     children: [
                          //       SingleChildScrollView(
                          //         scrollDirection: Axis.horizontal,
                          //         child: Builder(
                          //
                          //           builder: (context) => DataTable(
                          //             dataRowColor: MaterialStateProperty
                          //                 .resolveWith<Color>(
                          //                     (Set<MaterialState> states) {
                          //                   if (states
                          //                       .contains(MaterialState.selected))
                          //                     return Theme.of(context).accentColor.withOpacity(0.5);
                          //                   return null; // Use the default value.
                          //                 }),
                          //             showCheckboxColumn: false,
                          //            // columnSpacing: 15,
                          //             columns: [
                          //               DataColumn(
                          //                   label: Text(
                          //                     S.of(context).Type,
                          //                     style: TextStyle(
                          //                       color: Theme.of(context).accentColor,
                          //                     ),
                          //                     //'Type'
                          //                   )),
                          //               DataColumn(
                          //                   label: Text(
                          //                     S.of(context).ContactNumber,
                          //                     style: TextStyle(
                          //                       color: Theme.of(context).accentColor,
                          //                     ),
                          //                     // 'Contact Number'
                          //                   )),
                          //             ],
                          //             rows: List<DataRow>.generate(
                          //               sippercontactList.length,
                          //                   (index) => newDataRow(index),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
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

  // newDataRow(int dimensionIndex) {
  //   return DataRow(
  //       key: ValueKey(sippercontactList[dimensionIndex]),
  //       // ! Very Important key for Delete the value....
  //       selected: sippercontactList[dimensionIndex]['isSelected'],
  //       onSelectChanged: (value) {
  //         setState(() {
  //           sippercontactList[dimensionIndex]['isSelected'] =
  //               !sippercontactList[dimensionIndex]['isSelected'];
  //         });
  //       },
  //       cells: [
  //         DataCell(
  //           DropdownButton<String>(
  //               icon: Icon(Icons.arrow_drop_down),
  //               value: sippercontactList[dimensionIndex]
  //                   ['Shipper_Contact_Type'],
  //               items: ['Telegram', 'WhatsApp', 'Fax', "Telephone"]
  //                   .map<DropdownMenuItem<String>>((String value) {
  //                 return DropdownMenuItem<String>(
  //                   value: value,
  //                   child: Text(
  //                     value,
  //                     style: TextStyle(
  //                       color: Theme.of(context).accentColor,
  //                     ),
  //                   ),
  //                 );
  //               }).toList(),
  //               onChanged: (String text) {
  //                 setState(() {
  //                   sippercontactList[dimensionIndex]['Shipper_Contact_Type'] =
  //                       text;
  //                 });
  //               }),
  //
  //           //   TextFormField(
  //           //     initialValue:
  //           //         sippercontactList[dimensionIndex]['itentifier'] == ""
  //           //             ? ''
  //           //             : '${sippercontactList[dimensionIndex]['itentifier']}',
  //           //     onChanged: (value) {
  //           //       setState(() {
  //           //         sippercontactList[dimensionIndex]['itentifier'] = value;
  //           //       });
  //           //     },
  //           //     keyboardType: TextInputType.text,
  //           //     // decoration: InputDecoration(
  //           //     //   border: OutlineInputBorder(
  //           //     //       // gapPadding: 2.0,
  //           //     //       // borderRadius: BorderRadius.all(Radius.circular(8.0))
  //           //     //       ),
  //           //     //   labelText: 'Itentifier',
  //           //     // ),
  //           //   ),
  //           // ), // DataColumn(label: Text('Length')
  //         ),
  //         DataCell(IntlPhoneField(
  //           initialValue: sippercontactList[dimensionIndex]
  //                       ['Shipper_Contact_Detail'] ==
  //                   0.0
  //               ? ''
  //               : '${sippercontactList[dimensionIndex]['Shipper_Contact_Detail']}',
  //           onChanged: (value) {
  //             setState(() {
  //               sippercontactList[dimensionIndex]['Shipper_Contact_Detail'] =
  //                   value;
  //             });
  //           },
  //           //controller: ,
  //           decoration: InputDecoration(
  //             enabledBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: Theme.of(context).accentColor),
  //               // borderRadius: BorderRadius.all(Radius.circular(25.0)),
  //             ),
  //             //border: InputBorder.none,
  //             focusedBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: Theme.of(context).accentColor),
  //               // borderRadius: BorderRadius.all(Radius.circular(25.0)),
  //             ),
  //
  //             //decoration for Input Field
  //             labelText:
  //             S.of(context).PhoneNumber,
  //             //'Phone Number',
  //             labelStyle: TextStyle(color: Theme.of(context).accentColor),
  //             border: OutlineInputBorder(
  //               borderSide: BorderSide(),
  //             ),
  //           ),
  //           initialCountryCode: 'IN', //default contry code, NP for Nepal
  //           // onChanged: (phone) {
  //           //   setState(() {
  //           //     initialCountryCode = phone.countryCode as String;
  //           //   });
  //           //   //when phone number country code is changed
  //           //   print(phone.completeNumber); //get complete number
  //           //   print(phone.countryCode); // get country code only
  //           //   print(phone.number); // only phone number
  //           // },
  //         )
  //             // TextFormField(
  //             //   initialValue: sippercontactList[dimensionIndex]
  //             //   ['Shipper_Contact_Detail'] ==
  //             //       0.0
  //             //       ? ''
  //             //       : '${sippercontactList[dimensionIndex]['Shipper_Contact_Detail']}',
  //             //   onChanged: (value) {
  //             //     setState(() {
  //             //       sippercontactList[dimensionIndex]['Shipper_Contact_Detail'] =
  //             //           value;
  //             //     });
  //             //   },
  //             //   keyboardType: TextInputType.number,
  //             //   // decoration: InputDecoration(
  //             //   //   border: OutlineInputBorder(
  //             //   //       // gapPadding: 2.0,
  //             //   //       // borderRadius: BorderRadius.all(Radius.circular(8.0))
  //             //   //       ),
  //             //   //   labelText: 'Number',
  //             //   // ),
  //             // ),
  //             ),
  //       ]);
  // }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  accountNumber(EAWBModel model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.shipperAccountNumber,
        focusNode: _shipperAccountNumberFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        style: TextStyle(
          fontSize: 16,
        ),
        onFieldSubmitted: (value) {
          _fieldFocusChange(
              context, _shipperAccountNumberFocusNode, _shipperNameFocusNode);
        },
        decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,
                    // color: Colors.deepPurple,
                    width: 2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 2, color: Theme.of(context).accentColor
                      // color: Colors.deepPurple
                      ),
              borderRadius: BorderRadius.circular(10),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).AccountNumber,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor
                //  color: Colors.deepPurple
                ,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.switch_account,
              color: Theme.of(context).accentColor
              //  color: Colors.deepPurple
              ,
            )
            //'Account Number',
            ),
        onChanged: (text) {
          model.shipperAccountNumber = text;
        },
      ),
    );
  }

  name(EAWBModel model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.shipperName,
        focusNode: _shipperNameFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        style: TextStyle(
          fontSize: 16,
        ),
        onFieldSubmitted: (value) {
          _fieldFocusChange(
              context, _shipperNameFocusNode, _shipperAddressFocusNode);
        },
        decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,
                    //color: Colors.deepPurple,
                    width: 2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).Name+" *",
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontSize: 16.0),
            //'Name',
            suffixIcon: Icon(
              Icons.contacts_rounded,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )),
        onChanged: (text) {
          // model.setshipperName(text);
          model.shipperName = text;
        },
      ),
    );
  }

  place(EAWBModel model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.shipperPlace,
        focusNode: _shipperPlaceFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontSize: 16,
        ),
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _fieldFocusChange(
              context, _shipperNameFocusNode, _shipperAddressFocusNode);
        },
        decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,
                    //color: Colors.deepPurple,
                    width: 2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).Place,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
                fontSize: 16.0),
            //'Place',
            suffixIcon: Icon(
              Icons.place,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )),
        onChanged: (text) {
          // model.setshipperName(text);
          model.shipperPlace = text;
        },
      ),
    );
  }

  state(EAWBModel model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.shipperState,
        //focusNode: _shipperPlaceFocusNode,
        textInputAction: TextInputAction.next,
        style: TextStyle(
          fontSize: 16,
        ),
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          // _fieldFocusChange(
          //     context, _shipperNameFocusNode, _shipperAddressFocusNode);
        },
        decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor
                    //color: Colors.deepPurple
                    ,
                    width: 2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).accentColor,
                //  color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).State,
            labelStyle: TextStyle(
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
                fontSize: 16.0),
            //'State',
            suffixIcon: Icon(
              Icons.place,
              color: Theme.of(context).accentColor,
              //  color: Colors.deepPurple,
            )),
        onChanged: (text) {
          // model.setshipperName(text);
          model.shipperState = text;
        },
      ),
    );
  }

  postCode(EAWBModel model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.shipperPostCode,
        // focusNode: _shipperPlaceFocusNode,
        maxLength: 6,
        style: TextStyle(
          fontSize: 16,
        ),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,

        onFieldSubmitted: (value) {
          // _fieldFocusChange(
          //     context, _shipperNameFocusNode, _shipperAddressFocusNode);
        },
        decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor
                    //color: Colors.deepPurple
                    ,
                    width: 2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).accentColor,
                //  color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).PostCode,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
                fontSize: 16.0),
            //'Post Code',
            suffixIcon: Icon(
              Icons.code,
              color: Theme.of(context).accentColor,
              //color: Colors.deepPurple,
            )),
        onChanged: (text) {
          // model.setshipperName(text);
          model.shipperPostCode = text;
        },
      ),
    );
  }

  countryCode(EAWBModel model) {
    this.shipperContact.text = model.shipperCountryCode;
    return Container(
      margin: EdgeInsets.all(10.0),

      child: TypeAheadFormField<CountryCode>(
        getImmediateSuggestions: true,
        suggestionsCallback: CountryCodeApi.getCountryCode,
        itemBuilder: (context, CountryCode suggestion) {
          final code = suggestion;
          print(code.countryName);
          return ListTile(
            title: Text(code.countryCode),
            subtitle: Text(code.countryName),
          );
        },
        validator: (value) {
          if (value.isEmpty) {
            return
              S.of(context).Selectacountrycode;
              //'Select a country code';
          }
          return null;
        },

        autovalidateMode: AutovalidateMode.always,
        textFieldConfiguration: TextFieldConfiguration(
          inputFormatters: [AllCapitalCase()],
          controller: this.shipperContact,
          style: TextStyle(
            fontSize: 16,
          ),
          onChanged: (value) {
            if (CountryCodeApi.checkifCountryCode(value) != null) {
              model.shipperCountryCode = this.shipperContact.text;
            }
          },
          decoration: InputDecoration(
              isDense: true,
              enabledBorder: OutlineInputBorder(
                  borderSide: new BorderSide(
                      color: Theme.of(context).accentColor,
                      // color: Colors.deepPurple,
                      width: 2),
                  //gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Theme.of(context).accentColor,
                  //  color: Colors.deepPurple
                ),
                borderRadius: BorderRadius.circular(10),
              ),

              // border: OutlineInputBorder(
              //     gapPadding: 2.0,
              //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText: S.of(context).CountryCode+" *",
              labelStyle: new TextStyle(
                  color: Theme.of(context).accentColor,
                  // color: Colors.deepPurple,
                  fontSize: 16.0),
              //'Country Code',
              suffixIcon: Icon(
                Icons.add_location,
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
              )),
        ),
        suggestionsBoxDecoration: SuggestionsBoxDecoration(elevation: 2.0),
        onSuggestionSelected: (CountryCode suggestion) {
          if (suggestion.countryCode == null &&
              suggestion.countryName == null) {
            return
              S.of(context).WrongAWBNumber;
              //'Worong AWB Number';
          } else {
            this.shipperContact.text = suggestion.countryCode;
            model.shipperCountryCode = suggestion.countryCode;
          }
        },

        // onSuggestionSelected: (CountryCode suggestion) {
        //
        //   this.shipperContact.text = suggestion.countryCode;
        //   model.shipperCountryCode = suggestion.countryCode;
        //   //print(origin);
        // }
      ),
      // child: TextFormField(
      //   initialValue: model.shipperCountryCode,
      //   // focusNode: _shipperPlaceFocusNode,
      //   maxLength: 3,
      //   textInputAction: TextInputAction.next,
      //   //keyboardType: TextInputType.number,

      //   onFieldSubmitted: (value) {
      //     // _fieldFocusChange(
      //     //     context, _shipperNameFocusNode, _shipperAddressFocusNode);
      //   },
      //   decoration: InputDecoration(
      //     border: OutlineInputBorder(
      //         gapPadding: 2.0,
      //         borderRadius: BorderRadius.all(Radius.circular(8.0))),
      //     labelText: 'Country Code',
      //   ),
      //   onChanged: (text) {
      //     // model.setshipperName(text);
      //     model.shipperCountryCode = text;
      //   },
      // ),
    );
  }

  address(EAWBModel model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        maxLines: _addressMaxLinesCount,
        initialValue: model.shipperAddress,
        focusNode: _shipperAddressFocusNode,
        keyboardType: TextInputType.multiline,
        style: TextStyle(
          fontSize: 16,
        ),
        textInputAction: TextInputAction.newline,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _addressMaxLinesCount = _addressMaxLinesCount + 1;
        },
        decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,
                    // color: Colors.deepPurple,
                    width: 2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).Address,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.my_location,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
            //'Address',
            ),
        onChanged: (text) {
          model.shipperAddress = text;
        },
      ),
    );
  }

  void Scontactdelete(String title, EAWBModel model) {
    setState(() {
      // model.newshipperContactList.removeWhere(
      //     ShipperExpenseList(
      //         Shipper_Contact_Type: Telecontroller.text,
      //         Shipper_Contact_Detail: contype.text,
      //         flag:flag
      //     )
      // );
       model.newshipperContactList
          .removeWhere((element) => element.Shipper_Contact_Detail == title);
    });
  }

  Future<String> _showDialogContact(EAWBModel model) => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Stack(children: [
            Text(
           //  S.of(context).AddShipperNumber,
              "Add Shipper Contacts",
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ]),
          content: Form(
            key: _ContactKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TypeAheadField<ContactType>(
                    suggestionsCallback: ContacTypeApi.getContactType,
                    itemBuilder: (context, ContactType suggestion) {
                      final code = suggestion;
                      return ListTile(
                        title: Text(code.contactType,
                            style: TextStyle(
                                color: Theme.of(context).accentColor)),
                        subtitle: Text(code.contactCode,
                            style: TextStyle(
                                color: Theme.of(context).accentColor)),
                      );
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: contype,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          //border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          border: OutlineInputBorder(
                              gapPadding: 2.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          labelText: "Type",
                          //S.of(context).Origin,
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor)
                          //'Origin',
                          ),
                    ),
                    onSuggestionSelected: (ContactType suggestion) {
                      List.generate(
                          sippercontactList.length,
                          (index) => sippercontactList[index]
                          //Shipper_Contact_Type
                                  ['Shipper_Contact_Type']
                          =
                              suggestion.contactType);
                      // sippercontactList[index]['Shipper_Contact_Type'] =
                      //     suggestion.contactCode;
                      contype.text = suggestion.contactType;
                      //_fhlModel.houseDetailsOrigin = suggestion.airportCode;
                      //
                    }),
                SizedBox(
                  height: 10,
                ),
                contype.text == "Email"
                    ? TextFormField
                  (
                        autofocus: true,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            //border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            labelText:
                            S.of(context).EmailId,
                            //"Email",
                            labelStyle:
                                TextStyle(color: Theme.of(context).accentColor),
                            hintText:
                            S.of(context).Enteremail
                            //"Enter the Email"
                        ),
                        controller: Telecontroller,
                        keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty) {
                      return S.of(context).Thisfieldisempty;
                      //"This field is empty";
                    }
                    return value.contains('@') && value.contains('.')
                        ? null
                        : S.of(context).InvalidEmailId;
                    //"Invalid Email Id.";
                  },
                      )
                    : Container(
                        child: IntlPhoneField(
                        //controller: Telecontroller,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor),
                            // borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          ),
                          //border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor),
                            // borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          ),

                          //decoration for Input Field
                          labelText:
                          S.of(context).PhoneNumber,
                          //'Phone Number',
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        initialCountryCode:
                            'IN',
                          //default contry code, NP for Nepal
                        onChanged: (phone) {
                          setState(() {
                            int flagOffset = 0x1F1E6;
                            int asciiOffset = 0x41;

                            String country = phone.countryISOCode;

                            int firstChar = country.codeUnitAt(0) - asciiOffset + flagOffset;
                            int secondChar = country.codeUnitAt(1) - asciiOffset + flagOffset;
                            countrcode=phone.countryISOCode;
                            flag =
                                String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
                            Telecontroller.text =
                                //flag+" "+
                                    phone.completeNumber;
                          });

                          //   //when phone number country code is changed
                          //   print(phone.completeNumber); //get complete number
                          //   print(phone.countryCode); // get country code only
                           // print(phone.number); // only phone number
                        },
                      )),
              ],
            ),
          ),
          actions: [
            TextButton(
                child: Text(

                S.of(context).Cancel,
                  //  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            TextButton(
                onPressed: () {

                  if (_ContactKey.currentState.validate()) {
                    setState(() {
                      model.newshipperContactList.add(
                          ShipperExpenseList(
                              Shipper_Contact_Type:contype.text ,
                              Shipper_Contact_Detail: Telecontroller.text,
                              flag:flag
                          )
                      );
                    });
                    // model.newshipperContactList.addAll(expenseList);
                    print("eAWB CONTACT LIST " +
                        model.newshipperContactList.toString());

                    // addTele(Telecontroller.text, contype.text,flag
                    //     // _Teletype
                    //     //Teletypecontroller.text
                    //     );
                    Navigator.pop(context);
                  }
                  Telecontroller.clear();
                  contype.clear();
                  // Navigator.of(context).pop(Emailcontroller.text);
                  // Emailcontroller.clear();
                },
                child: Text(
                  S.of(context).Submit,
                  //"Submit",
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                )),
          ],
        ),
      );

  void addTele(String TeleNumber, String Tdescription,String flag) {
    final expense = ShipperExpenseList(
      Shipper_Contact_Type: Tdescription,
      Shipper_Contact_Detail: TeleNumber,
      flag:flag
    );
    setState(() {
      expenseList.add(expense);
    });
  }
}
