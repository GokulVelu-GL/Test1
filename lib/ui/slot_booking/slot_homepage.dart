import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/ui/slot_booking/slot_manager.dart';

import '../../formatter.dart';
import 'background.dart';
import 'multipleawb.dart';

class Slot_home extends StatefulWidget {
  const Slot_home({Key key}) : super(key: key);

  @override
  _Slot_homeState createState() => _Slot_homeState();
}

class _Slot_homeState extends State<Slot_home> {
  var proselect;
  final _awbForm = GlobalKey<FormState>();

  String _eAWBNumber = "";
  String _eAWBNumber2 = "";
  String _eAWBNumber3 = "";

  String type;
  var select;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
              S.of(context).BookingDockandSlot
              //"Booking Dock and Slot"
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.help,
              color: Theme.of(context).backgroundColor,
              ),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  title: Center(child: Text(
                      S.of(context).BookingDockandSlot,
                    //  "Booking Dock and Slot",
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,

                  ),
                  )),
                  content: Container(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                          ),
                          child: ListTile(
                            leading:  Image(
                              width: 39.0,
                              color: Theme.of(context).accentColor,
                              image: NetworkImage(
                              "https://img.icons8.com/external-itim2101-blue-itim2101/2x/external-paper-school-stationery-itim2101-blue-itim2101.png",
                                //  "https://www.shiphub.co/wp-content/uploads/air-waybill-form.jpg",
                                //  "https://cdn.iconscout.com/icon/free/png-64/e-way-bill-1817367-1538235.png"
                              ),
                              //  "https://cdn-icons-png.flaticon.com/512/4301/4301588.png"),
                            ),
                            // leading: Icon(Icons.document_scanner,
                            // color: Theme.of(context).accentColor,
                            // ),
                            title: Text(
                              S.of(context).AWB,
                              //"AWB",
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(
                             S.of(context).SlotsbookingperShipment,
                              // "Slot(s) booking per Shipment",

                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          child: ListTile(
                            leading:  Image(
                              width: 39.0,
                              color: Theme.of(context).accentColor,
                              image: NetworkImage(
                                "https://img.icons8.com/external-icongeek26-outline-colour-icongeek26/344/external-paper-ecology-icongeek26-outline-colour-icongeek26.png",
                                //"https://cdn.pixabay.com/photo/2012/04/01/17/40/paper-23700_960_720.png",
                                 // "https://cdn.iconscout.com/icon/free/png-64/e-way-bill-1817367-1538235.png"
                              ),
                              //  "https://cdn-icons-png.flaticon.com/512/4301/4301588.png"),
                            ),
                            title: Text(
                            S.of(context).MultipleAWBs,
                             // "Multiple AWBs",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(
                            S.of(context).SlotsbookingforMultipleShipments,
                                //"Slot(s) booking for Multiple Shipments",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          child: ListTile(
                            leading:  Image(
                              width: 39.0,
                              color: Theme.of(context).accentColor,
                              image: NetworkImage(
                                  "https://img.icons8.com/ios/344/truck.png"
                              ),
                              //  "https://cdn-icons-png.flaticon.com/512/4301/4301588.png"),
                            ),
                            title: Text(
                              S.of(context).VehicleRegistrationNumber,
                              //  "Vehicle Registration Number",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(
                              S.of(context).SlotsbookingforaVehiclethatcouldbeinvolvedwithsinglemultipleShipments
                                //"Slot(s) booking for a Vehicle that could be involved with single/multiple Shipments",
                              ,style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).accentColor),
                            ),
                            child:  Text(
                              S.of(context).Close,
                              //'Close',
                            style: TextStyle(
                              color: Theme.of(context).backgroundColor
                            ),),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],

        ),
      body: Stack(
        children: [
          Background(),
      Center(
        child: Container(
          child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(
                            S.of(context).AWB,
                            //"AWB",
                            style: TextStyle(
                              color: Theme.of(context).accentColor
                            ),
                          ),
                          leading: Radio(
                              fillColor: MaterialStateColor.resolveWith((states) => Theme.of(context).accentColor),
                              value: "Eawb",
                              groupValue: type,
                              onChanged: (value) {
                                EAWBModel model;
                                _showDialogAWB(model);
                                setState(() {
                                  type = value.toString();
                                });
                              }),
                        ),

                        ListTile(
                          title: Text(
                            S.of(context).MultipleAWBs,
                            //"Multiple AWBs",
                            style: TextStyle(
                                color: Theme.of(context).accentColor
                            ),),
                          leading: Radio(
                              fillColor: MaterialStateColor.resolveWith((states) => Theme.of(context).accentColor),
                              value: "Multiple AWBs",
                              groupValue: type,
                              onChanged: (value) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) => MultipleAWB(
                                    )));
                                setState(() {
                                  type = value.toString();
                                });
                              }),
                        ),
                        ListTile(
                          title: Text(
                            S.of(context).VehicleRegistrationNumber,
                            //"Vehicle Registration Number",
                            style: TextStyle(
                                color: Theme.of(context).accentColor
                            ),),
                          leading: Radio(
                              fillColor: MaterialStateColor.resolveWith((states) => Theme.of(context).accentColor),
                              value: "Vehicle Registration Number",
                              groupValue: type,
                              onChanged: (value) {
                                _vehicleNumber();
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (BuildContext context) =>
                                //         SlotManager(
                                //         )));
                                setState(() {
                                  type = value.toString();
                                });
                              }),
                        ),
                      ]
                  ),
        ),
      ),
      Positioned(
        bottom: 60,
        left: 0,
        child: Container(
          height: 180,
            width: 240,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                 "https://content.presentermedia.com/content/animsp/00018000/18825/dock_figures_loading_boxes_300_wht.gif",
                  // "https://i.gifer.com/PRxH.gif"
                  //  "https://content.presentermedia.com/content/animsp/00018000/18825/dock_figures_loading_boxes_300_wht.gif"
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
      ),
        ],
      ),
      //   body: Column(
      //     children: [
      //       SizedBox(
      //         height: 50,
      //       ),
      //       Container(
      //         child: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               ListTile(
      //                 title: Text("AWB",
      //                   style: TextStyle(
      //                     color: Theme.of(context).accentColor
      //                   ),
      //                 ),
      //                 leading: Radio(
      //                     fillColor: MaterialStateColor.resolveWith((states) => Theme.of(context).accentColor),
      //                     value: "Eawb",
      //                     groupValue: type,
      //                     onChanged: (value) {
      //                       EAWBModel model;
      //                       _showDialogAWB(model);
      //                       setState(() {
      //                         type = value.toString();
      //                       });
      //                     }),
      //               ),
      //
      //               ListTile(
      //                 title: Text("Multiple AWBs",
      //                   style: TextStyle(
      //                       color: Theme.of(context).accentColor
      //                   ),),
      //                 leading: Radio(
      //                     fillColor: MaterialStateColor.resolveWith((states) => Theme.of(context).accentColor),
      //                     value: "Multiple AWBs",
      //                     groupValue: type,
      //                     onChanged: (value) {
      //
      //                       Navigator.of(context).push(MaterialPageRoute(
      //                           builder: (BuildContext context) => MultipleAWB(
      //                           )));
      //                       setState(() {
      //                         type = value.toString();
      //                       });
      //                     }),
      //               ),
      //               ListTile(
      //                 title: Text("Vehicle Registration Number",
      //                   style: TextStyle(
      //                       color: Theme.of(context).accentColor
      //                   ),),
      //                 leading: Radio(
      //                     fillColor: MaterialStateColor.resolveWith((states) => Theme.of(context).accentColor),
      //                     value: "Vehicle Registration Number",
      //                     groupValue: type,
      //                     onChanged: (value) {
      //                       _vehicleNumber();
      //                       // Navigator.of(context).push(MaterialPageRoute(
      //                       //     builder: (BuildContext context) =>
      //                       //         SlotManager(
      //                       //         )));
      //                       setState(() {
      //                         type = value.toString();
      //                       });
      //                     }),
      //               ),
      //             ]
      //         ),
      //       ),
      // SizedBox(
      //   height: 100,
      // ),
      // Container(
      //   height: 300,
      //   decoration: BoxDecoration(
      //     image: DecorationImage(
      //       image: NetworkImage("https://content.presentermedia.com/content/animsp/00018000/18825/dock_figures_loading_boxes_300_wht.gif"),
      //       fit: BoxFit.cover,
      //     ),
      //   ),
      // ),
      //     ],
      //   )
    ));
  }

  //AWB Pop up
  _showDialogAWB(EAWBModel model) {
    // model.clearEAWB();

    Future.delayed(Duration(milliseconds: 500), () {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) =>
            Dialog(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 300,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  fit: StackFit.loose,
                  children: <Widget>[
                    Transform.translate(
                      offset: Offset(0, -50),
                      child: ClipOval(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: FittedBox(
                            alignment: Alignment.center,
                            child: Image.network
                            //   ("https://eadn-wc01-4731180.nxedge.io/cdn/media/wp-content/uploads/2019/02/transportation-and-logistics-concept.jpg"
                            // ),
                              (
                                "https://image.shutterstock.com/image-vector/warehouse-loading-dock-goods-vehicles-260nw-2044711208.jpg"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, 60),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                             S.of(context).EnterAWBnumber,
                              //"Enter AWB number",
                              style: TextStyle(
                                  color:Theme.of(context).accentColor,
                                  fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Form(
                            key: _awbForm,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      print(value);
                                      if (value.length == 13)
                                        value = value.substring(0, 12);
                                      if (value.isEmpty)
                                        return
                                            S.of(context).GiveAWBNumbertocreateorretrieveeAWB;
                                          //"Give AWB Number to\ncreate or retrieve eAWB";
                                      if (value.length != 12)
                                        return
                                          S.of(context).AWBnumbershouldbe12including;
                                          //"AWB number should be 12 including '-'";
                                      if (value.indexOf("-") != 3)
                                        return
                                          S.of(context).NotproperAWBnumbereg15078596324;
                                          //"Not proper AWB number\neg: 150-78596324";
                                      if (!value.endsWith(
                                          '${int.parse(value.substring(
                                              4, value.length - 1)) % 7}'))
                                        return
                                          S.of(context).NotValidAWBNumber;
                                          //"Not Valid AWB Number.";
                                      return null;
                                    },
                                    onChanged: (value) =>
                                        setState(() {
                                          _eAWBNumber = value;
                                        }),
                                    onEditingComplete: () {
                                      //_getAWBData(model);
                                    },
                                    inputFormatters: [
                                      // LengthLimitingTextInputFormatter(12),
                                      MaskTextInputFormatter(
                                        mask: "###-########",
                                        filter: {"#": RegExp(r'[0-9]')},
                                      )
                                      // added AWB formatter....
                                    ],
                                    keyboardType: TextInputType.number,
                                    cursorColor: Theme
                                        .of(context)
                                        .accentColor,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                        counterStyle: TextStyle(color: Theme.of(context).accentColor),
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
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        hintText: "___-________",
                                        labelText:
                                        S.of(context).AWBnumber,
                                       // "AWB-Number",
                                      labelStyle: TextStyle(
                                        color: Theme.of(context).accentColor
                                      )
                                    ),
                                    maxLength: 12,
                                    // maxLengthEnforced: true,
                                  ),
                                ),
                                // TextFormField(
                                //   validator: (value) {
                                //     print(value);
                                //     if (value.length == 13)
                                //       value = value.substring(0, 12);
                                //     if (value.isEmpty)
                                //       return "Give AWB Number to\ncreate or retrieve eAWB";
                                //     if (value.length != 12)
                                //       return "AWB number should be 12 including '-'";
                                //     if (value.indexOf("-") != 3)
                                //       return "Not proper AWB number\neg: 150-78596324";
                                //     if (!value.endsWith(
                                //         '${int.parse(value.substring(
                                //             4, value.length - 1)) % 7}'))
                                //       return "Not Valid AWB Number.";
                                //     return null;
                                //   },
                                //   onChanged: (value) =>
                                //       setState(() {
                                //         _eAWBNumber2 = value;
                                //       }),
                                //   onEditingComplete: () {
                                //     //_getAWBData(model);
                                //   },
                                //   inputFormatters: [
                                //     // LengthLimitingTextInputFormatter(12),
                                //     MaskTextInputFormatter(
                                //       mask: "###-########",
                                //       filter: {"#": RegExp(r'[0-9]')},
                                //     )
                                //     // added AWB formatter....
                                //   ],
                                //   keyboardType: TextInputType.number,
                                //   cursorColor: Theme
                                //       .of(context)
                                //       .accentColor,
                                //   textInputAction: TextInputAction.done,
                                //   decoration: InputDecoration(
                                //       counterStyle: TextStyle(color: Theme.of(context).accentColor),
                                //       enabledBorder: OutlineInputBorder(
                                //           borderSide:
                                //           new BorderSide(
                                //               color: Theme.of(context).accentColor,
                                //               // color: Colors.deepPurple,
                                //               width: 2),
                                //           //gapPadding: 2.0,
                                //           borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                //       focusedBorder: OutlineInputBorder(
                                //         borderSide: BorderSide(width: 2,
                                //           color: Theme.of(context).accentColor,
                                //           //   color: Colors.deepPurple
                                //         ),
                                //         borderRadius: BorderRadius.circular(8.0),
                                //       ),
                                //       border: OutlineInputBorder(
                                //         borderRadius: BorderRadius.circular(10),
                                //       ),
                                //       hintText: "___-________",
                                //       labelText:
                                //       //S.of(context).AWBnumber,
                                //       "AWB-Number",
                                //       labelStyle: TextStyle(
                                //           color: Theme.of(context).accentColor
                                //       )
                                //   ),
                                //   maxLength: 12,
                                //   maxLengthEnforced: true,
                                // ),
                                // TextFormField(
                                //   validator: (value) {
                                //     print(value);
                                //     if (value.length == 13)
                                //       value = value.substring(0, 12);
                                //     if (value.isEmpty)
                                //       return "Give AWB Number to\ncreate or retrieve eAWB";
                                //     if (value.length != 12)
                                //       return "AWB number should be 12 including '-'";
                                //     if (value.indexOf("-") != 3)
                                //       return "Not proper AWB number\neg: 150-78596324";
                                //     if (!value.endsWith(
                                //         '${int.parse(value.substring(
                                //             4, value.length - 1)) % 7}'))
                                //       return "Not Valid AWB Number.";
                                //     return null;
                                //   },
                                //   onChanged: (value) =>
                                //       setState(() {
                                //         _eAWBNumber3 = value;
                                //       }),
                                //   onEditingComplete: () {
                                //     //_getAWBData(model);
                                //   },
                                //   inputFormatters: [
                                //     // LengthLimitingTextInputFormatter(12),
                                //     MaskTextInputFormatter(
                                //       mask: "###-########",
                                //       filter: {"#": RegExp(r'[0-9]')},
                                //     )
                                //     // added AWB formatter....
                                //   ],
                                //   keyboardType: TextInputType.number,
                                //   cursorColor: Theme
                                //       .of(context)
                                //       .accentColor,
                                //   textInputAction: TextInputAction.done,
                                //   decoration: InputDecoration(
                                //       counterStyle: TextStyle(color: Theme.of(context).accentColor),
                                //       enabledBorder: OutlineInputBorder(
                                //           borderSide:
                                //           new BorderSide(
                                //               color: Theme.of(context).accentColor,
                                //               // color: Colors.deepPurple,
                                //               width: 2),
                                //           //gapPadding: 2.0,
                                //           borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                //       focusedBorder: OutlineInputBorder(
                                //         borderSide: BorderSide(width: 2,
                                //           color: Theme.of(context).accentColor,
                                //           //   color: Colors.deepPurple
                                //         ),
                                //         borderRadius: BorderRadius.circular(8.0),
                                //       ),
                                //       border: OutlineInputBorder(
                                //         borderRadius: BorderRadius.circular(10),
                                //       ),
                                //       hintText: "___-________",
                                //       labelText:
                                //       //S.of(context).AWBnumber,
                                //       "AWB-Number",
                                //       labelStyle: TextStyle(
                                //           color: Theme.of(context).accentColor
                                //       )
                                //   ),
                                //   maxLength: 12,
                                //   maxLengthEnforced: true,
                                // ),
                              ],
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor)),
                            onPressed: () {
                              if(_awbForm.currentState.validate())
                              //print(model.awbConsigmentDetailsAWBNumber);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SlotManager(
                                        awbNumber: _eAWBNumber,
                                        awbNumber2: _eAWBNumber2,
                                        awbNumber3: _eAWBNumber3,

                                      )));
                            },
                            child: Text(
                              S.of(context).Search,
                              //  "Search"
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      );
    });
  }
  _vehicleNumber() {
    // model.clearEAWB();

    Future.delayed(Duration(milliseconds: 500), () {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) =>
            Dialog(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 300,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  fit: StackFit.loose,
                  children: <Widget>[
                    Transform.translate(
                      offset: Offset(0, -50),
                      child: ClipOval(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: FittedBox(
                            alignment: Alignment.center,
                            child: Image.network
                            //   ("https://eadn-wc01-4731180.nxedge.io/cdn/media/wp-content/uploads/2019/02/transportation-and-logistics-concept.jpg"
                            // ),
                              (
                                "https://image.shutterstock.com/image-vector/warehouse-loading-dock-goods-vehicles-260nw-2044711208.jpg"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, 60),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              S.of(context).EnterVehicleRegistrationnumber,
                              //"Enter Vehicle Registration  number",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Form(
                            key: _awbForm,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: TextFormField(
                                onChanged: (value) =>
                                    setState(() {
                                      _eAWBNumber = value;
                                    }),
                                onEditingComplete: () {
                                  //_getAWBData(model);
                                },
                                // keyboardType: TextInputType.number,
                                cursorColor: Theme
                                    .of(context)
                                    .accentColor,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                    counterStyle: TextStyle(color: Theme.of(context).accentColor),
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
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    labelText:
                                    S.of(context).VehicleRegistrationNumber,
                                   // "Vehicle Registration Number",
                                  labelStyle: TextStyle(
                                    color: Theme.of(context).accentColor
                                  )
                                ),
                                // maxLengthEnforced: true,
                              ),
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor)),
                            onPressed: () {
                              //print(model.awbConsigmentDetailsAWBNumber);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MultipleAWB(
                                        // awbNumber: _eAWBNumber,
                                      )));
                            },
                            child: Text(
                              S.of(context).Search,

                              //  "Search",
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      );
    });
  }

}
//Multiple AWB Pop up
class MultipleAWB extends StatefulWidget {
  const MultipleAWB({Key key}) : super(key: key);

  @override
  _MultipleAWBState createState() => _MultipleAWBState();
}

class _MultipleAWBState extends State<MultipleAWB> {
  final _multipleawbForm = GlobalKey<FormState>();
  final _multipleawbpopup = GlobalKey<FormState>();



  String _AWBNumber = "";
  TextEditingController awbcontroller = new TextEditingController();
  TextEditingController awb1controller = new TextEditingController();
  TextEditingController awb2controller = new TextEditingController();
  TextEditingController awb3controller = new TextEditingController();
  final List<ExpenseList> expenseList = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              S.of(context).AWBs,
              //"AWBs",
              style: TextStyle(fontSize: 20,
              color: Theme.of(context).accentColor
              ),
            ),
          ),
          Form(
           key: _multipleawbForm,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: awb1controller,
                    // onChanged: (value) =>
                    //     setState(() {
                    //       _AWBNumber = value;
                    //     }),
                    validator: (value) {
                      print(value);
                      if (value.length == 13)
                        value = value.substring(0, 12);
                      if (value.isEmpty)
                        return
                      S.of(context).GiveAWBNumbertocreateorretrieveeAWB;
                      //"Give AWB Number to\ncreate or retrieve eAWB";
                      if (value.length != 12)
                        return
                          S.of(context).AWBnumbershouldbe12including;
                          //"AWB number should be 12 including '-'";
                      if (value.indexOf("-") != 3)
                        return
                      S.of(context).NotproperAWBnumbereg15078596324;
                      //"Not proper AWB number\neg: 150-78596324";
                      if (!value.endsWith(
                          '${int.parse(value.substring(
                              4, value.length - 1)) % 7}'))
                        return
                          S.of(context).NotValidAWBNumber;
                          //"Not Valid AWB Number.";
                      return null;
                    },
                    // onChanged: (value) =>
                    //     setState(() {
                    //     //  _AWBNumber = value;
                    //     }),
                    onEditingComplete: () {
                      //_getAWBData(model);
                    },
                    inputFormatters: [
                     //  LengthLimitingTextInputFormatter(12),
                      MaskTextInputFormatter(
                        mask: "###-########",
                        filter: {"#": RegExp(r'[0-9]')},
                      )
                      // added AWB formatter....
                    ],
                    keyboardType: TextInputType.number,
                    cursorColor: Theme
                        .of(context)
                        .primaryColor,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        counterStyle: TextStyle(color: Theme.of(context).accentColor),
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
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                        hintText: "___-________",
                        labelText:
                        S.of(context).AWBnumber,
                       // "AWB-Number",
                      labelStyle: TextStyle(
                        color:Theme.of(context).accentColor
                      )
                    ),
                    maxLength: 12,
                    // maxLengthEnforced: true,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: awb2controller,
                    // onChanged: (value) =>
                    //     setState(() {
                    //       _AWBNumber = value;
                    //     }),
                    validator: (value) {
                      print(value);
                      if (value.length == 13)
                        value = value.substring(0, 12);
                      if (value.isEmpty)
                        return
                      S.of(context).GiveAWBNumbertocreateorretrieveeAWB;
                      //"Give AWB Number to\ncreate or retrieve eAWB";
                      if (value.length != 12)
                        return
                          S.of(context).AWBnumbershouldbe12including;
                          //"AWB number should be 12 including '-'";
                      if (value.indexOf("-") != 3)
                        return
                          S.of(context).NotproperAWBnumbereg15078596324;
                          //"Not proper AWB number\neg: 150-78596324";
                      if (!value.endsWith(
                          '${int.parse(value.substring(
                              4, value.length - 1)) % 7}'))
                        return
                          S.of(context).NotValidAWBNumber;
                          //"Not Valid AWB Number.";
                      return null;
                    },
                    // onChanged: (value) =>
                    //     setState(() {
                    //     //  _AWBNumber = value;
                    //     }),
                    onEditingComplete: () {
                      //_getAWBData(model);
                    },
                    inputFormatters: [
                      //  LengthLimitingTextInputFormatter(12),
                      MaskTextInputFormatter(
                        mask: "###-########",
                        filter: {"#": RegExp(r'[0-9]')},
                      )
                      // added AWB formatter....
                    ],
                    keyboardType: TextInputType.number,
                    cursorColor: Theme
                        .of(context)
                        .primaryColor,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        counterStyle: TextStyle(color: Theme.of(context).accentColor),
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
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                        hintText: "___-________",
                        labelText:
                        S.of(context).AWBnumber,
                       // "AWB-Number",
                        labelStyle: TextStyle(
                            color:Theme.of(context).accentColor
                        )
                    ),
                    maxLength: 12,
                    // maxLengthEnforced: true,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: awb3controller,
                    // onChanged: (value) =>
                    //     setState(() {
                    //       _AWBNumber = value;
                    //     }),
                    validator: (value) {
                      print(value);
                      if (value.length == 13)
                        value = value.substring(0, 12);
                      if (value.isEmpty)
                        return
                          S.of(context).GiveAWBNumbertocreateorretrieveeAWB;
                          //"Give AWB Number to\ncreate or retrieve eAWB";
                      if (value.length != 12)
                        return
                          S.of(context).AWBnumbershouldbe12including;
                          //"AWB number should be 12 including '-'";
                      if (value.indexOf("-") != 3)
                        return
                          S.of(context).NotproperAWBnumbereg15078596324;
                          //"Not proper AWB number\neg: 150-78596324";
                      if (!value.endsWith(
                          '${int.parse(value.substring(
                              4, value.length - 1)) % 7}'))
                        return
                          S.of(context).NotValidAWBNumber;
                          //"Not Valid AWB Number.";
                      return null;
                    },
                    // onChanged: (value) =>
                    //     setState(() {
                    //     //  _AWBNumber = value;
                    //     }),
                    onEditingComplete: () {
                      //_getAWBData(model);
                    },
                    inputFormatters: [
                      //  LengthLimitingTextInputFormatter(12),
                      MaskTextInputFormatter(
                        mask: "###-########",
                        filter: {"#": RegExp(r'[0-9]')},
                      )
                      // added AWB formatter....
                    ],
                    keyboardType: TextInputType.number,
                    cursorColor: Theme
                        .of(context)
                        .primaryColor,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        counterStyle: TextStyle(color: Theme.of(context).accentColor),
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
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                        hintText: "___-________",
                        labelText:
                        S.of(context).AWBnumber,
                        //"AWB-Number",
                        labelStyle: TextStyle(
                            color:Theme.of(context).accentColor
                        )
                    ),
                    maxLength: 12,
                    // maxLengthEnforced: true,
                  ),
                ),

              ],
            ),
          ),

          Container(
            child: Column(
              children: expenseList.map((e) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Theme.of(context).backgroundColor,
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

                        // leading: Icon(
                        //   Icons.flight_takeoff,
                        //   color: Theme.of(context).accentColor,
                        // ),
                        title: Text(
                          '${e.title}',
                        ),
                        //subtitle:Text("AWB Number"),
                        trailing: IconButton(
                          onPressed: () {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible: false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(child: Text('Remove',
                                  style: TextStyle(
                                    color:Theme.of(context).accentColor
                                  ),
                                  )),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          S.of(context).WouldyouliketoRemove,
                                          //'Would you like to Remove',
                                        style: TextStyle(
                                          color: Theme.of(context).accentColor
                                        ),
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
                                            color: Theme.of(context).accentColor),
                                      ),
                                      onPressed: () {
                                        awbdelete(e.title);
                                        // Consigneecontactdelete(e.title);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        S.of(context).Cancel,
                                        //'Cancel',
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
                            // Emaildelete(e.title);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ),

                  ],
                );
              }).toList(),
            ),
          ),
          TextButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor)),
            onPressed: () {

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                       SlotManager(
                         awbNumber: awb1controller.text,
                         awbNumber2: awb2controller.text,
                         awbNumber3: awb3controller.text,
                      )));
            },
            child: Text(
              S.of(context).Search,
                //"Search"
            ),
          ),

        ],
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showDialog();
          },
          backgroundColor: Theme.of(context).accentColor,
          child:  Icon(Icons.add),
        ),
      ),
    );
  }
  Future<String> _showDialog() => showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Text(
        S.of(context).AddAWBNumber,
        //"Add AWB Number",
        style: TextStyle(
          color: Theme.of(context).accentColor,
        ),
      ),
      content: Form(
        key: _multipleawbpopup,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              inputFormatters: [
                // LengthLimitingTextInputFormatter(12),
                MaskTextInputFormatter(
                  mask: "###-########",
                  filter: {"#": RegExp(r'[0-9]')},
                )
                // added AWB formatter....
              ],
              keyboardType: TextInputType.number,
              autofocus: true,
              maxLength: 12,
              decoration: InputDecoration(
                  counterStyle: TextStyle(color: Theme.of(context).accentColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  hintText:
                 S.of(context).EnterAWBnumber,
                 // "Enter the AWB Number"
              ),
              controller: awbcontroller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return
                  S.of(context).PleaseEntertheAWBNo;
                  //'Please enter the AWB Number';
                }
                return null;
              },
            ),

            SizedBox(
              height: 5,
            ),
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
              if (_multipleawbpopup.currentState.validate()) {
                addawb(awbcontroller.text
                  //selectEtype
                  // _chosenValue
                  //Etypecontroller.text
                );
                Navigator.pop(context);
              }


              awbcontroller.clear();
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
  void awbdelete(String title) {
    setState(() {
      expenseList.removeWhere((element) => element.title == title);
    });
  }


  void addawb(String title) {
    final expense = ExpenseList(
      title: title,
    );
    setState(() {
      expenseList.add(expense);
    });
  }
}

class ExpenseList {
  String title;
  ExpenseList({
    @required this.title,
  });
}