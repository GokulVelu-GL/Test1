import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/screenroute.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'dart:math' as math show sin, pi,sqrt;

import 'static/eawb_nav_pages.dart';
import 'static/eawb_fab_menu.dart';

class MainEAWB extends StatefulWidget {
  final String awbNumber;
  MainEAWB({Key key, this.awbNumber}) : super(key: key);

  @override
  _MainEAWBState createState() => _MainEAWBState();
}

class _MainEAWBState extends State<MainEAWB> with TickerProviderStateMixin{
  EAWBModel model;
  bool alertvalue=true;
  Color color;
  AnimationController _controller;
  AnimationController _resizableController;
  
  

  void initState() {
    super.initState();
    _resizableController = new AnimationController(
      vsync: this,
      duration: new Duration(
        milliseconds: 1000,
      ),
    );
    _resizableController.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _resizableController.reverse();
          break;
        case AnimationStatus.dismissed:
          _resizableController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });

    _resizableController.forward();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(onPressed: (){
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                title: AnimatedBuilder(
                    animation: _resizableController,
                    builder: (context, child) {
                      return Container(
                        padding: EdgeInsets.only(left: 15.0,
                            top: 10.0,bottom: 10.0,
                            right: 15.0),
                        child: Center(child: Text("Alert")),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          border: Border.all(
                              color: Theme.of(context).backgroundColor, width: _resizableController.value * 10),
                        ),
                      );
                    }),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: CustomPaint(
                            painter: CirclePainter(
                                _controller,
                                color: Theme.of(context).accentColor
                            ),
                            child: SizedBox(
                                height: 80,
                                width:80,
                                child: Icon(Icons.dangerous_outlined, size: 20,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("AWB Gross weight ",
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                Text("--------------> 350K",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("AWB Chargeable Weight  ",
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,

                                  ),
                                ),
                                Text("--------> 350K",
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
                                Text("-> 500K",
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
                // actions: <Widget>[
                //   TextButton(
                //     onPressed: () {
                //       Navigator.of(ctx).pop();
                //     },
                //     child: Center(
                //       child: Container(
                //         padding: const EdgeInsets.all(14),
                //         child:  Text("Close",
                //           style: TextStyle(
                //             color: Theme.of(context).accentColor,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ],
              ),
            );
          },  icon: Icon(Icons.developer_mode)),
          IconButton(
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
                                  leading: Icon(Icons.done,
                                    color: Colors.green[800],
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Fill all required fields",
                                        style: TextStyle(
                                            fontSize: 12.0
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              color: Colors.green[800]
                                          ),
                                          child: Text("Completed",
                                            style: TextStyle(
                                                color: Theme.of(context).backgroundColor
                                            ),
                                          )),

                                    ],
                                  ),
                                  // subtitle: Text("Fill all required fields"),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: Icon(Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("All fields Empty",
                                        style: TextStyle(
                                            fontSize: 12.0
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              color: Colors.red
                                          ),
                                          child: Text("No Data",
                                            style: TextStyle(
                                                color: Theme.of(context).backgroundColor
                                            ),
                                          )),

                                    ],
                                  ),
                                  // subtitle: Text("Fill all required fields"),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: Icon(Icons.done,
                                    color: Colors.green,
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Optional fields",
                                        style: TextStyle(
                                            fontSize: 12.0
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              color: Colors.green
                                          ),
                                          child: Text("Completed !",
                                          style: TextStyle(
                                            color: Theme.of(context).backgroundColor
                                          ),
                                          )),

                                    ],
                                  ),
                                  // subtitle: Text("Fill all required fields"),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: Icon(Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Some required fields are not filled",
                                      style: TextStyle(
                                        fontSize: 12.0
                                      ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              color: Colors.blue
                                          ),
                                          child: Text("Incomplete",
                                            style: TextStyle(
                                                color: Theme.of(context).backgroundColor
                                            ),
                                          )),

                                    ],
                                  ),
                                  // subtitle: Text("Fill all required fields"),
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
              color: Theme.of(context).backgroundColor,
            ),

          ),
          // IconButton(onPressed: () {}, icon: Icon(Icons.menu_open))
          PopupMenuButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      child: Consumer<EAWBModel>(
                          builder: (BuildContext context, model, Widget child) {
                        return TextButton(
                            onPressed: () {
                              model.loadSampleData();
                            },
                            child: Row(children: [
                              Icon(
                                Icons.system_security_update,
                                color: Theme.of(context).accentColor,
                              ),
                              Text(
                                S.of(context).eAWBSampleData1,
                               // "eAWB Sample Data 1",
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              )
                            ]));
                      }),
                      // child: TextButton(
                      //     onPressed: () {
                      //       EAWBModel model;
                      //       model.loadSampleData();
                      //     },
                      //     child: Row(children: [
                      //       Icon(Icons.system_security_update),
                      //       Text("Sample Data 1")
                      //     ]))
                    ),
                PopupMenuItem(
                  child: Consumer<EAWBModel>(
                      builder: (BuildContext context, model, Widget child) {
                        return TextButton(
                            onPressed: () {
                              model.loadSampleData1();
                            },
                            child: Row(children: [
                              Icon(
                                Icons.system_security_update,
                                color: Theme.of(context).accentColor,
                              ),
                              Text(
                               // S.of(context).eAWBSampleData1,
                                 "eAWB Sample Data 2",
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              )
                            ]));
                      }),
                  // child: TextButton(
                  //     onPressed: () {
                  //       EAWBModel model;
                  //       model.loadSampleData();
                  //     },
                  //     child: Row(children: [
                  //       Icon(Icons.system_security_update),
                  //       Text("Sample Data 1")
                  //     ]))
                )
                  ])
        ],
        backgroundColor: Theme.of(context).primaryColor,
        // centerTitle: true,
        // title: Text(
        //   // 'eAWB  '
        //   S.of(context).eAWB +
        //       ' ${widget.awbNumber.substring(0, 3)}${widget.awbNumber.substring(3)}',
        // ),
        title: RichText(
          text: TextSpan(
            text: S.of(context).eAWB,

            children:  <TextSpan>[
              TextSpan(text: ' ${widget.awbNumber.substring(0, 3)}${widget.awbNumber.substring(3)}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      body: EAWBPage(),
    );
  }
}

class EAWBPage extends StatefulWidget {
  EAWBPage({Key key}) : super(key: key);

  @override
  _EAWBPageState createState() => _EAWBPageState();
}

class _EAWBPageState extends State<EAWBPage> {
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = List();
  bool tutorial = true;

  GlobalKey _listTargetKey = GlobalKey();
  GlobalKey _statusTargetKey = GlobalKey();
  GlobalKey _fabTargetKey = GlobalKey();
  AnimationController _controller;
  // String Shipper = S.of(context).Shipper;
  //  List<String> items = [
  //    "Shipper",
  //    "Consignee",
  //    "Issuing carrier's agent",
  //    "Routing and flight bookings",
  //    "Awb Consignment details",
  //    "Also Notify",
  //    "Issuer",
  //    "Accounting information",
  //    "Optional Shipping Information",
  //    "Charges declaration",
  //    "Handling information",
  //    "Rate description",
  //    "Charges summary",
  //    "CC charges in destination currency",
  //    "Other Charges",
  //    "Shipper's certification",
  //    "Carrier's execution"
  //  ];

  void initTargets() {
    targets.add(
      TargetFocus(
        identify: "Field Type",
        keyTarget: _listTargetKey,
        contents: [
          ContentTarget(
            align: AlignContent.bottom,
            child: InkWell(
              onTap: () {
                tutorialCoachMark.next();
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                 S.of(context).ClickontheCardtoeditthefield,
                  // "Click on the Card to edit the field",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
            ),
          )
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Status",
        keyTarget: _statusTargetKey,
        contents: [
          ContentTarget(
            align: AlignContent.bottom,
            child: InkWell(
              onTap: () {
                tutorialCoachMark.next();
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                 S.of(context).Statusofthedatayouhavefilled,
                 // "Status of the data you have filled",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
            ),
          )
        ],
        shape: ShapeLightFocus.Circle,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Fab",
        keyTarget: _fabTargetKey,
        contents: [
          ContentTarget(
            align: AlignContent.top,
            child: InkWell(
              onTap: () {
                tutorialCoachMark.finish();
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text("Click This button to more options like (Save, Print, Clear)",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),
            ),
          )
        ],
        shape: ShapeLightFocus.Circle,
      ),
    );
  }

  void _afterLayout(_) {
    Future.delayed(const Duration(seconds: 1), () {
      showTutorial();
    });
  }

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.black,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        setState(() {
          tutorial = false;
        });
      },
    )..show();
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      if (value.getBool('tutorial') ?? true) {
        initTargets();
        WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
        setState(() {
          tutorial = true;
        });
      } else {
        setState(() {
          tutorial = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String AwbConsignmentdetails = S.of(context).AwbConsignmentdetails;
    String Shipper = S.of(context).Shipper;
    String Consignee = S.of(context).Consignee;
    String Issuingcarriersagent = S.of(context).Issuingcarriersagent;
    String Routingandflightbookings = S.of(context).Routingandflightbookings;
    String AlsoNotify = S.of(context).AlsoNotify;
    String Issuer = S.of(context).Issuer;
    String Accountinginformation = S.of(context).Accountinginformation;
    String OptionalShippingInformation =
        S.of(context).OptionalShippingInformation;
    String Chargesdeclaration = S.of(context).Chargesdeclaration;
    String Handlinginformation = S.of(context).Handlinginformation;
    String Ratedescription = S.of(context).Ratedescription;
    String Chargessummary = S.of(context).Chargessummary;
    String CCchargesindestinationcurrency =
        S.of(context).CCchargesindestinationcurrency;
    String OtherCharges = S.of(context).OtherCharges;
    String Shipperscertification = S.of(context).Shipperscertification;
    String Carriersexecution = S.of(context).Carriersexecution;
    // ignore: non_constant_identifier_names
    String SpecialHandlingDetails =
        S.of(context).SpecialHandlingDetails;
        //"Special Handling Details";

    List<String> items = [
      AwbConsignmentdetails,
      Shipper,
      Consignee,
      Issuingcarriersagent,
      Routingandflightbookings,
      AlsoNotify,
      Issuer,
      Accountinginformation,
      OptionalShippingInformation,
      Chargesdeclaration,
      Ratedescription,
      OtherCharges,
      // Handlinginformation,
      SpecialHandlingDetails,
      Chargessummary,
      CCchargesindestinationcurrency,
      Shipperscertification,
      Carriersexecution,

    ];
    //  String Shipper = S.of(context).Shipper;

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        floatingActionButton: EawbFabMenu(
          context,
          true,
        ),
        body: Consumer<EAWBModel>(builder: (context, model, child) {
          Future<bool> _onBackPressed() {
            return showDialog(
                  context: context,
                  builder: (context) => new AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    title: Center(
                      child: Text(
                        S.of(context).WouldyouliketoSave,

                        // "Would you like to Save?"

                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 20),
                      ),
                    ),
                    content: new Text(
                      S.of(context).YouhavemadeseveralchangesSavethefieldforfutureuse,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                      // 'You have made several changes!\nSave the field for future use.',
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(
                          S.of(context).Exit,
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20),
                          // "Exit"
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          model.inserteAWB();
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          S.of(context).SaveExit,
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20),
                          //  "Save & Exit"
                        ),
                      ),
                    ],
                  ),
                ) ??
                false;
          }

          return WillPopScope(
            onWillPop: () async {
              return _onBackPressed();
            },
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 25.0),
                  child: Container(
                    key: _fabTargetKey,
                    color: Colors.transparent,
                    width: 80,
                    height: 80,
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  child: tutorial
                      ? ListView(
                          children: [
                            Card(
                              elevation: 2.5,
                              key: _listTargetKey,
                              margin: EdgeInsets.all(5),
                              child: Container(
                                height: 120,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Stack(
                                    fit: StackFit.loose,
                                    children: <Widget>[
                                      Text("XXXXXXXXXXXX",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      Container(
                                        key: _statusTargetKey,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.red[800]),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "XXXX",
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Tooltip(
                                        message: "XXXX",
                                        preferBelow: false,
                                        child: Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => Navigator.of(context)
                                  .push(HomeScreenRoute(EAWBNavPages(index))),
                              child: Card(
                                elevation: 2.5,
                                margin: EdgeInsets.all(5),
                                child: Container(
                                  height: 88,
                                  child: Container(
                                    padding: const EdgeInsets.all(15.0),
                                    child: ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      children: <Widget>[
                                        //setIcon(index, model),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("${items[index]}",
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15)),

                                            setIcon(index, model),
                                          ],
                                        ),
                                        //SizedBox(width: 100,),
                                        Row(
                                          children: [
                                            setSubTitle(index, model),
                                          ],
                                        ),


                                        // setSubTitle(index, model),
                                        // setIcon(index, model)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
          );
        }));
  }

  setSubTitle(int index, EAWBModel model) {
    var subTitleMap = {
      0: Container(
        padding: EdgeInsets.all(3.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.red[800]),
        child: Center(
          child: Text(
            S.of(context).NoData,
            //"No Data",
            style: TextStyle(
              fontSize: 17,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
      ),
      1: Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.green[800]),
        child: Center(
          child: Text(
            S.of(context).Completed,
            // "Completed",
            style: TextStyle(
              fontSize: 17,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
      ),
      -1: Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.blue[800]),
        child: Center(
          child: Text(
            "Incomplete",
            //S.of(context).Incompleted,
            // "Incomplete",
            style: TextStyle(
              fontSize: 17,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
      ),
      2 :Container(
        height: 30,
        padding: EdgeInsets.only(
        right: 3.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
             //color: Colors.red
        ),
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.green
          ),
          child: Text(
            "Completed !",
            //  S.of(context).Incompleted,
            // "Incomplete",
            style: TextStyle(
              fontSize: 17,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
      ),

    };

    switch (index) {
      case 0:
        return subTitleMap[model.awbConsigmentDetailsStatus];
        break;
      case 1:
        return subTitleMap[model.shipperStatus];
        break;
      case 2:
        return subTitleMap[model.consigneeStatus];
        break;
      case 3:
        return subTitleMap[model.issuingCarrierAgentStatus];
        break;
      case 4:
        return subTitleMap[model.routeAndFlightStatus];
        break;
      case 5:
        return subTitleMap[model.notifyStatus];
        break;
      case 6:
        return subTitleMap[model.issuerStatus];
        break;
      case 7:
        return subTitleMap[model.accountingInformationStatus];
        break;
      case 8:
        return subTitleMap[model.optionalShippingInformationStatus];
        break;
      case 9:
        return subTitleMap[model.chargesDeclarationStatus];
        break;
      case 10:
        return subTitleMap[model.rateDescriptionStatus];
        break;
      case 11:
        return subTitleMap[model.otherChargesStatus];
        break;

      // case 11:
      //   return subTitleMap[model.handlingInformationStatus];
      //   break;
      case 12:
        return subTitleMap[model.SpecialHandlingDetailsStatus];
        break;

      case 13:
        return subTitleMap[model.chargeSummaryStatus];
        break;
      case 14:
        return subTitleMap[model.ccChargesInDestinationCurrencyStatus];
        break;
      case 15:
        return subTitleMap[model.shipperCertificationStatus];
        break;
      case 16:
        return subTitleMap[model.carriersExecutionStatus];
        break;
    }
  }

  setIcon(int index, EAWBModel model) {
    var iconMap = {
      0: Tooltip(
        message: S.of(context).NoData,
        // "No Data",
        preferBelow: false,
        child: Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      ),
      1: Tooltip(
        message: S.of(context).Completed,
        //"Completed",
        preferBelow: false,
        child: Icon(
          Icons.done,
          color: Colors.green,
        ),
      ),
      -1: Tooltip(
        message: S.of(context).Incompleted,
        //"Incompleted",
        preferBelow: false,
        child: Icon(
          Icons.edit,
          color: Colors.blue,
        ),
      ),
      2: Tooltip(
    message: S.of(context).Completed,
    //"Completed",
    preferBelow: false,
    child: Icon(
    Icons.done,
    color: Colors.green,
    ),
    ),
    };
    switch (index) {
      case 0:
        return iconMap[model.awbConsigmentDetailsStatus];
        break;
      case 1:
        return iconMap[model.shipperStatus];
        break;
      case 2:
        return iconMap[model.consigneeStatus];
        break;
      case 3:
        return iconMap[model.issuingCarrierAgentStatus];
        break;
      case 4:
        return iconMap[model.routeAndFlightStatus];
        break;
      case 5:
        return iconMap[model.notifyStatus];
        break;
      case 6:
        return iconMap[model.issuerStatus];
        break;
      case 7:
        return iconMap[model.accountingInformationStatus];
        break;
      case 8:
        return iconMap[model.optionalShippingInformationStatus];
        break;
      case 9:
        return iconMap[model.chargesDeclarationStatus];
        break;

      // case 10:
      //   return iconMap[model.handlingInformationStatus];
      //   break;
      case 10:
        return iconMap[model.rateDescriptionStatus];
        break;
      case 11:
        return iconMap[model.otherChargesStatus];
        break;
      case 12:
        return iconMap[model.SpecialHandlingDetailsStatus];
        break;
      case 13:
        return iconMap[model.chargeSummaryStatus];
        break;
      case 14:
        return iconMap[model.ccChargesInDestinationCurrencyStatus];
        break;
      case 15:
        return iconMap[model.shipperCertificationStatus];
        break;
      case 16:
        return iconMap[model.carriersExecutionStatus];
        break;
    }
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

