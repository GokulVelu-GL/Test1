import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../model/eawb_model.dart';
import '../house_details.dart';
import 'create_data_screen.dart';
import 'edit_screen.dart';
import 'model_class.dart';

class ShowDataScreen extends StatefulWidget {
  const ShowDataScreen({Key key}) : super(key: key);

  @override
  State<ShowDataScreen> createState() => _ShowDataScreenState();
}

class _ShowDataScreenState extends State<ShowDataScreen> {

  @override
  void dispose() {
    Hive.box('AwbList').close();
    //or
    //Close all boxes
    // Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              image: AssetImage('assets/images/flight_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          S.of(context).AWBList,
          //"AWB List",
          textAlign: TextAlign.center,
          style: TextStyle(

            // color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        elevation: 1,
        actions: [
          IconButton(onPressed: (){
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
                title:  Center(child: Text("Help",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold
                  ),
                )),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("The most recently created AWB will be shown on the top",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,

                      ),
                    ),
                    Text("Please use Search option if you would like to find any AWB based on AWB Prefix, AWB Serial, AWB Origin Airport Code and AWB Destination Airport Code",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: Theme.of(context).accentColor
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Container(
                      child:  Center(child: Text("Close",
                          style: TextStyle(
                              color: Theme.of(context).accentColor
                          )
                      )),
                    ),
                  ),
                ],
              ),
            );
          }, icon: Icon(Icons.help)),
          IconButton(
            onPressed: () {
              //Delete All Box
              Hive.box('AwbList').clear();
            },
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final hiveBox = Hive.box('AwbList');
           if(hiveBox.length<4) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CreateDataScreen(),
              ),
            );
           }
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: Hive.openBox('AwbList'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final hiveBox = Hive.box('AwbList');

            return ValueListenableBuilder(
              valueListenable: hiveBox.listenable(),
              builder: (context, Box box, child) {
                if (box.isEmpty) {
                  return const Center(
                    child: Text('Empty'),
                  );
                } else {
                  return ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount:  hiveBox.length,

                    itemBuilder: (context, index) {

                      final helper = hiveBox.getAt(index) as AwbListOffline;
                      if(index==3){
                        Fluttertoast.showToast(
                            msg: 'Maximum 4 AWB Only allowed in Offline',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.red,
                            textColor: Colors.white
                        );
                      }
                      return Dismissible(
                           key: ValueKey(helper),
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
                                      TextButton(
                                          onPressed: () {
                                            hiveBox.deleteAt(index);
                                            Navigator.of(context).pop(true);
                                          },
                                          child: Text(
                                            // BuildContext context,
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
                                          // "Cancel"
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditScreen(
                                      index: index,
                                      age: helper.airline,
                                      name: helper.pieces,
                                      phone: helper.weight,
                                    ),
                                  ),
                                );
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
                                                helper.origin,
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
                                                  padding: const EdgeInsets.all(6.0),
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
                                                                              .black
                                                                        //.shade300
                                                                      ),
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
                                                helper.destination,
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
                                            children: <Widget>[
                                              Container(
                                                  child: Text(
                                                    S.of(context).Pieces,
                                                    //"Pieces",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      //color: Colors.deepPurpleAccent,
                                                      color: Theme.of(context).accentColor,
                                                    ),
                                                  )),
                                              SizedBox(
                                                width: 60,
                                              ),
                                              SizedBox(
                                                width: 180,
                                              ),
                                              Container(
                                                  child: Text(
                                                    S.of(context).Weight,
                                                    //"Weight",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Theme.of(context).accentColor,
                                                      // color: Colors.deepPurpleAccent,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          // SizedBox(height: 2),
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
                                                      padding: const EdgeInsets.only(
                                                          top: 3.0, bottom: 3.0),
                                                      child: Text(
                                                        helper.pieces,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            // color: Colors.black54,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    )),
                                              ),
                                              Container(
                                                //color: Colors.lightBlueAccent,
                                                  child: Text(
                                                    helper.airline+"-"+helper.masterAWB,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        //color: Colors.black,
                                                        color: Theme.of(context).accentColor,
                                                        fontWeight: FontWeight.bold),
                                                  )),
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(10.0),
                                                        // color: Colors.lightBlueAccent,
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(5.0),
                                                        child: Text(
                                                          helper.weight,
                                                          style: TextStyle(
                                                              fontSize: 14,
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
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          // CustomPaint(
                                          //   painter: CirclePainter(
                                          //       _controller,
                                          //     color: color,
                                          //     // color: Theme.of(context).accentColor
                                          //   ),
                                          //   child: SizedBox(
                                          //       height: 10,
                                          //       width:10,
                                          //       child: Icon(Icons.dangerous_outlined, size: 10,
                                          //         color:
                                          //         Theme.of(context).backgroundColor,
                                          //       )
                                          //     //_button(),
                                          //   ),
                                          // ),
                                          Container(
                                            height: 30,
                                            child: Padding(
                                                padding: const EdgeInsets.all(0.0),
                                                child: PopupMenuButton(
                                                    child: Container(
                                                      padding: EdgeInsets.all(3),
                                                      decoration: BoxDecoration(
                                                          color: Theme.of(context).accentColor.withOpacity(0.3),
                                                          // color: Colors.amber.shade50,
                                                          borderRadius:
                                                          BorderRadius.circular(20)),
                                                      child: Icon(
                                                        Icons.flight_takeoff,
                                                        color: Theme.of(context).accentColor,
                                                        // color: Colors.amber
                                                      ),
                                                    ),
                                                    itemBuilder: (context) => [
                                                      // PopupMenuItem(
                                                      //
                                                      //   child: Consumer<EAWBModel>(
                                                      //     builder: (BuildContext context,
                                                      //         model, Widget child) {
                                                      //       return TextButton(
                                                      //           style: TextButton.styleFrom(
                                                      //             // primary: Colors.purpleAccent,
                                                      //             // backgroundColor: Colors.black, // Background Color
                                                      //           ),
                                                      //           onPressed: () {
                                                      //             model.clearEAWB();
                                                      //           model.awbConsigmentOriginPrefix =
                                                      //             '${getawblist[index]["origin"]}';
                                                      //             model.awbConsigmentDestination =
                                                      //             '${getawblist[index]["destination"]}';
                                                      //             model.awbConsigmentPices =
                                                      //             '${getawblist[index]["pieces"]}';
                                                      //             model.awbConsigmentPices =
                                                      //             '${getawblist[index]["weight"]}';
                                                      //             model.awbConsigmentPices =
                                                      //             '${getawblist[index]["weightcode"]}';
                                                      //             model
                                                      //                 .getEAWB(
                                                      //                 '${getawblist[index]["id"]}')
                                                      //                 .then(
                                                      //                     (value) async {
                                                      //                   if (value == 'New Air Waybill Number') {
                                                      //                     SharedPreferences
                                                      //                     prefs =
                                                      //                     await SharedPreferences
                                                      //                         .getInstance();
                                                      //                     prefs.setString(
                                                      //                         "awbListid",
                                                      //                         '${getawblist[index]["id"]}');
                                                      //                     model.awbConsigmentDetailsAWBNumber =
                                                      //                     '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}';
                                                      //                     Navigator.pop(
                                                      //                         context);
                                                      //                     _displayCreateAWBDialog(
                                                      //                         context,
                                                      //                         '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}');
                                                      //                     //
                                                      //                   } else {
                                                      //                     print(
                                                      //                         "DATA FROM getEAWB $value");
                                                      //
                                                      //                     model.awbConsigmentDetailsAWBNumber =
                                                      //                     '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}';
                                                      //                     Navigator.of(
                                                      //                         context)
                                                      //                         .push(
                                                      //                         HomeScreenRoute(
                                                      //                             MainEAWB(
                                                      //                               awbNumber:
                                                      //                               '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}',
                                                      //                             )
                                                      //                         ));
                                                      //                   }
                                                      //                 });
                                                      //           },
                                                      //           child: Column(
                                                      //             children: [
                                                      //               Text(
                                                      //                 S.of(context).AWBdetails,
                                                      //                 style: TextStyle(
                                                      //                   color: Theme.of(context).accentColor,
                                                      //                 ),
                                                      //                 //"AWB Details"
                                                      //               ),
                                                      //               // Divider(
                                                      //               //   color: Theme.of(context).accentColor,thickness: 2,
                                                      //               // ),
                                                      //             ],
                                                      //           ));
                                                      //     },
                                                      //   ),
                                                      //   value: 2,
                                                      // ),
                                                      // // Divider(
                                                      // //   color: Colors.black,
                                                      // // ),
                                                      // //PopupMenuDivider(),
                                                      // PopupMenuItem(
                                                      //   child: Container(
                                                      //     child: TextButton(
                                                      //         onPressed: () {
                                                      //           // Navigator.push(
                                                      //           //     context,
                                                      //           //     MaterialPageRoute(
                                                      //           //       builder: (context) =>
                                                      //           //           EditEawb(
                                                      //           //               '${getawblist[index]["prefix"]}-${getawblist[index]["wayBillNumber"]}',
                                                      //           //               '${getawblist[index]["id"]}'),
                                                      //           //     ));
                                                      //         },
                                                      //         child: Text(
                                                      //           S
                                                      //               .of(context)
                                                      //               .HouseDetails,
                                                      //           style: TextStyle(
                                                      //             color: Theme.of(context)
                                                      //                 .accentColor,
                                                      //           ),
                                                      //           // "House Details"
                                                      //         )),
                                                      //   ),
                                                      //   value: 1,
                                                      // ),
                                                    ],

                                                    // offset: Offset(0, 30),
                                                    // elevation: 2,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(20.0),
                                                      ),
                                                    ))),
                                          ),
                                          Row(
                                            children: [
                                              Text(DateTime.now().toString()),
                                            ],
                                          ),

                                          TextButton(
                                            onPressed: () {
                                              // showDialog(
                                              //     context: context,
                                              //     builder: (BuildContext context) {
                                              //       return AlertDialog(
                                              //         shape: RoundedRectangleBorder(
                                              //             borderRadius: BorderRadius.all(
                                              //                 Radius.circular(15.0))),
                                              //         title: Center(
                                              //             child: Text(
                                              //               S.of(context).Createddateandtime,
                                              //               //'Created date and time',
                                              //               style: TextStyle(
                                              //                   color:
                                              //                   Theme.of(context).accentColor,
                                              //                   fontStyle: FontStyle.italic),
                                              //             )),
                                              //         content: Container(
                                              //             child: Card(
                                              //               child: Column(
                                              //                 mainAxisSize: MainAxisSize.min,
                                              //                 children: [
                                              //                   Row(
                                              //                     mainAxisAlignment: MainAxisAlignment.center,
                                              //                     crossAxisAlignment: CrossAxisAlignment.start,
                                              //                     children: [
                                              //                       Text('${getawblist[index]["Created_User"]}',
                                              //                         style: TextStyle(
                                              //                             color: Theme.of(context)
                                              //                                 .accentColor),
                                              //                       ),
                                              //                     ],
                                              //                   ),
                                              //                   Padding(
                                              //                     padding:
                                              //                     const EdgeInsets.all(8.0),
                                              //                     child: Row(
                                              //                       mainAxisAlignment:
                                              //                       MainAxisAlignment.center,
                                              //                       //crossAxisAlignment: CrossAxisAlignment.start,
                                              //                       children: [
                                              //                         // Text(
                                              //                         //   '${loginhistoryD[index]["origin"]}',
                                              //                         //   // '${userid[index]}',
                                              //                         //   style: TextStyle(
                                              //                         //       color: Colors.grey,
                                              //                         //       fontWeight: FontWeight.bold),
                                              //                         // ),
                                              //                         Text(
                                              //                           '${getawblist[index]["Created_Time"]}',
                                              //                           // '${ipaddr[index]}',
                                              //                           style: TextStyle(
                                              //                               color:
                                              //                               Theme.of(context)
                                              //                                   .accentColor),
                                              //                         ),
                                              //                       ],
                                              //                     ),
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //             )),
                                              //         actions: <Widget>[
                                              //           Center(
                                              //             child: new FlatButton(
                                              //               onPressed: () {
                                              //                 Navigator.of(context).pop();
                                              //               },
                                              //               //textColor: Theme.of(context).primaryColor,
                                              //               child: Text(
                                              //                   S.of(context).Close,
                                              //                   //'Close',
                                              //                   style: TextStyle(
                                              //                     color: Theme.of(context)
                                              //                         .accentColor,
                                              //                   )),
                                              //             ),
                                              //           ),
                                              //         ],
                                              //       );
                                              //     });
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )));
                      //original offline data
                      //   ListTile(
                      //   trailing: IconButton(
                      //     onPressed: () {
                      //       showDialog(
                      //         context: context,
                      //         useSafeArea: true,
                      //         builder: (context) => AlertDialog(
                      //           scrollable: true,
                      //           title: const Text('Delete'),
                      //           content: const Text('Do you want delete it?'),
                      //           actions: [
                      //             ElevatedButton(
                      //               style: ElevatedButton.styleFrom(
                      //                 // backgroundColor: Colors.red,
                      //               ),
                      //               onPressed: () {
                      //                 hiveBox.deleteAt(index);
                      //                 Navigator.pop(context);
                      //               },
                      //               child: const Text(
                      //                 'Delete it',
                      //                 style: TextStyle(
                      //                   color: Colors.white,
                      //                 ),
                      //               ),
                      //             ),
                      //             TextButton(
                      //               onPressed: () {
                      //                 Navigator.pop(context);
                      //               },
                      //               child: const Text('Return'),
                      //             ),
                      //           ],
                      //         ),
                      //       );
                      //     },
                      //     icon: const Icon(
                      //       Icons.delete,
                      //       color: Colors.red,
                      //     ),
                      //   ),
                      //   leading: IconButton(
                      //     onPressed: () {
                      //       Navigator.of(context).push(
                      //         MaterialPageRoute(
                      //           builder: (context) => EditScreen(
                      //             index: index,
                      //             age: helper.airline,
                      //             name: helper.pieces,
                      //             phone: helper.weight,
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //     icon: const Icon(
                      //       Icons.edit,
                      //       color: Colors.green,
                      //     ),
                      //   ),
                      //   title: Text(helper.airline),
                      //   subtitle: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text('Phone: ${helper.pieces}'),
                      //       Text('Age: ${helper.weight}'),
                      //     ],
                      //   ),
                      // );
                    },
                  );
                }
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}