import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import 'Slot_book.dart';

class Multipleawbslotbooking extends StatefulWidget {
  const Multipleawbslotbooking({Key key}) : super(key: key);

  @override
  _MultipleawbslotbookingState createState() => _MultipleawbslotbookingState();
}

class _MultipleawbslotbookingState extends State<Multipleawbslotbooking> {
  var Date=[
    "Mon, 22 Mar 2022 09:00-11:00",
    "Mon, 22 Mar 2022 14:00-16:00",
  ];
  var color=[
    Colors.green,
    Colors.blue
  ];

  var Block=[
    "A1 block",
    "A1 block"
  ];
  var status=[
    "Booked",
    "Available"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 50.0),
          child: Text(
            "Slot Booking"
          ),
        ),
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ListTile(
              // leading:  Wrap(
              //   spacing: 6.0,
              //   runSpacing: 6.0,
              //   children: <Widget>[
              //     _buildChip1('9:30',Colors.green),
              //     _buildChip1('10:00', Colors.green),
              //     _buildChip('10:30', Colors.blue),
              //     _buildChip('11:00', Colors.blue),
              //     // _buildChip1('11:30', Colors.green),
              //     // _buildChip('12:00', Colors.blue),
              //     // _buildChip1('12:30', Colors.green),
              //     // _buildChip('13:00', Colors.blue),
              //
              //     // _buildChip('11:00', Colors.blue),
              //   ],
              // ),
              trailing: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                onPressed: (){
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
                        child:   Center(
                          child: Container(
                            child:  Wrap(
                              spacing: 8.0,
                              runSpacing: 6.0,
                              children: <Widget>[
                                // _buildChip('Show All', Color(0xFFff6666)),
                                // _buildChip('Available Slot', Colors.blue),
                                // GestureDetector(
                                //   onTap:(){
                                //     Available();
                                //   },
                                //   child: Chip(
                                //     labelPadding: EdgeInsets.all(2.0),
                                //     // avatar: CircleAvatar(
                                //     //   backgroundColor: Colors.white70,
                                //     //   child: Text("Time".toUpperCase()),
                                //     // ),
                                //     label: Text(
                                //       "Available",
                                //       style: TextStyle(
                                //         color: Colors.black,
                                //       ),
                                //     ),
                                //     backgroundColor: Colors.blue,
                                //     elevation: 5.0,
                                //     shadowColor: Colors.grey[60],
                                //     padding: EdgeInsets.all(8.0),
                                //   ),
                                // ),


                                // _buildChip('Available slot',Colors.blue ),
                                _buildChip1('Booked slot', Colors.green),
                                // _buildChip('11:00', Colors.blue),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Icon(Icons.filter_alt_outlined),

              ),
            ),
            // Container(
            //   child: GridView.builder(
            //       itemCount: Time_slot.length,
            //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 3,
            //
            //   ), itemBuilder: (context,index)=>
            //   Card(
            //     child: GridTile(
            //       child: Center(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Text(Time_slot[index]),
            //           ],
            //         ),
            //       ),
            //     ),
            //   )
            //   ),
            // ),
            Container(
              child:ListView.builder(
                itemBuilder: (BuildContext, index) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Theme
                          .of(context)
                          .accentColor
                          .withOpacity(0.5), width: 1),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0)
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  height: 30,
                                  width: 220,
                                  decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(20.0),
                                        topLeft: Radius.circular(20.0),
                                      ),
                                      color: Theme
                                          .of(context)
                                          .accentColor
                                          .withOpacity(0.5)
                                  ),

                                  child: Center(
                                      child: Text(Date[index])),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.all(6),
                                  //child: Icon(Icons.flight_takeoff,color:Colors.amber),
                                  decoration: BoxDecoration(
                                      color: color[index],
                                      borderRadius: BorderRadius.circular(20)),

                                  child: SizedBox(
                                    height: 8,
                                    width: 8,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Theme
                                              .of(context)
                                              .backgroundColor,
                                          borderRadius:
                                          BorderRadius.circular(5)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 3,
                                ),

                                Container(
                                  //  padding: EdgeInsets.only(left: 5),
                                  child: Column(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Text(""),
                                      Container(
                                          child: Text("Zone")),
                                      Text(
                                        Block[index],
                                        style: TextStyle(
                                          color: color[index],
                                        ),

                                        //"A1 block"
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Stack(
                            children: <Widget>[
                              SizedBox(
                                height: 45,
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
                                child: Image.network(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPG8TFydMwTjrdYDzECimH5JWcrwKmV1RrUQ&usqp=CAU",
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on_rounded,
                                    color: Theme
                                        .of(context)
                                        .accentColor,
                                  ),
                                  Text("blue building"),
                                ],
                              ),

                              // Image.network(
                              //   "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPG8TFydMwTjrdYDzECimH5JWcrwKmV1RrUQ&usqp=CAU",
                              //   width: 50,
                              //   height: 50,
                              // ),
                              Row(
                                children: [

                                  Icon(Icons.access_time,
                                    color: Theme
                                        .of(context)
                                        .accentColor,
                                  ),
                                  Text("30 mins"),
                                  SizedBox(
                                    width: 8,
                                  ),

                                ],),
                              (status[index]=="Available")
                                  ?
                              TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).accentColor),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft:Radius.circular(14.0),
                                        bottomRight: Radius.circular(14.0)
                                    )))
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
                                      builder: ( bc) {
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
                                                        "Book Your Slot Now",
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
                                                                      Date[index],
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
                                                              // "Book Slot",
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
                                      //  "Available",
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
                              ):
                              TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.green),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft:Radius.circular(14.0),
                                        bottomRight: Radius.circular(14.0)
                                    )))
                                ),
                                onPressed: () {
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      S.of(context).Booked,
                                      //"Booked",
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
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                  );
                },
                itemCount: status.length,
                shrinkWrap: true,
                padding: EdgeInsets.all(8),
                scrollDirection: Axis.vertical,


              ),
            ),

          ],
        ),
      ),
    );
  }
  _buildChip1(String s, Color color) {
    return GestureDetector(
      onTap: (){
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (BuildContext context) => SlotBooked(
        //     )));
      },
      child: Chip(
        labelPadding: EdgeInsets.all(2.0),
        // avatar: CircleAvatar(
        //   backgroundColor: Colors.white70,
        //   child: Text("Time".toUpperCase()),
        // ),
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
}

