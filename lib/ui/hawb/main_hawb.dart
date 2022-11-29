import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/string.dart';
import 'package:rooster/ui/eawb/main_eawb.dart';
import 'package:rooster/ui/hawb/static/add_master_eawb.dart';
import 'package:rooster/ui/hawb/static/edit_hawb.dart';
import 'package:rooster/ui/hawb/house_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:http/http.dart' as http;
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/screenroute.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void refreshToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var response = await http.get(StringData.refreshTokenAPI,
      headers: {'x-access-tokens': prefs.getString('token')});
  var result = json.decode(response.body);
  if (result['result'] == 'verified') prefs.setString('token', result['token']);
  print(result);
}

Future<dynamic> getAWBlist() async {
  var result;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //var response = await http.get(StringData.awblistAPI,
  //headers: {'x-access-tokens': prefs.getString('token')});
  //result = json.decode(response.body);

  //Alternative

  final url = Uri.parse(StringData.awblistAPI);
  final request = http.Request("GET", url);
  request.headers.addAll(<String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'x-access-tokens': prefs.getString('token')
  });

  request.body = jsonEncode({
    //"FlightList_id": id, //40,
    //"Manifest_Version": 2,
    //"FFM_PointOfLoading_AirportCode": flightLoading,
    //"FFM_PointOfUnLoading_AirportCode": flightUnloading
  });
  result = await request.send();

  final respStr = await result.stream.bytesToString();
  result = jsonDecode(respStr);

  //Alternative

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

  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = List();
  bool tutorial = false;

  GlobalKey _listTargetKey = GlobalKey();
  GlobalKey _masterAWBTargetKey = GlobalKey();
  GlobalKey _originToDestinationTargetKey = GlobalKey();
  GlobalKey _piecesAndWeightTargetKey = GlobalKey();
  GlobalKey _fabTarget = GlobalKey();

  void initTargets() {
    targets.add(
      TargetFocus(
        identify: "List",
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
                  S.of(context).SwipeLefttoDeteleandRighttoAddHouses,
                  // "Swipe Left to Detele and Right to Add Houses",
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
        identify: "Master AWB",
        keyTarget: _masterAWBTargetKey,
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
                  S.of(context).MasterAirWaybillofHouses,
                  // "Master Air Waybill of Houses",
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
        identify: "Origin to Destination",
        keyTarget: _originToDestinationTargetKey,
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
                  S.of(context).OrigintoDestinationShipmentTotal,
                  // 'Origin to Destination\nShipment - Total',
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
        identify: "Pieces and Weight",
        keyTarget: _piecesAndWeightTargetKey,
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
                  S.of(context).Numberofpiecesandtotalweight,
                  // "Number of pieces and total weight",
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
        identify: "Add Master AWB here.",
        keyTarget: _fabTarget,
        contents: [
          ContentTarget(
            align: AlignContent.top,
            child: InkWell(
              onTap: () {
                tutorialCoachMark.finish();
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  S.of(context).AddMasterAWBhere,
                  // "Add Master AWB here.",
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
  }

  void _afterLayout(_) {
    Future.delayed(const Duration(seconds: 1), () {
      showTutorial();
    });
  }

  void showTutorial() {
    BuildContext context;
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.black,
      alignSkip: Alignment.topRight,
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
                  //EasyLoading.show();
                  print("Snapshot Data ${snapshot.data}");
                  //getawblist=snapshot.data;
                  return GetAWBList(getawblist: snapshot.data);
                } else if (snapshot.hasError) {
                  return Text(S.of(context).DataNotFound
                    // "Data Not Found"
                  );
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

class GetAWBList extends StatefulWidget {
  var getawblist;
  GetAWBList({Key key, this.getawblist}) : super(key: key);

  @override
  _MyAWBState createState() => _MyAWBState();
}

class _MyAWBState extends State<GetAWBList> with TickerProviderStateMixin{
  TextEditingController controller = new TextEditingController();
  List _searchResult = [];
  AnimationController _controller;
  AnimationController _resizableController;
  bool alertvalue=false;

  Color color;

  Widget _buildSearchBox() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 45,
            width: 250,
            child: TextField(
              controller: controller,
              textCapitalization: TextCapitalization.characters,
              decoration: new InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).accentColor),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                //border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).accentColor),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                hintText:
                S.of(context).Search,
                //'Search',
                prefixIcon: IconButton(
                  icon: new Icon(Icons.search),
                  color: Theme.of(context).accentColor,
                  onPressed: () {},
                ),
                suffixIcon: IconButton(
                  icon: new Icon(Icons.cancel),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    controller.clear();
                    onSearchTextChanged('');
                  },
                ),
                //border: InputBorder.none,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
              ),
              onChanged: onSearchTextChanged,
            ),
          ),
          IconButton(
            icon: new Icon(Icons.filter_list_rounded),
            color: Theme.of(context).accentColor,
            iconSize: 43,
            onPressed: () {
              controller.clear();
              onSearchTextChanged('');
            },
          ),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    print("object");
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    widget.getawblist.forEach((getawblist) {
      print("Foreach'${getawblist}'" + text);
      String searchText = getawblist["origin"].toString();
      if (getawblist["prefix"].toString().contains(text) ||
          getawblist["wayBillNumber"].toString().contains(text) ||
          searchText.contains(text) ||
          getawblist["destination"].toString().contains(text))
        _searchResult.add(getawblist);
    });
    print('$_searchResult');
    setState(() {});
  }
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
    //print("Get AWB list ${widget.getawblist}");
    var getList = _searchResult.length != 0 || controller.text.isNotEmpty
        ? _searchResult
        : widget.getawblist;
    print("Get AWB list ${widget.getawblist}");

    return widget.getawblist == []
        ? Text(S.of(context).DataNotFound
      // "Data Not Found"
    )
        : Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        flexibleSpace: new Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            color: Color.fromRGBO(255, 255, 255, 0.5),
            image: new DecorationImage(
              image: AssetImage('assets/images/flight_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          S.of(context).AWBList,
          //"AWB List",
          textAlign: TextAlign.center,
          style: TextStyle(

            // color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        elevation: 1,
        actions: [
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
          IconButton(onPressed: (){
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                title:  Center(child: Text("Help",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold
                ),
                )),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     Text("The most recently created AWB will be shown on the top",
                       textAlign: TextAlign.justify,
                       style: TextStyle(
                           color: Theme.of(context).accentColor,

                       ),
                     ),
                     Text("Please use Search option if you would like to find any AWB based on AWB Prefix, AWB Serial, AWB Origin Airport Code and AWB Destination Airport Code",
                       textAlign: TextAlign.justify,
                       style: TextStyle(
                           color: Theme.of(context).accentColor
                       ),
                     ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Container(
                      child:  Center(child: Text("Close",
                          style: TextStyle(
                              color: Theme.of(context).accentColor
                          )
                      )),
                    ),
                  ),
                ],
              ),
            );
          }, icon: Icon(Icons.help))
        ],
      ),
      // backgroundColor: Colors.grey.shade200,
      //backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          new Container(
            //color: Theme.of(context).primaryColor,
              child: _buildSearchBox()),
          new Expanded(
              child: _buildAWBList1(
                  context,
                  _searchResult.length != 0 || controller.text.isNotEmpty
                      ? _searchResult
                      : widget.getawblist))
        ],
      ),
    );
  }

  Widget _buildAWBList1(BuildContext context, var getawblist) {
    return ListView(
      reverse: true,
      padding: EdgeInsets.only(top: 0, bottom: 0),
      children: new List<Widget>.generate(getawblist.length, (index) {

        return Dismissible(
            key: ValueKey(getawblist[index]),
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
                              deleteAWB('${getawblist[index]["id"]}');
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
            child: Padding(
                padding:
                EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ],
                    color: Colors.grey,
                    //color: Color.fromRGBO(255, 255, 255, 0.5),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "https://cdn.pixabay.com/photo/2013/07/12/12/54/world-map-146505_640.png")),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    // border: Border.all(
                    //   color: Colors.black,
                    // ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: 79,
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          // boxShadow: [
                          //   new BoxShadow(
                          //     color: Colors.black,
                          //     blurRadius: 20.0,
                          //   ),
                          // ],
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24))
                          // border: Border.all(
                          //   color: Colors.black,
                          // ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  '${getawblist[index]["origin"]}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    //color: Colors.indigo,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.all(6),
                                  //child: Icon(Icons.flight_takeoff,color:Colors.amber),
                                  decoration: BoxDecoration(
                                      color: Colors.indigo.shade50,
                                      borderRadius: BorderRadius.circular(20)),

                                  child: SizedBox(
                                    height: 8,
                                    width: 8,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.indigo.shade400,
                                          borderRadius:
                                          BorderRadius.circular(5)),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Stack(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 21,
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              return Flex(
                                                children: List.generate(
                                                    (constraints.constrainWidth() /
                                                        6)
                                                        .floor(),
                                                        (index) => SizedBox(
                                                      height: 1,
                                                      width: 3,
                                                      child: DecoratedBox(
                                                        decoration:
                                                        BoxDecoration(
                                                            color: Colors
                                                                .black
                                                          //.shade300
                                                        ),
                                                      ),
                                                    )),
                                                direction: Axis.horizontal,
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                              );
                                            },
                                          ),
                                        ),
                                        Center(
                                            child: Transform.rotate(
                                              angle: 1.5,
                                              child: Icon(
                                                Icons.local_airport,
                                                color: Colors.indigo.shade300,
                                                size: 24,
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(6),
                                  //child: Icon(Icons.flight_land,color:Colors.amber),
                                  decoration: BoxDecoration(
                                      color: Colors.pink.shade50,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: SizedBox(
                                    height: 8,
                                    width: 8,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.lightBlue,
                                          borderRadius:
                                          BorderRadius.circular(5)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${getawblist[index]["destination"]}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    //color: Colors.indigo,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                    child: Text(
                                      S.of(context).Pieces,
                                      //"Pieces",
                                      style: TextStyle(
                                        fontSize: 11,
                                        //color: Colors.deepPurpleAccent,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    )),
                                SizedBox(
                                  width: 60,
                                ),
                                SizedBox(
                                  width: 180,
                                ),
                                Container(
                                    child: Text(
                                      S.of(context).Weight,
                                      //"Weight",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Theme.of(context).accentColor,
                                        // color: Colors.deepPurpleAccent,
                                      ),
                                    )),
                              ],
                            ),
                            // SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 9),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                        // color: Colors.lightBlueAccent,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 3.0, bottom: 3.0),
                                        child: Text(
                                          '${getawblist[index]["pieces"]}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              // color: Colors.black54,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                ),
                                Container(
                                  //color: Colors.lightBlueAccent,
                                    child: Text(
                                      '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          //color: Colors.black,
                                          color: Theme.of(context).accentColor,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Row(
                                  children: <Widget>[
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                          // color: Colors.lightBlueAccent,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            '${getawblist[index]["weight"]} ${getawblist[index]["weightcode"]}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                // color: Colors.black54,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        //color: Colors.white,
                        color: Theme.of(context).backgroundColor,
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              height: 15,
                              width: 10,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    color: Colors.grey.shade200),
                              ),
                            ),
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
                              height: 15,
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
                      ),
                      Container(
                        padding:
                        EdgeInsets.only(left: 16, right: 16, bottom: 12),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // CustomPaint(
                            //   painter: CirclePainter(
                            //       _controller,
                            //     color: color,
                            //     // color: Theme.of(context).accentColor
                            //   ),
                            //   child: SizedBox(
                            //       height: 10,
                            //       width:10,
                            //       child: Icon(Icons.dangerous_outlined, size: 10,
                            //         color:
                            //         Theme.of(context).backgroundColor,
                            //       )
                            //     //_button(),
                            //   ),
                            // ),
                            Container(
                              height: 30,
                              child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: PopupMenuButton(
                                      child: Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).accentColor.withOpacity(0.3),
                                            // color: Colors.amber.shade50,
                                            borderRadius:
                                            BorderRadius.circular(20)),
                                        child: Icon(
                                          Icons.flight_takeoff,
                                          color: Theme.of(context).accentColor,
                                          // color: Colors.amber
                                        ),
                                      ),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(

                                          child: Consumer<EAWBModel>(
                                            builder: (BuildContext context,
                                                model, Widget child) {
                                              return TextButton(
                                                  style: TextButton.styleFrom(
                                                    // primary: Colors.purpleAccent,
                                                    // backgroundColor: Colors.black, // Background Color
                                                  ),
                                                  onPressed: () {
                                                    // Navigator.of(
                                                    //     context)
                                                    //     .push(
                                                    //     HomeScreenRoute(
                                                    //         MainEAWB(
                                                    //           awbNumber:
                                                    //           '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}',
                                                    //         )
                                                    //     ));
                                                    // Navigator.push(
                                                    //     context,
                                                    //     HomeScreenRoute(
                                                    //         MainEAWB(
                                                    //           awbNumber:
                                                    //           '${getawblist[index]["prefix"]}${getawblist[index]["wayBillNumber"]}',
                                                    //         )));
                                                    model.clearEAWB();
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
                                                          if (value == 'New Air Waybill Number') {
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
                                                            _displayCreateAWBDialog(
                                                                context,
                                                                '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}');
                                                            //
                                                          } else {
                                                            print(
                                                                "DATA FROM getEAWB $value");

                                                            model.awbConsigmentDetailsAWBNumber =
                                                            '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}';
                                                            // Navigator.push(
                                                            //     context,
                                                            //     MaterialPageRoute(
                                                            //       builder: (context) =>
                                                            //           MainEAWB(
                                                            //             awbNumber:
                                                            //             '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}',
                                                            //           )
                                                            //     )
                                                            // );
                                                            Navigator.of(
                                                                context)
                                                                .push(
                                                                HomeScreenRoute(
                                                                    MainEAWB(
                                                                      awbNumber:
                                                                      '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}',
                                                                    )
                                                                ));
                                                          }
                                                        });
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        S.of(context).AWBdetails,
                                                        style: TextStyle(
                                                          color: Theme.of(context).accentColor,
                                                        ),
                                                        //"AWB Details"
                                                      ),
                                                      // Divider(
                                                      //   color: Theme.of(context).accentColor,thickness: 2,
                                                      // ),
                                                    ],
                                                  ));
                                            },
                                          ),
                                          value: 2,
                                        ),
                                        // Divider(
                                        //   color: Colors.black,
                                        // ),
                                        //PopupMenuDivider(),
                                        PopupMenuItem(
                                          child: Container(
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
                                                child: Text(
                                                  S
                                                      .of(context)
                                                      .HouseDetails,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                  // "House Details"
                                                )),
                                          ),
                                          value: 1,
                                        ),
                                      ],

                                      // offset: Offset(0, 30),
                                      // elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                      ))),
                            ),

                            TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0))),
                                        title: Center(
                                            child: Text(
                                              S.of(context).Createddateandtime,
                                              //'Created date and time',
                                              style: TextStyle(
                                                  color:
                                                  Theme.of(context).accentColor,
                                                  fontStyle: FontStyle.italic),
                                            )),
                                        content: Container(
                                            child: Card(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('${getawblist[index]["Created_User"]}',
                                                        style: TextStyle(
                                                            color: Theme.of(context)
                                                                .accentColor),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Text(
                                                        //   '${loginhistoryD[index]["origin"]}',
                                                        //   // '${userid[index]}',
                                                        //   style: TextStyle(
                                                        //       color: Colors.grey,
                                                        //       fontWeight: FontWeight.bold),
                                                        // ),
                                                        Text(
                                                          '${getawblist[index]["Created_Time"]}',
                                                          // '${ipaddr[index]}',
                                                          style: TextStyle(
                                                              color:
                                                              Theme.of(context)
                                                                  .accentColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        actions: <Widget>[
                                          Center(
                                            child: new FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              //textColor: Theme.of(context).primaryColor,
                                              child: Text(
                                                S.of(context).Close,
                                                //'Close',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  )),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Row(
                                children: [
                                  Text(
                                   S.of(context).MoreInfo,
                                    // "More Info",
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  Icon(
                                    Icons.info,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )));
      }),
    );
  }

  void _displayCreateAWBDialog(BuildContext context, String awb) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: 300,
          child: Stack(
            overflow: Overflow.visible,
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
                        S.of(context).UpdateAirWaybillDetails,
                        //  "Update Air Waybill Details",
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
                                S
                                    .of(context)
                                    .WouldyouliketoupdateAirWaybillDetails,
                                //"Would you like to update Air Waybill Details?",
                                textAlign: TextAlign.center))),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            elevation: 5,
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context,
                                  HomeScreenRoute(MainEAWB(awbNumber: awb)));
                            },
                            child: Text(S.of(context).Yes
                              //"Yes"
                            ),
                          ),
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            elevation: 5,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              S.of(context).Cancel,
                              //"Cancel"
                            ),
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
