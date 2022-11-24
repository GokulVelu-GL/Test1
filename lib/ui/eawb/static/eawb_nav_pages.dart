import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import 'package:rooster/model/airport_model.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/screenroute.dart';
import 'package:rooster/string.dart';
import 'package:rooster/ui/eawb/SpecialHandlingDetail.dart';
import 'package:rooster/ui/eawb/accounting_information.dart';
import 'package:rooster/ui/eawb/awb_consignment_details.dart';
import 'package:rooster/ui/eawb/carriers_execution.dart';
import 'package:rooster/ui/eawb/cc_charges_in_destination_currency.dart';
import 'package:rooster/ui/eawb/charges_declaration.dart';
import 'package:rooster/ui/eawb/charges_summary.dart';
import 'package:rooster/ui/eawb/consignee.dart';
import 'package:rooster/ui/eawb/handling_information.dart';
import 'package:rooster/ui/eawb/issuer.dart';
import 'package:rooster/ui/eawb/issuing_carriers_agent.dart';
import 'package:rooster/ui/eawb/notify.dart';
import 'package:rooster/ui/eawb/optional_shipping_information.dart';
import 'package:rooster/ui/eawb/other_charges.dart';
import 'package:rooster/ui/eawb/rate_description.dart';
import 'package:rooster/ui/eawb/routing_and_flight_bookings.dart';
import 'package:rooster/ui/eawb/shipper.dart';
import 'package:rooster/ui/eawb/shippers_certification.dart';
import 'package:rooster/ui/homescreen/main_homescreen.dart';

class EAWBNavPages extends StatefulWidget {
  EAWBNavPages(this.index, {Key key}) : super(key: key);
  final index;

  @override
  _EAWBNavPagesState createState() => _EAWBNavPagesState(index);
}

class _EAWBNavPagesState extends State<EAWBNavPages> {
  PageController _pageController;
  static List<AirportModel> _airportsList = new List<AirportModel>();

  _EAWBNavPagesState(this._currentPage);

  int _currentPage;
  final _pageTransitionTime = 300;

  List<Widget> pages = [
    AwbConsignmentDetails(),
    Shipper(),
    Consignee(),
    IssuingCarriersAgent(),
    RoutingAndFlightBookings(
      airportList: _airportsList,
    ),
    AlsoNotify(),
    Issuer(),
    AccountingInformation(),
    OptionalShippingInformation(),
    ChargesDeclaration(),
    RateDescription(),
    OtherCharges(),

    // HandlingInformation(),
    SpecialHandling(),
    ChargesSummary(),
    CcChargesInDestinationCurrency(),
    ShippersCertification(),
    CarriersExecution(),

  ];

  @override
  void initState() {
    loadList();
    _pageController = PageController(initialPage: _currentPage);
    super.initState();
  }

  Future<void> loadList() async {
    _airportsList = await StringData.loadAirport();
  }
  //
  // Future<List<AirportModel>> loadAirport() async {
  //   List<AirportModel> _airportsList = new List<AirportModel>();
  //   try {
  //     final response = await http
  //         .get("https://roostertech6.herokuapp.com/api/reference/AirportCode");
  //     if (response.statusCode == 200) {
  //       final parsed =
  //           json.decode(response.body)["airports"].cast<Map<String, dynamic>>();
  //       _airportsList = parsed
  //           .map<AirportModel>((json) => AirportModel.fromJson(json))
  //           .toList();
  //       print(_airportsList);
  //       return _airportsList;
  //     } else {
  //       print("Error in Airport API eawb_nav_page");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Error in occur API");
  //     print(e);
  //     return null;
  //   }
  // }

  Widget _customNavBar(EAWBModel model) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              bottom: 10,
            ),
            child: InkWell(
              onTap: _currentPage != 0
                  ? () {
                      FocusScope.of(context).unfocus();
                      model.setStatus();
                      setState(() {
                        _currentPage--;
                        _pageController.animateToPage(_currentPage,
                            duration:
                                Duration(milliseconds: _pageTransitionTime),
                            curve: Curves.linear);
                      });
                    }
                  : null,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                // onPressed: () => {},
                onPressed: _currentPage != 0
                    ? () {
                        FocusScope.of(context).unfocus();
                        model.setStatus();
                        setState(() {
                          _currentPage--;
                          _pageController.animateToPage(_currentPage,
                              duration:
                                  Duration(milliseconds: _pageTransitionTime),
                              curve: Curves.linear);
                        });
                      }
                    : null,
                child: Icon(
                  Icons.navigate_before,
                  color: Colors.white,
                ),
                heroTag: "previous",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 10),
            child: InkWell(
              onTap: _currentPage != pages.length - 1
                  ? () {
                      FocusScope.of(context).unfocus();
                      model.setStatus();
                      setState(() {
                        _currentPage++;
                        _pageController.animateToPage(_currentPage,
                            duration:
                                Duration(milliseconds: _pageTransitionTime),
                            curve: Curves.linear);
                      });
                    }
                  : null,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: _currentPage != pages.length - 1
                    ? () {
                        FocusScope.of(context).unfocus();
                        model.setStatus();
                        setState(() {
                          _currentPage++;
                          _pageController.animateToPage(_currentPage,
                              duration:
                                  Duration(milliseconds: _pageTransitionTime),
                              curve: Curves.linear);
                        });
                      }
                    : null,
                child: Icon(
                  Icons.navigate_next_rounded,
                  color: Colors.white,
                ),
                heroTag: "next",
              ),
            ),
          ),
        ]);
    // Container(
    //   decoration: BoxDecoration(
    //     color: Theme.of(context).primaryColor,
    //     borderRadius: BorderRadius.only(
    //         topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
    //   ),
    //   child: Row(
    //     mainAxisSize: MainAxisSize.max,
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     children: <Widget>[
    //       // * Previous....
    //       Expanded(
    //         flex: 1,
    //         child: InkWell(
    //           onTap: _currentPage != 0
    //               ? () {
    //                   FocusScope.of(context).unfocus();
    //                   model.setStatus();
    //                   setState(() {
    //                     _currentPage--;
    //                     _pageController.animateToPage(_currentPage,
    //                         duration:
    //                             Duration(milliseconds: _pageTransitionTime),
    //                         curve: Curves.linear);
    //                   });
    //                 }
    //               : null,
    //           child: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: <Widget>[
    //                 IconButton(
    //                     icon: Icon(
    //                       Icons.navigate_before,
    //                       color: _currentPage != 0 ? Colors.white : Colors.grey,
    //                       size: 35,
    //                     ),
    //                     onPressed: _currentPage != 0
    //                         ? () {
    //                             FocusScope.of(context).unfocus();
    //                             model.setStatus();
    //                             setState(() {
    //                               _currentPage--;
    //                               _pageController.animateToPage(_currentPage,
    //                                   duration: Duration(
    //                                       milliseconds: _pageTransitionTime),
    //                                   curve: Curves.linear);
    //                             });
    //                           }
    //                         : null),
    //                 Text(
    //                   "Previous",
    //                   style: TextStyle(
    //                     color: _currentPage != 0 ? Colors.white : Colors.grey,
    //                     fontWeight: FontWeight.bold,
    //                     fontSize: 18,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //       // * Next....
    //       Expanded(
    //         flex: 1,
    //         child: InkWell(
    //           onTap: _currentPage != pages.length - 1
    //               ? () {
    //                   FocusScope.of(context).unfocus();
    //                   model.setStatus();
    //                   setState(() {
    //                     _currentPage++;
    //                     _pageController.animateToPage(_currentPage,
    //                         duration:
    //                             Duration(milliseconds: _pageTransitionTime),
    //                         curve: Curves.linear);
    //                   });
    //                 }
    //               : null,
    //           child: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: <Widget>[
    //                 IconButton(
    //                     icon: Icon(
    //                       Icons.navigate_next,
    //                       color: _currentPage != pages.length - 1
    //                           ? Colors.white
    //                           : Colors.grey,
    //                       size: 35,
    //                     ),
    //                     onPressed: _currentPage != pages.length - 1
    //                         ? () {
    //                             FocusScope.of(context).unfocus();
    //                             model.setStatus();
    //                             setState(() {
    //                               _currentPage++;
    //                               _pageController.animateToPage(_currentPage,
    //                                   duration: Duration(
    //                                       milliseconds: _pageTransitionTime),
    //                                   curve: Curves.linear);
    //                             });
    //                           }
    //                         : null),
    //                 Text(
    //                   "Next",
    //                   style: TextStyle(
    //                     color: _currentPage != pages.length - 1
    //                         ? Colors.white
    //                         : Colors.grey,
    //                     fontWeight: FontWeight.bold,
    //                     fontSize: 18,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }

  // TODO://Future Use
  // Widget _customNavBar(EAWBModel model) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).primaryColor,
  //       borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.max,
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: <Widget>[
  //         // * Previous....
  //         Expanded(
  //           flex: 1,
  //           child: InkWell(
  //             onTap: _currentPage != 0
  //                 ? () {
  //                     FocusScope.of(context).unfocus();
  //                     model.setStatus();
  //                     setState(() {
  //                       _currentPage--;
  //                       _pageController.animateToPage(_currentPage,
  //                           duration:
  //                               Duration(milliseconds: _pageTransitionTime),
  //                           curve: Curves.linear);
  //                     });
  //                   }
  //                 : null,
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: <Widget>[
  //                   IconButton(
  //                       icon: Icon(
  //                         Icons.navigate_before,
  //                         color: _currentPage != 0 ? Colors.white : Colors.grey,
  //                         size: 35,
  //                       ),
  //                       onPressed: _currentPage != 0
  //                           ? () {
  //                               FocusScope.of(context).unfocus();
  //                               model.setStatus();
  //                               setState(() {
  //                                 _currentPage--;
  //                                 _pageController.animateToPage(_currentPage,
  //                                     duration: Duration(
  //                                         milliseconds: _pageTransitionTime),
  //                                     curve: Curves.linear);
  //                               });
  //                             }
  //                           : null),
  //                   Text(
  //                     "Previous",
  //                     style: TextStyle(
  //                       color: _currentPage != 0 ? Colors.white : Colors.grey,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 18,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //         // * Home....
  //         Expanded(
  //           flex: 1,
  //           child: InkWell(
  //             onTap: () {
  //               FocusScope.of(context).unfocus();
  //               model.setStatus();
  //               showDialog(
  //                 context: context,
  //                 builder: (context) => new AlertDialog(
  //                   title: Text(
  //                     "Would you like to Save?",
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
  //                         model.saveEAWB();
  //                         Navigator.of(context).pushReplacement(
  //                             MaterialPageRoute(
  //                                 builder: (context) => HomeScreen()));
  //                       },
  //                       child: Text("Save & Exit"),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             },
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: <Widget>[
  //                   IconButton(
  //                       icon: Icon(
  //                         Icons.home,
  //                         color: Colors.white,
  //                       ),
  //                       onPressed: () {
  //                         FocusScope.of(context).unfocus();
  //                         model.setStatus();
  //                         showDialog(
  //                           context: context,
  //                           builder: (context) => new AlertDialog(
  //                             title: Text(
  //                               "Would you like to Save from Home?",
  //                               style: TextStyle(fontSize: 20),
  //                             ),
  //                             content: new Text(
  //                               'You have made several changes!\nSave the field for future use.',
  //                               textAlign: TextAlign.center,
  //                             ),
  //                             actions: <Widget>[
  //                               FlatButton(
  //                                 onPressed: () =>
  //                                     Navigator.of(context).pop(true),
  //                                 child: Text("Exit"),
  //                               ),
  //                               FlatButton(
  //                                 onPressed: () {
  //                                   model.inserteAWB();
  //                                   Navigator.of(context)..pop()..pop()..pop();
  //                                   // Navigator.of(context)
  //                                   //     .pop(true); // ! pop dialog....
  //                                   // Navigator.of(context)
  //                                   //     .pop(true); // ! pop eawb pages....
  //                                   // Navigator.of(context)
  //                                   //     .pop(true); // ! pop eawb screen....
  //                                 },
  //                                 child: Text("Save & Exit"),
  //                               ),
  //                             ],
  //                           ),
  //                         );
  //                       }),
  //                   Text(
  //                     "Home",
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 18,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //         // *eAWB....
  //         Expanded(
  //           flex: 1,
  //           child: InkWell(
  //             onTap: () {
  //               FocusScope.of(context).unfocus();
  //               model.setStatus();
  //               Navigator.pop(context);
  //             },
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: <Widget>[
  //                   IconButton(
  //                       icon: Icon(
  //                         Icons.flight,
  //                         color: Colors.white,
  //                       ),
  //                       onPressed: () {
  //                         FocusScope.of(context).unfocus();
  //                         model.setStatus();
  //                         Navigator.pop(context);
  //                       }),
  //                   Text(
  //                     "eAWB",
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 18,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //         // * Next....
  //         Expanded(
  //           flex: 1,
  //           child: InkWell(
  //             onTap: _currentPage != pages.length - 1
  //                 ? () {
  //                     FocusScope.of(context).unfocus();
  //                     model.setStatus();
  //                     setState(() {
  //                       _currentPage++;
  //                       _pageController.animateToPage(_currentPage,
  //                           duration:
  //                               Duration(milliseconds: _pageTransitionTime),
  //                           curve: Curves.linear);
  //                     });
  //                   }
  //                 : null,
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: <Widget>[
  //                   IconButton(
  //                       icon: Icon(
  //                         Icons.navigate_next,
  //                         color: _currentPage != pages.length - 1
  //                             ? Colors.white
  //                             : Colors.grey,
  //                         size: 35,
  //                       ),
  //                       onPressed: _currentPage != pages.length - 1
  //                           ? () {
  //                               FocusScope.of(context).unfocus();
  //                               model.setStatus();
  //                               setState(() {
  //                                 _currentPage++;
  //                                 _pageController.animateToPage(_currentPage,
  //                                     duration: Duration(
  //                                         milliseconds: _pageTransitionTime),
  //                                     curve: Curves.linear);
  //                               });
  //                             }
  //                           : null),
  //                   Text(
  //                     "Next",
  //                     style: TextStyle(
  //                       color: _currentPage != pages.length - 1
  //                           ? Colors.white
  //                           : Colors.grey,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 18,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    bool showFab = MediaQuery.of(context).viewInsets.bottom != 0;
    print("_currentPage : $_currentPage");
    return Consumer<EAWBModel>(
      builder: (context, model, child) => Scaffold(
        floatingActionButton: Visibility(
          visible: !showFab,
          child: SizedBox(
            height: 50,
            child: _customNavBar(model),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,

        //  SizedBox(height: 48, child: _customNavBar(model)),
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() {
                _currentPage = value;
              });
            },
            children: pages,
          ),
        ),
      ),
    );
  }
}
