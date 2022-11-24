import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/model/rate_description_items.dart';
import 'package:rooster/ui/eawb/charges_summary.dart';
import 'package:rooster/ui/eawb/static/add_rate_description.dart';
import 'package:rooster/ui/eawb/static/custom_background.dart';
import 'package:rooster/ui/eawb/handling_information.dart';
import 'package:rooster/ui/eawb/static/update_rate_description.dart';
import 'dart:math' as math show sin, pi,sqrt;
import 'package:flutter/animation.dart';

class RateDescription extends StatefulWidget {
  RateDescription({Key key}) : super(key: key);

  @override
  _RateDescriptionState createState() => _RateDescriptionState();
}

class _RateDescriptionState extends State<RateDescription>  with TickerProviderStateMixin{
  int previousIndex = 0;
  bool cardExpanded = true;
  bool alertvalue=false;
  AnimationController _controller;
  bool consolidationvalue = false;

  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
              name: S.of(context).Ratedescription,
              //"Rate Description",
              next: ChargesSummary(),
              previous: HandlingInformation(),
              help:   IconButton(
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
                                      leading: Icon(Icons.production_quantity_limits,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Number of Pieces"),
                                      subtitle: Text("Number of Loose Items and/or ULD’s as accepted for carriage\n Example: 10"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.monitor_weight,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Weight"),
                                      subtitle: Text("Weight measure\nExample: 140.0"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.monitor_weight,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("WeightUnit"),
                                      subtitle: Text("Weight measure\nExample: K"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.class__outlined,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Rate Class Code"),
                                      subtitle: Text("Code representing a specific rate category\nExample: M"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.code,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Item Number"),
                                      subtitle: Text("Number to identify a specific commodity\nExample: 9017"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.class_,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Rate or Charge"),
                                      subtitle: Text("Representation of a rate, charge or discount\nExample: 123"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.monitor_weight,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Total"),
                                      subtitle: Text(" total\nExample: 100"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.monitor_weight,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Nature and Quantity of Goods"),
                                      subtitle: Text(" Description of the goods\nExample: Laptop or consolidation"),
                                    ),
                                  ),
                                  Text("Dimensions",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.height_outlined,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("length"),
                                      subtitle: Text("Length Dimension\nExample: 200"),
                                    ),
                                  ),  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.panorama_wide_angle,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Width"),
                                      subtitle: Text("Width of pieces\nExample: 150"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.height,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Height"),
                                      subtitle: Text("Height of pieces\nExample: 150"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.monitor_weight,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Measurement Unit Code"),
                                      subtitle: Text("Indication of the unit of measurement in which measurements are expressed\nExample: cm"),
                                    ),
                                  ),



                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.production_quantity_limits,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Volume"),
                                      subtitle: Text("Cubic measure of a consignment\nExample: 12.00"),
                                    ),
                                  ), Card(
                                    child: ListTile(
                                      leading: Icon(Icons.production_quantity_limits,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("VolumeUnit"),
                                      subtitle: Text("Code indicating unit of volume\nExample: CC"),
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Center(
                        //   child: CustomPaint(
                        //     painter: CirclePainter(
                        //       _controller,
                        //       color: Theme.of(context).accentColor
                        //       // color: Colors.blue,
                        //     ),
                        //     child: SizedBox(
                        //       height: 200,
                        //       width: 200,
                        //       child:
                        //       Icon(Icons.dangerous_outlined, size: 44,)
                        //       //_button(),
                        //     ),
                        //   ),
                        // ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: consolidationvalue,
                                    onChanged: (bool value) {
                                      setState(() {
                                        this.consolidationvalue = value;
                                        if(consolidationvalue.toString()=="true") {
                                          model.rateDescriptionItemList.forEach((element) {

                                            element.natureAndQuantity = "CONSOLIDATION";
                                          });
                                          //  natureAndQuantity = "CONSOLIDATION";
                                        }
                                        else {
                                            //
                                            // element.natureAndQuantity= model.rateDescriptionItemList[1].natureAndQuantity;
                                          model.rateDescriptionItemList.forEach((
                                              element) {
                                           //String secondToLastElement =  model.rateDescriptionItemList.elementAt( model.rateDescriptionItemList.length - 2).toString();
                                            element.natureAndQuantity = element.previousnatureofgoods;


                                          });
                                        }
                                          // natureofgoods.clear();
                                          // this.widget.natureAndQuantity = "";
                                        // print(natureofgoods.text);
                                        // print(consolidationvalue);
                                        // monVal = value;
                                      });
                                    },
                                  ),
                                  Text("Consolidation"),
                                ],
                              ),

                              ElevatedButton(
                                style: TextButton.styleFrom(
                                  primary: Theme.of(context).backgroundColor,
                                  backgroundColor: Theme.of(context).accentColor,
                                  // Text Color
                                ),
                                onPressed: (){
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
                                        return Center(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft:Radius.circular(40.0),
                                                bottomLeft: Radius.circular(40.0),
                                              ),
                                              color: Colors.white,
                                            ),
                                            width: MediaQuery.of(context).size.width - 14,
                                            height: 250,
                                            padding: EdgeInsets.all(8.0),
                                            child:  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        child: Center(
                                                          child: Text("Alert",
                                                          style: TextStyle(
                                                                color: Theme.of(context).accentColor,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 20
                                                          ),
                                                          ),
                                                        ),
                                                      ),
                                                      Column(
                                                        children: [
                                                          Row(

                                                            children: [
                                                              Center(
                                                                child: CustomPaint(
                                                                  painter: CirclePainter(
                                                                    _controller,
                                                                      color: Theme.of(context).accentColor
                                                                  ),
                                                                  child: SizedBox(
                                                                    height: 85,
                                                                    width:80,
                                                                    child: Icon(Icons.dangerous_outlined, size: 25,
                                                                    color: Theme.of(context).backgroundColor,
                                                                    )
                                                                    //_button(),
                                                                  ),
                                                                ),
                                                              ),
                                                              Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                // crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                              // Text("AWB Gross weight:350K\nAWB Chargeable Weight: 350 K \nGHA Acceptance Gross Weight:\n 500"
                                                              //     "K \nThis means the AWB Gross Weight"
                                                              // ,
                                                              //   style: TextStyle(
                                                              //     fontSize: 13
                                                              //   ),
                                                              // ),
                                                                   Row(
                                                                     crossAxisAlignment: CrossAxisAlignment.end,
                                                                     // mainAxisAlignment: MainAxisAlignment.end,
                                                                     children: [
                                                                       Text("AWB Gross weight ",
                                                                         style: TextStyle(
                                                                             color: Theme.of(context).accentColor,
                                                                         ),
                                                                       ),
                                                                       Text("------------------> 350K",
                                                                         style: TextStyle(
                                                                           fontWeight: FontWeight.bold,
                                                                         ),
                                                                       )
                                                                     ],
                                                                   ),
                                                                  Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    // mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Text("AWB Chargeable Weight  ",
                                                                        style: TextStyle(
                                                                          color: Theme.of(context).accentColor,

                                                                        ),
                                                                      ),
                                                                      Text("-----------> 350K",
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    // mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Text("GHA Acceptance Gross Weight ",
                                                                        style: TextStyle(
                                                                            color: Theme.of(context).accentColor,
                                                                        ),
                                                                      ),
                                                                      Text("----> 500K",
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  // Text("This means the AWB Gross Weight & AWB",
                                                                  //   style: TextStyle(
                                                                  //       color: Theme.of(context).accentColor,
                                                                  //
                                                                  //   ),
                                                                  // ),
                                                                  // Text("Chargeable Weight captured by ",
                                                                  //   style: TextStyle(
                                                                  //       color: Theme.of(context).accentColor,
                                                                  //
                                                                  //   ),
                                                                  // ),
                                                                  // Text("Documentation Team are INCORRECT. This",
                                                                  //   style: TextStyle(
                                                                  //     color: Theme.of(context).accentColor,
                                                                  //
                                                                  //   ),
                                                                  // ),
                                                                  // Text("also potentially means the AWB Charges",
                                                                  //   style: TextStyle(
                                                                  //     color: Theme.of(context).accentColor,
                                                                  //
                                                                  //   ),
                                                                  // ),  Text("are INCORRECT,and a possible revenue loss",
                                                                  //   style: TextStyle(
                                                                  //     color: Theme.of(context).accentColor,
                                                                  //
                                                                  //   ),
                                                                  // )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Text("This means the AWB Gross Weight & AWB Chargeable Weight captured by Documentation Team are INCORRECT. This also potentially means the AWB Charges are INCORRECT, and a possible revenue loss.",
                                                            textAlign: TextAlign.justify,
                                                            style: TextStyle(
                                                              color: Theme.of(context).accentColor,
                                                            ),
                                                            ),
                                                          Text("Please Check!",
                                                            style: TextStyle(
                                                                color: Theme.of(context).accentColor,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            textAlign: TextAlign.center,

                                                          )
                                                        ],
                                                      ),

                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          ElevatedButton(

                                                              style: TextButton.styleFrom(
                                                                primary: Theme.of(context).backgroundColor,
                                                                backgroundColor: Colors.green,
                                                                // Text Color
                                                              ),onPressed: (){
                                                                setState(() {
                                                                  alertvalue=false;
                                                                  Navigator.pop(context);
                                                                });

                                                          }, child: Text("Accept",
                                                          )),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          ElevatedButton(

                                                              style: TextButton.styleFrom(
                                                                primary: Theme.of(context).backgroundColor,
                                                                backgroundColor: Colors.red,
                                                                // Text Color
                                                              ),
                                                              onPressed: (){
                                                                setState(() {
                                                                  alertvalue=true;
                                                                  Navigator.pop(context);
                                                                });
                                                                // Navigator.pop(context);
                                                                }, child: Text("Reject",
                                                          ))
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                          ),
                                        );
                                      });
                                // showDialog(
                                //     context: context,
                                //     builder: (BuildContext context) {
                                //       var height = MediaQuery.of(context).size.height;
                                //       var width = MediaQuery.of(context).size.width;
                                //       return Dialog(
                                //         shape: RoundedRectangleBorder(
                                //             borderRadius:
                                //             BorderRadius.only(
                                //              topLeft: Radius.circular(30.0),
                                //               bottomLeft: Radius.circular(30.0),
                                //             )
                                //         ), //this right here
                                //         child: Padding(
                                //           padding: const EdgeInsets.all(12.0),
                                //           child: Column(
                                //             mainAxisAlignment: MainAxisAlignment.center,
                                //             mainAxisSize: MainAxisSize.min,
                                //             crossAxisAlignment: CrossAxisAlignment.start,
                                //             children: [
                                //               Container(
                                //                 child: Center(
                                //                   child: Text("Alert",
                                //                   style: TextStyle(
                                //                     fontWeight: FontWeight.bold
                                //                   ),
                                //                   ),
                                //                 ),
                                //               ),
                                //               Row(
                                //                 children: [
                                //                   CustomPaint(
                                //                     painter: CirclePainter(
                                //                       _controller,
                                //                         color: Theme.of(context).accentColor
                                //                     ),
                                //                     child: SizedBox(
                                //                       height: 70,
                                //                       width:70,
                                //                       child: Icon(Icons.dangerous_outlined, size: 25,
                                //                       color: Theme.of(context).backgroundColor,
                                //                       )
                                //                       //_button(),
                                //                     ),
                                //                   ),
                                //                   Column(
                                //                     crossAxisAlignment: CrossAxisAlignment.start,
                                //                     mainAxisAlignment: MainAxisAlignment.start,
                                //                     children: [
                                //                   // Text("AWB Gross weight:350K\nAWB Chargeable Weight: 350 K \nGHA Acceptance Gross Weight:\n 500"
                                //                   //     "K \nThis means the AWB Gross Weight"
                                //                   // ,
                                //                   //   style: TextStyle(
                                //                   //     fontSize: 13
                                //                   //   ),
                                //                   // ),
                                //                        Row(
                                //                          crossAxisAlignment: CrossAxisAlignment.end,
                                //                          // mainAxisAlignment: MainAxisAlignment.end,
                                //                          children: [
                                //                            Text("AWB Gross weight ",
                                //                              style: TextStyle(
                                //                                  fontWeight: FontWeight.bold,
                                //                                  fontSize: 12
                                //                              ),
                                //                            ),
                                //                            Text("350K",
                                //                            style: TextStyle(
                                //                              fontWeight: FontWeight.bold,
                                //                              fontSize: 16
                                //                            ),
                                //                            )
                                //                          ],
                                //                        ),
                                //                       Row(
                                //                         crossAxisAlignment: CrossAxisAlignment.end,
                                //                         // mainAxisAlignment: MainAxisAlignment.end,
                                //                         children: [
                                //                           Text("AWB Chargeable Weight: ",
                                //                             style: TextStyle(
                                //                                 fontWeight: FontWeight.bold,
                                //                                 fontSize: 12
                                //                             ),
                                //                           ),
                                //                           Text("350K",
                                //                             style: TextStyle(
                                //                                 fontWeight: FontWeight.bold,
                                //                                 fontSize: 16
                                //                             ),
                                //                           )
                                //                         ],
                                //                       ),
                                //                       Row(
                                //                         crossAxisAlignment: CrossAxisAlignment.end,
                                //                         // mainAxisAlignment: MainAxisAlignment.end,
                                //                         children: [
                                //                           Text("GHA Acceptance Gross Weight:",
                                //                             style: TextStyle(
                                //                                 fontWeight: FontWeight.bold,
                                //                                 fontSize: 12
                                //                             ),
                                //                           ),
                                //                           Text("500K",
                                //                             style: TextStyle(
                                //                                 fontWeight: FontWeight.bold,
                                //                                 fontSize: 14
                                //                             ),
                                //                           ),
                                //                         ],
                                //                       ),
                                //                       Text("This means the AWB Gross Weight & "),
                                //                       Text("AWB Chargeable Weight captured by Documentation")
                                //                     ],
                                //                   ),
                                //                 ],
                                //               ),
                                //
                                //             ],
                                //           ),
                                //         ),
                                //       );
                                //     });

                              }, child: Text("Test"),

                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: buildExpansionPanelList(model,alertvalue),
                ),
            //         Stack(
            //                     children: <Widget>[
            //         Container(
            //            height: 100.0,
            //                 margin: new EdgeInsets.only(left: 26.0),
            //             decoration: new BoxDecoration(
            //          color: Colors.white,
            //               border: Border.all(color: Theme.of(context).accentColor,
            //               width: 3
            //               ),
            //             shape: BoxShape.rectangle,
            //             borderRadius: new BorderRadius.circular(17.0),
            //           boxShadow: <BoxShadow>[
            //         new BoxShadow(
            //           color: Colors.black12, blurRadius: 10.0,
            //           offset: new Offset(0.0, 10.0),
            //           ),
            //      ],),
            //           child: Container(
            //             padding: const EdgeInsets.only(left: 15,top: 10.0),
            //             child: Column(
            //               //crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //                   children: [
            //                     Column(
            //                       children: [
            //                         Text("Amount",
            //                           style: TextStyle(
            //                               color: Theme.of(context).accentColor,
            //                               fontWeight: FontWeight.bold
            //
            //                           ),
            //                         ),
            //                         Text("100"),
            //
            //                       ],
            //                     ),
            //                     Column(
            //                       children: [
            //                         Text("Gross Weight",
            //                           style: TextStyle(
            //                               color: Theme.of(context).accentColor,
            //                               fontWeight: FontWeight.bold
            //
            //                           ),
            //                         ),
            //                         Text("100"),
            //
            //                       ],
            //                     ),
            //                     Container(
            //                         alignment: Alignment.topRight,
            //                         child: Icon(Icons.info))
            //                   ],
            //                 ),
            //                 SizedBox(
            //                   height: 15.0,
            //                 ),
            //                 Text("Nature of Goods",
            //                 style: TextStyle(
            //                   color: Theme.of(context).accentColor,
            //                   fontWeight: FontWeight.bold
            //                 ),
            //                 ),
            //                 Text("Textiles")
            //               ],
            //             ),
            //
            //           ),
            // ),
            //         Positioned(
            //          top: 7,
            //           child: Container(
            //             decoration: BoxDecoration(
            //                 // border: Border.all(color: Theme.of(context).accentColor),
            //               borderRadius: BorderRadius.circular(10),
            //             ),
            //               margin: new EdgeInsets.symmetric(
            //                     vertical: 16.0
            //                  ),
            //               alignment: FractionalOffset.centerLeft,
            //              child: CircleAvatar(
            //                radius: 30.0,
            //                backgroundColor:Theme.of(context).accentColor,
            //                child: CircleAvatar(
            //                  radius: 28.0,
            //                  backgroundColor:Theme.of(context).backgroundColor,
            //                  child: CircleAvatar(
            //
            //                    radius: 20.0,
            //                    backgroundColor:Theme.of(context).accentColor,
            //                    child: new Icon(Icons.money,
            //                    color: Theme.of(context).backgroundColor,
            //                    )
            //                  ),
            //                ),
            //              ),),
            //         ),
            //                       // Positioned(
            //                       //   right: 0,top: 0,
            //                       //   child: CircleAvatar(
            //                       //     radius: 20,
            //                       //     backgroundColor: Theme.of(context).accentColor,
            //                       //     child: CircleAvatar(
            //                       //       radius: 18,
            //                       //         backgroundColor: Theme.of(context).backgroundColor,
            //                       //         child: Icon(Icons.info,
            //                       //           color: Theme.of(context).accentColor,
            //                       //
            //                       //         )),
            //                       //   ),
            //                       // )
            //                    ],
            //                   )
                      ],)),
              ),),),
          floatingActionButton: cardExpanded
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 55.0),
                  child: SizedBox(
                    height: 50,
                    child: FloatingActionButton(
                      backgroundColor: Theme.of(context).accentColor,
                      child: Icon(Icons.add),
                      onPressed: () async {
                        RateDescriptionItem rateDescriptionItem =
                            await Navigator.push(
                                context,
                                MaterialPageRoute<RateDescriptionItem>(
                                    builder: (context) =>
                                        AddRateDescriptionForm()));
                        if (rateDescriptionItem != null) {
                          model..addRateDescriptionItem(rateDescriptionItem);
                        }
                      },
                    ),
                  ))
              : null,
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }
  Widget _button() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                Theme.of(context).accentColor,
                Color.lerp(Colors.blue, Colors.black, .05)
              ],
            ),
          ),
          child: ScaleTransition(
              scale: Tween(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve:  CurveWave(),
                ),
              ),
              child: Icon(Icons.dangerous_outlined, size: 44,)
          ),
        ),
      ),
    );
  }

  buildExpansionPanelList(EAWBModel model, bool alertvalue) {

    if (model.rateDescriptionItemList.isNotEmpty) {
      return Container(
        child: Column(
          children: model.rateDescriptionItemList
                 .map<Column>((RateDescriptionItem item) {
            return Column(
              children: [
                Dismissible(
                  key: ValueKey(item),
                  confirmDismiss: (DismissDirection direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              S.of(context).DeleteConfirmation,
                              style: TextStyle(color: Theme.of(context).accentColor),
                              //"Delete Confirmation"
                            ),
                            content: Text(
                              S.of(context).Areyousureyouwanttodeletethisitem,
                              style: TextStyle(color: Theme.of(context).accentColor),
                              //"Are you sure you want to delete this item?"
                            ),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                    model.deleteRateDescriptionItem(item);

                                    // model.deleteOtherChargesItem(item);
                                    // deleteAWB('${getawblist[index]["id"]}');
                                  },
                                  child: Text(
                                    // BuildContext context,
                                    S.of(context).Delete,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                    //"Delete"
                                  )),
                              FlatButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text(
                                  S.of(context).Cancel,
                                  style:
                                  TextStyle(color: Theme.of(context).accentColor),
                                  // "Cancel"
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      RateDescriptionItem rateDescriptionItem =
                      await Navigator.push(
                          context,
                          MaterialPageRoute<RateDescriptionItem>(
                              builder: (context) =>
                                  UpdateRateDescriptionForm(
                                    pieces: item.pieces,
                                    grossWeight: item.grossWeight,
                                    grossWeightUnit:
                                    item.grossWeightUnit,
                                    rateClass: item.rateClass,
                                    itemNumber: item.itemNumber,
                                    chargeableWeight:
                                    item.chargeableWeight,
                                    rateCharge: item.rateCharge,
                                    total: item.total,
                                    autoCalculations:
                                    item.autoCalculations,
                                    natureAndQuantity:
                                    item.natureAndQuantity,
                                    dimensionsList:
                                    item.dimensionsList,
                                    text: item.text,
                                  )));
                      if (rateDescriptionItem != null) {
                        model.deleteRateDescriptionItem(item);
                        model.addRateDescriptionItem(
                            rateDescriptionItem);
                      }
                    }
                  },
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {}
                  },
                  background: Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                              S.of(context).Delete
                              //'Delete'
                              ,
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Icon(Icons.edit, color: Colors.white),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            S.of(context).UpdateDetails,
                            //'Update Details',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: new EdgeInsets.only(left: 26.0),
                        decoration: new BoxDecoration(
                        //  color: Colors.white,
                          border: Border.all(color: Theme.of(context).accentColor,
                              width: 2
                          ),
                          shape: BoxShape.rectangle,
                          borderRadius: new BorderRadius.circular(13.0),
                          // boxShadow: <BoxShadow>[
                          //   new BoxShadow(
                          //     color: Colors.black12, blurRadius: 10.0,
                          //     offset: new Offset(0.0, 10.0),
                          //   ),
                          // ]
                          ),
                        child: Container(
                          padding: const EdgeInsets.only(left: 15,top: 4.0,bottom: 4),
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(S.of(context).Pieces,
                                        style: TextStyle(
                                            color: Theme.of(context).accentColor,
                                            fontWeight: FontWeight.bold

                                        ),
                                      ),
                                      Text('${item.pieces ?? ' '} '),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text("Gross Weight",
                                        style: TextStyle(
                                            color: Theme.of(context).accentColor,
                                            fontWeight: FontWeight.bold

                                        ),
                                      ),
                                      Text('${item.grossWeight.ceil() ?? ' '} ${item.grossWeightUnit ?? 'K'}'),

                                    ],
                                  ),
                                  Container(
                                      alignment: Alignment.topRight,
                                      child:  Row(
                                        children: [

                                          IconButton(onPressed: (){
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
                                                        title: Text("Information"),
                                                        centerTitle: true,
                                                      ),
                                                      body: SingleChildScrollView(
                                                        child: Container(
                                                          padding: EdgeInsets.all(30.0),
                                                          child: Column(
                                                            children: [
                                                              // ListTile(
                                                              //   title: Text(
                                                              //     S.of(context).Information,
                                                              //     //'Information',
                                                              //     textAlign: TextAlign.center,
                                                              //     style: TextStyle(
                                                              //         fontWeight: FontWeight.bold,
                                                              //         fontSize: 17,
                                                              //         color: Theme.of(context).accentColor),
                                                              //   ),
                                                              // ),
                                                              ListTile(
                                                                title: Text(
                                                                  S.of(context).Pieces,
                                                                  //'Pieces',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.normal,
                                                                      color: Theme.of(context).accentColor),
                                                                ),
                                                                trailing: Text(
                                                                  '${item.pieces ?? "1"}',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    //    color: Colors.black
                                                                  ),
                                                                ),
                                                              ),
                                                              ListTile(
                                                                title: Text(
                                                                  S.of(context).GrossWeight,
                                                                  //'Gross weight',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.normal,
                                                                      color: Theme.of(context).accentColor),
                                                                ),
                                                                trailing: Text(
                                                                  '${item.grossWeight.ceil() ?? "null"} ${item.grossWeightUnit ?? ""}',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    //    color: Colors.black
                                                                  ),
                                                                ),
                                                              ),
                                                              ListTile(
                                                                title: Text(
                                                                  S.of(context).Rateclass,
                                                                  //'Rate class',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.normal,
                                                                      color:Theme.of(context).accentColor),
                                                                ),
                                                                trailing: Text(
                                                                  '${item.rateClass ?? "null"}',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    //    color: Colors.black
                                                                  ),
                                                                ),
                                                              ),
                                                              ListTile(
                                                                title: Text(
                                                                  S.of(context).ItemNumber,
                                                                  // 'Item Number',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.normal,
                                                                      color:Theme.of(context).accentColor),
                                                                ),
                                                                trailing: Text(
                                                                  '${item.itemNumber ?? "null"}',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    //    color: Colors.black
                                                                  ),
                                                                ),
                                                              ),
                                                              ListTile(
                                                                title: Text(
                                                                  S.of(context).Chargeableweight,
                                                                  // 'Chargeable weight',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.normal,
                                                                      color: Theme.of(context).accentColor),
                                                                ),
                                                                trailing: Text(
                                                                  '${item.chargeableWeight ?? "null"}',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    //    color: Colors.black
                                                                  ),
                                                                ),
                                                              ),
                                                              ListTile(
                                                                title: Text(
                                                                  S.of(context).RateCharge,
                                                                  // 'Rate / Charge',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.normal,
                                                                      color: Theme.of(context).accentColor),
                                                                ),
                                                                trailing: Text(
                                                                  '${item.rateCharge ?? "null"}',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    //    color: Colors.black
                                                                  ),
                                                                ),
                                                              ),
                                                              ListTile(
                                                                title: Text(
                                                                  S.of(context).Total,
                                                                  //'Total',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.normal,
                                                                      color: Theme.of(context).accentColor),
                                                                ),
                                                                trailing: Text(
                                                                  '${item.total ?? "null"}',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    //    color: Colors.black
                                                                  ),
                                                                ),
                                                              ),
                                                              ListTile(
                                                                title: Text(
                                                                  S.of(context).Autocalculations,
                                                                  //'Auto - calculations',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.normal,
                                                                      color: Theme.of(context).accentColor),
                                                                ),
                                                                trailing: Text(
                                                                  '${item.autoCalculations ?? "null"}',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    //    color: Colors.black
                                                                  ),
                                                                ),
                                                              ),
                                                              ListTile(
                                                                title: Text(
                                                                  S.of(context).Natureandquantityofgoods,
                                                                  //'Nature and quantity of goods',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.normal,
                                                                      fontSize: 17,
                                                                      color: Theme.of(context).accentColor),
                                                                ),
                                                              ),
                                                              ListTile(
                                                                title: Text(
                                                                  S.of(context).NatureandQuantity,
                                                                  // 'Nature and Quantity',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.normal,
                                                                      color: Theme.of(context).accentColor),
                                                                ),
                                                                trailing: Text(
                                                                  '${item.natureAndQuantity ?? "null"}',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    //    color: Colors.black
                                                                  ),
                                                                ),
                                                              ),
                                                              ListTile(
                                                                title: Text(
                                                                  S.of(context).Dimensions,
                                                                  // 'Dimensions',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.normal,
                                                                      color: Theme.of(context).accentColor),
                                                                ),
                                                              ),
                                                              SingleChildScrollView(
                                                                scrollDirection: Axis.horizontal,
                                                                child: DataTable(
                                                                  columnSpacing: 15,
                                                                  columns: [
                                                                    DataColumn(
                                                                        label: Text(
                                                                          S.of(context).Length,
                                                                          //'Length',
                                                                          style: TextStyle(
                                                                              color: Theme.of(context).accentColor
                                                                          ),
                                                                        )),
                                                                    DataColumn(
                                                                        label: Text(
                                                                          S.of(context).Width,
                                                                          //'Width',
                                                                          style: TextStyle(
                                                                              color: Theme.of(context).accentColor
                                                                          ),
                                                                        )),
                                                                    DataColumn(
                                                                        label: Text(
                                                                          S.of(context).height,
                                                                          //'Height',
                                                                          style: TextStyle(
                                                                              color: Theme.of(context).accentColor
                                                                          ),
                                                                        )),
                                                                    DataColumn(
                                                                        label: Text(
                                                                          S.of(context).Unit,
                                                                          //'Unit',
                                                                          style: TextStyle(color: Theme.of(context).accentColor),
                                                                        )),
                                                                    DataColumn(
                                                                        label: Text(
                                                                          S.of(context).Pieces,
                                                                          //'Pieces',
                                                                          style: TextStyle(
                                                                              color:Theme.of(context).accentColor
                                                                          ),
                                                                        )),
                                                                    DataColumn(
                                                                        label: Text(
                                                                          S.of(context).Weight,
                                                                          //'Weight',
                                                                          style: TextStyle(color: Theme.of(context).accentColor),
                                                                        )),
                                                                    DataColumn(
                                                                        label: Text(
                                                                          S.of(context).Unit,
                                                                          //'Unit',
                                                                          style: TextStyle(color: Theme.of(context).accentColor),
                                                                        )),
                                                                  ],
                                                                  rows: item.dimensionsList
                                                                      .map<DataRow>((e) => DataRow(cells: [
                                                                    DataCell(Text(
                                                                      e['length'].toString(),
                                                                      style: TextStyle(
                                                                        //color: Colors.black
                                                                      ),
                                                                    )),
                                                                    DataCell(Text(
                                                                      e['width'].toString(),
                                                                      style: TextStyle(
                                                                        //    color: Colors.black
                                                                      ),
                                                                    )),
                                                                    DataCell(Text(
                                                                      e['height'].toString(),
                                                                      style: TextStyle(
                                                                        //    color: Colors.black
                                                                      ),
                                                                    )),
                                                                    DataCell(Text(
                                                                      e['lwhUnit'] ??= "cm",
                                                                      style: TextStyle(
                                                                        //    color: Colors.black
                                                                      ),
                                                                    )),
                                                                    DataCell(Text(
                                                                      (e['pieces'] ??= 1).toString(),
                                                                      style: TextStyle(
                                                                        //    color: Colors.black
                                                                      ),
                                                                    )),
                                                                    DataCell(Text(
                                                                      (e['weight'] ??= 0).toString(),
                                                                      style: TextStyle(
                                                                        //    color: Colors.black
                                                                      ),
                                                                    )),
                                                                    DataCell(Text(
                                                                      e['pwUnit'] ??= "K",
                                                                      style: TextStyle(
                                                                        //    color: Colors.black
                                                                      ),
                                                                    )),
                                                                  ]))
                                                                      .toList(),
                                                                ),
                                                              ),
                                                              ListTile(
                                                                title: Text(
                                                                  S.of(context).ExtraDescription,
                                                                  //   'Extra Description',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.normal,
                                                                      fontSize: 17,
                                                                      color: Theme.of(context).accentColor),
                                                                ),
                                                              ),
                                                              ListTile(
                                                                title: Text(
                                                                  S.of(context).Text,
                                                                  //'Text',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    //    color: Colors.black
                                                                  ),
                                                                ),
                                                                trailing: Text(
                                                                  '${item.text ?? S.of(context).Nodescription
                                                                  // "No description"
                                                                  }',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    //    color: Colors.black
                                                                  ),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  FlatButton(
                                                                    color: Theme.of(context).accentColor,
                                                                    onPressed: () {
                                                                      model.deleteRateDescriptionItem(item);
                                                                      setState(() {
                                                                        cardExpanded = true;
                                                                        previousIndex = 0;
                                                                      });
                                                                    },
                                                                    child: Icon(
                                                                      Icons.delete,
                                                                      color: Theme.of(context).backgroundColor,
                                                                      // S.of(context).Delete,
                                                                      // //"Delete",
                                                                      // style: TextStyle(
                                                                      //   color: Theme.of(context).backgroundColor,
                                                                      // ),
                                                                    ),
                                                                  ),
                                                                  TextButton(

                                                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor),

                                                                    ),
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                    child: Text("Close",
                                                                      style: TextStyle(
                                                                          color: Theme.of(context).backgroundColor
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  FlatButton(
                                                                    color: Theme.of(context).accentColor,
                                                                    onPressed: () async {
                                                                      RateDescriptionItem rateDescriptionItem =
                                                                      await Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute<RateDescriptionItem>(
                                                                              builder: (context) =>
                                                                                  UpdateRateDescriptionForm(
                                                                                    pieces: item.pieces,
                                                                                    grossWeight: item.grossWeight,
                                                                                    grossWeightUnit:
                                                                                    item.grossWeightUnit,
                                                                                    rateClass: item.rateClass,
                                                                                    itemNumber: item.itemNumber,
                                                                                    chargeableWeight:
                                                                                    item.chargeableWeight,
                                                                                    rateCharge: item.rateCharge,
                                                                                    total: item.total,
                                                                                    autoCalculations:
                                                                                    item.autoCalculations,
                                                                                    natureAndQuantity:
                                                                                    item.natureAndQuantity,
                                                                                    dimensionsList:
                                                                                    item.dimensionsList,
                                                                                    text: item.text,
                                                                                  )));
                                                                      if (rateDescriptionItem != null) {
                                                                        model.deleteRateDescriptionItem(item);
                                                                        model.addRateDescriptionItem(
                                                                            rateDescriptionItem);
                                                                      }
                                                                    },
                                                                    child: Icon(
                                                                      Icons.edit,
                                                                      color: Theme.of(context).backgroundColor,
                                                                      // S.of(context).Edit,
                                                                      // // "Edit",
                                                                      // style: TextStyle(
                                                                      //   color: Theme.of(context).backgroundColor,
                                                                      // ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                // showDialog(
                //   context: context,
                //   builder: (ctx) => SingleChildScrollView(
                //     child: AlertDialog(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(20),
                //       ),
                //       content: Container(
                //
                //         child: Column(
                //           children: [
                //             ListTile(
                //               title: Text(
                //                 S.of(context).Information,
                //                 //'Information',
                //                 textAlign: TextAlign.center,
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.bold,
                //                     fontSize: 17,
                //                     color: Theme.of(context).accentColor),
                //               ),
                //             ),
                //             ListTile(
                //               title: Text(
                //                 S.of(context).Pieces,
                //                 //'Pieces',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                     color: Theme.of(context).accentColor),
                //               ),
                //               trailing: Text(
                //                 '${item.pieces ?? "1"}',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                 //    color: Colors.black
                //                 ),
                //               ),
                //             ),
                //             ListTile(
                //               title: Text(
                //                 S.of(context).GrossWeight,
                //                 //'Gross weight',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                     color: Theme.of(context).accentColor),
                //               ),
                //               trailing: Text(
                //                 '${item.grossWeight.ceil() ?? "null"} ${item.grossWeightUnit ?? ""}',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                 //    color: Colors.black
                //                 ),
                //               ),
                //             ),
                //             ListTile(
                //               title: Text(
                //                 S.of(context).Rateclass,
                //                 //'Rate class',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                     color:Theme.of(context).accentColor),
                //               ),
                //               trailing: Text(
                //                 '${item.rateClass ?? "null"}',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                 //    color: Colors.black
                //                 ),
                //               ),
                //             ),
                //             ListTile(
                //               title: Text(
                //                 S.of(context).ItemNumber,
                //                 // 'Item Number',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                     color:Theme.of(context).accentColor),
                //               ),
                //               trailing: Text(
                //                 '${item.itemNumber ?? "null"}',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                 //    color: Colors.black
                //                 ),
                //               ),
                //             ),
                //             ListTile(
                //               title: Text(
                //                 S.of(context).Chargeableweight,
                //                 // 'Chargeable weight',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                     color: Theme.of(context).accentColor),
                //               ),
                //               trailing: Text(
                //                 '${item.chargeableWeight ?? "null"}',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                 //    color: Colors.black
                //                 ),
                //               ),
                //             ),
                //             ListTile(
                //               title: Text(
                //                 S.of(context).RateCharge,
                //                 // 'Rate / Charge',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                     color: Theme.of(context).accentColor),
                //               ),
                //               trailing: Text(
                //                 '${item.rateCharge ?? "null"}',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                 //    color: Colors.black
                //                 ),
                //               ),
                //             ),
                //             ListTile(
                //               title: Text(
                //                 S.of(context).Total,
                //                 //'Total',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                     color: Theme.of(context).accentColor),
                //               ),
                //               trailing: Text(
                //                 '${item.total ?? "null"}',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                 //    color: Colors.black
                //                 ),
                //               ),
                //             ),
                //             ListTile(
                //               title: Text(
                //                 S.of(context).Autocalculations,
                //                 //'Auto - calculations',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                     color: Theme.of(context).accentColor),
                //               ),
                //               trailing: Text(
                //                 '${item.autoCalculations ?? "null"}',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                 //    color: Colors.black
                //                 ),
                //               ),
                //             ),
                //             ListTile(
                //               title: Text(
                //                 S.of(context).Natureandquantityofgoods,
                //                 //'Nature and quantity of goods',
                //                 textAlign: TextAlign.center,
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                     fontSize: 17,
                //                     color: Theme.of(context).accentColor),
                //               ),
                //             ),
                //             ListTile(
                //               title: Text(
                //                 S.of(context).NatureandQuantity,
                //                 // 'Nature and Quantity',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                     color: Theme.of(context).accentColor),
                //               ),
                //               trailing: Text(
                //                 '${item.natureAndQuantity ?? "null"}',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                 //    color: Colors.black
                //                 ),
                //               ),
                //             ),
                //             ListTile(
                //               title: Text(
                //                 S.of(context).Dimensions,
                //                 // 'Dimensions',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                     color: Theme.of(context).accentColor),
                //               ),
                //             ),
                //             SingleChildScrollView(
                //               scrollDirection: Axis.horizontal,
                //               child: DataTable(
                //                 columnSpacing: 15,
                //                 columns: [
                //                   DataColumn(
                //                       label: Text(
                //                         S.of(context).Length,
                //                         //'Length',
                //                         style: TextStyle(
                //                             color: Theme.of(context).accentColor
                //                         ),
                //                       )),
                //                   DataColumn(
                //                       label: Text(
                //                         S.of(context).Width,
                //                         //'Width',
                //                         style: TextStyle(
                //                             color: Theme.of(context).accentColor
                //                         ),
                //                       )),
                //                   DataColumn(
                //                       label: Text(
                //                         S.of(context).height,
                //                         //'Height',
                //                         style: TextStyle(
                //                             color: Theme.of(context).accentColor
                //                         ),
                //                       )),
                //                   DataColumn(
                //                       label: Text(
                //                         S.of(context).Unit,
                //                         //'Unit',
                //                         style: TextStyle(color: Theme.of(context).accentColor),
                //                       )),
                //                   DataColumn(
                //                       label: Text(
                //                         S.of(context).Pieces,
                //                         //'Pieces',
                //                         style: TextStyle(
                //                             color:Theme.of(context).accentColor
                //                         ),
                //                       )),
                //                   DataColumn(
                //                       label: Text(
                //                         S.of(context).Weight,
                //                         //'Weight',
                //                         style: TextStyle(color: Theme.of(context).accentColor),
                //                       )),
                //                   DataColumn(
                //                       label: Text(
                //                         S.of(context).Unit,
                //                         //'Unit',
                //                         style: TextStyle(color: Theme.of(context).accentColor),
                //                       )),
                //                 ],
                //                 rows: item.dimensionsList
                //                     .map<DataRow>((e) => DataRow(cells: [
                //                   DataCell(Text(
                //                     e['length'].toString(),
                //                     style: TextStyle(
                //                         //color: Colors.black
                //                     ),
                //                   )),
                //                   DataCell(Text(
                //                     e['width'].toString(),
                //                     style: TextStyle(
                //                     //    color: Colors.black
                //                     ),
                //                   )),
                //                   DataCell(Text(
                //                     e['height'].toString(),
                //                     style: TextStyle(
                //                     //    color: Colors.black
                //                     ),
                //                   )),
                //                   DataCell(Text(
                //                     e['lwhUnit'] ??= "cm",
                //                     style: TextStyle(
                //                     //    color: Colors.black
                //                     ),
                //                   )),
                //                   DataCell(Text(
                //                     (e['pieces'] ??= 1).toString(),
                //                     style: TextStyle(
                //                     //    color: Colors.black
                //                     ),
                //                   )),
                //                   DataCell(Text(
                //                     (e['weight'] ??= 0).toString(),
                //                     style: TextStyle(
                //                     //    color: Colors.black
                //                     ),
                //                   )),
                //                   DataCell(Text(
                //                     e['pwUnit'] ??= "K",
                //                     style: TextStyle(
                //                     //    color: Colors.black
                //                     ),
                //                   )),
                //                 ]))
                //                     .toList(),
                //               ),
                //             ),
                //             ListTile(
                //               title: Text(
                //                 S.of(context).ExtraDescription,
                //                 //   'Extra Description',
                //                 textAlign: TextAlign.center,
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                     fontSize: 17,
                //                     color: Theme.of(context).accentColor),
                //               ),
                //             ),
                //             ListTile(
                //               title: Text(
                //                 S.of(context).Text,
                //                 //'Text',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                 //    color: Colors.black
                //                 ),
                //               ),
                //               trailing: Text(
                //                 '${item.text ?? S.of(context).Nodescription
                //                 // "No description"
                //                 }',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                 //    color: Colors.black
                //                 ),
                //               ),
                //             ),
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //               children: [
                //                 FlatButton(
                //                   color: Theme.of(context).accentColor,
                //                   onPressed: () {
                //                     model.deleteRateDescriptionItem(item);
                //                     setState(() {
                //                       cardExpanded = true;
                //                       previousIndex = 0;
                //                     });
                //                   },
                //                   child: Icon(
                //                     Icons.delete,
                //                     color: Theme.of(context).backgroundColor,
                //                     // S.of(context).Delete,
                //                     // //"Delete",
                //                     // style: TextStyle(
                //                     //   color: Theme.of(context).backgroundColor,
                //                     // ),
                //                   ),
                //                 ),
                //                 TextButton(
                //
                //                   style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor),
                //
                //                   ),
                //                   onPressed: () {
                //                     Navigator.of(ctx).pop();
                //                   },
                //                   child: Text("Close",
                //                     style: TextStyle(
                //                         color: Theme.of(context).backgroundColor
                //                     ),
                //                   ),
                //                 ),
                //                 FlatButton(
                //                   color: Theme.of(context).accentColor,
                //                   onPressed: () async {
                //                     RateDescriptionItem rateDescriptionItem =
                //                     await Navigator.push(
                //                         context,
                //                         MaterialPageRoute<RateDescriptionItem>(
                //                             builder: (context) =>
                //                                 UpdateRateDescriptionForm(
                //                                   pieces: item.pieces,
                //                                   grossWeight: item.grossWeight,
                //                                   grossWeightUnit:
                //                                   item.grossWeightUnit,
                //                                   rateClass: item.rateClass,
                //                                   itemNumber: item.itemNumber,
                //                                   chargeableWeight:
                //                                   item.chargeableWeight,
                //                                   rateCharge: item.rateCharge,
                //                                   total: item.total,
                //                                   autoCalculations:
                //                                   item.autoCalculations,
                //                                   natureAndQuantity:
                //                                   item.natureAndQuantity,
                //                                   dimensionsList:
                //                                   item.dimensionsList,
                //                                   text: item.text,
                //                                 )));
                //                     if (rateDescriptionItem != null) {
                //                       model.deleteRateDescriptionItem(item);
                //                       model.addRateDescriptionItem(
                //                           rateDescriptionItem);
                //                     }
                //                   },
                //                   child: Icon(
                //                     Icons.edit,
                //                     color: Theme.of(context).backgroundColor,
                //                     // S.of(context).Edit,
                //                     // // "Edit",
                //                     // style: TextStyle(
                //                     //   color: Theme.of(context).backgroundColor,
                //                     // ),
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ],
                //         ),
                //       ),
                //
                //     ),
                //   ),
                // );
              }, icon: Icon(Icons.info,
                color: Theme.of(context).accentColor,
              )),
                                          // Text(alertvalue.toString()),

                                        ],
                                      ),

                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 14.0,right: 25.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text("Nature of Goods",
                                          style: TextStyle(
                                              color: Theme.of(context).accentColor,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text( '${item.natureAndQuantity ?? ' '}')
                                      ],
                                    ),
                                    (alertvalue)?CustomPaint(
                                      painter: CirclePainter(
                                          _controller,
                                          color: Colors.red
                                      ),
                                      child: SizedBox(
                                          height: 40,
                                          width:40,
                                          child: Text("")
                                        //_button(),
                                      ),
                                    ):CustomPaint(
                                      painter: CirclePainter(
                                          _controller,
                                          color: Colors.green
                                      ),
                                      child: SizedBox(
                                          height: 40,
                                          width:40,
                                          child: Text("")
                                        //_button(),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                            ],
                          ),

                        ),
                      ),
                      Positioned(
                        top: 7,
                        child: Container(
                          decoration: BoxDecoration(
                            // border: Border.all(color: Theme.of(context).accentColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: new EdgeInsets.symmetric(
                              vertical: 16.0
                          ),
                          alignment: FractionalOffset.centerLeft,
                          child: CircleAvatar(
                            radius: 25.0,
                            backgroundColor:Theme.of(context).accentColor,
                            child: CircleAvatar(
                              radius: 23.0,
                              backgroundColor:Theme.of(context).backgroundColor,
                              child: CircleAvatar(

                                  radius: 18.0,
                                  backgroundColor:Theme.of(context).accentColor,
                                  child: new Icon(Icons.money,
                                    size: 20,
                                    color: Theme.of(context).backgroundColor,
                                  )
                              ),
                            ),
                          ),),
                      ),
                      // Positioned(
                      //   right: 0,top: 0,
                      //   child: CircleAvatar(
                      //     radius: 20,
                      //     backgroundColor: Theme.of(context).accentColor,
                      //     child: CircleAvatar(
                      //       radius: 18,
                      //         backgroundColor: Theme.of(context).backgroundColor,
                      //         child: Icon(Icons.info,
                      //           color: Theme.of(context).accentColor,
                      //
                      //         )),
                      //   ),
                      // )
                    ],
                  ),
                  // child: Card(
                  //   elevation: 2,
                  //   shadowColor: Theme.of(context).accentColor,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(15.0)
                  //   ),
                  //   child:
                  //   Column(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 15.0),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //               Column(
                  //                 children: [
                  //                   Text("Pieces",
                  //                   style: TextStyle(
                  //                     color: Theme.of(context).accentColor,
                  //                     fontWeight: FontWeight.bold
                  //                   ),
                  //                   ),
                  //                   Text(
                  //                       '${item.pieces ?? ' '} '),
                  //
                  //                 ],
                  //               ), Column(
                  //                 children: [
                  //                   Text("Gross Weight",
                  //                     style: TextStyle(
                  //                         color: Theme.of(context).accentColor,
                  //                         fontWeight: FontWeight.bold
                  //                     ),
                  //                   ),
                  //                   Text(
                  //                       '${item.grossWeight.ceil() ?? ' '} ${item.grossWeightUnit ?? 'K'}'),
                  //                 ],
                  //               ),
                  //             Column(
                  //               children: [
                  //                 Text("Nature of Goods",
                  //                   style: TextStyle(
                  //                       color: Theme.of(context).accentColor,
                  //                       fontWeight: FontWeight.bold
                  //                   ),
                  //                 ),
                  //                 Text(
                  //                     '${item.natureAndQuantity ?? ' '}'),
                  //               ],
                  //             ),
                  //
                  //           ],
                  //         ),
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.all(10.0),
                  //             child: IconButton(
                  //               color: Theme.of(context).backgroundColor,
                  //               onPressed: () {
                  //                 showGeneralDialog(
                  //                     context: context,
                  //                     barrierDismissible: true,
                  //                     barrierLabel: MaterialLocalizations.of(context)
                  //                         .modalBarrierDismissLabel,
                  //                     barrierColor: Colors.black45,
                  //                     transitionDuration: const Duration(milliseconds: 200),
                  //                     pageBuilder: (BuildContext buildContext,
                  //                         Animation animation,
                  //                         Animation secondaryAnimation) {
                  //                       return SafeArea(
                  //                         child: Scaffold(
                  //                           appBar: AppBar(
                  //                             backgroundColor: Theme.of(context).primaryColor,
                  //                             title: Text("Help"),
                  //                             centerTitle: true,
                  //                           ),
                  //                           body: SingleChildScrollView(
                  //                             child: Card(
                  //                               shape: RoundedRectangleBorder(
                  //                                 side: BorderSide(color: Colors.white70, width: 1),
                  //                                 borderRadius: BorderRadius.circular(10),
                  //                               ),
                  //                               child: Container(
                  //                                 padding: EdgeInsets.all(10.0),
                  //                                // color: Colors.grey[100],
                  //                                 child: Column(
                  //                                   children: [
                  //                                     ListTile(
                  //                                       title: Text(
                  //                                         S.of(context).Information,
                  //                                         //'Information',
                  //                                         textAlign: TextAlign.center,
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             fontSize: 17,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                     ),
                  //                                     ListTile(
                  //                                       title: Text(
                  //                                         S.of(context).Pieces,
                  //                                         //'Pieces',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                       trailing: Text(
                  //                                         '${item.pieces ?? "1"}',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                     ),
                  //                                     ListTile(
                  //                                       title: Text(
                  //                                         S.of(context).GrossWeight,
                  //                                         //'Gross weight',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                       trailing: Text(
                  //                                         '${item.grossWeight.ceil() ?? "null"} ${item.grossWeightUnit ?? ""}',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                     ),
                  //                                     ListTile(
                  //                                       title: Text(
                  //                                         S.of(context).Rateclass,
                  //                                         //'Rate class',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                       trailing: Text(
                  //                                         '${item.rateClass ?? "null"}',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                     ),
                  //                                     ListTile(
                  //                                       title: Text(
                  //                                         S.of(context).ItemNumber,
                  //                                         // 'Item Number',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                       trailing: Text(
                  //                                         '${item.itemNumber ?? "null"}',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                     ),
                  //                                     ListTile(
                  //                                       title: Text(
                  //                                         S.of(context).Chargeableweight,
                  //                                         // 'Chargeable weight',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                       trailing: Text(
                  //                                         '${item.chargeableWeight ?? "null"}',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                     ),
                  //                                     ListTile(
                  //                                       title: Text(
                  //                                         S.of(context).RateCharge,
                  //                                         // 'Rate / Charge',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                       trailing: Text(
                  //                                         '${item.rateCharge ?? "null"}',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                     ),
                  //                                     ListTile(
                  //                                       title: Text(
                  //                                         S.of(context).Total,
                  //                                         //'Total',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                       trailing: Text(
                  //                                         '${item.total ?? "null"}',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                     ),
                  //                                     ListTile(
                  //                                       title: Text(
                  //                                         S.of(context).Autocalculations,
                  //                                         //'Auto - calculations',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                       trailing: Text(
                  //                                         '${item.autoCalculations ?? "null"}',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                     ),
                  //                                     ListTile(
                  //                                       title: Text(
                  //                                         S.of(context).Natureandquantityofgoods,
                  //                                         //'Nature and quantity of goods',
                  //                                         textAlign: TextAlign.center,
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             fontSize: 17,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                     ),
                  //                                     ListTile(
                  //                                       title: Text(
                  //                                         S.of(context).NatureandQuantity,
                  //                                         // 'Nature and Quantity',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                       trailing: Text(
                  //                                         '${item.natureAndQuantity ?? "null"}',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                     ),
                  //                                     ListTile(
                  //                                       title: Text(
                  //                                         S.of(context).Dimensions,
                  //                                         // 'Dimensions',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                     ),
                  //                                     SingleChildScrollView(
                  //                                       scrollDirection: Axis.horizontal,
                  //                                       child: DataTable(
                  //                                         columnSpacing: 15,
                  //                                         columns: [
                  //                                           DataColumn(
                  //                                               label: Text(
                  //                                                 S.of(context).Length,
                  //                                                 //'Length',
                  //                                                 style: TextStyle(color: Colors.black),
                  //                                               )),
                  //                                           DataColumn(
                  //                                               label: Text(
                  //                                                 S.of(context).Width,
                  //                                                 //'Width',
                  //                                                 style: TextStyle(color: Colors.black),
                  //                                               )),
                  //                                           DataColumn(
                  //                                               label: Text(
                  //                                                 S.of(context).height,
                  //                                                 //'Height',
                  //                                                 style: TextStyle(color: Colors.black),
                  //                                               )),
                  //                                           DataColumn(
                  //                                               label: Text(
                  //                                                 S.of(context).Unit,
                  //                                                 //'Unit',
                  //                                                 style: TextStyle(color: Colors.black),
                  //                                               )),
                  //                                           DataColumn(
                  //                                               label: Text(
                  //                                                 S.of(context).Pieces,
                  //                                                 //'Pieces',
                  //                                                 style: TextStyle(color: Colors.black),
                  //                                               )),
                  //                                           DataColumn(
                  //                                               label: Text(
                  //                                                 S.of(context).Weight,
                  //                                                 //'Weight',
                  //                                                 style: TextStyle(color: Colors.black),
                  //                                               )),
                  //                                           DataColumn(
                  //                                               label: Text(
                  //                                                 S.of(context).Unit,
                  //                                                 //'Unit',
                  //                                                 style: TextStyle(color: Colors.black),
                  //                                               )),
                  //                                         ],
                  //                                         rows: item.dimensionsList
                  //                                             .map<DataRow>((e) => DataRow(cells: [
                  //                                           DataCell(Text(
                  //                                             e['length'].toString(),
                  //                                             style: TextStyle(color: Colors.black),
                  //                                           )),
                  //                                           DataCell(Text(
                  //                                             e['width'].toString(),
                  //                                             style: TextStyle(color: Colors.black),
                  //                                           )),
                  //                                           DataCell(Text(
                  //                                             e['height'].toString(),
                  //                                             style: TextStyle(color: Colors.black),
                  //                                           )),
                  //                                           DataCell(Text(
                  //                                             e['lwhUnit'] ??= "cm",
                  //                                             style: TextStyle(color: Colors.black),
                  //                                           )),
                  //                                           DataCell(Text(
                  //                                             (e['pieces'] ??= 1).toString(),
                  //                                             style: TextStyle(color: Colors.black),
                  //                                           )),
                  //                                           DataCell(Text(
                  //                                             (e['weight'] ??= 0).toString(),
                  //                                             style: TextStyle(color: Colors.black),
                  //                                           )),
                  //                                           DataCell(Text(
                  //                                             e['pwUnit'] ??= "K",
                  //                                             style: TextStyle(color: Colors.black),
                  //                                           )),
                  //                                         ]))
                  //                                             .toList(),
                  //                                       ),
                  //                                     ),
                  //                                     ListTile(
                  //                                       title: Text(
                  //                                         S.of(context).ExtraDescription,
                  //                                         //   'Extra Description',
                  //                                         textAlign: TextAlign.center,
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             fontSize: 17,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                     ),
                  //                                     ListTile(
                  //                                       title: Text(
                  //                                         S.of(context).Text,
                  //                                         //'Text',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                       trailing: Text(
                  //                                         '${item.text ?? S.of(context).Nodescription
                  //                                         // "No description"
                  //                                         }',
                  //                                         style: TextStyle(
                  //                                             fontWeight: FontWeight.normal,
                  //                                             color: Colors.black),
                  //                                       ),
                  //                                     ),
                  //                                     Row(
                  //                                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //                                       children: [
                  //                                         FlatButton(
                  //                                           color: Theme.of(context).accentColor,
                  //                                           onPressed: () {
                  //                                             model.deleteRateDescriptionItem(item);
                  //                                             setState(() {
                  //                                               cardExpanded = true;
                  //                                               previousIndex = 0;
                  //                                             });
                  //                                           },
                  //                                           child: Text(
                  //                                             S.of(context).Delete,
                  //                                             //"Delete",
                  //                                             style: TextStyle(
                  //                                               color: Theme.of(context).backgroundColor,
                  //                                             ),
                  //                                           ),
                  //                                         ),
                  //                                         FlatButton(
                  //                                           color: Theme.of(context).accentColor,
                  //                                           onPressed: () async {
                  //                                             RateDescriptionItem rateDescriptionItem =
                  //                                             await Navigator.push(
                  //                                                 context,
                  //                                                 MaterialPageRoute<RateDescriptionItem>(
                  //                                                     builder: (context) =>
                  //                                                         AddRateDescriptionForm(
                  //                                                           pieces: item.pieces,
                  //                                                           grossWeight: item.grossWeight,
                  //                                                           grossWeightUnit:
                  //                                                           item.grossWeightUnit,
                  //                                                           rateClass: item.rateClass,
                  //                                                           itemNumber: item.itemNumber,
                  //                                                           chargeableWeight:
                  //                                                           item.chargeableWeight,
                  //                                                           rateCharge: item.rateCharge,
                  //                                                           total: item.total,
                  //                                                           autoCalculations:
                  //                                                           item.autoCalculations,
                  //                                                           natureAndQuantity:
                  //                                                           item.natureAndQuantity,
                  //                                                           dimensionsList:
                  //                                                           item.dimensionsList,
                  //                                                           text: item.text,
                  //                                                         )));
                  //                                             if (rateDescriptionItem != null) {
                  //                                               model.deleteRateDescriptionItem(item);
                  //                                               model.addRateDescriptionItem(
                  //                                                   rateDescriptionItem);
                  //                                             }
                  //                                           },
                  //                                           child: Text(
                  //                                             S.of(context).Edit,
                  //                                             // "Edit",
                  //                                             style: TextStyle(
                  //                                               color: Theme.of(context).backgroundColor,
                  //                                             ),
                  //                                           ),
                  //                                         )
                  //                                       ],
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       );
                  //                     });
                  //               },
                  //               icon: Icon(Icons.info,
                  //                 color: Theme.of(context).accentColor,
                  //               ),
                  //
                  //             ),
                  //           ),
                  //           IconButton(onPressed: (){
                  //             showDialog(
                  //               context: context,
                  //               builder: (ctx) => SingleChildScrollView(
                  //                 child: AlertDialog(
                  //                   shape: RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.circular(20),
                  //                   ),
                  //                   content: Container(
                  //
                  //                     child: Column(
                  //                       children: [
                  //                         ListTile(
                  //                           title: Text(
                  //                             S.of(context).Information,
                  //                             //'Information',
                  //                             textAlign: TextAlign.center,
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.bold,
                  //                                 fontSize: 17,
                  //                                 color: Colors.black),
                  //                           ),
                  //                         ),
                  //                         ListTile(
                  //                           title: Text(
                  //                             S.of(context).Pieces,
                  //                             //'Pieces',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                           trailing: Text(
                  //                             '${item.pieces ?? "1"}',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                         ),
                  //                         ListTile(
                  //                           title: Text(
                  //                             S.of(context).GrossWeight,
                  //                             //'Gross weight',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                           trailing: Text(
                  //                             '${item.grossWeight.ceil() ?? "null"} ${item.grossWeightUnit ?? ""}',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                         ),
                  //                         ListTile(
                  //                           title: Text(
                  //                             S.of(context).Rateclass,
                  //                             //'Rate class',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                           trailing: Text(
                  //                             '${item.rateClass ?? "null"}',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                         ),
                  //                         ListTile(
                  //                           title: Text(
                  //                             S.of(context).ItemNumber,
                  //                             // 'Item Number',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                           trailing: Text(
                  //                             '${item.itemNumber ?? "null"}',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                         ),
                  //                         ListTile(
                  //                           title: Text(
                  //                             S.of(context).Chargeableweight,
                  //                             // 'Chargeable weight',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                           trailing: Text(
                  //                             '${item.chargeableWeight ?? "null"}',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                         ),
                  //                         ListTile(
                  //                           title: Text(
                  //                             S.of(context).RateCharge,
                  //                             // 'Rate / Charge',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                           trailing: Text(
                  //                             '${item.rateCharge ?? "null"}',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                         ),
                  //                         ListTile(
                  //                           title: Text(
                  //                             S.of(context).Total,
                  //                             //'Total',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                           trailing: Text(
                  //                             '${item.total ?? "null"}',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                         ),
                  //                         ListTile(
                  //                           title: Text(
                  //                             S.of(context).Autocalculations,
                  //                             //'Auto - calculations',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                           trailing: Text(
                  //                             '${item.autoCalculations ?? "null"}',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                         ),
                  //                         ListTile(
                  //                           title: Text(
                  //                             S.of(context).Natureandquantityofgoods,
                  //                             //'Nature and quantity of goods',
                  //                             textAlign: TextAlign.center,
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 fontSize: 17,
                  //                                 color: Colors.black),
                  //                           ),
                  //                         ),
                  //                         ListTile(
                  //                           title: Text(
                  //                             S.of(context).NatureandQuantity,
                  //                             // 'Nature and Quantity',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                           trailing: Text(
                  //                             '${item.natureAndQuantity ?? "null"}',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                         ),
                  //                         ListTile(
                  //                           title: Text(
                  //                             S.of(context).Dimensions,
                  //                             // 'Dimensions',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                         ),
                  //                         SingleChildScrollView(
                  //                           scrollDirection: Axis.horizontal,
                  //                           child: DataTable(
                  //                             columnSpacing: 15,
                  //                             columns: [
                  //                               DataColumn(
                  //                                   label: Text(
                  //                                     S.of(context).Length,
                  //                                     //'Length',
                  //                                     style: TextStyle(color: Colors.black),
                  //                                   )),
                  //                               DataColumn(
                  //                                   label: Text(
                  //                                     S.of(context).Width,
                  //                                     //'Width',
                  //                                     style: TextStyle(color: Colors.black),
                  //                                   )),
                  //                               DataColumn(
                  //                                   label: Text(
                  //                                     S.of(context).height,
                  //                                     //'Height',
                  //                                     style: TextStyle(color: Colors.black),
                  //                                   )),
                  //                               DataColumn(
                  //                                   label: Text(
                  //                                     S.of(context).Unit,
                  //                                     //'Unit',
                  //                                     style: TextStyle(color: Colors.black),
                  //                                   )),
                  //                               DataColumn(
                  //                                   label: Text(
                  //                                     S.of(context).Pieces,
                  //                                     //'Pieces',
                  //                                     style: TextStyle(color: Colors.black),
                  //                                   )),
                  //                               DataColumn(
                  //                                   label: Text(
                  //                                     S.of(context).Weight,
                  //                                     //'Weight',
                  //                                     style: TextStyle(color: Colors.black),
                  //                                   )),
                  //                               DataColumn(
                  //                                   label: Text(
                  //                                     S.of(context).Unit,
                  //                                     //'Unit',
                  //                                     style: TextStyle(color: Colors.black),
                  //                                   )),
                  //                             ],
                  //                             rows: item.dimensionsList
                  //                                 .map<DataRow>((e) => DataRow(cells: [
                  //                               DataCell(Text(
                  //                                 e['length'].toString(),
                  //                                 style: TextStyle(color: Colors.black),
                  //                               )),
                  //                               DataCell(Text(
                  //                                 e['width'].toString(),
                  //                                 style: TextStyle(color: Colors.black),
                  //                               )),
                  //                               DataCell(Text(
                  //                                 e['height'].toString(),
                  //                                 style: TextStyle(color: Colors.black),
                  //                               )),
                  //                               DataCell(Text(
                  //                                 e['lwhUnit'] ??= "cm",
                  //                                 style: TextStyle(color: Colors.black),
                  //                               )),
                  //                               DataCell(Text(
                  //                                 (e['pieces'] ??= 1).toString(),
                  //                                 style: TextStyle(color: Colors.black),
                  //                               )),
                  //                               DataCell(Text(
                  //                                 (e['weight'] ??= 0).toString(),
                  //                                 style: TextStyle(color: Colors.black),
                  //                               )),
                  //                               DataCell(Text(
                  //                                 e['pwUnit'] ??= "K",
                  //                                 style: TextStyle(color: Colors.black),
                  //                               )),
                  //                             ]))
                  //                                 .toList(),
                  //                           ),
                  //                         ),
                  //                         ListTile(
                  //                           title: Text(
                  //                             S.of(context).ExtraDescription,
                  //                             //   'Extra Description',
                  //                             textAlign: TextAlign.center,
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 fontSize: 17,
                  //                                 color: Colors.black),
                  //                           ),
                  //                         ),
                  //                         ListTile(
                  //                           title: Text(
                  //                             S.of(context).Text,
                  //                             //'Text',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                           trailing: Text(
                  //                             '${item.text ?? S.of(context).Nodescription
                  //                             // "No description"
                  //                             }',
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.normal,
                  //                                 color: Colors.black),
                  //                           ),
                  //                         ),
                  //                         Row(
                  //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //                           children: [
                  //                             FlatButton(
                  //                               color: Theme.of(context).accentColor,
                  //                               onPressed: () {
                  //                                 model.deleteRateDescriptionItem(item);
                  //                                 setState(() {
                  //                                   cardExpanded = true;
                  //                                   previousIndex = 0;
                  //                                 });
                  //                               },
                  //                               child: Text(
                  //                                 S.of(context).Delete,
                  //                                 //"Delete",
                  //                                 style: TextStyle(
                  //                                   color: Colors.black,
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                             FlatButton(
                  //                               color: Theme.of(context).accentColor,
                  //                               onPressed: () async {
                  //                                 RateDescriptionItem rateDescriptionItem =
                  //                                 await Navigator.push(
                  //                                     context,
                  //                                     MaterialPageRoute<RateDescriptionItem>(
                  //                                         builder: (context) =>
                  //                                             AddRateDescriptionForm(
                  //                                               pieces: item.pieces,
                  //                                               grossWeight: item.grossWeight,
                  //                                               grossWeightUnit:
                  //                                               item.grossWeightUnit,
                  //                                               rateClass: item.rateClass,
                  //                                               itemNumber: item.itemNumber,
                  //                                               chargeableWeight:
                  //                                               item.chargeableWeight,
                  //                                               rateCharge: item.rateCharge,
                  //                                               total: item.total,
                  //                                               autoCalculations:
                  //                                               item.autoCalculations,
                  //                                               natureAndQuantity:
                  //                                               item.natureAndQuantity,
                  //                                               dimensionsList:
                  //                                               item.dimensionsList,
                  //                                               text: item.text,
                  //                                             )));
                  //                                 if (rateDescriptionItem != null) {
                  //                                   model.deleteRateDescriptionItem(item);
                  //                                   model.addRateDescriptionItem(
                  //                                       rateDescriptionItem);
                  //                                 }
                  //                               },
                  //                               child: Text(
                  //                                 S.of(context).Edit,
                  //                                 // "Edit",
                  //                                 style: TextStyle(
                  //                                   color: Colors.black,
                  //                                 ),
                  //                               ),
                  //                             )
                  //                           ],
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   actions: <Widget>[
                  //                     Center(
                  //                       child: TextButton(
                  //
                  //                         style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor),
                  //
                  //                         ),
                  //                         onPressed: () {
                  //                           Navigator.of(ctx).pop();
                  //                         },
                  //                         child: Text("Close",
                  //                           style: TextStyle(
                  //                               color: Theme.of(context).backgroundColor
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             );
                  //           }, icon: Icon(Icons.info,
                  //             color: Theme.of(context).accentColor,
                  //           )),
                  //         ],
                  //       ),
                  //
                  //     ],
                  //   ),
                  // ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            );
          }).toList(),
        ),
      );
      // return ExpansionPanelList(
      //   animationDuration: Duration(milliseconds: 1000),
      //   elevation: 1,
      //   expansionCallback: (panelIndex, isExpanded) {
      //     model.rateDescriptionItemList[previousIndex].isExpanded = false;
      //     model.rateDescriptionItemList[panelIndex].isExpanded = !isExpanded;
      //     setState(() {
      //       previousIndex = panelIndex;
      //       cardExpanded = isExpanded;
      //     });
      //   },
      //   children: model.rateDescriptionItemList
      //       .map<ExpansionPanel>((RateDescriptionItem item) {
      //     return ExpansionPanel(
      //
      //         canTapOnHeader: true,
      //         headerBuilder: (context, isExpanded) {
      //           return ListTile(
      //             title: Text(
      //                 '${item.pieces ?? ' '} Pieces / ${item.grossWeight.ceil() ?? ' '} ${item.grossWeightUnit ?? 'K'}/ ${item.natureAndQuantity ?? ' '}'),
      //           );
      //         },
      //         body: Card(
      //           shape: RoundedRectangleBorder(
      //             side: BorderSide(color: Colors.white70, width: 1),
      //             borderRadius: BorderRadius.circular(10),
      //           ),
      //           child: Container(
      //             color: Colors.grey[100],
      //             child: Column(
      //               children: [
      //                 ListTile(
      //                   title: Text(
      //                     S.of(context).Information,
      //                     //'Information',
      //                     textAlign: TextAlign.center,
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         fontSize: 17,
      //                         color: Colors.black),
      //                   ),
      //                 ),
      //                 ListTile(
      //                   title: Text(
      //                     S.of(context).Pieces,
      //                     //'Pieces',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                   trailing: Text(
      //                     '${item.pieces ?? "1"}',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                 ),
      //                 ListTile(
      //                   title: Text(
      //                     S.of(context).GrossWeight,
      //                     //'Gross weight',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                   trailing: Text(
      //                     '${item.grossWeight.ceil() ?? "null"} ${item.grossWeightUnit ?? ""}',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                 ),
      //                 ListTile(
      //                   title: Text(
      //                     S.of(context).Rateclass,
      //                     //'Rate class',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                   trailing: Text(
      //                     '${item.rateClass ?? "null"}',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                 ),
      //                 ListTile(
      //                   title: Text(
      //                     S.of(context).ItemNumber,
      //                     // 'Item Number',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                   trailing: Text(
      //                     '${item.itemNumber ?? "null"}',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                 ),
      //                 ListTile(
      //                   title: Text(
      //                     S.of(context).Chargeableweight,
      //                     // 'Chargeable weight',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                   trailing: Text(
      //                     '${item.chargeableWeight ?? "null"}',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                 ),
      //                 ListTile(
      //                   title: Text(
      //                     S.of(context).RateCharge,
      //                     // 'Rate / Charge',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                   trailing: Text(
      //                     '${item.rateCharge ?? "null"}',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                 ),
      //                 ListTile(
      //                   title: Text(
      //                     S.of(context).Total,
      //                     //'Total',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                   trailing: Text(
      //                     '${item.total ?? "null"}',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                 ),
      //                 ListTile(
      //                   title: Text(
      //                     S.of(context).Autocalculations,
      //                     //'Auto - calculations',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                   trailing: Text(
      //                     '${item.autoCalculations ?? "null"}',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                 ),
      //                 ListTile(
      //                   title: Text(
      //                     S.of(context).Natureandquantityofgoods,
      //                     //'Nature and quantity of goods',
      //                     textAlign: TextAlign.center,
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         fontSize: 17,
      //                         color: Colors.black),
      //                   ),
      //                 ),
      //                 ListTile(
      //                   title: Text(
      //                     S.of(context).NatureandQuantity,
      //                     // 'Nature and Quantity',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                   trailing: Text(
      //                     '${item.natureAndQuantity ?? "null"}',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                 ),
      //                 ListTile(
      //                   title: Text(
      //                     S.of(context).Dimensions,
      //                     // 'Dimensions',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                 ),
      //                 SingleChildScrollView(
      //                   scrollDirection: Axis.horizontal,
      //                   child: DataTable(
      //                     columnSpacing: 15,
      //                     columns: [
      //                       DataColumn(
      //                           label: Text(
      //                         S.of(context).Length,
      //                         //'Length',
      //                         style: TextStyle(color: Colors.black),
      //                       )),
      //                       DataColumn(
      //                           label: Text(
      //                         S.of(context).Width,
      //                         //'Width',
      //                         style: TextStyle(color: Colors.black),
      //                       )),
      //                       DataColumn(
      //                           label: Text(
      //                         S.of(context).height,
      //                         //'Height',
      //                         style: TextStyle(color: Colors.black),
      //                       )),
      //                       DataColumn(
      //                           label: Text(
      //                         S.of(context).Unit,
      //                         //'Unit',
      //                         style: TextStyle(color: Colors.black),
      //                       )),
      //                       DataColumn(
      //                           label: Text(
      //                         S.of(context).Pieces,
      //                         //'Pieces',
      //                         style: TextStyle(color: Colors.black),
      //                       )),
      //                       DataColumn(
      //                           label: Text(
      //                         S.of(context).Weight,
      //                         //'Weight',
      //                         style: TextStyle(color: Colors.black),
      //                       )),
      //                       DataColumn(
      //                           label: Text(
      //                         S.of(context).Unit,
      //                         //'Unit',
      //                         style: TextStyle(color: Colors.black),
      //                       )),
      //                     ],
      //                     rows: item.dimensionsList
      //                         .map<DataRow>((e) => DataRow(cells: [
      //                               DataCell(Text(
      //                                 e['length'].toString(),
      //                                 style: TextStyle(color: Colors.black),
      //                               )),
      //                               DataCell(Text(
      //                                 e['width'].toString(),
      //                                 style: TextStyle(color: Colors.black),
      //                               )),
      //                               DataCell(Text(
      //                                 e['height'].toString(),
      //                                 style: TextStyle(color: Colors.black),
      //                               )),
      //                               DataCell(Text(
      //                                 e['lwhUnit'] ??= "cm",
      //                                 style: TextStyle(color: Colors.black),
      //                               )),
      //                               DataCell(Text(
      //                                 (e['pieces'] ??= 1).toString(),
      //                                 style: TextStyle(color: Colors.black),
      //                               )),
      //                               DataCell(Text(
      //                                 (e['weight'] ??= 0).toString(),
      //                                 style: TextStyle(color: Colors.black),
      //                               )),
      //                               DataCell(Text(
      //                                 e['pwUnit'] ??= "K",
      //                                 style: TextStyle(color: Colors.black),
      //                               )),
      //                             ]))
      //                         .toList(),
      //                   ),
      //                 ),
      //                 ListTile(
      //                   title: Text(
      //                     S.of(context).ExtraDescription,
      //                     //   'Extra Description',
      //                     textAlign: TextAlign.center,
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         fontSize: 17,
      //                         color: Colors.black),
      //                   ),
      //                 ),
      //                 ListTile(
      //                   title: Text(
      //                     S.of(context).Text,
      //                     //'Text',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                   trailing: Text(
      //                     '${item.text ?? S.of(context).Nodescription
      //                     // "No description"
      //                     }',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.normal,
      //                         color: Colors.black),
      //                   ),
      //                 ),
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                   children: [
      //                     FlatButton(
      //                       color: Theme.of(context).accentColor,
      //                       onPressed: () {
      //                         model.deleteRateDescriptionItem(item);
      //                         setState(() {
      //                           cardExpanded = true;
      //                           previousIndex = 0;
      //                         });
      //                       },
      //                       child: Text(
      //                         S.of(context).Delete,
      //                         //"Delete",
      //                         style: TextStyle(
      //                           color: Colors.black,
      //                         ),
      //                       ),
      //                     ),
      //                     FlatButton(
      //                       color: Theme.of(context).accentColor,
      //                       onPressed: () async {
      //                         RateDescriptionItem rateDescriptionItem =
      //                             await Navigator.push(
      //                                 context,
      //                                 MaterialPageRoute<RateDescriptionItem>(
      //                                     builder: (context) =>
      //                                         AddRateDescriptionForm(
      //                                           pieces: item.pieces,
      //                                           grossWeight: item.grossWeight,
      //                                           grossWeightUnit:
      //                                               item.grossWeightUnit,
      //                                           rateClass: item.rateClass,
      //                                           itemNumber: item.itemNumber,
      //                                           chargeableWeight:
      //                                               item.chargeableWeight,
      //                                           rateCharge: item.rateCharge,
      //                                           total: item.total,
      //                                           autoCalculations:
      //                                               item.autoCalculations,
      //                                           natureAndQuantity:
      //                                               item.natureAndQuantity,
      //                                           dimensionsList:
      //                                               item.dimensionsList,
      //                                           text: item.text,
      //                                         )));
      //                         if (rateDescriptionItem != null) {
      //                           model.deleteRateDescriptionItem(item);
      //                           model.addRateDescriptionItem(
      //                               rateDescriptionItem);
      //                         }
      //                       },
      //                       child: Text(
      //                         S.of(context).Edit,
      //                         // "Edit",
      //                         style: TextStyle(
      //                           color: Colors.black,
      //                         ),
      //                       ),
      //                     )
      //                   ],
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //         isExpanded: item.isExpanded);
      //   }).toList(),
      // );
    } else {
      return Text(S.of(context).NoItemsFound
          //"No Items Found"
          );
    }
  }
}
class CurveWave extends Curve {
  const CurveWave();
  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return 0.01;
    }
    return math.sin(t * math.pi);
  }
}

class CirclePainter extends CustomPainter {
  CirclePainter(
      this._animation, {
        @required this.color,
      }) : super(repaint: _animation);
  final Color color;
  final Animation<double> _animation;
  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final Color _color = color.withOpacity(opacity);
    final double size = rect.width / 2;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 4);
    final Paint paint = Paint()..color = _color;
    canvas.drawCircle(rect.center, radius, paint);
  }
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation.value);
    }
  }
  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}