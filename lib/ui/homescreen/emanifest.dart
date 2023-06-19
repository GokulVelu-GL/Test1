import 'dart:convert';
import 'package:rooster/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:rooster/ui/homescreen/Manifest/show_BulkandUld.dart';
import '../../formatter.dart';
import 'package:provider/provider.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/emanifest_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EManifestFFM extends StatefulWidget {
  EManifestFFM({Key key}) : super(key: key);

  @override
  _EManifestFFMState createState() => _EManifestFFMState();
}

class _EManifestFFMState extends State<EManifestFFM> {
  var _expand = false;

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
                builder: (BuildContext context) => ManifestPage()));
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
                            "assets/homescreen/emanifest.webp"
                              //"https://cdn0.iconfinder.com/data/icons/freebies-2/24/warehouse-storage-3-128.png"
                          ),
                          // "https://cdn2.iconfinder.com/data/icons/delivery-and-shipping-2/64/package_delivery_manifest_document-512.png"),
                        ),
                        SizedBox(
                          height: 05,
                        ),
                        Text(
                          S.of(context).eManifest,
                          //"eManifest (FFM)",
                          textAlign: TextAlign.center,
                          //textDirection: TextDirection.ltr,
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

class ManifestPage extends StatefulWidget {
  //String segemnt;
  int flightId;
  String flightLoading;
  String flightOnLoading;
  String flightNo;
  var date;
  var flightList;
  // var segement="176";
  ManifestPage(
      {Key key,
      this.flightId,
      this.flightLoading,
      this.flightOnLoading,
      this.flightNo,
      this.date,
      this.flightList})
      : super(key: key);

  @override
  State<ManifestPage> createState() => _ManifestPageState();
}

class _ManifestPageState extends State<ManifestPage> {
  final List<ExpenseList> expenseList = [];
  final _formKey = GlobalKey<FormState>();

  String flightNo;
  String dateTime;
  String segement = "176";
  String name = '';
  String airline;
  String masterAWB;
  String origin;
  String destination;
  String pieces;
  String totalpieces;

  String weight;
  String totalweight;
  String weightUnit = 'K';
  String mash;
  String DG;
  String MC;
  String nature_of_goods;
  String volume;
  String uldtype;
  String uldno;

  String volumeUnit = "MC";

  final TextEditingController destinationController = TextEditingController();
  final TextEditingController originController = TextEditingController();
  final TextEditingController masterController = TextEditingController();
  final TextEditingController airlineController = TextEditingController();
  TextEditingController dateController = new TextEditingController(
    text: DateFormat('dd-MM-yyyy').format(DateTime.now()),
  );
  TextEditingController flightNoCtrl = new TextEditingController();

  void refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(Uri.parse(StringData.refreshTokenAPI),
        headers: {'x-access-tokens': prefs.getString('token')});
    var result = json.decode(response.body);
    if (result['result'] == 'verified')
      prefs.setString('token', result['token']);
    print(result);
  }

  Future<dynamic> getManifestList(
      int id, String flightLoading, String flightUnloading) async {
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
      "FFM_PointOfLoading_AirportCode": flightLoading,
      "FFM_PointOfUnLoading_AirportCode": flightUnloading
    });
    result = await request.send();

    final respStr = await result.stream.bytesToString();
    result = jsonDecode(respStr);
    //result = json.decode(response);
    if (result['message'] == 'token expired') {
      refreshToken();
      getManifestList(id, flightLoading, flightUnloading);
    } else {
      //getAWBlist();
      print(prefs.getString('token'));
    }
    print("Manifest List Details " + '${result}');
    return result["manifest"];
  }

  @override
  void initState() {
    // TODO: implement initState
    flightNoCtrl.text =
        widget.flightNo.toString() == null ? "" : widget.flightNo.toString();
    dateController.text = widget.date;
    super.initState();
  }

  // List<String> text = [];
  @override
  Widget build(BuildContext context) {
    //text.add(widget.segement);
    return Consumer<ManifestModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: Text(
            "Manifest",
          ),
        ),
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: flightNoCtrl,
                        onChanged: ((value) {
                          if (value.isEmpty) {
                            return "Flight no can't be empty";
                          }
                          flightNo = value;
                        }),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Theme.of(context).accentColor,
                                  // color: Colors.deepPurple,
                                  width: 1),
                              //gapPadding: 2.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context).accentColor,
                              // color: Colors.deepPurple
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Flight',
                          labelStyle: new TextStyle(
                              color: Theme.of(context).accentColor,
                              // color: Colors.deepPurple,
                              fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: dateController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Theme.of(context).accentColor,
                                  // color: Colors.deepPurple,
                                  width: 1),
                              //gapPadding: 2.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context).accentColor,
                              //  color: Colors.deepPurple
                            ),
                          ),
                          labelText: "Date ",
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
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
                                          onPrimary:
                                              Colors.black, // header text color
                                          onSurface:
                                              Colors.black, // body text color

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
                              dateController.text =
                                  DateFormat.yMMMMd().format(selectedDate);
                              dateTime =
                                  DateFormat('dd-MM-yyyy').format(selectedDate);
                              //dateController.text = DateFormat('dd-MM-yyyy').add_jms().format(selectedDate);
                              print(dateController.text);
                            }
                          });

                          dateController.text = date.toIso8601String();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary:
                              Theme.of(context).accentColor, // Background color
                        ),
                        onPressed: () async {
                          EasyLoading.show(status: 'Please wait...');
                          var result =
                              model.getFlight(flightNo, flightNo, dateTime);
                          // ignore: unrelated_type_equality_checks
                          if (result.toString().contains("true"))
                            EasyLoading.showSuccess('Success!');
                          else
                            EasyLoading.showError('Faild!');
                          await Future.delayed(Duration(seconds: 1));
                          EasyLoading.dismiss();
                          print("Flight");
                        },
                        child: Text("Search")),
                  ),
                ],
              ),
              // Card(
              //   child: Row(
              //     children: <Widget>[
              //       Expanded(
              //           child: ListTile(
              //         title: Text(
              //           "Flight",
              //           style: TextStyle(color: Theme.of(context).accentColor),
              //         ),
              //         subtitle: Text(
              //           "IX333",
              //           style: TextStyle(
              //             color: Colors.black,
              //           ),
              //         ),
              //       )),
              //       Expanded(
              //           child: ListTile(
              //         title: Text(
              //           "Date",
              //           style: TextStyle(color: Theme.of(context).accentColor),
              //         ),
              //         subtitle: Text(
              //           "10 May 2022",
              //           style: TextStyle(
              //             color: Colors.black,
              //           ),
              //         ),
              //       )),
              //       Expanded(
              //           child: ListTile(
              //         title: Text(
              //           "Aircraft Reg",
              //           style: TextStyle(color: Theme.of(context).accentColor),
              //         ),
              //         subtitle: Text(
              //           "9VSSD",
              //           style: TextStyle(
              //             color: Colors.black,
              //           ),
              //         ),
              //       )),
              //     ],
              //   ),
              // ),
              // Card(
              //   child: ListTile(
              //     title: Text("Routing"),
              //     subtitle: Text("MAA->HKG->NRT"),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       TextButton.icon(
              //         icon: Icon(
              //           Icons.add_box_outlined,
              //           color: Theme.of(context).backgroundColor,
              //         ),
              //         style: ButtonStyle(
              //             backgroundColor: MaterialStateProperty.all(
              //                 Theme.of(context).accentColor)),
              //         // onPressed: () async {
              //         //   final name = await _displayDialog(context);
              //         //   if (name == null || name.isEmpty) return;
              //         //   setState(() {
              //         //     this.name = name;
              //         //   });
              //         // },
              //         onPressed: () {
              //           Navigator.of(context).push(MaterialPageRoute(
              //               builder: (BuildContext context) =>
              //                   CreateManifestBulk(
              //                     isBulk: true,
              //                   )));
              //         },
              //         label: Text(
              //           "BULK AWBs",
              //           style:
              //               TextStyle(color: Theme.of(context).backgroundColor),
              //         ),
              //       ),
              //       TextButton.icon(
              //         icon: Icon(Icons.add_box_outlined,
              //             color: Theme.of(context).backgroundColor),
              //         style: ButtonStyle(
              //             backgroundColor: MaterialStateProperty.all(
              //                 Theme.of(context).accentColor)),
              //         onPressed: () {
              //           Navigator.of(context).push(MaterialPageRoute(
              //               builder: (BuildContext context) =>
              //                   CreateManifestBulk(
              //                     isBulk: false,
              //                   )));
              //         },
              //         label: Text(
              //           "ULD AWBs",
              //           style:
              //               TextStyle(color: Theme.of(context).backgroundColor),
              //         ),
              //       )
              //     ],
              //   ),
              // ),

              // Center(
              //   child: FutureBuilder<dynamic>(
              //     future: getManifestList(widget.flightId, widget.flightLoading,
              //         widget.flightOnLoading),
              //     builder: (context, snapshot) {
              //       if (snapshot.hasData) {
              //         return GetManifestList(
              //           manifestList: snapshot.data,
              //           flightLoading: widget.flightLoading,
              //           flightUnloading: widget.flightOnLoading,
              //         );
              //       } else if (snapshot.hasError) {
              //         return Text(S.of(context).DataNotFound
              //             // "Data Not Found"
              //             );
              //       }
              //       // By default, show a loading spinner
              //       return CircularProgressIndicator();
              //       //return EasyLoading.show();
              //     },
              //   ),
              // ),

              Column(
                children: new List<Widget>.generate(widget.flightList.length,
                    (index) {
                  return GestureDetector(
                    onTap: () {
                      // bulkLits = manifestList["Bulk_Consignment_details"];
                      // print(bulkLits);
                      // uldList = manifestList["ULD_Consignment_details"];
                      // print(uldList);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              BulkandUldListloader(
                                flightId: widget.flightId,
                                flightLoading: widget.flightLoading,
                                flightUnLoading: widget.flightList[index],
                              )));
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.5),
                                width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0, top: 8),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(widget.flightLoading,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Icon(Icons.flight_takeoff_outlined,
                                          color: Colors.amber),
                                      Text(widget.flightList[index],
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color:
                                                Theme.of(context).accentColor,
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
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "-",
                                            //uldList.length.toString(),
                                            style: TextStyle(
                                                //color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "ULD ",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Theme.of(context)
                                                    .accentColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "-",
                                            style: TextStyle(
                                                //color: Colors.black,
                                                // color: Theme.of(context).accentColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Loose Cargo ",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Theme.of(context)
                                                    .accentColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Column(children: [
                                            Text(
                                              "-",
                                              //uldList.length.toString(),
                                              style: TextStyle(
                                                  //color: Colors.black,
                                                  // color: Theme.of(context).accentColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "Cargo in ULD ",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ])
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "-",
                                                style: TextStyle(
                                                    //  color: Colors.black,
                                                    // color: Theme.of(context).accentColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "Pieces ",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        children: [
                                          Column(children: [
                                            Text(
                                              "-",
                                              style: TextStyle(
                                                  // color: Colors.black,
                                                  // color: Theme.of(context).accentColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "Weight ",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ])
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      );
    });
  }

  _displayDialog(BuildContext context) {
    // showGeneralDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   transitionDuration: Duration(milliseconds: 2000),
    //   transitionBuilder: (context, animation, secondaryAnimation, child) {
    //     return FadeTransition(
    //       opacity: animation,
    //       child: ScaleTransition(
    //         scale: animation,
    //         child: child,
    //       ),
    //     );
    //   },
    //   pageBuilder: (context, animation, secondaryAnimation) {
    //     return
    //   },
    // );
  }

  void addEmail(
      String description,
      String airline,
      String serialNumber,
      String origin,
      String dest,
      String pcs,
      String totalpcs,
      String weight,
      String totalweight,
      String weightunit,
      String mash,
      String DG,
      String volume,
      String volumeUnit,
      String Nature_Of_Goods,
      String Customs_Exam_Indicator,
      String Customs_Exam_OrderNo,
      String Customs_Exam_DateTime,
      String Scan_Type,
      String Internal_Remarks,
      String Manifest_Remarks,
      String Office_Use_Remarks) {
    final expense = ExpenseList(
        id: description,
        title: airline,
        serialNo: serialNumber,
        origin: origin,
        destination: dest,
        pieces: pcs,
        total_pieces: totalpcs,
        weight: weight,
        total_weight: totalweight,
        weight_unit: weightunit,
        mash: mash,
        DG: DG,
        volume: volume,
        volumeUnit: volumeUnit,
        Nature_Of_Goods: Nature_Of_Goods,
        Customs_Exam_Indicator: Customs_Exam_Indicator,
        Customs_Exam_OrderNo: Customs_Exam_OrderNo,
        Customs_Exam_DateTime: Customs_Exam_DateTime,
        Scan_Type: Scan_Type,
        Internal_Remarks: Internal_Remarks,
        Manifest_Remarks: Manifest_Remarks,
        Office_Use_Remarks: Office_Use_Remarks);
    setState(() {
      expenseList.add(expense);
    });
  }

  void Update(String title) {
    setState(() {
      expenseList.removeWhere((element) => element.id == title);
    });
  }

  void Emaildelete(String title) {
    setState(() {
      expenseList.removeWhere((element) => element.id == title);
    });
  }
}

class ExpenseList {
  String title;
  String id;
  String serialNo;
  String origin;
  String destination;
  String pieces;
  String total_pieces;
  String weight;
  String total_weight;
  String weight_unit;
  String mash;
  String DG;
  String volume;
  String volumeUnit;
  String Nature_Of_Goods;
  String Customs_Exam_Indicator;
  String Customs_Exam_OrderNo;
  String Customs_Exam_DateTime;
  String Scan_Type;
  String Internal_Remarks;
  String Manifest_Remarks;
  String Office_Use_Remarks;

  ExpenseList({
    @required this.title,
    @required this.id,
    @required this.serialNo,
    @required this.origin,
    @required this.destination,
    @required this.pieces,
    @required this.total_pieces,
    @required this.weight,
    @required this.total_weight,
    @required this.weight_unit,
    @required this.mash,
    @required this.DG,
    @required this.volume,
    @required this.volumeUnit,
    @required this.Nature_Of_Goods,
    @required this.Customs_Exam_Indicator,
    @required this.Customs_Exam_OrderNo,
    @required this.Customs_Exam_DateTime,
    @required this.Scan_Type,
    @required this.Internal_Remarks,
    @required this.Manifest_Remarks,
    @required this.Office_Use_Remarks,
  });
}

class GetManifestList extends StatefulWidget {
  var manifestList;
  String flightLoading;
  String flightUnloading;
  GetManifestList(
      {Key key, this.manifestList, this.flightLoading, this.flightUnloading})
      : super(key: key);

  @override
  _MyManifesttate createState() => _MyManifesttate();
}

class _MyManifesttate extends State<GetManifestList> {
  List bulkLits;
  List uldList;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.manifestList.length == 0
        ? Text(S.of(context).DataNotFound)
        : Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => BulkandUldList(
                            // bulkList: bulkLits,
                            // uldList: uldList,
                            flightLoading: widget.flightLoading,
                            flightUnLoading: widget.flightUnloading,
                          )));
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color:
                                Theme.of(context).accentColor.withOpacity(0.5),
                            width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0, top: 8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(widget.flightLoading,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Icon(Icons.flight_takeoff_outlined,
                                      color: Colors.amber),
                                  Text(widget.flightUnloading,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: Theme.of(context).accentColor,
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
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        uldList.length.toString(),
                                        style: TextStyle(
                                            //color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "ULD ",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Theme.of(context).accentColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "-",
                                        style: TextStyle(
                                            //color: Colors.black,
                                            // color: Theme.of(context).accentColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Loose Cargo ",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Theme.of(context).accentColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Column(children: [
                                        Text(
                                          uldList.length.toString(),
                                          style: TextStyle(
                                              //color: Colors.black,
                                              // color: Theme.of(context).accentColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Cargo in ULD ",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color:
                                                  Theme.of(context).accentColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ])
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "-",
                                            style: TextStyle(
                                                //  color: Colors.black,
                                                // color: Theme.of(context).accentColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Pieces ",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Theme.of(context)
                                                    .accentColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    children: [
                                      Column(children: [
                                        Text(
                                          "-",
                                          style: TextStyle(
                                              // color: Colors.black,
                                              // color: Theme.of(context).accentColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Weight ",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color:
                                                  Theme.of(context).accentColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ])
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
