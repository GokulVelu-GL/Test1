import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/string.dart';
import 'package:rooster/ui/homescreen/create_bulkManifest.dart';
import 'package:badges/badges.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BulkandUldListloader extends StatefulWidget {
  String flightLoading;
  String flightUnLoading;
  int flightId;
  int manifestVersion;
  BulkandUldListloader(
      {this.flightId,
      this.flightLoading,
      this.flightUnLoading,
      this.manifestVersion});

  @override
  State<BulkandUldListloader> createState() => BulkandUldListloaderState();
}

class BulkandUldListloaderState extends State<BulkandUldListloader> {
  void refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(StringData.refreshTokenAPI,
        headers: {'x-access-tokens': prefs.getString('token')});
    var result = json.decode(response.body);
    if (result['result'] == 'verified')
      prefs.setString('token', result['token']);
    print(result);
  }

  Future<dynamic> getManifestList(int id, String flightLoading,
      String flightUnloading, int manifestVersion) async {
    var result;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(StringData.manifestAPI);
    final request = http.Request("GET", url);
    request.headers.addAll(<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-access-tokens': prefs.getString('token')
    });
    request.body = jsonEncode({
      "FlightList_id": id, //40,
      "Manifest_Version": manifestVersion,
      "FFM_PointOfLoading_AirportCode": flightLoading,
      "FFM_PointOfUnLoading_AirportCode": flightUnloading
    });
    result = await request.send();

    final respStr = await result.stream.bytesToString();
    result = jsonDecode(respStr);
    //result = json.decode(response);
    if (result['message'] == 'token expired') {
      refreshToken();
      getManifestList(id, flightLoading, flightUnloading, manifestVersion);
    } else {
      //getAWBlist();
      print(prefs.getString('token'));
    }
    print("Manifest List Details " + '${result}');
    return result["manifest"];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<dynamic>(
        future: getManifestList(widget.flightId, widget.flightLoading,
            widget.flightUnLoading, widget.manifestVersion),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BulkandUldList(
                flightId: widget.flightId,
                flightLoading: widget.flightLoading,
                flightUnLoading: widget.flightUnLoading,
                manifestList: snapshot.data);
          }
          // By default, show a loading spinner
          return CircularProgressIndicator();
          //return EasyLoading.show();
        },
      ),
    );
  }
}

class BulkandUldList extends StatefulWidget {
  var manifestList;
  String flightLoading;
  String flightUnLoading;
  int flightId;

  BulkandUldList(
      {this.flightId,
      this.manifestList,
      this.flightLoading,
      this.flightUnLoading});

  @override
  State<BulkandUldList> createState() => BulkandUldListState();
}

//const BulkandUldList({super.key});
class BulkandUldListState extends State<BulkandUldList>
    with SingleTickerProviderStateMixin {
  final List<ExpenseList> expenseList = [];
  bool _customTileExpanded = false;
  bool _uldCustomTileExpanded = false;
  TextEditingController addText = new TextEditingController();
  TabController _tabController;
  int bulkCount, uldCount;
  var uldConsignment;
  var uldList, bulkList;

  @override
  void initState() {
    addText.text = "Bulk";
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      setState(() {
        if (_tabController.index == 1)
          addText.text = "ULD";
        else
          addText.text = "Bulk";
      });
    });

    setState(() {
      print(widget.manifestList);
      if (widget.manifestList.length != 0) {
        bulkList = widget.manifestList["Bulk_Consignment_details"];
        print(bulkList);
        uldList = widget.manifestList["ULD_Consignment_details"];
        print(uldList);
      } else {
        bulkList = [];
        uldList = [];
      }

      bulkCount = bulkList.length;
      uldCount = uldList.length;
      print(bulkCount);
      //uldConsignment=widget.uldList[];
    });
    super.initState();
  }

  @override
  void dispose() {
    addText.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isBulk;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                icon: Badge(
                    showBadge: true,
                    badgeContent: Text(bulkCount.toString(),
                        style: const TextStyle(color: Colors.white)),
                    animationType: BadgeAnimationType.scale,
                    shape: BadgeShape.circle,
                    //alignment: Alignment.topRight,
                    position: BadgePosition.topEnd(),
                    // child: const Icon(Icons),
                    child: Text(
                      "Bulk   ",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
              Tab(
                icon: Badge(
                    showBadge: true,
                    badgeContent: Text(uldCount.toString(),
                        style: const TextStyle(color: Colors.white)),
                    animationType: BadgeAnimationType.scale,
                    shape: BadgeShape.circle,
                    alignment: Alignment.topRight,
                    //position: BadgePosition.center(),
                    // child: const Icon(Icons),
                    child: Text(
                      "ULD   ",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(widget.flightLoading + " -> " + widget.flightUnLoading),
            SizedBox(
              width: 2,
            ),
            Align(
                alignment: Alignment.topRight,
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white10.withOpacity(0.4),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    //color: Colors.cyanAccent,
                    child: GestureDetector(
                      onTap: (() => {
                            if (addText.text.contains("Bulk"))
                              {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        CreateManifestBulk(
                                          isBulk: true,
                                        )))
                              }
                            else
                              {
                                //uldList() //Show existing uld list
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        CreateManifestBulk(
                                          isBulk: false,
                                        )))
                              }
                          }),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            this.addText.text,
                            style: TextStyle(fontSize: 17),
                          ),
                          Icon(
                            Icons.add,
                            size: 17,
                          )
                        ],
                      ),
                    )))
          ]),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            //BulkList(),
            //Icon(Icons.directions_transit),
            ListView(
              padding: EdgeInsets.only(top: 0, bottom: 0),
              children: new List<Widget>.generate(bulkList.length, (index) {
                return Container(
                  padding: EdgeInsets.all(8),
                  //transform: Matrix4.rotationZ(0.1),
                  width: MediaQuery.of(context).size.width,
                  child: Dismissible(
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
                                      // Emaildelete(e.id);
                                    },
                                    child: Text(
                                      // BuildContext context,
                                      S.of(context).Delete,
                                      //"Delete",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    )),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text(
                                    S.of(context).Cancel,
                                    //"Cancel",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        //_displayDialog(context);
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
                                //'Delete',
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
                          //textDirection: TextDirection.rtl,
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
                    key: ValueKey(e),
                    child: Card(
                      // color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color:
                                Theme.of(context).accentColor.withOpacity(0.5),
                            width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(10.0),
                        child: ExpansionTile(
                          textColor: Colors.black,
                          title: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          bulkList[index][
                                                  'FFM_AWB_Identification_AirlinePrefix'] +
                                              "-" +
                                              bulkList[index][
                                                  'FFM_AWB_Identification_AWB_SerialNumber'],
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    SizedBox(
                                      width: 13,
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: Colors.greenAccent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(05)),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            "Manifest",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black),
                                          ),
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      bulkList[index]['FFM_AirportCode_Origin'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      width: 02,
                                    ),
                                    Icon(Icons.flight_takeoff_outlined,
                                        color: Colors.amber),
                                    SizedBox(
                                      width: 02,
                                    ),
                                    //DEST
                                    Text(
                                      bulkList[index]
                                          ['FFM_AirportCode_Destination'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      bulkList[index][
                                          'FFM_Consignment_Detail_NatureOfGoods'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "pcs/Totpcs",
                                              style: TextStyle(
                                                  fontSize: 09,
                                                  fontWeight: FontWeight.w400,
                                                  color: Theme.of(context)
                                                      .accentColor),
                                            ),
                                            Text(
                                              bulkList[index][
                                                      'FFM_Consignment_Detail_NumberOfPieces'] +
                                                  "/",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "Wgt/TotWgt",
                                              style: TextStyle(
                                                  fontSize: 09,
                                                  fontWeight: FontWeight.w400,
                                                  color: Theme.of(context)
                                                      .accentColor),
                                            ),
                                            Text(
                                              bulkList[index][
                                                      'FFM_Consignment_Detail_Quantity_Detail_Weight'] +
                                                  "/" +
                                                  "Kg",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Special Handling",
                                          style: TextStyle(
                                              fontSize: 09,
                                              fontWeight: FontWeight.w400,
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        Text(
                                          "PER",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "P/D/S",
                                          style: TextStyle(
                                              fontSize: 09,
                                              fontWeight: FontWeight.w400,
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        Text(
                                          "NONE",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          bulkList[index][
                                                  'FFM_Consignment_Detail_VolumeAmount']
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          bulkList[index][
                                              'FFM_Consignment_Detail_VolumeCode'],
                                          style: TextStyle(
                                              fontSize: 09,
                                              fontWeight: FontWeight.w400,
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          trailing: Icon(
                            _customTileExpanded
                                ? Icons.arrow_drop_down
                                : Icons.info,
                            color: Theme.of(context).accentColor,
                          ),
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Onward",
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                          Text(
                                            "NRT / JL",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Shipping Bill Number",
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                          Text(
                                            bulkList[index]
                                                ['RT_ShippingBillNo'],
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Scan Type",
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                          Text(
                                            bulkList[index]['RT_ScanType'],
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Manifest Remarks ",
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                          Text(
                                            bulkList[index]
                                                ['RT_ManifestRemarks'],
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Office Use Remarks",
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                          Text(
                                            bulkList[index]
                                                ['RT_ForOfficeUseRemarks'],
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Internal Remarks",
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                          Text(
                                            bulkList[index]
                                                ['RT_InternalRemarks'],
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Physical Verification",
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                          Text(
                                            bulkList[index]
                                                ['RT_PhysicalVerification'],
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Scanned Indicator",
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                          Text(
                                            bulkList[index]
                                                ['RT_Scanned_Indicator'],
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onExpansionChanged: (bool expanded) {
                            setState(() => _customTileExpanded = expanded);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            ListView(
                padding: EdgeInsets.only(top: 0, bottom: 0),
                children: new List<Widget>.generate(uldList.length, (uldindex) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    //transform: Matrix4.rotationZ(0.1),
                    width: MediaQuery.of(context).size.width,
                    child: Dismissible(
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
                                  S
                                      .of(context)
                                      .Areyousureyouwanttodeletethisitem,
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                  //"Are you sure you want to delete this item?"
                                ),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                        // Emaildelete(e.id);
                                      },
                                      child: Text(
                                        // BuildContext context,
                                        S.of(context).Delete,
                                        //"Delete",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor),
                                      )),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text(
                                      S.of(context).Cancel,
                                      //"Cancel",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          //_displayDialog(context);
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
                                  //'Delete',
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
                            //textDirection: TextDirection.rtl,
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
                      key: ValueKey(e),
                      child: Column(children: [
                        Container(
                            padding: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              // color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.5),
                                    width: 3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: ClipRRect(
                                clipBehavior: Clip.hardEdge,
                                borderRadius: BorderRadius.circular(10.0),
                                child: ExpansionTile(
                                  textColor: Colors.black,
                                  title: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                  uldList[uldindex]
                                                              ['Consignment_details']
                                                          [0]['ULD_Type'] +
                                                      uldList[uldindex]
                                                              ['Consignment_details'][0]
                                                          [
                                                          'ULD_Serial_Number'] +
                                                      uldList[uldindex]
                                                              ['Consignment_details']
                                                          [0]['ULD_Owner_Code'],
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            SizedBox(
                                              width: 13,
                                            ),
                                            Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  color: Colors.greenAccent,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(05)),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "Manifest ULD",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.black),
                                                  ),
                                                ))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "T.AWB",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      //fontWeight: FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .accentColor),
                                                ),
                                                Text(
                                                  " 2",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "T.Pieces",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      //fontWeight: FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .accentColor),
                                                ),
                                                Text(
                                                  " 5",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "T.Wight",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      //fontWeight: FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .accentColor),
                                                ),
                                                Text(
                                                  " 450.0 K",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: Icon(
                                    _uldCustomTileExpanded
                                        ? Icons.arrow_downward_outlined
                                        : Icons.arrow_forward_ios_sharp,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  children: new List<Widget>.generate(
                                      uldList[uldindex]['Consignment_details']
                                          .length, (index) {
                                    var conssignment = uldList[uldindex]
                                        ['Consignment_details'];
                                    print("Consgnemet Details"
                                        '$conssignment');
                                    //return Text(index.toString());
                                    return Container(
                                      padding: EdgeInsets.only(top: 10),
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      child: Card(
                                        // color: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .dividerColor
                                                  .withOpacity(0.5),
                                              width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: ClipRRect(
                                          clipBehavior: Clip.hardEdge,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: ExpansionTile(
                                            textColor: Colors.black,
                                            title: Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                            conssignment[index][
                                                                    'FFM_AWB_Identification_AirlinePrefix'] +
                                                                "-" +
                                                                conssignment[
                                                                        index][
                                                                    'FFM_AWB_Identification_AWB_SerialNumber'],
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                      SizedBox(
                                                        width: 13,
                                                      ),
                                                      Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            color: Colors
                                                                .greenAccent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            05)),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5.0),
                                                            child: Text(
                                                              "Manifest",
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        conssignment[index][
                                                            'FFM_AirportCode_Origin'],
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      SizedBox(
                                                        width: 02,
                                                      ),
                                                      Icon(
                                                          Icons
                                                              .flight_takeoff_outlined,
                                                          color: Colors.amber),
                                                      SizedBox(
                                                        width: 02,
                                                      ),
                                                      //DEST
                                                      Text(
                                                        conssignment[index][
                                                            'FFM_AirportCode_Destination'],
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        conssignment[index][
                                                            'FFM_Consignment_Detail_NatureOfGoods'],
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "pcs/Totpcs",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        09,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .accentColor),
                                                              ),
                                                              Text(
                                                                conssignment[
                                                                            index]
                                                                        [
                                                                        'FFM_Consignment_Detail_NumberOfPieces'] +
                                                                    "/",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Text(
                                                                "Wgt/TotWgt",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        09,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .accentColor),
                                                              ),
                                                              Text(
                                                                conssignment[
                                                                            index]
                                                                        [
                                                                        'FFM_Consignment_Detail_Quantity_Detail_Weight'] +
                                                                    " Kg",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Special Handling",
                                                            style: TextStyle(
                                                                fontSize: 09,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Theme.of(
                                                                        context)
                                                                    .accentColor),
                                                          ),
                                                          Text(
                                                            conssignment[index][
                                                                'FFM_Consignment_Detail_Special_Handling_Code1'],
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            "P/D/S",
                                                            style: TextStyle(
                                                                fontSize: 09,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Theme.of(
                                                                        context)
                                                                    .accentColor),
                                                          ),
                                                          Text(
                                                            "PART",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            conssignment[index][
                                                                    'FFM_Consignment_Detail_VolumeAmount']
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            "MC",
                                                            style: TextStyle(
                                                                fontSize: 09,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Theme.of(
                                                                        context)
                                                                    .accentColor),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            trailing: Icon(
                                              _customTileExpanded
                                                  ? Icons.arrow_drop_down
                                                  : Icons.info,
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                            child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Onward",
                                                              style: TextStyle(
                                                                  fontSize: 9,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .accentColor),
                                                            ),
                                                            Text(
                                                              "NRT / JL",
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                        Expanded(
                                                            child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Shipping Bill Number",
                                                              style: TextStyle(
                                                                  fontSize: 9,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .accentColor),
                                                            ),
                                                            Text(
                                                              conssignment[
                                                                      index][
                                                                  'RT_ShippingBillNo'],
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                        Expanded(
                                                            child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Scan Type",
                                                              style: TextStyle(
                                                                  fontSize: 9,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .accentColor),
                                                            ),
                                                            Text(
                                                              conssignment[
                                                                      index][
                                                                  'RT_ScanType'],
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: <Widget>[
                                                        Expanded(
                                                            child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Manifest Remarks ",
                                                              style: TextStyle(
                                                                  fontSize: 9,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .accentColor),
                                                            ),
                                                            Text(
                                                              conssignment[
                                                                      index][
                                                                  'RT_ManifestRemarks'],
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                        Expanded(
                                                            child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Office Use Remarks",
                                                              style: TextStyle(
                                                                  fontSize: 9,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .accentColor),
                                                            ),
                                                            Text(
                                                              conssignment[
                                                                      index][
                                                                  'RT_ForOfficeUseRemarks'],
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                        Expanded(
                                                            child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Internal Remarks",
                                                              style: TextStyle(
                                                                  fontSize: 9,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .accentColor),
                                                            ),
                                                            Text(
                                                              conssignment[
                                                                      index][
                                                                  'RT_InternalRemarks'],
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                            child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Physical Verification",
                                                              style: TextStyle(
                                                                  fontSize: 9,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .accentColor),
                                                            ),
                                                            Text(
                                                              conssignment[
                                                                      index][
                                                                  'RT_PhysicalVerification'],
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                        Expanded(
                                                            child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Scanned Indicator",
                                                              style: TextStyle(
                                                                  fontSize: 9,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .accentColor),
                                                            ),
                                                            Text(
                                                              conssignment[
                                                                      index][
                                                                  'RT_Scanned_Indicator'],
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            onExpansionChanged:
                                                (bool expanded) {
                                              setState(() =>
                                                  _customTileExpanded =
                                                      expanded);
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  }),

                                  // Container(
                                  //   padding: EdgeInsets.only(top: 10),
                                  //   width:
                                  //       MediaQuery.of(context).size.width /
                                  //           1.2,
                                  //   child: Card(
                                  //     // color: Colors.blue,
                                  //     shape: RoundedRectangleBorder(
                                  //       side: BorderSide(
                                  //           color: Theme.of(context)
                                  //               .dividerColor
                                  //               .withOpacity(0.5),
                                  //           width: 1),
                                  //       borderRadius: BorderRadius.all(
                                  //           Radius.circular(10)),
                                  //     ),
                                  //     child: ClipRRect(
                                  //       clipBehavior: Clip.hardEdge,
                                  //       borderRadius:
                                  //           BorderRadius.circular(10.0),
                                  //       child: ExpansionTile(
                                  //         textColor: Colors.black,
                                  //         title: Container(
                                  //           child: Column(
                                  //             mainAxisAlignment:
                                  //                 MainAxisAlignment
                                  //                     .spaceBetween,
                                  //             children: [
                                  //               Row(
                                  //                 children: [
                                  //                   Align(
                                  //                     alignment:
                                  //                         Alignment.topLeft,
                                  //                     child: Text(
                                  //                         "618-27257053",
                                  //                         style: TextStyle(
                                  //                             fontSize: 20,
                                  //                             fontWeight:
                                  //                                 FontWeight
                                  //                                     .bold)),
                                  //                   ),
                                  //                   SizedBox(
                                  //                     width: 13,
                                  //                   ),
                                  //                   Container(
                                  //                       decoration:
                                  //                           BoxDecoration(
                                  //                         shape: BoxShape
                                  //                             .rectangle,
                                  //                         color: Colors
                                  //                             .greenAccent,
                                  //                         borderRadius: BorderRadius
                                  //                             .all(Radius
                                  //                                 .circular(
                                  //                                     05)),
                                  //                       ),
                                  //                       child: Padding(
                                  //                         padding:
                                  //                             EdgeInsets
                                  //                                 .all(5.0),
                                  //                         child: Text(
                                  //                           "Manifest",
                                  //                           style: TextStyle(
                                  //                               fontSize:
                                  //                                   10,
                                  //                               color: Colors
                                  //                                   .black),
                                  //                         ),
                                  //                       ))
                                  //                 ],
                                  //               ),
                                  //               SizedBox(
                                  //                 height: 4,
                                  //               ),
                                  //               Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment
                                  //                         .spaceEvenly,
                                  //                 children: [
                                  //                   Text(
                                  //                     "HKG",
                                  //                     style: TextStyle(
                                  //                         fontSize: 18,
                                  //                         fontWeight:
                                  //                             FontWeight
                                  //                                 .w500),
                                  //                   ),
                                  //                   SizedBox(
                                  //                     width: 02,
                                  //                   ),
                                  //                   Icon(
                                  //                       Icons
                                  //                           .flight_takeoff_outlined,
                                  //                       color:
                                  //                           Colors.amber),
                                  //                   SizedBox(
                                  //                     width: 02,
                                  //                   ),
                                  //                   //DEST
                                  //                   Text(
                                  //                     "NRT",
                                  //                     style: TextStyle(
                                  //                         fontSize: 18,
                                  //                         fontWeight:
                                  //                             FontWeight
                                  //                                 .w500),
                                  //                   ),
                                  //                   SizedBox(
                                  //                     width: 10,
                                  //                   ),
                                  //                   Text(
                                  //                     "FURNITURE",
                                  //                     style: TextStyle(
                                  //                         fontSize: 16,
                                  //                         fontWeight:
                                  //                             FontWeight
                                  //                                 .w400),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //               SizedBox(
                                  //                 height: 4,
                                  //               ),
                                  //               Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment
                                  //                         .spaceBetween,
                                  //                 children: [
                                  //                   Row(
                                  //                     children: [
                                  //                       Column(
                                  //                         crossAxisAlignment:
                                  //                             CrossAxisAlignment
                                  //                                 .start,
                                  //                         children: [
                                  //                           Text(
                                  //                             "pcs/Totpcs",
                                  //                             style: TextStyle(
                                  //                                 fontSize:
                                  //                                     09,
                                  //                                 fontWeight:
                                  //                                     FontWeight
                                  //                                         .w400,
                                  //                                 color: Theme.of(
                                  //                                         context)
                                  //                                     .accentColor),
                                  //                           ),
                                  //                           Text(
                                  //                             "5/7",
                                  //                             style:
                                  //                                 TextStyle(
                                  //                               fontWeight:
                                  //                                   FontWeight
                                  //                                       .w500,
                                  //                               fontSize:
                                  //                                   15,
                                  //                             ),
                                  //                           ),
                                  //                         ],
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                   Row(
                                  //                     children: [
                                  //                       Column(
                                  //                         children: [
                                  //                           Text(
                                  //                             "Wgt/TotWgt",
                                  //                             style: TextStyle(
                                  //                                 fontSize:
                                  //                                     09,
                                  //                                 fontWeight:
                                  //                                     FontWeight
                                  //                                         .w400,
                                  //                                 color: Theme.of(
                                  //                                         context)
                                  //                                     .accentColor),
                                  //                           ),
                                  //                           Text(
                                  //                             "450/800 Kg",
                                  //                             style:
                                  //                                 TextStyle(
                                  //                               fontWeight:
                                  //                                   FontWeight
                                  //                                       .w500,
                                  //                               fontSize:
                                  //                                   15,
                                  //                             ),
                                  //                           ),
                                  //                         ],
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //               SizedBox(
                                  //                 height: 4,
                                  //               ),
                                  //               Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment
                                  //                         .spaceBetween,
                                  //                 children: [
                                  //                   Column(
                                  //                     crossAxisAlignment:
                                  //                         CrossAxisAlignment
                                  //                             .start,
                                  //                     children: [
                                  //                       Text(
                                  //                         "Special Handling",
                                  //                         style: TextStyle(
                                  //                             fontSize: 09,
                                  //                             fontWeight:
                                  //                                 FontWeight
                                  //                                     .w400,
                                  //                             color: Theme.of(
                                  //                                     context)
                                  //                                 .accentColor),
                                  //                       ),
                                  //                       Text(
                                  //                         "SPX",
                                  //                         style: TextStyle(
                                  //                             fontSize: 15,
                                  //                             fontWeight:
                                  //                                 FontWeight
                                  //                                     .w500),
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                   Column(
                                  //                     children: [
                                  //                       Text(
                                  //                         "P/D/S",
                                  //                         style: TextStyle(
                                  //                             fontSize: 09,
                                  //                             fontWeight:
                                  //                                 FontWeight
                                  //                                     .w400,
                                  //                             color: Theme.of(
                                  //                                     context)
                                  //                                 .accentColor),
                                  //                       ),
                                  //                       Text(
                                  //                         "PART",
                                  //                         style: TextStyle(
                                  //                             fontSize: 15,
                                  //                             fontWeight:
                                  //                                 FontWeight
                                  //                                     .w500),
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                   Row(
                                  //                     children: [
                                  //                       Text(
                                  //                         "1.0",
                                  //                         style: TextStyle(
                                  //                             fontSize: 15,
                                  //                             fontWeight:
                                  //                                 FontWeight
                                  //                                     .w500),
                                  //                       ),
                                  //                       Text(
                                  //                         "MC",
                                  //                         style: TextStyle(
                                  //                             fontSize: 09,
                                  //                             fontWeight:
                                  //                                 FontWeight
                                  //                                     .w400,
                                  //                             color: Theme.of(
                                  //                                     context)
                                  //                                 .accentColor),
                                  //                       ),
                                  //                     ],
                                  //                   )
                                  //                 ],
                                  //               )
                                  //             ],
                                  //           ),
                                  //         ),
                                  //         trailing: Icon(
                                  //           _customTileExpanded
                                  //               ? Icons.arrow_drop_down
                                  //               : Icons.info,
                                  //           color: Theme.of(context)
                                  //               .accentColor,
                                  //         ),
                                  //         children: <Widget>[
                                  //           Container(
                                  //             padding: EdgeInsets.all(8.0),
                                  //             child: Column(
                                  //               children: [
                                  //                 Row(
                                  //                   children: <Widget>[
                                  //                     Expanded(
                                  //                         child: Column(
                                  //                       crossAxisAlignment:
                                  //                           CrossAxisAlignment
                                  //                               .start,
                                  //                       children: [
                                  //                         Text(
                                  //                           "Onward",
                                  //                           style: TextStyle(
                                  //                               fontSize:
                                  //                                   13,
                                  //                               color: Theme.of(
                                  //                                       context)
                                  //                                   .accentColor),
                                  //                         ),
                                  //                         Text(
                                  //                           "NRT / JL",
                                  //                           style:
                                  //                               TextStyle(
                                  //                             fontSize: 18,
                                  //                           ),
                                  //                         ),
                                  //                       ],
                                  //                     )),
                                  //                     Expanded(
                                  //                         child: Column(
                                  //                       crossAxisAlignment:
                                  //                           CrossAxisAlignment
                                  //                               .start,
                                  //                       children: [
                                  //                         Text(
                                  //                           "Shipping Bill Number",
                                  //                           style: TextStyle(
                                  //                               fontSize:
                                  //                                   13,
                                  //                               color: Theme.of(
                                  //                                       context)
                                  //                                   .accentColor),
                                  //                         ),
                                  //                         Text(
                                  //                           "20202021",
                                  //                           style:
                                  //                               TextStyle(
                                  //                             fontSize: 18,
                                  //                           ),
                                  //                         ),
                                  //                       ],
                                  //                     )),
                                  //                     Expanded(
                                  //                         child: Column(
                                  //                       crossAxisAlignment:
                                  //                           CrossAxisAlignment
                                  //                               .start,
                                  //                       children: [
                                  //                         Text(
                                  //                           "Scan Type",
                                  //                           style: TextStyle(
                                  //                               fontSize:
                                  //                                   13,
                                  //                               color: Theme.of(
                                  //                                       context)
                                  //                                   .accentColor),
                                  //                         ),
                                  //                         Text(
                                  //                           "X-RAY",
                                  //                           style:
                                  //                               TextStyle(
                                  //                             fontSize: 18,
                                  //                           ),
                                  //                         ),
                                  //                       ],
                                  //                     )),
                                  //                   ],
                                  //                 ),
                                  //                 Row(
                                  //                   mainAxisAlignment:
                                  //                       MainAxisAlignment
                                  //                           .spaceAround,
                                  //                   children: <Widget>[
                                  //                     Expanded(
                                  //                         child: Column(
                                  //                       crossAxisAlignment:
                                  //                           CrossAxisAlignment
                                  //                               .start,
                                  //                       children: [
                                  //                         Text(
                                  //                           "Manifest Remarks ",
                                  //                           style: TextStyle(
                                  //                               fontSize:
                                  //                                   13,
                                  //                               color: Theme.of(
                                  //                                       context)
                                  //                                   .accentColor),
                                  //                         ),
                                  //                         Text(
                                  //                           "CLEARED",
                                  //                           style:
                                  //                               TextStyle(
                                  //                             fontSize: 18,
                                  //                           ),
                                  //                         ),
                                  //                       ],
                                  //                     )),
                                  //                     Expanded(
                                  //                         child: Column(
                                  //                       crossAxisAlignment:
                                  //                           CrossAxisAlignment
                                  //                               .start,
                                  //                       children: [
                                  //                         Text(
                                  //                           "Office Use Remarks",
                                  //                           style: TextStyle(
                                  //                               fontSize:
                                  //                                   13,
                                  //                               color: Theme.of(
                                  //                                       context)
                                  //                                   .accentColor),
                                  //                         ),
                                  //                         Text(
                                  //                           "VIP SHIPPER",
                                  //                           style:
                                  //                               TextStyle(
                                  //                             fontSize: 18,
                                  //                           ),
                                  //                         ),
                                  //                       ],
                                  //                     )),
                                  //                     Expanded(
                                  //                         child: Column(
                                  //                       crossAxisAlignment:
                                  //                           CrossAxisAlignment
                                  //                               .start,
                                  //                       children: [
                                  //                         Text(
                                  //                           "Internal Remarks",
                                  //                           style: TextStyle(
                                  //                               fontSize:
                                  //                                   13,
                                  //                               color: Theme.of(
                                  //                                       context)
                                  //                                   .accentColor),
                                  //                         ),
                                  //                         Text(
                                  //                           "CREDIT ",
                                  //                           style:
                                  //                               TextStyle(
                                  //                             fontSize: 18,
                                  //                           ),
                                  //                         ),
                                  //                       ],
                                  //                     )),
                                  //                   ],
                                  //                 ),
                                  //                 Row(
                                  //                   children: <Widget>[
                                  //                     Expanded(
                                  //                         child: Column(
                                  //                       crossAxisAlignment:
                                  //                           CrossAxisAlignment
                                  //                               .start,
                                  //                       children: [
                                  //                         Text(
                                  //                           "Physical Verification",
                                  //                           style: TextStyle(
                                  //                               fontSize:
                                  //                                   13,
                                  //                               color: Theme.of(
                                  //                                       context)
                                  //                                   .accentColor),
                                  //                         ),
                                  //                         Text(
                                  //                           "No",
                                  //                           style:
                                  //                               TextStyle(
                                  //                             fontSize: 18,
                                  //                           ),
                                  //                         ),
                                  //                       ],
                                  //                     )),
                                  //                     Expanded(
                                  //                         child: Column(
                                  //                       crossAxisAlignment:
                                  //                           CrossAxisAlignment
                                  //                               .start,
                                  //                       children: [
                                  //                         Text(
                                  //                           "Scanned Indicator",
                                  //                           style: TextStyle(
                                  //                               fontSize:
                                  //                                   13,
                                  //                               color: Theme.of(
                                  //                                       context)
                                  //                                   .accentColor),
                                  //                         ),
                                  //                         Text(
                                  //                           "Yes",
                                  //                           style:
                                  //                               TextStyle(
                                  //                             fontSize: 18,
                                  //                           ),
                                  //                         ),
                                  //                       ],
                                  //                     )),
                                  //                   ],
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         ],
                                  //         onExpansionChanged:
                                  //             (bool expanded) {
                                  //           setState(() =>
                                  //               _customTileExpanded =
                                  //                   expanded);
                                  //         },
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: 8,
                                  // )

                                  onExpansionChanged: (bool expanded) {
                                    setState(() =>
                                        _uldCustomTileExpanded = expanded);
                                  },
                                ),
                              ),
                            )),
                      ]),
                    ),
                  );
                })),
          ],
        ),
      ),
    );
  }
}
