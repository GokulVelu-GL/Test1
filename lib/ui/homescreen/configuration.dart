import 'package:flutter/material.dart';
import 'package:rooster/generated/l10n.dart';

class Configuration extends StatefulWidget {
  Configuration({Key key}) : super(key: key);

  @override
  _ConfigurationState createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  bool _expand = false;

  listItem(IconData icon, String field) {
    return SizedBox(
      //height: 50,
      child: TextButton(
        onPressed: () {
          // TODO : Configuration....
          switch (field) {
            case "Parameter":
              print("Parameter");
              break;
            case "Airport":
              print("Airport");
              break;
            case "Airlines":
              print("Airlines");
              break;
            case "Contact":
              print("Contact");
              break;
            case "Tools":
              print("Tools");
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
                style: TextStyle(
                    //fontSize: 10
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
            //width: 130,
            //height: _expand ? (130.0 + (5 * 50) + 10) : 130,
            duration: Duration(milliseconds: 300),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // ! Parameter....
                    // listItem(
                    //   Icons.trending_up,
                    //   S.of(context).Parameter,
                    //   //"Parameter"
                    // ),
                    // // ! Airport....
                    // listItem(
                    //   Icons.flight,
                    //   S.of(context).Airport,
                    //   // "Airport"
                    // ),
                    // // ! Airlines....
                    // listItem(
                    //   Icons.flight_takeoff,
                    //   S.of(context).Airport,
                    //   //"Airlines"
                    // ),
                    // // ! Contact....
                    // listItem(
                    //   Icons.contacts,
                    //   S.of(context).Contact,
                    //   // "Contact"
                    // ),
                    // // ! Tools....
                    // listItem(
                    //   Icons.build,
                    //   S.of(context).Tools,
                    //   // "Tools"
                    // ),
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
                            "assets/homescreen/configuration.png"
                            //  "https://cdn-icons-png.flaticon.com/512/989/989368.png"
                          ),
                        ),
                        // SizedBox(
                        //   height: 12,
                        // ),
                        Text(
                          S.of(context).Configuration,
                          //"Configuration",
                          textAlign: TextAlign.end,
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
