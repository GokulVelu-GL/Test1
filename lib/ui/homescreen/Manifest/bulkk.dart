import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/ui/homescreen/emanifest.dart';

class BulkList extends StatefulWidget {
  @override
  State<BulkList> createState() => BulkListState();
}

class BulkListState extends State<BulkList> {
  final List<ExpenseList> expenseList = [];
  bool _customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                            Navigator.of(context).pop(true);
                            // Emaildelete(e.id);
                          },
                          child: Text(
                            // BuildContext context,
                            S.of(context).Delete,
                            //"Delete",
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          )),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(
                          S.of(context).Cancel,
                          //"Cancel",
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
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
          //key: ValueKey(e),
          child: Card(
            // color: Colors.blue,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Theme.of(context).accentColor.withOpacity(0.5),
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
                            child: Text("618-27257053",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            width: 13,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.greenAccent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(05)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  "Manifest",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                ),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "HKG",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
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
                            "NRT",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "COCONUTS",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "pcs/Totpcs",
                                    style: TextStyle(
                                        fontSize: 09,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).accentColor),
                                  ),
                                  Text(
                                    "10/10",
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
                                        color: Theme.of(context).accentColor),
                                  ),
                                  Text(
                                    "1000/1000 Kg",
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Special Handling",
                                style: TextStyle(
                                    fontSize: 09,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).accentColor),
                              ),
                              Text(
                                "PER",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
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
                                    color: Theme.of(context).accentColor),
                              ),
                              Text(
                                "NONE",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "1.0",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "MC",
                                style: TextStyle(
                                    fontSize: 09,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).accentColor),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                trailing: Icon(
                  _customTileExpanded ? Icons.arrow_drop_down : Icons.info,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Onward",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context).accentColor),
                                ),
                                Text(
                                  "NRT / JL",
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
                                  "Shipping Bill Number",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context).accentColor),
                                ),
                                Text(
                                  "20202021",
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
                                  "Scan Type",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context).accentColor),
                                ),
                                Text(
                                  "X-RAY",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Manifest Remarks ",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context).accentColor),
                                ),
                                Text(
                                  "CLEARED",
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
                                  "Office Use Remarks",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context).accentColor),
                                ),
                                Text(
                                  "VIP SHIPPER",
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
                                  "Internal Remarks",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context).accentColor),
                                ),
                                Text(
                                  "CREDIT ",
                                  style: TextStyle(
                                    fontSize: 18,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Physical Verification",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context).accentColor),
                                ),
                                Text(
                                  "No",
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
                                  "Scanned Indicator",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context).accentColor),
                                ),
                                Text(
                                  "Yes",
                                  style: TextStyle(
                                    fontSize: 18,
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
      ),

      //ADD BULK
      // Container(
      //   child: Column(
      //     children: expenseList.map((e) {
      //       return Column(
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           Dismissible(
      //             key: ValueKey(e),
      //             confirmDismiss:
      //                 (DismissDirection direction) async {
      //               if (direction == DismissDirection.startToEnd) {
      //                 return await showDialog(
      //                   context: context,
      //                   builder: (BuildContext context) {
      //                     return AlertDialog(
      //                       title: Text(
      //                         S.of(context).DeleteConfirmation,
      //                         style: TextStyle(
      //                             color: Theme.of(context)
      //                                 .accentColor),
      //                         //"Delete Confirmation"
      //                       ),
      //                       content: Text(
      //                         S
      //                             .of(context)
      //                             .Areyousureyouwanttodeletethisitem,
      //                         style: TextStyle(
      //                             color: Theme.of(context)
      //                                 .accentColor),
      //                         //"Are you sure you want to delete this item?"
      //                       ),
      //                       actions: <Widget>[
      //                         FlatButton(
      //                             onPressed: () {
      //                               Navigator.of(context).pop(true);
      //                               Emaildelete(e.id);
      //                             },
      //                             child: Text(
      //                               // BuildContext context,
      //                               S.of(context).Delete,
      //                               style: TextStyle(
      //                                   color: Theme.of(context)
      //                                       .accentColor),
      //                               //"Delete"
      //                             )),
      //                         FlatButton(
      //                           onPressed: () =>
      //                               Navigator.of(context)
      //                                   .pop(false),
      //                           child: Text(
      //                             S.of(context).Cancel,
      //                             style: TextStyle(
      //                                 color: Theme.of(context)
      //                                     .accentColor),
      //                             // "Cancel"
      //                           ),
      //                         ),
      //                       ],
      //                     );
      //                   },
      //                 );
      //               } else {
      //                 _displayDialog(context);
      //                 // Navigator.push(
      //                 //     context,
      //                 //     MaterialPageRoute(
      //                 //       builder: (context) => EditHawb(
      //                 //         '${getawblist[index]["prefix"]}',
      //                 //         '${getawblist[index]["wayBillNumber"]}',
      //                 //         '${getawblist[index]["id"]}',
      //                 //         '${getawblist[index]["destination"]}',
      //                 //         '${getawblist[index]["origin"]}',
      //                 //         '${getawblist[index]["shipmentcode"]}',
      //                 //         '${getawblist[index]["pieces"]}',
      //                 //         '${getawblist[index]["weight"]}',
      //                 //         '${getawblist[index]["weightcode"]}',
      //                 //       ),
      //                 //     ));
      //                 return false;
      //               }
      //             },
      //             onDismissed: (direction) {
      //               if (direction == DismissDirection.startToEnd) {}
      //             },
      //             background: Container(
      //               color: Colors.red,
      //               child: Padding(
      //                 padding: const EdgeInsets.all(15),
      //                 child: Row(
      //                   children: [
      //                     Icon(Icons.delete, color: Colors.white),
      //                     SizedBox(
      //                       width: 10,
      //                     ),
      //                     Text(
      //                         S.of(context).Delete
      //                         //'Delete'
      //                         ,
      //                         style:
      //                             TextStyle(color: Colors.white)),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //             secondaryBackground: Container(
      //               color: Colors.blue,
      //               child: Padding(
      //                 padding: const EdgeInsets.all(15),
      //                 child: Row(
      //                   // textDirection: TextDirection.rtl,
      //                   children: [
      //                     Icon(Icons.edit, color: Colors.white),
      //                     SizedBox(
      //                       width: 10,
      //                     ),
      //                     Text(
      //                       S.of(context).UpdateDetails,
      //                       //'Update Details',
      //                       style: TextStyle(color: Colors.white),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //             child: Container(
      //               width: MediaQuery.of(context).size.width,
      //               child: Card(
      //                 // color: Colors.blue,
      //                 shape: RoundedRectangleBorder(
      //                   side: BorderSide(
      //                       color: Theme.of(context)
      //                           .accentColor
      //                           .withOpacity(0.5),
      //                       width: 1),
      //                   borderRadius: BorderRadius.only(
      //                       bottomLeft: Radius.circular(10.0),
      //                       topLeft: Radius.circular(10.0),
      //                       topRight: Radius.circular(10.0),
      //                       bottomRight: Radius.circular(10.0)),
      //                 ),
      //                 child: ClipRRect(
      //                   clipBehavior: Clip.hardEdge,
      //                   borderRadius: BorderRadius.circular(10.0),
      //                   child: ExpansionTile(
      //                     textColor: Colors.black,
      //                     title: Container(
      //                       child: Column(
      //                         children: [
      //                           Center(
      //                               child: Text(
      //                             '${e.title}' +
      //                                 '-' +
      //                                 '${e.serialNo}',
      //                             style: TextStyle(
      //                               fontSize: 18,
      //                             ),
      //                           )),
      //                           Row(
      //                             mainAxisAlignment:
      //                                 MainAxisAlignment.spaceEvenly,
      //                             children: [
      //                               Text(
      //                                 '${e.origin}',
      //                                 style: TextStyle(
      //                                   fontSize: 20,
      //                                 ),
      //                               ),
      //                               Icon(
      //                                 Icons.flight_takeoff,
      //                                 color: Theme.of(context)
      //                                     .accentColor,
      //                                 size: 18,
      //                               ),
      //                               for (int i = 0; i < 25; i++)
      //                                 Container(
      //                                   width: 5,
      //                                   height: 1,
      //                                   decoration: BoxDecoration(
      //                                     border: Border(
      //                                       bottom: BorderSide(
      //                                         width: 2,
      //                                         color: i % 2 == 0
      //                                             ? const Color
      //                                                     .fromRGBO(
      //                                                 214,
      //                                                 211,
      //                                                 211,
      //                                                 1)
      //                                             : Colors
      //                                                 .transparent,
      //                                       ),
      //                                     ),
      //                                   ),
      //                                 ),
      //                               //DEST
      //                               Row(
      //                                 children: [
      //                                   Icon(
      //                                     Icons.flight_land,
      //                                     size: 18,
      //                                     color: Theme.of(context)
      //                                         .accentColor,
      //                                   ),
      //                                   Text(
      //                                     '${e.destination}',
      //                                     style: TextStyle(
      //                                       fontSize: 20,
      //                                     ),
      //                                   )
      //                                 ],
      //                               ),
      //                             ],
      //                           ),
      //                           Row(
      //                             mainAxisAlignment:
      //                                 MainAxisAlignment
      //                                     .spaceBetween,
      //                             children: [
      //                               Row(
      //                                 children: [
      //                                   Column(
      //                                     crossAxisAlignment:
      //                                         CrossAxisAlignment
      //                                             .start,
      //                                     children: [
      //                                       Text(
      //                                         '${e.pieces}' +
      //                                             '/' +
      //                                             '${e.total_pieces}',
      //                                         style: TextStyle(
      //                                           fontSize: 20,
      //                                         ),
      //                                       ),
      //                                       Text(
      //                                         "pcs/Totpcs",
      //                                         style: TextStyle(
      //                                             fontSize: 13,
      //                                             color: Theme.of(
      //                                                     context)
      //                                                 .accentColor),
      //                                       )
      //                                     ],
      //                                   ),
      //                                 ],
      //                               ),
      //                               Text(
      //                                 '${e.Nature_Of_Goods}',
      //                                 style: TextStyle(
      //                                   fontSize: 16,
      //                                 ),
      //                               ),
      //                               Row(
      //                                 children: [
      //                                   Column(
      //                                     children: [
      //                                       Text(
      //                                         '${e.weight}' +
      //                                             '/' +
      //                                             '${e.total_weight}',
      //                                         style: TextStyle(
      //                                           fontSize: 20,
      //                                         ),
      //                                       ),
      //                                       Text(
      //                                         "Wgt/TotWgt",
      //                                         style: TextStyle(
      //                                             fontSize: 13,
      //                                             color: Theme.of(
      //                                                     context)
      //                                                 .accentColor),
      //                                       )
      //                                     ],
      //                                   ),
      //                                   Text(
      //                                     '${e.weight_unit}',
      //                                   )
      //                                 ],
      //                               ),
      //                             ],
      //                           ),
      //                           Row(
      //                             mainAxisAlignment:
      //                                 MainAxisAlignment
      //                                     .spaceBetween,
      //                             children: [
      //                               Column(
      //                                 crossAxisAlignment:
      //                                     CrossAxisAlignment.start,
      //                                 children: [
      //                                   Text(
      //                                     '${e.origin}',
      //                                     style: TextStyle(
      //                                       fontSize: 18,
      //                                     ),
      //                                   ),
      //                                   Text(
      //                                     "Special Handling",
      //                                     style: TextStyle(
      //                                         fontSize: 13,
      //                                         color:
      //                                             Theme.of(context)
      //                                                 .accentColor),
      //                                   )
      //                                 ],
      //                               ),
      //                               Column(
      //                                 children: [
      //                                   Text(
      //                                     '${e.mash}',
      //                                     style: TextStyle(
      //                                       fontSize: 18,
      //                                     ),
      //                                   ),
      //                                   Text(
      //                                     "P/D/S",
      //                                     style: TextStyle(
      //                                         fontSize: 13,
      //                                         color:
      //                                             Theme.of(context)
      //                                                 .accentColor),
      //                                   )
      //                                 ],
      //                               ),
      //                               Row(
      //                                 children: [
      //                                   Text(
      //                                     '${e.volume}',
      //                                     style: TextStyle(
      //                                       fontSize: 20,
      //                                     ),
      //                                   ),
      //                                   Text(
      //                                     '${e.volumeUnit}',
      //                                     style: TextStyle(
      //                                         fontSize: 13,
      //                                         color:
      //                                             Theme.of(context)
      //                                                 .accentColor),
      //                                   ),
      //                                 ],
      //                               )
      //                             ],
      //                           )
      //                         ],
      //                       ),
      //                     ),
      //                     trailing: Icon(
      //                       _customTileExpanded
      //                           ? Icons.arrow_drop_down
      //                           : Icons.info,
      //                       color: Theme.of(context).accentColor,
      //                     ),
      //                     children: <Widget>[
      //                       Container(
      //                         padding: EdgeInsets.all(8.0),
      //                         child: Column(
      //                           children: [
      //                             Row(
      //                               children: <Widget>[
      //                                 Expanded(
      //                                     child: Column(
      //                                   crossAxisAlignment:
      //                                       CrossAxisAlignment
      //                                           .start,
      //                                   children: [
      //                                     Text(
      //                                       "Onward",
      //                                       style: TextStyle(
      //                                           fontSize: 13,
      //                                           color: Theme.of(
      //                                                   context)
      //                                               .accentColor),
      //                                     ),
      //                                     Text(
      //                                       "NRT / JL",
      //                                       style: TextStyle(
      //                                         fontSize: 18,
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 )),
      //                                 Expanded(
      //                                     child: Column(
      //                                   crossAxisAlignment:
      //                                       CrossAxisAlignment
      //                                           .start,
      //                                   children: [
      //                                     Text(
      //                                       "Shipping Bill Number",
      //                                       style: TextStyle(
      //                                           fontSize: 13,
      //                                           color: Theme.of(
      //                                                   context)
      //                                               .accentColor),
      //                                     ),
      //                                     Text(
      //                                       "20202021",
      //                                       style: TextStyle(
      //                                         fontSize: 18,
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 )),
      //                                 Expanded(
      //                                     child: Column(
      //                                   crossAxisAlignment:
      //                                       CrossAxisAlignment
      //                                           .start,
      //                                   children: [
      //                                     Text(
      //                                       "Scan Type",
      //                                       style: TextStyle(
      //                                           fontSize: 13,
      //                                           color: Theme.of(
      //                                                   context)
      //                                               .accentColor),
      //                                     ),
      //                                     Text(
      //                                       '${e.Scan_Type}',
      //                                       style: TextStyle(
      //                                         fontSize: 18,
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 )),
      //                               ],
      //                             ),
      //                             Row(
      //                               mainAxisAlignment:
      //                                   MainAxisAlignment
      //                                       .spaceAround,
      //                               children: <Widget>[
      //                                 Expanded(
      //                                     child: Column(
      //                                   crossAxisAlignment:
      //                                       CrossAxisAlignment
      //                                           .start,
      //                                   children: [
      //                                     Text(
      //                                       "Manifest Remarks ",
      //                                       style: TextStyle(
      //                                           fontSize: 13,
      //                                           color: Theme.of(
      //                                                   context)
      //                                               .accentColor),
      //                                     ),
      //                                     Text(
      //                                       '${e.Manifest_Remarks}',
      //                                       style: TextStyle(
      //                                         fontSize: 18,
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 )),
      //                                 Expanded(
      //                                     child: Column(
      //                                   crossAxisAlignment:
      //                                       CrossAxisAlignment
      //                                           .start,
      //                                   children: [
      //                                     Text(
      //                                       "Office Use Remarks",
      //                                       style: TextStyle(
      //                                           fontSize: 13,
      //                                           color: Theme.of(
      //                                                   context)
      //                                               .accentColor),
      //                                     ),
      //                                     Text(
      //                                       '${e.Office_Use_Remarks}',
      //                                       style: TextStyle(
      //                                         fontSize: 18,
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 )),
      //                                 Expanded(
      //                                     child: Column(
      //                                   crossAxisAlignment:
      //                                       CrossAxisAlignment
      //                                           .start,
      //                                   children: [
      //                                     Text(
      //                                       "Internal Remarks",
      //                                       style: TextStyle(
      //                                           fontSize: 13,
      //                                           color: Theme.of(
      //                                                   context)
      //                                               .accentColor),
      //                                     ),
      //                                     Text(
      //                                       '${e.Internal_Remarks}',
      //                                       style: TextStyle(
      //                                         fontSize: 18,
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 )),
      //                               ],
      //                             ),
      //                             Row(
      //                               children: <Widget>[
      //                                 Expanded(
      //                                     child: Column(
      //                                   crossAxisAlignment:
      //                                       CrossAxisAlignment
      //                                           .start,
      //                                   children: [
      //                                     Text(
      //                                       "Physical Verification",
      //                                       style: TextStyle(
      //                                           fontSize: 13,
      //                                           color: Theme.of(
      //                                                   context)
      //                                               .accentColor),
      //                                     ),
      //                                     Text(
      //                                       "No",
      //                                       style: TextStyle(
      //                                         fontSize: 18,
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 )),
      //                                 Expanded(
      //                                     child: Column(
      //                                   crossAxisAlignment:
      //                                       CrossAxisAlignment
      //                                           .start,
      //                                   children: [
      //                                     Text(
      //                                       "Scanned Indicator",
      //                                       style: TextStyle(
      //                                           fontSize: 13,
      //                                           color: Theme.of(
      //                                                   context)
      //                                               .accentColor),
      //                                     ),
      //                                     Text(
      //                                       "Yes",
      //                                       style: TextStyle(
      //                                         fontSize: 18,
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 )),
      //                               ],
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                     ],
      //                     onExpansionChanged: (bool expanded) {
      //                       setState(() =>
      //                           _customTileExpanded = expanded);
      //                     },
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ],
      //       );
      //     }).toList(),
      //   ),
      // ),
    );
  }
}
