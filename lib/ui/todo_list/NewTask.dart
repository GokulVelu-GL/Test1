import 'dart:convert';
//
// import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rooster/string.dart';
import 'package:rooster/ui/todo_list/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../generated/l10n.dart';

class NewTask extends StatefulWidget {
  _newTaskState createState() => _newTaskState();
}

// ignore: camel_case_types
class _newTaskState extends State<NewTask> {
  String title;
  String longDescription;
  String status;
  String dueDate = "";
  var types = [
    "New",
    "In Progress",
    "Completed",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          S.of(context).NewTask,
          // "New Task",
          style: TextStyle(fontSize: 25),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ToDoList()));
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              height: 30,
              color: Theme.of(context).accentColor,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Colors.white),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   children: [
                    //     Text(
                    //       "For",
                    //       style: TextStyle(fontSize: 18),
                    //     ),
                    //     Container(
                    //       padding: EdgeInsets.all(10),
                    //       decoration: BoxDecoration(
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(20)),
                    //           color: Colors.grey.withOpacity(0.2)),
                    //       child: Text(
                    //         "Asignee",
                    //         style: TextStyle(fontSize: 18),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     Text(
                    //       "In",
                    //       style: TextStyle(fontSize: 18),
                    //     ),
                    //     Container(
                    //       padding: EdgeInsets.all(10),
                    //       decoration: BoxDecoration(
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(20)),
                    //           color: Colors.grey.withOpacity(0.2)),
                    //       child: Text(
                    //         "Project",
                    //         style: TextStyle(fontSize: 18),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      //color: Colors.grey.withOpacity(0.2),
                      child: TextField(
                        onSubmitted: (String value) {
                          setState(() {
                            title = value;
                          });
                        },
                        onChanged: (String value) {
                          setState(() {
                            title = value;
                          });
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).accentColor,
                                  // color: Colors.deepPurple,
                                  style: BorderStyle.solid,
                                )),
                            hintText:
                            S.of(context).title
                          //    "Title"
                        ),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).Description,
                            // "Description",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 130,
                            width: double.infinity,
                            child: TextField(
                              onChanged: (String value) {
                                setState(() {
                                  longDescription = value;
                                });
                              },
                              onSubmitted: (String value) {
                                setState(() {
                                  longDescription = value;
                                });
                              },
                              maxLines: 6,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).accentColor,
                                      // color: Colors.deepPurple,
                                      style: BorderStyle.solid,
                                    )),
                                hintText:
                                S.of(context).Adddescriptionhere,
                                //"Add description here",
                              ),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          // Container(
                          //   height: 50,
                          //   width: double.infinity,
                          //   decoration: BoxDecoration(
                          //       color: Colors.grey.withOpacity(0.2),
                          //       borderRadius: BorderRadius.only(
                          //           bottomRight: Radius.circular(15),
                          //           bottomLeft: Radius.circular(15)),
                          //       border: Border.all(
                          //           color: Colors.grey.withOpacity(0.5))),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: [
                          //       Container(
                          //         child: IconButton(
                          //           icon: Icon(
                          //             Icons.attach_file,
                          //             color: Colors.grey,
                          //           ),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            margin: EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () async {
                                final month = [
                                  'JAN',
                                  'FEB',
                                  'MAR',
                                  'APR',
                                  'MAY',
                                  "JUNE",
                                  "JULY",
                                  'AUG',
                                  'SEPT',
                                  'OCT',
                                  'NOV',
                                  'DEC'
                                ];
                                DateTime _date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1000, 01, 01),
                                  lastDate: DateTime(
                                      DateTime.now().year + 1000, 01, 01),
                                );
                                _date = _date ?? DateTime.now();
                                setState(() {
                                  dueDate =
                                  '${_date.day} ${month[_date.month - 1]}, ${_date.year}';
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Theme.of(context).accentColor,
                                    // color: Colors.deepPurple,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(dueDate),
                                  trailing: Icon(
                                    Icons.date_range,
                                    color: Theme.of(context).accentColor,
                                    //color: Colors.deepPurple,
                                  ),
                                  subtitle: Text(
                                    S.of(context).DueDate,
                                    //    "Due Date"
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            S.of(context).Status,
                            //"Status",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                //labelText: "Status",
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 16.0),
                                  errorStyle: TextStyle(
                                      color: Colors.redAccent, fontSize: 16.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).accentColor,
                                      //   color: Colors.deepPurple
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2,
                                          color: Theme.of(context).accentColor),
                                      borderRadius:
                                      BorderRadius.circular(10.0))),
                              value: status,
                              // hint: Text("No",
                              // style: TextStyle(
                              //   color: Theme.of(context).accentColor
                              // ),
                              // ),

                              onChanged: (String newValue) {
                                setState(() {
                                  status = newValue;
                                });
                              },
                              // validator: (String value) {
                              //   if (value?.isEmpty ?? true) {
                              //     return 'Please enter a valid type of Special Handling group';
                              //   }
                              // },
                              items: types.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            color: Theme.of(context).accentColor),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                                color: Theme.of(context).accentColor),
                            child: Center(
                              child: TextButton(
                                child: Text(
                                    S.of(context).AddTask,
                                    //"Add Task",
                                    style:TextStyle(
                                        color:Theme.of(context).backgroundColor
                                    ),
                                ),
                                onPressed: () {
                                  insertTODOList(title, longDescription);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> insertTODOList(String title, String longDesc) async {
    var result;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(StringData.todoListAPI),
        headers: <String, String>{
          'x-access-tokens': prefs.getString('token'),
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "shortname": title,
          "longdescription": longDesc,
          "timelimit": "2022-03-19 20:54:26",
          "status": "In Progress"
        }));
    result = json.decode(response.body);
    if (result['message'] == 'token expired') {
      refreshToken();
      insertTODOList(title, longDesc);
    } else {
      result = json.decode(response.body);
      print(prefs.getString('token'));
      print("@@@@@@@@@@@@@@@@@");
      print(result);
      if (response.statusCode == 201 || response.statusCode == 200) {
        // insertAWB();
        Fluttertoast.showToast(
            msg: 'TODO List Added',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white
        );
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text("TODO List Added"),
        // ));
        // _showMessage("TODO List Added", Colors.green, Colors.white);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ToDoList()));
      } else {
        Fluttertoast.showToast(
            msg: 'TODO List Added Failed',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white
        );
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text("TODO List Added Failed"),
        // ));
        // _showMessage("TODO List Added Faild", Colors.red, Colors.white);
        print("Data insertion faild");
      }
    }
    return result;
  }

// void _showMessage(String message, Color bgcolor, txtcolor) {
//   if (!mounted) return;
//   showFlash(
//       context: context,
//       duration: Duration(seconds: 3),
//       builder: (_, controller) {
//         return Flash(
//           borderRadius: BorderRadius.circular(20),
//           backgroundColor: bgcolor,
//           controller: controller,
//           position: FlashPosition.top,
//           behavior: FlashBehavior.fixed,
//           child: FlashBar(
//             icon: Icon(
//               Icons.flight_takeoff_outlined,
//               size: 36.0,
//               color: txtcolor,
//             ),
//             content: Text(
//               message,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 20, color: txtcolor),
//             ),
//           ),
//         );
//       });
// }
}
