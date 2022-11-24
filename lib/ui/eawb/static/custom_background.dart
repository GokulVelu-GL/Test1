import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/ui/homescreen/main_homescreen.dart';

import '../main_eawb.dart';

class CustomBackground extends StatelessWidget {
  const CustomBackground(
      {Key key,
      @required this.name,
      @required this.child,
        this.help,
      this.next,
      this.previous})
      : super(key: key);
  final Widget child;
  final Widget help;
  final String name;
  final Widget next;
  final Widget previous;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
    EAWBModel model;
    return Builder(
      builder: (BuildContext context) {
        return Scaffold(
          body: SafeArea(
            child: ListView(
              //alignment: Alignment.center,
              // fit: StackFit.loose,
              //overflow: Overflow.clip,
              children: <Widget>[
                ClipPath(
                  //clipper: CurveClip(),
                  child: Container(
                    alignment: Alignment.topLeft,
                    //color: Theme.of(context).primaryColor,
                    // height: MediaQuery.of(context).size.height * 0.25,
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: FittedBox(
                          fit: BoxFit.contain,
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    name,
                                    // textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      //  color: Theme.of(context).accentColor,
                                      //color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.6),
                                  ),

                                  // buildAlign()
                                  // Container(
                                  //   color: Colors.blue,
                                  //     child:_offsetPopup()
                                  // ),
                                ],
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.80,
                    color: Colors.transparent,
                    child: Padding(padding: EdgeInsets.all(10.0), child: child),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton:
          Container(
              margin:EdgeInsets.only(
                top: 16,
              ) ,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  help,
                  buildAlign(),
                ],
              )),
          // Builder(
          //   builder: (context) => FabCircularMenu(
          //     key: fabKey,
          //     // Cannot be `Alignment.center`
          //     alignment: Alignment.topRight,
          //     ringColor: Colors.black26.withAlpha(10),
          //     ringDiameter: 260.0,
          //     ringWidth: 50.0,
          //     fabSize: 37.0,
          //     fabElevation: 2,
          //     fabIconBorder: CircleBorder(),
          //     // Also can use specific color based on wether
          //     // the menu is open or not:
          //     // fabOpenColor: Colors.white
          //     // fabCloseColor: Colors.white
          //     // These properties take precedence over fabColor
          //     fabColor: Colors.white,
          //     fabOpenIcon: Icon(Icons.more_vert,
          //     color:Theme.of(context).accentColor
          //       //    color: Colors.blue
          //     ),
          //     fabCloseIcon: Icon(Icons.close,
          //         color:Theme.of(context).accentColor
          //       //color: Colors.blue
          //     ),
          //     fabMargin: const EdgeInsets.all(16.0),
          //     animationDuration: const Duration(milliseconds: 800),
          //     animationCurve: Curves.easeInBack,
          //     onDisplayChange: (isOpen) {
          //       //  _showSnackBar(context, "The menu is ${isOpen ? "open" : "closed"}");
          //     },
          //     children: <Widget>[
          //       // RawMaterialButton(
          //       //   onPressed: () {
          //       //     FocusScope.of(
          //       //         context)
          //       //         .unfocus();
          //       //     model.setStatus();
          //       //     Navigator.pop(
          //       //         context);
          //       //    // _showSnackBar(context, "You pressed 1");
          //       //   },
          //       //   shape: CircleBorder(),
          //       //  // padding: const EdgeInsets.all(24.0),
          //       //   child: Column(
          //       //     children: [
          //       //       Text("eAwb"
          //       //       ,style: TextStyle(color: Colors.black),),
          //       //       Icon(Icons.flight_takeoff, color: Colors.black),
          //       //     ],
          //       //   ),
          //       // ),
          //       RawMaterialButton(
          //         onPressed: () {
          //           moveHome(model, context);
          //           // _showSnackBar(context, "You pressed 2");
          //         },
          //         shape: CircleBorder(),
          //         //  padding: const EdgeInsets.all(24.0),
          //         child: Icon(Icons.home,
          //             color:Theme.of(context).accentColor
          //           //    color: Colors.blue
          //         ),
          //       ),
          //       RawMaterialButton(
          //         onPressed: () {
          //           FocusScope.of(context).unfocus();
          //           moveEawb(model, context);
          //           model.setStatus();
          //           Navigator.pop(context);
          //           // _showSnackBar(context, "You pressed 2");
          //         },
          //         shape: CircleBorder(),
          //         //  padding: const EdgeInsets.all(24.0),
          //         child:
          //             // Text("E-AWB"
          //             //   ,style: TextStyle(color: Colors.black),),
          //             Icon(Icons.flight_takeoff,
          //                 color:Theme.of(context).accentColor
          //               //    color: Colors.blue
          //             ),
          //       ),
          //       RawMaterialButton(
          //         onPressed: () {
          //           moveHome(model, context);
          //           // _showSnackBar(context, "You pressed 2");
          //         },
          //         shape: CircleBorder(),
          //         //  padding: const EdgeInsets.all(24.0),
          //         // child: Row(
          //         //   children: [
          //         //     Text("Home"
          //         //       ,style: TextStyle(color: Colors.black),),
          //         //     Icon(Icons.home, color: Colors.black),
          //         //   ],
          //         // ),
          //         child: Icon(Icons.home,
          //             color:Theme.of(context).accentColor
          //           //    color: Colors.blue
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //
          //   },
          //   child: const Icon(Icons.more_vert),
          // ),
          //BUTTON LOCATION

        );
      },
    );
  }

  Widget buildAlign() {
    return PopupMenuButton<int>(
        itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 1,
                child: Consumer<EAWBModel>(
                    builder: (BuildContext context, model, Widget child) {
                  return TextButton(
                      onPressed: () {
                        moveHome(model, context);
                      },
                      child: Row(children: [
                        Icon(Icons.home,
                        color: Theme.of(context).accentColor,
                        ),
                        Text(
                          S.of(context).Home,
                          style: TextStyle(
                            color:  Theme.of(context).accentColor,
                          ),
                          //"Home"
                        )
                      ]));
                }),
              ),
              PopupMenuItem(
                value: 2,
                child: Consumer<EAWBModel>(
                    builder: (BuildContext context, model, Widget child) {
                  return TextButton(
                      onPressed: () {
                        // FocusScope.of(context).unfocus();
                        moveEawb(model, context);
                        // model.setStatus();
                        // Navigator.pop(context);
                      },
                      child: Row(children: [
                        Icon(Icons.flight_takeoff,
                        color: Theme.of(context).accentColor,
                        ),
                        Text(
                          S.of(context).eAWB,
                          style: TextStyle(
                            color: Theme.of(context).accentColor
                          ),
                          //  "eawb"
                        )
                      ]));
                }),
              )
            ]);
  }

  Widget _offsetPopup() {
    PopupMenuButton<int>(
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Consumer<EAWBModel>(
                    builder: (BuildContext context, model, Widget child) {
                  return TextButton(
                      onPressed: () {
                        moveHome(model, context);
                      },
                      child: Row(children: [
                        Icon(Icons.home),
                        Text(
                          S.of(context).Home,
                          //"Home"
                        )
                      ]));
                }),
              ),
              PopupMenuItem(
                value: 2,
                child: Consumer<EAWBModel>(
                    builder: (BuildContext context, model, Widget child) {
                  return TextButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        moveEawb(model, context);
                        model.setStatus();
                        Navigator.pop(context);
                      },
                      child: Row(children: [
                        Icon(Icons.flight_takeoff),
                        Text(
                          S.of(context).eAWB,
                          //  "eawb"
                        )
                      ]));
                }),
              ),
            ],
        icon: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: ShapeDecoration(
            // color: Theme.of(context).accentColor,
            // color: Colors.blue,
              shape: StadiumBorder(
                side: BorderSide(color: Colors.white, width: 2),
              )),
          //child: Icon(Icons.menu, color: Colors.white), <-- You can give your icon here
        ));
  }
}

Future moveHome(EAWBModel model, BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: Text(
        S.of(context).WouldyouliketoSave,
        // "Would you like to Save?",
        style: TextStyle(fontSize: 20,
            color: Theme.of(context).accentColor
        ),
      ),
      content: new Text(
        S.of(context).YouhavemadeseveralchangesSavethefieldforfutureuse,
        style: TextStyle(
            color: Theme.of(context).accentColor
        ),
        //'You have made several changes!\nSave the field for future use.',
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen())),
               //Navigator.of(context).pop(true),
                child: Text(
            S.of(context).Exit,
            style: TextStyle(
              color: Theme.of(context).accentColor
            ),
            //"Exit"
          ),
        ),
        TextButton(
          onPressed: () {
            model.inserteAWB();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          child: Text(
            S.of(context).SaveExit,
            style: TextStyle(
                color: Theme.of(context).accentColor
            ),
            //  "Save & Exit"
          ),
        ),
      ],
    ),
  );
  // return InkWell(
  //   onTap: () {
  //     FocusScope.of(context).unfocus();
  //     model.setStatus();
  //     showDialog(
  //       context: context,
  //       builder: (context) => new AlertDialog(
  //         title: Text(
  //           "Would you like to Save?",
  //           style: TextStyle(fontSize: 20),
  //         ),
  //         content: new Text(
  //           'You have made several changes!\nSave the field for future use.',
  //           textAlign: TextAlign.center,
  //         ),
  //         actions: <Widget>[
  //           FlatButton(
  //             onPressed: () => Navigator.of(context).pop(true),
  //             child: Text("Exit"),
  //           ),
  //           FlatButton(
  //             onPressed: () {
  //               model.saveEAWB();
  //               Navigator.of(context).pushReplacement(
  //                   MaterialPageRoute(builder: (context) => HomeScreen()));
  //             },
  //             child: Text("Save & Exit"),
  //           ),
  //         ],
  //       ),
  //     );
  //   },
  //   child: Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: <Widget>[
  //         IconButton(
  //             icon: Icon(
  //               Icons.home,
  //               color: Colors.white,
  //             ),
  //             onPressed: () {
  //               FocusScope.of(context).unfocus();
  //               model.setStatus();
  //               showDialog(
  //                 context: context,
  //                 builder: (context) => new AlertDialog(
  //                   title: Text(
  //                     "Would you like to Save from Home?",
  //                     style: TextStyle(fontSize: 20),
  //                   ),
  //                   content: new Text(
  //                     'You have made several changes!\nSave the field for future use.',
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   actions: <Widget>[
  //                     FlatButton(
  //                       onPressed: () => Navigator.of(context).pop(true),
  //                       child: Text("Exit"),
  //                     ),
  //                     FlatButton(
  //                       onPressed: () {
  //                         model.inserteAWB();
  //                         Navigator.of(context)..pop()..pop()..pop();
  //                         // Navigator.of(context)
  //                         //     .pop(true); // ! pop dialog....
  //                         // Navigator.of(context)
  //                         //     .pop(true); // ! pop eawb pages....
  //                         // Navigator.of(context)
  //                         //     .pop(true); // ! pop eawb screen....
  //                       },
  //                       child: Text("Save & Exit"),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             }),
  //         Text(
  //           "Home",
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 18,
  //           ),
  //         ),
  //       ],
  //     ),
  //   ),
  // );
}

Future moveEawb(EAWBModel model, BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: Text(
        S.of(context).WouldyouliketoSave,
        // "Would you like to Save?",
        style: TextStyle(
            fontSize: 20,
        color: Theme.of(context).accentColor

        ),
      ),
      content: new Text(
        S.of(context).YouhavemadeseveralchangesSavethefieldforfutureuse,
        //'You have made several changes!\nSave the field for future use.',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Theme.of(context).accentColor
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () =>
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MainEAWB(awbNumber:  '${model.awbConsigmentDetailsAWBNumber.substring(0, 3)}${model.awbConsigmentDetailsAWBNumber.substring(3)}'
                  ))),
              //Navigator.of(context).pop(true),
          child: Text(
            S.of(context).Exit,
            style: TextStyle(
              color: Theme.of(context).accentColor
            ),
            //"Exit"
          ),
        ),
        FlatButton(
          onPressed: () {
            model.inserteAWB();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MainEAWB(awbNumber:  '${model.awbConsigmentDetailsAWBNumber.substring(0, 3)}${model.awbConsigmentDetailsAWBNumber.substring(3)}'
            )));
                },
          child: Text(
            S.of(context).SaveExit,
            style: TextStyle(
              color: Theme.of(context).accentColor
            ),
            //  "Save & Exit"
          ),
        ),
      ],
    ),
  );
}

class CurveClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0, size.height);
    var ctrlPoint1 = Offset(size.width * 0.75, size.height);
    var ctrlPoint2 = Offset(0, size.height * 0.25);
    var endPoint = Offset(size.width, size.height * 0.35);
    path.cubicTo(ctrlPoint1.dx, ctrlPoint1.dy, ctrlPoint2.dx, ctrlPoint2.dy,
        endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return oldClipper != this;
  }
}
