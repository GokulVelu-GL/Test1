import 'package:flutter/material.dart';
import 'package:rooster/generated/l10n.dart';

class IATAOneRecord extends StatefulWidget {
  IATAOneRecord({Key key}) : super(key: key);

  @override
  _IATAOneRecordState createState() => _IATAOneRecordState();
}

class _IATAOneRecordState extends State<IATAOneRecord> {
  bool _expand = false;

  listItem(IconData icon, String field) {
    return SizedBox(
      height: 50,
      child: TextButton(
        onPressed: () {
          switch (field) {
            case "One Waybill":
              print("One Waybill");
              break;
            case "One House":
              print("One House");
              break;
            case "One Manifest":
              print("One Manifest");
              break;
            case "One Data Model (JSON)":
              print("One Data Model (JSON)");
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
            height: _expand ? (150.0 + (4 * 50) + 10) : 150,
            duration: Duration(milliseconds: 300),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // ! One Waybill....
                    listItem(Icons.flight_takeoff, "One Waybill"),
                    // ! One House....
                    listItem(Icons.flight_takeoff, "One House"),
                    // ! One Manifest....
                    listItem(Icons.flight_takeoff, "One Manifest"),
                    // ! One Data Model (JSON)....
                    listItem(Icons.flight_takeoff, "One Data Model (JSON)"),
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
                    S.of(context).IATAOne,
                    //"IATA One Record",
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: Colors.black,
                      // fontSize: 20,
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
