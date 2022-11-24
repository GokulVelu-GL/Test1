import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/model/other_charges_items.dart';
import 'package:rooster/ui/eawb/cc_charges_in_destination_currency.dart';
import 'package:rooster/ui/eawb/shippers_certification.dart';
import 'package:rooster/ui/eawb/static/add_other_charges.dart';
import 'package:rooster/ui/eawb/static/custom_background.dart';

class OtherCharges extends StatefulWidget {
  OtherCharges({Key key}) : super(key: key);

  @override
  _OtherChargesState createState() => _OtherChargesState();
}

class _OtherChargesState extends State<OtherCharges> {
  int previousIndex = 0;

  bool cardExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<EAWBModel>(
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          model.setStatus();
          return true;
        },
        child: Scaffold(
          body: SafeArea(
            child: CustomBackground(
              name: S.of(context).OtherCharges,
              //"Other Charges",
              next: ShippersCertification(),
              previous: CcChargesInDestinationCurrency(),
              help: IconButton(
                color: Theme.of(context).backgroundColor,
                onPressed: () {
                  showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: MaterialLocalizations.of(context)
                          .modalBarrierDismissLabel,
                      barrierColor: Colors.black45,
                      transitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (BuildContext buildContext,
                          Animation animation,
                          Animation secondaryAnimation) {
                        return SafeArea(
                          child: Scaffold(
                            appBar: AppBar(
                              backgroundColor: Theme.of(context).primaryColor,
                              title: Text("Help"),
                              centerTitle: true,
                            ),
                            body: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.code,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Other Charge Code"),
                                      subtitle: Text("Code identifying the type of an individual charge\nExample: AC "),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.contacts_rounded,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Entitlement Code"),
                                      subtitle: Text("Coded identification of the recipient of a charge amount \nExample: Due agent "),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.money,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Charge Amount"),
                                      subtitle: Text("An amount of money \nExample:120.46 "),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                icon: Icon(Icons.help,
                  color: Theme.of(context).accentColor,
                ),

              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Entitlement : Due Carrier",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor
                            ),
                          ),
                          Icon(Icons.flight_takeoff_outlined ,
                          color: Theme.of(context).accentColor,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide( //                   <--- left side
                              color: Theme.of(context).accentColor.withOpacity(0.3),
                              width: 15.0,
                            ),
                            top: BorderSide( //                    <--- top side
                              color: Theme.of(context).accentColor.withOpacity(0.6),
                              width: 10.0,
                            ),
                            bottom: BorderSide( //                    <--- top side
                              color: Theme.of(context).accentColor.withOpacity(0.5),
                              width: 3.0,
                            ),
                            right: BorderSide( //                    <--- top side
                              color: Theme.of(context).accentColor.withOpacity(0.5),
                              width: 5.0,
                            ),
                          ),
                        ),
                        child: buildExpansionPanelList2(model),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Entitlement : Due Agent",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor
                          ),
                          ),
                      Icon(Icons.person_outline_outlined,
                        color: Theme.of(context).accentColor,
                      )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide( //                   <--- left side
                              color: Theme.of(context).accentColor.withOpacity(0.3),
                              width: 15.0,
                            ),
                            top: BorderSide( //                    <--- top side
                              color: Theme.of(context).accentColor.withOpacity(0.6),
                              width: 10.0,
                            ),
                            bottom: BorderSide( //                    <--- top side
                              color: Theme.of(context).accentColor.withOpacity(0.5),
                              width: 3.0,
                            ),
                            right: BorderSide( //                    <--- top side
                              color: Theme.of(context).accentColor.withOpacity(0.5),
                              width: 5.0,
                            ),

                          ),


                        ),
                        child: buildExpansionPanelList(model),
                      ),


                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: cardExpanded
              ? FloatingActionButton(
                  backgroundColor: Theme.of(context).accentColor,
                  child: Icon(Icons.add),
                  onPressed: () async {
                    OtherChargesItem otherChargesItem = await Navigator.push(
                        context,
                        MaterialPageRoute<OtherChargesItem>(
                            builder: (context) => AddOtherChargesForm()));
                    if (otherChargesItem != null) {
                      model.addOtherChargesItem(otherChargesItem);
                    }
                  },
                )
              : null,
        ),
      ),
    );
  }

  buildExpansionPanelList(EAWBModel model) {
    if (model.otherChargesList.isNotEmpty) {
      return  Container(
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text("Entitlement : Due Agent",
            //       style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           color: Theme.of(context).accentColor
            //       ),
            //     ),
            //     Icon(Icons.person_outline_outlined,
            //       color: Theme.of(context).accentColor,
            //     )
            //   ],
            // ),
            Column(
              children:  model.otherChargesList.map<Column>((OtherChargesItem item) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if(item.entitlement=="Due agent")Dismissible(
                  key: ValueKey(item),
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
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                    model.deleteOtherChargesItem(item);
                                    // deleteAWB('${getawblist[index]["id"]}');
                                  },
                                  child: Text(
                                    // BuildContext context,
                                    S.of(context).Delete,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                    //"Delete"
                                  )),
                              FlatButton(
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
                      OtherChargesItem otherChargesItem =
                      await Navigator.push(
                          context,
                          MaterialPageRoute<OtherChargesItem>(
                              builder: (context) =>
                                  AddOtherChargesForm(
                                    description: item.description,
                                    amount: item.amount,
                                    entitlementValue:
                                    item.entitlement,
                                    rate: item.rate,
                                    weight: item.weight,
                                    minimum: item.minimum,
                                    useRateIsEnabled: item.useRate,
                                  )));
                      if (otherChargesItem != null) {
                        model.deleteOtherChargesItem(item);
                        model.addOtherChargesItem(otherChargesItem);
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
                  child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://i.pinimg.com/736x/bb/15/97/bb159741f7f3150d93792261edca8662.jpg"
                        //"assets/images/othercharge_background.gif"
                      ),
                      fit: BoxFit.fill,
                    ),
                  // border: Border.all(
                  // color: Theme
                  //     .of(context)
                  //     .accentColor,
                  // ),
                  borderRadius: BorderRadius.circular(20.0),
                  color: Theme
                      .of(context)
                      .backgroundColor,
                  ),

                  // color: Theme.of(context).accentColor.withOpacity(0.2),
                  child: Column(
                  children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ChargeCode",
                            // S.of(context).Description,
                            // 'Description',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme
                                    .of(context)
                                    .accentColor
                              //color: Colors.black,
                            ),
                          ),
                          Text(
                            '${item.description}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              // color: Colors.black,
                            ),
                          ),

                        ],
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          // S
                          //     .of(context)
                          //     .Entitlement,
                          'PPD/COLL',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Theme
                                  .of(context)
                                  .accentColor
                          ),
                        ),
                        Text(
                          '${item.prepaidcollect}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            // color: Colors.black,
                          ),
                        ),

                      ],
                    ),
                    // Expanded(
                    //   flex:2,
                    // child: ListTile(
                    // title: Text(
                    // "ChargeCode",
                    // // S.of(context).Description,
                    // // 'Description',
                    // style: TextStyle(
                    // fontSize: 14,
                    // fontWeight: FontWeight.bold,
                    // color: Theme
                    //     .of(context)
                    //     .accentColor
                    // //color: Colors.black,
                    // ),
                    // ),
                    // subtitle: Text(
                    // '${item.description}',
                    // style: TextStyle(
                    // fontWeight: FontWeight.w600,
                    // // color: Colors.black,
                    // ),
                    // ),
                    // ),
                    // ),
                    // Expanded(
                    // child: ListTile(
                    // title: Text(
                    // S
                    //     .of(context)
                    //     .Amount,
                    // // 'Amount',
                    // style: TextStyle(
                    // fontWeight: FontWeight.w900,
                    // color: Theme
                    //     .of(context)
                    //     .accentColor
                    // // color: Colors.black,
                    // ),
                    // ),
                    // subtitle: Text(
                    // '${item.amount}',
                    // style: TextStyle(
                    // fontWeight: FontWeight.w600,
                    // // color: Colors.black,
                    // ),
                    // ),
                    // ),
                    // ),
                    // Expanded(
                    // child: ListTile(
                    // title: Text(
                    // // S
                    // //     .of(context)
                    // //     .Entitlement,
                    //  'PPD/COLL',
                    // style: TextStyle(
                    // fontSize: 14,
                    // fontWeight: FontWeight.w900,
                    // color: Theme
                    //     .of(context)
                    //     .accentColor
                    // ),
                    // ),
                    // subtitle: Text(
                    // '${item.prepaidcollect}',
                    // style: TextStyle(
                    // fontWeight: FontWeight.w600,
                    // // color: Colors.black,
                    // ),
                    // ),
                    // ),
                    // ),
                    ],
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(left: 20,top: 20,right: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S
                                  .of(context)
                                  .Amount,
                              // 'Amount',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Theme
                                      .of(context)
                                      .accentColor
                                // color: Colors.black,
                              ),
                            ),
                            Text(
                              '${item.amount}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                // color: Colors.black,
                              ),
                            ),

                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Description",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Theme
                                      .of(context)
                                      .accentColor
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 20),
                                alignment: Alignment.topCenter,
                                child: Text(item.weight)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Text(item.prepaidcollect),
                  SizedBox(
                    height: 10,
                  ),
                  // Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // children: [
                  // FlatButton(
                  // color: Theme
                  //     .of(context)
                  //     .accentColor,
                  // onPressed: () {
                  // model.deleteOtherChargesItem(item);
                  // setState(() {
                  // cardExpanded = true;
                  // previousIndex = 0;
                  // });
                  // },
                  // child: Text(
                  // S
                  //     .of(context)
                  //     .Delete,
                  // // "Delete",
                  // style: TextStyle(
                  // color: Theme
                  //     .of(context)
                  //     .backgroundColor,
                  // ),
                  // ),
                  // ),
                  // FlatButton(
                  // color: Theme
                  //     .of(context)
                  //     .accentColor,
                  // onPressed: () async {
                  // OtherChargesItem otherChargesItem =
                  // await Navigator.push(
                  // context,
                  // MaterialPageRoute<OtherChargesItem>(
                  // builder: (context) =>
                  // AddOtherChargesForm(
                  // description: item.description,
                  // amount: item.amount,
                  // entitlementValue:
                  // item.entitlement,
                  // rate: item.rate,
                  // weight: item.weight,
                  // minimum: item.minimum,
                  // useRateIsEnabled: item.useRate,
                  // )));
                  // if (otherChargesItem != null) {
                  // model.deleteOtherChargesItem(item);
                  // model.addOtherChargesItem(otherChargesItem);
                  // }
                  // },
                  // child: Text(
                  // S
                  //     .of(context)
                  //     .Edit,
                  // // "Edit",
                  // style: TextStyle(
                  // color: Theme
                  //     .of(context)
                  //     .backgroundColor,
                  // // color: Colors.black,
                  // ),
                  // ),
                  // )
                  // ],
                  // ),
                  ],
                  ),
                  ),
                ),
                    SizedBox(
                      height: 10.0,
                    )
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      );
        // model.otherChargesList.map<Container>((OtherChargesItem item) {
      // return ClipRRect(

      // return ClipRRect(
      //   borderRadius: BorderRadius.circular(20.0),
      //   child: ExpansionPanelList(
      //     animationDuration: Duration(milliseconds: 800),
      //     elevation: 3,
      //     expansionCallback: (panelIndex, isExpanded) {
      //       model.otherChargesList[previousIndex].isExpanded = false;
      //       model.otherChargesList[panelIndex].isExpanded = !isExpanded;
      //       setState(() {
      //         previousIndex = panelIndex;
      //         cardExpanded = isExpanded;
      //       });
      //     },
      //     children:
      //         model.otherChargesList.map<ExpansionPanel>((OtherChargesItem item) {
      //       return ExpansionPanel(
      //         backgroundColor: Theme.of(context).accentColor.withOpacity(0.5),
      //           canTapOnHeader: true,
      //           headerBuilder: (context, isExpanded) {
      //             return Container(
      //               child: ListTile(
      //                 leading: CircleAvatar(
      //                   backgroundColor: Theme.of(context).accentColor,
      //                   child: Icon(Icons.money,
      //                   size: 20,
      //                   color: Theme.of(context).backgroundColor,
      //                   ),
      //                 ),
      //                 title: Text(
      //                     '${item.entitlement ?? ' '}'),
      //                 subtitle: Text("${item.amount ?? ' '} INR"),
      //               ),
      //             );
      //           },
      //           body: Container(
      //             decoration: BoxDecoration(
      //               border: Border.all(
      //                 color: Theme.of(context).accentColor,
      //               ),
      //               borderRadius: BorderRadius.circular(20.0),
      //               color: Theme.of(context).backgroundColor,
      //             ),
      //
      //             // color: Theme.of(context).accentColor.withOpacity(0.2),
      //             child: Column(
      //               children: [
      //                 Row(
      //                   children: [
      //                     Expanded(
      //                       child: ListTile(
      //                         title: Text(
      //                           "ChargeCode",
      //                           // S.of(context).Description,
      //                           // 'Description',
      //                           style: TextStyle(
      //                             fontSize: 14,
      //                             fontWeight: FontWeight.bold,
      //                             color: Theme.of(context).accentColor
      //                             //color: Colors.black,
      //                           ),
      //                         ),
      //                         subtitle: Text(
      //                           '${item.description}',
      //                           style: TextStyle(
      //                             fontWeight: FontWeight.w600,
      //                             // color: Colors.black,
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                     Expanded(
      //                       child: ListTile(
      //                         title: Text(
      //                           S.of(context).Amount,
      //                           // 'Amount',
      //                           style: TextStyle(
      //                             fontWeight: FontWeight.w900,
      //                            color: Theme.of(context).accentColor
      //                            // color: Colors.black,
      //                           ),
      //                         ),
      //                         subtitle: Text(
      //                           '${item.amount}',
      //                           style: TextStyle(
      //                             fontWeight: FontWeight.w600,
      //                             // color: Colors.black,
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                     Expanded(
      //                       child: ListTile(
      //                         title: Text(
      //                           S.of(context).Entitlement,
      //                           // 'Entitlement',
      //                           style: TextStyle(
      //                               fontSize: 14,
      //                               fontWeight: FontWeight.w900,
      //                               color: Theme.of(context).accentColor
      //                           ),
      //                         ),
      //                         subtitle: Text(
      //                           '${item.entitlement}',
      //                           style: TextStyle(
      //                             fontWeight: FontWeight.w600,
      //                             // color: Colors.black,
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                   children: [
      //                     FlatButton(
      //                       color: Theme.of(context).accentColor,
      //                       onPressed: () {
      //                         model.deleteOtherChargesItem(item);
      //                         setState(() {
      //                           cardExpanded = true;
      //                           previousIndex = 0;
      //                         });
      //                       },
      //                       child: Text(
      //                         S.of(context).Delete,
      //                         // "Delete",
      //                         style: TextStyle(
      //                           color: Theme.of(context).backgroundColor,
      //                         ),
      //                       ),
      //                     ),
      //                     FlatButton(
      //                       color: Theme.of(context).accentColor,
      //                       onPressed: () async {
      //                         OtherChargesItem otherChargesItem =
      //                             await Navigator.push(
      //                                 context,
      //                                 MaterialPageRoute<OtherChargesItem>(
      //                                     builder: (context) =>
      //                                         AddOtherChargesForm(
      //                                           description: item.description,
      //                                           amount: item.amount,
      //                                           entitlementValue:
      //                                               item.entitlement,
      //                                           rate: item.rate,
      //                                           weight: item.weight,
      //                                           minimum: item.minimum,
      //                                           useRateIsEnabled: item.useRate,
      //                                         )));
      //                         if (otherChargesItem != null) {
      //                           model.deleteOtherChargesItem(item);
      //                           model.addOtherChargesItem(otherChargesItem);
      //                         }
      //                       },
      //                       child: Text(
      //                         S.of(context).Edit,
      //                         // "Edit",
      //                         style: TextStyle(
      //                           color: Theme.of(context).backgroundColor,
      //                          // color: Colors.black,
      //                         ),
      //                       ),
      //                     )
      //                   ],
      //                 ),
      //               ],
      //             ),
      //           ),
      //           isExpanded: item.isExpanded);
      //     }).toList(),
      //   ),
      // );
      //   }
      //   );
    }
    else {
      return Text(
        S.of(context).NoItemsFound,
        // "No Items Found"
      );
    }
  }
  buildExpansionPanelList2(EAWBModel model) {
    if (model.otherChargesList.isNotEmpty) {
      return  Container(
        child: Column(
          children:  model.otherChargesList.map<Column>((OtherChargesItem item) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if(item.entitlement=="Due carrier")Dismissible(
                  key: ValueKey(item),
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
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                    model.deleteOtherChargesItem(item);
                                    // deleteAWB('${getawblist[index]["id"]}');
                                  },
                                  child: Text(
                                    // BuildContext context,
                                    S.of(context).Delete,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                    //"Delete"
                                  )),
                              FlatButton(
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
                      OtherChargesItem otherChargesItem =
                      await Navigator.push(
                          context,
                          MaterialPageRoute<OtherChargesItem>(
                              builder: (context) =>
                                  AddOtherChargesForm(
                                    description: item.description,
                                    amount: item.amount,
                                    entitlementValue:
                                    item.entitlement,
                                    rate: item.rate,
                                    weight: item.weight,
                                    minimum: item.minimum,
                                    useRateIsEnabled: item.useRate,
                                  )));
                      if (otherChargesItem != null) {
                        model.deleteOtherChargesItem(item);
                        model.addOtherChargesItem(otherChargesItem);
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
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://i.pinimg.com/736x/bb/15/97/bb159741f7f3150d93792261edca8662.jpg"
                          // "assets/images/othercharge_background.gif"
                        ),
                        fit: BoxFit.fill,
                      ),
                      // border: Border.all(
                      // color: Theme
                      //     .of(context)
                      //     .accentColor,
                      // ),
                      borderRadius: BorderRadius.circular(20.0),
                      color: Theme
                          .of(context)
                          .backgroundColor,
                    ),

                    // color: Theme.of(context).accentColor.withOpacity(0.2),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "ChargeCode",
                                    // S.of(context).Description,
                                    // 'Description',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Theme
                                            .of(context)
                                            .accentColor
                                      //color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${item.description}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      // color: Colors.black,
                                    ),
                                  ),

                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    // S
                                    //     .of(context)
                                    //     .Entitlement,
                                    'PPD/COLL',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        color: Theme
                                            .of(context)
                                            .accentColor
                                    ),
                                  ),
                                  Text(
                                    '${item.prepaidcollect}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      // color: Colors.black,
                                    ),
                                  ),

                                ],
                              ),
                              // Expanded(
                              //   flex:2,
                              // child: ListTile(
                              // title: Text(
                              // "ChargeCode",
                              // // S.of(context).Description,
                              // // 'Description',
                              // style: TextStyle(
                              // fontSize: 14,
                              // fontWeight: FontWeight.bold,
                              // color: Theme
                              //     .of(context)
                              //     .accentColor
                              // //color: Colors.black,
                              // ),
                              // ),
                              // subtitle: Text(
                              // '${item.description}',
                              // style: TextStyle(
                              // fontWeight: FontWeight.w600,
                              // // color: Colors.black,
                              // ),
                              // ),
                              // ),
                              // ),
                              // Expanded(
                              // child: ListTile(
                              // title: Text(
                              // S
                              //     .of(context)
                              //     .Amount,
                              // // 'Amount',
                              // style: TextStyle(
                              // fontWeight: FontWeight.w900,
                              // color: Theme
                              //     .of(context)
                              //     .accentColor
                              // // color: Colors.black,
                              // ),
                              // ),
                              // subtitle: Text(
                              // '${item.amount}',
                              // style: TextStyle(
                              // fontWeight: FontWeight.w600,
                              // // color: Colors.black,
                              // ),
                              // ),
                              // ),
                              // ),
                              // Expanded(
                              // child: ListTile(
                              // title: Text(
                              // // S
                              // //     .of(context)
                              // //     .Entitlement,
                              //  'PPD/COLL',
                              // style: TextStyle(
                              // fontSize: 14,
                              // fontWeight: FontWeight.w900,
                              // color: Theme
                              //     .of(context)
                              //     .accentColor
                              // ),
                              // ),
                              // subtitle: Text(
                              // '${item.prepaidcollect}',
                              // style: TextStyle(
                              // fontWeight: FontWeight.w600,
                              // // color: Colors.black,
                              // ),
                              // ),
                              // ),
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(left: 20,top: 20,right: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    S
                                        .of(context)
                                        .Amount,
                                    // 'Amount',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: Theme
                                            .of(context)
                                            .accentColor
                                      // color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${item.amount}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      // color: Colors.black,
                                    ),
                                  ),

                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("Description",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        color: Theme
                                            .of(context)
                                            .accentColor
                                    ),
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(left: 20),
                                      alignment: Alignment.topCenter,
                                      child: Text(item.weight)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Text(item.prepaidcollect),
                        SizedBox(
                          height: 10,
                        )
                        // Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // children: [
                        // FlatButton(
                        // color: Theme
                        //     .of(context)
                        //     .accentColor,
                        // onPressed: () {
                        // model.deleteOtherChargesItem(item);
                        // setState(() {
                        // cardExpanded = true;
                        // previousIndex = 0;
                        // });
                        // },
                        // child: Text(
                        // S
                        //     .of(context)
                        //     .Delete,
                        // // "Delete",
                        // style: TextStyle(
                        // color: Theme
                        //     .of(context)
                        //     .backgroundColor,
                        // ),
                        // ),
                        // ),
                        // FlatButton(
                        // color: Theme
                        //     .of(context)
                        //     .accentColor,
                        // onPressed: () async {
                        // OtherChargesItem otherChargesItem =
                        // await Navigator.push(
                        // context,
                        // MaterialPageRoute<OtherChargesItem>(
                        // builder: (context) =>
                        // AddOtherChargesForm(
                        // description: item.description,
                        // amount: item.amount,
                        // entitlementValue:
                        // item.entitlement,
                        // rate: item.rate,
                        // weight: item.weight,
                        // minimum: item.minimum,
                        // useRateIsEnabled: item.useRate,
                        // )));
                        // if (otherChargesItem != null) {
                        // model.deleteOtherChargesItem(item);
                        // model.addOtherChargesItem(otherChargesItem);
                        // }
                        // },
                        // child: Text(
                        // S
                        //     .of(context)
                        //     .Edit,
                        // // "Edit",
                        // style: TextStyle(
                        // color: Theme
                        //     .of(context)
                        //     .backgroundColor,
                        // // color: Colors.black,
                        // ),
                        // ),
                        // )
                        // ],
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                )
              ],
            );
          }).toList(),
        ),
      );
      // model.otherChargesList.map<Container>((OtherChargesItem item) {
      // return ClipRRect(

      // return ClipRRect(
      //   borderRadius: BorderRadius.circular(20.0),
      //   child: ExpansionPanelList(
      //     animationDuration: Duration(milliseconds: 800),
      //     elevation: 3,
      //     expansionCallback: (panelIndex, isExpanded) {
      //       model.otherChargesList[previousIndex].isExpanded = false;
      //       model.otherChargesList[panelIndex].isExpanded = !isExpanded;
      //       setState(() {
      //         previousIndex = panelIndex;
      //         cardExpanded = isExpanded;
      //       });
      //     },
      //     children:
      //         model.otherChargesList.map<ExpansionPanel>((OtherChargesItem item) {
      //       return ExpansionPanel(
      //         backgroundColor: Theme.of(context).accentColor.withOpacity(0.5),
      //           canTapOnHeader: true,
      //           headerBuilder: (context, isExpanded) {
      //             return Container(
      //               child: ListTile(
      //                 leading: CircleAvatar(
      //                   backgroundColor: Theme.of(context).accentColor,
      //                   child: Icon(Icons.money,
      //                   size: 20,
      //                   color: Theme.of(context).backgroundColor,
      //                   ),
      //                 ),
      //                 title: Text(
      //                     '${item.entitlement ?? ' '}'),
      //                 subtitle: Text("${item.amount ?? ' '} INR"),
      //               ),
      //             );
      //           },
      //           body: Container(
      //             decoration: BoxDecoration(
      //               border: Border.all(
      //                 color: Theme.of(context).accentColor,
      //               ),
      //               borderRadius: BorderRadius.circular(20.0),
      //               color: Theme.of(context).backgroundColor,
      //             ),
      //
      //             // color: Theme.of(context).accentColor.withOpacity(0.2),
      //             child: Column(
      //               children: [
      //                 Row(
      //                   children: [
      //                     Expanded(
      //                       child: ListTile(
      //                         title: Text(
      //                           "ChargeCode",
      //                           // S.of(context).Description,
      //                           // 'Description',
      //                           style: TextStyle(
      //                             fontSize: 14,
      //                             fontWeight: FontWeight.bold,
      //                             color: Theme.of(context).accentColor
      //                             //color: Colors.black,
      //                           ),
      //                         ),
      //                         subtitle: Text(
      //                           '${item.description}',
      //                           style: TextStyle(
      //                             fontWeight: FontWeight.w600,
      //                             // color: Colors.black,
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                     Expanded(
      //                       child: ListTile(
      //                         title: Text(
      //                           S.of(context).Amount,
      //                           // 'Amount',
      //                           style: TextStyle(
      //                             fontWeight: FontWeight.w900,
      //                            color: Theme.of(context).accentColor
      //                            // color: Colors.black,
      //                           ),
      //                         ),
      //                         subtitle: Text(
      //                           '${item.amount}',
      //                           style: TextStyle(
      //                             fontWeight: FontWeight.w600,
      //                             // color: Colors.black,
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                     Expanded(
      //                       child: ListTile(
      //                         title: Text(
      //                           S.of(context).Entitlement,
      //                           // 'Entitlement',
      //                           style: TextStyle(
      //                               fontSize: 14,
      //                               fontWeight: FontWeight.w900,
      //                               color: Theme.of(context).accentColor
      //                           ),
      //                         ),
      //                         subtitle: Text(
      //                           '${item.entitlement}',
      //                           style: TextStyle(
      //                             fontWeight: FontWeight.w600,
      //                             // color: Colors.black,
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                   children: [
      //                     FlatButton(
      //                       color: Theme.of(context).accentColor,
      //                       onPressed: () {
      //                         model.deleteOtherChargesItem(item);
      //                         setState(() {
      //                           cardExpanded = true;
      //                           previousIndex = 0;
      //                         });
      //                       },
      //                       child: Text(
      //                         S.of(context).Delete,
      //                         // "Delete",
      //                         style: TextStyle(
      //                           color: Theme.of(context).backgroundColor,
      //                         ),
      //                       ),
      //                     ),
      //                     FlatButton(
      //                       color: Theme.of(context).accentColor,
      //                       onPressed: () async {
      //                         OtherChargesItem otherChargesItem =
      //                             await Navigator.push(
      //                                 context,
      //                                 MaterialPageRoute<OtherChargesItem>(
      //                                     builder: (context) =>
      //                                         AddOtherChargesForm(
      //                                           description: item.description,
      //                                           amount: item.amount,
      //                                           entitlementValue:
      //                                               item.entitlement,
      //                                           rate: item.rate,
      //                                           weight: item.weight,
      //                                           minimum: item.minimum,
      //                                           useRateIsEnabled: item.useRate,
      //                                         )));
      //                         if (otherChargesItem != null) {
      //                           model.deleteOtherChargesItem(item);
      //                           model.addOtherChargesItem(otherChargesItem);
      //                         }
      //                       },
      //                       child: Text(
      //                         S.of(context).Edit,
      //                         // "Edit",
      //                         style: TextStyle(
      //                           color: Theme.of(context).backgroundColor,
      //                          // color: Colors.black,
      //                         ),
      //                       ),
      //                     )
      //                   ],
      //                 ),
      //               ],
      //             ),
      //           ),
      //           isExpanded: item.isExpanded);
      //     }).toList(),
      //   ),
      // );
      //   }
      //   );
    }
    else {
      return Text(
        S.of(context).NoItemsFound,
        // "No Items Found"
      );
    }
  }
}