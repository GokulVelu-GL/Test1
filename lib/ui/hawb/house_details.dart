import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/fhl_model.dart';
import 'package:rooster/screenroute.dart';
import 'package:rooster/string.dart';
import 'package:rooster/ui/hawb/main_hawb.dart';
import 'package:rooster/ui/hawb/static/edit_house_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'static/add_eawb_house.dart';

void refreshToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var response = await http.get(Uri.parse(StringData.refreshTokenAPI),
      headers: {'x-access-tokens': prefs.getString('token')});
  var result = json.decode(response.body);
  if (result['result'] == 'verified') prefs.setString('token', result['token']);
  print(result);
}

Future<dynamic> getAWBHouseList(String awbid) async {
  //List<String, dynamic> result;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.parse(StringData.hawblistAPI);
  final request = http.Request("GET", url);
  request.headers.addAll(<String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'x-access-tokens': prefs.getString('token')
  });
  request.body = jsonEncode({"AWBList_id": awbid});
  var jsonData;
  var res = await request.send();
  final respStr = await res.stream.bytesToString();
  jsonData = jsonDecode(respStr);
  print("Respstr ${respStr}");
  print("jsonData ${jsonData}");
  return jsonData["hawb"];
}

class EditEawb extends StatefulWidget {
  final String masterAWB;
  final String awbid;

  EditEawb(this.masterAWB, this.awbid);

  @override
  _EditEditEawbState createState() => new _EditEditEawbState();
}

class _EditEditEawbState extends State<EditEawb> {
  @override
  void initState() {
    // TODO: implement initState
    // getAWBHouseList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).accentColor,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: refreshhouse,
      child: new Scaffold(

          body: Center(
            child: FutureBuilder<dynamic>(
              future: getAWBHouseList(widget.awbid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print("Snapshot Data ${snapshot.data}");
                  if (snapshot.data == null) {
                    return Text(
                      S.of(context).DataNotFound,
                      //"Data Not Found"
                    );
                  } else {
                    return GetHouseList(
                      awbid: widget.awbid,
                        gethouselist: snapshot.data,
                        awbNumber: widget.masterAWB);
                  }
                } else if (snapshot.hasError) {
                  return Text(S.of(context).DataNotFound
                      //"Data Not Found"
                      );
                }

                // By default, show a loading spinner
                return CircularProgressIndicator();
              },
            ),
          )),
    );
  }

  Future<void> refreshhouse() async {
    await Future.delayed(Duration(milliseconds: 500));
    FutureBuilder<dynamic>(
      future: getAWBHouseList(widget.awbid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("Snapshot Data ${snapshot.data}");
          if (snapshot.data == null) {
            return Text(
              S.of(context).DataNotFound,
              //"Data Not Found"
            );
          } else {
            return GetHouseList(
                gethouselist: snapshot.data, awbNumber: widget.masterAWB,
            awbid:widget.awbid
            );
          }
        } else if (snapshot.hasError) {
          return Text(S.of(context).DataNotFound
              //"Data Not Found"
              );
        }

        // By default, show a loading spinner
      },
    );
  }
}

class GetHouseList extends StatefulWidget {
  var gethouselist;
  var awbNumber;
  var awbid;
  GetHouseList({Key key, this.gethouselist, this.awbNumber,this.awbid}) : super(key: key);

  @override
  State<GetHouseList> createState() => _GetHouseListState();
}

class _GetHouseListState extends State<GetHouseList> {
  TextEditingController controllerh = new TextEditingController();
  List _searchResult = [];
  bool mini;
  Widget _buildSearchBox() {
    return new Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        padding: EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 45,
              width: 250,
              child: TextField(
                controller: controllerh,
                textCapitalization: TextCapitalization.characters,
                decoration: new InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).accentColor),
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  //border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).accentColor),
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
                      controllerh.clear();
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
              iconSize: 40,
              onPressed: () {
                controllerh.clear();
                onSearchTextChanged('');
              },
            ),
          ],
        ),
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

    widget.gethouselist.forEach((gethouselist) {
      print("Foreach'${gethouselist}'" + text);
      String searchText = gethouselist["origin"].toString();
      if (gethouselist["serialNumber"].toString().startsWith(text) ||
          searchText.startsWith(text) ||
          gethouselist["destination"].toString().startsWith(text))
        _searchResult.add(gethouselist);
    });
    print('$_searchResult');
    setState(() {});
  }


  Widget buildAddButton() {
    return Builder(
      builder: (context) => FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () async {
          FHLModel _newFHLModel = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddEawb(isView: false, awbid: widget.awbid,houselist:widget.gethouselist),
                fullscreenDialog: true,
              ));

          if (_newFHLModel != null) {
            setState(() {
              // _listFHLModel.add(_newFHLModel);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: buildAddButton(),
        appBar: AppBar(
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          flexibleSpace: new Container(
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
              color: Color.fromRGBO(255, 255, 255, 0.5),
              image: new DecorationImage(
                image: NetworkImage(
                    'https://bestlifeonline.com/wp-content/uploads/sites/3/2018/06/airplane-landing-at-sunset.jpg?quality=82&strip=1&resize=640%2C360'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            S.of(context).HouseList + "\t" + widget.awbNumber,
            //"AWB List",
            style: TextStyle(
                // color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          //elevation: 1,
        ),
        body: Container(
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Container(
                child: _buildSearchBox(),
              ),
              Expanded(
                  child: _buildAWBList1(
                      context,
                      _searchResult.length != 0 || controllerh.text.isNotEmpty
                          ? _searchResult
                          : widget.gethouselist))
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildAWBList1(BuildContext context, var gethouselist) {
    return ListView(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      children: new List<Widget>.generate(gethouselist.length, (index) {
        return Dismissible(
            key: ValueKey(gethouselist[index]),
            confirmDismiss: (DismissDirection direction) async {
              if (direction == DismissDirection.startToEnd) {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        S.of(context).DeleteConfirmation,
                        style: TextStyle(color: Theme.of(context).accentColor),

                        //  "Delete Confirmation"
                      ),
                      content: Text(
                        S.of(context).Areyousureyouwanttodeletethisitem,
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                      // "Are you sure you want to delete this item?"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                              deleteHAWB('${widget.gethouselist[index]["id"]}');
                            },
                            child: Text(
                              S.of(context).Delete,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                              //"Delete"
                            )),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            S.of(context).Cancel,
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                            //"Cancel"
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
                      builder: (context) => EditHouse(
                        isView: false,
                        id: '${widget.gethouselist[index]["id"]}',
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
                    Text(S.of(context).Delete,
                        //'Delete'
                        style: TextStyle(color: Theme.of(context).accentColor)),
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
                    //color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height / 7.5,
                        //  height: 80,
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            //color: Colors.white,
                            //color: Colors.grey,
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
                                  '${widget.gethouselist[index]["origin"]}',
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
                                      borderRadius: BorderRadius.circular(20)),

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
                                    padding: const EdgeInsets.all(3.0),
                                    child: Stack(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 21,
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              return Flex(
                                                children: List.generate(
                                                    (constraints.constrainWidth() /
                                                            6)
                                                        .floor(),
                                                    (index) => SizedBox(
                                                          height: 1,
                                                          width: 3,
                                                          child: DecoratedBox(
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                        )),
                                                direction: Axis.horizontal,
                                                mainAxisSize: MainAxisSize.max,
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
                                      borderRadius: BorderRadius.circular(20)),
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
                                  '${widget.gethouselist[index]["destination"]}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    //color: Colors.indigo,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                    child: Text(
                                  S.of(context).Pieces,
                                  //"Pieces",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context).accentColor,
                                    //color: Colors.deepPurpleAccent,
                                  ),
                                )),
                                SizedBox(
                                  width: 60,
                                ),
                                SizedBox(
                                  width: 150,
                                ),
                                Container(
                                    child: Text(
                                  S.of(context).Weight,
                                  //"Weight",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context).accentColor,
                                    //color: Colors.deepPurpleAccent,
                                  ),
                                )),
                              ],
                            ),
                            SizedBox(height: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 9),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        // color: Colors.lightBlueAccent,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          '${widget.gethouselist[index]["pieces"]}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              //color: Colors.black54,
                                              // color:
                                              // Theme.of(context).accentColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                ),
                                Container(
                                    //color: Colors.lightBlueAccent,
                                    child: Text(
                                  '${widget.gethouselist[index]["serialNumber"]}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      //color: Colors.black,
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.bold),
                                )),
                                Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            //  color: Colors.lightBlueAccent,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              '${widget.gethouselist[index]["weight"]} ${widget.gethouselist[index]["weightCode"]}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  //color: Colors.black54,
                                                  // color: Theme.of(context)
                                                  //     .accentColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ],
                                  ),
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
                              height: 20,
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
                              height: 20,
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
                        height: MediaQuery.of(context).size.height / 15,
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          //  color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24)),
                          //  color: Colors.lightBlueAccent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.3),
                                  // color: Colors.amber.shade50,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Icon(
                                Icons.flight_takeoff,
                                color: Theme.of(context).accentColor,

                                // color: Colors.amber
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0))),
                                          title: Center(
                                              child: Text(
                                           S.of(context).ShipperandConsignee,
                                                // 'Shipper and Consignee',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                fontStyle: FontStyle.italic),
                                          )),
                                          content: Container(
                                              child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Card(
                                                child: ListTile(
                                                  leading: Image(
                                                    width: 39.0,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    image: NetworkImage(
                                                        "https://cdn.iconscout.com/icon/premium/png-256-thumb/message-sender-3322207-2764893.png"),
                                                  ),
                                                  // leading: CircleAvatar(
                                                  //    radius: 20.0,
                                                  //    backgroundImage:
                                                  //    NetworkImage("https://cdn.iconscout.com/icon/premium/png-256-thumb/message-sender-3322207-2764893.png",
                                                  //    ),
                                                  //    backgroundColor: Colors.transparent,
                                                  //  ),
                                                  title: Text(
                                                    '${widget.gethouselist[index]["s_name"]}',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                  ),
                                                  subtitle: Column(
                                                    children: [
                                                      Text(
                                                        '${widget.gethouselist[index]["s_address"]}',
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${widget.gethouselist[index]["s_state"]}',
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Card(
                                                child: ListTile(
                                                  leading: Image(
                                                    width: 39.0,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    image: NetworkImage(
                                                        "https://cdn.iconscout.com/icon/premium/png-256-thumb/receiver-188-1130956.png"),
                                                  ),
                                                  // leading: CircleAvatar(
                                                  //   radius: 25.0,
                                                  //   backgroundImage:
                                                  //   NetworkImage("https://cdn.iconscout.com/icon/premium/png-256-thumb/receiver-188-1130956.png",
                                                  //   ),
                                                  //   backgroundColor: Colors.transparent,
                                                  // ),
                                                  title: Text(
                                                    '${widget.gethouselist[index]["c_name"]}',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                  ),
                                                  subtitle: Column(
                                                    children: [
                                                      Text(
                                                        '${widget.gethouselist[index]["c_address"]}',
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${widget.gethouselist[index]["c_state"]}',
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                          actions: <Widget>[
                                            Center(
                                              child:  TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                //textColor: Theme.of(context).primaryColor,
                                                child: Text(
                                                    S.of(context).Close,
                                                    //'Close',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      S.of(context).MoreInfo,
                                     // "More Info",
                                      style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                    Icon(
                                      Icons.info,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )));
      }),
    );
  }

  Future<dynamic> deleteHAWB(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(StringData.hawblistAPI);
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

  Widget ExtraData() {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              leading: Icon(Icons.list),
              trailing: Text(
                "GFG",
                style: TextStyle(color: Colors.green, fontSize: 15),
              ),
              title: Text("List item $index"));
        });
  }
}
