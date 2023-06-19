import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/slot_booking/main_slotbooking.dart';
import 'package:rooster/theme_changer.dart';
import 'package:rooster/ui/slot_booking/slot_homepage.dart';
import 'package:rooster/ui/slot_booking/update_slotbooking.dart';

class SlotBook extends StatefulWidget {
  final String area;
  final String number;
  final String zone;
  String awbnumber3;
  String awbnumber2;

  final String sphgroup;
  final String date;
  String driverinfo;
  String awbnumber;

  SlotBook(
      {Key key,
      this.area,
      this.number,
      this.zone,
      this.sphgroup,
      this.date,
      this.driverinfo,
      this.awbnumber,
      this.awbnumber2,
      this.awbnumber3})
      : super(key: key);

  @override
  _SlotBookState createState() => _SlotBookState();
}

class _SlotBookState extends State<SlotBook> {
  List<Slotdata> addselectlistt = List();
  List availablesearch = [];
  bool _customTileExpanded = false;
  String _currentSelectedValue;
  int slotSelectrestrict = 0;
  var types = [
    "perishable",
    "live animals",
    "general",
    "radio active",
    "valuable",
  ];
  var addselecteddate = [];
  var status = ["Booked", "Booked", "Available", "Available"];
  String timeslot = "";
  var color = [
    Colors.green,
    Colors.green,
    Colors.blue,
    Colors.blue,
    Colors.green,
    Colors.green,
  ];
  var val = -1;
  bool _value = false;
  int defaultChoiceIndex;

  List timeicons = [
    Icons.nights_stay_outlined,
    Icons.sunny_snowing,
    Icons.wb_sunny,
    Icons.nights_stay_sharp
  ];
  List<String> _choicesList = ['00-06', '06-12', '12-18', "18-00"];
  int i;
  List<Slotdata> searchResult = [];

  int n;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        centerTitle: true,
        title: Container(
          child: Text(
            S.of(context).SlotBooking,
            //'Slot Booking',

          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.details,
               // color: Theme.of(context).backgroundColor
            ),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => Container(
                width: MediaQuery.of(context).size.width,
                child: AlertDialog(
                  insetPadding: EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  title: Center(
                      child: Text(
                   S.of(context).DockManagement,
                        // "Dock Management",
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold),
                  )),
                  content: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          Card(
                            elevation: 4,
                            child: ListTile(
                              leading: Icon(Icons.circle,
                                  size: 39,
                                 // color: Theme.of(context).accentColor
                                ),
                              title: Text(
                                S.of(context).DockZone,
                                //"Dock Zone",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor)
                                  // fontWeight: FontWeight.bold
                                  ),
                              subtitle: Text(widget.zone,
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor)),
                            ),
                          ),
                          Card(
                            elevation: 4,
                            child: ListTile(
                              leading: Icon(
                                Icons.location_on,
                                size: 39,
                                color: Theme.of(context).accentColor,
                              ),
                              title: Text(
                                S.of(context).DockLocation,
                                //"Dock Location",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  // fontWeight: FontWeight.bold
                                ),
                              ),
                              subtitle: Text(
                                widget.area,
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  // fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                          Card(
                            elevation: 4,
                            child: ListTile(
                              leading: Icon(
                                Icons.dock,
                                size: 39,
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.8),
                              ),
                              title: Text(
                               S.of(context).DockNumber,
                                // "Dock Number",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  //fontWeight: FontWeight.bold
                                ),
                              ),
                              subtitle: Text(
                                widget.number,
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  // fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                          Card(
                            elevation: 4,
                            child: ListTile(
                              leading: Icon(
                                Icons.folder_special,
                                size: 39,
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.8),
                              ),
                              title: Text(
                              S.of(context).SpecialHandlingGroup,
                                //  "Special Handling Group",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  // fontWeight: FontWeight.bold
                                ),
                              ),
                              subtitle: Text(
                                widget.sphgroup,
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  // fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: ListTile(
                              leading: Icon(
                                Icons.calendar_today,
                                size: 39,
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.8),
                              ),
                              title: Text(
                               S.of(context).Date,
                                // "Date",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              subtitle: Text(
                                widget.date,
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                          ),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: ListTile(
                              leading: Image(
                                width: 39.0,
                                color: Theme.of(context).accentColor,
                                image: NetworkImage(
                                  "https://img.icons8.com/external-itim2101-blue-itim2101/2x/external-paper-school-stationery-itim2101-blue-itim2101.png",
                                  // "https://img.icons8.com/external-itim2101-blue-itim2101/2x/external-paper-school-stationery-itim2101-blue-itim2101.png",
                                ),
                              ),
                              // leading: Icon(Icons.document_scanner,
                              // color: Theme.of(context).accentColor,
                              // ),
                              title: Text(
                                S.of(context).AWB,
                                //"AWB",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              subtitle: Text(
                                widget.awbnumber,
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                          ),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: ListTile(
                              leading: Image(
                                width: 39.0,
                                color: Theme.of(context).accentColor,
                                image: NetworkImage(
                                  "https://img.icons8.com/external-itim2101-blue-itim2101/2x/external-paper-school-stationery-itim2101-blue-itim2101.png",
                                  // "https://img.icons8.com/external-itim2101-blue-itim2101/2x/external-paper-school-stationery-itim2101-blue-itim2101.png",
                                ),
                              ),
                              // leading: Icon(Icons.document_scanner,
                              // color: Theme.of(context).accentColor,
                              // ),
                              title: Text(
                               S.of(context).AWB2,
                                // "AWB2",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              subtitle: Text(
                                widget.awbnumber2 + "\nAGL1649",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                          ),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: ListTile(
                              leading: Image(
                                width: 39.0,
                                color: Theme.of(context).accentColor,
                                image: NetworkImage(
                                  "https://img.icons8.com/external-itim2101-blue-itim2101/2x/external-paper-school-stationery-itim2101-blue-itim2101.png",
                                  // "https://img.icons8.com/external-itim2101-blue-itim2101/2x/external-paper-school-stationery-itim2101-blue-itim2101.png",
                                ),
                              ),
                              // leading: Icon(Icons.document_scanner,
                              // color: Theme.of(context).accentColor,
                              // ),
                              title: Text(
                                S.of(context).AWB3,
                                //"AWB3",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              subtitle: Text(
                                widget.awbnumber3 + "\nAGL1649",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).accentColor),
                              ),
                              child: Text(
                               S.of(context).Close,
                                // 'Close',
                                style: TextStyle(
                                    color: Theme.of(context).backgroundColor),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.help,
              //  color: Theme.of(context).backgroundColor
            ),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => Container(
                width: MediaQuery.of(context).size.width,
                child: AlertDialog(
                  insetPadding: EdgeInsets.all(5.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  title: Center(
                      child: Text(
                   S.of(context).SlotBooking,
                        // "Slot Booking",
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold),
                  )),
                  content: Container(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          elevation: 4,
                          child: ListTile(
                            leading: Icon(Icons.airplane_ticket,
                                size: 39, color: Colors.green),
                            title: Text(
                            S.of(context).Booked,
                              //  "Booked",
                              style: TextStyle(
                                color: Colors.green,
                                // fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          child: ListTile(
                            leading: Icon(Icons.airplane_ticket,
                                size: 39, color: Colors.blue),
                            title: Text(// "Available",
    S.of(context).Available,
                              style: TextStyle(
                                color: Colors.blue,
                                // fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          child: ListTile(
                            leading: Icon(
                              Icons.alarm,
                              size: 39,
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.8),
                            ),
                            title: Text(
                              "00-06, 06-12...",
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                //fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(
                              S.of(context).Selectthetimeperiodtonarrowdowntheslots,
                              // "Select the time period to narrow down the slots",
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                // fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          child: ListTile(
                            leading: Icon(
                              Icons.filter_alt_outlined,
                              size: 39,
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.8),
                            ),
                            title: Text(
                             S.of(context).SelectedSlotsAvailableSlotBookedSlot,
                              // "Selected Slots\nAvailable Slot \nBooked Slot",
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                // fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: ListTile(
                            leading: Image(
                              width: 39.0,
                              color: Theme.of(context).accentColor,
                              image: NetworkImage(
                                  "https://cdn-icons-png.flaticon.com/512/2717/2717391.png"
                                  // "https://img.icons8.com/external-itim2101-blue-itim2101/2x/external-paper-school-stationery-itim2101-blue-itim2101.png",
                                  ),
                            ),
                            // leading: Icon(Icons.document_scanner,
                            // color: Theme.of(context).accentColor,
                            // ),
                            title: Text(
                             S.of(context).ReleaseBooking,
                              // "Release Booking",
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            subtitle: Text(
                              S.of(context).SwipelefttorightforreleaseBooking,
                              //"Swipe left to right for release Booking",
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: ListTile(
                            leading: Image(
                              width: 39.0,
                              color: Theme.of(context).accentColor,
                              image: NetworkImage(
                                  "https://cdn-icons-png.flaticon.com/128/219/219679.png"
                                  // "https://img.icons8.com/external-itim2101-blue-itim2101/2x/external-paper-school-stationery-itim2101-blue-itim2101.png",
                                  ),
                            ),
                            // leading: Icon(Icons.document_scanner,
                            // color: Theme.of(context).accentColor,
                            // ),
                            title: Text(
                             S.of(context).UpdateDetails,
                              // "Update Details",
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            subtitle: Text(
                              S.of(context).SwiperighttoleftforUpdateDetails,
                              //"Swipe right to left for Update Details ",
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: ListTile(
                            leading: Icon(
                              Icons.book,
                              size: 39,
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.8),
                            ),
                            subtitle: Text(
                            S.of(context).SelectMultipleSlotBookMultipleSlotMAXIMUM3,
                              //  "Select Multiple Slot \nBook Multiple Slot\n(MAXIMUM 3)",
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).accentColor),
                            ),
                            child: Text(
                            S.of(context).Close,
                              //  'Close',
                              style: TextStyle(
                                  color: Theme.of(context).backgroundColor),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Slot_home()));
              },
              icon: Icon(Icons.close_outlined)),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //card
              Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 4,
                  // color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Theme.of(context).accentColor.withOpacity(0.5),
                        width: 1),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                  ),
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(10.0),
                    child: ExpansionTile(
                      textColor: Colors.black,
                      title: Container(
                        child: Column(
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(20.0),
                                        topLeft: Radius.circular(20.0),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.circle_outlined,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        Text(
                                          widget.zone,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        // Text(
                                        //     DateFormat.Hm().format(DateTime.parse(slotdata[index].datetime)),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(20.0),
                                        topLeft: Radius.circular(20.0),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        Text(
                                          widget.area,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        // Text(
                                        //     DateFormat.Hm().format(DateTime.parse(slotdata[index].datetime)),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.dock,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    Text(
                                      widget.number,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ],
                                ),
                                Text(
                                  widget.awbnumber,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).accentColor,
                                      fontSize: 16),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 18,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      widget.date,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget.sphgroup,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                  ],
                                ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     Text("AWB",
                                //       style: TextStyle(
                                //           color: Theme.of(context).accentColor
                                //       ),),
                                //     Text("Special Handling",
                                //       style: TextStyle(
                                //           color: Theme.of(context).accentColor
                                //       ),),
                                //     Text("House Details",
                                //       style: TextStyle(
                                //           color: Theme.of(context).accentColor
                                //       ),),
                                //     Text("Date",
                                //       style: TextStyle(
                                //           color: Theme.of(context).accentColor
                                //       ),)
                                //   ],
                                // ),
                                //  Column(
                                //    children: [
                                //      Text(":",
                                //      style: TextStyle(
                                //        color: Theme.of(context).accentColor
                                //      ),
                                //      ),
                                //      Text(":",
                                //        style: TextStyle(
                                //            color: Theme.of(context).accentColor
                                //        ),
                                //      ),
                                //      Text(":",
                                //        style: TextStyle(
                                //            color: Theme.of(context).accentColor
                                //        ),),
                                //      Text(":",
                                //        style: TextStyle(
                                //            color: Theme.of(context).accentColor
                                //        ),),
                                //
                                //    ],
                                //  ),
                                //  Column(
                                //    crossAxisAlignment: CrossAxisAlignment.start,
                                //    children: [
                                //      Text(widget.awbnumber,
                                //      style: TextStyle(
                                //          fontWeight: FontWeight.bold,
                                //        color: Theme.of(context).accentColor
                                //      ),
                                //      ),
                                //      Text(widget.sphgroup,
                                //        style: TextStyle(
                                //            fontWeight: FontWeight.bold,
                                //            color: Theme.of(context).accentColor
                                //        ),
                                //      ),
                                //      Text(""),
                                //      Text(widget.date,
                                //        style: TextStyle(
                                //          fontWeight: FontWeight.bold,
                                //            color: Theme.of(context).accentColor
                                //        ),)
                                //    ],
                                //  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //Stack
                      // title:  Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: <Widget>[
                      //
                      //     Flexible(
                      //       child: Column(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //
                      //           NeumorphicContainer(
                      //             height: 30,
                      //             width: 30,
                      //             borderRadius: 150,
                      //             primaryColor: Theme.of(context).backgroundColor,
                      //             //add border color and thickness
                      //             borderColor: Theme.of(context).accentColor,
                      //             borderThickness: 1,
                      //             curvature: Curvature.flat,
                      //             child: Icon(Icons.circle,color: Theme.of(context).accentColor,size: 20,),
                      //           ),
                      //           SizedBox(height: 5),
                      //           Text(widget.zone,
                      //           style: TextStyle(
                      //             color: Theme.of(context).accentColor,
                      //             fontSize: 14
                      //           ),
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //         Container(
                      //           height: 40,
                      //           child: VerticalDivider(
                      //               color: Theme.of(context).accentColor),
                      //         ),
                      //     Flexible(
                      //       child: Column(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           NeumorphicContainer(
                      //             height: 30,
                      //             width: 30,
                      //             borderRadius: 150,
                      //             primaryColor: Theme.of(context).backgroundColor,
                      //             //add border color and thickness
                      //             borderColor: Theme.of(context).accentColor,
                      //             borderThickness: 1,
                      //             curvature: Curvature.flat,
                      //             child: Icon(Icons.dock,color: Theme.of(context).accentColor,size: 20,),
                      //           ),
                      //           SizedBox(height: 5),
                      //           Text(widget.number,
                      //             style: TextStyle(
                      //                 color: Theme.of(context).accentColor,
                      //                 fontSize: 14
                      //             ),
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //     Container(
                      //       height: 40,
                      //       child: VerticalDivider(
                      //           color: Theme.of(context).accentColor),
                      //     ),
                      //     Flexible(
                      //       child: Column(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           NeumorphicContainer(
                      //             height: 30,
                      //             width: 30,
                      //             borderRadius: 150,
                      //             primaryColor: Theme.of(context).backgroundColor,
                      //             //add border color and thickness
                      //             borderColor: Theme.of(context).accentColor,
                      //             borderThickness: 1,
                      //             curvature: Curvature.flat,
                      //             child: Icon(Icons.location_on,color: Theme.of(context).accentColor,size: 20,),
                      //           ),
                      //           SizedBox(height: 5,),
                      //           Text(widget.area,
                      //           style: TextStyle(
                      //             color: Theme.of(context).accentColor,
                      //           fontSize: 14
                      //           ),
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      // title: Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //         Text(
                      //           "Dock Zone",
                      //           style: TextStyle(
                      //               color: Theme.of(context).accentColor,
                      //               fontSize: 13),
                      //         ),
                      //         Text(
                      //           widget.zone,
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.bold,
                      //               color: Theme.of(context).accentColor,
                      //               fontSize: 13),
                      //         )
                      //       ],
                      //     ),
                      //     Container(
                      //       height: 40,
                      //       child: VerticalDivider(
                      //           color: Theme.of(context).accentColor),
                      //     ),
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //         Text(
                      //           "Location",
                      //           style: TextStyle(
                      //               color: Theme.of(context).accentColor,
                      //               fontSize: 13),
                      //         ),
                      //         Text(
                      //           widget.area,
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.bold,
                      //               color: Theme.of(context).accentColor,
                      //               fontSize: 13),
                      //         )
                      //       ],
                      //     ),
                      //     Container(
                      //       height: 40,
                      //       child: VerticalDivider(
                      //           color: Theme.of(context).accentColor),
                      //     ),
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //         Text(
                      //           "Dock Number",
                      //           style: TextStyle(
                      //               color: Theme.of(context).accentColor,
                      //               fontSize: 13),
                      //         ),
                      //         Text(
                      //           widget.number,
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             color: Theme.of(context).accentColor,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      trailing: Icon(
                        _customTileExpanded
                            ? Icons.arrow_drop_down_circle
                            : Icons.arrow_drop_down,
                        color: Theme.of(context).accentColor,
                      ),
                      children: <Widget>[
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                    S.of(context).AWB2
                                    //"AWB 2"
                                ),
                                Text(
                                  S.of(context).AWB3
                                  //"AWB 3"
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  widget.awbnumber2,
                                  // "House Details"
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).accentColor),
                                ),
                                Text(
                                  widget.awbnumber3,
                                  // "House Details"
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Theme.of(context).accentColor),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "AGL1649",
                                  // "House Details"
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).accentColor),
                                ),
                                Text(
                                  "AGL1650",
                                  // "House Details"
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).accentColor),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                      onExpansionChanged: (bool expanded) {
                        setState(() => _customTileExpanded = expanded);
                      },
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Wrap(
                  spacing: 6,
                  children: List.generate(_choicesList.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        //_choicesList[index] = timeslot;
                        print("Time Filter");
                      },
                      child: ChoiceChip(
                        labelPadding: EdgeInsets.only(right: 10, left: 10),
                        // avatar:  Icon(timeicons[index]),
                        label: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              timeicons[index],
                              size: 18,
                            ),
                            Text(
                              _choicesList[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                 // color: Colors.black,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                        selected: defaultChoiceIndex == index,
                        selectedColor: Theme.of(context).accentColor,
                        onSelected: (value) {
                          setState(() {
                            defaultChoiceIndex =
                                value ? index : defaultChoiceIndex;

                            timeslot = _choicesList[defaultChoiceIndex];
                            print(timeslot);
                            List<String> filterTime =
                                _choicesList[defaultChoiceIndex].split('-');
                            filterTimeBased(filterTime[0], filterTime[1]);
                          });
                        },
                        // backgroundColor: color,
                        elevation: 1,
                        // padding: EdgeInsets.symmetric(
                        //     horizontal: SizeConfig.widthMultiplier * 4),
                      ),
                    );
                  }),
                ),
                trailing: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).accentColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      clipBehavior: Clip.antiAlias,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15.0),
                                topLeft: Radius.circular(15.0),
                              ),
                              color: Theme.of(context).backgroundColor
                          ),
                          height: 100,
                          child: Center(
                            child: Container(
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 6.0,
                                children: <Widget>[
                                  // _buildChip('Show All', Color(0xFFff6666)),

                                  _buildChip(
                                    'Available Slot', Colors.blue,
                                    //    Icons.book
                                  ),
                                  TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Theme.of(context)
                                                      .accentColor),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ))),
                                      onPressed: () => showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30.0)),
                                              ),
                                              title: Center(
                                                child: Text(
                                               S.of(context).SelectedSlot,
                                                  //   'Selected Slot',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor),
                                                ),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    height: 180,
                                                    child: ListView.builder(
                                                        itemCount:
                                                            addselectlistt
                                                                .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return ListTile(
                                                            leading: Icon(
                                                                Icons.alarm),
                                                            trailing: Text(
                                                              addselectlistt[
                                                                      index]
                                                                  .datetime,
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .accentColor,
                                                                  fontSize: 15),
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      TextButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Theme.of(
                                                                            context)
                                                                        .accentColor)),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text(
                                                       S.of(context).Close,
                                                          //   'Close',
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .backgroundColor),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Theme.of(
                                                                            context)
                                                                        .accentColor)),
                                                        onPressed: () async {
                                                          //Navigator.pop(context, 'OK');
                                                          EasyLoading.show(
                                                              status:
                                                            S.of(context).Pleasewait
                                                            //   'Please wait...'
                                                          );
                                                          await Future.delayed(
                                                              Duration(
                                                                  seconds: 3));
                                                          setState(() {
                                                            addselectlistt
                                                                .forEach(
                                                                    (bookList) {
                                                              int index = SlotBookingList
                                                                  .slotData
                                                                  .indexWhere((element) =>
                                                                      element
                                                                          .id ==
                                                                      bookList
                                                                          .id);
                                                              SlotBookingList
                                                                      .slotData[
                                                                          index]
                                                                      .status =
                                                              S.of(context).Booked
                                                              //    "Booked"
                                                              ;
                                                            });
                                                          });
                                                          // notifyListeners();
                                                          EasyLoading
                                                              .showSuccess(
                                                          S.of(context).Success
                                                            //        'Success!'
                                                          );
                                                          await Future.delayed(
                                                              Duration(
                                                                  seconds: 1));
                                                          EasyLoading.dismiss();
                                                          print(SlotBookingList
                                                              .slotData);
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          SlotBook(
                                                                            area:
                                                                                widget.area,
                                                                            number:
                                                                                widget.number,
                                                                            zone:
                                                                                widget.zone,
                                                                            sphgroup:
                                                                                widget.sphgroup,
                                                                            date:
                                                                                widget.date,
                                                                          )));
                                                        },
                                                        child: Text(
                                                          S.of(context).Book,
                                                          //'Book',
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .backgroundColor),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                      child: Text(
                                        "Selected Slot",
                                        style: TextStyle(
                                            color: Colors.black),
                                      )),

                                  _buildChip1(
                                    S.of(context).Booked,
                                    //'Booked slot',
                                    Colors.green,
                                    // Icons.book
                                  ),
                                  // _buildChip('11:00', Colors.blue),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Icon(
                    Icons.filter_alt_outlined,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: buildListView(context, timeslot),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            title: Center(
              child: Text(
               S.of(context).BookYourSlotNow,
                // 'Book your slot now',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 180,
                  child: ListView.builder(
                      itemCount: addselectlistt.length,
                      itemBuilder: (BuildContext context, int index) {
                        var tempindex =
                            //addselectlistt[0].datetime
                            DateFormat.Hm().format(
                                DateTime.parse(addselectlistt[0].datetime)
                                    .add(Duration(minutes: 30)));

                        var tempadd = DateFormat.Hm().format(
                            DateTime.parse(addselectlistt[0].datetime)
                                .add(Duration(hours: 1)));
                        print(tempadd);
                        return (index == 0 ||
                                tempindex ==
                                    DateFormat.Hm().format(DateTime.parse(
                                        addselectlistt[index].datetime)) ||
                                tempadd ==
                                    DateFormat.Hm().format(DateTime.parse(
                                        addselectlistt[index].datetime)))
                            ? Card(
                                elevation: 4,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.alarm,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  title: Text(
                                    DateFormat.yMMMEd()
                                            // displaying formatted date
                                            .format(DateTime.parse(
                                                addselectlistt[index]
                                                    .datetime)) +
                                        " " +
                                        DateFormat.Hm().format(DateTime.parse(
                                            addselectlistt[index].datetime)),
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 15),
                                  ),
                                  // trailing: Text(
                                  //
                                  //   addselectlistt[index].datetime,
                                  //   style: TextStyle(
                                  //       color: Theme.of(context).accentColor,
                                  //       fontSize: 15),
                                  // ),
                                ),
                              )
                            : Text("");
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).accentColor)),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        S.of(context).Close,
                        //'Close',
                        style:
                            TextStyle(color: Theme.of(context).backgroundColor),
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).accentColor)),
                      onPressed: () async {
                        //Navigator.pop(context, 'OK');
                        EasyLoading.show(status:
                        S.of(context).Pleasewait
                          //'Please wait...'
                        );
                        await Future.delayed(Duration(seconds: 3));
                        setState(() {
                          addselectlistt.forEach((bookList) {
                            int index = SlotBookingList.slotData.indexWhere(
                                (element) => element.id == bookList.id);
                            SlotBookingList.slotData[index].status =
                            S.of(context).Booked
                            //"Booked"
                            ;
                          });
                        });
                        // notifyListeners();
                        EasyLoading.showSuccess(
                        S.of(context).Success
                          ///    'Success!'
                        );
                        await Future.delayed(Duration(seconds: 1));
                        EasyLoading.dismiss();
                        print(SlotBookingList.slotData);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SlotBook(
                                      awbnumber: widget.awbnumber,
                                      driverinfo: widget.driverinfo,
                                      area: widget.area,
                                      number: widget.number,
                                      zone: widget.zone,
                                      sphgroup: widget.sphgroup,
                                      date: widget.date,
                                    )));
                      },
                      child: Text(
                       S.of(context).Book,
                        // 'Book',
                        style:
                            TextStyle(color: Theme.of(context).backgroundColor),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.book),
      ),
    );
  }

  // This widget will be passed as Top Card's Widget.
  Widget topCardWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
             S.of(context).DockZone,
              // "Dock Zone",
              style: TextStyle(
                  color: Theme.of(context).backgroundColor, fontSize: 13),
            ),
            Text(
              widget.zone,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).backgroundColor,
                  fontSize: 13),
            )
          ],
        ),
        Container(
          height: 40,
          child: VerticalDivider(color: Theme.of(context).backgroundColor),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
            S.of(context).DockLocation,
              //  "Location",
              style: TextStyle(
                  color: Theme.of(context).backgroundColor, fontSize: 13),
            ),
            Text(
              widget.area,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).backgroundColor,
                  fontSize: 13),
            )
          ],
        ),
        VerticalDivider(color: Theme.of(context).backgroundColor),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
             S.of(context).DockNumber,
              // "Dock Number",
              style: TextStyle(
                  color: Theme.of(context).backgroundColor, fontSize: 13),
            ),
            Text(
              widget.number,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).backgroundColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // This widget will be passed as Bottom Card's Widget.
  Widget bottomCardWidget() {
    return Text(
      'It doesn\'t matter \nwhat your name is.',
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget buildListView(BuildContext context, String isSearchresult) {
    return Consumer<SlotBookingList>(
        builder: (context, slotbookingList, child) {
      List<Slotdata> slotdata =
          isSearchresult.isEmpty ? SlotBookingList.slotData : searchResult;

      return ListView.builder(
        itemBuilder: (BuildContext, index) {
          return Dismissible(
            key: ValueKey(slotdata[index]),
            confirmDismiss: (DismissDirection direction) async {
              if (direction == DismissDirection.startToEnd) {
                return await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                     S.of(context).ReleaseBooking,
                        //   "Release Booking",
                        // S
                        //     .of(context)
                        //     .DeleteConfirmation,
                        style: TextStyle(color: Theme.of(context).accentColor),
                        //"Delete Confirmation"
                      ),
                      content: Text(
                       S.of(context).WouldyouliketoReleaseyourBookedDockSlot,
                        // "Would you like to Release your Booked Dock & Slot?",
                        // S
                        //     .of(context)
                        //     .Areyousureyouwanttodeletethisitem,
                        style: TextStyle(color: Theme.of(context).accentColor),
                        //"Are you sure you want to delete this item?"
                      ),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () async {
                              //Navigator.pop(context, 'OK');
                              EasyLoading.show(status:
                              S.of(context).Pleasewait
                                //'Please wait...'
                              );
                              await Future.delayed(Duration(seconds: 3));
                              setState(() {
                                // slotdata.forEach((bookList) {
                                //   int index = SlotBookingList.slotData.indexWhere(
                                //           (element) => element.id == SlotBookingList.slotData[index].id);
                                if (slotdata[index].status ==
                                S.of(context).Booked
                                //    "Booked"
                                )
                                  SlotBookingList.slotData[index].status =
                                S.of(context).Available
                                ///      "Available"
                                ;
                                // });
                              });
                              // notifyListeners();
                              EasyLoading.showSuccess(
                                S.of(context).Success
                                //'Success!'
                              );
                              await Future.delayed(Duration(seconds: 1));
                              EasyLoading.dismiss();
                              print(SlotBookingList.slotData);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SlotBook(
                                            awbnumber: widget.awbnumber,
                                            driverinfo: widget.driverinfo,
                                            area: widget.area,
                                            number: widget.number,
                                            zone: widget.zone,
                                            sphgroup: widget.sphgroup,
                                            date: widget.date,
                                          )));
                            },
                            child: Text(
                             S.of(context).Yes,
                              // "Yes",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            )),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                           S.of(context).No,
                            // "No",
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                if (slotdata[index].status !=
                S.of(context).Available
                //    "Available"
                ) {
                  return await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                         S.of(context).UpdateBooking,
                          // "Update Booking",
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                        content: Text(
                        S.of(context).WouldyouliketoUpdateyourBookedDockSlot,
                          //  "Would you like to Update your Booked Dock & Slot?",
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateSlot(
                                          driverinfo: widget.driverinfo,
                                          awbnumber: widget.awbnumber,
                                          area: widget.area,
                                          zone: widget.zone,
                                          sphgroup: widget.sphgroup,
                                          number: widget.number,
                                          date: widget.date),
                                    ));
                              },
                              child: Text(
                               S.of(context).Yes
                                // "Yes",
                             ,   style: TextStyle(
                                    color: Theme.of(context).accentColor
                              ),
                              )),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              S.of(context).No,
                              //"No",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
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
                      S.of(context).ReleaseBooking
                      //  "Release Booking"
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
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  // textDirection: TextDirection.rtl,
                  children: [
                    Icon(Icons.edit, color: Colors.white),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      S.of(context).UpdateDetails,
                      textAlign: TextAlign.right,
                      //'Update Details',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  n=index;
                  slotdata[index].isSelected = !slotdata[index].isSelected;
                  if (slotdata[index].status !=
                  S.of(context).Booked
                  //    "Booked"
                  ) {
                    if (slotdata[index].isSelected == true) {
                      //slotSelectrestrict = index + 1;
                      // To restrict only 3 continuse slots
                      if (addselectlistt.length < 3) {
                        if (index != 0) {
                          if (slotSelectrestrict - 1 == index - 1 ||
                              slotSelectrestrict - 1 == index - 2) {
                            addselectlistt.add(Slotdata(
                                driverinfo: slotdata[index].driverinfo,
                                id: slotdata[index].id,
                                datetime: slotdata[index].datetime,
                                zone: slotdata[index].zone,
                                area: slotdata[index].area,
                                time: slotdata[index].time,
                                status: slotdata[index].status));
                            slotSelectrestrict = index;
                          } else {
                            EasyLoading.showToast(
                               S.of(context).OnlyAllowtobookcontinues3slots,
                              // "Only Allow to book continues 3 slots"
                            );
                          }
                        } else {
                          addselectlistt.add(Slotdata(
                              driverinfo: slotdata[index].driverinfo,
                              id: slotdata[index].id,
                              datetime: slotdata[index].datetime,
                              zone: slotdata[index].zone,
                              area: slotdata[index].area,
                              time: slotdata[index].time,
                              status: slotdata[index].status));
                          slotSelectrestrict = index + 1;
                        }
                      } else {
                        EasyLoading.showToast(
                         S.of(context).Maximumonly3slotsareallowedtobookatatime,
                          //   "Maximum only 3 slots are allowed to book at a time"
                        );
                      }
                    } else if (slotdata[index].isSelected == false) {
                      addselectlistt.removeWhere((element) =>
                          element.datetime == slotdata[index].datetime);
                    }
                  }

                  print(addselectlistt[index].datetime);
                });
              },
              child: Container(
                color: (slotdata[index].isSelected == true)
                    ? Theme.of(context).accentColor
                    : null,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Theme.of(context).accentColor.withOpacity(0.5),
                        width: 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              // (slotdata[index].isSelected==true)?
                              //     Icon(Icons.check,
                              //     color: Colors.green,
                              //     ):
                              //     Text(""),
                              Container(
                                height: 30,
                                width: 220,
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20.0),
                                      topLeft: Radius.circular(20.0),
                                    ),
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.5)),
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat.yMMMEd()
                                              // displaying formatted date
                                              .format(DateTime.parse(
                                                  slotdata[index].datetime)) +
                                          " " +
                                          DateFormat.Hm().format(DateTime.parse(
                                              slotdata[index].datetime)),
                                    ),
                                    // Text(
                                    //     DateFormat.Hm().format(DateTime.parse(slotdata[index].datetime)),
                                    // ),
                                  ],
                                )),
                              ),
                              SizedBox(
                                width: 20,
                              ),

                              SizedBox(
                                width: 3,
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          children: <Widget>[
                            (slotdata[index].status ==
                                S.of(context).Booked
                                //"Booked"
                            )
                                ? Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Text(
                                      "176-00122474",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  )
                                : Text(""),
                            Center(
                              child: Image.network(
                                "https://img.icons8.com/external-konkapp-detailed-outline-konkapp/344/external-truck-transportation-konkapp-detailed-outline-konkapp.png",
                                width: 50,
                                height: 40,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            (slotdata[index].status ==
                                S.of(context).Booked
                                //"Booked"
                            )
                                ? Positioned(
                                    top: 10,
                                    right: 50,
                                    child: Text(
                                      widget.driverinfo,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  )
                                : Text(""),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  Text(
                                    "30 min",
                                    style: TextStyle(
                                        //color: Theme.of(context).accentColor
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                ],
                              ),
                              (slotdata[index].status ==
                               S.of(context).Available
                                  //   "Available"
                              )
                                  ? TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.blue),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10.0
                                                          // topLeft:
                                                          // Radius.circular(14.0),
                                                          // bottomRight:
                                                          // Radius.circular(14.0)
                                                          )))),
                                      onPressed: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight:
                                                      Radius.circular(20)),
                                            ),
                                            context: context,
                                            builder: (bc) {
                                              return Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .40,
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            18.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                          S.of(context).BookYourSlotNow,
                                                              //    "Book Your Slot Now",
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
                                                                      // "Slot Date & Time :",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Theme.of(context).accentColor),
                                                                    ),
                                                                    Container(
                                                                        child:
                                                                            Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              50),
                                                                      child:
                                                                          Text(
                                                                        slotdata[index]
                                                                            .datetime,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                            color: Theme.of(context).accentColor),
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
                                                              onPressed:
                                                                  () async {
                                                                //Navigator.pop(context, 'OK');
                                                                EasyLoading.show(
                                                                    status:
                                                                S.of(context).Pleasewait
                                                                  //        'Please wait...'
                                                                );
                                                                await Future.delayed(
                                                                    Duration(
                                                                        seconds:
                                                                            3));
                                                                setState(() {
                                                                  if (slotdata[
                                                                              index]
                                                                          .status ==
                                                                  S.of(context).Available
                                                                  //"Available"
                                                                          )
                                                                    SlotBookingList
                                                                        .slotData[
                                                                            index]
                                                                        .status =
                                                                  S.of(context).Booked
                                                                  //  "Booked"
                                                                  ;
                                                                });
                                                                // notifyListeners();
                                                                EasyLoading
                                                                    .showSuccess(
                                                                S.of(context).Success
                                                                  //        'Success!'
                                                                );
                                                                await Future.delayed(
                                                                    Duration(
                                                                        seconds:
                                                                            1));
                                                                EasyLoading
                                                                    .dismiss();
                                                                print(SlotBookingList
                                                                    .slotData);
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            SlotBook(
                                                                              awbnumber: widget.awbnumber,
                                                                              driverinfo: widget.driverinfo,
                                                                              area: widget.area,
                                                                              number: widget.number,
                                                                              zone: widget.zone,
                                                                              sphgroup: widget.sphgroup,
                                                                              date: widget.date,
                                                                              awbnumber3: "",
                                                                              awbnumber2: "",
                                                                            )));
                                                              },
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(
                                                                        Theme.of(context)
                                                                            .backgroundColor),
                                                              ),
                                                              icon: Icon(
                                                                Icons
                                                                    .cloud_circle,
                                                                size: 18,
                                                                color: Theme.of(
                                                                        context)
                                                                    .accentColor,
                                                              ),
                                                              label: Text(
                                                              S.of(context).BookSlot,
                                                                //  "Book Slot",
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
                                           S.of(context).Available,
                                            // "Available",
                                            style: TextStyle(

                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(Icons.airplane_ticket,
                                            color: Colors.white,
                                            // color: Theme.of(context).backgroundColor
                                          ),
                                        ],
                                      ),
                                    )
                                  : TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.green),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10.0
                                                          // topLeft:
                                                          // Radius.circular(14.0),
                                                          // bottomRight:
                                                          // Radius.circular(14.0)

                                                          )))),
                                      onPressed: () {},
                                      child: Row(
                                        children: [
                                          Text(
                                           S.of(context).Booked,
                                            // "Booked",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .backgroundColor,
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
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: slotdata.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8),
      );
    });
  }

  _buildChip(String s, Color color) {
    return GestureDetector(
      onTap: () {
        timeslot =
        S.of(context).Available
        //"Available"
        ;
        searchResult.clear();
        print("object");
        SlotBookingList.slotData.forEach((element) {
          if (element.status ==
          S.of(context).Available
          //    "Available"
          ) {
            setState(() {
              searchResult.add(element);
            });
          }
        });
      },
      child: Chip(
        labelPadding: EdgeInsets.all(2.0),
        label: Text(
          s,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: color,
        elevation: 5.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(8.0),
      ),
    );
  }

  _buildChip1(String s, Color color
      //IconData wb_sunny
      ) {
    return GestureDetector(
      onTap: () {
        timeslot =
        S.of(context).Booked
        //"Booked"
        ;
        searchResult.clear();
        SlotBookingList.slotData.forEach((element) {
          if (element.status ==
              S.of(context).Booked
              //"Booked"
          )
          {
            setState(() {
              searchResult.add(element);
            });
          }
        });
      },
      child: Chip(
        labelPadding: EdgeInsets.all(2.0),
        label: Text(
          s,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: color,
        elevation: 5.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(8.0),
      ),
    );
  }

  Widget multiselectButton(bool isSelected) {
    if (isSelected) {
      TextButton(
        onPressed: () {},
        child: Text(
        S.of(context).BookNow
          //    "Book Now"
        ),
      );
    }
  }

  void filterTimeBased(String minTime, String maxTime) {
    searchResult.clear();
    SlotBookingList.slotData.forEach((element) {
      DateTime parsedDate = DateTime.parse(element.datetime);
      print(parsedDate.hour);
      int.parse(minTime);
      if (parsedDate.hour >= int.parse(minTime) &&
          parsedDate.hour <= int.parse(maxTime)) {
        setState(() {
          searchResult.add(element);
        });
      }
    });
  }
}

class SlotBooked extends StatefulWidget {
  String awbnumber;
  String area;
  String zone;
  String sphgroup;
  String number;
  String date;
  String driverinfo;
  SlotBooked(
      {Key key,
      this.awbnumber,
      this.area,
      this.zone,
      this.sphgroup,
      this.number,
      this.date,
      this.driverinfo})
      : super(key: key);

  @override
  _SlotBookedState createState() => _SlotBookedState();
}

class _SlotBookedState extends State<SlotBooked> {
  var Date = [
    "Mon, 17 Mar 2022 10:30",
    "Mon, 17 Mar 2022 11:00",
    "Mon, 17 Mar 2022 12:00",
    "Mon, 17 Mar 2022 13:00"
  ];
  final startTime = TimeOfDay(hour: 9, minute: 0);
  final endTime = TimeOfDay(hour: 22, minute: 0);
  final step = Duration(minutes: 30);

  List<Slotdata> addselectlistt = List();
  List availablesearch = [];
  bool _customTileExpanded = false;
  String _currentSelectedValue;

  var types = [
    "perishable",
    "live animals",
    "general",
    "radio active",
    "valuable",
  ];
  //var Time_slot = ["9:00-9:30", "9:30-10:00", "10:00-10:30"];
  // var Date = [
  //   "Mon, 17 Mar 2022 09:30",
  //   "Mon, 17 Mar 2022 10:00",
  //   "Mon, 17 Mar 2022 11:30",
  //   "Mon, 17 Mar 2022 12;30"
  // ];
  var addselecteddate = [];
  //var Block = ["A1", "A2", "A3", "A4"];
  var status = ["Booked", "Booked", "Available", "Available"];
  String timeslot;
  var color = [
    Colors.green,
    Colors.green,
    Colors.blue,
    Colors.blue,
    Colors.green,
    Colors.green,
  ];
  var val = -1;
  bool _value = false;
  int defaultChoiceIndex;
  List<String> _choicesList = ['00-06', '06-12', '12-18', "18-00"];

  int i;
  // var Date = [
  //   "Mon, 17 Mar 2022 09:30",
  //   "Mon, 17 Mar 2022 10:00",
  //   "Mon, 17 Mar 2022 11:30",
  //   "Mon, 17 Mar 2022 12;30"
  // ];
  var Block = ["A1", "A2", "A3", "A4"];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: Container(child: Text("Booked Slot")),
        ),
        body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)),
          ),
          child: buildListView(
              context, availablesearch.length != 0 ? availablesearch : status),
        ),
      ),
    );
  }

  Widget buildListView(BuildContext context, var slotlen) {
    return Consumer<SlotBookingList>(
        builder: (context, slotbookingList, child) {
      List<Slotdata> slotdata = SlotBookingList.slotData;

      return ListView.builder(
        itemBuilder: (BuildContext, index) {
          return (slotdata[index].status == "Booked")
              ? Dismissible(
                  key: ValueKey(slotdata[index]),
                  confirmDismiss: (DismissDirection direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      return await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Release Booking",
                              // S
                              //     .of(context)
                              //     .DeleteConfirmation,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                              //"Delete Confirmation"
                            ),
                            content: Text(
                              "Would you like to Release your Booked Dock & Slot?",
                              // S
                              //     .of(context)
                              //     .Areyousureyouwanttodeletethisitem,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                              //"Are you sure you want to delete this item?"
                            ),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                    // deleteAWB('${slotlen[index]["id"]}');
                                  },
                                  child: Text(
                                    "Yes",
                                    // BuildContext context,
                                    // S
                                    //     .of(context)
                                    //     .Delete,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                    //"Delete"
                                  )),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text(
                                  "No",
                                  // S
                                  //     .of(context)
                                  //     .Cancel,
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
                      if (slotdata[index].status != "Available") {
                        return await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "Update Booking",
                                // S
                                //     .of(context)
                                //     .DeleteConfirmation,
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                                //"Delete Confirmation"
                              ),
                              content: Text(
                                "Would you like to Update your Booked Dock & Slot?",
                                // S
                                //     .of(context)
                                //     .Areyousureyouwanttodeletethisitem,
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                                //"Are you sure you want to delete this item?"
                              ),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UpdateSlot(
                                                awbnumber: widget.awbnumber,
                                                area: widget.area,
                                                zone: widget.zone,
                                                sphgroup: widget.sphgroup,
                                                number: widget.number,
                                                date: widget.date),
                                          ));
                                    },
                                    child: Text(
                                      "Yes",
                                      // BuildContext context,
                                      // S
                                      //     .of(context)
                                      //     .Delete,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                      //"Delete"
                                    )),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text(
                                    "No",
                                    // S
                                    //     .of(context)
                                    //     .Cancel,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                    // "Cancel"
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
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
                              "Release Booking"
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
                        // textDirection: TextDirection.rtl,
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
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        slotdata[index].isSelected =
                            !slotdata[index].isSelected;
                        if (slotdata[index].status != "Booked") {
                          if (slotdata[index].isSelected == true) {
                            addselectlistt.add(Slotdata(
                                id: slotdata[index].id,
                                datetime: slotdata[index].datetime,
                                zone: slotdata[index].zone,
                                area: slotdata[index].area,
                                time: slotdata[index].time,
                                status: slotdata[index].status));
                          } else if (slotdata[index].isSelected == false) {
                            addselectlistt.removeWhere((element) =>
                                element.datetime == slotdata[index].datetime);
                          }
                        }

                        print(addselectlistt[index].datetime);
                      });
                    },
                    child: Container(
                      color: (slotdata[index].isSelected == true)
                          ? Theme.of(context).accentColor
                          : null,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.5),
                              width: 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    // (slotdata[index].isSelected==true)?
                                    //     Icon(Icons.check,
                                    //     color: Colors.green,
                                    //     ):
                                    //     Text(""),
                                    Container(
                                      height: 30,
                                      width: 220,
                                      decoration: new BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20.0),
                                            topLeft: Radius.circular(20.0),
                                          ),
                                          color: Theme.of(context)
                                              .accentColor
                                              .withOpacity(0.5)),
                                      child: Center(
                                          child: Text(
                                        slotdata[index].datetime,
                                      )),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                  ],
                                ),
                              ),
                              Stack(
                                children: <Widget>[
                                  (slotdata[index].status == "Booked")
                                      ? Positioned(
                                          top: 16,
                                          left: 10,
                                          child: Text(
                                            "176-00122474",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                        )
                                      : Text(""),
                                  Center(
                                    child: Image.network(
                                      "https://img.icons8.com/external-konkapp-detailed-outline-konkapp/344/external-truck-transportation-konkapp-detailed-outline-konkapp.png",
                                      // "https://img.icons8.com/external-xnimrodx-lineal-gradient-xnimrodx/344/external-truck-distribution-xnimrodx-lineal-gradient-xnimrodx.png",
                                      // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPG8TFydMwTjrdYDzECimH5JWcrwKmV1RrUQ&usqp=CAU",
                                      width: 50,
                                      height: 50,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  (slotdata[index].status == "Booked")
                                      ? Positioned(
                                          top: 16,
                                          right: 50,
                                          child: Text(
                                            widget.driverinfo,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                        )
                                      : Text(""),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Row(
                                    //   children: [
                                    //     Icon(
                                    //       Icons.location_on_rounded,
                                    //       color: Theme.of(context).accentColor,
                                    //     ),
                                    //     Text(
                                    //       slotdata[index].area,
                                    //       style: TextStyle(
                                    //           color: Theme.of(context).accentColor),
                                    //     ),
                                    //   ],
                                    // ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        Text(
                                          "30 min",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                      ],
                                    ),
                                    (slotdata[index].status == "Available")
                                        ? TextButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.blue),
                                                shape: MaterialStateProperty
                                                    .all(RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10.0
                                                                // topLeft:
                                                                // Radius.circular(14.0),
                                                                // bottomRight:
                                                                // Radius.circular(14.0)
                                                                )))),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20)),
                                                  ),
                                                  context: context,
                                                  builder: (bc) {
                                                    return Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .40,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(18.0),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                   S.of(context).BookYourSlotNow,
                                                                    // "Book Your Slot Now",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Theme.of(context)
                                                                            .accentColor),
                                                                  ),
                                                                  Spacer(),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      color: Theme.of(
                                                                              context)
                                                                          .accentColor,
                                                                      icon: Icon(
                                                                          Icons
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
                                                                          const EdgeInsets.all(
                                                                              5),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Text(
                                                                           S.of(context).SlotDateTime,
                                                                            // "Slot Date & Time :",
                                                                            style: TextStyle(
                                                                                fontSize: 17,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Theme.of(context).accentColor),
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
                                                                              child: Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 50),
                                                                            child:
                                                                                Text(
                                                                              slotdata[index].datetime,
                                                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Theme.of(context).accentColor),
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
                                                                      child: ElevatedButton
                                                                          .icon(
                                                                    onPressed:
                                                                        () async {
                                                                      //Navigator.pop(context, 'OK');
                                                                      EasyLoading.show(
                                                                          status:
                                                                        S.of(context).Pleasewait
                                                                        // 'Please wait...'
                                                                      );
                                                                      await Future.delayed(Duration(
                                                                          seconds:
                                                                              3));
                                                                      setState(
                                                                          () {
                                                                        addselectlistt
                                                                            .forEach((bookList) {
                                                                          int index = SlotBookingList.slotData.indexWhere((element) =>
                                                                              element.id ==
                                                                              bookList.id);
                                                                          SlotBookingList
                                                                              .slotData[index]
                                                                              .status =
                                                                          S.of(context).Booked
                                                                          //"Booked"
                                                                          ;
                                                                        });
                                                                      });
                                                                      // notifyListeners();
                                                                      EasyLoading
                                                                          .showSuccess(
                                                                        S.of(context).Success
                                                                        //    'Success!'
                                                                      );
                                                                      await Future.delayed(Duration(
                                                                          seconds:
                                                                              1));
                                                                      EasyLoading
                                                                          .dismiss();
                                                                      print(SlotBookingList
                                                                          .slotData);
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => SlotBook(
                                                                                    area: widget.area,
                                                                                    number: widget.number,
                                                                                    zone: widget.zone,
                                                                                    sphgroup: widget.sphgroup,
                                                                                    date: widget.date,
                                                                                  )));
                                                                    },
                                                                    style:
                                                                        ButtonStyle(
                                                                      backgroundColor:
                                                                          MaterialStateProperty.all(
                                                                              Theme.of(context).backgroundColor),
                                                                    ),
                                                                    icon: Icon(
                                                                      Icons
                                                                          .cloud_circle,
                                                                      size: 18,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .accentColor,
                                                                    ),
                                                                    label: Text(
                                                                    S.of(context).BookSlot,
                                                                      //  "Book Slot",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Theme.of(context).accentColor),
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
                                                  "Available",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .backgroundColor,
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
                                          )
                                        : TextButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.green),
                                                shape: MaterialStateProperty
                                                    .all(RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10.0
                                                                // topLeft:
                                                                // Radius.circular(14.0),
                                                                // bottomRight:
                                                                // Radius.circular(14.0)

                                                                )))),
                                            onPressed: () {},
                                            child: Row(
                                              children: [
                                                Text(
                                                  S.of(context).Booked,
                                                  //"Booked",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .backgroundColor,
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
                                          )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Text("");
        },
        itemCount: slotdata.length,
        shrinkWrap: true,
        padding: EdgeInsets.all(8),
        scrollDirection: Axis.vertical,
      );
    });
  }
}

class SlotList extends StatefulWidget {
  String awbnumber;
  String area;
  String zone;
  String sphgroup;
  String number;
  String date;
  String driverinfo;

  SlotList(
      {Key key,
      this.awbnumber,
      this.area,
      this.zone,
      this.sphgroup,
      this.number,
      this.date,
      this.driverinfo})
      : super(key: key);

  @override
  _SlotListState createState() => _SlotListState();
}

class _SlotListState extends State<SlotList> {
  var Date = [
    "Mon, 17 Mar 2022 10:30",
    "Mon, 17 Mar 2022 11:00",
    "Mon, 17 Mar 2022 12:00",
    "Mon, 17 Mar 2022 13:00"
  ];
  final startTime = TimeOfDay(hour: 9, minute: 0);
  final endTime = TimeOfDay(hour: 22, minute: 0);
  final step = Duration(minutes: 30);

  List<Slotdata> addselectlistt = List();
  List availablesearch = [];
  bool _customTileExpanded = false;
  String _currentSelectedValue;

  var types = [
    "perishable",
    "live animals",
    "general",
    "radio active",
    "valuable",
  ];
  //var Time_slot = ["9:00-9:30", "9:30-10:00", "10:00-10:30"];
  // var Date = [
  //   "Mon, 17 Mar 2022 09:30",
  //   "Mon, 17 Mar 2022 10:00",
  //   "Mon, 17 Mar 2022 11:30",
  //   "Mon, 17 Mar 2022 12;30"
  // ];
  var addselecteddate = [];
  //var Block = ["A1", "A2", "A3", "A4"];
  var status = ["Booked", "Booked", "Available", "Available"];
  String timeslot;
  var color = [
    Colors.green,
    Colors.green,
    Colors.blue,
    Colors.blue,
    Colors.green,
    Colors.green,
  ];
  var val = -1;
  bool _value = false;
  int defaultChoiceIndex;
  List<String> _choicesList = ['00-06', '06-12', '12-18', "18-00"];

  int i;

  @override
  Widget build(BuildContext context) {
    final times = getTimes(startTime, endTime, step)
        .map((tod) => tod.format(context))
        .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
        S.of(context).AvailableSlot
          //    "Available Slot"
        ),
      ),
      body: Scrollbar(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: buildListView(
              context, availablesearch.length != 0 ? availablesearch : status),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            title: Center(
              child: Text(
              S.of(context).BookYourSlotNow,
                //  'Book your slot now',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 180,
                  child: ListView.builder(
                      itemCount: addselectlistt.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Icon(Icons.alarm),
                          trailing: Text(
                            addselectlistt[index].datetime,
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 15),
                          ),
                        );
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).accentColor)),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                      S.of(context).Cancel,
                        //  'Cancel',
                        style:
                            TextStyle(color: Theme.of(context).backgroundColor),
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).accentColor)),
                      onPressed: () async {
                        //Navigator.pop(context, 'OK');
                        EasyLoading.show(status: 'Please wait...');
                        await Future.delayed(Duration(seconds: 3));
                        setState(() {
                          addselectlistt.forEach((bookList) {
                            int index = SlotBookingList.slotData.indexWhere(
                                (element) => element.id == bookList.id);
                            SlotBookingList.slotData[index].status = "Booked";
                          });
                        });
                        // notifyListeners();
                        EasyLoading.showSuccess('Success!');
                        await Future.delayed(Duration(seconds: 1));
                        EasyLoading.dismiss();
                        print(SlotBookingList.slotData);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SlotBook(
                                      area: widget.area,
                                      number: widget.number,
                                      zone: widget.zone,
                                      sphgroup: widget.sphgroup,
                                      date: widget.date,
                                    )));
                      },
                      child: Text(
                     S.of(context).BookSlot,
                        //   'Book Slot',
                        style:
                            TextStyle(color: Theme.of(context).backgroundColor),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.book),
      ),
    );
  }

  Widget buildListView(BuildContext context, var slotlen) {
    return Consumer<SlotBookingList>(
        builder: (context, slotbookingList, child) {
      List<Slotdata> slotdata = SlotBookingList.slotData;

      return ListView.builder(
        itemBuilder: (BuildContext, index) {
          return (slotdata[index].status != "Booked")
              ? Dismissible(
                  key: ValueKey(slotdata[index]),
                  confirmDismiss: (DismissDirection direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      return await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                           S.of(context).ReleaseBooking,
                              //   "Release Booking",
                              // S
                              //     .of(context)
                              //     .DeleteConfirmation,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                              //"Delete Confirmation"
                            ),
                            content: Text(
                              //"Would you like to Release your Booked Dock & Slot?",
                              S
                                  .of(context)
                                  .WouldyouliketoReleaseyourBookedDockSlot,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                              //"Are you sure you want to delete this item?"
                            ),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () async {
                                    //Navigator.pop(context, 'OK');
                                    EasyLoading.show(status:
                                    S.of(context).Pleasewait
                                      //'Please wait...'
                                    );
                                    await Future.delayed(Duration(seconds: 3));
                                    setState(() {
                                      // slotdata.forEach((bookList) {
                                      //   int index = SlotBookingList.slotData.indexWhere(
                                      //           (element) => element.id == SlotBookingList.slotData[index].id);
                                      if (slotdata[index].status == "Booked")
                                        SlotBookingList.slotData[index].status =
                                            "Available";
                                      // });
                                    });
                                    // notifyListeners();
                                    EasyLoading.showSuccess('Success!');
                                    await Future.delayed(Duration(seconds: 1));
                                    EasyLoading.dismiss();
                                    print(SlotBookingList.slotData);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SlotBook(
                                                  awbnumber: widget.awbnumber,
                                                  driverinfo: widget.driverinfo,
                                                  area: widget.area,
                                                  number: widget.number,
                                                  zone: widget.zone,
                                                  sphgroup: widget.sphgroup,
                                                  date: widget.date,
                                                )));
                                  },
                                  child: Text(
                                   // "Yes",
                                   //  BuildContext context,
                                    S
                                        .of(context)
                                        .Yes,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                    //"Delete"
                                  )),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text(
                                  //"No",
                                  S
                                      .of(context)
                                      .No,
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
                      if (slotdata[index].status != "Available") {
                        return await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                               // "Update Booking",
                                S
                                    .of(context)
                                    .UpdateBooking,
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                                //"Delete Confirmation"
                              ),
                              content: Text(

                                //"Would you like to Update your Booked Dock & Slot?",
                                S
                                    .of(context)
                                    .WouldyouliketoUpdateyourBookedDockSlot,
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                                //"Are you sure you want to delete this item?"
                              ),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UpdateSlot(
                                                awbnumber: widget.awbnumber,
                                                area: widget.area,
                                                zone: widget.zone,
                                                sphgroup: widget.sphgroup,
                                                number: widget.number,
                                                date: widget.date),
                                          ));
                                    },
                                    child: Text(
                                      // "Yes",
                                      // BuildContext context,
                                      S
                                          .of(context)
                                          .Yes,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                      //"Delete"
                                    )),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text(
                                   // "No",
                                     S
                                         .of(context)
                                         .No,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                    // "Cancel"
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
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
                            S.of(context).ReleaseBooking,
                            //"Release Booking"
                              //'Delete'
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
                        // textDirection: TextDirection.rtl,
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
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        slotdata[index].isSelected =
                            !slotdata[index].isSelected;
                        if (slotdata[index].status != "Booked") {
                          if (slotdata[index].isSelected == true) {
                            addselectlistt.add(Slotdata(
                                id: slotdata[index].id,
                                datetime: slotdata[index].datetime,
                                zone: slotdata[index].zone,
                                area: slotdata[index].area,
                                time: slotdata[index].time,
                                status: slotdata[index].status));
                          } else if (slotdata[index].isSelected == false) {
                            addselectlistt.removeWhere((element) =>
                                element.datetime == slotdata[index].datetime);
                          }
                        }

                        print(addselectlistt[index].datetime);
                      });
                    },
                    child: Container(
                      color: (slotdata[index].isSelected == true)
                          ? Theme.of(context).accentColor
                          : null,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.5),
                              width: 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    // (slotdata[index].isSelected==true)?
                                    //     Icon(Icons.check,
                                    //     color: Colors.green,
                                    //     ):
                                    //     Text(""),
                                    Container(
                                      height: 30,
                                      width: 220,
                                      decoration: new BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20.0),
                                            topLeft: Radius.circular(20.0),
                                          ),
                                          color: Theme.of(context)
                                              .accentColor
                                              .withOpacity(0.5)),
                                      child: Center(
                                          child: Text(
                                        slotdata[index].datetime,
                                      )),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                  ],
                                ),
                              ),
                              Stack(
                                children: <Widget>[
                                  (slotdata[index].status == "Booked")
                                      ? Positioned(
                                          top: 16,
                                          left: 10,
                                          child: Text(
                                            "176-00122474",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                        )
                                      : Text(""),
                                  Center(
                                    child: Image.network(
                                      "https://img.icons8.com/external-konkapp-detailed-outline-konkapp/344/external-truck-transportation-konkapp-detailed-outline-konkapp.png",
                                      // "https://img.icons8.com/external-xnimrodx-lineal-gradient-xnimrodx/344/external-truck-distribution-xnimrodx-lineal-gradient-xnimrodx.png",
                                      // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPG8TFydMwTjrdYDzECimH5JWcrwKmV1RrUQ&usqp=CAU",
                                      width: 50,
                                      height: 50,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  (slotdata[index].status == "Booked")
                                      ? Positioned(
                                          top: 16,
                                          right: 50,
                                          child: Text(
                                            widget.driverinfo,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                        )
                                      : Text(""),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Row(
                                    //   children: [
                                    //     Icon(
                                    //       Icons.location_on_rounded,
                                    //       color: Theme.of(context).accentColor,
                                    //     ),
                                    //     Text(
                                    //       slotdata[index].area,
                                    //       style: TextStyle(
                                    //           color: Theme.of(context).accentColor),
                                    //     ),
                                    //   ],
                                    // ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        Text(
                                          "30 min",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                      ],
                                    ),
                                    (slotdata[index].status == "Available")
                                        ? TextButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.blue),
                                                shape: MaterialStateProperty
                                                    .all(RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10.0
                                                                // topLeft:
                                                                // Radius.circular(14.0),
                                                                // bottomRight:
                                                                // Radius.circular(14.0)
                                                                )))),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20)),
                                                  ),
                                                  context: context,
                                                  builder: (bc) {
                                                    return Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .40,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(18.0),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                   S.of(context).BookYourSlotNow,
                                                                    // "Book Your Slot Now",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Theme.of(context)
                                                                            .accentColor),
                                                                  ),
                                                                  Spacer(),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      color: Theme.of(
                                                                              context)
                                                                          .accentColor,
                                                                      icon: Icon(
                                                                          Icons
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
                                                                          const EdgeInsets.all(
                                                                              5),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Text(
                                                                          S.of(context).SlotDateTime,
                                                                            //  "Slot Date & Time :",
                                                                            style: TextStyle(
                                                                                fontSize: 17,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Theme.of(context).accentColor),
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
                                                                              child: Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 50),
                                                                            child:
                                                                                Text(
                                                                              slotdata[index].datetime,
                                                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Theme.of(context).accentColor),
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
                                                                      child: ElevatedButton
                                                                          .icon(
                                                                    onPressed:
                                                                        () async {
                                                                      //Navigator.pop(context, 'OK');
                                                                      EasyLoading.show(
                                                                          status:
                                                                        S.of(context).Pleasewait
                                                                      //    'Please wait...'
                                                                      );
                                                                      await Future.delayed(Duration(
                                                                          seconds:
                                                                              3));
                                                                      setState(
                                                                          () {
                                                                        if (slotdata[index].status ==
                                                                            "Available")
                                                                          SlotBookingList
                                                                              .slotData[index]
                                                                              .status = "Booked";
                                                                      });
                                                                      // notifyListeners();
                                                                      EasyLoading
                                                                          .showSuccess(
                                                                        S.of(context).Success
                                                                        //'Success!'
                                                                      );
                                                                      await Future.delayed(Duration(
                                                                          seconds:
                                                                              1));
                                                                      EasyLoading
                                                                          .dismiss();
                                                                      print(SlotBookingList
                                                                          .slotData);
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => SlotBook(
                                                                                    awbnumber: widget.awbnumber,
                                                                                    driverinfo: widget.driverinfo,
                                                                                    area: widget.area,
                                                                                    number: widget.number,
                                                                                    zone: widget.zone,
                                                                                    sphgroup: widget.sphgroup,
                                                                                    date: widget.date,
                                                                                awbnumber2: "",
                                                                                awbnumber3: "",
                                                                                  )));
                                                                    },
                                                                    style:
                                                                        ButtonStyle(
                                                                      backgroundColor:
                                                                          MaterialStateProperty.all(
                                                                              Theme.of(context).backgroundColor),
                                                                    ),
                                                                    icon: Icon(
                                                                      Icons
                                                                          .cloud_circle,
                                                                      size: 18,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .accentColor,
                                                                    ),
                                                                    label: Text(
                                                                    S.of(context).BookSlot,
                                                                      //  "Book Slot",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Theme.of(context).accentColor),
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
                                                S.of(context).Available,
                                                  //  "Available",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .backgroundColor,
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
                                          )
                                        : TextButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.green),
                                                shape: MaterialStateProperty
                                                    .all(RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10.0
                                                                // topLeft:
                                                                // Radius.circular(14.0),
                                                                // bottomRight:
                                                                // Radius.circular(14.0)

                                                                )))),
                                            onPressed: () {},
                                            child: Row(
                                              children: [
                                                Text(
                                                  S.of(context).Booked,
                                                  //"Booked",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .backgroundColor,
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
                                          )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Text("");
        },
        itemCount: slotdata.length,
        shrinkWrap: true,
        padding: EdgeInsets.all(8),
        scrollDirection: Axis.vertical,
      );
    });
  }

  Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }
}
