import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:core';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../generated/l10n.dart';
import '../../../model/eawb_model.dart';
import '../../../string.dart';
import '../../hawb/main_hawb.dart';

import 'package:http/http.dart' as http;
//
// class Line extends StatefulWidget {
//   const Line({Key key}) : super(key: key);
//
//   @override
//   State<Line> createState() => _LineState();
// }
//
// class _LineState extends State<Line> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//           //height: MediaQuery.of(context).size.height - 185.0,
//           child: Center(
//             child: FutureBuilder<dynamic>(
//               future: getAWBlist(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   //EasyLoading.show();
//                   print("Snapshot Data ${snapshot.data}");
//                   //getawblist=snapshot.data;
//                   return LineCharts(
//                   //    getawblist: snapshot.data
//                   );
//                 } else if (snapshot.hasError) {
//                   return Text(S.of(context).DataNotFound
//                     // "Data Not Found"
//                   );
//                 }
//
//                 // By default, show a loading spinner
//                 return CircularProgressIndicator();
//                 //return EasyLoading.show();
//               },
//             ),
//           ),
//         ));
//   }
// }
//


class LineCharts extends StatefulWidget {
  // var getawblist;
   LineCharts({Key key,

   //  getawblist
   }) : super(key: key);

  @override
  _LineChartsState createState() => _LineChartsState();
}

class _LineChartsState extends State<LineCharts> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  List months =
  ['jan', 'feb', 'mar', 'apr', 'may','jun','jul','aug','sep','oct','nov','dec'];
  List<dynamic> dateList;
  var outputDate;

  bool showAvg = false;
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

    return result["awb"];
  }
  @override
  @override
  Widget build(BuildContext context) {
    int month;
    return FutureBuilder<dynamic>(
      future: getAWBlist(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          dateList = snapshot.data;
          var sdata=dateList[0]['Created_Time'];
          // DateTime _dateTime = DateTime(
          //     int.parse(sdata.substring(sdata.length - 4, sdata.length)),
          //     months.indexOf(sdata.split(' ')[0]) + 1,
          //     int.parse(sdata.substring(sdata.length - 8, sdata.length - 6)));
          // print("Navewe"+_dateTime.toString());
          List months =
          ['jan', 'feb', 'mar', 'apr', 'may','jun','jul','aug','sep','oct','nov','dec'];
          var now = new DateTime.now();
          //
          var current_mon = now.month;
          DateTime date = DateTime.now();
           month = date.month.floor();
          // DateTime parseDate =
          // new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(dateList[0]['Created_Time']);
          // var inputDate = DateTime.parse(parseDate.toString());
          // var outputFormat = DateFormat("MM/dd/yyyy hh:mm a");
          //  outputDate = outputFormat.format(inputDate);
          //EasyLoading.show();
          print("Snapshot Data ${snapshot.data}");
          // print(DateFormat('MMM').format(DateTime(0, current_mon)).toString());
          //getawblist=snapshot.data;
          return Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.70,
                child: Row(
                  children: [
                    Expanded(
                        child: RotatedBox(
                            quarterTurns: 1,
                            child: new Text("Count")
                        )),
                    Expanded(
                      flex: 15,
                      child: Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(18),
                            ),
                            color: Color(0xff232d37)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 18.0,top: 30, bottom: 12),
                          child: LineChart(
                            showAvg ? avgData() : mainData(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 60,
                height: 34,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      showAvg = !showAvg;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                //   DateTime.parse(snapshot.data[0]['Created_Time']).toString(),
      //   DateFormat('MM').format(DateTime.parse(dateList[1]['Created_Time'])).toString(),

                      //outputDate,
                     // month.toString(),
      //  DateFormat('MMM').format(DateTime(0, month)).toString(),
                       DateTime.now().year.toString(),
                    //  DateFormat('MM').format(DateTime.now(),),
                      style: TextStyle(
                          fontSize: 11,
                          color:
                          showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
                    ),
                  ),
                ),
              ),
            ],
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
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 12),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return 'JAN';
              case 2:
                return 'FEB';
              case 3:
                return 'MAR';
              case 4:
                return 'APR';
              case 5:
                return 'MAY';
              case 6:
                return 'JUN';
              case 7:
                return 'JUL';
              case 8:
                return 'AUG';
              case 9:
                return 'SEP';
              case 10:
                return 'OCT';
              case 11:
                return 'NOV';
              case 12:
                return 'DEC';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1';
              case 5:
                return '5';
              case 10:
                return '10';
            }
            return '';
          },
          reservedSize: 32,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 1,
      maxX: 12,
      minY: 1,
      maxY: 10,
      lineBarsData: [
     //   widget.getawblist[0]['Created_Time'],
        LineChartBarData(
           spots:  [
             FlSpot(2, 8),
            // FlSpot(4.9, 5),
            // FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(10, 2),
            FlSpot(11, 4),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,

            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (context, value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 12),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return 'JAN';
              case 2:
                return 'FEB';
              case 3:
                return 'MAR';
                case 4:
                return 'APR';
                case 5:
                return 'MAY';
                case 6:
                return 'JUN';
                case 7:
                return 'JUL';
                case 8:
                return 'AUG';
            }
            return '';
          },
          margin: 8,
          interval: 1,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 32,
          interval: 1,
          margin: 12,
        ),
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2),
          ],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)
                .withOpacity(0.1),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)
                .withOpacity(0.1),
          ]),
        ),
      ],
    );
  }
}
