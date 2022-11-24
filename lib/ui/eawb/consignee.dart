import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/model/eawb_models/consignee_model.dart';
import 'package:rooster/ui/drodowns/airport_code.dart';
import 'package:rooster/ui/eawb/static/custom_background.dart';
import 'package:rooster/ui/eawb/issuing_carriers_agent.dart';
import 'package:rooster/ui/eawb/shipper.dart';

import '../../formatter.dart';
import '../drodowns/country_code.dart';

class Consignee extends StatefulWidget {
  Consignee({Key key}) : super(key: key);

  @override
  _ConsigneeState createState() => _ConsigneeState();
}

class _ConsigneeState extends State<Consignee> {
  final _consigneeFormKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> consigneecontactList = [];

  @override
  void initState() {
    super.initState();
  }

  FocusNode _consigneeAccountNumberFocusNode = FocusNode();
  FocusNode _consigneeNameFocusNode = FocusNode();
  FocusNode _consigneeAddressFocusNode = FocusNode();
  //final List<ExpenseList> expenseList = [];
  final List<ConsigneeExpenseList> expenseL = [];
  TextEditingController Consigneecontype = new TextEditingController();
  TextEditingController Consigneecontact = new TextEditingController();
  final _consigneeContactkey = GlobalKey<FormState>();

  String flag;

  int _addressMaxLinesCount;
  final TextEditingController consigneeContact = TextEditingController();
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
              previous: Shipper(),
              next: IssuingCarriersAgent(),
              name: S.of(context).Consignee,
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
              //"Consignee",
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _consigneeFormKey,
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
                                      _showConsigneeContactDialog(model);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            child: Column(
                              children: model.newconsigneeContactList.map((e) {
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
                                        leading:e.Consignee_Contact_Type == "Email"? Icon(
                                          Icons.email,
                                          color: Theme.of(context).accentColor,
                                        ):Icon ( Icons.phone,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        title: Text(
                                          (e.Consignee_Contact_Type == "Email")?' ' + '${e.Consignee_Contact_Detail}':'${e.flag}'
                                              + '${e.Consignee_Contact_Detail}',
                                        ),
                                        // title: Text(
                                        //   '${e.Consignee_Contact_Detail}',
                                        // ),
                                        subtitle: Text(
                                          '${e.Consignee_Contact_Type}',
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
                                                         S.of(context).Wouldyouliketodeleteconsigneecontactnumber,
                                                          //  'Would you like to delete consignee contact number'
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text(
                                                        S.of(context).Confirm,
                                                        //'Confirm',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor),
                                                      ),
                                                      onPressed: () {
                                                        Consigneecontactdelete(e
                                                            .Consignee_Contact_Type,model);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text(
                                                      S.of(context).Cancel,
                                                        //  'Cancel',
                                                        style: TextStyle(
                                                            color: Theme.of(context).accentColor),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
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
                          //             columnSpacing: 15,
                          //             columns: [
                          //               DataColumn(
                          //                   label: Text(
                          //                     S.of(context).Type,
                          //                     style: TextStyle(
                          //                       color: Theme.of(context).accentColor,
                          //                     ),
                          //                     // 'Type'
                          //                   )),
                          //               DataColumn(
                          //                   label: Text(S.of(context).ContactNumber,
                          //                     style: TextStyle(
                          //                       color: Theme.of(context).accentColor,
                          //                     ),
                          //                     //  'Contact Number'
                          //                   )),
                          //             ],
                          //             rows: List<DataRow>.generate(
                          //               consigneecontactList.length,
                          //                   (index) => newAddConsignee(index),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // )
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

  newAddConsignee(int dimensionIndex) {
    return DataRow(
        key: ValueKey(consigneecontactList[dimensionIndex]),
        // ! Very Important key for Delete the value....
        selected: consigneecontactList[dimensionIndex]['isSelected'],
        onSelectChanged: (value) {
          setState(() {
            consigneecontactList[dimensionIndex]['isSelected'] =
                !consigneecontactList[dimensionIndex]['isSelected'];
          });
        },
        cells: [
          DataCell(DropdownButton<String>(
                  icon: Icon(Icons.arrow_drop_down),
                  value: consigneecontactList[dimensionIndex]
                      ['Consignee_Contact_Type'],
                  items: ['Telegram', 'WhatsApp', 'Fax', "Telephone"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String text) {
                    setState(() {
                      consigneecontactList[dimensionIndex]
                          ['Consignee_Contact_Type'] = text;
                    });
                  })
              // TextFormField(
              //   initialValue:
              //       consigneecontactList[dimensionIndex]['itentifier'] == ""
              //           ? ''
              //           : '${consigneecontactList[dimensionIndex]['itentifier']}',
              //   onChanged: (value) {
              //     setState(() {
              //       consigneecontactList[dimensionIndex]['itentifier'] = value;
              //     });
              //   },
              //   keyboardType: TextInputType.text,
              // ),
              ), // DataColumn(label: Text('Length')),
          DataCell(IntlPhoneField(
            initialValue: consigneecontactList[dimensionIndex]
                        ['Consignee_Contact_Detail'] ==
                    0.0
                ? ''
                : '${consigneecontactList[dimensionIndex]['Consignee_Contact_Detail']}',
            onChanged: (value) {
              setState(() {
                consigneecontactList[dimensionIndex]
                    ['Consignee_Contact_Detail'] = value;
              });
            },
            //controller: ,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
                // borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
                // borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),

              //decoration for Input Field
              labelText:
              S.of(context).PhoneNumber,
              //'Phone Number',
              labelStyle: TextStyle(color: Theme.of(context).accentColor),
              border: OutlineInputBorder(
                borderSide: BorderSide(),
              ),
            ),
            initialCountryCode: 'IN', //default contry code, NP for Nepal
            // onChanged: (phone) {
            //   setState(() {
            //     initialCountryCode = phone.countryCode as String;
            //   });
            //   //when phone number country code is changed
            //   print(phone.completeNumber); //get complete number
            //   print(phone.countryCode); // get country code only
            //   print(phone.number); // only phone number
            // },
          )
              // TextFormField(
              //   initialValue: consigneecontactList[dimensionIndex]
              //   ['Consignee_Contact_Detail'] ==
              //       0.0
              //       ? ''
              //       : '${consigneecontactList[dimensionIndex]['Consignee_Contact_Detail']}',
              //   onChanged: (value) {
              //     setState(() {
              //       consigneecontactList[dimensionIndex]
              //       ['Consignee_Contact_Detail'] = value;
              //     });
              //   },
              //   keyboardType: TextInputType.number,
              // ),
              ),
        ]);
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  accountNumber(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.consigneeAccountNumber,
        focusNode: _consigneeAccountNumberFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _consigneeAccountNumberFocusNode,
              _consigneeNameFocusNode);
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
            labelText: S.of(context).AccountNumber,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.switch_account,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
            //'Account Number',
            ),
        onChanged: (text) {
          setState(() {
            model.consigneeAccountNumber = text;
          });
        },
      ),
    );
  }

  name(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.consigneeName,
        focusNode: _consigneeNameFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _fieldFocusChange(
              context, _consigneeNameFocusNode, _consigneeAddressFocusNode);
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
            labelText: S.of(context).Name+" *",
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.contacts_rounded,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
            //'Name',
            ),
        onChanged: (text) {
          setState(() {
            model.consigneeName = text;
          });
        },
      ),
    );
  }

  address(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        maxLines: _addressMaxLinesCount,
        initialValue: model.consigneeAddress,
        focusNode: _consigneeAddressFocusNode,
        keyboardType: TextInputType.multiline,
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
            //  borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).Address,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.my_location,
              color: Theme.of(context).accentColor,
              //color: Colors.deepPurple,
            )
            //'Address',
            ),
        onChanged: (text) {
          setState(() {
            model.consigneeAddress = text;
          });
        },
      ),
    );
  }

  place(EAWBModel model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.consigneePlace,
        //focusNode: _shipperPlaceFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        // onFieldSubmitted: (value) {
        //   _fieldFocusChange(
        //       context, _shipperNameFocusNode, _shipperAddressFocusNode);
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
                //color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            // border: OutlineInputBorder(
            //     gapPadding: 2.0,
            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: S.of(context).Place,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.place,
              color: Theme.of(context).accentColor,
              //   color: Colors.deepPurple,
            )
            //'Place',
            ),
        onChanged: (text) {
          // model.setshipperName(text);
          model.consigneePlace = text;
        },
      ),
    );
  }

  state(EAWBModel model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.consigneeState,
        //focusNode: _shipperPlaceFocusNode,
        textInputAction: TextInputAction.next,
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
            labelText: S.of(context).State,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.place,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
            //'State',
            ),
        onChanged: (text) {
          // model.setshipperName(text);
          model.consigneeState = text;
        },
      ),
    );
  }

  postCode(EAWBModel model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.consigneePostCode,
        // focusNode: _shipperPlaceFocusNode,
        maxLength: 6,
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
            labelText: S.of(context).PostCode,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.code,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
            //'Post Code',
            ),
        onChanged: (text) {
          // model.setshipperName(text);
          model.consigneePostCode = text;
        },
      ),
    );
  }

  countryCode(EAWBModel model) {
    this.consigneeContact.text = model.consigneeCountryCode;
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TypeAheadField<CountryCode>(
          suggestionsCallback: CountryCodeApi.getCountryCode,
          itemBuilder: (context, CountryCode suggestion) {
            final code = suggestion;
            return ListTile(
              title: Text(code.countryCode),
              subtitle: Text(code.countryName),
            );
          },
          textFieldConfiguration: TextFieldConfiguration(
            controller: this.consigneeContact,
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
                    // color: Colors.deepPurple
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                // border: OutlineInputBorder(
                //     gapPadding: 2.0,
                //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
                labelText: S.of(context).CountryCode+" *",
                labelStyle: new TextStyle(
                    color: Theme.of(context).accentColor,
                    // color: Colors.deepPurple,
                    fontSize: 16.0),
                suffixIcon: Icon(
                  Icons.add_location,
                  color: Theme.of(context).accentColor,
                  //color: Colors.deepPurple,
                )
                //'Country Code',
                ),
            onChanged: (value) {
              if (CountryCodeApi.checkifCountryCode(value) != null) {
                model.shipperCountryCode = this.consigneeContact.text;
              }
            },
          ),
          onSuggestionSelected: (CountryCode suggestion) {
            this.consigneeContact.text = suggestion.countryCode;
            model.consigneeCountryCode = suggestion.countryCode;

            //print(origin);
          }),
      // child: TextFormField(
      //   initialValue: model.consigneeCountryCode,
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
      //     model.consigneeCountryCode = text;
      //   },
      // ),
    );
  }

  // void addConsignee(String TeleNumber, String Tdescription, String flag) {
  //   final expense = ConsigneeExpenseList(
  //     Consignee_Contact_Type: Tdescription,
  //     Consignee_Contact_Detail: TeleNumber,
  //     flag: flag
  //   );
  //   setState(() {
  //     expenseL.add(expense);
  //   });
  // }

  //Consignee..
  void Consigneecontactdelete(String title, EAWBModel model) {
    setState(() {
      model.newconsigneeContactList
          .removeWhere((element) => element.Consignee_Contact_Type == title);
    });
  }

  Future<String> _showConsigneeContactDialog(EAWBModel model) =>
      showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Stack(children: [
            Text(
              "Add Consignee Contact",
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ]),
          content: Form(
            key: _consigneeContactkey,
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
                      controller: Consigneecontype,
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
                          labelText:

                          //"Type",
                          S.of(context).Type,
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor)
                          //'Origin',
                          ),
                    ),
                    onSuggestionSelected: (ContactType suggestion) {
                      List.generate(
                          consigneecontactList.length,
                          (index) => consigneecontactList[index]
                                  ['Consignee_Contact_Type'] =
                              suggestion.contactCode);
                      // sippercontactList[index]['Shipper_Contact_Type'] =
                      //     suggestion.contactCode;
                      Consigneecontype.text = suggestion.contactType;
                      //_fhlModel.houseDetailsOrigin = suggestion.airportCode;
                      //
                    }),
                SizedBox(
                  height: 10,
                ),
                Consigneecontype.text == "Email"
                    ? TextFormField(
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
                            S.of(context).Enteremail,
                            //"Enter the Email"
                        ),
                        controller: Consigneecontact,
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
                        //controller: Consigneecontact,
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
                            'IN', //default contry code, NP for Nepal
                        onChanged: (phone) {
                          setState(() {
                            int flagOffset = 0x1F1E6;
                            int asciiOffset = 0x41;

                            String country = phone.countryISOCode;

                            int firstChar = country.codeUnitAt(0) - asciiOffset + flagOffset;
                            int secondChar = country.codeUnitAt(1) - asciiOffset + flagOffset;
                         //   countrcode=phone.countryISOCode;
                            flag =
                                String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
                            Consigneecontact.text = phone.completeNumber;
                          });
                          //   //when phone number country code is changed
                          //   print(phone.completeNumber); //get complete number
                          //   print(phone.countryCode); // get country code only
                          //   print(phone.number); // only phone number
                        },
                      )),
              ],
            ),
          ),
          actions: [
            TextButton(
                child: Text(

                 S.of(context).Cancel,
                 // 'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            TextButton(
                onPressed: () {
                  if (_consigneeContactkey.currentState.validate()) {
                    setState(() {
                      model.newconsigneeContactList.add(
                          ConsigneeExpenseList(
                              Consignee_Contact_Type:Consigneecontype.text ,
                              Consignee_Contact_Detail: Consigneecontact.text,
                              flag:flag
                          )
                      );
                    });
                    // model.newconsigneeContactList = expenseL;
                    // addConsignee(Consigneecontact.text, Consigneecontype.text,flag
                    //     // _Teletype
                    //     //Teletypecontroller.text
                    //     );
                    Navigator.pop(context);
                  }
                  Consigneecontact.clear();
                  Consigneecontype.clear();
                  // Navigator.of(context).pop(Emailcontroller.text);
                  // Emailcontroller.clear();
                },
                child: Text(
                 S.of(context).Submit,
                  // "Submit",
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                )),
          ],
        ),
      );
}
