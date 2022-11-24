import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/screenroute.dart';
import 'package:rooster/string.dart';
import 'package:rooster/ui/eawb/main_eawb.dart';
import 'package:rooster/ui/hawb/house_details.dart';
import 'package:rooster/ui/hawb/static/add_master_eawb.dart';
import 'package:rooster/ui/hawb/static/edit_hawb.dart';
import 'package:rooster/ui/slot_booking/add_slot_booking.dart';
import 'package:shared_preferences/shared_preferences.dart';

void refreshToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var response = await http.get(StringData.refreshTokenAPI,
      headers: {'x-access-tokens': prefs.getString('token')});
  var result = json.decode(response.body);
  if (result['result'] == 'verified') prefs.setString('token', result['token']);
  print(result);
}

Future<dynamic> getAWBlist() async {
  var result;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var response = await http.get(StringData.awblistAPI,
      headers: {'x-access-tokens': prefs.getString('token')});
  result = json.decode(response.body);
  if (result['message'] == 'token expired') {
    refreshToken();
    getAWBlist();
  } else {
    //getAWBlist();
    print(prefs.getString('token'));
  }
  print("AWB List Details " + '${result["awb"]}');
  return result["awb"];
}

class SlotBooking extends StatefulWidget {
  final String awbNumber;
  SlotBooking({Key key, this.awbNumber}) : super(key: key);

  @override
  _SlotBookingState createState() => _SlotBookingState();
}

class _SlotBookingState extends State<SlotBooking>
    with TickerProviderStateMixin {
  bool _expand = false;

  AnimationController _anicontroller;

  Animation _profilePictureAnimation;
  Animation _contentAnimation;
  Animation _listAnimation;
  Animation _fabAnimation;
  GlobalKey _fabTarget = GlobalKey();

  @override
  void initState() {
    _anicontroller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    _profilePictureAnimation = Tween(begin: 0.0, end: 50.0).animate(
        CurvedAnimation(
            parent: _anicontroller,
            curve: Interval(0.0, 0.20, curve: Curves.easeOut)));
    _contentAnimation = Tween(begin: 0.0, end: 34.0).animate(CurvedAnimation(
        parent: _anicontroller,
        curve: Interval(0.20, 0.40, curve: Curves.easeOut)));
    _listAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _anicontroller,
        curve: Interval(0.40, 0.75, curve: Curves.easeOut)));
    _fabAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _anicontroller,
        curve: Interval(0.75, 1.0, curve: Curves.easeOut)));
    _anicontroller.forward();
    _anicontroller.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // floatingActionButton: Transform.scale(
        //   scale: _fabAnimation.value,
        //   child: Builder(
        //     builder: (context) => FloatingActionButton(
        //       key: _fabTarget,
        //       backgroundColor: Theme.of(context).accentColor,
        //       onPressed: () async {
        //         Map<String, String> newMasterAWB = await Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => AddSlotBooking(),
        //               fullscreenDialog: true,
        //             ));
        //         if (newMasterAWB != null) {
        //           setState(() {
        //             //masterAWB.add(newMasterAWB);
        //           });
        //         }
        //       },
        //       child: Icon(Icons.add),
        //     ),
        //   ),
        // ),
        body: Container(
      //height: MediaQuery.of(context).size.height - 185.0,
      child: Center(
        child: FutureBuilder<dynamic>(
          future: getAWBlist(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              EasyLoading.show();
              print("Snapshot Data ${snapshot.data}");
              //getawblist=snapshot.data;
              return GetAWBList(
                getawblist: snapshot.data,
                awbNumber: widget.awbNumber,
              );
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
    ));
  }
}

class GetAWBList extends StatefulWidget {
  var getawblist;
  var awbNumber;
  GetAWBList({Key key, this.getawblist, this.awbNumber}) : super(key: key);

  @override
  _MyAWBState createState() => _MyAWBState();
}

class _MyAWBState extends State<GetAWBList> {
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController controller = new TextEditingController();
  List _searchResult = [];
  Widget _buildSearchBox() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 45,
            width: 250,
            child: TextField(
              controller: controller,
              textCapitalization: TextCapitalization.characters,
              decoration: new InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).accentColor),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                //border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).accentColor),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                hintText:
                S.of(context).Search,
                //'Search',
                prefixIcon: IconButton(
                  icon: new Icon(Icons.search),
                  color: Theme.of(context).accentColor,
                  onPressed: () {},
                ),
                suffixIcon: IconButton(
                  icon: new Icon(Icons.cancel),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    controller.clear();
                    onSearchTextChanged('');
                  },
                ),
                //border: InputBorder.none,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
              ),
              onChanged: onSearchTextChanged,
            ),
          ),
          IconButton(
            icon: new Icon(Icons.filter_list_rounded),
            color: Theme.of(context).accentColor,
            iconSize: 43,
            onPressed: () {
              controller.clear();
              onSearchTextChanged('');
            },
          ),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    print("object");
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    widget.getawblist.forEach((getawblist) {
      print("Foreach'${getawblist}'" + text);
      String searchText = getawblist["origin"].toString();
      if (getawblist["prefix"].toString().contains(text) ||
          getawblist["wayBillNumber"].toString().contains(text) ||
          searchText.contains(text) ||
          getawblist["destination"].toString().contains(text))
        _searchResult.add(getawblist);
    });
    print('$_searchResult');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //print("Get AWB list ${widget.getawblist}");
    var getList = _searchResult.length != 0 || controller.text.isNotEmpty
        ? _searchResult
        : widget.getawblist;
    print("Get AWB list ${widget.getawblist}");

    return widget.getawblist == []
        ? Text(S.of(context).DataNotFound
            // "Data Not Found"
            )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              // flexibleSpace: new Container(
              //   decoration: new BoxDecoration(
              //     borderRadius: BorderRadius.vertical(
              //       bottom: Radius.circular(20),
              //     ),
              //     color: Color.fromRGBO(255, 255, 255, 0.5),
              //     image: new DecorationImage(
              //       image: AssetImage('assets/images/flight_bg.png'),
              //       fit: BoxFit.cover,
              //     ) ,
              //   ),
              // ),
              // title: Text(
              //   S.of(context).AWBList,
              //   //"AWB List",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(

              //       // color: Colors.white,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 20),
              // ),
              title: Text(
                '176-00122474',
              ),
              elevation: 1,
            ),




            // backgroundColor: Colors.grey.shade200,
            //backgroundColor: Theme.of(context).primaryColor,

            body: Column(
              children: [
                new Container(
                    //color: Theme.of(context).primaryColor,
                    child: _buildSearchBox()),
                new Expanded(
                    child: _buildAWBList1(
                        context,
                        _searchResult.length != 0 || controller.text.isNotEmpty
                            ? _searchResult
                            : widget.getawblist))
              ],
            ),


          );
  }

  Widget _buildAWBList1(BuildContext context, var getawblist) {
    return ListView(
      padding: EdgeInsets.only(top: 0, bottom: 0),
      children: new List<Widget>.generate(getawblist.length, (index) {
        return Dismissible(
            key: ValueKey(getawblist[index]),
            confirmDismiss: (DismissDirection direction) async {
              if (direction == DismissDirection.startToEnd) {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        S.of(context).DeleteConfirmation,
                        style: TextStyle(color: Theme.of(context).accentColor),
                        //"Delete Confirmation"
                      ),
                      content: Text(
                        S.of(context).Areyousureyouwanttodeletethisitem,
                        style: TextStyle(color: Theme.of(context).accentColor),
                        //"Are you sure you want to delete this item?"
                      ),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                              deleteAWB('${getawblist[index]["id"]}');
                            },
                            child: Text(
                              // BuildContext context,
                              S.of(context).Delete,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                              //"Delete"
                            )),
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            S.of(context).Cancel,
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                            // "Cancel"
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditHawb(
                        '${getawblist[index]["prefix"]}',
                        '${getawblist[index]["wayBillNumber"]}',
                        '${getawblist[index]["id"]}',
                        '${getawblist[index]["destination"]}',
                        '${getawblist[index]["origin"]}',
                        '${getawblist[index]["shipmentcode"]}',
                        '${getawblist[index]["pieces"]}',
                        '${getawblist[index]["weight"]}',
                        '${getawblist[index]["weightcode"]}',
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
                  textDirection: TextDirection.rtl,
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
            child: Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ],
                    color: Colors.grey,
                    //color: Color.fromRGBO(255, 255, 255, 0.5),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "https://cdn.pixabay.com/photo/2013/07/12/12/54/world-map-146505_640.png")),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    // border: Border.all(
                    //   color: Colors.black,
                    // ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: 79,
                        padding: EdgeInsets.only(top: 10, right: 10, left: 10),
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
                            // Row(
                            //   children: <Widget>[
                            //     Container(
                            //         //color: Colors.lightBlueAccent,
                            //         child: Text(
                            //       'AAA${getawblist[index]["prefix"]}',
                            //       style: TextStyle(
                            //           fontSize: 20,
                            //           //color: Colors.black,
                            //           color: Theme.of(context).accentColor,
                            //           fontWeight: FontWeight.bold),
                            //     )),
                            //     SizedBox(
                            //       width: 19,
                            //     ),
                            //     Text(
                            //       'Pcs : ${getawblist[index]["pieces"]}',
                            //       style: TextStyle(
                            //         fontSize: 15,
                            //         fontWeight: FontWeight.bold,
                            //         //color: Colors.indigo,
                            //         color: Theme.of(context).accentColor,
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 5,
                            //     ),
                            //     Text(
                            //       'Wgt : ${getawblist[index]["weight"]}' + "kg",
                            //       style: TextStyle(
                            //         fontSize: 15,
                            //         fontWeight: FontWeight.bold,
                            //         //color: Colors.indigo,
                            //         color: Theme.of(context).accentColor,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Row(
                              children: <Widget>[
                                Container(
                                    child: Text(
                                  "Date & Time",
                                  //"Pieces",
                                  style: TextStyle(
                                    fontSize: 14,
                                    //color: Colors.deepPurpleAccent,
                                    color: Theme.of(context).accentColor,
                                  ),
                                )),
                                SizedBox(
                                  width: 60,
                                ),
                                SizedBox(
                                  width: 110,
                                ),
                                Container(
                                    child: Text(
                                  "duration",
                                  //"Weight",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).accentColor,
                                    // color: Colors.deepPurpleAccent,
                                  ),
                                )),
                              ],
                            ),
                            SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        // color: Colors.lightBlueAccent,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 3.0, bottom: 3.0),
                                        child: Text(
                                          'Mon, 10 Mar 2022 09:30:00 ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              // color: Colors.black54,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          // color: Colors.lightBlueAccent,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            '30 min',
                                            style: TextStyle(
                                                fontSize: 15,
                                                // color: Colors.black54,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        //color: Colors.white,
                        color: Theme.of(context).backgroundColor,
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              height: 15,
                              width: 10,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    color: Colors.grey.shade200),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Flex(
                                      children: List.generate(
                                          (constraints.constrainWidth() / 10)
                                              .floor(),
                                          (index) => SizedBox(
                                                height: 1,
                                                width: 5,
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade400),
                                                ),
                                              )),
                                      direction: Axis.horizontal,
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                              width: 10,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                    color: Colors.grey.shade200),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 12),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                    child: Text(
                                  "Location",
                                  //"Pieces",
                                  style: TextStyle(
                                    fontSize: 13,
                                    //color: Colors.deepPurpleAccent,
                                    color: Theme.of(context).accentColor,
                                  ),
                                )),
                                SizedBox(
                                  width: 60,
                                ),
                                // SizedBox(
                                //   width: 150,
                                // ),
                                Container(
                                    child: Text(
                                  "Zone",
                                  //"Weight",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context).accentColor,
                                    // color: Colors.deepPurpleAccent,
                                  ),
                                )),
                              ],
                            ),
                            SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    // decoration: BoxDecoration(
                                    //   borderRadius: BorderRadius.circular(10.0),
                                    //   // color: Colors.lightBlueAccent,
                                    // ),
                                    child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 3.0, bottom: 3.0),
                                  child: Text(
                                    'Blue building',
                                    style: TextStyle(
                                        fontSize: 15,
                                        // color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    // decoration: BoxDecoration(
                                    //   borderRadius: BorderRadius.circular(10.0),
                                    //   // color: Colors.lightBlueAccent,
                                    // ),
                                    child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    'A1 block',
                                    style: TextStyle(
                                        fontSize: 15,
                                        // color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                                SizedBox(
                                  width: 20,
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).accentColor),
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                        ),
                                        context: context,
                                        builder: (BuildContext bc) {
                                          return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .40,
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(18.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          S.of(context).BookYourSlotNow,
                                                          //"Book Your Slot Now",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Theme.of(
                                                                      context)
                                                                  .accentColor),
                                                        ),
                                                        Spacer(),
                                                        IconButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor,
                                                            icon: Icon(Icons
                                                                .close_rounded))
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  S.of(context).SlotDateTime,
                                                                  //"Slot Date & Time :",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          17,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .accentColor),
                                                                ),
                                                                Container(
                                                                    // decoration:
                                                                    //     BoxDecoration(
                                                                    //   border: Border.all(
                                                                    //       color: Theme.of(context)
                                                                    //           .accentColor),
                                                                    //   shape: BoxShape
                                                                    //       .rectangle,
                                                                    // ),
                                                                    child:
                                                                        Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 50),
                                                                  child: Text(
                                                                    "Mon, 10 Mar 2022 09:30:00",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        color: Theme.of(context)
                                                                            .accentColor),
                                                                  ),
                                                                ))
                                                              ],
                                                            )),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                            // width: 80,
                                                            // height: 30,
                                                            child:
                                                                ElevatedButton
                                                                    .icon(
                                                          onPressed: () {
                                                            // Respond to button press
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Theme.of(
                                                                            context)
                                                                        .backgroundColor),
                                                          ),
                                                          icon: Icon(
                                                            Icons.cloud_circle,
                                                            size: 18,
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor,
                                                          ),
                                                          label: Text(
                                                            S.of(context).BookSlot,
                                                            //"Book Slot",
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .accentColor),
                                                          ),
                                                        )),
                                                      ],
                                                    )
                                                  ],
                                                )),
                                          );
                                        });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                       S.of(context).BookNow,
                                        // "Book now",
                                        style: TextStyle(
                                          color:
                                              Theme.of(context).backgroundColor,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(Icons.airplane_ticket,
                                          color: Theme.of(context)
                                              .backgroundColor),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )));
      }),
    );
  }

  void _displayCreateAWBDialog(BuildContext context, String awb) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: 300,
          child: Stack(
            overflow: Overflow.visible,
            alignment: Alignment.topCenter,
            fit: StackFit.loose,
            children: <Widget>[
              Transform.translate(
                offset: Offset(0, -50),
                child: ClipOval(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: FittedBox(
                      alignment: Alignment.center,
                      child: Image.asset("assets/images/logo.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, 60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        S.of(context).UpdateAirWaybillDetails,
                        //  "Update Air Waybill Details",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Container(
                        height: 100,
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Center(
                            child: Text(
                                S
                                    .of(context)
                                    .WouldyouliketoupdateAirWaybillDetails,
                                //"Would you like to update Air Waybill Details?",
                                textAlign: TextAlign.center))),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            elevation: 5,
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context,
                                  HomeScreenRoute(MainEAWB(awbNumber: awb)));
                            },
                            child: Text(S.of(context).Yes
                                //"Yes"
                                ),
                          ),
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            elevation: 5,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              S.of(context).Cancel,
                              //"Cancel"
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _bottomModelSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * .30,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                S.of(context).BookYourSlot
                 // "BookYour Slot"
              ),
            ),
          );
        });
  }

  Future<dynamic> deleteAWB(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(StringData.awblistAPI);
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

  void _selectTime(BuildContext context) async{
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,

    );
    if(timeOfDay != null && timeOfDay != selectedTime)
    {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }
}
