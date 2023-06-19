import 'package:flutter/material.dart';
import 'package:rooster/generated/l10n.dart';

class IATAEDI extends StatefulWidget {
  IATAEDI({Key key}) : super(key: key);

  @override
  _IATAEDIState createState() => _IATAEDIState();
}

class _IATAEDIState extends State<IATAEDI> {
  bool _expand = false;

  listItem(IconData icon, String field) {
    return SizedBox(
      height: 50,
      child: TextButton(
        onPressed: () {
          switch (field) {
            case "FWB":
              print("FWB");
              break;
            case "FHL":
              print("FHL");
              break;
            case "FFM":
              print("FFM");
              break;
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Icon(
                icon,
                color: Theme.of(context).accentColor,
              ),
              flex: 1,
            ),
            Expanded(
              child: Text(
                "$field",
                style: TextStyle(fontSize: 10
                    //color: Colors.black,
                    ),
              ),
              flex: 2,
            ),
          ],
        ),
      ),
    );
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
            // width: 130,
            // height: _expand ? (130.0 + (3 * 50) + 10) : 130,
            duration: Duration(milliseconds: 300),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // ! FWB....
                    // listItem(Icons.flight_takeoff, S.of(context).FWB
                    //     //"FWB"
                    //     ),
                    // // ! FHL....
                    // listItem(Icons.flight_takeoff, S.of(context).FHL
                    //     //"FHL"
                    //     ),
                    // // ! FFM....
                    // listItem(Icons.flight_takeoff, S.of(context).FFM
                    //     //"FFM"
                    //     ),
                  ],
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _expand = !_expand;
            });
          },
          onLongPress: () {
            setState(() {
              _expand = !_expand;
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
                            "assets/homescreen/iataedi.png"
                          //    "http://monstertechblog.com/wp-content/2.png"
                          //  "https://img.icons8.com/wired/344/chat.png"
                          ),
                        ),
                        SizedBox(
                          height: 05,
                        ),
                        Text(
                          S.of(context).IATAEDI,
                          //"IATA EDI",
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
