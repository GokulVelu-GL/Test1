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

class EditNewTask extends StatefulWidget {
  int id;
  String title;
  String longDest;
  String status;
  String dueDate;
  EditNewTask(this.id, this.dueDate, this.title, this.longDest, this.status);
  _editnewTaskState createState() => _editnewTaskState();
}

class _editnewTaskState extends State<EditNewTask> {
  String title;
  String longDescription;
  String dueDate;
  String status;
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
          S.of(context).Edittask,
          // "Edit Task",
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
                      height: 25,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      // color: Colors.grey.withOpacity(0.2),
                      child: TextFormField(
                        initialValue: widget.title,
                        onSaved: (String value) {
                          setState(() {
                            widget.title = value;
                          });
                        },
                        onChanged: (String value) {
                          setState(() {
                            widget.title = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText:
                          S.of(context).title,
                          //"Title",
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                width: 2,
                                color: Theme.of(context).accentColor,
                                // color: Colors.deepPurple,
                                style: BorderStyle.solid,
                              )),
                        ),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(

                            S.of(context).Description,
                            //"Description",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 130,
                            width: double.infinity,
                            child: TextFormField(
                              initialValue: widget.longDest,
                              onChanged: (String value) {
                                setState(() {
                                  widget.longDest = value;
                                });
                              },
                              onSaved: (String value) {
                                setState(() {
                                  widget.longDest = value;
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
                            height: 20,
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
                                  widget.dueDate =
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
                                  title: Text(widget.dueDate),
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
                            height: 20,
                          ),
                          Text(
                            S.of(context).Status,
                            // "Status",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 20,
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
                              value: widget.status,
                              // hint: Text("No",
                              // style: TextStyle(
                              //   color: Theme.of(context).accentColor
                              // ),
                              // ),

                              onChanged: (String newValue) {
                                setState(() {
                                  widget.status = newValue;
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
                            height: 20,
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
                                    S.of(context).SaveTask,
                                    style:TextStyle(
                                        color:Theme.of(context).backgroundColor
                                    )
                                    //"Save Task",
                                    // style: TextStyle(
                                    //     color: Colors.white, fontSize: 18)

                                ),
                                onPressed: () {
                                  updateTODOList(
                                      widget.id,
                                      widget.title,
                                      widget.longDest,
                                      widget.dueDate,
                                      widget.status);
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

  Future<dynamic> updateTODOList(int id, String title, String longDesc,
      String dueDate, String status) async {
    var result;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.put(Uri.parse(StringData.todoListAPI),
        headers: <String, String>{
          'x-access-tokens': prefs.getString('token'),
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "id": id,
          "shortname": title,
          "longdescription": longDesc,
          "timelimit": dueDate,
          "status": status
        }));
    result = json.decode(response.body);
    if (result['message'] == 'token expired') {
      refreshToken();
      updateTODOList(id, title, longDesc, dueDate, status);
    } else {
      result = json.decode(response.body);
      print(prefs.getString('token'));
      print("@@@@@@@@@@@@@@@@@");
      print(result);
      if (response.statusCode == 201 || response.statusCode == 200) {
        // insertAWB();
        Fluttertoast.showToast(
            msg: 'TODO List Updated',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white
        );
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text("TODO List Updated"),
        // ));
        // _showMessage("TODO List Updated", Colors.green, Colors.white);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ToDoList()));
      } else {
        Fluttertoast.showToast(
            msg: 'TODO List update Failed',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white
        );
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text("TODO List update Failed"),
        // ));
        // _showMessage("TODO List update Faild", Colors.red, Colors.white);
        print("Data update failed");
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
