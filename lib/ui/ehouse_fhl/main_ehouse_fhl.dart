import 'package:flutter/material.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/ui/ehouse_fhl/edit_houses_fhl.dart';
import 'package:rooster/ui/ehouse_fhl/static/add_master_awb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class MainEHouseFHL extends StatefulWidget {
  @override
  _MainEHouseFHLState createState() => _MainEHouseFHLState();
}

class _MainEHouseFHLState extends State<MainEHouseFHL> {
/*
  final _awbForm = GlobalKey<FormState>();
*/
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = List();
  bool tutorial = true;

  GlobalKey _listTargetKey = GlobalKey();
  GlobalKey _masterAWBTargetKey = GlobalKey();
  GlobalKey _originToDestinationTargetKey = GlobalKey();
  GlobalKey _piecesAndWeightTargetKey = GlobalKey();
  GlobalKey _fabTarget = GlobalKey();

  var masterAWB = [
    {
      'airline': 154,
      'masterAWB': 53800033,
      'origin': 'BLR',
      'destination': 'DXB',
      'shipment': 'T',
      'pieces': 21,
      'weight': 100,
      'unit': 'K',
    },
    {
      'airline': 618,
      'masterAWB': 72442672,
      'origin': 'BLR',
      'destination': 'DXB',
      'shipment': 'T',
      'pieces': 10,
      'weight': 200,
      'unit': 'K',
    }
  ];

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
                  //"Swipe Left to Detele and Right to Add Houses",
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
                  //"Master Air Waybill of Houses",
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
                  //'Origin to Destination\nShipment - Total',
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
                  //  "Number of pieces and total weight",
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          S.of(context).EHouse,
          //  'eHouse (FHL)'
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          key: _fabTarget,
          backgroundColor: Theme.of(context).accentColor,
          onPressed: () async {
            Map<String, dynamic> newMasterAWB = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMasterAWBFHL(),
                  fullscreenDialog: true,
                ));
            if (newMasterAWB != null) {
              setState(() {
                masterAWB.add(newMasterAWB);
              });
            }
          },
          child: Icon(Icons.add),
        ),
      ),
      body: tutorial
          ? ListView(
              children: [
                Card(
                  key: _listTargetKey,
                  child: ListTile(
                    title: Text(
                      'XXX-XXXXXXXX',
                      key: _masterAWBTargetKey,
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      'XXX <-> XXX\nShipment - Total',
                      key: _originToDestinationTargetKey,
                      style: TextStyle(fontSize: 15),
                    ),
                    isThreeLine: true,
                    trailing: Text(
                      'X pieces with X.X K(or)L',
                      key: _piecesAndWeightTargetKey,
                    ),
                  ),
                ),
              ],
            )
          : ListView.separated(
              itemCount: masterAWB.length,
              itemBuilder: (context, index) => Dismissible(
                key: ValueKey(masterAWB[index]),
                confirmDismiss: (DismissDirection direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title:  Text(
                              S.of(context).DeleteConfirmation,
                             // "Delete Confirmation"
                          ),
                          content:  Text(
                            S.of(context).Areyousureyouwanttodeletethisitem,

                            //  "Are you sure you want to delete this item?"
                          ),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text(
                                   // "Delete"
                                S.of(context).Delete,
                                )),
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child:  Text(
                              S.of(context).Cancel,
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
                          builder: (context) => EditHousesFHL(
                              '${masterAWB[index]['airline']}-${masterAWB[index]['masterAWB']}'),
                        ));
                    return false;
                  }
                },
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    setState(() {
                      masterAWB.removeAt(index);
                    });
                  }
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
                            , style: TextStyle(color: Colors.white)),
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
                         S.of(context).EditHouses,
                         // 'Edit Houses',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                child: Card(
                  child: ListTile(
                    title: Text(
                      '${masterAWB[index]['airline']}-${masterAWB[index]['masterAWB']}',
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      '${masterAWB[index]['origin']}-${masterAWB[index]['destination']}\nShipment - ${masterAWB[index]['shipment']}',
                      style: TextStyle(fontSize: 15),
                    ),
                    isThreeLine: true,
                    trailing: Text(
                        '${masterAWB[index]['pieces']} pieces with ${masterAWB[index]['weight']}${masterAWB[index]['unit']}'),
                  ),
                ),
              ),
              separatorBuilder: (context, index) => Divider(),
            ),
    );
  }
}
