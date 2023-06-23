import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/screenroute.dart';
import 'package:rooster/string.dart';
import 'package:rooster/ui/GroupChart/chart_homepage.dart';
import 'package:rooster/ui/homescreen/configuration.dart';
import 'package:rooster/ui/homescreen/dashboard.dart';
import 'package:rooster/ui/homescreen/eawb.dart';
import 'package:rooster/ui/homescreen/ehouse.dart';
import 'package:rooster/ui/homescreen/emanifest.dart';
import 'package:rooster/ui/homescreen/iata_cargo_xml.dart';
import 'package:rooster/ui/homescreen/iata_one_record.dart';
import 'package:rooster/ui/homescreen/iataedi.dart';
import 'package:rooster/ui/homescreen/my_hawb.dart';
import 'package:rooster/ui/homescreen/policies.dart';
import 'package:rooster/ui/homescreen/social_media.dart';
import 'package:rooster/ui/homescreen/telex.dart';
import 'package:rooster/ui/homescreen/user_management.dart';
import 'package:rooster/ui/loginscreen/main_logincardscreen.dart';
import 'package:rooster/ui/loginscreen/new_signin_sigup.dart';
import 'package:rooster/ui/payment_wallet/add_wallet.dart';
import 'package:rooster/ui/slot_booking/Slot_book.dart';
import 'package:rooster/ui/slot_booking/slot_booking.dart';
import 'package:rooster/ui/slot_booking/slot_homepage.dart';
import 'package:rooster/ui/slot_booking/slot_manager.dart';
import 'package:rooster/ui/todo_list/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:http/http.dart' as http;
import 'package:rooster/model/profile_model.dart';

import '../../color_picker.dart';
import '../../formatter.dart';
import '../../languagechangeprovider.dart';
import '../../theme_changer.dart';
import '../payment_wallet/recharge_wallet.dart';
import 'flight_list.dart';
import 'new_dashbord.dart';
import 'profile.dart';

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

class NewHomeScreen extends StatefulWidget {
  @override
  _NewHomeScreenState createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  bool _customTileExpanded = false;
  String _currentSelectedValue;
  var types = [
    "perishable",
    "live animals",
    "general",
    "radio active",
    "valuable",
  ];
  var val = -1;
  bool _value = false;
  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US'), 'lang': "en"},
    {'name': 'தமிழ்', 'locale': Locale('ta', 'IN'), 'lang': 'ta'},
    // {'name':'ಕನ್ನಡ','locale': Locale('kn','IN'),'lang': 'kn'},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN'), 'lang': 'hi'},
    {'name': 'عربي', 'locale': Locale('ar', 'MY'), 'lang': 'ar'},
  ];

  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = List();

  GlobalKey _tileTargetKey = GlobalKey();
  GlobalKey _settingTargetKey = GlobalKey();
  var _homeScaffoldKey = new GlobalKey<ScaffoldState>();
  bool tutorial;
  var emailId;

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      if (value.getString('email') != null) {
        setState(() {
          emailId = value.getString('email');
        });
      }
      if (value.getBool('tutorial') ?? true) {
        // initTargets();
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

  Widget LoginHistory({loginhistoryD}) {
    return AlertDialog(
      title: Center(child: const Text('Login History')),
      content:
          //userid.isNotEmpty
          Container(
        height: 200,
        width: 300,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: loginhistoryD.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${loginhistoryD[index]["Created_User"]}',
                        style: TextStyle(color: Colors.orangeAccent),
                      ),
                      // Text(
                      //   '${loginhistoryD[index]["origin"]}',
                      //   // '${time[index]}',
                      //   style: TextStyle(color: Colors.green),
                      // ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          '${loginhistoryD[index]["Created_Time"]}',
                          // '${ipaddr[index]}',
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //         child: ListTile(
              //           tileColor: Colors.transparent,
              // // tileColor: Colors.black26,
              //             leading: Text('${date[index]}',
              //               style: TextStyle(
              //                   color: Colors.orangeAccent
              //               ),),
              // //             leading: Icon(Icons.add_location),
              //          // title:Text('${userid[index]}'),
              //           title:  Text('${ipaddr[index]}',
              //             style: TextStyle(
              //               // color: Colors.orangeAccent
              //             ),),
              //           trailing:  Text('${time[index]}',
              //             style: TextStyle(
              //               // color: Colors.orangeAccent
              //             ),),
              //         ),
            );
          },
        ),
      ),
      actions: <Widget>[
        Center(
          child:  TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },  
            //textColor: Theme.of(context).primaryColor,
            child: const Text('Close'),
          ),
        ),
      ],
    );
  } // updateLanguage(Locale locale){

  //   context.read<LanguageChangeProvider>().changeLocale("ar");
  // }
  Widget _buildHistory(BuildContext context) {
    // var itemCount =20;
    final List<String> userid = <String>[
      'Mumbai',
      'chennai',
      "hongkong",
      "Maldives",
      "Dubai"
    ];
    final List<String> date = <String>[
      'Dec 12,2021',
      'Nov 04,2021',
      'July 27,2021',
      'July 02,2021',
      'Nov 21,2021'
    ];
    final List<String> time = <String>[
      '12:00:02 AM',
      '11:00:01 PM',
      '13:00:00 PM',
      '1:00:00 PM',
      '15:01:00 PM'
    ];
    final List<String> ipaddr = <String>[
      '(157.49.147.216)',
      '(157.49.137.206)',
      '(157.49.147.286)',
      '(157.49.147.236)',
      '(157.49.147.206)'
    ];

    return new Container(
      //height: MediaQuery.of(context).size.height - 185.0,
      child: Center(
        child: FutureBuilder<dynamic>(
          future: getAWBlist(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              EasyLoading.show();
              print("Snapshot Data ${snapshot.data}");
              //getawblist=snapshot.data;
              return LoginHistory(loginhistoryD: snapshot.data);
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
    );
  }

  buildLanguageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text(
              S.of(context).ChooseYourLanguage,
              //  'Choose Your Language'
            ),
            content: Container(
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Text(locale[index]['name']),
                        onTap: () {
                          print(locale[index]['name']);
                          context
                              .read<LanguageChangeProvider>()
                              .changeLocale(locale[index]['lang']);
                          // updateLanguage(locale[index]['locale']);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.blue,
                    );
                  },
                  itemCount: locale.length),
            ),
          );
        });
  }

  // void initTargets() {
  //   targets.add(
  //     TargetFocus(
  //       identify: "Tile",
  //       keyTarget: _tileTargetKey,
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
  //                 S.of(context).ClickontheTilestoNavigate,
  //                 // "Click on the Tiles to Navigate",
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
  //   targets.add(
  //     TargetFocus(
  //       identify: "Setting",
  //       keyTarget: _settingTargetKey,
  //       contents: [
  //         ContentTarget(
  //           align: AlignContent.bottom,
  //           child: InkWell(
  //             onTap: () {
  //               tutorialCoachMark.finish();
  //             },
  //             child: Padding(
  //               padding: const EdgeInsets.only(bottom: 20.0),
  //               child: Text(
  //                 S.of(context).Settings,
  //                 //"Settings",
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
      // showTutorial();
    });
  }
  //
  // void showTutorial() {
  //   tutorialCoachMark = TutorialCoachMark(
  //     context,
  //     targets: targets,
  //     colorShadow: Colors.black,
  //     textSkip: "SKIP",
  //     paddingFocus: 10,
  //     opacityShadow: 0.8,
  //   )..show();
  // }

  _endDrawerUI() {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 6,
                                color: Colors.black,
                                spreadRadius: 0.1)
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage:
                          AssetImage(
                            "assets/profile/default.png"
                          ),
                              //"https://png.pngitem.com/pimgs/s/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"),
                        ),
                      ),
                      SizedBox(height: 15),
                      //These can go here or below the header with the same background color
                      // Text(
                      //   "Hi Gokul",
                      //   style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 20,
                      //       fontWeight: FontWeight.bold),
                      // ), //customize this text
                      Text(
                       // "RoosterAirCargo1@gmail.com",
                        emailId,
                        // "icms_maa@aai.aero",
                        // "",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      //...additional header items here
                    ],
                  )),

              // DrawerHeader(
              //   decoration: BoxDecoration(
              //       // borderRadius: BorderRadius.only(
              //       //           bottomLeft: Radius.circular(80),
              //       //                  bottomRight: Radius.circular(60)
              //       //       ),

              //       // shape: BoxShape.circle,
              //       color: Theme.of(context).primaryColor,
              //       image: DecorationImage(
              //         //alignment: Alignment.center,
              //         fit: BoxFit.fill,
              //         colorFilter: ColorFilter.mode(
              //             Colors.black.withOpacity(0.2), BlendMode.srcOver),
              //         image: NetworkImage(
              //             "https://i.pinimg.com/564x/e8/78/07/e878077e0f4bf593bdebee566f2f39a4.jpg"
              //             //"https://images.unsplash.com/photo-1527605158555-853f200063e9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=371&q=80",
              //             ),
              //         // image: AssetImage(
              //         //     'assets/images/drawer_header_background.png')
              //       )),
              //   child: Align(
              //     alignment: Alignment.center,
              //     child: Text(
              //       S.of(context).Settings,
              //       //'Settings',
              //       style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         color: Colors.black,
              //         fontSize: 24,
              //       ),
              //     ),
              //   ),
              // ),
              ListTile(
                title: Text(
                  S.of(context).DarkMode,
                  //"Dark Mode"
                ),
                trailing: Switch(
                  value: _themeChanger.isDarkTheme,
                  onChanged: (value) {
                    _themeChanger.toggleDarkTheme();
                  },
                ),
                onTap: () {
                  _themeChanger.toggleDarkTheme();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.color_lens,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  S.of(context).Theme,
                  //"Theme"
                ),
                onTap: () {
                  Navigator.pop(context);
                  _colorPicker(_themeChanger);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.refresh,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  "Refresh"
                  //S.of(context).Theme,
                  //"Theme"
                ),
                onTap: () {
                  setState(() {
                    if (
                    StringData.airportCodes == null ||
                        StringData.airportCodes.isEmpty ||
                        StringData.specialhandlinggroup.isEmpty ||
                        StringData.contactType.isEmpty ||
                        StringData.airlineCodes.isEmpty ||
                        StringData.contactType.isEmpty ||
                        StringData.CHGSCode.isEmpty ||
                        StringData.voulmeCodes.isEmpty
                    ) {
                      StringData.loadAirportCode();
                      StringData.loadAirlineCode();
                      StringData.loadVolumeCode();
                      StringData.loadOtherChargesCode();
                      StringData.loadRateClassCode();
                      StringData.loadAccId();
                      StringData.loadtCHGSCode();
                      StringData.loadtContactType();
                      StringData.loadShgCode();
                      StringData.loadCurrency();
                      StringData.loadExchangeRate();
                      StringData.loadAirport();
                    }
                  });
                  Navigator.pop(context);
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Center(
                        child: const Text('Success',
                        style: TextStyle(
                          color: Colors.greenAccent
                        ),),
                      ),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.table_chart,
                            color:Theme.of(context).accentColor,
                          ),
                           Text('Refresh Reference table',
                          textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        Center(
                          child: TextButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor)),
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child:  Text('Close',
                            style: TextStyle(

                              color:Theme.of(context).backgroundColor,)
                            ),
                          ),
                        ),
                        // TextButton(
                        //   onPressed: () => Navigator.pop(context, 'OK'),
                        //   child: const Text('OK'),
                        // ),
                      ],
                    ),
                  );
                //  _colorPicker(_themeChanger);
                },
              ),
              ListTile(
                leading: Transform.rotate(
                    angle: pi,
                    child: Icon(
                      Icons.exit_to_app,
                      color: Theme.of(context).accentColor,
                    )
                ),
                title: Text(
                  S.of(context).Logout,
                  //"Logout"
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmLogout();
                },
              ),
              IconButton(
                  icon: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.language,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          S.of(context).Language,
                          // "Language"
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    buildLanguageDialog(context);
                  }),
              ListTile(
                  leading: Icon(
                    Icons.history,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text(S.of(context).History
                      // "History",
                      ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => _buildHistory(context),
                    );
                  }),
              //             RaisedButton(
              //             child: Text(
              //             'History',
              //             style: TextStyle(
              //               color: Colors.black,
              //             ),
              //           ),
              //   color: Colors.white,
              //   onPressed: () {
              //     showDialog(
              //       context: context,
              //       builder: (BuildContext context) => _buildPopupDialog(context),
              //     );
              //   },
              // ),
              // ),
              ListTile(
                title: Text(
                  S.of(context).Tuitorial,
                  //"Tutorial"
                ),
                trailing: Switch(
                  value: tutorial,
                  onChanged: (value) {
                    setState(() {
                      tutorial = !tutorial;
                      SharedPreferences.getInstance().then((value) {
                        value.setBool('tutorial', tutorial);
                      });
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    tutorial = !tutorial;
                    SharedPreferences.getInstance().then((value) {
                      value.setBool('tutorial', tutorial);
                    });
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showDialog(
      context: context,
      builder: (context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            title: Text(
              S.of(context).Logout,
              // 'Logout'
            ),
            content: Text(
              S.of(context).Wouldyouliketologout,
              //'Would you like to logout?'
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  S.of(context).Yes,
                  //"Yes"
                ),
                onPressed: () async {
                  await prefs.remove('email');
                  await prefs.remove('token');
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context, HomeScreenRoute(LoginPage()));
                },
              ),
              TextButton(
                child: Text(
                  S.of(context).No,
                  //"No"
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        } else {
          return CupertinoAlertDialog(
            title: Text(
              S.of(context).Logout,
              //'Logout'
            ),
            content: Text(
              S.of(context).Wouldyouliketologout,
              //'Would you like to logout?'
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  S.of(context).Yes,
                  //"Yes"
                ),
                onPressed: () async {
                  await prefs.remove('email');
                  await prefs.remove('token');
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context, HomeScreenRoute(LoginCardScreen()));
                },
              ),
              CupertinoDialogAction(
                child: Text(S.of(context).No
                    //"No"
                    ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
      },
    );
  }

  void _colorPicker(_themeChanger) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).Selectacolor
              // 'Select a color'
              ),
          content: Builder(
            builder: (context) {
              return SingleChildScrollView(
                child: BlockPicker(
                  pickerColor: Theme.of(context).primaryColor,
                  onColorChanged: (value) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('theme', value.toString());
                    print(prefs.getString('theme'));
                    _themeChanger.baseColorbyColor = value;
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  final _awbForm = GlobalKey<FormState>();

  String _eAWBNumber = "";

  _showDialogAWB(EAWBModel model) {
    // model.clearEAWB();

    Future.delayed(Duration(milliseconds: 500), () {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Dialog(
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
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: FittedBox(
                        alignment: Alignment.center,
                        child: Image.asset
                            //   ("https://eadn-wc01-4731180.nxedge.io/cdn/media/wp-content/uploads/2019/02/transportation-and-logistics-concept.jpg"
                            // ),
                            (
                        "ssets/images/logo.png"
                        //    "https://image.shutterstock.com/image-vector/warehouse-loading-dock-goods-vehicles-260nw-2044711208.jpg"
                        ),
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
                          // "Enter AWB number",
                          style: TextStyle(fontSize: 20),
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
                            validator: (value) {
                              print(value);
                              if (value.length == 13)
                                value = value.substring(0, 12);
                              if (value.isEmpty)
                                return "Give AWB Number to\ncreate or retrieve eAWB";
                              if (value.length != 12)
                                return "AWB number should be 12 including '-'";
                              if (value.indexOf("-") != 3)
                                return "Not proper AWB number\neg: 150-78596324";
                              if (!value.endsWith(
                                  '${int.parse(value.substring(4, value.length - 1)) % 7}'))
                                return "Not Valid AWB Number.";
                              return null;
                            },
                            onChanged: (value) => setState(() {
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
                            cursorColor: Theme.of(context).primaryColor,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "___-________",
                              labelText: S.of(context).AWBnumber,
                              // "AWB-Number"
                            ),
                            maxLength: 12,
                            // maxLengthEnforced: true,
                          ),
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor)),
                        onPressed: () {
                          //print(model.awbConsigmentDetailsAWBNumber);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => SlotManager(
                                  // awbNumber: _eAWBNumber,
                                  )));
                        },
                        child: Text(
                          S.of(context).Search,
                          style: TextStyle(color: Theme.of(context).backgroundColor),
                          // "Search"
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _homeScaffoldKey,
      endDrawer: _endDrawerUI(),
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          S.of(context).AirCargoeAWB,

          //"AirCargo eAWB"
        ), //Drona eAWB - Home Page
        actions: [
          IconButton(
              icon: Icon(
                Icons.menu_open_rounded,
                size: 30,
              ),
              onPressed: () {
                print("object");
                _homeScaffoldKey.currentState.openEndDrawer();
              }),
        ],
      ),
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            TweenAnimationBuilder(
              tween: Tween(begin: 1.0, end: 0.0),
              curve: Curves.easeIn,
              duration: const Duration(seconds: 1),
              child: SizedBox(
                width: width,
                height: height * 0.9 / 3,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Spacer(),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0)),
                  ),
                ),
              ),
              builder: (context, value, child) => Transform.translate(
                offset: Offset(0, -(height * 0.6) * (value)),
                child: child,
              ),
            ),
            Container(
              color: Colors.transparent,
              alignment: Alignment.topCenter,
              child: TweenAnimationBuilder(
                tween: Tween(begin: 1.0, end: 0.0),
                curve: Curves.easeIn,
                duration: const Duration(seconds: 1),
                //child: SizedBox(
                //  height: height * 0.6,
                //color: Colors.transparent,
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      // ? Dashboard....
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 07.0, left: 15),
                      //   child: Text(
                      //     "About",
                      //     style: TextStyle(
                      //       decoration: TextDecoration.underline,
                      //       fontWeight: FontWeight.w700,
                      //       fontSize: 20.0,
                      //     ),
                      //   ),
                      // ),
                      Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          // border:
                          //   Border.all(color: Colors.blueAccent, width: 5)
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            children: [
                              Dashboard(
                                  // key: _tileTargetKey,
                                  ),
                              // ? User Management....
                              UserManagement(),
                              // ? Configuration....
                              Configuration(),
                              // ? Social Media....
                              SocialMedia(),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 07.0, left: 15),
                        child: Text(
                          S.of(context).AirWaybill,
                          //"Air Waybill",
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            // border: Border.all(color: Colors.blueAccent)
                            ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              HAWB(),
                              EAWB(),
                              EHouseFHL(),
                              EManifestFFM(),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            // border: Border.all(color: Colors.blueAccent)
                            ),
                        child: SingleChildScrollView(
                          child: Row(
                            children: [FlightBook()],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 07.0, left: 15),
                        child: Text(
                          S.of(context).TelexIATA,
                          // "Telex & IATA",
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0,
                          ),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            // border: Border.all(color: Colors.blueAccent)
                            ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Telex(),
                              // ? IATA EDI....
                              IATAEDI(),
                              // ? IATA Cargo XML....
                              IATACargoXML(),

                              // ? Policies....
                              //Policies(),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 15, right: 15),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Theme.of(context).backgroundColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8.0,
                                  offset: Offset(0.0, 5.0),
                                ),
                              ],
                            ),
                            width: double.infinity,
                            child: GestureDetector(
                              // onTap: () {
                              //   Navigator.of(context).push(MaterialPageRoute(
                              //       builder: (BuildContext context) =>
                              //           SlotBooking()));
                              // },
                              onTap: () {
                                // _openCustomDialog();

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Slot_home()));
                                // EAWBModel model;
                                //_showDialogAWB(model);
                              },
                              // onLongPress: () {
                              //   EAWBModel model;
                              //   _showDialogAWB(model);
                              // },
                              child: ListTile(
                                leading: Image(
                                  width: 39.0,
                                  color: Theme.of(context).accentColor,
                                  image: AssetImage(
                                    "assets/homescreen/slot_booking.png"
                                    //  "https://cdn-icons-png.flaticon.com/512/2649/2649019.png"
                                      // "https://cdn-icons-png.flaticon.com/512/2329/2329087.png"
                                      ),
                                ),
                                title: Text(
                                    S.of(context).DockandSlotBooking
                                 //   "Dock and Slot Booking"
                                ),
                                subtitle: Text(
                                    S.of(context).BookDockNumberandSlotTimebasedoneitherAWBorVehicleRegistrationNumber
                                   //"Book Dock Number and Slot Time based on either AWB or Vehicle Registration Number"
                                    // "This service to provide customers possible time slots to book via Internet."
                                    ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            )),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 15, right: 15),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Theme.of(context).backgroundColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8.0,
                                  offset: Offset(0.0, 5.0),
                                ),
                              ],
                            ),
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () {
                                //Navigator.of(context).push(MaterialPageRoute(
                                //  builder: (BuildContext context) => DetailPage()));
                              },
                              child: ListTile(
                                leading: Image(
                                  width: 39.0,
                                  color: Theme.of(context).accentColor,
                                  image: AssetImage(
                                    "assets/homescreen/about.png"
                                     // "https://img.icons8.com/ios-filled/452/about.png"
                                      // "https://cdn-icons-png.flaticon.com/512/2329/2329087.png"
                                      ),
                                ),
                                title: Text(S.of(context).About
                                    // "About"
                                    ),
                                subtitle: Text(S.of(context).About
                                    //"About"
                                    ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 15, right: 15),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Theme.of(context).backgroundColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8.0,
                                  offset: Offset(0.0, 5.0),
                                ),
                              ],
                            ),
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () {
                                //Navigator.of(context).push(MaterialPageRoute(
                                //  builder: (BuildContext context) => DetailPage()));
                              },
                              child: ListTile(
                                leading: Image(
                                  width: 39.0,
                                  color: Theme.of(context).accentColor,
                                  image: AssetImage(
                                      //"https://uxwing.com/wp-content/themes/uxwing/download/12-peoples-avatars/team-communication.png"
                                    "assets/homescreen/chatbox.png"
                                   // "https://img.icons8.com/wired/344/chat.png"
                                    //  "https://cdn-icons.flaticon.com/png/512/919/premium/919904.png?token=exp=1660142065~hmac=d0aed4d4e291d1b14ac3ffe1d9573bcd"
                                      ),
                                ),
                                title: Text(
                                    S.of(context).ChatBox
                                   //"ChatBox"
                                ),
                                subtitle: Text(S
                                        .of(context)
                                        .Abilitytochatwithmultiplepeople
                                    // "Ability to chat with multiple people"
                                    ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context, HomeScreenRoute(ChatPage()));
                                  },
                                ),
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 15, right: 15),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Theme.of(context).backgroundColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8.0,
                                  offset: Offset(0.0, 5.0),
                                ),
                              ],
                            ),
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ToDoList()));
                              },
                              child: ListTile(
                                leading: Image(
                                  width: 39.0,
                                  color: Theme.of(context).accentColor,
                                  image: AssetImage(
                                    "assets/homescreen/todolist.png"
                                    //  "https://cdn-icons-png.flaticon.com/512/1/1560.png"
                                  ),
                                ),
                                title: Text(S.of(context).ToDoList
                                    //"To Do List"
                                    ),
                                subtitle: Text(S.of(context).AddtodoList
                                    //"Add to do List"
                                    ),
                                trailing: Icon(
                                  Icons.post_add_outlined,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 15, right: 15),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Theme.of(context).backgroundColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8.0,
                                  offset: Offset(0.0, 5.0),
                                ),
                              ],
                            ),
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () {
                                //Navigator.of(context).push(MaterialPageRoute(
                                //  builder: (BuildContext context) => DetailPage()));
                              },
                              child: ListTile(
                                // leading: Icon(
                                //   Icons.policy_outlined,
                                //   color: Theme.of(context).accentColor,
                                // ),
                                leading: Image(
                                  width: 39.0,
                                  color: Theme.of(context).accentColor,
                                  image: AssetImage(
                                    "assets/homescreen/policies.png"
                                  //    "https://cdn-icons-png.flaticon.com/512/4599/4599298.png"
                                  ),
                                ),
                                title: Text(S.of(context).Policies
                                    //"Policies"
                                    ),
                                subtitle: Text(S
                                        .of(context)
                                        .Identifiestheactualguidingprinciples
                                    //"Identifies the actual guiding principles"
                                    ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 15, right: 15),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Theme.of(context).backgroundColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8.0,
                                  offset: Offset(0.0, 5.0),
                                ),
                              ],
                            ),
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                 builder: (BuildContext context) =>
                                     RechargeWallet()
                                     //PaymentHomePage()
                                ));
                              },
                              child: ListTile(
                                // leading: Icon(
                                //   Icons.policy_outlined,
                                //   color: Theme.of(context).accentColor,
                                // ),
                                leading: Image(
                                  width: 39.0,
                                  color: Theme.of(context).accentColor,
                                  image: AssetImage(
                                    "assets/homescreen/payment_wallet.png"
                                  //    "https://cdn-icons-png.flaticon.com/512/7150/7150057.png"
                                  ),
                                    // "https://cdn-icons-png.flaticon.com/512/4599/4599298.png"),
                                ),
                                title: Text(
                                  "Payment Wallet"
                                  //"Policies"
                                ),
                                subtitle:
                                Text("Safe, Secure and Fast"),
                            //    Text(S.of(context).Identifiestheactualguidingprinciples
                                  //"Identifies the actual guiding principles"
                               // ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            )),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(17.0),
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              S.of(context).CopyrightRoosterTech,
                              // "Copyright © 2022 Rooster Tech",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.normal,
                                //fontSize: 20.0,
                              ),
                            )),
                      ),
                      // ? IATA One Record....
                      //IATAOneRecord(),
                      // ? Policies....
                      //Policies(),

                      // Wrap(
                      //   children: [
                      //     Column(
                      //       children: <Widget>[
                      //         Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Text(
                      //               "Air Way Bill",
                      //               style: TextStyle(
                      //                 fontSize: 22.0,
                      //                 fontWeight: FontWeight.bold,
                      //                 letterSpacing: 1.5,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //         SizedBox(
                      //           height: 20,
                      //         ),
                      //         SingleChildScrollView(
                      //           scrollDirection: Axis.horizontal,
                      //           child: Wrap(
                      //             spacing: 10,
                      //             children: [
                      //               HAWB(),
                      //               EAWB(),
                      //               EHouseFHL(),
                      //               EManifestFFM(),
                      //             ],
                      //           ),
                      //         )
                      //       ],
                      //     )
                      //   ],
                      // )
                      // // ? Telex....
                    ],
                  ),
                  //)
                ),
                builder: (context, value, child) => Transform.translate(
                    offset: Offset(0, height * (value)), child: child),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCustomDialog() {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        //barrierDismissible: false,
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Center(child: Text('Filter')),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        elevation: 4,
                        // color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: ClipRRect(
                          clipBehavior: Clip.hardEdge,
                          borderRadius: BorderRadius.circular(20.0),
                          child: ExpansionTile(
                            title: const Text('Doc Zone'),
                            // subtitle: const Text('Custom expansion arrow icon'),
                            trailing: Icon(
                              _customTileExpanded
                                  ? Icons.arrow_drop_down_circle
                                  : Icons.arrow_drop_down,
                            ),
                            children: <Widget>[
                              ListTile(
                                title: Text("Import"),
                                leading: Radio(
                                  value: 1,
                                  groupValue: val,
                                  onChanged: (value) {
                                    setState(() {
                                      val = value;
                                    });
                                  },
                                  activeColor: Colors.green,
                                ),
                              ),
                              ListTile(
                                title: Text("Export"),
                                leading: Radio(
                                  value: 2,
                                  groupValue: val,
                                  onChanged: (value) {
                                    setState(() {
                                      val = value;
                                    });
                                  },
                                  activeColor: Colors.green,
                                ),
                              ),
                            ],
                            onExpansionChanged: (bool expanded) {
                              setState(() => _customTileExpanded = expanded);
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 15),
                          child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 16.0),
                                  errorStyle: TextStyle(
                                      color: Colors.redAccent, fontSize: 16.0),
                                  hintText: 'type',

                                  // border: OutlineInputBorder(
                                  //     borderSide: BorderSide(
                                  //     ),
                                  //     borderRadius: BorderRadius.circular(20.0)
                                  // )
                                ),
                                isEmpty: _currentSelectedValue == '',
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _currentSelectedValue,
                                    isDense: true,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _currentSelectedValue = newValue;
                                        state.didChange(newValue);
                                      });
                                    },
                                    items: types.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 4,
                        // color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: ClipRRect(
                          clipBehavior: Clip.hardEdge,
                          borderRadius: BorderRadius.circular(20.0),
                          child: ExpansionTile(
                            title: const Text('Doc Location'),
                            // subtitle: const Text('Custom expansion arrow icon'),
                            trailing: Icon(
                              _customTileExpanded
                                  ? Icons.arrow_drop_down_circle
                                  : Icons.arrow_drop_down,
                            ),
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                width: 320,
                                padding: EdgeInsets.all(8.0),
                                child: TextField(
                                  //  autofocus: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Location',
                                  ),
                                ),
                              ),
                            ],
                            onExpansionChanged: (bool expanded) {
                              setState(() => _customTileExpanded = expanded);
                            },
                          ),
                        ),
                      ),
                      Card(
                        elevation: 4,
                        // color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(20.0),
                            child: ExpansionTile(
                              title: const Text('Doc Area'),
                              // subtitle: const Text('Custom expansion arrow icon'),
                              trailing: Icon(
                                _customTileExpanded
                                    ? Icons.arrow_drop_down_circle
                                    : Icons.arrow_drop_down,
                              ),
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  width: 320,
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Area',
                                    ),
                                  ),
                                ),
                              ],
                              onExpansionChanged: (bool expanded) {
                                setState(() => _customTileExpanded = expanded);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 4,
                        // color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(20.0),
                            child: ExpansionTile(
                              title: const Text('Doc Number'),
                              // subtitle: const Text('Custom expansion arrow icon'),
                              trailing: Icon(
                                _customTileExpanded
                                    ? Icons.arrow_drop_down_circle
                                    : Icons.arrow_drop_down,
                              ),
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  width: 320,
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Doc Number',
                                    ),
                                  ),
                                ),
                              ],
                              onExpansionChanged: (bool expanded) {
                                setState(() => _customTileExpanded = expanded);
                              },
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              child: const Text('Submit'),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SlotBook()));
                              }),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            child: const Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (BuildContext context) => SlotBook(
                              //     )));
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 400),
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
}

class LengthLimitingTextInputFormatter {}

class Constants {
  static const String FirstItem = 'English';
  static const String SecondItem = 'hindi';
  static const String ThirdItem = 'Arabic';
  static const String forthItem = 'Tamil';

  static const List<String> choices = <String>[
    FirstItem,
    SecondItem,
    ThirdItem,
    forthItem
  ];
}

void choiceAction(BuildContext context, String choice) {
  switch (choice) {
    case "0":
      context.read<LanguageChangeProvider>().changeLocale("en");
      // Navigator.of(context).push(
      //   MaterialPageRoute(builder: (context) => HomeScreen()),);
      break;
    case "1":
      context.read<LanguageChangeProvider>().changeLocale("hi");
      break;
    case "2":
      context.read<LanguageChangeProvider>().changeLocale("ar");
      break;
    case "3":
      context.read<LanguageChangeProvider>().changeLocale("ta");
  }
}


// Thank You

// Addresss and multiple contacts,information buttton in register page

// If you are registering as a solo user, please choose your own CUSTOMER CODE (example: ABC123). 
// Otherwise if you are part of an organization, please input your organization's CUSTOMER CODE (example: ROOSTER123)