import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../string.dart';
import 'package:http/http.dart' as http;
import 'linechart.dart';
import 'dart:math';
import 'package:collection/collection.dart';
import 'piechart.dart';

//import 'package:animated_text_kit/animated_text_kit.dart';

class HomeDashboard extends StatefulWidget {
  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  Color myHexColor = const Color(0xFFFFEBEE);
  static List<dynamic> awblistdata;

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
    //var response = await http.get(StringData.awblistAPI,
    //headers: {'x-access-tokens': prefs.getString('token')});
    //result = json.decode(response.body);

    //Alternative

    final url = Uri.parse(StringData.awblistAPI);
    final request = http.Request("GET", url);
    request.headers.addAll(<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-access-tokens': prefs.getString('token')
    });

    request.body = jsonEncode({
      //"FlightList_id": id, //40,
      //"Manifest_Version": 2,
      //"FFM_PointOfLoading_AirportCode": flightLoading,
      //"FFM_PointOfUnLoading_AirportCode": flightUnloading
    });
    result = await request.send();

    final respStr = await result.stream.bytesToString();
    result = jsonDecode(respStr);

    //Alternative

    if (result['message'] == 'token expired') {
      refreshToken();
      getAWBlist();
    } else {
      //getAWBlist();
      print(prefs.getString('token'));
    }
    print("AWB List Details " + '${result["awb"]}');
    awblistdata = result["awb"];
    return result["awb"];
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    // List<dynamic> awbList=getAWBlist() as List;
    print("Charttt");
    // print(awbList);
  }
  @override
  Widget build(BuildContext context) {
    //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Padding(
          padding: EdgeInsets.all(18.0),
          child: Text(
            "Drona - eAWB",
            style: TextStyle(
                //color: Colors.white,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ),
      ),
      // backgroundColor: Colors.white,
      //drawer: SideMenu(),

      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 15,
                  runSpacing: 10.0,
                  children: <Widget>[
                    //1 card
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: containerbox(
                              context,
                              "https://www.pngmart.com/files/10/User-Account-PNG-Photos.png",
                              //"https://cdn-icons-png.flaticon.com/512/3135/3135768.png",
                              "46",
                              S.of(context).User,
                              //"User",
                              // Colors.orange.shade300
                              Theme.of(context).accentColor),
                        ),

                        //2 card
                        // containerbox(
                        //     context,
                        //     "https://cdn-icons-png.flaticon.com/512/3135/3135768.png",
                        //     "48",
                        //     S.of(context).UniqueVisitors,
                        //     // "Unique\nVisitors",
                        //     Colors.blue),
                        //3 card
                        Align(
                          alignment: Alignment.topRight,
                          child: containerbox(
                              context,
                              "https://img.icons8.com/nolan/2x/link.png",
                              //  "https://cdn-icons-png.flaticon.com/512/1011/1011356.png",
                              "4/20",
                              S.of(context).Connections,
                              //"Connections",
                              // Colors.purple.shade300
                              Theme.of(context).accentColor),
                        ),
                        Card(
                          color: Theme.of(context).backgroundColor,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Container(
                              width: 60,
                              height: 125,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                // color: Colors.orange.shade300,
                                // image: DecorationImage(
                                //   colorFilter: ColorFilter.mode(
                                //       Colors.black.withOpacity(0.5), BlendMode.dstATop),
                                //   image: NetworkImage(
                                //       "https://ifatceg.com/wp-content/uploads/2021/03/72AC9CE1-F524-4778-80D7-9401ED743DDA.jpeg"
                                //       // "https://www.fmanet.org/wp-content/uploads/2015/07/water-image1.jpg",
                                //       ),
                                //   fit: BoxFit.cover,
                                // ),
                              ),
                              child: Center(
                                  child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          // SizedBox(
                                          //   height: 10,
                                          // ),
                                          Image(
                                            width: 45.0,
                                            color:
                                                Theme.of(context).accentColor,
                                            image: NetworkImage(
                                                "https://www.pngmart.com/files/10/User-Account-PNG-Photos.png"),
                                          ),
                                          SizedBox(
                                            height: 05,
                                          ),
                                          Text(
                                            "User",
                                            //"User Management",
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.ltr,
                                            style: TextStyle(
                                              //color: Colors.black,
                                              //fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),),
                                          SizedBox(height: 2,),
                                          Text(
                                            "2",
                                            //"User Management",
                                            textAlign: TextAlign.end,
                                            textDirection: TextDirection.ltr,
                                            style: TextStyle(
                                              //color: Colors.black,
                                              //fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )))),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Theme.of(context).backgroundColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8.0,
                                offset: Offset(0.0, 5.0),
                              ),
                            ],
                          ),
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              //Navigator.of(context).push(MaterialPageRoute(
                              //  builder: (BuildContext context) => DetailPage()));
                            },
                            child: ListTile(
                              // leading: Icon(
                              //   Icons.policy_outlined,
                              //   color: Theme.of(context).accentColor,
                              // ),
                              leading: Image(
                                width: 45.0,
                                color: Theme.of(context).accentColor,
                                image: NetworkImage(
                                    "https://img.icons8.com/ios/344/user--v1.png"
                                    //  "https://cdn-icons-png.flaticon.com/512/3135/3135768.png",
                                    //color: Theme.of(context).accentColor,
                                    ),
                              ),
                              title: Text(S.of(context).UniqueVisitors),
                              // subtitle: Text(
                              //     "Identifies the actual guiding principles"),
                              trailing: Text(
                                "48",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Theme.of(context).backgroundColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8.0,
                                offset: Offset(0.0, 5.0),
                              ),
                            ],
                          ),
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              //Navigator.of(context).push(MaterialPageRoute(
                              //  builder: (BuildContext context) => DetailPage()));
                            },
                            child: ListTile(
                              // leading: Icon(
                              //   Icons.policy_outlined,
                              //   color: Theme.of(context).accentColor,
                              // ),
                              leading: Image(
                                width: 45.0,
                                color: Theme.of(context).accentColor,
                                image: NetworkImage(
                                    "https://cdn.iconscout.com/icon/free/png-64/e-way-bill-1817367-1538235.png"
                                    //  "https://cdn-icons-png.flaticon.com/512/3135/3135768.png",
                                    //color: Theme.of(context).accentColor,
                                    ),
                              ),
                              // "https://cdn-icons-png.flaticon.com/512/4301/4301590.png",
                              title: Text(S.of(context).BookedAirwayBills),
                              // subtitle: Text(
                              //     "Identifies the actual guiding principles"),
                              trailing: Text(
                                "8",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          )),
                    ),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        // containerbox(
                        //     context,
                        //     "https://cdn-icons-png.flaticon.com/512/4301/4301590.png",
                        //     "5",
                        //     S.of(context).BookedAirwayBills,
                        //     //"Booked\nAirwayBills",
                        //     Colors.yellow.shade300),
                        containerbox(
                            context,
                            "https://img.icons8.com/dotty/2x/online.png",
                            // "https://cdn-icons-png.flaticon.com/512/3135/3135768.png",
                            "1",
                            S.of(context).Online,
                            //"Online",
                            Colors.green.shade300),
                        //6 card
                        containerbox(
                            context,
                            "https://img.icons8.com/ios-filled/2x/pivot-table.png",
                            // "https://cdn-icons-png.flaticon.com/512/1548/1548723.png",
                            "80",
                            S.of(context).Tables,
                            // "Tables",
                            Colors.pink.shade300),
                        //7 card
                        containerbox(
                            context,
                            "https://img.icons8.com/external-xnimrodx-lineal-xnimrodx/2x/external-flight-calendar-xnimrodx-lineal-xnimrodx.png",
                            // "https://cdn-icons.flaticon.com/png/128/5086/premium/5086864.png?token=exp=1645798626~hmac=ead32126940d8a839a82bd2701f4725a",
                            // "https://cdn-icons-png.flaticon.com/512/1544/1544388.png",
                            "17",
                            S.of(context).Flights,
                            //"Flights",
                            Colors.green.shade300),
                        //8 card
                        containerbox(
                            context,
                            "https://img.icons8.com/external-outline-wichaiwi/2x/external-bounce-rate-digital-marketing-outline-wichaiwi.png",
                            //  "https://cdn-icons-png.flaticon.com/512/2328/2328942.png",
                            "53",
                            S.of(context).BounceRate,
                            //"Bounce Rate",
                            Colors.deepPurpleAccent.shade200),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            PieChartSample2(),
             Container(
                 padding: EdgeInsets.only(left: 20,bottom: 10),
                 child: Center(child: Text("Trends",
                 style: TextStyle(
                   fontWeight: FontWeight.bold
                 ),
                 ))),
             LineCharts(),
            Container(
                padding: EdgeInsets.only(left: 20),
                child: Center(child: Text("Month")))
          ],
        ),
      )),
    );
  }

  Widget containerbox(BuildContext context, String imageUrl, String count,
      String bodytext, Color colors) {
    // return SizedBox(
    //   width: 120.0,
    //   height: 100.0,
    //   child: Card(
    //     // color: Color.fromARGB(255,21, 21, 21),
    //     elevation: 2.0,
    //     shape:
    //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    //     child: Container(
    //       // color: Colors.orange.shade300,
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(20),
    //         // color: Colors.orange.shade300,
    //         // image: DecorationImage(
    //         //   colorFilter: ColorFilter.mode(
    //         //       Colors.black.withOpacity(0.5), BlendMode.dstATop),
    //         //   image: NetworkImage(
    //         //       "https://ifatceg.com/wp-content/uploads/2021/03/72AC9CE1-F524-4778-80D7-9401ED743DDA.jpeg"
    //         //       // "https://www.fmanet.org/wp-content/uploads/2015/07/water-image1.jpg",
    //         //       ),
    //         //   fit: BoxFit.cover,
    //         // ),
    //       ),
    //       child: Center(
    //           child: Padding(
    //         padding: const EdgeInsets.all(4.0),
    //         child: Column(
    //           children: <Widget>[
    //             Image.network(
    //               imageUrl,
    //               width: 39.0,
    //               //color: Colors.white,
    //               fit: BoxFit.cover,
    //             ),
    //             Text(
    //               bodytext,
    //               textAlign: TextAlign.center,
    //               textDirection: TextDirection.ltr,
    //               style: TextStyle(
    //                   color: Theme.of(context).accentColor,
    //                   fontWeight: FontWeight.bold,
    //                   fontSize: 10.0),
    //             ),
    //             Padding(
    //                 padding: EdgeInsets.all(5),
    //                 child: Align(
    //                   alignment: Alignment.center,
    //                   child: Row(
    //                     children: [
    //                       Text(
    //                         count,
    //                         style: TextStyle(
    //                             color: Theme.of(context).accentColor,
    //                             fontWeight: FontWeight.bold),
    //                       ),
    //                       // Center(
    //                       //   child: IconButton(
    //                       //       icon: const Icon(
    //                       //         Icons.info,
    //                       //         // color: Theme.of(context).accentColor,
    //                       //       ),
    //                       //       tooltip: 'More Info',
    //                       //       onPressed: () {} //SideMenu(),
    //                       //       ),
    //                       // ),
    //                     ],
    //                   ),
    //                 ))
    //           ],
    //         ),
    //       )),
    //     ),
    //   ),
    // );
    return Card(
      color: Theme.of(context).backgroundColor,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      child: Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            // color: Colors.orange.shade300,
            // image: DecorationImage(
            //   colorFilter: ColorFilter.mode(
            //       Colors.black.withOpacity(0.5), BlendMode.dstATop),
            //   image: NetworkImage(
            //       "https://ifatceg.com/wp-content/uploads/2021/03/72AC9CE1-F524-4778-80D7-9401ED743DDA.jpeg"
            //       // "https://www.fmanet.org/wp-content/uploads/2015/07/water-image1.jpg",
            //       ),
            //   fit: BoxFit.cover,
            // ),
          ),
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
                        width: 49.0,
                        color: Theme.of(context).accentColor,
                        image: NetworkImage(imageUrl),
                      ),
                      // SizedBox(
                      //   height: 05,
                      // ),
                      Text(
                        bodytext,
                        //"User Management",
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          //color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        count,
                        //"User Management",
                        textAlign: TextAlign.end,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          //color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )))),
    );
  }
}

class PricePoint {
  final double x;
  final double y;

  PricePoint({ this.x,  this.y});
}

List<PricePoint> get pricePoints {
  final Random random = Random();
  final randomNumbers = <double>[];
  for (var i = 0; i <= 11; i++) {
    randomNumbers.add(random.nextDouble());
  }

  return randomNumbers
      .mapIndexed(
          (index, element) => PricePoint(x: index.toDouble(), y: element))
      .toList();
}