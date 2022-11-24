import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/ui/eawb/cc_charges_in_destination_currency.dart';
import 'package:rooster/ui/eawb/static/custom_background.dart';
import 'package:rooster/ui/eawb/rate_description.dart';

class ChargesSummary extends StatefulWidget {
  ChargesSummary({Key key}) : super(key: key);

  @override
  _ChargesSummaryState createState() => _ChargesSummaryState();
}

class _ChargesSummaryState extends State<ChargesSummary> {
  final _chargesSummaryFormKey = GlobalKey<FormState>();

  FocusNode _chargesSummaryWeightChargePrepaidFocusNode = FocusNode();
  FocusNode _chargesSummaryWeightChargePostpaidFocusNode = FocusNode();

  FocusNode _chargesSummaryValuationChargePrepaidFocusNode = FocusNode();
  FocusNode _chargesSummaryValuationChargePostpaidFocusNode = FocusNode();

  FocusNode _chargesSummaryTaxPrepaidFocusNode = FocusNode();
  FocusNode _chargesSummaryTaxPostpaidFocusNode = FocusNode();

  FocusNode _chargesSummaryTotalOtherChargesDueAgentPrepaidFocusNode =
      FocusNode();
  FocusNode _chargesSummaryTotalOtherChargesDueAgentPostpaidFocusNode =
      FocusNode();

  FocusNode _chargesSummaryTotalOtherChargesDueCarrierPrepaidFocusNode =
      FocusNode();
  FocusNode _chargesSummaryTotalOtherChargesDueCarrierPostpaidFocusNode =
      FocusNode();

  FocusNode _chargesSummaryTotalPrepaidFocusNode = FocusNode();
  FocusNode _chargesSummaryTotalPostpaidFocusNode = FocusNode();
  TextEditingController teTotal = new TextEditingController();
  TextEditingController postTotal = new TextEditingController();

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
              name: S.of(context).Chargessummary,
              //"Charges Summary",
              next: CcChargesInDestinationCurrency(),
              previous: RateDescription(),
              help:   IconButton(
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
                                      leading: Icon(Icons.monitor_weight_outlined,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Total Weight Charge"),
                                      subtitle: Text("An amount of money \nExample: 300 "),
                                    ),
                                  ),  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.monitor_weight_outlined,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Valuation Charges,Taxes"),
                                      subtitle: Text("An amount of money \nExample: 20 "),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.monitor_weight_outlined,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Total Other Charges Due Agent / Due Carrier"),
                                      subtitle: Text("An amount of money \nExample: 30 "),
                                    ),
                                  ),  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.monitor_weight_outlined,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Total "),
                                      subtitle: Text("An amount of money \nExample: 3000"),
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
              child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _chargesSummaryFormKey,
                      child: SingleChildScrollView(
                          child: Column(
                        children: <Widget>[

                          weightCharge(model),
                          valuationCharge(model),
                          tax(model),
                          totalOtherChargesDueAgent(model),
                          totalOtherChargesDueCarrier(model),
                          total(model)
                        ],
                      )),
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  weightCharge(model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            S.of(context).WeightCharges,
            // "Weight Charges",
            style: TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontWeight: FontWeight.w500,
                fontSize: 17.0),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: TextFormField(
                      initialValue: model.chargeSummaryWeightChargePrepaid,
                      focusNode: _chargesSummaryWeightChargePrepaidFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) {
                        _fieldFocusChange(
                            context,
                            _chargesSummaryWeightChargePrepaidFocusNode,
                            _chargesSummaryWeightChargePostpaidFocusNode);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: Theme.of(context).accentColor,
                                //color: Colors.deepPurple,
                                width: 2),
                            //gapPadding: 2.0,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).accentColor,
                            // color: Colors.deepPurple
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        // border: OutlineInputBorder(
                        //     gapPadding: 2.0,
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(8.0))),
                        labelText: S.of(context).Prepaid,
                        labelStyle: new TextStyle(
                            color: Theme.of(context).accentColor,
                            // color: Colors.deepPurple,
                            fontSize: 16.0),
                        // 'Prepaid',
                      ),
                      onChanged: (text) {
                       //    int total=0;
                       // for(int i=0;i<model.rateDescriptionItemList.length;i++)
                       //   total+=model.rateDescriptionItemList[i]['Total'];
                       //    model.chargeSummaryWeightChargePrepaid=total;
                          model.chargeSummaryWeightChargePrepaid = text;
                          print(model.chargeSummaryWeightChargePrepaid);
                          // model.summaryratedescription();
                          totalPrePaind(model);

                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: TextFormField(
                      initialValue: model.chargeSummaryWeightChargePostpaid,
                      focusNode: _chargesSummaryWeightChargePostpaidFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) {
                        _fieldFocusChange(
                            context,
                            _chargesSummaryWeightChargePostpaidFocusNode,
                            _chargesSummaryValuationChargePrepaidFocusNode);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: Theme.of(context).accentColor,
                                // color: Colors.deepPurple,
                                width: 2),
                            //gapPadding: 2.0,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).accentColor,
                            // color: Colors.deepPurple
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        // border: OutlineInputBorder(
                        //     gapPadding: 2.0,
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(8.0))),
                        labelText:
                        "Collect",
                        //S.of(context).Postpaid,
                        labelStyle: new TextStyle(
                            color: Theme.of(context).accentColor,
                            //color: Colors.deepPurple,
                            fontSize: 16.0),
                        //  'Postpaid',
                      ),
                      onChanged: (text) {
                        model.chargeSummaryWeightChargePostpaid = text;
                        totalPostpaid(model);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  valuationCharge(model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            S.of(context).ValuationCharges,
            // "Valuation Charges",
            style: TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontWeight: FontWeight.w500,
                fontSize: 17.0),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: TextFormField(
                      initialValue: model.chargeSummaryValuationChargePrepaid,
                      focusNode: _chargesSummaryValuationChargePrepaidFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) {
                        _fieldFocusChange(
                            context,
                            _chargesSummaryValuationChargePrepaidFocusNode,
                            _chargesSummaryValuationChargePostpaidFocusNode);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: Theme.of(context).accentColor,
                                //   color: Colors.deepPurple,
                                width: 2),
                            //gapPadding: 2.0,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).accentColor,
                            // color: Colors.deepPurple
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        // border: OutlineInputBorder(
                        //     gapPadding: 2.0,
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(8.0))),
                        labelText: S.of(context).Prepaid,
                        labelStyle: new TextStyle(
                            color: Theme.of(context).accentColor,
                            // color: Colors.deepPurple,
                            fontSize: 16.0),
                        //'Prepaid',
                      ),
                      onChanged: (text) {
                        model.chargeSummaryValuationChargePrepaid = text;
                        totalPrePaind(model);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: TextFormField(
                      initialValue: model.chargeSummaryValuationChargePostpaid,
                      focusNode:
                          _chargesSummaryValuationChargePostpaidFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) {
                        _fieldFocusChange(
                            context,
                            _chargesSummaryValuationChargePostpaidFocusNode,
                            _chargesSummaryTaxPrepaidFocusNode);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: Theme.of(context).accentColor,
                                // color: Colors.deepPurple,
                                width: 2),
                            //gapPadding: 2.0,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).accentColor,
                            // color: Colors.deepPurple
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        // border: OutlineInputBorder(
                        //     gapPadding: 2.0,
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(8.0))),
                        labelText:
                        "Collect",
                        //S.of(context).Postpaid,
                        labelStyle: new TextStyle(
                            color: Theme.of(context).accentColor,
                            //color: Colors.deepPurple,
                            fontSize: 16.0),
                        //'Postpaid',
                      ),
                      onChanged: (text) {
                        model.chargeSummaryValuationChargePostpaid = text;
                        totalPostpaid(model);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  tax(model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            S.of(context).Tax,
            // "Tax",
            style: TextStyle(
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
                fontWeight: FontWeight.w500,
                fontSize: 17.0),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: TextFormField(
                      initialValue: model.chargeSummaryTaxPrepaid,
                      focusNode: _chargesSummaryTaxPrepaidFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) {
                        _fieldFocusChange(
                            context,
                            _chargesSummaryTaxPrepaidFocusNode,
                            _chargesSummaryTaxPostpaidFocusNode);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: Theme.of(context).accentColor,
                                // color: Colors.deepPurple,
                                width: 2),
                            //gapPadding: 2.0,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).accentColor,
                            //    color: Colors.deepPurple
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        // border: OutlineInputBorder(
                        //     gapPadding: 2.0,
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(8.0))),
                        labelText: S.of(context).Prepaid,
                        labelStyle: new TextStyle(
                            color: Theme.of(context).accentColor,
                            //color: Colors.deepPurple,
                            fontSize: 16.0),
                        //'Prepaid',
                      ),
                      onChanged: (text) {
                        model.chargeSummaryTaxPrepaid = text;
                        totalPrePaind(model);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: TextFormField(
                      initialValue: model.chargeSummaryTaxPostpaid,
                      focusNode: _chargesSummaryTaxPostpaidFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) {
                        _fieldFocusChange(
                            context,
                            _chargesSummaryTaxPostpaidFocusNode,
                            _chargesSummaryTotalOtherChargesDueAgentPrepaidFocusNode);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: Theme.of(context).accentColor,
                                // color: Colors.deepPurple,
                                width: 2),
                            //gapPadding: 2.0,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).accentColor,
                            // color: Colors.deepPurple
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        // border: OutlineInputBorder(
                        //     gapPadding: 2.0,
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(8.0))),
                        labelText:
                        "Collect",
                        //S.of(context).Postpaid,
                        labelStyle: new TextStyle(
                            color: Theme.of(context).accentColor,
                            //color: Colors.deepPurple,
                            fontSize: 16.0),
                        //'Postpaid',
                      ),
                      onChanged: (text) {
                        model.chargeSummaryTaxPostpaid = text;
                        totalPostpaid(model);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  totalOtherChargesDueAgent(model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            S.of(context).TotalOtherChargesDueAgent,
            // "Total Other Charges Due Agent",
            style: TextStyle(
                color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
                fontWeight: FontWeight.w500,
                fontSize: 17.0),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: TextFormField(
                      enabled: true,
                      initialValue: model.chargeSummaryDueAgentPrepaid,
                      focusNode:
                          _chargesSummaryTotalOtherChargesDueAgentPrepaidFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) {
                        _fieldFocusChange(
                            context,
                            _chargesSummaryTotalOtherChargesDueAgentPrepaidFocusNode,
                            _chargesSummaryTotalOtherChargesDueAgentPostpaidFocusNode);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: Theme.of(context).accentColor,
                                // color: Colors.deepPurple,
                                width: 2),
                            //gapPadding: 2.0,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).accentColor,
                            //color: Colors.deepPurple
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        // border: OutlineInputBorder(
                        //     gapPadding: 2.0,
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(8.0))),
                        labelText: S.of(context).Prepaid,
                        labelStyle: new TextStyle(
                            color: Theme.of(context).accentColor,
                            //color: Colors.deepPurple,
                            fontSize: 16.0),
                        //'Prepaid',
                      ),
                      onChanged: (text) {
                        model.chargeSummaryDueAgentPrepaid = text;
                        totalPrePaind(model);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: TextFormField(
                      enabled: true,
                      initialValue: model.chargeSummaryDueAgentPostpaid,
                      focusNode:
                          _chargesSummaryTotalOtherChargesDueAgentPostpaidFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) {
                        _fieldFocusChange(
                            context,
                            _chargesSummaryTotalOtherChargesDueAgentPostpaidFocusNode,
                            _chargesSummaryTotalOtherChargesDueCarrierPrepaidFocusNode);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: Theme.of(context).accentColor,
                                // color: Colors.deepPurple,
                                width: 2),
                            //gapPadding: 2.0,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).accentColor,
                            // color: Colors.deepPurple
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        // border: OutlineInputBorder(
                        //     gapPadding: 2.0,
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(8.0))),
                        labelText:
                        "Collect",
                        //S.of(context).Postpaid,
                        labelStyle: new TextStyle(
                            color: Theme.of(context).accentColor,
                            //color: Colors.deepPurple,
                            fontSize: 16.0),
                        //'Postpaid',
                      ),
                      onChanged: (text) {
                        model.chargeSummaryDueAgentPostpaid = text;
                        totalPostpaid(model);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  totalOtherChargesDueCarrier(model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            S.of(context).TotalOtherChargesDueCarrier,
            // "Total Other Charges Due Carrier",
            style: TextStyle(
                color: Theme.of(context).accentColor,
                //  color: Colors.deepPurple,
                fontWeight: FontWeight.w500,
                fontSize: 17.0),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: TextFormField(
                      enabled: true,
                      initialValue: model.chargeSummaryDueCarrierPrepaid,
                      focusNode:
                          _chargesSummaryTotalOtherChargesDueCarrierPrepaidFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) {
                        _fieldFocusChange(
                            context,
                            _chargesSummaryTotalOtherChargesDueCarrierPrepaidFocusNode,
                            _chargesSummaryTotalOtherChargesDueCarrierPostpaidFocusNode);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: Theme.of(context).accentColor,
                                // color: Colors.deepPurple,
                                width: 2),
                            //gapPadding: 2.0,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).accentColor,
                            //  color: Colors.deepPurple
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        // border: OutlineInputBorder(
                        //     gapPadding: 2.0,
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(8.0))),
                        labelText: S.of(context).Prepaid,
                        labelStyle: new TextStyle(
                            color: Theme.of(context).accentColor,
                            //color: Colors.deepPurple,
                            fontSize: 16.0),
                        //'Prepaid',
                      ),
                      onChanged: (text) {
                        model.chargeSummaryDueCarrierPrepaid = text;
                        totalPrePaind(model);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: TextFormField(
                      enabled: true,
                      initialValue: model.chargeSummaryDueCarrierPostpaid,
                      focusNode:
                          _chargesSummaryTotalOtherChargesDueCarrierPostpaidFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (value) {
                        _fieldFocusChange(
                            context,
                            _chargesSummaryTotalOtherChargesDueCarrierPostpaidFocusNode,
                            _chargesSummaryTotalPrepaidFocusNode);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: Theme.of(context).accentColor,
                                // color: Colors.deepPurple,
                                width: 2),
                            //gapPadding: 2.0,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).accentColor,
                            // color: Colors.deepPurple
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        // border: OutlineInputBorder(
                        //     gapPadding: 2.0,
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(8.0))),
                        labelText:
                        "Collect",
                        //S.of(context).Postpaid,
                        labelStyle: new TextStyle(
                            color: Theme.of(context).accentColor,
                            // color: Colors.deepPurple,
                            fontSize: 16.0),
                        //'Postpaid',
                      ),
                      onChanged: (text) {
                        model.chargeSummaryDueCarrierPostpaid = text;
                        totalPostpaid(model);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  total(model) {
    teTotal.text = model.chargeSummaryTotalPrepaid;
    postTotal.text = model.chargeSummaryTotalPostpaid;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            S.of(context).Total,
            //  "Total",
            style: TextStyle(
                color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
                fontWeight: FontWeight.w500,
                fontSize: 17.0),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: TextFormField(
                      enabled: false,
                      //initialValue: model.chargeSummaryTotalPrepaid,
                      focusNode: _chargesSummaryTotalPrepaidFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      controller: teTotal,
                      onFieldSubmitted: (value) {
                        _fieldFocusChange(
                            context,
                            _chargesSummaryTotalPrepaidFocusNode,
                            _chargesSummaryTotalPostpaidFocusNode);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: Theme.of(context).accentColor,
                                //color: Colors.deepPurple,
                                width: 2),
                            //gapPadding: 2.0,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).accentColor,
                            //color: Colors.deepPurple
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        // border: OutlineInputBorder(
                        //     gapPadding: 2.0,
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(8.0))),
                        labelText: S.of(context).Prepaid,
                        labelStyle: new TextStyle(
                            color: Theme.of(context).accentColor,
                            //color: Colors.deepPurple,
                            fontSize: 16.0),
                        //'Prepaid',
                      ),
                      onChanged: (text) {
                        model.chargeSummaryTotalPrepaid = text;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: TextFormField(
                      enabled: false,
                      //initialValue: model.chargeSummaryTotalPostpaid,
                      controller: postTotal,
                      focusNode: _chargesSummaryTotalPostpaidFocusNode,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (value) {
                        _chargesSummaryTotalPostpaidFocusNode.unfocus();
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: Theme.of(context).accentColor,
                                // color: Colors.deepPurple,
                                width: 2),
                            //gapPadding: 2.0,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).accentColor,
                            //color: Colors.deepPurple
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        // border: OutlineInputBorder(
                        //     gapPadding: 2.0,
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(8.0))),
                        labelText:
                        "Collect",
                        //S.of(context).Postpaid,
                        labelStyle: new TextStyle(
                            color: Theme.of(context).accentColor,
                            //color: Colors.deepPurple,
                            fontSize: 16.0),
                        //'Postpaid',
                      ),
                      onChanged: (text) {
                        model.chargeSummaryTotalPostpaid = text;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  totalPrePaind(model) {
    print(model.chargeSummaryWeightChargePrepaid +
        model.chargeSummaryValuationChargePrepaid +
        model.chargeSummaryTaxPrepaid);

    var wcharge =
        int.tryParse(model.chargeSummaryWeightChargePrepaid.toString()) ?? 0;

    var vcharge =
        int.tryParse(model.chargeSummaryValuationChargePrepaid.toString()) ?? 0;
    var tax = int.tryParse(model.chargeSummaryTaxPrepaid.toString()) ?? 0;
    var due = int.tryParse(model.chargeSummaryDueAgentPrepaid.toString()) ?? 0;
    var dueCarrier = 0;
    dueCarrier =
        int.tryParse(model.chargeSummaryDueCarrierPrepaid.toString()) ?? 0;

    setState(() {
      model.chargeSummaryTotalPrepaid =
          (wcharge + vcharge + tax + due + dueCarrier).toString();
      teTotal.text = model.chargeSummaryTotalPrepaid;
    });

    print(model.chargeSummaryTotalPrepaid);
  }

  totalPostpaid(model) {
    // print(model.chargeSummaryWeightChargePrepaid +
    //     model.chargeSummaryValuationChargePrepaid +
    //     model.chargeSummaryTaxPrepaid);

    var wcharge =
        int.tryParse(model.chargeSummaryWeightChargePostpaid.toString()) ?? 0;

    var vcharge =
        int.tryParse(model.chargeSummaryValuationChargePostpaid.toString()) ??
            0;
    var tax = int.tryParse(model.chargeSummaryTaxPostpaid.toString()) ?? 0;
    var due = int.tryParse(model.chargeSummaryDueAgentPostpaid.toString()) ?? 0;
    var dueCarrier = 0;
    dueCarrier =
        int.tryParse(model.chargeSummaryDueCarrierPostpaid.toString()) ?? 0;

    setState(() {
      model.chargeSummaryTotalPostpaid =
          (wcharge + vcharge + tax + due + dueCarrier).toString();
      postTotal.text = model.chargeSummaryTotalPostpaid;
    });

    print(model.chargeSummaryTotalPostpaid);
  }
}
