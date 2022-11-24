import 'package:flutter/material.dart';
import 'package:rooster/generated/l10n.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _expand = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          color: Colors.grey[200],
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          child: AnimatedContainer(
            //width: 50,
            //height: _expand ? 300 : 130,
            duration: Duration(milliseconds: 200),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              // TODO :Dashboard options....
            });
          },
          onLongPress: () {
            setState(() {
              // TODO : Dashboard options....
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
                              "https://cdn-icons-png.flaticon.com/512/2329/2329087.png"),
                        ),
                        // SizedBox(
                        //   height: 09,
                        // ),
                        Text(
                          S.of(context).Dashboard,
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
