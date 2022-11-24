import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/ui/drodowns/airport_code.dart';
import 'package:rooster/ui/drodowns/special_code.dart';
import 'package:rooster/ui/eawb/carriers_execution.dart';
import 'package:rooster/ui/eawb/static/custom_background.dart';

import '../../formatter.dart';

class SpecialHandling extends StatefulWidget {
  SpecialHandling({Key key}) : super(key: key);

  @override
  _SpecialHandlingState createState() => _SpecialHandlingState();
}

class _SpecialHandlingState extends State<SpecialHandling> {
  final _specialhandleFormKey = GlobalKey<FormState>();
  // EAWBModel model;

  List<Map<String, dynamic>> specialCodeList = [];
  final TextEditingController shcontroller = TextEditingController();

  final TextEditingController shccontroller1 = TextEditingController();
  final TextEditingController shccontroller2 = TextEditingController();
  final TextEditingController shccontroller3 = TextEditingController();
  final TextEditingController shccontroller4 = TextEditingController();
  final TextEditingController shccontroller5 = TextEditingController();
  final TextEditingController shccontroller7 = TextEditingController();
  final TextEditingController shccontroller6 = TextEditingController();
  final TextEditingController shccontroller8 = TextEditingController();
  final TextEditingController shccontroller9 = TextEditingController();
  final TextEditingController shccontrollermultiple = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // FocusNode _consigneeAccountNumberFocusNode = FocusNode();
  // FocusNode _consigneeNameFocusNode = FocusNode();
  // FocusNode _consigneeAddressFocusNode = FocusNode();
  //
  // int _addressMaxLinesCount;
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
              previous: CarriersExecution(),
              // next: IssuingCarriersAgent(),
              name: "Handling Information",
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
                                      leading: Icon(Icons.code,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Special Handling Code"),
                                      subtitle: Text("Code indicating that nature of consignment may necessitate use of special handling procedures\nExample: EAT "),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.perm_device_info,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Other Service Information"),
                                      subtitle: Text("Remarks relating to a shipment \nExample: EXTRA CHARGE DUE TO SPECIAL HANDLING REQUIREMENTS"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.request_quote_outlined,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Special Service Request"),
                                      subtitle: Text("Information related to instructions for special action required\nExample: MUST BE KEPT ABOVE 5 DEGREES CELSIUS"),
                                    ),
                                  ),  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.request_quote_outlined,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("SCI"),
                                      subtitle: Text("Information related to instructions for special action required\nExample: T1"),
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
                    key: _specialhandleFormKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          // buildSpecialRequirements(model),
                          // sph11(model),
                          Row(
                            children: [
                              // ! houseDetailsOrigin....
                              Expanded(
                                child: shc1(model),
                              ),
                              // ! houseDetailsDestination....
                              Expanded(
                                child: shc2(model),
                              ),
                              Expanded(
                                child: shc3(model),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // ! houseDetailsOrigin....
                              Expanded(
                                child: shc4(model),
                              ),
                              // ! houseDetailsDestination....
                              Expanded(
                                child: shc5(model),
                              ),
                              Expanded(
                                child: shc6(model),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // ! houseDetailsOrigin....
                              Expanded(
                                child: shc7(model),
                              ),
                              // ! houseDetailsDestination....
                              Expanded(
                                child: shc8(model),
                              ),
                              Expanded(
                                child: shc9(model),
                              ),
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     // ! houseDetailsOrigin....
                          //     Expanded(
                          //       child: shc7(model),
                          //     ),
                          //     // ! houseDetailsDestination....
                          //     Expanded(
                          //       child: shc8(model),
                          //     ),
                          //   ],
                          // ),
                          // shc9(model),
                          specialservicereq(model),
                          otherinfo(model),
                          sci(model),
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

  Widget buildSpecialRequirements(EAWBModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
            child: Text(
              S.of(context).SpecialRequirements,
              // "Special Requirements",
              style: TextStyle(
                color: Theme.of(context).accentColor,
                //  decoration: TextDecoration.underline,
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 8,
                child: Text(
                  S.of(context).AddSpecialCode,
                  style: TextStyle(color: Theme.of(context).accentColor),
                  //  "Add Special Code"
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  color: Theme.of(context).accentColor,
                  icon: Icon(
                    Icons.delete,
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      specialCodeList
                          .removeWhere((element) => element['isSelected']);
                    });
                  },
                ),
              ),
              Expanded(
                flex: 5,
                child: IconButton(
                  color: Theme.of(context).accentColor,
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      specialCodeList.add({
                        'isSelected': false,
                        'specialcode': "",
                      });
                    });
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Builder(
                    builder: (context) => DataTable(
                      columnSpacing: 5,
                      columns: [
                        DataColumn(
                            label: Text(
                          S.of(context).SpecialCode,
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                          // 'Special Code'
                        )),
                      ],
                      rows: List<DataRow>.generate(
                        specialCodeList.length,
                        (index) => addSpecialCode(index, model),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  sph11(EAWBModel model) {
    this.shcontroller.text = model.SPH1;
    TypeAheadFormField<SpecialCode>(
        suggestionsCallback: SpecialCodeApi.getSpecialCode,
        itemBuilder: (context, SpecialCode suggestion) {
          final code = suggestion;
          return ListTile(
            title: Text(
              code.codeType,
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            subtitle: Text(
              code.codeName,
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          );
        },
        // initialValue: model.SPH1,
        validator: (value) {
          if (value.isEmpty) {
            return
              S.of(context).SelectaSpecialCode;
              //'Select a SpecialCode';
          }
          return null;
        },
        // initialValue:
        //     specialCodeList[dimensionIndex]['specialcode'] == ""
        //         ? ''
        //         : '${specialCodeList[dimensionIndex]['specialcode']}',
        textFieldConfiguration: TextFieldConfiguration(
          controller: this.shcontroller,
          autofocus: false,
          // inputFormatters: [AllCapitalCase()],
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).accentColor),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            //border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).accentColor),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            border: OutlineInputBorder(
                gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText:
            //"SPh",
            S.of(context).Sph,
            labelStyle: TextStyle(color: Theme.of(context).accentColor),
            //'SpecialCode',
          ),
        ),
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        onSuggestionSelected: (SpecialCode suggestion) {
          print(suggestion);
          this.shcontroller.text = suggestion.codeType;
          // specialCodeList[index]['specialcode'] =
          //     suggestion.codeType;
          model.SPH1 = suggestion.codeType;
          //print(destination);
        });
  }

  addSpecialCode(int dimensionIndex, EAWBModel model) {
    List<String> modelList = [
      model.SPH1,
      model.SPH2,
      model.SPH3,
      model.SPH4,
      model.SPH5,
      model.SPH6,
      model.SPH7,
      model.SPH8,
      model.SPH9
    ];
    print(modelList);
    this.shccontrollermultiple.text = modelList[dimensionIndex];

    return DataRow(
        key: ValueKey(specialCodeList[dimensionIndex]),
        // ! Very Important key for Delete the value....
        selected: specialCodeList[dimensionIndex]['isSelected'],
        onSelectChanged: (value) {
          setState(() {
            specialCodeList[dimensionIndex]['isSelected'] =
                !specialCodeList[dimensionIndex]['isSelected'];
          });
        },
        cells: [
          DataCell(
              // TextFormField(
              //   initialValue: specialCodeList[dimensionIndex]['specialcode'] == ""
              //       ? ''
              //       : '${specialCodeList[dimensionIndex]['specialcode']}',
              //   onChanged: (value) {
              //     setState(() {
              //       specialCodeList[dimensionIndex]['specialcode'] = value;
              //     });
              //   },
              //   keyboardType: TextInputType.text,
              //   inputFormatters: [AllCapitalCase()],
              //   maxLength: 3,
              //),

              TypeAheadFormField<SpecialCode>(
                  suggestionsCallback: SpecialCodeApi.getSpecialCode,
                  itemBuilder: (context, SpecialCode suggestion) {
                    final code = suggestion;
                    return ListTile(
                      title: Text(
                        code.codeType,
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                      subtitle: Text(
                        code.codeName,
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return
                        S.of(context).SelectaSpecialCode;
                        //'Select a SpecialCode';
                    }
                    return null;
                  },
                  // initialValue:
                  //     specialCodeList[dimensionIndex]['specialcode'] == ""
                  //         ? ''
                  //         : '${specialCodeList[dimensionIndex]['specialcode']}',
                  textFieldConfiguration: TextFieldConfiguration(
                    autofocus: false,
                    controller: this.shccontrollermultiple,
                    // inputFormatters: [AllCapitalCase()],
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).accentColor),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      //border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).accentColor),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      border: OutlineInputBorder(
                          gapPadding: 2.0,
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      labelText:
                      S.of(context).Sph,
                      //"SPH",
                      //S.of(context).SpecialCode,
                      labelStyle:
                          TextStyle(color: Theme.of(context).accentColor),
                      //'SpecialCode',
                    ),
                  ),
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSuggestionSelected: (SpecialCode suggestion) {
                    print(suggestion);
                    this.shccontrollermultiple.text = suggestion.codeType;
                    specialCodeList[dimensionIndex]['specialcode'] =
                        suggestion.codeType;
                    modelList[dimensionIndex] = suggestion.codeType;
                    print(modelList[dimensionIndex]);
                    print(dimensionIndex);
                    // model.SPH1 =suggestion.codeType;

                    //print(destination);
                  })), // DataColumn(label: Text('Length')),
        ]);
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  shc1(EAWBModel model) {
    this.shccontroller1.text = model.SPH1;
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TypeAheadFormField<SpecialHandlingGroup>(
          suggestionsCallback: SpecialHandlingGroupApi.getSpecialHandlingCode,
          itemBuilder: (context, SpecialHandlingGroup suggestion) {
            final code = suggestion;
            return ListTile(
              title: Text(
                code.shgCode,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              subtitle: Text(
                code.shgName,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            );
          },
          //  initialValue: model.SPH1,
          // onSaved: (value) {
          //   model.SPH1 = value;
          // },
          validator: (value) {
            if (value.isEmpty) {
              return
                S.of(context).SelectaSpecialCode;
                //'Select a SpecialCode';
            }
            return null;
          },
          // initialValue:
          //     specialCodeList[dimensionIndex]['specialcode'] == ""
          //         ? ''
          //         : '${specialCodeList[dimensionIndex]['specialcode']}',
          textFieldConfiguration: TextFieldConfiguration(
            controller: this.shccontroller1,
            autofocus: false,
            // inputFormatters: [AllCapitalCase()],
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              border: OutlineInputBorder(
                  gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText:
              S.of(context).Sph +"1",
              //"SPH1",
              //S.of(context).SpecialCode,
              labelStyle: TextStyle(color: Theme.of(context).accentColor),
              //'SpecialCode',
            ),
          ),
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          onSuggestionSelected: (SpecialHandlingGroup suggestion) {
            print(suggestion);
            this.shccontroller1.text = suggestion.shgCode;
            // specialCodeList[index]['specialcode'] =
            //     suggestion.codeType;
            model.SPH1 = suggestion.shgCode;
            //print(destination);
          }),
    );
  }

  shc2(EAWBModel model) {
    this.shccontroller2.text = model.SPH2;
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TypeAheadFormField<SpecialHandlingGroup>(
          suggestionsCallback: SpecialHandlingGroupApi.getSpecialHandlingCode,
          itemBuilder: (context, SpecialHandlingGroup suggestion) {
            final code = suggestion;
            return ListTile(
              title: Text(
                code.shgCode,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              subtitle: Text(
                code.shgName,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            );
          },
          // initialValue: model.SPH2,
          // onSaved: (value) {
          //   model.SPH2 = value;
          // },
          validator: (value) {
            if (value.isEmpty) {
              return
                S.of(context).SelectaSpecialCode;
                //'Select a SpecialCode';
            }
            return null;
          },
          // initialValue:
          //     specialCodeList[dimensionIndex]['specialcode'] == ""
          //         ? ''
          //         : '${specialCodeList[dimensionIndex]['specialcode']}',
          textFieldConfiguration: TextFieldConfiguration(
            controller: this.shccontroller2,
            autofocus: false,
            // inputFormatters: [AllCapitalCase()],
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              border: OutlineInputBorder(
                  gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText:
              S.of(context).Sph +"2",
              //"SPH2",
              //S.of(context).SpecialCode,
              labelStyle: TextStyle(color: Theme.of(context).accentColor),
              //'SpecialCode',
            ),
          ),
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          onSuggestionSelected: (SpecialHandlingGroup suggestion) {
            print(suggestion);
            this.shccontroller2.text = suggestion.shgCode;
            // specialCodeList[index]['specialcode'] =
            //     suggestion.codeType;
            model.SPH2 = suggestion.shgCode;
            //print(destination);
          }),
    );
  }

  shc3(EAWBModel model) {
    this.shccontroller3.text = model.SPH3;
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TypeAheadFormField<SpecialHandlingGroup>(
          suggestionsCallback: SpecialHandlingGroupApi.getSpecialHandlingCode,
          itemBuilder: (context, SpecialHandlingGroup suggestion) {
            final code = suggestion;
            return ListTile(
              title: Text(
                code.shgCode,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              subtitle: Text(
                code.shgName,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            );
          },
          // initialValue: model.SPH3,
          // onSaved: (value) {
          //   model.SPH3 = value;
          // },
          validator: (value) {
            if (value.isEmpty) {
              return
                S.of(context).SpecialCode;
                //'Select a SpecialCode';
            }
            return null;
          },
          // initialValue:
          //     specialCodeList[dimensionIndex]['specialcode'] == ""
          //         ? ''
          //         : '${specialCodeList[dimensionIndex]['specialcode']}',
          textFieldConfiguration: TextFieldConfiguration(
            controller: this.shccontroller3,
            autofocus: false,
            // inputFormatters: [AllCapitalCase()],
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              border: OutlineInputBorder(
                  gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText:
              S.of(context).Sph +"3",
              //"SPH3",
              //S.of(context).SpecialCode,
              labelStyle: TextStyle(color: Theme.of(context).accentColor),
              //'SpecialCode',
            ),
          ),
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          onSuggestionSelected: (SpecialHandlingGroup suggestion) {
            print(suggestion);
            this.shccontroller3.text = suggestion.shgCode;
            // specialCodeList[index]['specialcode'] =
            //     suggestion.codeType;
            model.SPH3 = suggestion.shgCode;
            //print(destination);
          }),
    );
  }

  shc4(EAWBModel model) {
    this.shccontroller4.text = model.SPH4;
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TypeAheadFormField<SpecialHandlingGroup>(
          suggestionsCallback: SpecialHandlingGroupApi.getSpecialHandlingCode,
          itemBuilder: (context, SpecialHandlingGroup suggestion) {
            final code = suggestion;
            return ListTile(
              title: Text(
                code.shgCode,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              subtitle: Text(
                code.shgName,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            );
          },
          // initialValue: model.SPH4,
          // onSaved: (value) {
          //   model.SPH4 = value;
          // },
          validator: (value) {
            if (value.isEmpty) {
              return
                S.of(context).SelectaSpecialCode;
                //'Select a SpecialCode';
            }
            return null;
          },
          // initialValue:
          //     specialCodeList[dimensionIndex]['specialcode'] == ""
          //         ? ''
          //         : '${specialCodeList[dimensionIndex]['specialcode']}',
          textFieldConfiguration: TextFieldConfiguration(
            controller: shccontroller4,
            autofocus: false,
            // inputFormatters: [AllCapitalCase()],
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              border: OutlineInputBorder(
                  gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText: "SPH4",
              //S.of(context).SpecialCode,
              labelStyle: TextStyle(color: Theme.of(context).accentColor),
              //'SpecialCode',
            ),
          ),
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          onSuggestionSelected: (SpecialHandlingGroup suggestion) {
            print(suggestion);
            this.shccontroller4.text = suggestion.shgCode;
            // specialCodeList[index]['specialcode'] =
            //     suggestion.codeType;
            model.SPH4 = suggestion.shgCode;
            //print(destination);
          }),
    );
  }

  shc5(EAWBModel model) {
    this.shccontroller5.text = model.SPH5;
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TypeAheadFormField<SpecialHandlingGroup>(
          suggestionsCallback: SpecialHandlingGroupApi.getSpecialHandlingCode,
          itemBuilder: (context, SpecialHandlingGroup suggestion) {
            final code = suggestion;
            return ListTile(
              title: Text(
                code.shgCode,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              subtitle: Text(
                code.shgName,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            );
          },
          // initialValue: model.SPH5,
          // onSaved: (value) {
          //   model.SPH5 = value;
          // },
          validator: (value) {
            if (value.isEmpty) {
              return
                S.of(context).SelectaSpecialCode;
                //'Select a SpecialCode';
            }
            return null;
          },
          // initialValue:
          //     specialCodeList[dimensionIndex]['specialcode'] == ""
          //         ? ''
          //         : '${specialCodeList[dimensionIndex]['specialcode']}',
          textFieldConfiguration: TextFieldConfiguration(
            controller: shccontroller5,
            autofocus: false,
            // inputFormatters: [AllCapitalCase()],
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              border: OutlineInputBorder(
                  gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText:
              S.of(context).Sph +"5",
              //"SPH5",
              //S.of(context).SpecialCode,
              labelStyle: TextStyle(color: Theme.of(context).accentColor),
              //'SpecialCode',
            ),
          ),
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          onSuggestionSelected: (SpecialHandlingGroup suggestion) {
            print(suggestion);
            this.shccontroller5.text = suggestion.shgCode;
            // specialCodeList[index]['specialcode'] =
            //     suggestion.codeType;
            model.SPH5 = suggestion.shgCode;
            //print(destination);
          }),
    );
  }

  shc6(EAWBModel model) {
    this.shccontroller6.text = model.SPH6;
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TypeAheadFormField<SpecialHandlingGroup>(
          suggestionsCallback: SpecialHandlingGroupApi.getSpecialHandlingCode,
          itemBuilder: (context, SpecialHandlingGroup suggestion) {
            final code = suggestion;
            return ListTile(
              title: Text(
                code.shgCode,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              subtitle: Text(
                code.shgName,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            );
          },
          //initialValue: model.SPH6,
          // onSaved: (value) {
          //   model.SPH6 = value;
          // },
          validator: (value) {
            if (value.isEmpty) {
              return
                S.of(context).SelectaSpecialCode;
                //'Select a SpecialCode';
            }
            return null;
          },
          // initialValue:
          //     specialCodeList[dimensionIndex]['specialcode'] == ""
          //         ? ''
          //         : '${specialCodeList[dimensionIndex]['specialcode']}',
          textFieldConfiguration: TextFieldConfiguration(
            controller: this.shccontroller6,
            autofocus: false,
            // inputFormatters: [AllCapitalCase()],
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              border: OutlineInputBorder(
                  gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText:
              S.of(context).Sph +"6",
              //"SPH6",
              //S.of(context).SpecialCode,
              labelStyle: TextStyle(color: Theme.of(context).accentColor),
              //'SpecialCode',
            ),
          ),
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          onSuggestionSelected: (SpecialHandlingGroup suggestion) {
            print(suggestion);
            this.shccontroller6.text = suggestion.shgCode;
            // specialCodeList[index]['specialcode'] =
            //     suggestion.codeType;
            model.SPH6 = suggestion.shgCode;
            //print(destination);
          }),
    );
  }

  shc7(EAWBModel model) {
    this.shccontroller7.text = model.SPH7;
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TypeAheadFormField<SpecialHandlingGroup>(
          suggestionsCallback: SpecialHandlingGroupApi.getSpecialHandlingCode,
          itemBuilder: (context, SpecialHandlingGroup suggestion) {
            final code = suggestion;
            return ListTile(
              title: Text(
                code.shgCode,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              subtitle: Text(
                code.shgName,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            );
          },
          //initialValue: model.SPH7,
          validator: (value) {
            if (value.isEmpty) {
              return
                S.of(context).SelectaSpecialCode;
                //'Select a SpecialCode';
            }
            return null;
          },
          // initialValue:
          //     specialCodeList[dimensionIndex]['specialcode'] == ""
          //         ? ''
          //         : '${specialCodeList[dimensionIndex]['specialcode']}',
          textFieldConfiguration: TextFieldConfiguration(
            controller: this.shccontroller7,
            autofocus: false,
            // inputFormatters: [AllCapitalCase()],
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              border: OutlineInputBorder(
                  gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText:
              S.of(context).Sph +"7",
              //"SPH7",
              //S.of(context).SpecialCode,
              labelStyle: TextStyle(color: Theme.of(context).accentColor),
              //'SpecialCode',
            ),
          ),
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          onSuggestionSelected: (SpecialHandlingGroup suggestion) {
            print(suggestion);
            this.shccontroller7.text = suggestion.shgCode;
            // specialCodeList[index]['specialcode'] =
            //     suggestion.codeType;
            model.SPH7 = suggestion.shgCode;

            //print(destination);
          }),
    );
  }

  shc8(EAWBModel model) {
    this.shccontroller8.text = model.SPH8;
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TypeAheadFormField<SpecialHandlingGroup>(
          suggestionsCallback: SpecialHandlingGroupApi.getSpecialHandlingCode,
          itemBuilder: (context, SpecialHandlingGroup suggestion) {
            final code = suggestion;
            return ListTile(
              title: Text(
                code.shgCode,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              subtitle: Text(
                code.shgName,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            );
          },
          // initialValue: model.SPH8,
          // onSaved: (value) {
          //   model.SPH8 = value;
          // },
          validator: (value) {
            if (value.isEmpty) {
              return
                S.of(context).SelectaSpecialCode;
                //'Select a SpecialCode';
            }
            return null;
          },
          // initialValue:
          //     specialCodeList[dimensionIndex]['specialcode'] == ""
          //         ? ''
          //         : '${specialCodeList[dimensionIndex]['specialcode']}',
          textFieldConfiguration: TextFieldConfiguration(
            controller: this.shccontroller8,
            autofocus: false,
            // inputFormatters: [AllCapitalCase()],
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              border: OutlineInputBorder(
                  gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText:
              S.of(context).Sph +"8",
              //"SPH8",
              //S.of(context).SpecialCode,
              labelStyle: TextStyle(color: Theme.of(context).accentColor),
              //'SpecialCode',
            ),
          ),
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          onSuggestionSelected: (SpecialHandlingGroup suggestion) {
            print(suggestion);
            this.shccontroller8.text = suggestion.shgCode;
            // specialCodeList[index]['specialcode'] =
            //     suggestion.codeType;
            model.SPH8 = suggestion.shgCode;
            //print(destination);
          }),
    );
  }

  shc9(EAWBModel model) {
    this.shccontroller9.text = model.SPH9;
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TypeAheadFormField<SpecialHandlingGroup>(
          suggestionsCallback: SpecialHandlingGroupApi.getSpecialHandlingCode,
          itemBuilder: (context, SpecialHandlingGroup suggestion) {
            final code = suggestion;
            return ListTile(
              title: Text(
                code.shgCode,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              subtitle: Text(
                code.shgName,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            );
          },
          // initialValue: model.SPH8,
          // onSaved: (value) {
          //   model.SPH8 = value;
          // },
          validator: (value) {
            if (value.isEmpty) {
              return
                S.of(context).SelectaSpecialCode;
                //'Select a SpecialCode';
            }
            return null;
          },
          // initialValue:
          //     specialCodeList[dimensionIndex]['specialcode'] == ""
          //         ? ''
          //         : '${specialCodeList[dimensionIndex]['specialcode']}',
          textFieldConfiguration: TextFieldConfiguration(
            controller: this.shccontroller9,
            autofocus: false,
            // inputFormatters: [AllCapitalCase()],
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              border: OutlineInputBorder(
                  gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText:
              S.of(context).Sph+"9",
              //"SPH9",
              //S.of(context).SpecialCode,
              labelStyle: TextStyle(color: Theme.of(context).accentColor),
              //'SpecialCode',
            ),
          ),
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          onSuggestionSelected: (SpecialHandlingGroup suggestion) {
            print(suggestion);
            this.shccontroller9.text = suggestion.shgCode;
            // specialCodeList[index]['specialcode'] =
            //     suggestion.codeType;
            model.SPH9 = suggestion.shgCode;
            //print(destination);
          }),
    );
  }

  specialservicereq(EAWBModel model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.SpecialServiceRequest,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) {
          // _fieldFocusChange(
          //     context, _shipperNameFocusNode, _shipperAddressFocusNode);
        },
        maxLines: 6,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(20.0),
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
            border: OutlineInputBorder(
                gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            labelText: "Special Service Request",
            //S.of(context).PostCode,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.request_quote_outlined,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )),
        onChanged: (text) {
          model.SpecialServiceRequest = text;
        },
      ),
    );
  }

  otherinfo(EAWBModel model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.OtherServiceInformation,
        textInputAction: TextInputAction.next,

        // inputFormatters: [
        //   LengthLimitingTextInputFormatter(65),
        //   MaskTextInputFormatter(
        //     FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
        //
        //     // filter: {"#": RegExp(r'[0-9]')},
        //   )
        // ],

        onFieldSubmitted: (value) {
          // _fieldFocusChange(
          //     context, _shipperNameFocusNode, _shipperAddressFocusNode);
        },
        maxLines: 6,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(20.0),
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
            labelText:
            S.of(context).OtherServiceInformation,
            //"Other Service Information",
            //S.of(context).PostCode,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.perm_device_info,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )),
        onChanged: (text) {
          model.OtherServiceInformation = text;
        },
      ),
    );
  }

  sci(EAWBModel model) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: model.SCI,
        textInputAction: TextInputAction.next,

        onFieldSubmitted: (value) {
          // _fieldFocusChange(
          //     context, _shipperNameFocusNode, _shipperAddressFocusNode);
        },
        // maxLines: 6,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(20.0),
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
            labelText:
            S.of(context).SCI,
            //"SCI",
            //S.of(context).PostCode,
            labelStyle: new TextStyle(
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(
              Icons.code,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )),
        onChanged: (text) {
          model.SCI = text;
        },
      ),
    );
  }
}
