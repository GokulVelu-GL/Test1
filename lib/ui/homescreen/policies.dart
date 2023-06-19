import 'package:flutter/material.dart';
import 'package:rooster/generated/l10n.dart';

class Policies extends StatefulWidget {
  Policies({Key key}) : super(key: key);

  @override
  _PoliciesState createState() => _PoliciesState();
}

class _PoliciesState extends State<Policies> {
  bool _expand = false;

  listItem(IconData icon, String field) {
    return SizedBox(
      height: 50,
      child: TextButton(
        onPressed: () {
          // TODO : Configuration....
          switch (field) {
            case "Privacy Policy":
              print("Privacy Policy");
              break;
            case "Terms of Services":
              print("Terms of Services");
              break;
            case "Security":
              print("Security");
              break;
            case "Plans":
              print("Plans");
              break;
            case "Refund Policy":
              print("Refund Policy");
              break;
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Icon(
                icon,
                color: Colors.black,
              ),
              flex: 1,
            ),
            Expanded(
              child: Text(
                "$field",
                style: TextStyle(
                  color: Colors.black,
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
          color: Colors.grey[200],
          elevation: 5,
          child: AnimatedContainer(
            width: 150,
            height: _expand ? (150.0 + (5 * 50) + 10) : 150,
            duration: Duration(milliseconds: 300),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // ! Parameter....
                    listItem(Icons.lock_outline, "Privacy Policy"),
                    // ! Airport....
                    listItem(Icons.note_add, "Terms of Services"),
                    // ! Airlines....
                    listItem(Icons.security, "Security"),
                    // ! Contact....
                    listItem(Icons.attach_money, "Plans"),
                    // ! Tools....
                    listItem(Icons.monetization_on, "Refund Policy"),
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
            color: Colors.white,
            elevation: 5,
            child: Container(
              width: 150,
              height: 150,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    S.of(context).Policies,
                    //"Policies",
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: Colors.black,
                      //fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
