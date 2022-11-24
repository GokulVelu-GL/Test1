import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:rooster/ui/slot_booking/slot_homepage.dart';

import '../../formatter.dart';
import '../../generated/l10n.dart';
import '../drodowns/airport_code.dart';
import 'Slot_book.dart';

class UpdateSlot extends StatefulWidget {
  String area;
  String zone;
  String sphgroup;
  String number;
  String date;
  String awbnumber;
  String driverinfo;

  UpdateSlot({Key key,this.area,this.zone,this.sphgroup,this.number, this.date, this.awbnumber, this.driverinfo}) : super(key: key);

  @override
  State<UpdateSlot> createState() => _UpdateSlotState();
}

class _UpdateSlotState extends State<UpdateSlot> {
  final _formKey = GlobalKey<FormState>();
  bool _customTileExpanded = false;
  String _currentSelectedValue;
  var val = -1;
  var Docknumber = [
    "11",
    "12",
    "13",
    "14",
    "15",
  ];
  var types = [
    "general",
    "perishable",
    "live animals",
    "radio active",
    "valuable",
  ];
  String SpecialHandlingtype;
  String sphtype;
  var _DockZone = new TextEditingController();
  var _DockArea = new TextEditingController();
  var _DockNumber = new TextEditingController();
  var DateController = new TextEditingController();
  var shgroupController = new TextEditingController();
  var driverinfo = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _formKey,
                child: Column(
                  //  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        S.of(context).Update,
                        //"Update",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        margin: EdgeInsets.only(left: 25, right: 25),
                        child: TypeAheadFormField<SpecialHandlingGroup>(
                            suggestionsCallback: SpecialHandlingGroupApi.getSpecialHandlingCode,
                            itemBuilder: (context, SpecialHandlingGroup suggestion) {
                              final code = suggestion;
                              return ListTile(
                                title: Text(code.shgCode),
                                subtitle: Text(code.shgName),
                              );
                            },
                            // validator: (value) {
                            //   if (value.isEmpty) {
                            //     return 'Select a Special Handling Group';
                            //   }
                            //   return null;
                            // },
                            textFieldConfiguration: TextFieldConfiguration(
                              autofocus: false,
                              controller: this.shgroupController,
                              inputFormatters: [AllCapitalCase()],
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 20,left: 10,
                                      bottom: 20),
                                  isDense: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      new BorderSide(
                                          color: Theme.of(context).accentColor,
                                          // color: Colors.deepPurple,
                                          width: 2),
                                      //gapPadding: 2.0,
                                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2,
                                      color: Theme.of(context).accentColor,
                                      //   color: Colors.deepPurple
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  // border: OutlineInputBorder(
                                  //     gapPadding: 2.0,
                                  //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                  labelText:
                                  S.of(context).SpecialHandlingGroup,
                                  //"Special Handling Group",
                                  labelStyle:
                                  new TextStyle(
                                      color: Theme.of(context).accentColor,
                                      // color: Colors.deepPurple,
                                      fontSize: 16.0),
                                  suffixIcon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Theme.of(context).accentColor,
                                    // color: Colors.deepPurple,
                                  )
                                // 'Destination',
                              ),
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            onSuggestionSelected: (SpecialHandlingGroup suggestion) {
                              this.shgroupController.text = suggestion.shgCode;
                              // model.awbConsigmentDestination = suggestion.shgCode;
                              //print(destination);
                            })),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      width: 320,
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        enabled: false,
                        initialValue: widget.zone,
                        // validator: (value) =>
                        // value.isEmpty ? 'Dock zone is required' : null,
                        // controller: _DockZone,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Theme.of(context).accentColor,
                                  // color: Colors.deepPurple,
                                  width: 2),
                              //gapPadding: 2.0,
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context).accentColor,
                              //  color: Colors.deepPurple
                            ),
                          ),
                          labelText:
                          S.of(context).DockZone,
                          //'Dock Zone',
                          labelStyle: new TextStyle(
                              color: Theme.of(context).accentColor,
                              // color: Colors.deepPurple,
                              fontSize: 16.0),
                        ),
                        onChanged: (value) {
                          setState(() {
                            widget.zone = value;
                            //print('${masterAWB}');
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      width: 320,
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        enabled: false,
                        initialValue: widget.area,
                        onChanged: (value) {
                          setState(() {
                            widget.area = value;
                            //print('${masterAWB}');
                          });
                        },
                        // validator: (value) => value.isEmpty ? 'Dock Area is required' : null,
                        // controller: _DockArea,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Theme.of(context).accentColor,
                                  // color: Colors.deepPurple,
                                  width: 2),
                              //gapPadding: 2.0,
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context).accentColor,
                              //  color: Colors.deepPurple
                            ),
                          ),
                          labelText:
                          S.of(context).DockArea,
                          //'Dock Area',
                          labelStyle: new TextStyle(
                              color: Theme.of(context).accentColor,
                              // color: Colors.deepPurple,
                              fontSize: 16.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      width: 320,
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        enabled: false,
                        initialValue: widget.number,
                        onChanged: (value) {
                          setState(() {
                            widget.number = value;
                            //print('${masterAWB}');
                          });
                        },
                        // validator: (value) =>
                        // value.isEmpty ? 'Dock Number is required' : null,
                        //controller: _DockNumber,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Theme.of(context).accentColor,
                                  // color: Colors.deepPurple,
                                  width: 2),
                              //gapPadding: 2.0,
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context).accentColor,
                              //  color: Colors.deepPurple
                            ),
                          ),
                          labelText:
                          S.of(context).DockNumber,
                          //'Dock Number',
                          labelStyle: new TextStyle(
                              color: Theme.of(context).accentColor,
                              // color: Colors.deepPurple,
                              fontSize: 16.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      width: 320,
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        enabled: false,
                        initialValue: widget.date,
                        onChanged: (value) {
                          setState(() {
                            widget.date = value;
                            //print('${masterAWB}');
                          });
                        },
                        // controller: DateController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Theme.of(context).accentColor,
                                  // color: Colors.deepPurple,
                                  width: 2),
                              //gapPadding: 2.0,
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context).accentColor,
                              //  color: Colors.deepPurple
                            ),
                          ),
                          labelText:
                          S.of(context).Date,
                          //"Date ",
                          labelStyle:
                          TextStyle(color: Theme.of(context).accentColor),
                          hintText:
                          S.of(context).EntertheDate

                          //"Enter the Date",
                        ),
                        onTap: () async {
                          DateTime date = DateTime(1900);
                          FocusScope.of(context).requestFocus(new FocusNode());

                          date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2021),
                              lastDate: DateTime(2100))
                              .then((selectedDate) {
                            if (selectedDate != null) {
                              DateController.text =
                                  DateFormat('dd-MM-yyyy').format(selectedDate);
                            }
                          });

                          // DateController.text = date.toIso8601String();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      width: 320,
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.driverinfo,
                        onChanged: (value) {
                          setState(() {
                            widget.driverinfo = value;
                            //print('${masterAWB}');
                          });
                        },
                        //  validator: (value) => value.isEmpty ? 'Dock Number is required' : null,
                        //controller: _DockNumber,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Theme.of(context).accentColor,
                                  // color: Colors.deepPurple,
                                  width: 2),
                              //gapPadding: 2.0,
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context).accentColor,
                              //  color: Colors.deepPurple
                            ),
                          ),
                          labelText:
                          S.of(context).AgentDriverInfo,
                          //'Agent/Driver Info',
                          labelStyle: new TextStyle(
                              color: Theme.of(context).accentColor,
                              // color: Colors.deepPurple,
                              fontSize: 16.0),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).accentColor),
                            ),
                            child: Text(

                              S.of(context).Submit,
                              //'Submit',
                              style: TextStyle(
                                  color: Theme.of(context).backgroundColor),
                            ),
                            onPressed: () async {
                             // if (_formKey.currentState.validate()) {
                                EasyLoading.show(status:
                                S.of(context).Pleasewait
                                  //'Please wait...'
                                );
                                await Future.delayed(Duration(seconds: 2));
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                    // MultipleAWB()
                                        SlotBook(
                                          driverinfo: widget.driverinfo,
                                      awbnumber: widget.awbnumber,
                                        date: widget.date,
                                        zone: widget.zone,
                                        sphgroup:
                                        shgroupController.text,
                                        area: widget.area,
                                        number: widget.number)
                                ),
                                );
                                await Future.delayed(Duration(seconds: 1));
                                EasyLoading.dismiss();
                            //  }
                            }),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).accentColor),
                      ),
                      child: Text(
                        S.of(context).ModifySearch,
                        // 'Modify Search'
                      ),
                      onPressed: (){
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => MultipleAWB(
                            )));
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
