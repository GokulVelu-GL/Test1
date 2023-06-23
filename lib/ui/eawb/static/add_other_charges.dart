import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:rooster/formatter.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/other_charges_items.dart';
import 'package:rooster/model/rate_description_items.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../model/eawb_model.dart';
import '../../drodowns/OtherChargeCode.dart';

class AddOtherChargesForm extends StatefulWidget {
  AddOtherChargesForm(
      {Key key,
      this.description,
      this.amount,
      this.entitlementValue,
      this.useRateIsEnabled,
      this.rate,
      this.weight,
        this.prepaidcollect,
      this.minimum})
      : super(key: key);
  final String entitlementValue;
  final String prepaidcollect;
  final bool useRateIsEnabled;
  final String description;
  final int amount;
  final double rate;
  final String weight;
  final double minimum;

  @override
  _AddOtherChargesFormState createState() => _AddOtherChargesFormState();
}

class _AddOtherChargesFormState extends State<AddOtherChargesForm> {
  int ratevaluechange;
  int minimumvaluechange;
  final ratevalue =

  TextEditingController();
  List<RateDescriptionItem> ratedescriptionList = new List<RateDescriptionItem>();
  var amountvalue = TextEditingController();
  var minimumcontroller = TextEditingController();
  var OtherChargeController = TextEditingController();
  // EAWBModel model;
  final _addOtherChargesItemForm = GlobalKey<FormState>();


  List<String> entitlement = ["Due agent", "Due carrier"];
  String entitlementValue;
  List<String> fields = ["PPD", "COLL"];
  int totalgrossweight=0;
  int totalchargeableweight=0;
  int noofpieces=0;
  int ChargesdueCarrier=0;
  int Chargesdueagent=0;
  List<ChargeCode> chargitems =[
    ChargeCode("MY","Fuel Surcharge"),
    ChargeCode("XB","Insurance & Security Surcharge"),
    ChargeCode("CG","Electronic processing or transmission\n of data for customs purposes"),
    ChargeCode("CC","Manual data entry for customs purposes"),
    ChargeCode("RA","Dangerous Goods Fee"),
  ];

  String prepaidrcollect="PPD";
  // List<String> codetype = [
  //   "MY",
  //   "XB",
  //   "CG",
  //   "CC",
  //   "RA"
  // ];
  // String codetype1 =
  //     'RA'
  // ;
  // ChargeCode codetype1;
  String codetype1 = '';

  List<bool> _selections = List.generate(2, (_)=> false);
  List<String> criteriaDropDown = [
    "Gross Weight",
    "Chargeable Weight",
    "No. of pieces",
    "Charges due Carrier",
    "Charges due agent"

  ];
  List<String> calculationDropDownValue = [
  "(rate x quantity) or minimum",
    "minimum + (rate x quantity)"
  ];
  String calculationDropDown="(rate x quantity) or minimum";
  String criteriaDropDownValue =
      'Gross Weight'
  ;
  bool useRateIsEnabled;
  String dueagentvalue;
  String duecarriervalue;
  int ChargesdueCarriervalue;
  String description;
   int amount;
  double rate;
  String weight;
  double minimum;
  double amount1;
  int minimumvalue;

  @override
  void initState() {
    print(widget.description);
    description = widget.description ?? "";
    print(description);
    amount = widget.amount ?? 0;
    entitlementValue = widget.entitlementValue ?? "Due agent";
    useRateIsEnabled = widget.useRateIsEnabled ?? false;
    rate = widget.rate ?? 0;
    weight = widget.weight ?? '';
    minimum = widget.minimum ?? 0;
    prepaidrcollect=widget.prepaidcollect??'PPD';
    // codetype1=(widget.description??'MY') as ChargeCode;
    ratevalue.addListener(_rateAmountChanged);
    amountvalue.addListener(_onAmountChanged);
    minimumcontroller.addListener(_onminimumchanged);


    super.initState();
  }
  @override
  void dispose() {
    // To make sure we are not leaking anything, dispose any used TextEditingController
    // when this widget is cleared from memory.
    ratevalue.dispose();
    amountvalue.dispose();

    super.dispose();
  }


  FocusNode descriptionFocusNode = FocusNode();
  FocusNode amountFocusNode = FocusNode();
  FocusNode rateFocusNode = FocusNode();
  FocusNode minimumFocusNode = FocusNode();
  _rateAmountChanged() {
    setState(() {
      ratevaluechange = int.tryParse(ratevalue.text) ?? 0;
    });
  }

  _onAmountChanged() {
    setState(() {
      amount = int.tryParse(amountvalue.text) ?? 0;
    });
  }
  _onminimumchanged() {
    setState(() {
      minimumvalue = int.tryParse(minimumcontroller.text) ?? 0;
    });
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }


  @override
  Widget build(BuildContext context) {
    // amount=widget.amount;
    //  var amountvalue = TextEditingController(text: amount.toString());
    return Consumer<EAWBModel>(
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          model.setStatus();
          return true;
        },
        child:Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
            title: Text(
              //S.of(context).AddItem,
               "Add Other Charges"
            ),
          ),
          body: SafeArea(
            child: Center(
              child: Form(
                key: _addOtherChargesItemForm,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // ! Entitlement....
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(S.of(context).Entitlement,
                                  //"Entitlement",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      //color: Colors.deepPurple,
                                      fontWeight: FontWeight.w500, fontSize: 18.0)),
                              // Container(
                              //   padding: EdgeInsets.only(
                              //     left: 10.0
                              //   ),
                              //   color: Theme.of(context).accentColor.withOpacity(0.3),
                              //   child: DropdownButton<String>(
                              //
                              //       icon: Icon(Icons.arrow_drop_down),
                              //       value: entitlementValue,
                              //       items: entitlement.map<DropdownMenuItem<String>>(
                              //               (String value) {
                              //             return DropdownMenuItem<String>(
                              //               value: value,
                              //               child: Text(value),
                              //             );
                              //           }).toList(),
                              //       onChanged: (String text) {
                              //         setState(() {
                              //           entitlementValue = text;
                              //         });
                              //       }),
                              // )
                            ],
                          ),
                        ),
                        // ! Description....
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
                        //   child: TextFormField(
                        //     focusNode: descriptionFocusNode,
                        //     textInputAction: TextInputAction.next,
                        //     onFieldSubmitted: (value) {
                        //       _fieldFocusChange(
                        //           context, descriptionFocusNode, amountFocusNode);
                        //     },
                        //     initialValue: description,
                        //     keyboardType: TextInputType.text,
                        //     inputFormatters: [AllCapitalCase()],
                        //     onChanged: (value) {
                        //       description = value;
                        //     },
                        //     decoration: InputDecoration(
                        //       enabledBorder: OutlineInputBorder(
                        //           borderSide: new BorderSide(
                        //               color: Theme.of(context).accentColor,
                        //             //color: Colors.deepPurple,
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
                        //       // border: OutlineInputBorder(
                        //       //     gapPadding: 2.0,
                        //       //     borderRadius:
                        //       //         BorderRadius.all(Radius.circular(8.0))),
                        //       labelText:
                        //       S.of(context).Description,
                        //       labelStyle:
                        //       new TextStyle(
                        //           color: Theme.of(context).accentColor,
                        //         //color: Colors.deepPurple,
                        //           fontSize: 16.0),
                        //       //'Description',
                        //     ),
                        //   ),
                        // ),
                        // ! Amount....
                        Container(

                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),),
                              border: Border.all(color: Theme.of(context).accentColor,
                                width: 2,
                              )
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    "Due Agent",
                                    //"AWB",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor
                                    ),
                                  ),
                                  leading: Radio(
                                      fillColor: MaterialStateColor.resolveWith((states) => Theme.of(context).accentColor),
                                      value: "Due agent",
                                      groupValue: entitlementValue,
                                      onChanged: (value) {
                                        setState(() {
                                          entitlementValue = value.toString();
                                        });
                                      }),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    "Due Carrier",
                                    //"Multiple AWBs",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor
                                    ),),
                                  leading: Radio(
                                      fillColor: MaterialStateColor.resolveWith((states) => Theme.of(context).accentColor),
                                      value: "Due carrier",
                                      groupValue: entitlementValue,
                                      onChanged: (value) {
                                        setState(() {
                                          entitlementValue = value.toString();
                                        });
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top:15.0,bottom: 15.0),
                          child: TextFormField(
                            controller: amountvalue,
                            focusNode: amountFocusNode,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (value) => amountFocusNode.unfocus(),
                            // initialValue: amount == 0 ? "" : amount.toString(),
                            enabled: !useRateIsEnabled,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                               filled: true,
                              fillColor: (useRateIsEnabled)?Theme.of(context).accentColor.withOpacity(0.2):Theme.of(context).backgroundColor,
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
                                  //  color: Colors.deepPurple
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              // border: OutlineInputBorder(
                              //     gapPadding: 2.0,
                              //     borderRadius:
                              //         BorderRadius.all(Radius.circular(8.0))),
                              labelText:
                              S.of(context).Amount,
                              labelStyle:
                              new TextStyle(
                                  color: Theme.of(context).accentColor,
                                  //color: Colors.deepPurple,
                                  fontSize: 16.0),
                              //'Amount',
                            ),
                            onChanged: (value) {
                              amount = int.parse(value);
                            },
                          ),
                        ),


                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.only(bottom: 15),
                        //       child: DropdownButton<String>(
                        //           icon: Icon(Icons.arrow_drop_down),
                        //           value: codetype1,
                        //           items: codetype
                        //               .map<DropdownMenuItem<String>>(
                        //                   (String value) {
                        //                 return DropdownMenuItem<String>(
                        //                   value: value,
                        //                   child: Text(value),
                        //                 );
                        //               }).toList(),
                        //           onChanged: (String text) {
                        //             setState(() {
                        //               codetype1 = text;
                        //               description =text;
                        //               if(description =="MY"){
                        //                 weight ="Fuel Surcharge";
                        //               }
                        //               else if(description =="XB"){
                        //                 weight ="Insurance & Security Surcharge";
                        //               }
                        //               else if(description =="CG"){
                        //                 weight ="Electronic processing or transmission\n of data for customs purposes";
                        //               }
                        //               else if(description =="CC"){
                        //                 weight ="Manual data entry for\n customs purposes";
                        //               }
                        //               else if(description =="RA"){
                        //                 weight ="Dangerous Goods Fee";
                        //               }
                        //
                        //             });
                        //           }),
                        //     ),
                        //     IconButton(onPressed: (){
                        //       showDialog(
                        //         context: context,
                        //         builder: (ctx) => AlertDialog(
                        //           shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(20),
                        //           ),
                        //           title:  Center(
                        //             child: Text("Other Charge Code Description",
                        //               style: TextStyle(
                        //                 fontSize: 18,
                        //               ),
                        //             ),
                        //           ),
                        //           content: Column(
                        //             mainAxisSize: MainAxisSize.min,
                        //             children: [
                        //               Card(
                        //                 child: ListTile(
                        //                   title: Text("MY",
                        //                     style: TextStyle(
                        //                         color: Theme.of(context).accentColor
                        //                     ),
                        //                   ),
                        //                   subtitle: Text("Fuel Surcharge",
                        //                     style: TextStyle(
                        //                         color: Theme.of(context).accentColor
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ), Card(
                        //                 child: ListTile(
                        //                   title: Text("XB",
                        //                     style: TextStyle(
                        //                         color: Theme.of(context).accentColor
                        //                     ),
                        //                   ),
                        //                   subtitle: Text("Insurance & Security Surcharge",
                        //                     style: TextStyle(
                        //                         color: Theme.of(context).accentColor
                        //                     ),
                        //                     textAlign: TextAlign.justify,
                        //                   ),
                        //                 ),
                        //               ), Card(
                        //                 child: ListTile(
                        //                   title: Text("CG",
                        //                     style: TextStyle(
                        //                         color: Theme.of(context).accentColor
                        //                     ),
                        //                   ),
                        //                   subtitle: Text("Electronic processing or transmission of data for customs purposes",
                        //                     style: TextStyle(
                        //                         color: Theme.of(context).accentColor
                        //                     ),
                        //                     // textAlign: TextAlign.justify,
                        //                   ),
                        //                 ),
                        //               ), Card(
                        //                 child: ListTile(
                        //                   title: Text("CC",
                        //                     style: TextStyle(
                        //                         color: Theme.of(context).accentColor
                        //                     ),
                        //                   ),
                        //                   subtitle: Text("Manual data entry for customs purposes",
                        //                     style: TextStyle(
                        //                         color: Theme.of(context).accentColor
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ), Card(
                        //                 child: ListTile(
                        //                   title: Text("RA",
                        //                     style: TextStyle(
                        //                         color: Theme.of(context).accentColor
                        //                     ),),
                        //                   subtitle: Text("Dangerous Goods Fee",
                        //                     style: TextStyle(
                        //                         color: Theme.of(context).accentColor
                        //                     ),
                        //                     textAlign: TextAlign.justify,
                        //                   ),
                        //                 ),
                        //               ),
                        //
                        //             ],
                        //           ),
                        //           actions: <Widget>[
                        //             Center(
                        //               child: TextButton(
                        //
                        //                 style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor),
                        //
                        //                 ),
                        //                 onPressed: () {
                        //                   Navigator.of(ctx).pop();
                        //                 },
                        //                 child: Text("Close",
                        //                   style: TextStyle(
                        //                       color: Theme.of(context).backgroundColor
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       );
                        //     }, icon: Icon(Icons.help,
                        //       color: Theme.of(context).accentColor,
                        //     )),
                        //     Padding(
                        //       padding: const EdgeInsets.only(bottom: 15),
                        //       child: DropdownButton<String>(
                        //           icon: Icon(Icons.arrow_drop_down),
                        //           value: prepaidrcollect,
                        //           items: fields
                        //               .map<DropdownMenuItem<String>>(
                        //                   (String value) {
                        //                 return DropdownMenuItem<String>(
                        //                   value: value,
                        //                   child: Text(value),
                        //                 );
                        //               }).toList(),
                        //           onChanged: (String text) {
                        //             setState(() {
                        //               prepaidrcollect = text;
                        //               // model.chargesDeclarationOtherCharges=text;
                        //             });
                        //           }),
                        //     ),
                        //
                        //     // ToggleButtons(
                        //     //   borderWidth: 2,
                        //     //   color: Theme.of(context).primaryColor,
                        //     //   borderColor: Theme.of(context).accentColor,
                        //     //   fillColor: Theme.of(context).accentColor,
                        //     //   selectedColor: Colors.white,
                        //     //   selectedBorderColor: Theme.of(context).accentColor,
                        //     //   borderRadius: BorderRadius.circular(5.0),
                        //     //   children: <Widget>[
                        //     //     Text("PPD"),
                        //     //     Text("COLL"),
                        //     //   ],
                        //     //   isSelected: _selections,
                        //     //   onPressed: (int index) {
                        //     //     setState(() {
                        //     //       _selections[index] = !_selections[index];
                        //     //
                        //     //       // _selections[index] = model.chargesDeclarationOtherCharges as bool;
                        //     //     });
                        //     //   },
                        //     // ),
                        //   ],
                        // ),
                        // ! Use rate....
                        Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: TypeAheadField<OtherChargesCode>(
                              suggestionsCallback: OtherChargeCodeClassApi.getRateClassCode,
                              itemBuilder: (context, OtherChargesCode suggestion) {
                                final code = suggestion;
                                return ListTile(
                                  title: Text(code.OtherChargeCode,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor)),
                                  subtitle: Text(code.OtherChargeName,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor)),
                                );
                              },
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: OtherChargeController,
                                inputFormatters: [AllCapitalCase()],
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
                                      // gapPadding: 1.0,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8.0),

                                        )),
                                    suffixText: codetype1,
                                    labelText: "Charge Code",
                                    //S.of(context).Origin,
                                    labelStyle:
                                    TextStyle(color: Theme.of(context).accentColor)
                                  //'Origin',
                                ),
                              ),
                              onSuggestionSelected: (OtherChargesCode suggestion) {
                                setState(() {
                                  codetype1 = suggestion.OtherChargeName;
                                  this.OtherChargeController.text=suggestion.OtherChargeCode;
                                //  codetype1 = suggestion.OtherChargeCode;

                                    // codetype1 = newValue;
                                  description = suggestion.OtherChargeCode;
                                    model.otherChargesList.forEach((element) {
                                      if(element.description==description&&element.entitlement==entitlementValue){
                                        Fluttertoast.showToast(
                                            msg: "This charge code is already exists",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      }
                                    });
                                    if(description =="MY"){weight ="Fuel Surcharge";}
                                    else if(description =="XB"){weight ="Insurance & Security Surcharge";}
                                    else if(description =="CG"){
                                      weight ="Electronic processing or\n transmission of data for\n customs purposes";}
                                    else if(description =="CC"){
                                      weight ="Manual data entry for\n customs purposes";
                                    }
                                    else if(description =="RA"){
                                      weight ="Dangerous Goods Fee";
                                    }
                                    // (entitlementValue=="Due agent")?description = newValue.ChargCode+"A":description = newValue.ChargCode+"C";


                                });
                                // sippercontactList[index]['Shipper_Contact_Type'] =
                                //     suggestion.contactCode;

                                //_fhlModel.houseDetailsOrigin = suggestion.airportCode;
                                //
                              }),
                        ),

              //           Container(
              //             margin: const EdgeInsets.only(bottom: 15),
              //             decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.all(
              //                   Radius.circular(8.0),),
              //                 border: Border.all(color: Theme.of(context).accentColor,
              //                   width: 2,
              //                 )
              //             ),
              //             padding: const EdgeInsets.only(bottom:10),
              //             child: DropdownButton<ChargeCode>(
              //               hint:Padding(
              //                 padding: const EdgeInsets.only(left: 15.0,top: 5),
              //                 child: Text("Charge Code",
              //                 style: TextStyle(
              //                   color: Theme.of(context).accentColor
              //                 ),
              //                 ),
              //               ),
              //                 isExpanded: true,
              //                 icon: Visibility (visible:false, child: Icon(Icons.arrow_downward)),
              //                 // icon: Icon(Icons.keyboard_arrow_down),
              //                 underline: SizedBox(),
              //                 value: codetype1,
              //                 onChanged: (ChargeCode newValue) {
              //                   setState(() {
              //                    // codetype1 = newValue;
              //                     description = newValue.ChargCode;
              //                     model.otherChargesList.forEach((element) {
              //                       if(element.description==description&&element.entitlement==entitlementValue){
              //                         Fluttertoast.showToast(
              //                             msg: "This charge code is already exists",
              //                             toastLength: Toast.LENGTH_SHORT,
              //                             gravity: ToastGravity.CENTER,
              //                             timeInSecForIosWeb: 1,
              //                             backgroundColor: Colors.red,
              //                             textColor: Colors.white,
              //                             fontSize: 16.0
              //                         );
              //                       }
              //                     });
              //                     if(description =="MY"){weight ="Fuel Surcharge";}
              //                     else if(description =="XB"){weight ="Insurance & Security Surcharge";}
              //                     else if(description =="CG"){
              //                       weight ="Electronic processing or\n transmission of data for\n customs purposes";}
              // else if(description =="CC"){
              //   weight ="Manual data entry for\n customs purposes";
              // }
              // else if(description =="RA"){
              //   weight ="Dangerous Goods Fee";
              // }
              // // (entitlementValue=="Due agent")?description = newValue.ChargCode+"A":description = newValue.ChargCode+"C";
              //
              //                   });
              //                 },
              //                 items: chargitems.map<DropdownMenuItem<ChargeCode>>((ChargeCode value) {
              //                   return DropdownMenuItem<ChargeCode>(
              //                     value: value,
              //                     child: ListTile(
              //                       title: Text(value.ChargCode),
              //                       trailing:  Text(value.Chargename),
              //                     ),
              //                   );
              //                 }).toList()),
              //           ),
              //
                        AbsorbPointer(
                          absorbing: true,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor.withOpacity(0.2),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8.0)),
                              //  border: Border.all(color: Theme.of(context).accentColor,
                                //  width: 2,
                              //  )
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      "PPD",
                                      //"AWB",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor
                                      ),
                                    ),
                                    leading: Radio(
                                        fillColor: MaterialStateColor.resolveWith((states) => Theme.of(context).accentColor),
                                        value: "PPD",
                                        groupValue: model.chargesDeclarationOtherCharges,
                                        onChanged: (value) {
                                          setState(() {
                                            model.chargesDeclarationOtherCharges = value.toString();
                                          });
                                        }),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      "COLL",
                                      //"Multiple AWBs",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor
                                      ),),
                                    leading: Radio(
                                        fillColor: MaterialStateColor.resolveWith((states) => Theme.of(context).accentColor),
                                        value: "COLL",
                                        groupValue: model.chargesDeclarationOtherCharges,
                                        onChanged: (value) {
                                          setState(() {
                                            model.chargesDeclarationOtherCharges = value.toString();
                                          });
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),



                        //split ppd and collect
                        // Container(
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.all(
                        //         Radius.circular(8.0),),
                        //       border: Border.all(color: Theme.of(context).accentColor,
                        //         width: 2,
                        //       )
                        //   ),
                        //   child: Row(
                        //     children: [
                        //       Expanded(
                        //         child: ListTile(
                        //           title: Text(
                        //             "PPD",
                        //             //"AWB",
                        //             style: TextStyle(
                        //                 color: Theme.of(context).accentColor
                        //             ),
                        //           ),
                        //           leading: Radio(
                        //               fillColor: MaterialStateColor.resolveWith((states) => Theme.of(context).accentColor),
                        //               value: "PPD",
                        //               groupValue: prepaidrcollect,
                        //               onChanged: (value) {
                        //                 setState(() {
                        //                   prepaidrcollect = value.toString();
                        //                 });
                        //               }),
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         width: 10,
                        //       ),
                        //       Expanded(
                        //         child: ListTile(
                        //           title: Text(
                        //            "COLL",
                        //             //"Multiple AWBs",
                        //             style: TextStyle(
                        //                 color: Theme.of(context).accentColor
                        //             ),),
                        //           leading: Radio(
                        //               fillColor: MaterialStateColor.resolveWith((states) => Theme.of(context).accentColor),
                        //               value: "COLL",
                        //               groupValue: prepaidrcollect,
                        //               onChanged: (value) {
                        //                 setState(() {
                        //                   prepaidrcollect = value.toString();
                        //                 });
                        //               }),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     IconButton(onPressed: (){
                            //       showDialog(
                            //         context: context,
                            //         builder: (ctx) => AlertDialog(
                            //           shape: RoundedRectangleBorder(
                            //             borderRadius: BorderRadius.circular(20),
                            //           ),
                            //           title:  Center(
                            //             child: Text("Other Charge Code Description",
                            //               style: TextStyle(
                            //                 fontSize: 18,
                            //               ),
                            //             ),
                            //           ),
                            //           content: Column(
                            //             mainAxisSize: MainAxisSize.min,
                            //             children: [
                            //               Card(
                            //                 child: ListTile(
                            //                   title: Text("MY",
                            //                     style: TextStyle(
                            //                         color: Theme.of(context).accentColor
                            //                     ),
                            //                   ),
                            //                   subtitle: Text("Fuel Surcharge",
                            //                     style: TextStyle(
                            //                         color: Theme.of(context).accentColor
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ), Card(
                            //                 child: ListTile(
                            //                   title: Text("XB",
                            //                     style: TextStyle(
                            //                         color: Theme.of(context).accentColor
                            //                     ),
                            //                   ),
                            //                   subtitle: Text("Insurance & Security Surcharge",
                            //                     style: TextStyle(
                            //                         color: Theme.of(context).accentColor
                            //                     ),
                            //                     textAlign: TextAlign.justify,
                            //                   ),
                            //                 ),
                            //               ), Card(
                            //                 child: ListTile(
                            //                   title: Text("CG",
                            //                     style: TextStyle(
                            //                         color: Theme.of(context).accentColor
                            //                     ),
                            //                   ),
                            //                   subtitle: Text("Electronic processing or transmission of data for customs purposes",
                            //                     style: TextStyle(
                            //                         color: Theme.of(context).accentColor
                            //                     ),
                            //                     // textAlign: TextAlign.justify,
                            //                   ),
                            //                 ),
                            //               ), Card(
                            //                 child: ListTile(
                            //                   title: Text("CC",
                            //                     style: TextStyle(
                            //                         color: Theme.of(context).accentColor
                            //                     ),
                            //                   ),
                            //                   subtitle: Text("Manual data entry for customs purposes",
                            //                     style: TextStyle(
                            //                         color: Theme.of(context).accentColor
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ), Card(
                            //                 child: ListTile(
                            //                   title: Text("RA",
                            //                     style: TextStyle(
                            //                         color: Theme.of(context).accentColor
                            //                     ),),
                            //                   subtitle: Text("Dangerous Goods Fee",
                            //                     style: TextStyle(
                            //                         color: Theme.of(context).accentColor
                            //                     ),
                            //                     textAlign: TextAlign.justify,
                            //                   ),
                            //                 ),
                            //               ),
                            //
                            //             ],
                            //           ),
                            //           actions: <Widget>[
                            //             Center(
                            //               child: TextButton(
                            //
                            //                 style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor),
                            //
                            //                 ),
                            //                 onPressed: () {
                            //                   Navigator.of(ctx).pop();
                            //                 },
                            //                 child: Text("Close",
                            //                   style: TextStyle(
                            //                       color: Theme.of(context).backgroundColor
                            //                   ),
                            //                 ),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       );
                            //     }, icon: Icon(Icons.help,
                            //       color: Theme.of(context).accentColor,
                            //     )),
                            //     // Padding(
                            //     //   padding: const EdgeInsets.only(bottom: 15),
                            //     //   child: DropdownButton<String>(
                            //     //       icon: Icon(Icons.arrow_drop_down),
                            //     //       value: prepaidrcollect,
                            //     //       items: fields
                            //     //           .map<DropdownMenuItem<String>>(
                            //     //               (String value) {
                            //     //             return DropdownMenuItem<String>(
                            //     //               value: value,
                            //     //               child: Text(value),
                            //     //             );
                            //     //           }).toList(),
                            //     //       onChanged: (String text) {
                            //     //         setState(() {
                            //     //           prepaidrcollect = text;
                            //     //           // model.chargesDeclarationOtherCharges=text;
                            //     //         });
                            //     //       }),
                            //     // ),
                            //     // ToggleButtons(
                            //     //   borderWidth: 2,
                            //     //   color: Theme.of(context).primaryColor,
                            //     //   borderColor: Theme.of(context).accentColor,
                            //     //   fillColor: Theme.of(context).accentColor,
                            //     //   selectedColor: Colors.white,
                            //     //   selectedBorderColor: Theme.of(context).accentColor,
                            //     //   borderRadius: BorderRadius.circular(5.0),
                            //     //   children: <Widget>[
                            //     //     Text("PPD"),
                            //     //     Text("COLL"),
                            //     //   ],
                            //     //   isSelected: _selections,
                            //     //   onPressed: (int index) {
                            //     //     setState(() {
                            //     //       _selections[index] = !_selections[index];
                            //     //
                            //     //       // _selections[index] = model.chargesDeclarationOtherCharges as bool;
                            //     //     });
                            //     //   },
                            //     // ),
                            //   ],
                            // ),
                            Container(
                              padding: EdgeInsets.only(top: 14.0),
                              child: Text(
                                  S.of(context).Userate,
                                  //"Use rate"
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      // color: Colors.deepPurple,
                                      fontWeight: FontWeight.w500, fontSize: 18.0)),
                            ),
                            Switch(
                              value: useRateIsEnabled,
                              onChanged: (value) {
                                setState(() {
                                  useRateIsEnabled = value;
                                });
                              },
                              activeTrackColor: Theme.of(context).accentColor,
                              activeColor: Theme.of(context).primaryColor,
                            ),

                          ],
                        ),
                        if (useRateIsEnabled)
                          Column(
                            children: [
                              DropdownButton<String>(
                                  icon: Icon(Icons.arrow_drop_down),
                                  value: calculationDropDown,
                                  items: calculationDropDownValue
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                  onChanged: (String text) {
                                    setState(() {
                                      calculationDropDown = text;
                                    //  grossweight();
                                    });
                                  }),
                              Row(
                                children:[
                                  // Text(ratevaluechange.toString()),
                                  // Text(totalgrossweight.toString())
                                ]
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(bottom: 15),
                              //   child: TextFormField(
                              //     focusNode: rateFocusNode,
                              //     textInputAction: TextInputAction.done,
                              //     onFieldSubmitted: (context) =>
                              //         rateFocusNode.unfocus(),
                              //     initialValue:"0",
                              //     //amount1 == 0 ? "" : amount1.toString(),
                              //     keyboardType: TextInputType.number,
                              //     decoration: InputDecoration(
                              //       enabledBorder: OutlineInputBorder(
                              //           borderSide: new BorderSide(
                              //               color: Theme.of(context).accentColor,
                              //               //color: Colors.deepPurple,
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
                              //       // border: OutlineInputBorder(
                              //       //     gapPadding: 2.0,
                              //       //     borderRadius:
                              //       //         BorderRadius.all(Radius.circular(8.0))),
                              //       labelText:
                              //       S.of(context).Amount,
                              //       labelStyle:
                              //       new TextStyle(
                              //           color: Theme.of(context).accentColor,
                              //           //color: Colors.deepPurple,
                              //           fontSize: 16.0),
                              //       //'Rate',
                              //     ),
                              //     onChanged: (value) {
                              //       amount1 = double.parse(value);
                              //     },
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(bottom: 5),
                              //   child: DropdownButton<String>(
                              //       icon: Icon(Icons.arrow_drop_down),
                              //       value: criteriaDropDownValue,
                              //       items: criteriaDropDown
                              //           .map<DropdownMenuItem<String>>(
                              //               (String value) {
                              //             return DropdownMenuItem<String>(
                              //               value: value,
                              //               child: Text(value),
                              //             );
                              //           }).toList(),
                              //       onChanged: (String text) {
                              //         setState(() {
                              //           criteriaDropDownValue = text;
                              //           if(criteriaDropDownValue=="Gross Weight") {
                              //             model.rateDescriptionItemList.forEach((
                              //                 element) {
                              //               print("mnop.............");
                              //               totalgrossweight =
                              //                   element.grossWeight.toInt();
                              //               print(element.grossWeight);
                              //               print(element.chargeableWeight);
                              //               amount = totalgrossweight;
                              //               print(
                              //                   "Gross total" + amount.toString());
                              //             });
                              //             minimumvaluechange = ratevaluechange * 4;
                              //             amountvalue =
                              //                 TextEditingController(
                              //                     text: minimumvaluechange
                              //                         .toString());
                              //             minimumvaluechange = ratevaluechange;
                              //           }
                              //           grossweight();
                              //         });
                              //       }),
                              // ),
                              SizedBox(height: 5,),
                              // ! Rate....
                              // Padding(
                              //   padding: const EdgeInsets.only(bottom: 15),
                              //   child: TextFormField(
                              //     focusNode: rateFocusNode,
                              //     textInputAction: TextInputAction.done,
                              //     onFieldSubmitted: (context) =>
                              //         rateFocusNode.unfocus(),
                              //     initialValue: rate == 0 ? "" : rate.toString(),
                              //     keyboardType: TextInputType.number,
                              //     decoration: InputDecoration(
                              //       enabledBorder: OutlineInputBorder(
                              //           borderSide: new BorderSide(
                              //               color: Theme.of(context).accentColor,
                              //             //color: Colors.deepPurple,
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
                              //       // border: OutlineInputBorder(
                              //       //     gapPadding: 2.0,
                              //       //     borderRadius:
                              //       //         BorderRadius.all(Radius.circular(8.0))),
                              //       labelText:
                              //  S.of(context).Rate,
                              //       labelStyle:
                              //       new TextStyle(
                              //           color: Theme.of(context).accentColor,
                              //         //color: Colors.deepPurple,
                              //           fontSize: 16.0),
                              //       //'Rate',
                              //     ),
                              //     onChanged: (value) {
                              //       rate = double.parse(value);
                              //     },
                              //   ),
                              // ),
                              // // ! Criteria....

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: TextFormField(
                                      controller: this.ratevalue,
                                      //
                                      // focusNode: minimumFocusNode,
                                      // // textDirection: TextDirection.ltr,
                                      // textInputAction: TextInputAction.done,
                                      // onFieldSubmitted: (value) =>
                                      //     minimumFocusNode.unfocus(),
                                      // initialValue:
                                      //     minimum == 0 ? "" : minimum.toString(),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: new BorderSide(
                                              color: Theme.of(context).accentColor,
                                              //color: Colors.deepPurple,
                                              width:2,
                                            ),
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
                                        //     borderRadius:
                                        //         BorderRadius.all(Radius.circular(8.0))),
                                        labelText:
                                        "Rate",
                                        // S.of(context).Minimum,
                                        labelStyle:
                                        new TextStyle(
                                            color: Theme.of(context).accentColor,
                                            // color: Colors.deepPurple,
                                            fontSize: 16.0),
                                        //'Minimum',
                                      ),
                                      onChanged: (value) {

                                        if(ratevaluechange==null){
                                          totalgrossweight=0;
                                          totalchargeableweight=0;
                                        }
                                       // grossweight(model);
                                        //amount=int.parse(value);
                                        // minimum = double.parse(value);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text("x"),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if(criteriaDropDownValue=="Gross Weight")Container(
                                          height: 30,
                                        //    width: 60,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).accentColor.withOpacity(0.4),
                                                borderRadius: BorderRadius.all(Radius.circular(10))
                                            ),

                                            child: Center(child: Container(
                                                height: 30,
                                               // width: 55,
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context).accentColor.withOpacity(0.4),
                                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                                ),
                                                child: Center(child: Text(totalgrossweight.toString()))))),
                                        if(criteriaDropDownValue=="Chargeable Weight")Container(
                                            height: 30,
                                           // width: 30,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).accentColor.withOpacity(0.4),
                                                borderRadius: BorderRadius.all(Radius.circular(10))
                                            ),
                                            child: Center(child: Text(totalchargeableweight.toString()))),
                                        if(criteriaDropDownValue=="No. of pieces")Container(
                                            height: 30,
                                          //  width: 30,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).accentColor.withOpacity(0.4),
                                                borderRadius: BorderRadius.all(Radius.circular(10))
                                            ),
                                            child: Center(child: Text(noofpieces.toString()))),
                                        if(criteriaDropDownValue=="Charges due Carrier")Container(
                                            height: 40,
                                          //  width: 40,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).accentColor.withOpacity(0.4),
                                                borderRadius: BorderRadius.all(Radius.circular(10))
                                            ),

                                            child: Center(child: Text(ChargesdueCarrier.toString()))),
                                        if(criteriaDropDownValue=="Charges due agent")Container(
                                            height: 40,
                                          //  width: 40,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).accentColor.withOpacity(0.4),
                                                borderRadius: BorderRadius.all(Radius.circular(10))
                                            ),

                                            child: Center(child: Text(dueagentvalue))),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5),
                                          child: DropdownButton<String>(
                                              icon: Icon(Icons.arrow_drop_down),
                                              value: criteriaDropDownValue,
                                              items: criteriaDropDown
                                                  .map<DropdownMenuItem<String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                              onChanged: (String text) {
                                                setState(() {
                                                  criteriaDropDownValue = text;
                                                  print("Criteria  "+criteriaDropDownValue);
                                                  if(calculationDropDown=="(rate x quantity) or minimum") {
                                                    if (criteriaDropDownValue ==
                                                        "Gross Weight") {
                                                      int ttalgrossweight=0;
                                                      print("RATEEE"+ratevaluechange.toString());
                                                      // print(model
                                                      //     .rateDescriptionItemList);
                                                      model.rateDescriptionItemList
                                                          .forEach((element) {
                                                        print("mnop.............");
                                                        ttalgrossweight +=
                                                            element.grossWeight
                                                                .toInt();
                                                        totalgrossweight=ttalgrossweight;
                                                        // totalchargeableweight+=
                                                        // element.chargeableWeight;
                                                        // noofpieces+=element.pieces;
                                                        print("Gross weight" +
                                                            element.grossWeight
                                                                .toString());
                                                        print("chargeableweight" +
                                                            element.chargeableWeight
                                                                .toString());
                                                        // amount = totalgrossweight;
                                                        print(
                                                            "Gross total" +
                                                                amount.toString());
                                                      });
                                                      int grossweightvalue = totalgrossweight *
                                                          ratevaluechange;
                                                      print("amount" +
                                                          grossweightvalue
                                                              .toString());
                                                      // minimumvaluechange =
                                                      //     ratevaluechange * 4;
                                                      amountvalue =
                                                          TextEditingController(
                                                              text: grossweightvalue
                                                                  .toString());
                                                      // minimumvaluechange = ratevaluechange;
                                                    }
                                                    if (criteriaDropDownValue ==
                                                        "Chargeable Weight") {
                                                      print(model
                                                          .rateDescriptionItemList);
                                                      int ttalchargeableweight=0;
                                                      model.rateDescriptionItemList
                                                          .forEach((element) {
                                                        print("mnop.............");
                                                        ttalchargeableweight +=
                                                            element
                                                                .chargeableWeight;
                                                        totalchargeableweight=ttalchargeableweight;
                                                        // noofpieces+=element.pieces;
                                                        print("Gross weight" +
                                                            element.grossWeight
                                                                .toString());
                                                        print("chargeableweight" +
                                                            element.chargeableWeight
                                                                .toString());
                                                        // amount = totalgrossweight;
                                                        print(
                                                            "Gross total" +
                                                                amount.toString());
                                                      });
                                                      int chargeableweightvalue = totalchargeableweight *
                                                          ratevaluechange;
                                                      print("grossweightvalue" +
                                                          chargeableweightvalue
                                                              .toString());
                                                      // minimumvaluechange = ratevaluechange * 4;
                                                      amountvalue =
                                                          TextEditingController(
                                                              text: chargeableweightvalue
                                                                  .toString());
                                                    }
                                                    if (criteriaDropDownValue ==
                                                        "No. of pieces") {
                                                      print(model
                                                          .rateDescriptionItemList);
                                                      int nofpieces=0;
                                                      model.rateDescriptionItemList
                                                          .forEach((element) {
                                                        print("mnop.............");
                                                        // totalchargeableweight+=
                                                        // element.chargeableWeight;
                                                        nofpieces +=
                                                            element.pieces;
                                                        noofpieces=nofpieces;
                                                        print("no of pieces" +
                                                            element.pieces
                                                                .toString());
                                                        print("chargeableweight" +
                                                            element.chargeableWeight
                                                                .toString());
                                                        // amount = totalgrossweight;
                                                        print(
                                                            "Gross total" +
                                                                amount.toString());
                                                      });
                                                      int noofpiecesvalue = noofpieces *
                                                          ratevaluechange;
                                                      print("noofpiecesvalue" +
                                                          noofpiecesvalue
                                                              .toString());
                                                      // minimumvaluechange = ratevaluechange * 4;
                                                      amountvalue =
                                                          TextEditingController(
                                                              text: noofpiecesvalue
                                                                  .toString());
                                                      // minimumvaluechange = ratevaluechange;
                                                    }
                                                    if (criteriaDropDownValue ==
                                                        "Charges due Carrier") {
                                                      if(prepaidrcollect=="PPD"){
                                                        print(model
                                                            .rateDescriptionItemList);
                                                        int ChrgesdueCarrier =0;
                                                        model.rateDescriptionItemList.forEach((element) {
                                                          print("mnop.............");
                                                          // totalchargeableweight+=
                                                          // element.chargeableWeight;
                                                           duecarriervalue=model.chargeSummaryDueCarrierPrepaid;
                                                           ChrgesdueCarrier += int.parse(duecarriervalue)+
                                                               element.total;
                                                           ChargesdueCarrier=ChrgesdueCarrier;
                                                           print("no of pieces" +
                                                               element.total.toString());
                                                           print("chargeableweight" +
                                                               element.chargeableWeight.toString());
                                                           // amount = totalgrossweight;
                                                          print("Gross total" + ChargesdueCarrier.toString());});
                                                        int ChargesdueCarriervalue = ChargesdueCarrier * ratevaluechange;print("noofpiecesvalue" + ChargesdueCarriervalue.toString());
                                                          // minimumvaluechange = ratevaluechange * 4;
                                                        amountvalue = TextEditingController(
                                                            text: ChargesdueCarriervalue.toString());
                                                      }
                                                      else
                                                      {
                                                        print(model
                                                            .rateDescriptionItemList);
                                                        int ChrgesdueCarrier =0;
                                                        model.rateDescriptionItemList.forEach((element) {
                                                          print("mnop.............");
                                                          // totalchargeableweight+=
                                                          // element.chargeableWeight;
                                                          duecarriervalue=model.chargeSummaryDueCarrierPostpaid;
                                                          ChrgesdueCarrier += int.parse(duecarriervalue)+
                                                              element.total;
                                                          ChargesdueCarrier=ChrgesdueCarrier;
                                                          print("no of pieces" +
                                                              element.total.toString());
                                                          print("chargeableweight" +
                                                              element.chargeableWeight.toString());
                                                          // amount = totalgrossweight;
                                                          print("Gross total" + ChargesdueCarrier.toString());});
                                                        int ChargesdueCarriervalue = ChargesdueCarrier * ratevaluechange;print("noofpiecesvalue" + ChargesdueCarriervalue.toString());
                                                        // minimumvaluechange = ratevaluechange * 4;
                                                        amountvalue = TextEditingController(
                                                            text: ChargesdueCarriervalue.toString());
                                                      }
                                                      // minimumvaluechange = ratevaluechange;
                                                    }
                                                    if (criteriaDropDownValue ==
                                                        "Charges due agent") {
                                                      if(prepaidrcollect=="PPD") {
                                                       int Chrgesdueagent= 0;
                                                         dueagentvalue = model
                                                            .chargeSummaryDueAgentPrepaid;
                                                        Chrgesdueagent =
                                                            int.parse(
                                                                dueagentvalue) *
                                                                ratevaluechange;
                                                       Chargesdueagent=Chrgesdueagent;
                                                        amountvalue =
                                                            TextEditingController(
                                                                text: Chargesdueagent
                                                                    .toString());
                                                        print("Charrrge" +
                                                            Chargesdueagent
                                                                .toString());
                                                      }
                                                      else{
                                                         dueagentvalue = model
                                                            .chargeSummaryDueAgentPostpaid;
                                                        Chargesdueagent =
                                                            int.parse(
                                                                dueagentvalue) *
                                                                ratevaluechange;
                                                        amountvalue =
                                                            TextEditingController(
                                                                text: Chargesdueagent
                                                                    .toString());
                                                        print("Charrrge" +
                                                            Chargesdueagent
                                                                .toString());

                                                      }
                                                    }
                                                  }
                                                  else
                                                    {
                                                      if (criteriaDropDownValue ==
                                                          "Gross Weight") {
                                                        print(model
                                                            .rateDescriptionItemList);
                                                        int ttalgrossweight =0;
                                                        model.rateDescriptionItemList
                                                            .forEach((element) {
                                                          print("mnop.............");
                                                          ttalgrossweight +=
                                                              element.grossWeight
                                                                  .toInt();
                                                          totalgrossweight=ttalgrossweight;
                                                          // totalchargeableweight+=
                                                          // element.chargeableWeight;
                                                          // noofpieces+=element.pieces;
                                                          print("Gross weight" +
                                                              element.grossWeight
                                                                  .toString());
                                                          print("chargeableweight" +
                                                              element.chargeableWeight
                                                                  .toString());
                                                          // amount = totalgrossweight;
                                                          print(
                                                              "Gross total " + amount.toString()
                                                          );
                                                        });
                                                        int grossweightvalue =minimumvalue+ totalgrossweight *
                                                            ratevaluechange;
                                                        print("grossweightvalue" +
                                                            grossweightvalue
                                                                .toString());
                                                        minimumvaluechange =
                                                            ratevaluechange * 4;
                                                        amountvalue =
                                                            TextEditingController(
                                                                text: grossweightvalue
                                                                    .toString());
                                                        // minimumvaluechange = ratevaluechange;
                                                      }
                                                      if (criteriaDropDownValue ==
                                                          "Chargeable Weight") {
                                                        print(model
                                                            .rateDescriptionItemList);
                                                        int ttalchargeableweight=0;
                                                        model.rateDescriptionItemList
                                                            .forEach((element) {
                                                          print("mnop.............");
                                                          ttalchargeableweight +=
                                                              element
                                                                  .chargeableWeight;
                                                          totalchargeableweight=ttalchargeableweight;
                                                          // noofpieces+=element.pieces;
                                                          print("Gross weight" +
                                                              element.grossWeight
                                                                  .toString());
                                                          print("chargeableweight" +
                                                              element.chargeableWeight
                                                                  .toString());
                                                          // amount = totalgrossweight;
                                                          print(
                                                              "Gross total" +
                                                                  amount.toString());
                                                        });
                                                        int chargeableweightvalue = minimumvalue + totalchargeableweight *
                                                            ratevaluechange;
                                                        print("grossweightvalue" +
                                                            chargeableweightvalue
                                                                .toString());
                                                        // minimumvaluechange = ratevaluechange * 4;
                                                        amountvalue =
                                                            TextEditingController(
                                                                text: chargeableweightvalue
                                                                    .toString());
                                                      }
                                                      if (criteriaDropDownValue ==
                                                          "No. of pieces") {
                                                        print(model
                                                            .rateDescriptionItemList);
                                                        int nofpieces=0;
                                                        model.rateDescriptionItemList
                                                            .forEach((element) {
                                                          print("mnop.............");
                                                          // totalchargeableweight+=
                                                          // element.chargeableWeight;
                                                          nofpieces +=
                                                              element.pieces;
                                                          print("no of pieces" +
                                                              element.pieces
                                                                  .toString());
                                                          noofpieces=nofpieces;
                                                          print("chargeableweight" +
                                                              element.chargeableWeight
                                                                  .toString());
                                                          // amount = totalgrossweight;
                                                          print(
                                                              "Gross total" +
                                                                  amount.toString());
                                                        });
                                                        int noofpiecesvalue =minimumvalue+ noofpieces *
                                                            ratevaluechange;
                                                        print("noofpiecesvalue" +
                                                            noofpiecesvalue
                                                                .toString());
                                                        // minimumvaluechange = ratevaluechange * 4;
                                                        amountvalue =
                                                            TextEditingController(
                                                                text: noofpiecesvalue
                                                                    .toString());
                                                        // minimumvaluechange = ratevaluechange;
                                                      }
                                                      if (criteriaDropDownValue ==
                                                          "Charges due Carrier") {
                                                        if(prepaidrcollect=="PPD"){
                                                        print(model
                                                            .rateDescriptionItemList);
                                                        duecarriervalue=model.chargeSummaryDueCarrierPrepaid;
                                                        int ChrgesdueCarrier=0;
                                                        model.rateDescriptionItemList
                                                            .forEach((element) {
                                                          print("mnop.............");
                                                          // totalchargeableweight+=
                                                          // element.chargeableWeight;
                                                          ChrgesdueCarrier +=int.parse(duecarriervalue)+
                                                              element.total;
                                                          ChargesdueCarrier=ChrgesdueCarrier;
                                                          print("no of pieces" +
                                                              element.total
                                                                  .toString());
                                                          print("chargeableweight" +
                                                              element.chargeableWeight
                                                                  .toString());
                                                          // amount = totalgrossweight;
                                                          print(
                                                              "Gross total" +
                                                                  ChargesdueCarrier
                                                                      .toString());
                                                        });
                                                         ChargesdueCarriervalue =minimumvalue + ChargesdueCarrier *
                                                            ratevaluechange;
                                                        print("noofpiecesvalue" +
                                                            ChargesdueCarriervalue
                                                                .toString());
                                                        // minimumvaluechange = ratevaluechange * 4;
                                                        amountvalue =
                                                            TextEditingController(
                                                                text: ChargesdueCarriervalue
                                                                    .toString());
                                                        // minimumvaluechange = ratevaluechange;
                                                      }
                                                        else{
                                                          print(model
                                                              .rateDescriptionItemList);
                                                          duecarriervalue=model.chargeSummaryDueCarrierPostpaid;
                                                          int ChrgesdueCarrier=0;
                                                          model.rateDescriptionItemList
                                                              .forEach((element) {
                                                            print("mnop.............");
                                                            // totalchargeableweight+=
                                                            // element.chargeableWeight;
                                                            ChrgesdueCarrier +=int.parse(duecarriervalue)+
                                                                element.total;
                                                            ChargesdueCarrier=ChrgesdueCarrier;
                                                            print("no of pieces" +
                                                                element.total
                                                                    .toString());
                                                            print("chargeableweight" +
                                                                element.chargeableWeight
                                                                    .toString());
                                                            // amount = totalgrossweight;
                                                            print(
                                                                "Gross total" +
                                                                    ChargesdueCarrier
                                                                        .toString());
                                                          });
                                                          ChargesdueCarriervalue =minimumvalue + ChargesdueCarrier *
                                                              ratevaluechange;
                                                          print("noofpiecesvalue" +
                                                              ChargesdueCarriervalue
                                                                  .toString());
                                                          // minimumvaluechange = ratevaluechange * 4;
                                                          amountvalue =
                                                              TextEditingController(
                                                                  text: ChargesdueCarriervalue
                                                                      .toString());
                                                          // minimumvaluechange = ratevaluechange;
                                                        }
                                                    }
                                                      if (criteriaDropDownValue ==
                                                          "Charges due agent") {
                                                        if(prepaidrcollect=="PPD") {
                                                          int Chrgesdueagent=0;
                                                           dueagentvalue = model
                                                              .chargeSummaryDueAgentPrepaid;
                                                          Chrgesdueagent =
                                                              minimumvalue + int.parse(
                                                                  dueagentvalue) *
                                                                  ratevaluechange;
                                                          Chargesdueagent=Chrgesdueagent;
                                                          amountvalue =
                                                              TextEditingController(
                                                                  text: Chargesdueagent
                                                                      .toString());
                                                          print("Charrrge" +
                                                              Chargesdueagent
                                                                  .toString());
                                                        }
                                                        else{
                                                          String dueagentvalue = model
                                                              .chargeSummaryDueAgentPostpaid;
                                                          Chargesdueagent =
                                                          minimumvalue+
                                                              int.parse(
                                                                  dueagentvalue) *
                                                                  ratevaluechange;
                                                          amountvalue =
                                                              TextEditingController(
                                                                  text: Chargesdueagent
                                                                      .toString());
                                                          print("Charrrge" +
                                                              Chargesdueagent.toString());

                                                        }
                                                      }
                                                    }
                                                  //grossweight(model,ratevaluechange);
                                                });
                                              }),
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              // Text(minimumvalue.toString()),
                              // ! Minimum....
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: TextFormField(
                                  controller: this.minimumcontroller,

                                  focusNode: minimumFocusNode,
                                  // textDirection: TextDirection.ltr,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (value) =>
                                      minimumFocusNode.unfocus(),
                                  // initialValue:
                                  //     minimum == 0 ? "" : minimum.toString(),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: new BorderSide(
                                          color: Theme.of(context).accentColor,
                                          //color: Colors.deepPurple,
                                          width:2,
                                        ),
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
                                    //     borderRadius:
                                    //         BorderRadius.all(Radius.circular(8.0))),
                                    labelText:
                                    S.of(context).Minimum,
                                    labelStyle:
                                    new TextStyle(
                                        color: Theme.of(context).accentColor,
                                        // color: Colors.deepPurple,
                                        fontSize: 16.0),
                                    //'Minimum',
                                  ),
                                  onChanged: (value) {
                                   // grossweight(model);
                                    // this.minimumvalue.text=value;
                                    minimumvalue=int.parse(value);

                                    if(calculationDropDown=="(rate x quantity) or minimum") {
                                      if(int.parse(amountvalue.text)<minimumvalue)
                                    amountvalue=TextEditingController(text: minimumvalue.toString());
                                    }
                                    // minimum = double.parse(value);
                                  },
                                ),
                              ),

                            ],
                          )
                        else
                          Container(), // ? Empty....
                        // ! Dialog Buttons....
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding:  EdgeInsets.only(bottom: 15, right: 8),
                              child: TextButton(
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor),),
                                onPressed: () {
                                  Navigator.of(context).pop(null);
                                },
                                child: Text(
                                  S.of(context).Close,
                                  style: TextStyle(
                                    color: Theme.of(context).backgroundColor
                                  ),
                                  // "Close"
                                ),
                              ),
                            ),
                            // ! ADD ....
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: TextButton(
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor)),
                                  onPressed: () {
                                    Navigator.of(context).pop(OtherChargesItem(
                                        description: description,
                                        amount: int.parse(amountvalue.text),
                                        entitlement: entitlementValue,
                                        useRate: useRateIsEnabled,
                                        rate: rate,
                                        weight: codetype1,
                                        prepaidcollect: prepaidrcollect,
                                        minimum: minimum));
                                  },
                                  child: Text(
                                      S.of(context).Add,
                                    style:TextStyle(
                                      color:Theme.of(context).backgroundColor
                                    )
                                    // "Add"
                                  )),
                            ),
                          ],
                        ),
                        // Text(totalgrossweight.toString()),
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

    //   Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Theme.of(context).primaryColor,
    //     centerTitle: true,
    //     title: Text(
    //       S.of(context).AddItem,
    //        // "Add Item"
    //     ),
    //   ),
    //   body: SafeArea(
    //     child: Center(
    //       child: Form(
    //         key: _addOtherChargesItemForm,
    //         child: SingleChildScrollView(
    //           child: Padding(
    //             padding: const EdgeInsets.all(20.0),
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: <Widget>[
    //                 // ! Description....
    //                 // Padding(
    //                 //   padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
    //                 //   child: TextFormField(
    //                 //     focusNode: descriptionFocusNode,
    //                 //     textInputAction: TextInputAction.next,
    //                 //     onFieldSubmitted: (value) {
    //                 //       _fieldFocusChange(
    //                 //           context, descriptionFocusNode, amountFocusNode);
    //                 //     },
    //                 //     initialValue: description,
    //                 //     keyboardType: TextInputType.text,
    //                 //     inputFormatters: [AllCapitalCase()],
    //                 //     onChanged: (value) {
    //                 //       description = value;
    //                 //     },
    //                 //     decoration: InputDecoration(
    //                 //       enabledBorder: OutlineInputBorder(
    //                 //           borderSide: new BorderSide(
    //                 //               color: Theme.of(context).accentColor,
    //                 //             //color: Colors.deepPurple,
    //                 //               width:2),
    //                 //           //gapPadding: 2.0,
    //                 //           borderRadius: BorderRadius.all(Radius.circular(8.0))
    //                 //       ),
    //                 //       focusedBorder: OutlineInputBorder(
    //                 //         borderSide: BorderSide(width: 2,
    //                 //           color: Theme.of(context).accentColor,
    //                 //           // color: Colors.deepPurple
    //                 //         ),
    //                 //         borderRadius: BorderRadius.circular(8.0),
    //                 //       ),
    //                 //       // border: OutlineInputBorder(
    //                 //       //     gapPadding: 2.0,
    //                 //       //     borderRadius:
    //                 //       //         BorderRadius.all(Radius.circular(8.0))),
    //                 //       labelText:
    //                 //       S.of(context).Description,
    //                 //       labelStyle:
    //                 //       new TextStyle(
    //                 //           color: Theme.of(context).accentColor,
    //                 //         //color: Colors.deepPurple,
    //                 //           fontSize: 16.0),
    //                 //       //'Description',
    //                 //     ),
    //                 //   ),
    //                 // ),
    //                 // ! Amount....
    //                 Padding(
    //                   padding: const EdgeInsets.only(bottom: 15.0),
    //                   child: TextFormField(
    //                     controller: amountvalue,
    //                     focusNode: amountFocusNode,
    //                     textInputAction: TextInputAction.done,
    //                     onFieldSubmitted: (value) => amountFocusNode.unfocus(),
    //                    // initialValue: amount == 0 ? "" : amount.toString(),
    //                     enabled: !useRateIsEnabled,
    //                     keyboardType: TextInputType.number,
    //                     decoration: InputDecoration(
    //                       enabledBorder: OutlineInputBorder(
    //                           borderSide: new BorderSide(
    //                               color: Theme.of(context).accentColor,
    //                             //color: Colors.deepPurple,
    //                               width:2),
    //                           //gapPadding: 2.0,
    //                           borderRadius: BorderRadius.all(Radius.circular(8.0))
    //                       ),
    //                       focusedBorder: OutlineInputBorder(
    //                         borderSide: BorderSide(width: 2,
    //                           color: Theme.of(context).accentColor,
    //                           //  color: Colors.deepPurple
    //                         ),
    //                         borderRadius: BorderRadius.circular(8.0),
    //                       ),
    //                       // border: OutlineInputBorder(
    //                       //     gapPadding: 2.0,
    //                       //     borderRadius:
    //                       //         BorderRadius.all(Radius.circular(8.0))),
    //                       labelText:
    //                       S.of(context).Amount,
    //                       labelStyle:
    //                       new TextStyle(
    //                           color: Theme.of(context).accentColor,
    //                         //color: Colors.deepPurple,
    //                           fontSize: 16.0),
    //                       //'Amount',
    //                     ),
    //                     onChanged: (value) {
    //                       amount = int.parse(value);
    //                     },
    //                   ),
    //                 ),
    //                 // ! Entitlement....
    //                 Padding(
    //                   padding: const EdgeInsets.only(bottom: 10),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: <Widget>[
    //                       Text(S.of(context).Entitlement,
    //                           //"Entitlement",
    //                           style: TextStyle(
    //                               color: Theme.of(context).accentColor,
    //                             //color: Colors.deepPurple,
    //                               fontWeight: FontWeight.w500, fontSize: 18.0)),
    //                       DropdownButton<String>(
    //                           icon: Icon(Icons.arrow_drop_down),
    //                           value: entitlementValue,
    //                           items: entitlement.map<DropdownMenuItem<String>>(
    //                               (String value) {
    //                             return DropdownMenuItem<String>(
    //                               value: value,
    //                               child: Text(value),
    //                             );
    //                           }).toList(),
    //                           onChanged: (String text) {
    //                             setState(() {
    //                               entitlementValue = text;
    //                             });
    //                           })
    //                     ],
    //                   ),
    //                 ),
    //                 // Row(
    //                 //   crossAxisAlignment: CrossAxisAlignment.start,
    //                 //   mainAxisAlignment: MainAxisAlignment.center,
    //                 //   children: [
    //                 //     Padding(
    //                 //       padding: const EdgeInsets.only(bottom: 15),
    //                 //       child: DropdownButton<String>(
    //                 //           icon: Icon(Icons.arrow_drop_down),
    //                 //           value: codetype1,
    //                 //           items: codetype
    //                 //               .map<DropdownMenuItem<String>>(
    //                 //                   (String value) {
    //                 //                 return DropdownMenuItem<String>(
    //                 //                   value: value,
    //                 //                   child: Text(value),
    //                 //                 );
    //                 //               }).toList(),
    //                 //           onChanged: (String text) {
    //                 //             setState(() {
    //                 //               codetype1 = text;
    //                 //               description =text;
    //                 //               if(description =="MY"){
    //                 //                 weight ="Fuel Surcharge";
    //                 //               }
    //                 //               else if(description =="XB"){
    //                 //                 weight ="Insurance & Security Surcharge";
    //                 //               }
    //                 //               else if(description =="CG"){
    //                 //                 weight ="Electronic processing or transmission\n of data for customs purposes";
    //                 //               }
    //                 //               else if(description =="CC"){
    //                 //                 weight ="Manual data entry for\n customs purposes";
    //                 //               }
    //                 //               else if(description =="RA"){
    //                 //                 weight ="Dangerous Goods Fee";
    //                 //               }
    //                 //
    //                 //             });
    //                 //           }),
    //                 //     ),
    //                 //     IconButton(onPressed: (){
    //                 //       showDialog(
    //                 //         context: context,
    //                 //         builder: (ctx) => AlertDialog(
    //                 //           shape: RoundedRectangleBorder(
    //                 //             borderRadius: BorderRadius.circular(20),
    //                 //           ),
    //                 //           title:  Center(
    //                 //             child: Text("Other Charge Code Description",
    //                 //               style: TextStyle(
    //                 //                 fontSize: 18,
    //                 //               ),
    //                 //             ),
    //                 //           ),
    //                 //           content: Column(
    //                 //             mainAxisSize: MainAxisSize.min,
    //                 //             children: [
    //                 //               Card(
    //                 //                 child: ListTile(
    //                 //                   title: Text("MY",
    //                 //                     style: TextStyle(
    //                 //                         color: Theme.of(context).accentColor
    //                 //                     ),
    //                 //                   ),
    //                 //                   subtitle: Text("Fuel Surcharge",
    //                 //                     style: TextStyle(
    //                 //                         color: Theme.of(context).accentColor
    //                 //                     ),
    //                 //                   ),
    //                 //                 ),
    //                 //               ), Card(
    //                 //                 child: ListTile(
    //                 //                   title: Text("XB",
    //                 //                     style: TextStyle(
    //                 //                         color: Theme.of(context).accentColor
    //                 //                     ),
    //                 //                   ),
    //                 //                   subtitle: Text("Insurance & Security Surcharge",
    //                 //                     style: TextStyle(
    //                 //                         color: Theme.of(context).accentColor
    //                 //                     ),
    //                 //                     textAlign: TextAlign.justify,
    //                 //                   ),
    //                 //                 ),
    //                 //               ), Card(
    //                 //                 child: ListTile(
    //                 //                   title: Text("CG",
    //                 //                     style: TextStyle(
    //                 //                         color: Theme.of(context).accentColor
    //                 //                     ),
    //                 //                   ),
    //                 //                   subtitle: Text("Electronic processing or transmission of data for customs purposes",
    //                 //                     style: TextStyle(
    //                 //                         color: Theme.of(context).accentColor
    //                 //                     ),
    //                 //                     // textAlign: TextAlign.justify,
    //                 //                   ),
    //                 //                 ),
    //                 //               ), Card(
    //                 //                 child: ListTile(
    //                 //                   title: Text("CC",
    //                 //                     style: TextStyle(
    //                 //                         color: Theme.of(context).accentColor
    //                 //                     ),
    //                 //                   ),
    //                 //                   subtitle: Text("Manual data entry for customs purposes",
    //                 //                     style: TextStyle(
    //                 //                         color: Theme.of(context).accentColor
    //                 //                     ),
    //                 //                   ),
    //                 //                 ),
    //                 //               ), Card(
    //                 //                 child: ListTile(
    //                 //                   title: Text("RA",
    //                 //                     style: TextStyle(
    //                 //                         color: Theme.of(context).accentColor
    //                 //                     ),),
    //                 //                   subtitle: Text("Dangerous Goods Fee",
    //                 //                     style: TextStyle(
    //                 //                         color: Theme.of(context).accentColor
    //                 //                     ),
    //                 //                     textAlign: TextAlign.justify,
    //                 //                   ),
    //                 //                 ),
    //                 //               ),
    //                 //
    //                 //             ],
    //                 //           ),
    //                 //           actions: <Widget>[
    //                 //             Center(
    //                 //               child: TextButton(
    //                 //
    //                 //                 style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor),
    //                 //
    //                 //                 ),
    //                 //                 onPressed: () {
    //                 //                   Navigator.of(ctx).pop();
    //                 //                 },
    //                 //                 child: Text("Close",
    //                 //                   style: TextStyle(
    //                 //                       color: Theme.of(context).backgroundColor
    //                 //                   ),
    //                 //                 ),
    //                 //               ),
    //                 //             ),
    //                 //           ],
    //                 //         ),
    //                 //       );
    //                 //     }, icon: Icon(Icons.help,
    //                 //       color: Theme.of(context).accentColor,
    //                 //     )),
    //                 //     Padding(
    //                 //       padding: const EdgeInsets.only(bottom: 15),
    //                 //       child: DropdownButton<String>(
    //                 //           icon: Icon(Icons.arrow_drop_down),
    //                 //           value: prepaidrcollect,
    //                 //           items: fields
    //                 //               .map<DropdownMenuItem<String>>(
    //                 //                   (String value) {
    //                 //                 return DropdownMenuItem<String>(
    //                 //                   value: value,
    //                 //                   child: Text(value),
    //                 //                 );
    //                 //               }).toList(),
    //                 //           onChanged: (String text) {
    //                 //             setState(() {
    //                 //               prepaidrcollect = text;
    //                 //               // model.chargesDeclarationOtherCharges=text;
    //                 //             });
    //                 //           }),
    //                 //     ),
    //                 //
    //                 //     // ToggleButtons(
    //                 //     //   borderWidth: 2,
    //                 //     //   color: Theme.of(context).primaryColor,
    //                 //     //   borderColor: Theme.of(context).accentColor,
    //                 //     //   fillColor: Theme.of(context).accentColor,
    //                 //     //   selectedColor: Colors.white,
    //                 //     //   selectedBorderColor: Theme.of(context).accentColor,
    //                 //     //   borderRadius: BorderRadius.circular(5.0),
    //                 //     //   children: <Widget>[
    //                 //     //     Text("PPD"),
    //                 //     //     Text("COLL"),
    //                 //     //   ],
    //                 //     //   isSelected: _selections,
    //                 //     //   onPressed: (int index) {
    //                 //     //     setState(() {
    //                 //     //       _selections[index] = !_selections[index];
    //                 //     //
    //                 //     //       // _selections[index] = model.chargesDeclarationOtherCharges as bool;
    //                 //     //     });
    //                 //     //   },
    //                 //     // ),
    //                 //   ],
    //                 // ),
    //                 // ! Use rate....
    //                 Row(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: <Widget>[
    //
    //                     Row(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                         Padding(
    //                           padding: const EdgeInsets.only(bottom: 15),
    //                           child: DropdownButton<String>(
    //                               icon: Icon(Icons.arrow_drop_down),
    //                               value: codetype1,
    //                               items: codetype
    //                                   .map<DropdownMenuItem<String>>(
    //                                       (String value) {
    //                                     return DropdownMenuItem<String>(
    //                                       value: value,
    //                                       child: Text(value),
    //                                     );
    //                                   }).toList(),
    //                               onChanged: (String text) {
    //                                 setState(() {
    //                                   codetype1 = text;
    //                                   description =text;
    //                                   if(description =="MY"){
    //                                     weight ="Fuel Surcharge";
    //                                   }
    //                                   else if(description =="XB"){
    //                                     weight ="Insurance & Security Surcharge";
    //                                   }
    //                                   else if(description =="CG"){
    //                                     weight ="Electronic processing or transmission\n of data for customs purposes";
    //                                   }
    //                                   else if(description =="CC"){
    //                                     weight ="Manual data entry for\n customs purposes";
    //                                   }
    //                                   else if(description =="RA"){
    //                                     weight ="Dangerous Goods Fee";
    //                                   }
    //
    //                                 });
    //                               }),
    //                         ),
    //                         IconButton(onPressed: (){
    //                           showDialog(
    //                             context: context,
    //                             builder: (ctx) => AlertDialog(
    //                               shape: RoundedRectangleBorder(
    //                                 borderRadius: BorderRadius.circular(20),
    //                               ),
    //                               title:  Center(
    //                                 child: Text("Other Charge Code Description",
    //                                   style: TextStyle(
    //                                     fontSize: 18,
    //                                   ),
    //                                 ),
    //                               ),
    //                               content: Column(
    //                                 mainAxisSize: MainAxisSize.min,
    //                                 children: [
    //                                   Card(
    //                                     child: ListTile(
    //                                       title: Text("MY",
    //                                         style: TextStyle(
    //                                             color: Theme.of(context).accentColor
    //                                         ),
    //                                       ),
    //                                       subtitle: Text("Fuel Surcharge",
    //                                         style: TextStyle(
    //                                             color: Theme.of(context).accentColor
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   ), Card(
    //                                     child: ListTile(
    //                                       title: Text("XB",
    //                                         style: TextStyle(
    //                                             color: Theme.of(context).accentColor
    //                                         ),
    //                                       ),
    //                                       subtitle: Text("Insurance & Security Surcharge",
    //                                         style: TextStyle(
    //                                             color: Theme.of(context).accentColor
    //                                         ),
    //                                         textAlign: TextAlign.justify,
    //                                       ),
    //                                     ),
    //                                   ), Card(
    //                                     child: ListTile(
    //                                       title: Text("CG",
    //                                         style: TextStyle(
    //                                             color: Theme.of(context).accentColor
    //                                         ),
    //                                       ),
    //                                       subtitle: Text("Electronic processing or transmission of data for customs purposes",
    //                                         style: TextStyle(
    //                                             color: Theme.of(context).accentColor
    //                                         ),
    //                                         // textAlign: TextAlign.justify,
    //                                       ),
    //                                     ),
    //                                   ), Card(
    //                                     child: ListTile(
    //                                       title: Text("CC",
    //                                         style: TextStyle(
    //                                             color: Theme.of(context).accentColor
    //                                         ),
    //                                       ),
    //                                       subtitle: Text("Manual data entry for customs purposes",
    //                                         style: TextStyle(
    //                                             color: Theme.of(context).accentColor
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   ), Card(
    //                                     child: ListTile(
    //                                       title: Text("RA",
    //                                         style: TextStyle(
    //                                             color: Theme.of(context).accentColor
    //                                         ),),
    //                                       subtitle: Text("Dangerous Goods Fee",
    //                                         style: TextStyle(
    //                                             color: Theme.of(context).accentColor
    //                                         ),
    //                                         textAlign: TextAlign.justify,
    //                                       ),
    //                                     ),
    //                                   ),
    //
    //                                 ],
    //                               ),
    //                               actions: <Widget>[
    //                                 Center(
    //                                   child: TextButton(
    //
    //                                     style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor),
    //
    //                                     ),
    //                                     onPressed: () {
    //                                       Navigator.of(ctx).pop();
    //                                     },
    //                                     child: Text("Close",
    //                                       style: TextStyle(
    //                                           color: Theme.of(context).backgroundColor
    //                                       ),
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           );
    //                         }, icon: Icon(Icons.help,
    //                           color: Theme.of(context).accentColor,
    //                         )),
    //                         Padding(
    //                           padding: const EdgeInsets.only(bottom: 15),
    //                           child: DropdownButton<String>(
    //                               icon: Icon(Icons.arrow_drop_down),
    //                               value: prepaidrcollect,
    //                               items: fields
    //                                   .map<DropdownMenuItem<String>>(
    //                                       (String value) {
    //                                     return DropdownMenuItem<String>(
    //                                       value: value,
    //                                       child: Text(value),
    //                                     );
    //                                   }).toList(),
    //                               onChanged: (String text) {
    //                                 setState(() {
    //                                   prepaidrcollect = text;
    //                                   // model.chargesDeclarationOtherCharges=text;
    //                                 });
    //                               }),
    //                         ),
    //
    //                         // ToggleButtons(
    //                         //   borderWidth: 2,
    //                         //   color: Theme.of(context).primaryColor,
    //                         //   borderColor: Theme.of(context).accentColor,
    //                         //   fillColor: Theme.of(context).accentColor,
    //                         //   selectedColor: Colors.white,
    //                         //   selectedBorderColor: Theme.of(context).accentColor,
    //                         //   borderRadius: BorderRadius.circular(5.0),
    //                         //   children: <Widget>[
    //                         //     Text("PPD"),
    //                         //     Text("COLL"),
    //                         //   ],
    //                         //   isSelected: _selections,
    //                         //   onPressed: (int index) {
    //                         //     setState(() {
    //                         //       _selections[index] = !_selections[index];
    //                         //
    //                         //       // _selections[index] = model.chargesDeclarationOtherCharges as bool;
    //                         //     });
    //                         //   },
    //                         // ),
    //                       ],
    //                     ),
    //                     Container(
    //                       padding: EdgeInsets.only(top: 14.0),
    //                       child: Text(
    //                           S.of(context).Userate,
    //                           //"Use rate"
    //                           style: TextStyle(
    //                               color: Theme.of(context).accentColor,
    //                               // color: Colors.deepPurple,
    //                               fontWeight: FontWeight.w500, fontSize: 18.0)),
    //                     ),
    //                     Switch(
    //                       value: useRateIsEnabled,
    //                       onChanged: (value) {
    //                         setState(() {
    //                           useRateIsEnabled = value;
    //                         });
    //                       },
    //                       activeTrackColor: Theme.of(context).accentColor,
    //                       activeColor: Theme.of(context).primaryColor,
    //                     ),
    //
    //                   ],
    //                 ),
    //                 if (useRateIsEnabled)
    //                   Column(
    //                     children: [
    //                       DropdownButton<String>(
    //                           icon: Icon(Icons.arrow_drop_down),
    //                           value: calculationDropDown,
    //                           items: calculationDropDownValue
    //                               .map<DropdownMenuItem<String>>(
    //                                   (String value) {
    //                                 return DropdownMenuItem<String>(
    //                                   value: value,
    //                                   child: Text(value),
    //                                 );
    //                               }).toList(),
    //                           onChanged: (String text) {
    //                             setState(() {
    //                               calculationDropDown = text;
    //                               grossweight();
    //                             });
    //                           }),
    //                       // Padding(
    //                       //   padding: const EdgeInsets.only(bottom: 15),
    //                       //   child: TextFormField(
    //                       //     focusNode: rateFocusNode,
    //                       //     textInputAction: TextInputAction.done,
    //                       //     onFieldSubmitted: (context) =>
    //                       //         rateFocusNode.unfocus(),
    //                       //     initialValue:"0",
    //                       //     //amount1 == 0 ? "" : amount1.toString(),
    //                       //     keyboardType: TextInputType.number,
    //                       //     decoration: InputDecoration(
    //                       //       enabledBorder: OutlineInputBorder(
    //                       //           borderSide: new BorderSide(
    //                       //               color: Theme.of(context).accentColor,
    //                       //               //color: Colors.deepPurple,
    //                       //               width:2),
    //                       //           //gapPadding: 2.0,
    //                       //           borderRadius: BorderRadius.all(Radius.circular(8.0))
    //                       //       ),
    //                       //       focusedBorder: OutlineInputBorder(
    //                       //         borderSide: BorderSide(width: 2,
    //                       //           color: Theme.of(context).accentColor,
    //                       //           // color: Colors.deepPurple
    //                       //         ),
    //                       //         borderRadius: BorderRadius.circular(8.0),
    //                       //       ),
    //                       //       // border: OutlineInputBorder(
    //                       //       //     gapPadding: 2.0,
    //                       //       //     borderRadius:
    //                       //       //         BorderRadius.all(Radius.circular(8.0))),
    //                       //       labelText:
    //                       //       S.of(context).Amount,
    //                       //       labelStyle:
    //                       //       new TextStyle(
    //                       //           color: Theme.of(context).accentColor,
    //                       //           //color: Colors.deepPurple,
    //                       //           fontSize: 16.0),
    //                       //       //'Rate',
    //                       //     ),
    //                       //     onChanged: (value) {
    //                       //       amount1 = double.parse(value);
    //                       //     },
    //                       //   ),
    //                       // ),
    //                       // Padding(
    //                       //   padding: const EdgeInsets.only(bottom: 5),
    //                       //   child: DropdownButton<String>(
    //                       //       icon: Icon(Icons.arrow_drop_down),
    //                       //       value: criteriaDropDownValue,
    //                       //       items: criteriaDropDown
    //                       //           .map<DropdownMenuItem<String>>(
    //                       //               (String value) {
    //                       //             return DropdownMenuItem<String>(
    //                       //               value: value,
    //                       //               child: Text(value),
    //                       //             );
    //                       //           }).toList(),
    //                       //       onChanged: (String text) {
    //                       //         setState(() {
    //                       //           criteriaDropDownValue = text;
    //                       //           if(criteriaDropDownValue=="Gross Weight") {
    //                       //             model.rateDescriptionItemList.forEach((
    //                       //                 element) {
    //                       //               print("mnop.............");
    //                       //               totalgrossweight =
    //                       //                   element.grossWeight.toInt();
    //                       //               print(element.grossWeight);
    //                       //               print(element.chargeableWeight);
    //                       //               amount = totalgrossweight;
    //                       //               print(
    //                       //                   "Gross total" + amount.toString());
    //                       //             });
    //                       //             minimumvaluechange = ratevaluechange * 4;
    //                       //             amountvalue =
    //                       //                 TextEditingController(
    //                       //                     text: minimumvaluechange
    //                       //                         .toString());
    //                       //             minimumvaluechange = ratevaluechange;
    //                       //           }
    //                       //           grossweight();
    //                       //         });
    //                       //       }),
    //                       // ),
    //                       SizedBox(
    //                         height: 5,
    //                       ),
    //                       // ! Rate....
    //                       // Padding(
    //                       //   padding: const EdgeInsets.only(bottom: 15),
    //                       //   child: TextFormField(
    //                       //     focusNode: rateFocusNode,
    //                       //     textInputAction: TextInputAction.done,
    //                       //     onFieldSubmitted: (context) =>
    //                       //         rateFocusNode.unfocus(),
    //                       //     initialValue: rate == 0 ? "" : rate.toString(),
    //                       //     keyboardType: TextInputType.number,
    //                       //     decoration: InputDecoration(
    //                       //       enabledBorder: OutlineInputBorder(
    //                       //           borderSide: new BorderSide(
    //                       //               color: Theme.of(context).accentColor,
    //                       //             //color: Colors.deepPurple,
    //                       //               width:2),
    //                       //           //gapPadding: 2.0,
    //                       //           borderRadius: BorderRadius.all(Radius.circular(8.0))
    //                       //       ),
    //                       //       focusedBorder: OutlineInputBorder(
    //                       //         borderSide: BorderSide(width: 2,
    //                       //           color: Theme.of(context).accentColor,
    //                       //           // color: Colors.deepPurple
    //                       //         ),
    //                       //         borderRadius: BorderRadius.circular(8.0),
    //                       //       ),
    //                       //       // border: OutlineInputBorder(
    //                       //       //     gapPadding: 2.0,
    //                       //       //     borderRadius:
    //                       //       //         BorderRadius.all(Radius.circular(8.0))),
    //                       //       labelText:
    //                       //  S.of(context).Rate,
    //                       //       labelStyle:
    //                       //       new TextStyle(
    //                       //           color: Theme.of(context).accentColor,
    //                       //         //color: Colors.deepPurple,
    //                       //           fontSize: 16.0),
    //                       //       //'Rate',
    //                       //     ),
    //                       //     onChanged: (value) {
    //                       //       rate = double.parse(value);
    //                       //     },
    //                       //   ),
    //                       // ),
    //                       // // ! Criteria....
    //
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Expanded(
    //                             flex: 1,
    //                             child: TextFormField(
    //                                controller: this.ratevalue,
    //                               //
    //                               // focusNode: minimumFocusNode,
    //                               // // textDirection: TextDirection.ltr,
    //                               // textInputAction: TextInputAction.done,
    //                               // onFieldSubmitted: (value) =>
    //                               //     minimumFocusNode.unfocus(),
    //                               // initialValue:
    //                               //     minimum == 0 ? "" : minimum.toString(),
    //                               keyboardType: TextInputType.number,
    //                               decoration: InputDecoration(
    //                                 enabledBorder: OutlineInputBorder(
    //                                     borderSide: new BorderSide(
    //                                       color: Theme.of(context).accentColor,
    //                                       //color: Colors.deepPurple,
    //                                       width:2,
    //                                     ),
    //                                     //gapPadding: 2.0,
    //                                     borderRadius: BorderRadius.all(Radius.circular(8.0))
    //                                 ),
    //                                 focusedBorder: OutlineInputBorder(
    //                                   borderSide: BorderSide(width: 2,
    //                                     color: Theme.of(context).accentColor,
    //                                     //  color: Colors.deepPurple
    //                                   ),
    //                                   borderRadius: BorderRadius.circular(8.0),
    //                                 ),
    //                                 // border: OutlineInputBorder(
    //                                 //     gapPadding: 2.0,
    //                                 //     borderRadius:
    //                                 //         BorderRadius.all(Radius.circular(8.0))),
    //                                 labelText:
    //                                "Rate",
    //                                 // S.of(context).Minimum,
    //                                 labelStyle:
    //                                 new TextStyle(
    //                                     color: Theme.of(context).accentColor,
    //                                     // color: Colors.deepPurple,
    //                                     fontSize: 16.0),
    //                                 //'Minimum',
    //                               ),
    //                               // onChanged: (value) {
    //                               //   // grossweight();
    //                               //   // this.minimumvalue.text=value;
    //                               //   // ratevalue=int.parse(value);
    //                               //   grossweight();
    //                               //   //amount=int.parse(value);
    //                               //   // minimum = double.parse(value);
    //                               // },
    //                             ),
    //                           ),
    //                           SizedBox(
    //                             width: 4,
    //                           ),
    //                           Text("x"),
    //                           SizedBox(
    //                             width: 4,
    //                           ),
    //                           Expanded(
    //                             child: Padding(
    //                               padding: const EdgeInsets.only(bottom: 5),
    //                               child: DropdownButton<String>(
    //                                   icon: Icon(Icons.arrow_drop_down),
    //                                   value: criteriaDropDownValue,
    //                                   items: criteriaDropDown
    //                                       .map<DropdownMenuItem<String>>(
    //                                           (String value) {
    //                                         return DropdownMenuItem<String>(
    //                                           value: value,
    //                                           child: Text(value),
    //                                         );
    //                                       }).toList(),
    //                                   onChanged: (String text) {
    //                                     setState(() {
    //                                       criteriaDropDownValue = text;
    //                                       print("Criteria  "+criteriaDropDownValue);
    //                                       if(criteriaDropDownValue=="Gross Weight") {
    //                                         print(model.rateDescriptionItemList);
    //                                         model.rateDescriptionItemList.forEach((
    //                                             element) {
    //                                           print("mnop.............");
    //                                           totalgrossweight =
    //                                               element.grossWeight.toInt();
    //                                           print(element.grossWeight);
    //                                           print(element.chargeableWeight);
    //                                           amount = totalgrossweight;
    //                                           print(
    //                                               "Gross total" + amount.toString());
    //                                         });
    //                                         minimumvaluechange = ratevaluechange * 4;
    //                                         amountvalue =
    //                                             TextEditingController(
    //                                                 text: minimumvaluechange
    //                                                     .toString());
    //                                         minimumvaluechange = ratevaluechange;
    //                                       }
    //                                       grossweight();
    //                                     });
    //                                   }),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                       SizedBox(
    //                         height: 15,
    //                       ),
    //                       // ! Minimum....
    //                       Padding(
    //                         padding: const EdgeInsets.only(bottom: 15),
    //                         child: TextFormField(
    //                            controller: this.amountvalue,
    //
    //                           focusNode: minimumFocusNode,
    //                          // textDirection: TextDirection.ltr,
    //                           textInputAction: TextInputAction.done,
    //                           onFieldSubmitted: (value) =>
    //                               minimumFocusNode.unfocus(),
    //                           // initialValue:
    //                           //     minimum == 0 ? "" : minimum.toString(),
    //                           keyboardType: TextInputType.number,
    //                           decoration: InputDecoration(
    //                               enabledBorder: OutlineInputBorder(
    //                                   borderSide: new BorderSide(
    //                                       color: Theme.of(context).accentColor,
    //                                     //color: Colors.deepPurple,
    //                                       width:2,
    //                                   ),
    //                                   //gapPadding: 2.0,
    //                                   borderRadius: BorderRadius.all(Radius.circular(8.0))
    //                               ),
    //                               focusedBorder: OutlineInputBorder(
    //                                 borderSide: BorderSide(width: 2,
    //                                   color: Theme.of(context).accentColor,
    //                                   //  color: Colors.deepPurple
    //                                 ),
    //                                 borderRadius: BorderRadius.circular(8.0),
    //                               ),
    //                             // border: OutlineInputBorder(
    //                             //     gapPadding: 2.0,
    //                             //     borderRadius:
    //                             //         BorderRadius.all(Radius.circular(8.0))),
    //                             labelText:
    //                         S.of(context).Minimum,
    //                             labelStyle:
    //                             new TextStyle(
    //                                 color: Theme.of(context).accentColor,
    //                               // color: Colors.deepPurple,
    //                                 fontSize: 16.0),
    //                           //'Minimum',
    //                           ),
    //                           // onChanged: (value) {
    //                           //   grossweight();
    //                           //   // this.minimumvalue.text=value;
    //                           //   amount=int.parse(value);
    //                           //   // minimum = double.parse(value);
    //                           // },
    //                         ),
    //                       ),
    //                       Text(amount.toString())
    //                     ],
    //                   )
    //                 else
    //                   Container(), // ? Empty....
    //                 // ! Dialog Buttons....
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.end,
    //                   mainAxisSize: MainAxisSize.max,
    //                   children: <Widget>[
    //                     Padding(
    //                       padding:  EdgeInsets.only(bottom: 15, right: 8),
    //                       child: FlatButton(
    //                         textColor: Colors.black,
    //                         color: Theme.of(context).accentColor,
    //                         onPressed: () {
    //                           Navigator.of(context).pop(null);
    //                         },
    //                         child: Text(
    //                            S.of(context).Close,
    //                         // "Close"
    //                         ),
    //                       ),
    //                     ),
    //                     // ! ADD ....
    //                     Padding(
    //                       padding: const EdgeInsets.only(bottom: 15),
    //                       child: FlatButton(
    //                          // textColor: Colors.black,
    //                           color: Theme.of(context).accentColor,
    //                           onPressed: () {
    //                             Navigator.of(context).pop(OtherChargesItem(
    //                                 description: description,
    //                                 amount: amount,
    //                                 entitlement: entitlementValue,
    //                                 useRate: useRateIsEnabled,
    //                                 rate: rate,
    //                                 weight: weight,
    //                                 prepaidcollect: prepaidrcollect,
    //                                 minimum: minimum));
    //                           },
    //                           child: Text(
    //                                 S.of(context).Add
    //                                  // "Add"
    //                       )),
    //                     ),
    //                   ],
    //                 ),
    //                 Text(totalgrossweight.toString()),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  grossweight(EAWBModel model, int ratevaluechange) {
    if(calculationDropDown=="(rate x quantity) or minimum") {
      if (criteriaDropDownValue ==
          "Gross Weight") {
        print(model
            .rateDescriptionItemList);
        model.rateDescriptionItemList
            .forEach((element) {
          print("mnop.............");
          totalgrossweight +=
              element.grossWeight
                  .toInt();
          // totalchargeableweight+=
          // element.chargeableWeight;
          // noofpieces+=element.pieces;
          print("Gross weight" +
              element.grossWeight
                  .toString());
          print("chargeableweight" +
              element.chargeableWeight
                  .toString());
          // amount = totalgrossweight;
          print(
              "Gross total" +
                  amount.toString());
        });
        int grossweightvalue = totalgrossweight *
            ratevaluechange;
        print("grossweightvalue" +
            grossweightvalue
                .toString());
        // minimumvaluechange =
        //     ratevaluechange * 4;
        amountvalue =
            TextEditingController(
                text: grossweightvalue
                    .toString());
        // minimumvaluechange = ratevaluechange;
      }
      if (criteriaDropDownValue ==
          "Chargeable Weight") {
        print(model
            .rateDescriptionItemList);
        model.rateDescriptionItemList
            .forEach((element) {
          print("mnop.............");
          totalchargeableweight +=
              element
                  .chargeableWeight;
          // noofpieces+=element.pieces;
          print("Gross weight" +
              element.grossWeight
                  .toString());
          print("chargeableweight" +
              element.chargeableWeight
                  .toString());
          // amount = totalgrossweight;
          print(
              "Gross total" +
                  amount.toString());
        });
        int chargeableweightvalue = totalchargeableweight *
            ratevaluechange;
        print("grossweightvalue" +
            chargeableweightvalue
                .toString());
        // minimumvaluechange = ratevaluechange * 4;
        amountvalue =
            TextEditingController(
                text: chargeableweightvalue
                    .toString());
      }
      if (criteriaDropDownValue ==
          "No. of pieces") {
        print(model
            .rateDescriptionItemList);
        model.rateDescriptionItemList
            .forEach((element) {
          print("mnop.............");
          // totalchargeableweight+=
          // element.chargeableWeight;
          noofpieces +=
              element.pieces;
          print("no of pieces" +
              element.pieces
                  .toString());
          print("chargeableweight" +
              element.chargeableWeight
                  .toString());
          // amount = totalgrossweight;
          print(
              "Gross total" +
                  amount.toString());
        });
        int noofpiecesvalue = noofpieces *
            ratevaluechange;
        print("noofpiecesvalue" +
            noofpiecesvalue
                .toString());
        // minimumvaluechange = ratevaluechange * 4;
        amountvalue =
            TextEditingController(
                text: noofpiecesvalue
                    .toString());
        // minimumvaluechange = ratevaluechange;
      }
      if (criteriaDropDownValue ==
          "Charges due Carrier") {
        print(model
            .rateDescriptionItemList);
        model.rateDescriptionItemList
            .forEach((element) {
          print("mnop.............");
          // totalchargeableweight+=
          // element.chargeableWeight;
          ChargesdueCarrier +=
              element.total;
          print("no of pieces" +
              element.total
                  .toString());
          print("chargeableweight" +
              element.chargeableWeight
                  .toString());
          // amount = totalgrossweight;
          print(
              "Gross total" +
                  ChargesdueCarrier
                      .toString());
        });
        int ChargesdueCarriervalue = ChargesdueCarrier *
            ratevaluechange;
        print("noofpiecesvalue" +
            ChargesdueCarriervalue
                .toString());
        // minimumvaluechange = ratevaluechange * 4;
        amountvalue =
            TextEditingController(
                text: ChargesdueCarriervalue
                    .toString());
        // minimumvaluechange = ratevaluechange;
      }
      if (criteriaDropDownValue ==
          "Charges due agent") {
        if(prepaidrcollect=="PPD") {
          dueagentvalue = model
              .chargeSummaryDueAgentPrepaid;
          Chargesdueagent =
              int.parse(
                  dueagentvalue) *
                  ratevaluechange;
          amountvalue =
              TextEditingController(
                  text: Chargesdueagent
                      .toString());
          print("Charrrge" +
              Chargesdueagent
                  .toString());
        }
        else{
          dueagentvalue = model
              .chargeSummaryDueAgentPostpaid;
          Chargesdueagent =
              int.parse(
                  dueagentvalue) *
                  ratevaluechange;
          amountvalue =
              TextEditingController(
                  text: Chargesdueagent
                      .toString());
          print("Charrrge" +
              Chargesdueagent
                  .toString());

        }
      }
    }
    else
    {
      if (criteriaDropDownValue ==
          "Gross Weight") {
        print(model
            .rateDescriptionItemList);
        model.rateDescriptionItemList
            .forEach((element) {
          print("mnop.............");
          totalgrossweight +=
              element.grossWeight
                  .toInt();
          // totalchargeableweight+=
          // element.chargeableWeight;
          // noofpieces+=element.pieces;
          print("Gross weight" +
              element.grossWeight
                  .toString());
          print("chargeableweight" +
              element.chargeableWeight
                  .toString());
          // amount = totalgrossweight;
          print(
              "Gross total" +
                  amount.toString());
        });
        int grossweightvalue =minimumvalue+ totalgrossweight *
            ratevaluechange;
        print("grossweightvalue" +
            grossweightvalue
                .toString());
        minimumvaluechange =
            ratevaluechange * 4;
        amountvalue =
            TextEditingController(
                text: grossweightvalue
                    .toString());
        // minimumvaluechange = ratevaluechange;
      }
      if (criteriaDropDownValue ==
          "Chargeable Weight") {
        print(model
            .rateDescriptionItemList);
        model.rateDescriptionItemList
            .forEach((element) {
          print("mnop.............");
          totalchargeableweight +=
              element
                  .chargeableWeight;
          // noofpieces+=element.pieces;
          print("Gross weight" +
              element.grossWeight
                  .toString());
          print("chargeableweight" +
              element.chargeableWeight
                  .toString());
          // amount = totalgrossweight;
          print(
              "Gross total" +
                  amount.toString());
        });
        int chargeableweightvalue = minimumvalue + totalchargeableweight *
            ratevaluechange;
        print("grossweightvalue" +
            chargeableweightvalue
                .toString());
        // minimumvaluechange = ratevaluechange * 4;
        amountvalue =
            TextEditingController(
                text: chargeableweightvalue
                    .toString());
      }
      if (criteriaDropDownValue ==
          "No. of pieces") {
        print(model
            .rateDescriptionItemList);
        model.rateDescriptionItemList
            .forEach((element) {
          print("mnop.............");
          // totalchargeableweight+=
          // element.chargeableWeight;
          noofpieces +=
              element.pieces;
          print("no of pieces" +
              element.pieces
                  .toString());
          print("chargeableweight" +
              element.chargeableWeight
                  .toString());
          // amount = totalgrossweight;
          print(
              "Gross total" +
                  amount.toString());
        });
        int noofpiecesvalue =minimumvalue+ noofpieces *
            ratevaluechange;
        print("noofpiecesvalue" +
            noofpiecesvalue
                .toString());
        // minimumvaluechange = ratevaluechange * 4;
        amountvalue =
            TextEditingController(
                text: noofpiecesvalue
                    .toString());
        // minimumvaluechange = ratevaluechange;
      }
      if (criteriaDropDownValue ==
          "Charges due Carrier") {
        print(model
            .rateDescriptionItemList);
        model.rateDescriptionItemList
            .forEach((element) {
          print("mnop.............");
          // totalchargeableweight+=
          // element.chargeableWeight;
          ChargesdueCarrier +=
              element.total;
          print("no of pieces" +
              element.total
                  .toString());
          print("chargeableweight" +
              element.chargeableWeight
                  .toString());
          // amount = totalgrossweight;
          print(
              "Gross total" +
                  ChargesdueCarrier
                      .toString());
        });
        ChargesdueCarriervalue =minimumvalue + ChargesdueCarrier *
            ratevaluechange;
        print("noofpiecesvalue" +
            ChargesdueCarriervalue
                .toString());
        // minimumvaluechange = ratevaluechange * 4;
        amountvalue =
            TextEditingController(
                text: ChargesdueCarriervalue
                    .toString());
        // minimumvaluechange = ratevaluechange;
      }
      if (criteriaDropDownValue ==
          "Charges due agent") {
        if(prepaidrcollect=="PPD") {
          dueagentvalue = model
              .chargeSummaryDueAgentPrepaid;
          Chargesdueagent =
              minimumvalue + int.parse(
                  dueagentvalue) *
                  ratevaluechange;
          amountvalue =
              TextEditingController(
                  text: Chargesdueagent
                      .toString());
          print("Charrrge" +
              Chargesdueagent
                  .toString());
        }
        else{
          String dueagentvalue = model
              .chargeSummaryDueAgentPostpaid;
          Chargesdueagent =
              minimumvalue+
                  int.parse(
                      dueagentvalue) *
                      ratevaluechange;
          amountvalue =
              TextEditingController(
                  text: Chargesdueagent
                      .toString());
          print("Charrrge" +
              Chargesdueagent.toString());

        }
      }
    }
    }

  }
class ChargeCode {
  String ChargCode;
  String Chargename;

  ChargeCode(this.ChargCode, this.Chargename);
}

