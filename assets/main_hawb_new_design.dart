import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rooster/string.dart';
import 'package:rooster/ui/eawb/main_eawb.dart';
import 'package:rooster/ui/hawb/static/add_master_eawb.dart';
import 'package:rooster/ui/hawb/static/edit_hawb.dart';
import 'package:rooster/ui/hawb/house_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tutorial_coach_mark/animated_focus_light.dart';
// import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:http/http.dart' as http;
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/screenroute.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void refreshToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var response = await http.get(Uri.parse(StringData.refreshTokenAPI),
      headers: {'x-access-tokens': prefs.getString('token')});
  var result = json.decode(response.body);
  if (result['result'] == 'verified') prefs.setString('token', result['token']);
  print(result);
}

Future<dynamic> getAWBlist() async {
  var result;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var response = await http.get(Uri.parse(StringData.awblistAPI),
      headers: {'x-access-tokens': prefs.getString('token')});
  result = json.decode(response.body);
  if (result['message'] == 'token expired') {
    refreshToken();
    getAWBlist();
  } else {
    //getAWBlist();
    print(prefs.getString('token'));
  }
  print("AWB List Details " + '${result["awb"]}');
  return result["awb"];
}

class MyEawb extends StatefulWidget {
  @override
  _MyEawbState createState() => _MyEawbState();
}

class _MyEawbState extends State<MyEawb> with TickerProviderStateMixin {
  void _loaderDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  // TutorialCoachMark tutorialCoachMark;
  // List<TargetFocus> targets = List();
  bool tutorial = false;

  GlobalKey _listTargetKey = GlobalKey();
  GlobalKey _masterAWBTargetKey = GlobalKey();
  GlobalKey _originToDestinationTargetKey = GlobalKey();
  GlobalKey _piecesAndWeightTargetKey = GlobalKey();
  GlobalKey _fabTarget = GlobalKey();

  // void initTargets() {
  //   targets.add(
  //     TargetFocus(
  //       identify: "List",
  //       keyTarget: _listTargetKey,
  //       contents: [
  //         ContentTarget(
  //           align: AlignContent.bottom,
  //           child: InkWell(
  //             onTap: () {
  //               tutorialCoachMark.next();
  //             },
  //             child: Padding(
  //               padding: const EdgeInsets.only(bottom: 20.0),
  //               child: Text(
  //                 "Swipe Left to Detele and Right to Add Houses",
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 20.0),
  //               ),
  //             ),
  //           ),
  //         )
  //       ],
  //       shape: ShapeLightFocus.RRect,
  //     ),
  //   );
  //   targets.add(
  //     TargetFocus(
  //       identify: "Master AWB",
  //       keyTarget: _masterAWBTargetKey,
  //       contents: [
  //         ContentTarget(
  //           align: AlignContent.bottom,
  //           child: InkWell(
  //             onTap: () {
  //               tutorialCoachMark.next();
  //             },
  //             child: Padding(
  //               padding: const EdgeInsets.only(bottom: 20.0),
  //               child: Text(
  //                 "Master Air Waybill of Houses",
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 20.0),
  //               ),
  //             ),
  //           ),
  //         )
  //       ],
  //       shape: ShapeLightFocus.RRect,
  //     ),
  //   );
  //   targets.add(
  //     TargetFocus(
  //       identify: "Origin to Destination",
  //       keyTarget: _originToDestinationTargetKey,
  //       contents: [
  //         ContentTarget(
  //           align: AlignContent.bottom,
  //           child: InkWell(
  //             onTap: () {
  //               tutorialCoachMark.next();
  //             },
  //             child: Padding(
  //               padding: const EdgeInsets.only(bottom: 20.0),
  //               child: Text(
  //                 'Origin to Destination\nShipment - Total',
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 20.0),
  //               ),
  //             ),
  //           ),
  //         )
  //       ],
  //       shape: ShapeLightFocus.RRect,
  //     ),
  //   );
  //   targets.add(
  //     TargetFocus(
  //       identify: "Pieces and Weight",
  //       keyTarget: _piecesAndWeightTargetKey,
  //       contents: [
  //         ContentTarget(
  //           align: AlignContent.bottom,
  //           child: InkWell(
  //             onTap: () {
  //               tutorialCoachMark.next();
  //             },
  //             child: Padding(
  //               padding: const EdgeInsets.only(bottom: 20.0),
  //               child: Text(
  //                 "Number of pieces and total weight",
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 20.0),
  //               ),
  //             ),
  //           ),
  //         )
  //       ],
  //       shape: ShapeLightFocus.RRect,
  //     ),
  //   );
  //   targets.add(
  //     TargetFocus(
  //       identify: "Add Master AWB here.",
  //       keyTarget: _fabTarget,
  //       contents: [
  //         ContentTarget(
  //           align: AlignContent.top,
  //           child: InkWell(
  //             onTap: () {
  //               tutorialCoachMark.finish();
  //             },
  //             child: Padding(
  //               padding: const EdgeInsets.only(bottom: 20.0),
  //               child: Text(
  //                 "Add Master AWB here.",
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 20.0),
  //               ),
  //             ),
  //           ),
  //         )
  //       ],
  //       shape: ShapeLightFocus.Circle,
  //     ),
  //   );
  // }

  void _afterLayout(_) {
    Future.delayed(const Duration(seconds: 1), () {
      //showTutorial();
    });
  }

  // void showTutorial() {
  //   BuildContext context;
  //   tutorialCoachMark = TutorialCoachMark(
  //     context,
  //     targets: targets,
  //     colorShadow: Colors.black,
  //     alignSkip: Alignment.topRight,
  //     textSkip: "SKIP",
  //     paddingFocus: 10,
  //     opacityShadow: 0.8,
  //     onFinish: () {
  //       setState(() {
  //         tutorial = false;
  //       });
  //     },
  //   )..show();
  // }

// Animation Part
  AnimationController _anicontroller;

  Animation _profilePictureAnimation;
  Animation _contentAnimation;
  Animation _listAnimation;
  Animation _fabAnimation;

  @override
  void initState() {
    // SharedPreferences.getInstance().then((value) {
    //   if (value.getBool('tutorial') ?? true) {
    //     initTargets();
    //     WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    //     setState(() {
    //       tutorial = true;
    //     });
    //     //getAWBlist();
    //   } else {
    _anicontroller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    _profilePictureAnimation = Tween(begin: 0.0, end: 50.0).animate(
        CurvedAnimation(
            parent: _anicontroller,
            curve: Interval(0.0, 0.20, curve: Curves.easeOut)));
    _contentAnimation = Tween(begin: 0.0, end: 34.0).animate(CurvedAnimation(
        parent: _anicontroller,
        curve: Interval(0.20, 0.40, curve: Curves.easeOut)));
    _listAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _anicontroller,
        curve: Interval(0.40, 0.75, curve: Curves.easeOut)));
    _fabAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _anicontroller,
        curve: Interval(0.75, 1.0, curve: Curves.easeOut)));
    _anicontroller.forward();
    _anicontroller.addListener(() {
      setState(() {});
    });
    setState(() {
      tutorial = false;
    });
    // getAWBlist();
    // }
    //});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Transform.scale(
          scale: _fabAnimation.value,
          child: Builder(
            builder: (context) => FloatingActionButton(
              key: _fabTarget,
              backgroundColor: Theme.of(context).accentColor,
              onPressed: () async {
                Map<String, String> newMasterAWB = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddMasterAWB(),
                      fullscreenDialog: true,
                    ));
                if (newMasterAWB != null) {
                  setState(() {
                    //masterAWB.add(newMasterAWB);
                  });
                }
              },
              child: Icon(Icons.add),
            ),
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Container(
          //height: MediaQuery.of(context).size.height - 185.0,
          child: Center(
            child: FutureBuilder<dynamic>(
              future: getAWBlist(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  EasyLoading.show();
                  print("Snapshot Data ${snapshot.data}");
                  //getawblist=snapshot.data;
                  return GetAWBList(getawblist: snapshot.data);
                } else if (snapshot.hasError) {
                  return Text("Data Not Found");
                }

                // By default, show a loading spinner
                return CircularProgressIndicator();
                //return EasyLoading.show();
              },
            ),
          ),
        ));
  }
}

class GetAWBList extends StatelessWidget {
  var getawblist;
  GetAWBList({Key key, this.getawblist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Get AWB list ${getawblist}");

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Image(
          image: AssetImage('assets/images/flight_bg.png'),
          color: const Color.fromRGBO(255, 255, 255, 0.5),
          colorBlendMode: BlendMode.modulate,
          fit: BoxFit.cover,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          "AWB List",
          //textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 1,
      ),
      backgroundColor: Colors.grey.shade200,
      //backgroundColor: Theme.of(context).primaryColor,
      body: _buildAWBList1(context),
    );
  }

  Widget _buildAWBList1(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      children: new List<Widget>.generate(getawblist.length, (index) {
        return Dismissible(
            key: ValueKey(getawblist[index]),
            confirmDismiss: (DismissDirection direction) async {
              if (direction == DismissDirection.startToEnd) {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Delete Confirmation"),
                      content: const Text(
                          "Are you sure you want to delete this item?"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                              deleteAWB('${getawblist[index]["id"]}');
                            },
                            child:  Text("Delete")),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child:  Text("Cancel"),
                        ),
                      ],
                    );
                  },
                );
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditHawb(
                        '${getawblist[index]["prefix"]}',
                        '${getawblist[index]["wayBillNumber"]}',
                        '${getawblist[index]["id"]}',
                        '${getawblist[index]["destination"]}',
                        '${getawblist[index]["origin"]}',
                        '${getawblist[index]["shipmentcode"]}',
                        '${getawblist[index]["pieces"]}',
                        '${getawblist[index]["weight"]}',
                        '${getawblist[index]["weightcode"]}',
                      ),
                    ));
                return false;
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
                    Text('Delete', style: TextStyle(color: Colors.white)),
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
                      'Update Details',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            child: Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: Container(
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    color: Colors.white,
                    boxShadow: [
                      //background color of box

                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 16.0, // soften the shadow
                        spreadRadius: 3.0, //extend the shadow
                        offset: Offset(
                          10.0, // Move to right 10  horizontally
                          10.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.white.withOpacity(0.2), BlendMode.dstATop),
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "https://cdn.pixabay.com/photo/2013/07/12/12/54/world-map-146505_640.png")),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        // height: MediaQuery.of(context).size.height / 12,
                        padding: EdgeInsets.all(7),
                        child: Column(
                          children: <Widget>[
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                      child: Text(
                                    '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: PopupMenuButton(
                                        // child: Icon(Icons.more)),
                                        icon: Icon(Icons.more_vert),
                                        itemBuilder: (context) => [
                                              PopupMenuItem(
                                                child: TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditEawb(
                                                                    '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}',
                                                                    '${getawblist[index]["id"]}'),
                                                          ));
                                                    },
                                                    child:
                                                        Text("House Details")),
                                                value: 1,
                                              ),
                                              PopupMenuItem(
                                                child: Consumer<EAWBModel>(
                                                  builder:
                                                      (BuildContext context,
                                                          model, Widget child) {
                                                    return TextButton(
                                                        onPressed: () {
                                                          // model.awbConsigmentDetailsAWBNumber =
                                                          //     '${getawblist[index]["prefix"]}${getawblist[index]["wayBillNumber"]}';
                                                          model.awbConsigmentOriginPrefix =
                                                              '${getawblist[index]["origin"]}';
                                                          model.awbConsigmentDestination =
                                                              '${getawblist[index]["destination"]}';
                                                          model.awbConsigmentPices =
                                                              '${getawblist[index]["pieces"]}';
                                                          model.awbConsigmentPices =
                                                              '${getawblist[index]["weight"]}';
                                                          model.awbConsigmentPices =
                                                              '${getawblist[index]["weightcode"]}';
                                                          // Navigator.push(
                                                          //     context,
                                                          //     HomeScreenRoute(
                                                          //         MainEAWB(
                                                          //       awbNumber:
                                                          //           '${getawblist[index]["prefix"]}${getawblist[index]["wayBillNumber"]}',
                                                          //     )));

                                                          model
                                                              .getEAWB(
                                                                  '${getawblist[index]["id"]}')
                                                              .then(
                                                                  (value) async {
                                                            if (value ==
                                                                'New Air Waybill Number') {
                                                              SharedPreferences
                                                                  prefs =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              prefs.setString(
                                                                  "awbListid",
                                                                  '${getawblist[index]["id"]}');
                                                              model.awbConsigmentDetailsAWBNumber =
                                                                  '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}';
                                                              Navigator.pop(
                                                                  context);
                                                              model.clearEAWB();
                                                              _displayCreateAWBDialog(
                                                                  context,
                                                                  '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}');
                                                              //
                                                            } else {
                                                              print(
                                                                  "DATA FROM getEAWB $value");

                                                              model.awbConsigmentDetailsAWBNumber =
                                                                  '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}';
                                                              Navigator.of(
                                                                      context)
                                                                  .push(HomeScreenRoute(
                                                                      MainEAWB(
                                                                awbNumber:
                                                                    '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}',
                                                              )));
                                                            }
                                                          });
                                                        },
                                                        child: Text(
                                                            "AWB Details"));
                                                  },
                                                ),
                                                value: 2,
                                              )
                                            ]),
                                  ),
                                ]),
                            // Row(
                            //   children: <Widget>[
                            //     SizedBox(
                            //       width: 10,
                            //     ),
                            //     Align(
                            //       alignment: Alignment.centerLeft,
                            //       child: Text(
                            //         '${getawblist[index]["origin"]}',
                            //         style: TextStyle(
                            //             fontSize: 20,
                            //             fontWeight: FontWeight.bold,
                            //             color: Colors.indigo),
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 5,
                            //     ),
                            //     Container(
                            //       padding: EdgeInsets.all(5),
                            //       //child: Icon(Icons.flight_takeoff,color:Colors.amber),
                            //       decoration: BoxDecoration(
                            //           color: Colors.indigo.shade50,
                            //           borderRadius: BorderRadius.circular(20)),

                            //       child: SizedBox(
                            //         height: 8,
                            //         width: 8,
                            //         child: DecoratedBox(
                            //           decoration: BoxDecoration(
                            //               color: Colors.indigo.shade400,
                            //               borderRadius:
                            //                   BorderRadius.circular(5)),
                            //         ),
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 45,
                            //     ),
                            //     Align(
                            //       alignment: Alignment.center,
                            //       child: Center(
                            //           child: Transform.rotate(
                            //         angle: 1.5,
                            //         child: Icon(
                            //           Icons.local_airport,
                            //           color: Colors.indigo.shade300,
                            //           size: 30,
                            //         ),
                            //       )),
                            //     ),
                            //     SizedBox(
                            //       width: 45,
                            //     ),
                            //     Container(
                            //       padding: EdgeInsets.all(6),
                            //       //child: Icon(Icons.flight_land,color:Colors.amber),
                            //       decoration: BoxDecoration(
                            //           color: Colors.pink.shade50,
                            //           borderRadius: BorderRadius.circular(20)),
                            //       child: SizedBox(
                            //         height: 8,
                            //         width: 8,
                            //         child: DecoratedBox(
                            //           decoration: BoxDecoration(
                            //               color: Colors.lightBlue,
                            //               borderRadius:
                            //                   BorderRadius.circular(5)),
                            //         ),
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 5,
                            //     ),
                            //     Align(
                            //       alignment: Alignment.centerRight,
                            //       child: Text(
                            //         '${getawblist[index]["destination"]}',
                            //         style: TextStyle(
                            //             fontSize: 20,
                            //             fontWeight: FontWeight.bold,
                            //             color: Colors.indigo),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Flex(
                                    children: List.generate(
                                        (constraints.constrainWidth() / 10)
                                            .floor(),
                                        (index) => SizedBox(
                                              height: 1,
                                              width: 5,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                    color:
                                                        Colors.grey.shade400),
                                              ),
                                            )),
                                    direction: Axis.horizontal,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            //height: 10,
                            width: 10,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                  color: Colors.grey.shade200),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                // Container(
                                //     child: Text(
                                //   '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}',
                                //   style: TextStyle(
                                //       fontSize: 22,
                                //       color: Colors.black,
                                //       fontWeight: FontWeight.bold),
                                // )),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    '${getawblist[index]["origin"]}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigo),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Center(
                                      child: Transform.rotate(
                                    angle: 1.5,
                                    child: Icon(
                                      Icons.local_airport,
                                      color: Colors.indigo.shade300,
                                      size: 20,
                                    ),
                                  )),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '${getawblist[index]["destination"]}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigo),
                                  ),
                                ),
                                SizedBox(
                                  width: 35,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 9),
                                  child: Container(
                                      child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                'Pieces',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '${getawblist[index]["pieces"]}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Column(children: [
                                                Text(
                                                  'Weight',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '${getawblist[index]["weight"]} ${getawblist[index]["weightcode"]}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ]))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )));
      }),
    );
  }

  // Widget _buildAWBList(BuildContext context) {
  //   return ListView(
  //     children: new List<Widget>.generate(getawblist.length, (index) {
  //       return Dismissible(
  //           key: ValueKey(getawblist[index]),
  //           confirmDismiss: (DismissDirection direction) async {
  //             if (direction == DismissDirection.startToEnd) {
  //               return await showDialog(
  //                 context: context,
  //                 builder: (BuildContext context) {
  //                   return AlertDialog(
  //                     title: const Text("Delete Confirmation"),
  //                     content: const Text(
  //                         "Are you sure you want to delete this item?"),
  //                     actions: <Widget>[
  //                       FlatButton(
  //                           onPressed: () {
  //                             Navigator.of(context).pop(true);
  //                             deleteAWB('${getawblist[index]["id"]}');
  //                           },
  //                           child: const Text("Delete")),
  //                       FlatButton(
  //                         onPressed: () => Navigator.of(context).pop(false),
  //                         child: const Text("Cancel"),
  //                       ),
  //                     ],
  //                   );
  //                 },
  //               );
  //             } else {
  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => EditHawb(
  //                       '${getawblist[index]["prefix"]}',
  //                       '${getawblist[index]["wayBillNumber"]}',
  //                       '${getawblist[index]["id"]}',
  //                       '${getawblist[index]["destination"]}',
  //                       '${getawblist[index]["origin"]}',
  //                       '${getawblist[index]["shipmentcode"]}',
  //                       '${getawblist[index]["pieces"]}',
  //                       '${getawblist[index]["weight"]}',
  //                       '${getawblist[index]["weightcode"]}',
  //                     ),
  //                   ));
  //               return false;
  //             }
  //           },
  //           onDismissed: (direction) {
  //             if (direction == DismissDirection.startToEnd) {}
  //           },
  //           background: Container(
  //             color: Colors.red,
  //             child: Padding(
  //               padding: const EdgeInsets.all(15),
  //               child: Row(
  //                 children: [
  //                   Icon(Icons.delete, color: Colors.white),
  //                   SizedBox(
  //                     width: 10,
  //                   ),
  //                   Text('Delete', style: TextStyle(color: Colors.white)),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           secondaryBackground: Container(
  //             color: Colors.blue,
  //             child: Padding(
  //               padding: const EdgeInsets.all(15),
  //               child: Row(
  //                 textDirection: TextDirection.rtl,
  //                 children: [
  //                   Icon(Icons.edit, color: Colors.white),
  //                   SizedBox(
  //                     width: 10,
  //                   ),
  //                   Text(
  //                     'Update Details',
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           child: GestureDetector(
  //               onTap: () {},
  //               child: Container(
  //                 height: 100,
  //                 child: Card(
  //                   clipBehavior: Clip.antiAlias,

  //                   shape: RoundedRectangleBorder(
  //                     side: BorderSide(color: Colors.indigo[100], width: 2),
  //                     borderRadius: BorderRadius.only(
  //                         topRight: Radius.circular(30),
  //                         bottomLeft: Radius.circular(30)),
  //                   ),
  //                   shadowColor: Colors.grey,
  //                   //color: listColor ? Colors.white : Colors.purpleAccent[100],
  //                   color: Colors.white,
  //                   elevation: 05,
  //                   child: InkWell(
  //                     splashColor: Colors.blue.withAlpha(30),
  //                     child: ListTile(
  //                       // leading: CircleAvatar(
  //                       //   backgroundImage: NetworkImage(
  //                       //       "https://cdn-icons-png.flaticon.com/512/5439/5439210.png"),
  //                       // ),
  //                       title: Row(
  //                         children: [
  //                           Text(
  //                             '${getawblist[index]["prefix"]}-',
  //                             style: GoogleFonts.volkhov(
  //                                 textStyle: TextStyle(
  //                                     fontSize: 20,
  //                                     color: Colors.black54,
  //                                     fontWeight: FontWeight.bold)),
  //                             // style: TextStyle(
  //                             //     fontSize: 20,
  //                             //     color: Colors.black54,
  //                             //     fontWeight: FontWeight.bold),
  //                           ),
  //                           Text(
  //                             '${getawblist[index]["wayBillNumber"]}',
  //                             style: GoogleFonts.volkhov(
  //                                 textStyle: TextStyle(
  //                                     fontSize: 20,
  //                                     color: Colors.indigo[400],
  //                                     fontWeight: FontWeight.bold)),
  //                             // style: TextStyle(
  //                             //     fontSize: 20,
  //                             //     color: Colors.indigo[300],
  //                             //     fontWeight: FontWeight.bold),
  //                           ),
  //                         ],
  //                       ),
  //                       trailing: SingleChildScrollView(
  //                         scrollDirection: Axis.vertical,
  //                         child: Container(
  //                             padding: EdgeInsets.only(left: 6.0),
  //                             decoration: new BoxDecoration(
  //                                 border: new Border(
  //                                     left: new BorderSide(
  //                                         width: 1.0, color: Colors.brown))),
  //                             child: Column(
  //                               mainAxisSize: MainAxisSize.min,
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceAround,
  //                               // mainAxisAlignment: MainAxisAlignment.center,
  //                               children: [
  //                                 Text(
  //                                   '${getawblist[index]["origin"]}   🛫   ${getawblist[index]["destination"]}',
  //                                   style: GoogleFonts.notoSerif(
  //                                       textStyle: TextStyle(
  //                                           fontSize: 17,
  //                                           color: Colors.indigo[300],
  //                                           fontWeight: FontWeight.bold)),
  //                                   // style: TextStyle(
  //                                   //     fontSize: 17,
  //                                   //     color: Colors.blueGrey[900],
  //                                   //     fontWeight: FontWeight.bold),
  //                                 ),
  //                                 //TextButton(onPressed: null, child: Text("More Info "))
  //                                 SizedBox(
  //                                   height: 5,
  //                                 ),
  //                                 Text("More Info ℹ️"),
  //                                 // IconButton(
  //                                 //   onPressed: () {
  //                                 //     popUpMenu();
  //                                 //   },
  //                                 //   icon: Icon(Icons.info),
  //                                 // )
  //                                 PopupMenuButton(
  //                                     icon: Icon(Icons.more_vert),
  //                                     itemBuilder: (context) => [
  //                                           PopupMenuItem(
  //                                             child: TextButton(
  //                                                 onPressed: () {
  //                                                   listColor = !listColor;
  //                                                   Navigator.push(
  //                                                       context,
  //                                                       MaterialPageRoute(
  //                                                         builder: (context) =>
  //                                                             EditEawb(
  //                                                                 '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}',
  //                                                                 '${getawblist[index]["id"]}'),
  //                                                       ));
  //                                                 },
  //                                                 child: Text("House Details")),
  //                                             value: 1,
  //                                           ),
  //                                           PopupMenuItem(
  //                                             child: Consumer<EAWBModel>(
  //                                               builder: (BuildContext context,
  //                                                   model, Widget child) {
  //                                                 return TextButton(
  //                                                     onPressed: () {
  //                                                       // model.awbConsigmentDetailsAWBNumber =
  //                                                       //     '${getawblist[index]["prefix"]}${getawblist[index]["wayBillNumber"]}';
  //                                                       model.awbConsigmentOriginPrefix =
  //                                                           '${getawblist[index]["origin"]}';
  //                                                       model.awbConsigmentDestination =
  //                                                           '${getawblist[index]["destination"]}';
  //                                                       model.awbConsigmentPices =
  //                                                           '${getawblist[index]["pieces"]}';
  //                                                       model.awbConsigmentPices =
  //                                                           '${getawblist[index]["weight"]}';
  //                                                       model.awbConsigmentPices =
  //                                                           '${getawblist[index]["weightcode"]}';
  //                                                       // Navigator.push(
  //                                                       //     context,
  //                                                       //     HomeScreenRoute(
  //                                                       //         MainEAWB(
  //                                                       //       awbNumber:
  //                                                       //           '${getawblist[index]["prefix"]}${getawblist[index]["wayBillNumber"]}',
  //                                                       //     )));

  //                                                       model
  //                                                           .getEAWB(
  //                                                               '${getawblist[index]["id"]}')
  //                                                           .then(
  //                                                               (value) async {
  //                                                         if (value ==
  //                                                             'New Air Waybill Number') {
  //                                                           SharedPreferences
  //                                                               prefs =
  //                                                               await SharedPreferences
  //                                                                   .getInstance();
  //                                                           prefs.setString(
  //                                                               "awbListid",
  //                                                               '${getawblist[index]["id"]}');
  //                                                           model.awbConsigmentDetailsAWBNumber =
  //                                                               '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}';
  //                                                           Navigator.pop(
  //                                                               context);
  //                                                           model.clearEAWB();
  //                                                           _displayCreateAWBDialog(
  //                                                               context,
  //                                                               '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}');
  //                                                           //
  //                                                         } else {
  //                                                           print(
  //                                                               "DATA FROM getEAWB $value");

  //                                                           model.awbConsigmentDetailsAWBNumber =
  //                                                               '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}';
  //                                                           Navigator.of(
  //                                                                   context)
  //                                                               .push(
  //                                                                   HomeScreenRoute(
  //                                                                       MainEAWB(
  //                                                             awbNumber:
  //                                                                 '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}',
  //                                                           )));
  //                                                         }
  //                                                       });
  //                                                       // Navigator.pop(context);
  //                                                     },
  //                                                     child:
  //                                                         Text("AWB Details"));
  //                                               },
  //                                             ),
  //                                             value: 2,
  //                                           )
  //                                         ]),
  //                               ],
  //                             )),
  //                       ),
  //                       isThreeLine: true,
  //                       subtitle: Container(
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Column(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               children: [
  //                                 Text(
  //                                   "Pieces  /",
  //                                   style: TextStyle(
  //                                       fontSize: 15,
  //                                       color: Colors.blueGrey[900],
  //                                       fontWeight: FontWeight.normal,
  //                                       fontFamily: 'RobotoMono'),
  //                                 ),
  //                                 Text(' ${getawblist[index]["pieces"]} ',
  //                                     style: TextStyle(
  //                                         fontSize: 17,
  //                                         color: Colors.indigo[300],
  //                                         fontWeight: FontWeight.bold))
  //                               ],
  //                             ),
  //                             SizedBox(
  //                               width: 10,
  //                             ),
  //                             Column(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               children: [
  //                                 Text("Weight",
  //                                     style: TextStyle(
  //                                         fontSize: 15,
  //                                         color: Colors.blueGrey[900],
  //                                         fontWeight: FontWeight.normal,
  //                                         fontFamily: 'RobotoMono')),
  //                                 Text(
  //                                     ' ${getawblist[index]["weight"]} ${getawblist[index]["weightcode"]}',
  //                                     style: TextStyle(
  //                                         fontSize: 17,
  //                                         color: Colors.indigo[300],
  //                                         fontWeight: FontWeight.bold))
  //                               ],
  //                             ),
  //                             SizedBox(
  //                               width: 10,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               )));
  //     }),
  //   );
  // }

  void _displayCreateAWBDialog(BuildContext context, String awb) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: FittedBox(
                      alignment: Alignment.center,
                      child: Image.asset("assets/images/logo.png"),
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
                        "Update Air Waybill Details",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Container(
                        height: 100,
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Center(
                            child: Text(
                                "Would you like to update Air Waybill Details?",
                                textAlign: TextAlign.center))),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            // color: Theme.of(context).primaryColor,
                            // textColor: Colors.white,
                            // elevation: 5,
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context,
                                  HomeScreenRoute(MainEAWB(awbNumber: awb)));
                            },
                            child: Text("Yes"),
                          ),
                          TextButton(
                            // color: Theme.of(context).primaryColor,
                            // textColor: Colors.white,
                            // elevation: 5,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> deleteAWB(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(StringData.awblistAPI);
    final request = http.Request("DELETE", url);
    request.headers.addAll(<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-access-tokens': prefs.getString('token')
    });
    request.body = jsonEncode({"id": id});
    final response = await request.send();
    print(id);
    print(response);
    // ignore: unrelated_type_equality_checks
    if (response == 'token expired') {
      refreshToken();
    } else {
      // response = json.decode(request.body);
      print(prefs.getString('token'));
    }
    if (response.statusCode == 202 || response.statusCode == 200) {
      print("Sucess");
      // Navigator.push(context, HomeScreenRoute(MyEawb()));
    }
    return true;
  }
}
