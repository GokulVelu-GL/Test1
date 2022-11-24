import 'package:flutter/material.dart';
import 'package:rooster/generated/l10n.dart';

class SocialMedia extends StatefulWidget {
  SocialMedia({Key key}) : super(key: key);

  @override
  _SocialMediaState createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  bool _expand = false;

  listItem(IconData icon, String field) {
    return SizedBox(
      height: 50,
      child: FlatButton(
        onPressed: () {
          switch (field) {
            case "Social Contact":
              print("Social Contact");
              break;
            case "Social Notification":
              print("Social Notification");
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
            //height: _expand ? (130.0 + (2 * 50) + 10) : 130,
            duration: Duration(milliseconds: 300),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // ! Social Contact....
                    // listItem(Icons.people_outline, S.of(context).SocialContacts
                    //     //"Social Contact"
                    //     ),
                    // // ! Social Notification....
                    // listItem(Icons.person, S.of(context).SocialNotifi
                    //     //"Social Notification"
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
                          image: NetworkImage(
                              "https://cdn-icons-png.flaticon.com/512/2728/2728217.png"),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Text(
                          S.of(context).SocialMedia,
                          //"Social Media",
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
