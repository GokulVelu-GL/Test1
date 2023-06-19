import 'package:flutter/material.dart';
import 'package:rooster/generated/l10n.dart';

class UserManagement extends StatefulWidget {
  UserManagement({Key key}) : super(key: key);

  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  bool _expand = false;

  listItem(IconData icon, String field) {
    return SizedBox(
      // height: 50,
      child: TextButton(
        onPressed: () {
          switch (field) {
            case "Roles":
              print("Roles");
              break;
            case "Permission":
              print("Permission");
              break;
            case "Users":
              print("Users");
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
                    // color: Colors.black,
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
            //height: _expand ? (150.0 + (3 * 50) + 10) : 130,
            duration: Duration(milliseconds: 300),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // ! Roles....
                    // listItem(
                    //   Icons.folder_sharp,
                    //   S.of(context).Roles,
                    // ),
                    // // ! Permission....
                    // listItem(
                    //   Icons.person,
                    //   S.of(context).Permission,
                    // ),
                    // // ! Users....
                    // listItem(
                    //   Icons.people,
                    //   S.of(context).Users,
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
                              "assets/homescreen/user_management.png"
                                //    "https://cdn-icons-png.flaticon.com/512/1283/1283342.png"
                              ),
                            ),
                            // SizedBox(
                            //   height: 05,
                            // ),
                            Text(
                              S.of(context).UserManagement,
                              //"User Management",
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                //color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )))),
          ),
        ),
      ],
    );
  }
}
