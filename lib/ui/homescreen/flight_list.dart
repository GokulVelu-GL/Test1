import 'dart:convert';

// import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rooster/model/emanifest_model.dart';
import 'package:rooster/ui/drodowns/airline_code.dart';
import 'package:rooster/ui/homescreen/emanifest.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tutorial_coach_mark/animated_focus_light.dart';
// import 'package:tutorial_coach_mark/content_target.dart';
// import 'package:tutorial_coach_mark/target_focus.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../formatter.dart';
import '../../generated/l10n.dart';
import '../../screenroute.dart';
import '../../string.dart';
import 'package:http/http.dart' as http;

import '../drodowns/airport_code.dart';

class FlightBook extends StatefulWidget {
  const FlightBook({Key key}) : super(key: key);

  @override
  State<FlightBook> createState() => _FlightBookState();
}

class _FlightBookState extends State<FlightBook> {
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
            // height: _expand ? 300 : 130,
            duration: Duration(milliseconds: 200),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => FlightList()));
          },
          onLongPress: () {
            setState(() {
              // TODO : EManifestFFM options....
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
                            "assets/homescreen/flight.png"
                            //"https://img.icons8.com/external-xnimrodx-lineal-xnimrodx/2x/external-flight-calendar-xnimrodx-lineal-xnimrodx.png",
                          ),
                          //   "https://cdn2.iconfinder.com/data/icons/delivery-and-shipping-2/64/package_delivery_manifest_document-512.png"),
                        ),
                        SizedBox(
                          height: 05,
                        ),
                        Text(
                          "Flights(Bookings)",
                          //"eManifest (FFM)",
                          textAlign: TextAlign.center,
                          //   textDirection: TextDirection.ltr,
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

void refreshToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var response = await http.get(Uri.parse(StringData.refreshTokenAPI),
      headers: {'x-access-tokens': prefs.getString('token')});
  var result = json.decode(response.body);
  if (result['result'] == 'verified') prefs.setString('token', result['token']);
  print(result);
}

Future<dynamic> getflightlist() async {
  var result;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // var response = await http.get(StringData.flightlistAPI,
  //     headers: {'x-access-tokens': prefs.getString('token')});
  // result = json.decode(response.body);

  final url = Uri.parse(StringData.flightlistAPI);
  final request = http.Request("GET", url);
  request.headers.addAll(<String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'x-access-tokens': prefs.getString('token')
  });
  request.body = jsonEncode({
    // "FlightList_id": id, //40,
    // "All_Segment_id_info": "True"
    // "FFM_PointOfLoading_AirportCode": flightLoading,
    // "FFM_PointOfUnLoading_AirportCode": flightUnloading
  });
  result = await request.send();

  final respStr = await result.stream.bytesToString();
  result = jsonDecode(respStr);

  if (result['message'] == 'token expired') {
    refreshToken();
    getflightlist();
  } else {
    //getAWBlist();
    print(prefs.getString('token'));
  }
  print('$result');
  print("flight List Details " + '${result["flight"]}');
  return result["flight"];
}

Future<dynamic> deleteflightlist(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.parse(StringData.flightlistAPI);
  final request = http.Request("DELETE", url);
  request.headers.addAll(<String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'x-access-tokens': prefs.getString('token')
  });
  request.body = jsonEncode({"id": id});
  final response = await request.send();
  print(id);
  print(response);
  // ignore: unrelated_type_equality_checks
  if (response == 'token expired') {
    refreshToken();
  } else {
    // response = json.decode(request.body);
    print(prefs.getString('token'));
  }
  if (response.statusCode == 202 || response.statusCode == 200) {
    print("Sucess");
    // Navigator.push(context, HomeScreenRoute(MyEawb()));
  }
  return true;
}

class FlightList extends StatefulWidget {
  @override
  _FlightListState createState() => _FlightListState();
}

class _FlightListState extends State<FlightList> {
  Animation _fabAnimation;
  void initTargets() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
            title: Text(
              "Flight List",
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Theme.of(context).accentColor,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddFlightlist(),
                    fullscreenDialog: true,
                  ));
            },
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.miniEndFloat,
          // floatingActionButton: Transform.scale(
          //   scale: _fabAnimation.value,
          //   child: Builder(
          //     builder: (context) => FloatingActionButton(
          //    //key: _fabTarget,
          //       backgroundColor: Theme.of(context).accentColor,
          //       onPressed: () async {
          //         Map<String, String> newMasterAWB = await Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => AddFlightlist(),
          //               fullscreenDialog: true,
          //             ));
          //         if (newMasterAWB != null) {
          //           setState(() {
          //            // masterAWB.add(newMasterAWB);
          //           });
          //         }
          //       },
          //       child: Icon(Icons.add),
          //     ),
          //   ),
          // ),
          //  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: Container(
            //height: MediaQuery.of(context).size.height - 185.0,
            child: Center(
              child: FutureBuilder<dynamic>(
                future: getflightlist(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //EasyLoading.show();
                    print("Snapshot Data ${snapshot.data}");
                    //getawblist=snapshot.data;
                    return Getflightlist(getflightlist: snapshot.data);
                  } else if (snapshot.hasError) {
                    return Text(S.of(context).DataNotFound
                      // "Data Not Found"
                    );
                  }

                  // By default, show a loading spinner
                  return CircularProgressIndicator();
                  //return EasyLoading.show();
                },
              ),
            ),
          )),
    );
  }
}

class Getflightlist extends StatefulWidget {
  var getflightlist;
  Getflightlist({Key key, this.getflightlist}) : super(key: key);

//   @override
//   State<Getflightlist> createState() => _GetflightlistState();
// }
  @override
  _MyAWBState createState() => _MyAWBState();
}

class _MyAWBState extends State<Getflightlist> {
  TextEditingController _emailIdsController = new TextEditingController();

  void dispose() {
    _emailIdsController.dispose();
    super.dispose();
  }

  Future<String> _showTextInputDialog(
      ManifestModel model, BuildContext context, var flightSegmentList) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter Email'),
            content: TextField(
              controller: _emailIdsController,
              decoration: const InputDecoration(hintText: "Enter email"),
            ),
            actions: <Widget>[
              ElevatedButton(
                  child: const Text("Close"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context, _emailIdsController.text);
                    print(_emailIdsController.text);
                    if (_emailIdsController.text != null)
                      model.printeManifest(
                          model, _emailIdsController.text, flightSegmentList);
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return widget.getflightlist.length == 0
        ? Text(S.of(context).DataNotFound
      // "Data Not Found"
    )
        : Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: 0, bottom: 0),
        children: new List<Widget>.generate(widget.getflightlist.length,
                (index) {
              return Dismissible(
                  key: ValueKey(widget.getflightlist[index]),
                  confirmDismiss: (DismissDirection direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              S.of(context).DeleteConfirmation,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                              //"Delete Confirmation"
                            ),
                            content: Text(
                              S.of(context).Areyousureyouwanttodeletethisitem,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                              //"Are you sure you want to delete this item?"
                            ),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                    deleteflightlist(
                                        '${widget.getflightlist[index]["id"]}');
                                  },
                                  child: Text(
                                    // BuildContext context,
                                    S.of(context).Delete,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                    //"Delete"
                                  )),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text(
                                  S.of(context).Cancel,
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                  // "Cancel"
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      List<String> flightList = [];
                      flightList.insert(
                          0, widget.getflightlist[index]["airport_code1"]);
                      flightList.insert(
                          1, widget.getflightlist[index]["airport_code2"]);
                      if (widget.getflightlist[index]["airport_code3"]
                          .toString()
                          .isNotEmpty)
                        flightList.insert(
                            2, widget.getflightlist[index]["airport_code3"]);
                      if (widget.getflightlist[index]["airport_code4"]
                          .toString()
                          .isNotEmpty)
                        flightList.insert(
                            3, widget.getflightlist[index]["airport_code4"]);
                      if (widget.getflightlist[index]["airport_code5"]
                          .toString()
                          .isNotEmpty)
                        flightList.insert(
                            4, widget.getflightlist[index]["airport_code5"]);
                      if (widget.getflightlist[index]["airport_code6"]
                          .toString()
                          .isNotEmpty)
                        flightList.insert(
                            5, widget.getflightlist[index]["airport_code6"]);
                      if (widget.getflightlist[index]["airport_code7"]
                          .toString()
                          .isNotEmpty)
                        flightList.insert(
                            6, widget.getflightlist[index]["airport_code7"]);
                      if (widget.getflightlist[index]["airport_code8"]
                          .toString()
                          .isNotEmpty)
                        flightList.insert(
                            7, widget.getflightlist[index]["airport_code8"]);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditFlightList(
                              '${widget.getflightlist[index]["id"]}',
                              '${widget.getflightlist[index]["aircraftreg"]}',
                              '${widget.getflightlist[index]["airportcodeload"]}',
                              '${widget.getflightlist[index]["airportcodeunload"]}',
                              '${widget.getflightlist[index]["carriercode"]}',
                              '${widget.getflightlist[index]["departuredate"]}',
                              '${widget.getflightlist[index]["flightnumber"]}',
                              flightList,
                            ),
                          ));
                      return false;
                    }
                  },
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {}
                  },
                  background: Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                              S.of(context).Delete
                              //'Delete'
                              ,
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        //    textDirection: TextDirection.rtl,
                        children: [
                          Icon(Icons.edit, color: Colors.white),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            S.of(context).UpdateDetails,
                            //'Update Details',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color:
                          Theme.of(context).accentColor.withOpacity(0.5),
                          width: 1),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0)),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "CarrierCode",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Theme.of(context).accentColor),
                                      ),
                                      Text(
                                        '${widget.getflightlist[index]["carriercode"]}',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  )),
                              Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "FlightNumber",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Theme.of(context).accentColor),
                                      ),
                                      Text(
                                        '${widget.getflightlist[index]["flightnumber"]}',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  )),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "DepartureDate",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Theme.of(context).accentColor),
                                      ),
                                      Text(
                                        widget.getflightlist[index]
                                        ["departuredate"]
                                            .toString()
                                            .replaceAll(" 00:00:00 GMT", ''),
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                          Container(
                            height: 40,
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              //color: Colors.white,
                              // boxShadow: [
                              //   new BoxShadow(
                              //     color: Colors.black,
                              //     blurRadius: 20.0,
                              //   ),
                              // ],
                                color: Theme.of(context).backgroundColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24))
                              // border: Border.all(
                              //   color: Colors.black,
                              // ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${widget.getflightlist[index]["airportcodeload"]}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        //color: Colors.indigo,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      //child: Icon(Icons.flight_takeoff,color:Colors.amber),
                                      decoration: BoxDecoration(
                                          color: Colors.indigo.shade50,
                                          borderRadius:
                                          BorderRadius.circular(20)),

                                      child: SizedBox(
                                        height: 8,
                                        width: 8,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              color: Colors.indigo.shade400,
                                              borderRadius:
                                              BorderRadius.circular(5)),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Stack(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 21,
                                              child: LayoutBuilder(
                                                builder:
                                                    (context, constraints) {
                                                  return Flex(
                                                    children: List.generate(
                                                        (constraints.constrainWidth() /
                                                            6)
                                                            .floor(),
                                                            (index) => SizedBox(
                                                          height: 1,
                                                          width: 3,
                                                          child:
                                                          DecoratedBox(
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black
                                                              //.shade300
                                                            ),
                                                          ),
                                                        )),
                                                    direction:
                                                    Axis.horizontal,
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                  );
                                                },
                                              ),
                                            ),
                                            Center(
                                                child: Transform.rotate(
                                                  angle: 1.5,
                                                  child: Icon(
                                                    Icons.local_airport,
                                                    color: Colors.indigo.shade300,
                                                    size: 24,
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      //child: Icon(Icons.flight_land,color:Colors.amber),
                                      decoration: BoxDecoration(
                                          color: Colors.pink.shade50,
                                          borderRadius:
                                          BorderRadius.circular(20)),
                                      child: SizedBox(
                                        height: 8,
                                        width: 8,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              color: Colors.lightBlue,
                                              borderRadius:
                                              BorderRadius.circular(5)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${widget.getflightlist[index]["airportcodeunload"]}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        //color: Colors.indigo,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "AircraftReg",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Theme.of(context).accentColor),
                                      ),
                                      Text(
                                        '${widget.getflightlist[index]["aircraftreg"]}',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  )),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "NilcargoInd",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Theme.of(context).accentColor),
                                      ),
                                      Text(
                                        '${widget.getflightlist[index]["nilcargoind"]}',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: PopupMenuButton(
                                      child: Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .accentColor
                                                .withOpacity(0.3),
                                            // color: Colors.amber.shade50,
                                            borderRadius:
                                            BorderRadius.circular(20)),
                                        child: Icon(
                                          Icons.flight_takeoff,
                                          color:
                                          Theme.of(context).accentColor,
                                          // color: Colors.amber
                                        ),
                                      ),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: Consumer<ManifestModel>(
                                            builder:
                                                (BuildContext context,
                                                model, Widget child) {
                                              return TextButton(
                                                  onPressed: () {
                                                    model.manifestFlight =
                                                    '${widget.getflightlist[index]["flightnumber"]}';
                                                    model.departureDate =
                                                        DateTime.tryParse(
                                                            widget.getflightlist[
                                                            index]
                                                            [
                                                            "departuredate"]);
                                                    var flightAirportList =
                                                    [];

                                                    flightAirportList.insert(
                                                        0,
                                                        widget.getflightlist[
                                                        index][
                                                        "airport_code2"]);
                                                    if (widget
                                                        .getflightlist[
                                                    index][
                                                    "airport_code3"]
                                                        .toString()
                                                        .isNotEmpty)
                                                      flightAirportList.insert(
                                                          1,
                                                          widget.getflightlist[
                                                          index][
                                                          "airport_code3"]);
                                                    if (widget
                                                        .getflightlist[
                                                    index][
                                                    "airport_code4"]
                                                        .toString()
                                                        .isNotEmpty)
                                                      flightAirportList.insert(
                                                          2,
                                                          widget.getflightlist[
                                                          index][
                                                          "airport_code4"]);
                                                    if (widget
                                                        .getflightlist[
                                                    index][
                                                    "airport_code5"]
                                                        .toString()
                                                        .isNotEmpty)
                                                      flightAirportList.insert(
                                                          3,
                                                          widget.getflightlist[
                                                          index][
                                                          "airport_code5"]);
                                                    if (widget
                                                        .getflightlist[
                                                    index][
                                                    "airport_code6"]
                                                        .toString()
                                                        .isNotEmpty)
                                                      flightAirportList.insert(
                                                          4,
                                                          widget.getflightlist[
                                                          index][
                                                          "airport_code6"]);
                                                    if (widget
                                                        .getflightlist[
                                                    index][
                                                    "airport_code7"]
                                                        .toString()
                                                        .isNotEmpty)
                                                      flightAirportList.insert(
                                                          5,
                                                          widget.getflightlist[
                                                          index][
                                                          "airport_code7"]);
                                                    if (widget
                                                        .getflightlist[
                                                    index][
                                                    "airport_code8"]
                                                        .toString()
                                                        .isNotEmpty)
                                                      flightAirportList.insert(
                                                          6,
                                                          widget.getflightlist[
                                                          index][
                                                          "airport_code8"]);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                              ManifestPage(
                                                                flightId: int
                                                                    .tryParse(
                                                                    '${widget.getflightlist[index]["id"]}'),
                                                                flightLoading:
                                                                '${widget.getflightlist[index]["airportcodeload"]}',
                                                                flightOnLoading:
                                                                '${widget.getflightlist[index]["airportcodeunload"]}',
                                                                flightNo:
                                                                '${widget.getflightlist[index]["carriercode"]}' +
                                                                    '${widget.getflightlist[index]["flightnumber"]}',
                                                                date:
                                                                '${widget.getflightlist[index]["departuredate"]}',
                                                                flightList:
                                                                flightAirportList,
                                                              ),
                                                        ));
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "View Manifest",
                                                        style: TextStyle(
                                                          color: Theme.of(
                                                              context)
                                                              .accentColor,
                                                        ),
                                                        //"AWB Details"
                                                      ),
                                                      // Divider(
                                                      //   color: Theme.of(context).accentColor,thickness: 2,
                                                      // ),
                                                    ],
                                                  ));
                                            },
                                          ),
                                          value: 2,
                                        ),
                                        // Divider(
                                        //   color: Colors.black,
                                        // ),
                                        //PopupMenuDivider(),
                                        PopupMenuItem(
                                          child: Consumer<ManifestModel>(
                                              builder:
                                                  (BuildContext context,
                                                  model,
                                                  Widget child) {
                                                return TextButton(
                                                    onPressed: () {
                                                      model.carrieerCode =
                                                      '${widget.getflightlist[index]["carriercode"]}';
                                                      model.departureDate =
                                                          DateTime.tryParse(
                                                              widget.getflightlist[
                                                              index][
                                                              "departuredate"]);

                                                      var flightAirportList =
                                                      [];

                                                      flightAirportList.insert(
                                                          0,
                                                          widget.getflightlist[
                                                          index][
                                                          "airport_code2"]);
                                                      if (widget
                                                          .getflightlist[
                                                      index][
                                                      "airport_code3"]
                                                          .toString()
                                                          .isNotEmpty)
                                                        flightAirportList.insert(
                                                            1,
                                                            widget.getflightlist[
                                                            index][
                                                            "airport_code3"]);
                                                      if (widget
                                                          .getflightlist[
                                                      index][
                                                      "airport_code4"]
                                                          .toString()
                                                          .isNotEmpty)
                                                        flightAirportList.insert(
                                                            2,
                                                            widget.getflightlist[
                                                            index][
                                                            "airport_code4"]);
                                                      if (widget
                                                          .getflightlist[
                                                      index][
                                                      "airport_code5"]
                                                          .toString()
                                                          .isNotEmpty)
                                                        flightAirportList.insert(
                                                            3,
                                                            widget.getflightlist[
                                                            index][
                                                            "airport_code5"]);
                                                      if (widget
                                                          .getflightlist[
                                                      index][
                                                      "airport_code6"]
                                                          .toString()
                                                          .isNotEmpty)
                                                        flightAirportList.insert(
                                                            4,
                                                            widget.getflightlist[
                                                            index][
                                                            "airport_code6"]);
                                                      if (widget
                                                          .getflightlist[
                                                      index][
                                                      "airport_code7"]
                                                          .toString()
                                                          .isNotEmpty)
                                                        flightAirportList.insert(
                                                            5,
                                                            widget.getflightlist[
                                                            index][
                                                            "airport_code7"]);
                                                      if (widget
                                                          .getflightlist[
                                                      index][
                                                      "airport_code8"]
                                                          .toString()
                                                          .isNotEmpty)
                                                        flightAirportList.insert(
                                                            6,
                                                            widget.getflightlist[
                                                            index][
                                                            "airport_code8"]);
                                                      print(
                                                          '${model.departureDate}');
                                                      print(
                                                          '${widget.getflightlist[index]["id"]}');
                                                      model.manifestFlight =
                                                      '${widget.getflightlist[index]["flightnumber"]}';

                                                      _showTextInputDialog(
                                                          model,
                                                          context,
                                                          flightAirportList);
                                                    },
                                                    child: Text(
                                                      "Generate PDF",
                                                      style: TextStyle(
                                                        color:
                                                        Theme.of(context)
                                                            .accentColor,
                                                      ),
                                                      // "House Details"
                                                    ));
                                              }),
                                          value: 1,
                                        ),
                                      ],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                      ))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ));
            }),
      ),
    );
  }
}

class AddFlightlist extends StatefulWidget {
  @override
  _AddFlightlistState createState() => _AddFlightlistState();
}

class _AddFlightlistState extends State<AddFlightlist> {
  final _awbForm = GlobalKey<FormState>();
  String aircraftreg;
  String origin;
  String destination;
  String carriercode;
  String departuredate;
  String flightnumber;
  String nilcargoind = "";
  bool enable = false;
  TextEditingController dateController = new TextEditingController(
    text: DateFormat.yMMMMd().format(DateTime.now()),
  );
  TextEditingController originController;
  TextEditingController airlineController;
  static TextEditingController destinationController;
  static List<String> routingList = [null];

  @override
  void initState() {
    super.initState();
    originController = TextEditingController();
    airlineController = TextEditingController();
    destinationController = TextEditingController();
  }

  @override
  void dispose() {
    originController.dispose();
    airlineController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Add Flight "

            //  "Add Master Air Waybill"
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 8.0,
                  ),
                  Form(
                    key: _awbForm,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Carriercode(),
                                  flex: 3,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: FlightNumber(),
                                  flex: 7,
                                ),
                              ],
                            ),
                          ),

                          // Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: Row(
                          //       children: [
                          //         Expanded(
                          //           flex: 4,
                          //           child:
                          Text(
                            'Add Routing',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                          //),
                          //Expanded(child: departureDate(), flex: 4),
                          ..._addRoutFlight().reversed,
                          SizedBox(
                            height: 4,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: originTF(),
                                  flex: 4,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: destinationTF(),
                                  flex: 4,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Aircraftreg(),
                                  flex: 4,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(child: departureDate(), flex: 4),
                              ],
                            ),
                          ),
                          //   ],
                          // )),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor)),
                            onPressed: () {
                              if (_awbForm.currentState.validate()) {
                                insertflightList();
                              }
                            },
                            child: Text(
                              S.of(context).Submit,
                              //  "Submit"
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  /// get firends text-fields
  List<Widget> _addRoutFlight() {
    List<Widget> friendsTextFields = [];
    //if (routingList.length < 9) {
    for (int i = 0; i < routingList.length; i++) {
      friendsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: AddRouteingAirport(i, routingList)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButton(i == routingList.length - 1, i),
          ],
        ),
      ));
    }
    return friendsTextFields;
    // } else {
    //   EasyLoading.showToast("Routing airport should be less than 9");
    //   EasyLoading.dismiss(animation: true);
    // }
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          routingList.insert(0, null);
        } else
          routingList.removeAt(index);
        setState(() {
          //enable = true;
          print(routingList);
          origin = originController.text = routingList.last;
          if (routingList.length >= 2)
            destination = destinationController.text = routingList[2];
        });
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<dynamic> insertflightList() async {
    var result;

    if (origin == destination) {
      Fluttertoast.showToast(
          msg: 'Origin and Destination cant be same',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white
      );
      // ignore: deprecated_member_use
      // Scaffold.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("Origin and Destination can't be same"),
      //     duration: Duration(seconds: 1),
      //   ),
      // );
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(StringData.flightlistAPI),
        headers: <String, String>{
          'x-access-tokens': prefs.getString('token'),
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "airport_code1": routingList[0].isEmpty ? "" : routingList[0],
          "airport_code2": routingList[1].isEmpty ? "" : routingList[1],
          if (routingList.length > 2)
            "airport_code3": routingList[2].isEmpty ? "" : routingList[2],
          if (routingList.length > 3)
            "airport_code4": routingList[3].isEmpty ? "" : routingList[3],
          if (routingList.length > 4)
            "airport_code5": routingList[4].isEmpty ? "" : routingList[4],
          if (routingList.length > 5)
            "airport_code6": routingList[5].isEmpty ? "" : routingList[5],
          if (routingList.length > 6)
            "airport_code7": routingList[6].isEmpty ? "" : routingList[6],
          if (routingList.length > 7)
            "airport_code8": routingList[7].isEmpty ? "" : routingList[7],
          "aircraftreg": aircraftreg,
          "airportcodeload": origin,
          "airportcodeunload": destinationController.text,
          "carriercode": carriercode,
          "departuredate": departuredate,
          "flightnumber": flightnumber,
          "nilcargoind": nilcargoind
          // "segment10": "",
          // "segment11": "",
          // "segment12": "",
          // "segment13": "",
          // "segment14": "",
          // "segment15": "",
          // "segment16": "",
          // "segment2": "",
          // "segment3": "",
          // "segment4": "",
          // "segment5": "",
          // "segment6": "",
          // "segment7": "",
          // "segment8": "",
          // "segment9": ""
        }));
    result = json.decode(response.body);
    if (result['message'] == 'token expired') {
      refreshToken();
      insertflightList();
    } else {
      result = json.decode(response.body);
      print(prefs.getString('token'));
      print(result);
      print("@@@@@@@@@@@@@@@@@");
      if (response.statusCode == 200) {
        // insertAWB();
        Fluttertoast.showToast(
            msg: 'Flight list added success',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white
        );
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text("Flight list added success"),
        // ));
        // _showMessage("Flight list added success", Colors.green, Colors.white);
        Navigator.push(context, HomeScreenRoute(FlightList()));
        // Navigator.of(context).push(MyEawb());
        print("Data inserted");
      } else {
        Fluttertoast.showToast(
            msg: 'Flight list added failed',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white
        );
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text("Flight list added failed"),
        // ));
        // _showMessage("Flight list added faild", Colors.red, Colors.white);
        print("Data insertion failed");
      }
    }
    return result;
  }

  // void _showMessage(String message, Color bgcolor, txtcolor) {
  //   if (!mounted) return;
  //   showFlash(
  //       context: context,
  //       duration: Duration(seconds: 3),
  //       builder: (_, controller) {
  //         return Flash(
  //           borderRadius: BorderRadius.circular(20),
  //           backgroundColor: bgcolor,
  //           controller: controller,
  //           position: FlashPosition.top,
  //           behavior: FlashBehavior.fixed,
  //           child: FlashBar(
  //             icon: Icon(
  //               Icons.flight_takeoff_outlined,
  //               size: 36.0,
  //               color: txtcolor,
  //             ),
  //             content: Text(
  //               message,
  //               textAlign: TextAlign.center,
  //               style: TextStyle(fontSize: 20, color: txtcolor),
  //             ),
  //           ),
  //         );
  //       });
  // }

  Aircraftreg() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      inputFormatters: [AllCapitalCase()],
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          //border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          border: OutlineInputBorder(
              gapPadding: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText: "Aircraftreg",
          labelStyle: TextStyle(color: Theme.of(context).accentColor)
        //'Pieces',
      ),
      validator: (value) {
        if (value.isEmpty || value == null) {
          return "Please Enter the aircraftreg";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          aircraftreg = value;
        });
      },
    );
  }

  Carriercode() {
    final focus = FocusNode();
    return TypeAheadFormField<AirlineCode>(
        suggestionsCallback: AirlineCodeApi.getAirlineCode,
        itemBuilder: (context, AirlineCode suggestion) {
          final code = suggestion;
          return ListTile(
            title: Text(code.airlineCode),
            subtitle: Text(code.airlineName),
          );
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'Select a Airline';
          }
          return null;
        },
        textFieldConfiguration: TextFieldConfiguration(
          //maxLength: 3,
          controller: this.airlineController,
          inputFormatters: [AllCapitalCase()],
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              border: OutlineInputBorder(
                  gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText: S.of(context).Airline,
              labelStyle: TextStyle(color: Theme.of(context).accentColor)
            //'Airline',
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onSuggestionSelected: (AirlineCode suggestion) {
          this.airlineController.text = suggestion.airlineCode;
          carriercode = suggestion.airlineCode;
          print(carriercode);
        });
  }

  FlightNumber() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      // keyboardType: TextInputType.number,
      inputFormatters: [AllCapitalCase()],
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          //border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          border: OutlineInputBorder(
              gapPadding: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText: "FlightNumber",
          // labelText: S.of(context).Pieces,
          labelStyle: TextStyle(color: Theme.of(context).accentColor)
        //'Pieces',
      ),
      validator: (value) {
        if (value.isEmpty || value == null) {
          return "Please Enter the flightNumber";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          flightnumber = value;
        });
      },
    );
  }

  departureDate() {
    departuredate = dateController.text;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      width: 320,
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: dateController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: new BorderSide(
                  color: Theme.of(context).accentColor,
                  // color: Colors.deepPurple,
                  width: 1),
              //gapPadding: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).accentColor,
              //  color: Colors.deepPurple
            ),
          ),
          labelText: "Date ",
          labelStyle: TextStyle(color: Theme.of(context).accentColor),
          hintText: "Enter the Date",
        ),
        onTap: () async {
          DateTime date = DateTime(1900);
          FocusScope.of(context).requestFocus(new FocusNode());
          date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2021),
              builder: (context, child) => Theme(
                data: ThemeData().copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Theme.of(context)
                          .accentColor, // header background color
                      onPrimary: Colors.black, // header text color
                      onSurface: Colors.black, // body text color

                      //   onPrimary: Theme.of(context).accentColor,
                      //   secondary: Colors.yellowAccent,
                      //   //onSecondary: Theme.of(context).accentColor,
                      //   error: Theme.of(context).accentColor,
                      //   onError: Theme.of(context).accentColor,
                      // // background: Theme.of(context).accentColor,
                      //   onBackground: Colors.white,
                      //   surface: Colors.white,
                      //   onSurface: Colors.black
                    )),
                child: child,
              ),
              lastDate: DateTime(2100))
          // ignore: missing_return
              .then((selectedDate) {
            if (selectedDate != null) {
              // displaying formatted date
              dateController.text = DateFormat.yMMMMd().format(selectedDate);
              departuredate = DateFormat('dd-MM-yyyy').format(selectedDate);
              //dateController.text = DateFormat('dd-MM-yyyy').add_jms().format(selectedDate);
              print(dateController.text);
            }
          });

          dateController.text = date.toIso8601String();
        },
      ),
    );
  }

  originTF() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      inputFormatters: [AllCapitalCase()],
      controller: this.originController,
      enableInteractiveSelection: false,
      enabled: !enable,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          //border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          border: OutlineInputBorder(
              gapPadding: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText: "Origin",
          labelStyle: TextStyle(color: Theme.of(context).accentColor)
        //'Pieces',
      ),
      validator: (value) {
        if (value.isEmpty || value == null) {
          return "Please Enter the origin";
        }
        return null;
      },
      // onChanged: (value) {
      //   setState(() {
      //     aircraftreg = value;
      //   });
      // },
    );
  }

  destinationTF() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      inputFormatters: [AllCapitalCase()],
      controller: _AddFlightlistState.destinationController,
      enableInteractiveSelection: false,
      enabled: !enable,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          //border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          border: OutlineInputBorder(
              gapPadding: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText: "Destination",
          labelStyle: TextStyle(color: Theme.of(context).accentColor)
        //'Pieces',
      ),
      validator: (value) {
        if (value.isEmpty || value == null) {
          return "Please Enter the Destination";
        }
        return null;
      },
      // onChanged: (value) {
      //   setState(() {
      //     aircraftreg = value;
      //   });
      // },
    );
  }
}

class AddRouteingAirport extends StatefulWidget with ChangeNotifier {
  final int index;
  List<String> routeList;
  AddRouteingAirport(this.index, this.routeList);
  @override
  _AddRouteingAirportState createState() => _AddRouteingAirportState();
}

class _AddRouteingAirportState extends State<AddRouteingAirport>
    with ChangeNotifier {
  TextEditingController _flightRouteController;
  TextEditingController _flightRouteController2;

  @override
  void initState() {
    super.initState();
    _flightRouteController = TextEditingController();
    _flightRouteController2 = TextEditingController();
  }

  @override
  void dispose() {
    _flightRouteController.dispose();
    _flightRouteController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _flightRouteController.text = widget.routeList[widget.index] ?? '';
      _flightRouteController2.text = widget.routeList[widget.index + 1] ?? '';
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TypeAheadFormField<AirportCode>(
                suggestionsCallback: AirportApi.getAirportCode,
                itemBuilder: (context, AirportCode suggestion) {
                  final code = suggestion;
                  return ListTile(
                    title: Text(code.airportCode),
                    subtitle: Text(code.airportName),
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Select a Airport';
                  }
                  return null;
                },
                textFieldConfiguration: TextFieldConfiguration(
                  inputFormatters: [AllCapitalCase()],
                  controller: this._flightRouteController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Theme.of(context).accentColor),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      //border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Theme.of(context).accentColor),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      border: OutlineInputBorder(
                          gapPadding: 2.0,
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      labelText: "Airport",
                      labelStyle:
                      TextStyle(color: Theme.of(context).accentColor)
                    //'Origin',
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onSuggestionSelected: (AirportCode suggestion) {
                  if (suggestion.airportCode == null &&
                      suggestion.airportName == null) {
                    return 'Worong Code';
                  } else {
                    this._flightRouteController.text = suggestion.airportCode;
                    widget.routeList[widget.index] = suggestion.airportCode;
                    // if (widget.routeList.length > 1) {
                    //   _AddFlightlistState.destinationController.text =
                    //       widget.routeList[widget.index];
                    // }
                    print(widget.routeList[widget.index]);
                  }
                }),
            flex: 4,
          ),
        ],
      ),
    );
    // TextFormField(
    //   controller: ,
    //   onChanged: (v) => widget.routeList[widget.index] = v,
    //   decoration: InputDecoration(hintText: 'Enter your friend\'s name'),
    //   validator: (v) {
    //     if (v.trim().isEmpty) return 'Please enter something';
    //     return null;
    //   },
    // );
  }
}

class EditFlightList extends StatefulWidget {
  String id;
  String aircraftreg;
  String origin;
  String destination;
  String carriercode;
  String departuredate;
  String flightnumber;
  String nilcargoind = "";
  List<String> routeList;
  EditFlightList(
      this.id,
      this.aircraftreg,
      this.origin,
      this.destination,
      this.carriercode,
      this.departuredate,
      this.flightnumber,
      this.routeList,
      );

  @override
  _EditFlightlistState createState() => _EditFlightlistState();
}

class _EditFlightlistState extends State<EditFlightList> {
  final _awbForm = GlobalKey<FormState>();

  TextEditingController dateController = new TextEditingController(
    text: DateFormat.yMMMEd().format(DateTime.now()),
  );
  TextEditingController originController;
  TextEditingController airlineController;
  static TextEditingController destinationController;
  static List<String> routingList;

  @override
  void initState() {
    super.initState();
    originController = TextEditingController();
    airlineController = TextEditingController();
    destinationController = TextEditingController();
    routingList = widget.routeList;
  }

  @override
  void dispose() {
    originController.dispose();
    airlineController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Update Flight"),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "Update",
                      //S.of(context).Add,

                      //"Add",
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Form(
                    key: _awbForm,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Carriercode(),
                                  flex: 3,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: FlightNumber(),
                                  flex: 7,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: originTF(),
                                  flex: 4,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: destinationTF(),
                                  flex: 4,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Aircraftreg(),
                                  flex: 4,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(child: departureDate(), flex: 4),
                              ],
                            ),
                          ),
                          Text(
                            'Add Routing',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                          //),
                          //Expanded(child: departureDate(), flex: 4),
                          ..._addRoutFlight().reversed,

                          SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor)),
                            onPressed: () {
                              if (_awbForm.currentState.validate()) {
                                editFlightlist();
                              }
                            },
                            child: Text(
                              S.of(context).Submit,
                              //  "Submit"
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<dynamic> editFlightlist() async {
    var result;

    if (widget.origin == widget.destination) {
      Fluttertoast.showToast(
          msg: 'Origin and Destination cant be same',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white
      );
      // ignore: deprecated_member_use
      // Scaffold.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("Origin and Destination can't be same"),
      //     duration: Duration(seconds: 1),
      //   ),
      // );
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.put(Uri.parse(StringData.flightlistAPI),
        headers: <String, String>{
          'x-access-tokens': prefs.getString('token'),
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "id": widget.id,
          "airport_code1": "ABB",
          "airport_code2": "ACA",
          "airport_code3": "DXB",
          "airport_code4": "",
          "airport_code5": "",
          "airport_code6": "",
          "airport_code7": "",
          "airport_code8": "",
          "aircraftreg": widget.aircraftreg,
          "airportcodeload": widget.origin,
          "airportcodeunload": widget.destination,
          "carriercode": widget.carriercode,
          "departuredate": widget.departuredate,
          "flightnumber": widget.flightnumber,
          "nilcargoind": widget.nilcargoind,
          "segment10": "",
          "segment11": "",
          "segment12": "",
          "segment13": "",
          "segment14": "",
          "segment15": "",
          "segment16": "",
          "segment2": "",
          "segment3": "",
          "segment4": "",
          "segment5": "",
          "segment6": "",
          "segment7": "",
          "segment8": "",
          "segment9": ""
        }));
    result = json.decode(response.body);
    if (result['message'] == 'token expired') {
      refreshToken();
      editFlightlist();
    } else {
      result = json.decode(response.body);
      print(prefs.getString('token'));
      print(result);
      print("@@@@@@@@@@@@@@@@@");
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: 'Flight list update success',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white
        );
        // insertAWB();
        // Scaffold.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text("Flight list update success"),
        //     duration: Duration(seconds: 1),
        //   ),
        // );
        //  _showMessage("Flight list update success", Colors.green, Colors.white);
        Navigator.push(context, HomeScreenRoute(FlightList()));
        // Navigator.of(context).push(MyEawb());
        print("Data updated");
      } else {
        Fluttertoast.showToast(
            msg: 'Flight list update failed',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white
        );
        // Scaffold.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text("Flight list update failed"),
        //     duration: Duration(seconds: 1),
        //   ),
        // );
        // _showMessage("Flight list update failed", Colors.red, Colors.white);
        print("Data update failed");
      }
    }
    return result;
  }

  // void _showMessage(String message, Color bgcolor, txtcolor) {
  //   if (!mounted) return;
  //   showFlash(
  //       context: context,
  //       duration: Duration(seconds: 3),
  //       builder: (_, controller) {
  //         return Flash(
  //           borderRadius: BorderRadius.circular(20),
  //           backgroundColor: bgcolor,
  //           controller: controller,
  //           position: FlashPosition.top,
  //           behavior: FlashBehavior.fixed,
  //           child: FlashBar(
  //             icon: Icon(
  //               Icons.flight_takeoff_outlined,
  //               size: 36.0,
  //               color: txtcolor,
  //             ),
  //             content: Text(
  //               message,
  //               textAlign: TextAlign.center,
  //               style: TextStyle(fontSize: 20, color: txtcolor),
  //             ),
  //           ),
  //         );
  //       });
  // }

  Aircraftreg() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      inputFormatters: [AllCapitalCase()],
      initialValue: widget.aircraftreg,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          //border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          border: OutlineInputBorder(
              gapPadding: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText: "Aircraftreg",
          labelStyle: TextStyle(color: Theme.of(context).accentColor)
        //'Pieces',
      ),
      validator: (value) {
        if (value.isEmpty || value == null) {
          return "Please Enter the Aircraftreg";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          widget.aircraftreg = value;
        });
      },
    );
  }

  Carriercode() {
    airlineController.text = widget.carriercode;
    final focus = FocusNode();
    return TypeAheadFormField<AirlineCode>(
        suggestionsCallback: AirlineCodeApi.getAirlineCode,
        itemBuilder: (context, AirlineCode suggestion) {
          final code = suggestion;
          return ListTile(
            title: Text(code.airlineCode),
            subtitle: Text(code.airlineName),
          );
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'Select a Airline';
          }
          return null;
        },
        textFieldConfiguration: TextFieldConfiguration(
          // maxLength: 3,
          controller: this.airlineController,
          inputFormatters: [AllCapitalCase()],
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              border: OutlineInputBorder(
                  gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText: S.of(context).Airline,
              labelStyle: TextStyle(color: Theme.of(context).accentColor)
            //'Airline',
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onSuggestionSelected: (AirlineCode suggestion) {
          this.airlineController.text = suggestion.airlineCode;
          widget.carriercode = suggestion.airlineCode;
          print(widget.carriercode);
        });
  }

  FlightNumber() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      // keyboardType: TextInputType.number,
      inputFormatters: [AllCapitalCase()],
      initialValue: widget.flightnumber,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          //border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          border: OutlineInputBorder(
              gapPadding: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText: "FlightNumber",
          // labelText: S.of(context).Pieces,
          labelStyle: TextStyle(color: Theme.of(context).accentColor)
        //'Pieces',
      ),
      validator: (value) {
        if (value.isEmpty || value == null) {
          return "Please Enter the FlightNumber";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          widget.flightnumber = value;
        });
      },
    );
  }

  departureDate() {
    dateController.text = widget.departuredate;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      width: 320,
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: dateController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: new BorderSide(
                  color: Theme.of(context).accentColor,
                  // color: Colors.deepPurple,
                  width: 1),
              //gapPadding: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).accentColor,
              //  color: Colors.deepPurple
            ),
          ),
          labelText: "Date ",
          labelStyle: TextStyle(color: Theme.of(context).accentColor),
          hintText: "Enter the Date",
        ),
        onTap: () async {
          DateTime date = DateTime(1900);
          FocusScope.of(context).requestFocus(new FocusNode());
          date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2021),
              builder: (context, child) => Theme(
                data: ThemeData().copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Theme.of(context)
                          .accentColor, // header background color
                      onPrimary: Colors.black, // header text color
                      onSurface: Colors.black, // body text color

                      //   onPrimary: Theme.of(context).accentColor,
                      //   secondary: Colors.yellowAccent,
                      //   //onSecondary: Theme.of(context).accentColor,
                      //   error: Theme.of(context).accentColor,
                      //   onError: Theme.of(context).accentColor,
                      // // background: Theme.of(context).accentColor,
                      //   onBackground: Colors.white,
                      //   surface: Colors.white,
                      //   onSurface: Colors.black
                    )),
                child: child,
              ),
              lastDate: DateTime(2100))
          // ignore: missing_return
              .then((selectedDate) {
            if (selectedDate != null) {
              // displaying formatted date
              dateController.text = DateFormat.yMMMMd().format(selectedDate);
              widget.departuredate =
                  DateFormat('dd-MM-yyyy').format(selectedDate);
              //dateController.text = DateFormat('dd-MM-yyyy').add_jms().format(selectedDate);
              print(dateController.text);
            }
          });

          dateController.text = date.toIso8601String();
        },
      ),
    );
  }

  originTF() {
    originController.text = widget.origin;
    return TextFormField(
      textInputAction: TextInputAction.next,
      inputFormatters: [AllCapitalCase()],
      controller: this.originController,
      enableInteractiveSelection: false,
      //enabled: !enable,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          //border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          border: OutlineInputBorder(
              gapPadding: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText: "Origin",
          labelStyle: TextStyle(color: Theme.of(context).accentColor)
        //'Pieces',
      ),
      validator: (value) {
        if (value.isEmpty || value == null) {
          return "Please Enter the origin";
        }
        return null;
      },
      // onChanged: (value) {
      //   setState(() {
      //     aircraftreg = value;
      //   });
      // },
    );
  }

  destinationTF() {
    destinationController.text = widget.destination;
    //final focus = FocusNode();
    return TextFormField(
      textInputAction: TextInputAction.next,
      inputFormatters: [AllCapitalCase()],
      controller: _EditFlightlistState.destinationController,
      enableInteractiveSelection: false,
      //enabled: !enable,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          //border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          border: OutlineInputBorder(
              gapPadding: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText: "Destination",
          labelStyle: TextStyle(color: Theme.of(context).accentColor)
        //'Pieces',
      ),
      validator: (value) {
        if (value.isEmpty || value == null) {
          return "Please Enter the Destination";
        }
        return null;
      },
      // onChanged: (value) {
      //   setState(() {
      //     aircraftreg = value;
      //   });
      // },
    );
  }

  /// get firends text-fields
  List<Widget> _addRoutFlight() {
    List<Widget> friendsTextFields = [];
    //if (routingList.length < 9) {
    for (int i = 0; i < routingList.length; i++) {
      friendsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: AddRouteingAirport(i, routingList)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButton(i == routingList.length - 1, i),
          ],
        ),
      ));
    }
    return friendsTextFields;
    // } else {
    //   EasyLoading.showToast("Routing airport should be less than 9");
    //   EasyLoading.dismiss(animation: true);
    // }
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          routingList.insert(0, null);
        } else
          routingList.removeAt(index);
        setState(() {
          //enable = true;
          widget.origin = originController.text = routingList.last;
          if (routingList.length >= 2)
            widget.destination = destinationController.text = routingList[0];
        });
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

class EditRouteingAirport extends StatefulWidget with ChangeNotifier {
  final int index;
  List<String> routeList;
  EditRouteingAirport(this.index, this.routeList);
  @override
  _EditRouteingAirportState createState() => _EditRouteingAirportState();
}

class _EditRouteingAirportState extends State<EditRouteingAirport>
    with ChangeNotifier {
  TextEditingController _flightRouteController;

  @override
  void initState() {
    super.initState();
    _flightRouteController = TextEditingController();
  }

  @override
  void dispose() {
    _flightRouteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _flightRouteController.text = widget.routeList[widget.index] ?? '';
    });

    return TypeAheadFormField<AirportCode>(
        suggestionsCallback: AirportApi.getAirportCode,
        itemBuilder: (context, AirportCode suggestion) {
          final code = suggestion;
          return ListTile(
            title: Text(code.airportCode),
            subtitle: Text(code.airportName),
          );
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'Select a Airport';
          }
          return null;
        },
        textFieldConfiguration: TextFieldConfiguration(
          inputFormatters: [AllCapitalCase()],
          controller: this._flightRouteController,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              //border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              border: OutlineInputBorder(
                  gapPadding: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              labelText: "Airport",
              labelStyle: TextStyle(color: Theme.of(context).accentColor)
            //'Origin',
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onSuggestionSelected: (AirportCode suggestion) {
          if (suggestion.airportCode == null &&
              suggestion.airportName == null) {
            return 'Worong Code';
          } else {
            this._flightRouteController.text = suggestion.airportCode;
            widget.routeList[widget.index] = suggestion.airportCode;
            if (widget.routeList.length > 1) {
              _EditFlightlistState.destinationController.text =
              widget.routeList[widget.index];
            }
            print(widget.routeList[widget.index]);
          }
        });
    // TextFormField(
    //   controller: ,
    //   onChanged: (v) => widget.routeList[widget.index] = v,
    //   decoration: InputDecoration(hintText: 'Enter your friend\'s name'),
    //   validator: (v) {
    //     if (v.trim().isEmpty) return 'Please enter something';
    //     return null;
    //   },
    // );
  }
}
