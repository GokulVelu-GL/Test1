import 'dart:async';
import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rooster/string.dart';
import 'package:rooster/ui/homescreen/main_homescreen.dart';
import 'package:rooster/ui/loginscreen/main_logincardscreen.dart';
import 'package:rooster/ui/loginscreen/new_signin_sigup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import '../../theme_changer.dart';
import '../payment_wallet/plan/planhome.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashScreenDelay = 4;
  ThemeChanger themeChanger;
  bool dataConn = true;

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  void _movetoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String colorString = prefs.getString('theme');
    print(colorString);
    print(prefs.getBool('isDark'));

    themeChanger.baseColorByString = colorString;
    themeChanger.setDarkTheme(prefs.getBool('isDark'));

    String token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      Future.delayed(Duration(seconds: splashScreenDelay), () {
        if (dataConn) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (BuildContext context) => LoginPage()));
        }
      });
    } else {
      Future.delayed(Duration(seconds: splashScreenDelay), () {
        if (dataConn) {
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
            StringData.loadRateClassCode();
            StringData.loadAccId();
            StringData.loadtCHGSCode();
            StringData.loadtContactType();
            StringData.loadShgCode();
            StringData.loadCurrency();
            StringData.loadExchangeRate();
            StringData.loadAirport();
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  PlanPage()),
          );
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (BuildContext context) => PlanPage()));
        }
      });
    }
    //}
  }

  @override
  void initState() {
    _movetoLogin();
    //checkConnection(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      themeChanger = Provider.of<ThemeChanger>(context);
    });
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: Container(
            width: width, height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 250, height: 250,
                  child: FlareActor(
                    "assets/anim/rooster.flr",
                    animation: 'loader',
                    artboard: "Loader",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      )),
    );
  }

  StreamSubscription<DataConnectionStatus> listener;
  var InternetStatus = "Unknown";
  var contentmessage = "Unknown";
  checkConnection(BuildContext context) async {
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        // case DataConnectionStatus.connected:
        //   setState(() {
        //     dataConn = !dataConn;
        //   });
        //   print("Data Connection" + '$dataConn');
        //   break;
        case DataConnectionStatus.disconnected:
          setState(() {
            dataConn = false;
          });
          print("Data Connection" + '$dataConn');
          InternetStatus = "You are disconnected to the Internet. ";
          contentmessage = "Please check your internet connection";
          _showDialog(InternetStatus, contentmessage, context);
          break;
        case DataConnectionStatus.connected:
          // TODO: Handle this case.
          break;
      }
    });
    return await DataConnectionChecker().connectionStatus;
  }

  void _showDialog(String title, String content, BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("Connection"),
              content: new Text(content),
              actions: <Widget>[
                 TextButton(
                    onPressed: () {
                      exit(0);
                      // Navigator.of(context).pop();
                    },
                    child: new Text("Close"))
              ]);
        });
  }

  Text appName() {
    return Text(
      "Rooster",
      style: TextStyle(
        color: Colors.blue[800],
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        letterSpacing: 5,
      ),
    );
  }
}
