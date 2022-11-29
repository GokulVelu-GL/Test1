import 'package:flutter/material.dart';
import 'package:rooster/generated/l10n.dart';

class Telex extends StatefulWidget {
  Telex({Key key}) : super(key: key);

  @override
  _TelexState createState() => _TelexState();
}

class _TelexState extends State<Telex> {
  bool _expand = false;

  listItem(IconData icon, String field) {
    return SizedBox(
      height: 50,
      child: FlatButton(
        onPressed: () {
          switch (field) {
            case "Send Telex":
              print("Send Telex");
              break;
            case "FFM Parser":
              print("FFM Parser");
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
            // height: _expand ? (130.0 + (2 * 50) + 10) : 130,
            duration: Duration(milliseconds: 300),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // ! Social Contact....
                    // listItem(
                    //   Icons.send,
                    //   S.of(context).sendTelax,
                    //   //"Send Telex"
                    // ),
                    // // ! FFM Parser....
                    // listItem(Icons.short_text, S.of(context).FFMparser
                    //     //"FFM Parser"
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
                           "assets/homescreen/telax.png"
                          //  "https://cdn1.iconfinder.com/data/icons/electronics-and-devices-1-2/64/45-256.png"
                          ),
                            //"https://st4.depositphotos.com/16138592/29131/v/600/depositphotos_291311932-stock-illustration-flat-laser-printer-vector-design.jpg"),
                        ),
                        SizedBox(
                          height: 05,
                        ),
                        Text(
                          S.of(context).Telex,
                          //"Telex",
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
