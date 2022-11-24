import 'package:flutter/material.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/screenroute.dart';
import 'package:rooster/ui/hawb/main_hawb.dart';
//import 'package:rooster/screenroute.dart';

class HAWB extends StatefulWidget {
  HAWB({Key key}) : super(key: key);

  @override
  _HAWBState createState() => _HAWBState();
}

class _HAWBState extends State<HAWB> {
  var _expand = false;

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
              Navigator.push(context, HomeScreenRoute(MyEawb()));
            });
          },
          onLongPress: () {
            setState(() {
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
                          image: NetworkImage(
                           "https://cdn.iconscout.com/icon/free/png-64/e-way-bill-1817367-1538235.png"
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
