import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:rooster/formatter.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/airport_model.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/screenroute.dart';
import 'package:rooster/ui/eawb/awb_consignment_details.dart';
import 'package:rooster/ui/eawb/routing_and_flight_bookings.dart';
import 'package:rooster/ui/eawb/static/custom_background.dart';
import 'package:rooster/ui/eawb/issuing_carriers_agent.dart';

import '../../model/eawb_models/notify_model.dart';
import '../drodowns/airport_code.dart';
import 'issuer.dart';

class AlsoNotify extends StatefulWidget {
  AlsoNotify({Key key}) : super(key: key);
  //final airportList;

  @override
  _AlsoNotifyState createState() => _AlsoNotifyState();
}

class _AlsoNotifyState extends State<AlsoNotify> {
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
  TextEditingController contactController = TextEditingController();


  List<Map<String, dynamic>> notifycontactList = [];

  String countrcode;
  String flag;
  final _ContactKey = GlobalKey<FormState>();
  final List<NotifyExpenseList> expenseList = [];
  TextEditingController contype = new TextEditingController();
  TextEditingController Telecontroller = new TextEditingController();
  final TextEditingController shipperContact = TextEditingController();


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
              previous: RoutingAndFlightBookings(),
              next: Issuer(),
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
              name:
              S.of(context).AlsoNotify,
              //"Also Notify",
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
                          notify_name(model),
                          notify_address(model),
                          notify_place(model),
                          notify_state(model),
                          notify_country(model),
                          notify_post(model),
                          // destination(model),


                          // notify_contact(model),
                          // notify_contact_num(model),


                          //routeAndFlightNumber2(model),
                          //routeAndFlightDate2(model),
                          Container(
                            margin: EdgeInsets.only(left: 15.0,
                           ),
                            child: Row(
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
                                  child: IconButton(
                                    icon: CircleAvatar(

                                      backgroundColor: Theme.of(context).accentColor,
                                      radius: 30,
                                      child: Icon(
                                        Icons.add,
                                         color: Theme.of(context).backgroundColor,
                                      ),
                                    ),
                                    onPressed: () {
                                      _showDialogContact(model);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            child: Column(
                              children: model.newnotifyContactList.map((e) {
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
                                        leading:e.Notify_Contact_Type == "Email"? Icon(
                                          Icons.email,
                                          color: Theme.of(context).accentColor,
                                        ):Icon ( Icons.phone,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        title: Text(
                                          (e.Notify_Contact_Type == "Email")?' ' + '${e.Notify_Contact_Detail}':'${e.flag}'
                                              + '${e.Notify_Contact_Detail}',
                                        ),
                                        subtitle: Text('${e.Notify_Contact_Type}',
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
                                                            .Notify_Contact_Detail,model);
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
  void Scontactdelete(String title, EAWBModel model) {
    setState(() {
      model.newnotifyContactList
          .removeWhere((element) => element.Notify_Contact_Detail == title);
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
                      notifycontactList.length,
                          (index) => notifycontactList[index]
                      ['Notify_Contact1_Type'] =
                          suggestion.contactCode);
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
                  S.of(context).Enteremail
                //"Enter the Email"
              ),
              controller: Telecontroller,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return
                    S.of(context).Pleaseentertheemailaddress;
                  //'Please enter the email address';
                }
                return null;
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
                  model.newnotifyContactList.add(
                      NotifyExpenseList(
                          Notify_Contact_Type: contype.text,
                          Notify_Contact_Detail: Telecontroller.text,
                          flag:flag
                      )
                  );
                });
                // model.newnotifyContactList = expenseList;
                // print("eAWB CONTACT LIST " +
                //     model.newshipperContactList.toString());
                // addTele(Telecontroller.text, contype.text,flag
                //   // _Teletype
                //   //Teletypecontroller.text
                // );
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
  void addTele(String TeleNumber, String Tdescription,String flag) {
    final expense = NotifyExpenseList(
        Notify_Contact_Type: Tdescription,
        Notify_Contact_Detail: TeleNumber,
        flag:flag
    );
    setState(() {
      expenseList.add(expense);
    });
  }

  notify_name(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.notifyName,
        //focusNode: _routeAndFlightBy1FocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        decoration: InputDecoration(
          isDense: true,
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
                //  color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          // border: OutlineInputBorder(
          //     gapPadding: 2.0,
          //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText:
          S.of(context).NotifyName,
            labelStyle:
            new TextStyle(
                color: Theme.of(context).accentColor,
              //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(Icons.contacts_rounded,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
          //'Notify Name',
        ),
        onChanged: (text) {
          setState(() {
            model.notifyName = text;
          });
        },
      ),
    );
  }

  notify_address(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.nofityStreetAddress,
        //focusNode: _routeAndFlightBy1FocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        decoration: InputDecoration(
          isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,
                  //   color: Colors.deepPurple,
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
          S.of(context).NotifyAddress,
            labelStyle:
            new TextStyle(
                color: Theme.of(context).accentColor,
              //  color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(Icons.my_location,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
          //'Notify Address',
        ),
        onChanged: (text) {
          setState(() {
            model.nofityStreetAddress = text;
          });
        },
      ),
    );
  }

  notify_place(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.notifyPlace,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        decoration: InputDecoration(
          isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,
                  //  color: Colors.deepPurple,
                    width:2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(8.0))
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2,
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          // border: OutlineInputBorder(
          //     gapPadding: 2.0,
          //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText:
          S.of(context).NotifyPlace,
            labelStyle:
            new TextStyle(
                color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(Icons.place,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
          //'Notify Place',
        ),
        onChanged: (text) {
          setState(() {
            model.notifyPlace = text;
          });
        },
      ),
    );
  }

  notify_state(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.notifyState,
        // focusNode: _routeAndFlightBy2FocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        decoration: InputDecoration(
          isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,
                  //color: Colors.deepPurple,
                    width:2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(8.0))
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2,
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          // border: OutlineInputBorder(
          //     gapPadding: 2.0,
          //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText:
          S.of(context).NotifyState,
            labelStyle:
            new TextStyle(
                color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(Icons.edit_location,
              color: Theme.of(context).accentColor,
              //   color: Colors.deepPurple,
            )
          //'Notify State',
        ),
        onChanged: (text) {
          setState(() {
            model.notifyState = text;
          });
        },
      ),
    );
  }

  notify_country(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.notifyCountryCode,
        // focusNode: _routeAndFlightBy2FocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        decoration: InputDecoration(
          isDense: true,
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
                //color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          // border: OutlineInputBorder(
          //     gapPadding: 2.0,
          //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText:
          S.of(context).NotifyCountryCode,
            labelStyle:
            new TextStyle(
                color: Theme.of(context).accentColor,
              //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(Icons.edit_location,
              color: Theme.of(context).accentColor,
              //color: Colors.deepPurple,
            )
          //'Notify Country Code',
        ),
        onChanged: (text) {
          setState(() {
            model.notifyCountryCode = text;
          });
        },
      ),
    );
  }

  notify_post(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.notifyPostCode,
        //focusNode: _routeAndFlightBy3FocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        decoration: InputDecoration(
          isDense: true,
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
                  //color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          // border: OutlineInputBorder(
          //     gapPadding: 2.0,
          //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText:
          S.of(context).NotifyPostCode,
            labelStyle:
            new TextStyle(
                color: Theme.of(context).accentColor,
              //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(Icons.code,
              color: Theme.of(context).accentColor,
             // color: Colors.deepPurple,
            )
          //'Notify Post Code',
        ),
        onChanged: (text) {
          setState(() {
            model.notifyPostCode = text;
          });
        },
      ),
    );
  }

  notify_contact(model) {
    this.contactController.text = model.notifyContactType;
    return Container(
      margin: EdgeInsets.all(10.0),
      // child: TextFormField(
      //   initialValue: model.notifyContactType,
      //   textInputAction: TextInputAction.done,
      //   keyboardType: TextInputType.text,
      //   inputFormatters: [AllCapitalCase()],
      //   decoration: InputDecoration(
      //     isDense: true,
      //       enabledBorder: OutlineInputBorder(
      //           borderSide: new BorderSide(
      //               color: Theme.of(context).accentColor,
      //             // color: Colors.deepPurple,
      //               width:2),
      //           //gapPadding: 2.0,
      //           borderRadius: BorderRadius.all(Radius.circular(8.0))
      //       ),
      //       focusedBorder: OutlineInputBorder(
      //         borderSide: BorderSide(width: 2,
      //           color: Theme.of(context).accentColor,
      //           // color: Colors.deepPurple
      //         ),
      //         borderRadius: BorderRadius.circular(8.0),
      //       ),
      //     // border: OutlineInputBorder(
      //     //     gapPadding: 2.0,
      //     //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
      //     labelText:
      //     S.of(context).NotifyContacttype,
      //       labelStyle:
      //       new TextStyle(
      //           color: Theme.of(context).accentColor,
      //         //color: Colors.deepPurple,
      //           fontSize: 16.0),
      //       suffixIcon: Icon(Icons.contacts_outlined,
      //         color: Theme.of(context).accentColor,
      //         //  color: Colors.deepPurple,
      //       )
      //     //'Notify Contact Type',
      //   ),
      //   onChanged: (text) {
      //     setState(() {
      //       model.notifyContactType = text;
      //     });
      //   },
      // ),
      child: TypeAheadField<ContactType>(
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
            controller: this.contactController,
            inputFormatters:[AllCapitalCase()],

            decoration: InputDecoration(
                isDense: true,
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
                S.of(context).Type,
                //"Type",
                //S.of(context).Origin,
                labelStyle:
                TextStyle(color: Theme.of(context).accentColor)
              //'Origin',
            ),
          ),
          onSuggestionSelected: (ContactType suggestion) {
            if (suggestion.contactType == null &&
                suggestion.contactCode == null) {
              return
                S.of(context).WrongAWBNumber;
                //'Worong AWB Number';
            } else {
              this.contactController.text = suggestion.contactType;
              model.notifyContactType = suggestion.contactType;
              //print(origin);
            }
            // List.generate(
            //     sippercontactList.length,
            //         (index) => sippercontactList[index]
            //     ['Shipper_Contact_Type'] =
            //         suggestion.contactCode);
            // contype.text = suggestion.contactType;
          }),
    );
  }

  notify_contact_num(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.notifyContactNumber,
        // focusNode: _routeAndFlightNumberOrDate1FocusNode,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        decoration: InputDecoration(
          isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,
                  //color: Colors.deepPurple,
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
          S.of(context).NotifyContactNumber,
            labelStyle:
            new TextStyle(
                color: Theme.of(context).accentColor,
              //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(Icons.contacts,
              color: Theme.of(context).accentColor,
              //color: Colors.deepPurple,
            )
          //'Notify Contact Number',
        ),
        onChanged: (text) {
          setState(() {
            model.notifyContactNumber = text;
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
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: ListTile(
            title: Text(model.routeAndFlightDate1),
            trailing: Icon(Icons.date_range,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            ),
            subtitle: Text(
                S.of(context).FlightDate,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                //    color: Colors.deepPurple
              ),
              //  'Flight Date'
            ),
          ),
        )
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
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).accentColor,
              //  color: Colors.deepPurple,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: ListTile(
            title: Text(model.routeAndFlightDate2),
            trailing: Icon(Icons.date_range,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            ),

            subtitle: Text(
              S.of(context).FlightDate,
              //'Flight Date',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                //  color: Colors.deepPurple
              ),),
          ),
        )
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
