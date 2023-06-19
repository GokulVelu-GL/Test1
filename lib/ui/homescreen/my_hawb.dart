import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/screenroute.dart';
import 'package:rooster/ui/hawb/main_hawb.dart';
import 'package:rooster/ui/hawb/offline_main_hawb/model_class.dart';

import '../hawb/offline_main_hawb/show_data_screen.dart';
//import 'package:rooster/screenroute.dart';

class HAWB extends StatefulWidget {
  HAWB({Key key}) : super(key: key);

  @override
  _HAWBState createState() => _HAWBState();
}

class _HAWBState extends State<HAWB> {
  var _expand = false;

  StreamSubscription internetconnection;
  bool isoffline = false;
  @override
  void initState() {
    super.initState();
    internetconnection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if(result == ConnectivityResult.none){
        //there is no any connection
        setState(() {
          isoffline = true;
        });
      }else if(result == ConnectivityResult.mobile){
        //connection is mobile data network
        setState(() {
          isoffline = false;
        });
      }else if(result == ConnectivityResult.wifi){
        //connection is from wifi
        setState(() {
          isoffline = false;
        });
      }
    }); // using this listiner, you can get the medium of connection as well.

    print("create album");
    // print(localname);
  }
  @override
  dispose() {
    super.dispose();
    internetconnection.cancel();
    //cancel internent connection subscription after you are done
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          color: Theme.of(context).backgroundColor,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          child: AnimatedContainer(
            //width: 130,
            //height: _expand ? 300 : 130,
            duration: Duration(milliseconds: 200),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              // TODO: HAWB options....
              if(isoffline) {
                Fluttertoast.showToast(
                    msg: "Offline",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    textColor: Colors.white,
                    backgroundColor: Colors.red,
                    fontSize: 16.0
                );
                // Hive.openBox('AwbList');
                // Hive.box('AwbList').add(
                //     AwbListOffline(
                //       airline: "hello",
                //       pieces: "1",
                //       weight: "1",
                //     )
                // );
                Navigator.push(context, HomeScreenRoute(ShowDataScreen()));
              }
              else if(isoffline==false){
                Navigator.push(context, HomeScreenRoute(MyEawb()));
              }

            });
          },
          onLongPress: () {
            setState(() {
              Fluttertoast.showToast(
                  msg: "Online",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  backgroundColor: Colors.green,
                  fontSize: 16.0
              );
              // TODO: HAWB options....
              Navigator.push(context, HomeScreenRoute(MyEawb()));
            });
          },
          child: Card(
            color: Theme.of(context).backgroundColor,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            child: Container(
              width: 90,
              height: 90,
              child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Image(
                          width: 39.0,
                          color: Theme.of(context).accentColor,
                          image: AssetImage(
                            "assets/homescreen/hawb.png"
                        //   "https://cdn.iconscout.com/icon/free/png-64/e-way-bill-1817367-1538235.png"
                          ),
                            //  "https://cdn-icons-png.flaticon.com/512/4301/4301588.png"),
                        ),
                        SizedBox(
                          height: 05,
                        ),
                        Text(
                          S.of(context).AWB,
                          //"AWB",
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            //color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
