import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/string.dart';
import 'package:rooster/ui/todo_list/EditNewTask%20.dart';
import 'package:rooster/ui/todo_list/NewTask.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;

void refreshToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var response = await http.get(Uri.parse(StringData.refreshTokenAPI),
      headers: {'x-access-tokens': prefs.getString('token')});
  var result = json.decode(response.body);
  if (result['result'] == 'verified') prefs.setString('token', result['token']);
  print(result);
}

Future<dynamic> getToDolist() async {
  var result;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var response = await http.get(Uri.parse(StringData.todoListAPI),
      headers: {'x-access-tokens': prefs.getString('token')});
  result = json.decode(response.body);
  if (result['message'] == 'token expired') {
    refreshToken();
    getToDolist();
  } else {
    //getAWBlist();
    print(prefs.getString('token'));
  }
  print("TODO List Details " + '${result}');
  return result["todo"];
}

Future<dynamic> deleteToDo(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.parse(StringData.todoListAPI);
  final request = http.Request("DELETE", url);
  request.headers.addAll(<String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'x-access-tokens': prefs.getString('token')
  });
  request.body = jsonEncode({"id": id});
  final response = await request.send();
  print(id);
  print(response);
  // ignore: unrelated_type_equality_checks
  if (response == 'token expired') {
    refreshToken();
  } else {
    // response = json.decode(request.body);
    print(prefs.getString('token'));
  }
  if (response.statusCode == 202 || response.statusCode == 200) {
    print("Sucess");
    // Navigator.push(context, HomeScreenRoute(MyEawb()));
  }
  return true;
}

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: homePage(),
//     );
//   }
// }

class ToDoList extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<ToDoList> {
  String filterType = "today";
  DateTime today = new DateTime.now();
  String todayDate =
      DateFormat('EEE, d MMM, ' 'yyyy hh:mm').format(new DateTime.now());
  String taskPop = "close";
  var monthNames = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEPT",
    "OCT",
    "NOV",
    "DEC"
  ];
  //var todoList=[];

  @override
  void initState() {
    //todoList=getToDolist() as List;
    super.initState();
  }

  CalendarController ctrlr = new CalendarController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () async {
          Map<String, String> newMasterAWB = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewTask(),
              ));
          if (newMasterAWB != null) {
            setState(() {
              //masterAWB.add(newMasterAWB);
            });
          }
        },
        child: Icon(Icons.add),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                backgroundColor: Theme.of(context).accentColor,
                elevation: 0,
                title: Text(
                  "ToDoList",
                  style: TextStyle(fontSize: 20),
                ),
                actions: [
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.short_text,
                  //     color: Colors.white,
                  //     size: 30,
                  //   ),
                  // )
                ],
              ),
              Container(
                height: 50,
                color: Theme.of(context).accentColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            changeFilter("today");
                          },
                          child: Text(
                            "Today",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 4,
                          width: 120,
                          color: (filterType == "today")
                              ? Colors.white
                              : Colors.transparent,
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            changeFilter("monthly");
                          },
                          child: Text(
                            "Monthly",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 4,
                          width: 120,
                          color: (filterType == "monthly")
                              ? Colors.white
                              : Colors.transparent,
                        )
                      ],
                    )
                  ],
                ),
              ),
              (filterType == "monthly")
                  ? TableCalendar(
                      calendarController: ctrlr,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      initialCalendarFormat: CalendarFormat.week,
                    )
                  : Container(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            //"Today ${monthNames[today.month - 1]}, ${today.day}-${today.year}",
                            "Today ${todayDate}",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                    Center(
                      child: FutureBuilder<dynamic>(
                          future: getToDolist(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              dynamic todoListData = snapshot.data;
                              return Container(
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: todoListData.length,
                                      itemBuilder: (context, index) {
                                        // return Container(
                                        //   child: taskWidget(Color(0xfff96060),
                                        //       "Meeting with someone", "9:00 AM"),
                                        // );
                                        var color = Color(0xfff96060);
                                        String title =
                                            todoListData[index]['shortname'];
                                        String time = todoListData[index]
                                            ['longdescription'];
                                        return Slidable(
                                          actionPane:
                                              SlidableDrawerActionPane(),
                                          actionExtentRatio: 0.3,
                                          child: Container(
                                            height: 80,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.03),
                                                      offset: Offset(0, 9),
                                                      blurRadius: 20,
                                                      spreadRadius: 1)
                                                ]),
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: color,
                                                          width: 4)),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      title,
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                    ),
                                                    Text(
                                                      time,
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14),
                                                    )
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Container(),
                                                ),
                                                Container(
                                                  height: 50,
                                                  width: 5,
                                                  color: color,
                                                )
                                              ],
                                            ),
                                          ),
                                          secondaryActions: [
                                            IconSlideAction(
                                              caption: "Edit",
                                              color: Colors.white,
                                              icon: Icons.edit,
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditNewTask(
                                                                todoListData[
                                                                        index]
                                                                    ['id'],
                                                                todoListData[
                                                                        index][
                                                                    'timelimit'],
                                                                todoListData[
                                                                        index][
                                                                    'shortname'],
                                                                todoListData[
                                                                        index][
                                                                    'longdescription'],
                                                                todoListData[
                                                                        index][
                                                                    'status'])));
                                              },
                                            ),
                                            IconSlideAction(
                                              caption: "Delete",
                                              color: color,
                                              icon: Icons.edit,
                                              onTap: () {
                                                //Navigator.of(context).pop(true);
                                                deleteToDo(
                                                    '${todoListData[index]["id"]}');
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ToDoList()));
                                              },
                                            )
                                          ],
                                        );
                                      }));
                            } else if (snapshot.hasError) {
                              return Text(S.of(context).DataNotFound);
                            }

                            // By default, show a loading spinner
                            return CircularProgressIndicator();
                          }),
                    ),
                  ],
                ),
              )
            ],
          ),
          // Container(
          //   child: (taskPop == "open")
          //       ? Container(
          //           height: MediaQuery.of(context).size.height,
          //           width: MediaQuery.of(context).size.width,
          //           color: Colors.black.withOpacity(0.3),
          //           child: Center(
          //             child: InkWell(
          //               onTap: closeTaskPop,
          //               child: Container(
          //                 decoration: BoxDecoration(
          //                     borderRadius:
          //                         BorderRadius.all(Radius.circular(10)),
          //                     color: Colors.white),
          //                 height: MediaQuery.of(context).size.height * 0.3,
          //                 width: MediaQuery.of(context).size.width * 0.7,
          //                 child: Column(
          //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                   children: [
          //                     SizedBox(
          //                       height: 1,
          //                     ),
          //                     InkWell(
          //                       onTap: openNewTask,
          //                       child: Container(
          //                         child: Text(
          //                           "Add Task",
          //                           style: TextStyle(fontSize: 18),
          //                         ),
          //                       ),
          //                     ),
          //                     Container(
          //                       height: 1,
          //                       margin: EdgeInsets.symmetric(horizontal: 30),
          //                       color: Colors.black.withOpacity(0.2),
          //                     ),
          //                     Container(
          //                       height: 1,
          //                       margin: EdgeInsets.symmetric(horizontal: 30),
          //                       color: Colors.black.withOpacity(0.2),
          //                     ),
          //                     SizedBox(
          //                       height: 1,
          //                     )
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         )
          //       : Container(),
          // )
        ],
      ),
    );
  }

  openTaskPop() {
    taskPop = "open";
    setState(() {});
  }

  closeTaskPop() {
    taskPop = "close";
    setState(() {});
  }

  changeFilter(String filter) {
    filterType = filter;
    setState(() {});
  }

  Slidable taskWidget(Color color, String title, String time) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.3,
      child: Container(
        height: 80,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              offset: Offset(0, 9),
              blurRadius: 20,
              spreadRadius: 1)
        ]),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 4)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                )
              ],
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              height: 50,
              width: 5,
              color: color,
            )
          ],
        ),
      ),
      secondaryActions: [
        IconSlideAction(
          caption: "Edit",
          color: Colors.white,
          icon: Icons.edit,
          onTap: () {},
        ),
        IconSlideAction(
          caption: "Delete",
          color: color,
          icon: Icons.edit,
          onTap: () {},
        )
      ],
    );
  }

  openNewTask() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewTask()));
  }
}
