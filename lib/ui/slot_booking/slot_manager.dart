import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:rooster/ui/drodowns/airport_code.dart';
import 'package:rooster/ui/hawb/house_details.dart';
import 'package:rooster/ui/homescreen/new_home.dart';

import '../../formatter.dart';
import '../../generated/l10n.dart';
import 'Slot_book.dart';

class SlotManager extends StatefulWidget {
  String awbNumber;
  String awbNumber2;
  String awbNumber3;
  SlotManager({Key key, this.awbNumber,this.awbNumber2,this.awbNumber3}) : super(key: key);

  @override
  _SlotManagerState createState() => _SlotManagerState();
}

class _SlotManagerState extends State<SlotManager> {
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
  String formattedDate =
      DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
  var _DockZone = new TextEditingController(text:"AAA");
  var _DockArea = new TextEditingController(text:"blue building");
  var _DockNumber = new TextEditingController(text:"24");
  var DateController = new TextEditingController(
      text:
      DateFormat.yMMMEd()

      // displaying formatted date
          .format(DateTime.now()),
    // DateFormat('dd-MM-yyyy').format(DateTime.now()).toString()
  );
  var shgroupController = new TextEditingController();
  var driverinfo = new TextEditingController(text:"KRISH");
  final FocusScopeNode _node = FocusScopeNode();
  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: Container(
            // padding: const EdgeInsets.only(left: 40),
            child: Text(
              S.of(context).DockSelection,
              // "Dock Selection"
            ),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: Card(
            // color: Colors.transparent,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _formKey,
                child: FocusScope(
                  node: _node,
                  child: Column(
                    //  mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          margin: EdgeInsets.only(left: 25, right: 25),
                          child: TypeAheadFormField<SpecialHandlingGroup>(
                              suggestionsCallback: SpecialHandlingGroupApi
                                  .getSpecialHandlingCode,
                              itemBuilder:
                                  (context, SpecialHandlingGroup suggestion) {
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
                                    contentPadding: EdgeInsets.only(
                                        top: 20, left: 10, bottom: 20),
                                    isDense: true,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color:
                                                Theme.of(context).accentColor,
                                            // color: Colors.deepPurple,
                                            width: 2),
                                        //gapPadding: 2.0,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
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
                                    S.of(context).SpecialHandlingGroup,
                                    //"Special Handling Group",
                                    labelStyle: new TextStyle(
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onSuggestionSelected:
                                  (SpecialHandlingGroup suggestion) {
                                this.shgroupController.text =
                                    suggestion.shgCode;
                                // model.awbConsigmentDestination = suggestion.shgCode;
                                //print(destination);
                              })),
                      // Container(
                      //   margin: EdgeInsets.only(left: 25, right: 25),
                      //   child: DropdownButtonFormField<String>(
                      //     decoration: InputDecoration(
                      //         labelText: "Special Handling Group",
                      //         labelStyle: TextStyle(
                      //             color: Theme.of(context).accentColor,
                      //             fontSize: 16.0),
                      //         errorStyle: TextStyle(
                      //             color: Colors.redAccent, fontSize: 16.0),
                      //         focusedBorder: OutlineInputBorder(
                      //           borderSide: BorderSide(
                      //             width: 2,
                      //             color: Theme.of(context).accentColor,
                      //             //   color: Colors.deepPurple
                      //           ),
                      //           borderRadius: BorderRadius.circular(8.0),
                      //         ),
                      //         enabledBorder: OutlineInputBorder(
                      //             borderSide: BorderSide(
                      //                 width: 2,
                      //                 color: Theme.of(context).accentColor),
                      //             borderRadius: BorderRadius.circular(10.0))),
                      //     value: _currentSelectedValue,
                      //     // hint: Text("No",
                      //     // style: TextStyle(
                      //     //   color: Theme.of(context).accentColor
                      //     // ),
                      //     // ),
                      //
                      //     onChanged: (String newValue) {
                      //       setState(() {
                      //         _currentSelectedValue = newValue;
                      //       });
                      //     },
                      //     // validator: (String value) {
                      //     //   if (value?.isEmpty ?? true) {
                      //     //     return 'Please enter a valid type of Special Handling group';
                      //     //   }
                      //     // },
                      //     items:
                      //         types.map<DropdownMenuItem<String>>((String value) {
                      //       return DropdownMenuItem<String>(
                      //         value: value,
                      //         child: Text(
                      //           value,
                      //           style: TextStyle(
                      //               color: Theme.of(context).accentColor),
                      //         ),
                      //       );
                      //     }).toList(),
                      //   ),
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      // Card(
                      //   elevation: 4,
                      //   // color: Colors.blue,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(20.0),
                      //   ),
                      //   child: ClipRRect(
                      //     clipBehavior: Clip.hardEdge,
                      //     borderRadius: BorderRadius.circular(20.0),
                      //     child:  Container(
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(20.0),
                      //       ),
                      //       width: 320,
                      //       padding: EdgeInsets.all(8.0),
                      //       child: TextField(
                      //
                      //         //  autofocus: true,
                      //         decoration: InputDecoration(
                      //           contentPadding: EdgeInsets.all(8),
                      //           border: InputBorder.none,
                      //          // border: OutlineInputBorder(),
                      //           labelText: 'Area',
                      //           labelStyle: TextStyle(
                      //             color: Theme.of(context).accentColor
                      //           )
                      //
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),

                      //Dock Zone

                      // Container(
                      //   width: 300,
                      //   decoration: BoxDecoration(
                      //     border: Border.all(
                      //       color: Theme.of(context).accentColor,
                      //       width: 2,
                      //     ),
                      //     borderRadius: BorderRadius.circular(10.0),
                      //   ),
                      //   child: ClipRRect(
                      //     clipBehavior: Clip.hardEdge,
                      //     borderRadius: BorderRadius.circular(10.0),
                      //     child: ExpansionTile(
                      //       title:  Text("Dock Zone",
                      //       style: TextStyle(
                      //         color: Theme.of(context).accentColor
                      //       ),
                      //       ),
                      //       // subtitle: const Text('Custom expansion arrow icon'),
                      //       trailing: Icon(
                      //         _customTileExpanded
                      //             ? Icons.arrow_drop_down_circle
                      //             : Icons.arrow_drop_down,
                      //       ),
                      //       children:  <Widget>[
                      //         ListTile(
                      //           title: Text("Import"),
                      //           leading:Radio(
                      //             value: 1,
                      //             groupValue: val,
                      //             onChanged: (value) {
                      //               setState(() {
                      //                 val = value;
                      //               });
                      //             },
                      //             activeColor: Colors.green,
                      //           ),
                      //         ),
                      //         ListTile(
                      //           title: Text("Export"),
                      //           leading: Radio(
                      //             value: 2,
                      //             groupValue: val,
                      //             onChanged: (value) {
                      //               setState(() {
                      //                 val = value;
                      //               });
                      //             },
                      //             activeColor: Colors.green,
                      //           ),
                      //         ),
                      //       ],
                      //       onExpansionChanged: (bool expanded) {
                      //         setState(() => _customTileExpanded = expanded);
                      //       },
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        width: 320,
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) =>
                              value.isEmpty ?
                              S.of(context).Dockzoneisrequired
                              //'Dock zone is required'
                                  : null,
                          controller: _DockZone,
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
                          textInputAction: TextInputAction.next,
                          onEditingComplete: _node.nextFocus,
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
                          textInputAction: TextInputAction.next,
                          onEditingComplete: _node.nextFocus,
                          // validator: (value) => value.isEmpty ? 'Dock Area is required' : null,
                          controller: _DockArea,
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
                          validator: (value) =>
                              value.isEmpty ?
                              S.of(context).DockNumberisrequired
                              //'Dock Number is required'
                                  : null,
                          controller: _DockNumber,
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
                          textInputAction: TextInputAction.next,
                          onEditingComplete: _node.nextFocus,
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
                          controller: DateController,
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
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2021),
                                    builder: (context,child)=>
                                Theme(
                                  data: ThemeData().copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Theme.of(context).accentColor, // header background color
                                      onPrimary: Colors.black, // header text color
                                      onSurface: Colors.black, // body text color

                                      //   onPrimary: Theme.of(context).accentColor,
                                      //   secondary: Colors.yellowAccent,
                                      //   //onSecondary: Theme.of(context).accentColor,
                                      //   error: Theme.of(context).accentColor,
                                      //   onError: Theme.of(context).accentColor,
                                      // // background: Theme.of(context).accentColor,
                                      //   onBackground: Colors.white,
                                      //   surface: Colors.white,
                                      //   onSurface: Colors.black
                                    )
                                  ), child: child,
                                ),
                                    lastDate: DateTime(2100))
                                .then((selectedDate) {
                              if (selectedDate != null) {
                               DateController.text= DateFormat.yMMMEd()

                                // displaying formatted date
                                    .format(selectedDate);
                              //DateController.text = DateFormat('dd-MM-yyyy').add_jms().format(selectedDate);
                                print(DateController.text);
                              }
                            });

                            DateController.text = date.toIso8601String();
                          },
                        ),
                      ),
                      // Text(DateFormat.yMMMEd()
                      //
                      // // displaying formatted date
                      //     .format(DateTime.now()),),
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
                          textInputAction: TextInputAction.done,
                          onEditingComplete: _node.nextFocus,
                          //  validator: (value) => value.isEmpty ? 'Dock Number is required' : null,
                          controller: driverinfo,
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
                          textInputAction: TextInputAction.next,
                          maxLength: 12,
                          onEditingComplete: _node.nextFocus,
                          //  validator: (value) => value.isEmpty ? 'Dock Number is required' : null,
                         // controller: driverinfo,
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
                            S.of(context).VehicleNumber,
                            //'Vehicle Number',
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
                               // 'Submit',
                                style: TextStyle(
                                    color: Theme.of(context).backgroundColor),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  EasyLoading.show(status:
                                  S.of(context).Pleasewait
                                    //'Please wait...'
                                  );
                                  await Future.delayed(Duration(seconds: 2));
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SlotBook(
                                            awbnumber2:widget.awbNumber2,
                                              awbnumber3: widget.awbNumber3,
                                              awbnumber: widget.awbNumber,
                                              driverinfo: driverinfo.text,
                                              date: DateController.text,
                                              zone: _DockZone.text,
                                              sphgroup: shgroupController.text,
                                              area: _DockArea.text,
                                              number: _DockNumber.text)));
                                  //await Future.delayed(Duration(seconds: 1));
                                  EasyLoading.dismiss();
                                }
                              }),
                          SizedBox(
                            width: 10,
                          ),
                          // ElevatedButton(
                          //   child: const Text('Close'),
                          //   onPressed: (){
                          //     Navigator.of(context).pop();
                          //     // Navigator.of(context).push(MaterialPageRoute(
                          //     //     builder: (BuildContext context) => SlotBook(
                          //     //     )));
                          //   },
                          // )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SlotManagement extends StatefulWidget {
  const SlotManagement({Key key}) : super(key: key);

  @override
  _SlotManagementState createState() => _SlotManagementState();
}

class _SlotManagementState extends State<SlotManagement> {
  bool _customTileExpanded = false;
  String _currentSelectedValue;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          title: Container(
              padding: const EdgeInsets.only(left: 40),
              child: Text(
                S.of(context).SlotManagement
                //  "Slot Management"
              ))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              //margin: EdgeInsets.all(20.0),
              child: TextFormField(
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: "###-########",
                    filter: {"#": RegExp(r'[0-9]')},
                  )
                ],
                keyboardType: TextInputType.number,

                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20.0),
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
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    hintText: "___-________",
                    labelText:
                    S.of(context).AWBnumber,
                    //"AWB Number",
                    labelStyle: new TextStyle(
                        color: Theme.of(context).accentColor,
                        // color: Colors.deepPurple,
                        fontSize: 16.0),
                    suffixIcon: Icon(
                      Icons.flight_takeoff,
                      color: Theme.of(context).accentColor,
                      //  color: Colors.deepPurple,
                    )),

                //"AWB-Number"),
                maxLength: 12,
                // maxLengthEnforced: true,
              ),
            ),
            ElevatedButton(
                child:  Text(
                  S.of(context).Submit
                //    'Submit'
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => SlotBook()));
                }),
          ],
        ),
      ),
    ));
  }
}
