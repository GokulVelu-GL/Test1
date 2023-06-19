import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rooster/ui/homescreen/eawb.dart';
import '../../formatter.dart';
import '../../generated/l10n.dart';
import 'package:http/http.dart' as http;
import '../../string.dart';
import '../drodowns/airport_code.dart';
class AddWallet extends StatefulWidget {

  String total;
  String Currency;
   AddWallet({Key key,this.total,this.Currency}) : super(key: key);

  @override
  State<AddWallet> createState() => _AddWalletState();
}

class _AddWalletState extends State<AddWallet> with TickerProviderStateMixin{
  var baseCurrencyExchangeRate;
  int totalinitial = 0;
  bool selected = false;
  List status=[];
  List<Payment> trans = <Payment>[];
  // List<Recharge> recharge =<Recharge>[];
  List text = [];
  double quotedUSDValue;
  List name=[];
  int one, two, three;
  int sum =0;
  double per =0.0;
  double used=0;
  var toCurrencyExchangeRate;
  TextEditingController _controller = TextEditingController();
  TextEditingController _extra_amountcontroller = TextEditingController(text: "0");
  TextEditingController currencyconvert = TextEditingController(text: "0");
  TextEditingController DateController = TextEditingController();
  // TextEditingController nameController = TextEditingController();
  TextEditingController currencycontroller = TextEditingController();


  TextEditingController currconvert = TextEditingController();

  DateTime current =DateTime.now();
  String convertvalue ="";
  //String date = DateFormat('dd-MM-yyyy').add_jms().format(DateTime.now()).toString();
  String date = DateFormat('dd-MM-yyyy kk:mm:ss').format(DateTime.now().toUtc());

  Razorpay _razorpay;
  // TextEditingController _controller =TextEditingController();
  TextEditingController _Detailcontroller =TextEditingController();
  TextEditingController Currencycontroller =TextEditingController();

  AnimationController _resizableController;
  final animationDuration = Duration(milliseconds: 500);
  String flag;




  @override
  void initState() {
    _razorpay=Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _resizableController = new AnimationController(
      vsync: this,
      duration: new Duration(
        milliseconds: 1000,
      ),
    );
    _resizableController.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _resizableController.reverse();
          break;
        case AnimationStatus.dismissed:
          _resizableController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });

    _resizableController.forward();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    _razorpay?.clear();
  }
  final fromTextController = TextEditingController();
  List<String> currencies;
  String from;
  String to;
  String initial_recharge;

  double rate;
  String result = "";
  TextEditingController ConvertCurr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int flagOffset = 0x1F1E6;
    int asciiOffset = 0x41;

    String country = "USD";

    int firstChar = country.codeUnitAt(0) - asciiOffset + flagOffset;
    int secondChar = country.codeUnitAt(1) - asciiOffset + flagOffset;

    String emoji =
        String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
     initial_recharge = widget.total;
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString() );
    currconvert.text=convertvalue;
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text("Add Wallet",
        ),
        actions: [
          IconButton(onPressed: (){
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                title: AnimatedBuilder(
                    animation: _resizableController,
                    builder: (context, child) {
                      return Container(
                        padding: EdgeInsets.only(left: 15.0,
                            top: 10.0,bottom: 10.0,
                            right: 15.0),
                        child: Center(child: Text("Help")),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          border: Border.all(
                              color: Theme.of(context).backgroundColor, width: _resizableController.value * 10),
                        ),
                      );
                    }),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.monetization_on_rounded,
                          color: Theme.of(context).accentColor,
                        ),
                        title: Text("drag the ball left to navigate add wallet page"),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.monetization_on_rounded,
                          color: Theme.of(context).accentColor,
                        ),
                        title: Text("drag the ball right to navigate Transactions page"),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Text("Trail"),
                        title: Text("Trail user not allowed to use mandatory pages"),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Text("Gold",style:
                        TextStyle(
                            color: Colors.orangeAccent
                        ),),
                        title: Text("user can access all page"),
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        child:  Text("Close",
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }, icon: Icon(Icons.help)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).accentColor,
                        child: IconButton(
                          color: Theme.of(context).backgroundColor,
                            onPressed: (){
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
                                          title: Text("Recharge Wallet"),
                                          centerTitle: true,
                                        ),
                                        body: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 40.0, right: 40.0,top: 20.0),
                                                child: TextField(
                                                  keyboardType: TextInputType.number,
                                                  controller: _extra_amountcontroller,
                                                  textInputAction: TextInputAction.next,
                                                  decoration: InputDecoration(
                                                      prefixText:format.currencySymbol,
                                                      // prefixIcon: Icon(Icons.money,
                                                      //   color: Theme.of(context).accentColor,
                                                      // ),
                                                      suffixText: emoji+" USD ",
                                                      labelText: "Base currency is USD ("+format.currencySymbol+")",

                                                      labelStyle: TextStyle(
                                                          color: Theme.of(context).accentColor
                                                      ),
                                                      suffixIcon:
                                                      Material(
                                                        //  elevation: 10.0,
                                                        color: Theme.of(context).accentColor,
                                                        // shadowColor: Colors.green,
                                                        borderRadius: BorderRadius.only(
                                                            topRight: Radius.circular(15.0),
                                                            bottomRight: Radius.circular(15.0)

                                                        ),
                                                        child: Icon(Icons.money,
                                                            size: 20,
                                                            color: Colors.white),
                                                      ),
                                                      contentPadding:
                                                      EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(15.0),
                                                          borderSide:
                                                          BorderSide(color: Theme.of(context).accentColor, width: 1.0)),
                                                      // enabledBorder: new OutlineInputBorder(
                                                      //   borderRadius: new BorderRadius.circular(15.0),
                                                      //   borderSide:  BorderSide(
                                                      //       color: Theme.of(context).accentColor
                                                      //     //color: Colors.deepPurple
                                                      //   ),
                                                      //
                                                      // ),
                                                      focusedBorder: new OutlineInputBorder(
                                                        borderRadius: new BorderRadius.circular(15.0),
                                                        borderSide:  BorderSide(
                                                            color: Theme.of(context).accentColor
                                                          //    color: Colors.deepPurple
                                                        ),

                                                      ),
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10.0),
                                                          borderSide: BorderSide(
                                                              width: 5,
                                                              color: Theme.of(context).accentColor
                                                          )
                                                      )
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {

                                                      one=int.parse(_extra_amountcontroller.text)+10;
                                                      _extra_amountcontroller.text=one.toString();
                                                    },
                                                    child: Text("+ "+ format.currencySymbol+"10",
                                                      style: TextStyle(
                                                          color: Theme.of(context).accentColor
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {

                                                      one=int.parse(_extra_amountcontroller.text)+20;
                                                      _extra_amountcontroller.text=one.toString();
                                                    },
                                                    child: Text("+ "+ format.currencySymbol+"20",
                                                      style: TextStyle(
                                                          color: Theme.of(context).accentColor
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {

                                                      one=int.parse(_extra_amountcontroller.text)+25;
                                                      _extra_amountcontroller.text=one.toString();
                                                    },
                                                    child: Text("+ "+ format.currencySymbol+"25",
                                                      style: TextStyle(
                                                          color: Theme.of(context).accentColor
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),

                                              // select currency 1
                                              //convert currency
                                              Container(
                                                  margin: EdgeInsets.only(left: 40.0, right: 40.0),
                                                  child: TypeAheadFormField<CurrencyCode>(
                                                      enabled: false,
                                                      suggestionsCallback: CurrencyAPI.getCurrencyCode,
                                                      itemBuilder: (context, CurrencyCode suggestion) {
                                                        final code = suggestion;
                                                        return ListTile(
                                                          title: Text(code.currencyCode),
                                                          subtitle: Text(code.currencyName),
                                                        );
                                                      },
                                                      validator: (value) {
                                                        if (value.isEmpty) {
                                                          return
                                                            S.of(context).SelectacurrencyName;

                                                          //'Select a currency Name';
                                                        }
                                                        return null;
                                                      },
                                                      textFieldConfiguration: TextFieldConfiguration(
                                                        autofocus: false,
                                                        controller: ConvertCurr,
                                                        textInputAction: TextInputAction.next,
                                                        inputFormatters: [AllCapitalCase()],
                                                        decoration: InputDecoration(
                                                            isDense: true,
                                                            suffixIcon:
                                                            Material(
                                                              //  elevation: 10.0,
                                                              color: Theme.of(context).accentColor,
                                                              // shadowColor: Colors.green,
                                                              borderRadius: BorderRadius.only(
                                                                  topRight: Radius.circular(15.0),
                                                                  bottomRight: Radius.circular(15.0)

                                                              ),
                                                              child: Icon(Icons.money,
                                                                  size: 20,
                                                                  color: Colors.white),
                                                            ),
                                                            contentPadding:
                                                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(15.0),
                                                                borderSide:
                                                                BorderSide(color: Theme.of(context).accentColor, width: 1.0)),
                                                            // enabledBorder: OutlineInputBorder(
                                                            //     borderSide: new BorderSide(
                                                            //         color: Theme.of(context).accentColor,
                                                            //         // color: Colors.deepPurple,
                                                            //         width: 1),
                                                            //     // gapPadding: 60.0,
                                                            //     borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                width: 1,
                                                                color: Theme.of(context).accentColor,
                                                                //   color: Colors.deepPurple
                                                              ),
                                                              borderRadius: BorderRadius.circular(15.0),
                                                            ),
                                                            // border: OutlineInputBorder(
                                                            //     gapPadding: 2.0,
                                                            //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                            labelText:
                                                            "Desired Payment Currency Code",
                                                            prefixText: flag,
                                                            //S.of(context).CurrencyCode,
                                                            //"Currency Code",
                                                            labelStyle: new TextStyle(
                                                                color: Theme.of(context).accentColor,
                                                                // color: Colors.deepPurple,
                                                                fontSize: 16.0),
                                                            // prefixIcon: Icon(
                                                            //   Icons.money,
                                                            //   size: 25,
                                                            //   color: Theme.of(context).accentColor,
                                                            //   // color: Colors.deepPurple,
                                                            // )
                                                          // 'Destination',
                                                        ),
                                                      ),
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                      onSuggestionSelected: (CurrencyCode suggestion) {
                                                        if (suggestion.currencyCode == null &&
                                                            suggestion.currencyName == null) {
                                                          return
                                                            S.of(context).WrongCode;
                                                          //'Worong Code';
                                                        } else {
                                                          this.ConvertCurr.text = suggestion.currencyName;
                                                          String Currency = suggestion.currencyName;
                                                          print(Currency);
                                                        }
                                                        ConvertCurr.text = suggestion.currencyCode;
                                                        this.ConvertCurr.text = suggestion.currencyCode;
                                                        // toCurrencyExchangeRate = StringData.getCurrencyrate("USD",ConvertCurr.text.toString() );
                                                        toCurrencyExchangeRate = StringData.getCurrencyrate("USD",widget.Currency );
                                                        print(ConvertCurr);

                                                        double quotedUSDValue, quotedToCurrencyValue;
                                                        if(toCurrencyExchangeRate!=null){
                                                          // quotedToCurrencyValue =
                                                          //     (double.tryParse(_extra_amountcontroller.text) * quotedToCurrencyValue) /
                                                          //         1.00;
                                                          setState(() {
                                                            int flagOffset = 0x1F1E6;
                                                            int asciiOffset = 0x41;

                                                            String country =
                                                                ConvertCurr.text;

                                                            int firstChar = country.codeUnitAt(0) - asciiOffset + flagOffset;
                                                            int secondChar = country.codeUnitAt(1) - asciiOffset + flagOffset;

                                                            flag =
                                                                String.fromCharCode(firstChar) + String.fromCharCode(secondChar);

                                                            // currencyconvert.text=quotedToCurrencyValue.toString();
                                                            currencyconvert.text=(int.parse(_extra_amountcontroller.text)*(int.parse(toCurrencyExchangeRate))).toString();
                                                           // currencyconvert.text=(int.parse(_controller.text)*(int.parse(toCurrencyExchangeRate))).toString();
                                                          });
                                                        }
                                                        //  //model.chargeSummaryTotalPostpaid
                                                        //  //to convert originCurrency to USD
                                                        // var  baseCurrencyExchangeRate = StringData.getCurrencyrate(
                                                        //      "USD",ConvertCurr.text);
                                                        //  // var toCurrencyExchangeRate =
                                                        //  // StringData.getCurrencyrate("USD", currencycontroller.text);
                                                        //
                                                        //  //quotedToCurrencyValue;
                                                        //
                                                        //  if (baseCurrencyExchangeRate != null
                                                        //  //&&
                                                        //  //    toCurrencyExchangeRate != null
                                                        //  ) {
                                                        //   double quotedUSDValue =
                                                        //        (1.00 * int.tryParse(_controller.text)) /
                                                        //            double.tryParse(baseCurrencyExchangeRate);
                                                        //    // quotedToCurrencyValue =
                                                        //    //     (double.tryParse(toCurrencyExchangeRate) * quotedUSDValue) /
                                                        //    //         1.00;
                                                        //    // baseCurencyrate = baseCurrencyExchangeRate;
                                                        //    setState(() {
                                                        //      currencyconvert.text =
                                                        //          quotedUSDValue.toString();
                                                        //      //
                                                        //      // this.currencyconvert.text =
                                                        //      //     baseCurrencyExchangeRate.toString();
                                                        //      // convertvalue= baseCurrencyExchangeRate.toString();
                                                        //    });
                                                        //  }
                                                        print('Rate:${toCurrencyExchangeRate}');
                                                      })
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              // TextButton(
                                              //   style: TextButton.styleFrom(
                                              //       primary: Theme.of(context).backgroundColor,
                                              //       backgroundColor: Theme.of(context).accentColor
                                              //   ),
                                              //   onPressed: () {
                                              //     // currencyconvert.text = (double.parse(quotedToCurrencyValue.toString())*100.roundToDouble()).toString();
                                              //     currencyconvert.text=(int.parse(_extra_amountcontroller.text)*(int.parse(toCurrencyExchangeRate))).toString();
                                              //   },
                                              //   child: Text("Rate"),),
                                              Container(
                                                alignment: Alignment.topRight,
                                                margin: EdgeInsets.only(left: 50.0,right: 50.0),
                                                child: IconButton(onPressed: (){
                                                  showDialog(
                                                    context: context,
                                                    builder: (ctx) => AlertDialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(30.0))),
                                                      title: AnimatedBuilder(
                                                          animation: _resizableController,
                                                          builder: (context, child) {
                                                            return Container(
                                                              padding: EdgeInsets.only(left: 15.0,
                                                                  top: 10.0,bottom: 10.0,
                                                                  right: 15.0),
                                                              child: Center(child: Text("Currency conversion")),
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape.rectangle,
                                                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                                                border: Border.all(
                                                                    color: Theme.of(context).backgroundColor, width: _resizableController.value * 10),
                                                              ),
                                                            );
                                                          }),
                                                      content: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Card(
                                                            child: ListTile(
                                                              leading: Icon(Icons.monetization_on_rounded,
                                                                color: Theme.of(context).accentColor,
                                                              ),
                                                              subtitle: Text("Enter the Amount in USD (Base currency in USD Field) "+format.currencySymbol,
                                                                textAlign: TextAlign.justify,
                                                              ),
                                                            ),
                                                          ),
                                                          Card(
                                                            child: ListTile(
                                                              leading: Icon(Icons.monetization_on_rounded,
                                                                color: Theme.of(context).accentColor,
                                                              ),
                                                              subtitle: Text("Currency code inCurrency can be converted based on user choice (select Desired Payment Currency Code field) ",
                                                                textAlign: TextAlign.justify,

                                                              ),
                                                            ),
                                                          ),
                                                          Card(
                                                            child: ListTile(
                                                              leading: Icon(Icons.monetization_on_rounded,
                                                                color: Theme.of(context).accentColor,
                                                              ),
                                                              subtitle: Text("converted amount is shown in (Amount to be Paid field) ",
                                                                  textAlign: TextAlign.justify),
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(ctx).pop();
                                                          },
                                                          child: Center(
                                                            child: Container(
                                                              padding: const EdgeInsets.all(14),
                                                              child:  Text("Close",
                                                                style: TextStyle(
                                                                  color: Theme.of(context).accentColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }, icon: Icon(Icons.help,
                                                    color:Theme.of(context).accentColor
                                                )),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 40.0, right: 40.0),
                                                child: TextField(
                                                  readOnly: true,
                                                  enableInteractiveSelection: true,
                                                  keyboardType: TextInputType.number,
                                                  controller: currencyconvert,
                                                  textInputAction: TextInputAction.next,
                                                  decoration: InputDecoration(
                                                    // prefixText:format.currencySymbol,
                                                    //   prefixIcon: Icon(Icons.money,
                                                    //     size: 25,
                                                    //     color: Theme.of(context).accentColor,
                                                    //   ),
                                                      labelText: "Amount to be Paid",
                                                      // filled:true,
                                                      // fillColor:Colors.white,
                                                      labelStyle: TextStyle(
                                                          color: Theme.of(context).accentColor
                                                      ),
                                                      helperText: " (calculated against base currency)",
                                                      helperStyle: TextStyle(
                                                        color: Theme.of(context).accentColor
                                                      ),
                                                      suffixIcon:
                                                      Material(
                                                        //  elevation: 10.0,
                                                        color: Theme.of(context).accentColor,
                                                        // shadowColor: Colors.green,
                                                        borderRadius: BorderRadius.only(
                                                            topRight: Radius.circular(15.0),
                                                            bottomRight: Radius.circular(15.0)

                                                        ),
                                                        child: Icon(Icons.money,
                                                            size: 20,
                                                            color: Colors.white),
                                                      ),
                                                      contentPadding:
                                                      EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(15.0),
                                                          borderSide:
                                                          BorderSide(color: Theme.of(context).accentColor, width: 1.0)),
                                                      // enabledBorder: new OutlineInputBorder(
                                                      //   borderRadius: new BorderRadius.circular(15.0),
                                                      //   borderSide:  BorderSide(
                                                      //       color: Theme.of(context).accentColor
                                                      //     //color: Colors.deepPurple
                                                      //   ),
                                                      //
                                                      // ),
                                                      focusedBorder: new OutlineInputBorder(
                                                        borderRadius: new BorderRadius.circular(15.0),
                                                        borderSide:  BorderSide(
                                                            color: Theme.of(context).accentColor
                                                          //    color: Colors.deepPurple
                                                        ),

                                                      ),
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10.0),
                                                          borderSide: BorderSide(
                                                              width: 5,
                                                              color: Theme.of(context).accentColor
                                                          )
                                                      )
                                                  ),
                                                  onChanged: (text){
                                                    setState(() {
                                                      currencyconvert.text=widget.Currency;
                                                    });
                                                  },
                                                ),


                                              ),
                                              SizedBox
                                                (
                                                height: 20.0,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 40.0, right: 40.0),
                                                child: TextField(
                                                  controller: _Detailcontroller,
                                                  maxLength: 50,
                                                  maxLines: 1,
                                                  decoration: InputDecoration(
                                                      suffixIcon:
                                                      Material(
                                                        // elevation: 10.0,
                                                        color: Theme.of(context).accentColor,
                                                        // shadowColor: Colors.green,
                                                        borderRadius: BorderRadius.only(
                                                            topRight: Radius.circular(15.0),
                                                            bottomRight: Radius.circular(15.0)
                                                        ),
                                                        child: Icon(Icons.details,
                                                            size: 20,
                                                            color: Colors.white),
                                                      ),
                                                      contentPadding:
                                                      EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(15.0),
                                                          borderSide:
                                                          BorderSide(color: Theme.of(context).accentColor, width: 1.0)),
                                                      // prefixIcon: Icon(Icons.details,
                                                      //   size: 25,
                                                      //   color: Theme.of(context).accentColor,
                                                      // ),
                                                      labelText: "Payment Remarks ",
                                                      labelStyle: TextStyle(color: Theme.of(context).accentColor),
                                                      // enabledBorder: new OutlineInputBorder(
                                                      //   borderRadius: new BorderRadius.circular(15.0),
                                                      //   borderSide:  BorderSide(
                                                      //       color: Theme.of(context).accentColor
                                                      //     //color: Colors.deepPurple
                                                      //   ),),
                                                      focusedBorder: new OutlineInputBorder(
                                                        borderRadius: new BorderRadius.circular(15.0),
                                                        borderSide:  BorderSide(
                                                            color: Theme.of(context).accentColor
                                                          //    color: Colors.deepPurple
                                                        ),
                                                      ),
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10.0),
                                                          borderSide: BorderSide(
                                                              width: 5,
                                                              color: Theme.of(context).accentColor
                                                          )
                                                      )
                                                  ),
                                                ),
                                              ),
                                              SizedBox
                                                (
                                                height: 10.0,
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                    primary: Theme.of(context).backgroundColor,
                                                    backgroundColor: Theme.of(context).accentColor
                                                ),
                                                onPressed: () {

                                                  // print(_controller.text);
                                                  // print("status "+status.toString());
                                                  setState(() {

                                                    toCurrencyExchangeRate = StringData.getCurrencyrate("USD",widget.Currency );
                                                    // currencyconvert.text=widget.Currency;
                                                    currencyconvert.text=(int.parse(_extra_amountcontroller.text)*(int.parse(toCurrencyExchangeRate))).toString();

                                                    int extra = int.parse(widget.total)+int.parse(_extra_amountcontroller.text);

                                                    if(extra<=25) {
                                                      int extratotal = int
                                                          .parse(widget.total) +
                                                          int.parse(
                                                              _extra_amountcontroller
                                                                  .text);
                                                      widget.total =
                                                          extratotal.toString();
                                                      print(
                                                          "ttttttttttttttttttttt" +
                                                              widget.total);

                                                      String amnt = _extra_amountcontroller
                                                          .text;
                                                      text.add(amnt);
                                                      trans.add(
                                                          Payment(
                                                              amnt, Colors
                                                              .green,
                                                              _Detailcontroller
                                                                  .text
                                                          ));
                                                      print(text);
                                                      totalinitial =
                                                          totalinitial +
                                                              int.parse(
                                                                  _extra_amountcontroller
                                                                      .text);
                                                      totalinitial = int.parse(
                                                          widget.total) -
                                                          totalinitial;
                                                      print("totlinitial" +
                                                          totalinitial
                                                              .toString());
                                                      //total values
                                                      // convertvalue =
                                                      //     quotedUSDValue.toString();
                                                      openCheckout();
                                                    }
                                                    else{
                                                      final scaffold = ScaffoldMessenger.of(context);
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                          content: Text("Wallet balance cannot exceed 25 USD"),
                                                          duration:  Duration(minutes: 1),
                                                          action: SnackBarAction(label: 'x', onPressed: scaffold.hideCurrentSnackBar)
                                                      ));
                                                    }
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Pay"),
                                              ),
                                              Image.asset(
                                              "assets/recharge_wallet/recharge_wallet.gif"
                                              //    "https://www.arkasoftwares.com/blog/wp-content/uploads/2021/01/Near-Field-Communication.gif"
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                        },
                            icon: Icon(Icons.monetization_on_sharp),

                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Recharge",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                           // color: Theme.of(context).backgroundColor
                          //color: Colors.blue[100]
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).accentColor,
                        child: IconButton(
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
                                        title: Text("Recharge History"),
                                        centerTitle: true,
                                      ),
                                      body: Container(
                                        // width: MediaQuery.of(context).size.width - 10,
                                        // height: MediaQuery.of(context).size.height -  80,
                                        padding: EdgeInsets.all(20),
                                        color: Colors.white,
                                        child: Column(
                                          children: [

                                            ListView.builder(
                                              reverse: true,
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemCount:text.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  // text.add(_extra_amountcontroller.text);
                                                  return Dismissible(
                                                      direction: DismissDirection.endToStart,
                                                      onDismissed: (_) {
                                                        setState(() {
                                                          // sum = sum - int.parse(trans[index].amount.toString());
                                                          text.removeAt(index);
                                                          name.removeAt(index);
                                                        });
                                                      },
                                                      key: UniqueKey(),
                                                      child:Container(
                                                        //  padding: const EdgeInsets.all(8.0),
                                                        margin: EdgeInsets.only(left: 30.0,right: 30.0),
                                                        child: Card(
                                                          elevation: 4,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(15.0)
                                                          ),
                                                          child: Container(
                                                            // margin: EdgeInsets.symmetric(horizontal: 30),
                                                            // padding: EdgeInsets.all(10.0),
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius:
                                                                BorderRadius.all(Radius.circular(15))),
                                                            child: Row(
                                                              children: <Widget>[
                                                                Container(
                                                                  // margin:EdgeInsets.all(5.0),
                                                                  decoration: BoxDecoration(
                                                                      color:Theme.of(context).accentColor.withOpacity(0.3),
                                                                      borderRadius: BorderRadius.all(
                                                                          Radius.circular(15))),
                                                                  child: Icon(Icons.arrow_circle_up,
                                                                    color: Theme.of(context).accentColor,
                                                                  ),
                                                                  padding: EdgeInsets.all(12),
                                                                ),
                                                                SizedBox(
                                                                  width: 16,
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    children: <Widget>[
                                                                      Text("+"+format.currencySymbol+text[index], style: TextStyle(fontSize: 15,
                                                                      color: Colors.green)),
                                                                      Text(
                                                                        //status[index]
                                                                          date
                                                                        //DateController.text
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:  EdgeInsets.all(8.0),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    children: <Widget>[

                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                  );
                                                }),
                                            Container(
                                              //  padding: const EdgeInsets.all(8.0),
                                              margin: EdgeInsets.only(left: 30.0,right: 30.0),
                                              child: Card(
                                                elevation: 4,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15.0)
                                                ),
                                                child: Container(
                                                  // margin: EdgeInsets.symmetric(horizontal: 30),
                                                  // padding: EdgeInsets.all(10.0),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                      BorderRadius.all(Radius.circular(15))),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        // margin:EdgeInsets.all(5.0),
                                                        decoration: BoxDecoration(
                                                            color:Theme.of(context).accentColor.withOpacity(0.3),
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(15))),
                                                        child: Icon(Icons.arrow_circle_up,
                                                          color: Theme.of(context).accentColor,
                                                        ),
                                                        padding: EdgeInsets.all(12),
                                                      ),
                                                      SizedBox(
                                                        width: 16,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            Text(
                                                                (totalinitial!=0)?"+"+format.currencySymbol+totalinitial.toString():"+"+format.currencySymbol+widget.total,
                                                                //"+"+format.currencySymbol+widget.total,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    color: Colors.green
                                                                )),
                                                            Text(
                                                              //status[index]
                                                                date
                                                              //DateController.text
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:  EdgeInsets.all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: <Widget>[

                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                        },
                          icon: Icon(Icons.history),

                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "History",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            //color: Theme.of(context).backgroundColor
                          //color: Theme.of(context).accentColor,
                          //    color: Colors.blue[100]
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0, 1),
                        blurRadius: 9.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).accentColor.withOpacity(0.2),
                            ),

                          ),
                          SizedBox(width: 5,),
                          Text("Total USD:"+ widget.total,
                          ),
                        ],
                      ),
                      SizedBox(height: 6,),
                      Row(
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).accentColor
                            ),
                          ),
                          SizedBox(width: 10,),

                          Text("Total USD Spent: "+ sum.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 151,
                  height: 151,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0, 1),
                        blurRadius: 9.0,
                      ),
                    ],
                  ),
                  child:CircularPercentIndicator(
                    animation: true,
                    animationDuration: 10000,
                    radius: 50,
                    lineWidth: 8,
                    percent: (per<=1.0)?per:per-1.0,

                    header: Text("100%"),
                    center: (used<=100)?Text(used.toStringAsFixed(2)+"%"):Text("0%"),
                    progressColor: Theme.of(context).accentColor,
                    backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                DragTarget(
                  builder: (context, List<int> candidateData, rejectedData) {
                    return Container(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Start Payment",
                        // style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                  onWillAccept: (data) {
                    return true;
                  },
                  onAccept: (data) {
                    _displayDialog(context);
                  },
                ),
                Draggable(
                  data: 5,
                  child: Container(
                    width: 51,
                    height: 51,
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white54, Theme.of(context).primaryColor],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.3, 1]),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.attach_money,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  feedback: Container(
                    width: 51,
                    height: 51,
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white54,
                            Theme.of(context).accentColor
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.3, 1]),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.attach_money,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  axis: Axis.horizontal,
                  childWhenDragging: Container(
                    width: 51,
                    height: 51,
                  ),
                ),
                DragTarget(
                  builder: (context, List<int> candidateData, rejectedData) {
                    return Container(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Transactions",
                        //style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                  onWillAccept: (data) {
                    return true;
                  },
                  onAccept: (data) {

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
                                title: Text("Transaction"),
                                centerTitle: true,
                              ),
                              body: Container(
                                // width: MediaQuery.of(context).size.width - 10,
                                // height: MediaQuery.of(context).size.height -  80,
                                padding: EdgeInsets.all(20),
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      reverse: true,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: trans.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Dismissible(
                                              direction: DismissDirection.endToStart,
                                              onDismissed: (_) {
                                                setState(() {
                                                  sum = sum - int.parse(trans[index].amount.toString());
                                                  text.removeAt(index);
                                                  name.removeAt(index);
                                                });
                                              },
                                              key: UniqueKey(),
                                              child:Container(
                                                //  padding: const EdgeInsets.all(8.0),
                                                margin: EdgeInsets.only(left: 30.0,right: 30.0),
                                                child: Card(
                                                  elevation: 4,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(15.0)
                                                  ),
                                                  child: Container(
                                                    // margin: EdgeInsets.symmetric(horizontal: 30),
                                                    // padding: EdgeInsets.all(10.0),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                        BorderRadius.all(Radius.circular(15))),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          // margin:EdgeInsets.all(5.0),
                                                          decoration: BoxDecoration(
                                                              color:Theme.of(context).accentColor.withOpacity(0.3),
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(15))),
                                                          child: (Colors.green==trans[index].color)?Icon(Icons.arrow_circle_up, color: Theme.of(context).accentColor,):
                                                          Icon(Icons.arrow_circle_down, color: Theme.of(context).accentColor
                                                          ),
                                                          padding: EdgeInsets.all(12),
                                                        ),
                                                        SizedBox(
                                                          width: 16,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              trans[index].color==Colors.green?Text(
                                                                  "+"+format.currencySymbol+trans[index].amount,
                                                                  style: TextStyle(fontSize: 15,
                                                                      color: trans[index].color
                                                                  )
                                                              ):Text(
                                                                  "-"+format.currencySymbol+trans[index].amount,
                                                                  style: TextStyle(fontSize: 15,
                                                                      color: trans[index].color
                                                                  )
                                                              ),
                                                              Text(
                                                                //status[index]
                                                                  date
                                                                //DateController.text
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:  EdgeInsets.all(8.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: <Widget>[
                                                              Text(trans[index].description,
                                                                style: TextStyle(
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                          );
                                        }),
                                    Container(
                                      //  padding: const EdgeInsets.all(8.0),
                                      margin: EdgeInsets.only(left: 30.0,right: 30.0),
                                      child: Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0)
                                        ),
                                        child: Container(
                                          // margin: EdgeInsets.symmetric(horizontal: 30),
                                          // padding: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(15))),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                // margin:EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                    color:Theme.of(context).accentColor.withOpacity(0.3),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(15))),
                                                child: Icon(Icons.arrow_circle_up,
                                                  color: Theme.of(context).accentColor,
                                                ),
                                                padding: EdgeInsets.all(12),
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                        (totalinitial!=0)?"+"+format.currencySymbol+totalinitial.toString():"+"+format.currencySymbol+widget.total,
                                                        //"+"+format.currencySymbol+widget.total,
                                                        style: TextStyle(fontSize: 15,
                                                            color: Colors.green
                                                        )),
                                                    Text(
                                                      //status[index]
                                                        date
                                                      //DateController.text
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:  EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: <Widget>[
                                                    // Text(name[index],
                                                    //   style: TextStyle(
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                ),
                IconButton(
                    color: Theme.of(context).accentColor,
                    onPressed: (){
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0))),
                          title: AnimatedBuilder(
                              animation: _resizableController,
                              builder: (context, child) {
                                return Container(
                                  padding: EdgeInsets.only(left: 15.0,
                                      top: 10.0,bottom: 10.0,
                                      right: 15.0),
                                  child: Center(child: Text("Help")),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                    border: Border.all(
                                        color: Theme.of(context).backgroundColor, width: _resizableController.value * 4),
                                  ),
                                );
                              }),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              Card(
                                child: ListTile(
                                  leading: Icon(Icons.monetization_on_rounded,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  subtitle: Text("drag the ball left to navigate Start Payment page",
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  leading: Icon(Icons.monetization_on_rounded,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  subtitle: Text("drag the ball right to navigate Transaction page",
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ),

                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  child:  Text("Close",
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }, icon: Icon(Icons.help)),
              ],
            ),
            (text==0)?Text(" "):SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Recent",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).accentColor,
                              //    color: Colors.grey[500]
                            ),
                          ),
                          IconButton(onPressed: (){
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                                title: AnimatedBuilder(
                                    animation: _resizableController,
                                    builder: (context, child) {
                                      return Container(
                                        padding: EdgeInsets.only(left: 15.0,
                                            top: 10.0,bottom: 10.0,
                                            right: 15.0),
                                        child: Center(child: Text("Help")),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                          border: Border.all(
                                              color: Theme.of(context).backgroundColor, width: _resizableController.value * 10),
                                        ),
                                      );
                                    }),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Card(
                                      child: ListTile(
                                        leading: Icon(Icons.monetization_on_rounded,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        title: Text("Recent Transactions"),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        child:  Text("Close",
                                          style: TextStyle(
                                            color: Theme.of(context).accentColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }, icon: Icon(Icons.help,
                          color:Theme.of(context).accentColor
                          )),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32),
                    ),

                    SizedBox(
                      height: 16,
                    ),
                    ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: trans.length,
                        itemBuilder: (BuildContext context, int index) {
                          return

                            Dismissible(
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) {
                                setState(() {
                                  sum = sum - int.parse(trans[index].amount.toString());
                                  trans.removeAt(index).amount;
                                  name.removeAt(index);
                                });
                              },
                              key: UniqueKey(),
                              child:Container(
                              //  padding: const EdgeInsets.all(8.0),
                                margin: EdgeInsets.only(left: 30.0,right: 30.0),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0)
                                  ),
                                  child: Container(
                                    // margin: EdgeInsets.symmetric(horizontal: 30),
                                    // padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                         // margin:EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                              color:Theme.of(context).accentColor.withOpacity(0.3),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          child: (Colors.green==trans[index].color)?Icon(Icons.arrow_circle_up,
                                            color: Theme.of(context).accentColor,
                                          ):Icon(Icons.arrow_circle_down,
                                            color: Theme.of(context).accentColor,
                                          ),
                                          padding: EdgeInsets.all(12),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              // (recharge[index].color==Colors.green)?
                                              // Text(
                                              //     format.currencySymbol+trans[index].amount,
                                              //     style: TextStyle(fontSize: 15)
                                              // ):
                                              trans[index].color==Colors.green?Text(
                                                  "+"+format.currencySymbol+trans[index].amount,
                                                  style: TextStyle(fontSize: 15,
                                                  color: trans[index].color
                                                  )
                                              ):Text(
                                                  "-"+format.currencySymbol+trans[index].amount,
                                                  style: TextStyle(fontSize: 15,
                                                      color: trans[index].color
                                                  )
                                              ),
                                              Text(
                                                //status[index]
                                                  date
                                                //DateController.text
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:  EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: <Widget>[
                                              // Text(name[index],
                                              //   style: TextStyle(
                                              //   ),
                                              //),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          );
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      //  padding: const EdgeInsets.all(8.0),
                      margin: EdgeInsets.only(left: 30.0,right: 30.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Container(
                          // margin: EdgeInsets.symmetric(horizontal: 30),
                          // padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(15))),
                          child: Row(
                            children: <Widget>[
                              Container(
                                // margin:EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    color:Theme.of(context).accentColor.withOpacity(0.3),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15))),
                                child: Icon(Icons.arrow_circle_up,
                                  color: Theme.of(context).accentColor,
                                ),
                                padding: EdgeInsets.all(12),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // (recharge[index].color==Colors.green)?
                                    // Text(
                                    //     format.currencySymbol+trans[index].amount,
                                    //     style: TextStyle(fontSize: 15)
                                    // ):
                                    Text(
                                         (totalinitial!=0)?"+"+format.currencySymbol+totalinitial.toString():"+"+format.currencySymbol+widget.total,
                                        //"+"+format.currencySymbol+totalinitial.toString(),
                                        style: TextStyle(fontSize: 15,
                                        color: Colors.green
                                        )
                                    ),
                                    Text(
                                      //status[index]
                                        date
                                      //DateController.text
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    // Text(name[index],
                                    //   style: TextStyle(
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Payment',
            )),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _controller,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.money,
                            color: Theme.of(context).accentColor,
                          ),
                          labelText: "Amount",

                          labelStyle: TextStyle(
                              color: Theme.of(context).accentColor
                          ),
                          enabledBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            borderSide:  BorderSide(
                                color: Theme.of(context).accentColor
                              //color: Colors.deepPurple
                            ),

                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            borderSide:  BorderSide(
                                color: Theme.of(context).accentColor
                              //    color: Colors.deepPurple
                            ),

                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  width: 5,
                                  color: Theme.of(context).accentColor
                              )
                          )
                      ),
                    ),

                  ),
                  Container(
                      margin: EdgeInsets.all(10.0),
                      child: TypeAheadFormField<CurrencyCode>(
                          suggestionsCallback: CurrencyAPI.getCurrencyCode,
                          itemBuilder: (context, CurrencyCode suggestion) {
                            final code = suggestion;
                            return ListTile(
                              title: Text(code.currencyCode),
                              subtitle: Text(code.currencyName),
                            );
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return
                                S.of(context).SelectacurrencyName;

                              //'Select a currency Name';
                            }
                            return null;
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                            autofocus: false,
                            controller: ConvertCurr,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [AllCapitalCase()],
                            decoration: InputDecoration(
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Theme.of(context).accentColor,
                                        // color: Colors.deepPurple,
                                        width: 1),
                                    // gapPadding: 60.0,
                                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context).accentColor,
                                    //   color: Colors.deepPurple
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                // border: OutlineInputBorder(
                                //     gapPadding: 2.0,
                                //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                labelText:
                                S.of(context).CurrencyCode,
                                //"Currency Code",
                                labelStyle: new TextStyle(
                                    color: Theme.of(context).accentColor,
                                    // color: Colors.deepPurple,
                                    fontSize: 16.0),
                                prefixIcon: Icon(
                                  Icons.money,
                                  color: Theme.of(context).accentColor,
                                  // color: Colors.deepPurple,
                                )
                              // 'Destination',
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onSuggestionSelected: (CurrencyCode suggestion) {
                            if (suggestion.currencyCode == null &&
                                suggestion.currencyName == null) {
                              return
                                S.of(context).WrongCode;
                              //'Worong Code';
                            } else {
                              this.ConvertCurr.text = suggestion.currencyName;
                              String Currency = suggestion.currencyName;
                              print(Currency);
                            }
                            ConvertCurr.text = suggestion.currencyCode;
                            this.ConvertCurr.text = suggestion.currencyCode;
                            //model.chargeSummaryTotalPostpaid
                            //to convert originCurrency to USD
                            baseCurrencyExchangeRate = StringData.getCurrencyrate(
                                "USD",ConvertCurr.text);
                            // var toCurrencyExchangeRate =
                            // StringData.getCurrencyrate("USD", currencycontroller.text);

                            //quotedToCurrencyValue;

                            if (baseCurrencyExchangeRate != null
                            //&&
                            //    toCurrencyExchangeRate != null
                            ) {
                              quotedUSDValue =
                                  (1.00 * int.tryParse(_controller.text)) /
                                      double.tryParse(baseCurrencyExchangeRate);
                              // quotedToCurrencyValue =
                              //     (double.tryParse(toCurrencyExchangeRate) * quotedUSDValue) /
                              //         1.00;
                              // baseCurencyrate = baseCurrencyExchangeRate;
                              setState(() {
                                convertvalue =
                                    quotedUSDValue.toString();
                                print(convertvalue);
                                currconvert.text =
                                "10";

                                // this.currconvert.text =
                                //     baseCurrencyExchangeRate.toString();
                                // convertvalue= baseCurrencyExchangeRate.toString();
                              });
                            }
                            print(currconvert.text+".........................................................");

                            print('Rate:${baseCurrencyExchangeRate}');
                          })
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _Detailcontroller,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.details,
                            color: Theme.of(context).accentColor,
                          ),
                          labelText: "Remarks",
                          labelStyle: TextStyle(color: Theme.of(context).accentColor),
                          enabledBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            borderSide:  BorderSide(
                                color: Theme.of(context).accentColor
                              //color: Colors.deepPurple
                            ),),
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            borderSide:  BorderSide(
                                color: Theme.of(context).accentColor
                              //    color: Colors.deepPurple
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  width: 5,
                                  color: Theme.of(context).accentColor
                              )
                          )
                      ),
                    ),
                  ),

                  TextButton(
                    style: TextButton.styleFrom(
                        primary: Theme.of(context).backgroundColor,
                        backgroundColor: Theme.of(context).accentColor
                    ),
                    onPressed: () {
                      print(_controller.text);
                      print("status "+status.toString());
                      setState(() {
                        convertvalue =
                            quotedUSDValue.toString();
                        int checksum =sum + int.parse(_controller.text);
                        // openCheckout();
                        if(int.parse(_controller.text)<=25&&per<=1.0&&sum<=25&&checksum<=int.parse(widget.total)){
                          print("Ams"+sum.toString());
                          trans.add(
                              Payment(
                              _controller.text,Colors.red,_Detailcontroller.text)
                          );
                       //   text.add(_controller.text);
                          // text.add((double.parse(_controller.text)*100.roundToDouble()).toString(),);
                          name.add(_Detailcontroller.text);
                          //used space
                          sum =sum + int.parse(_controller.text);
                          //percentage
                          per =((sum/int.parse(widget.total))*100)*0.01;
                          print("summmmmmmmmmmmm"+initial_recharge);
                          used =(sum/int.parse(widget.total))*100;
                          print(per);

                          // sum=sum+value;
                          _controller.clear();
                          _Detailcontroller.clear();
                          print(used);
                          // category.remove(_controller.text);
                        } if(sum>25
                        //int.parse(widget.total)
                        ){
                          final scaffold = ScaffoldMessenger.of(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Wallet balance cannot exceed 25"),
                              duration:  Duration(minutes: 1),
                              action: SnackBarAction(label: 'x', onPressed: scaffold.hideCurrentSnackBar)
                          ));
                        }
                        // if(sum<=50){
                        //   final scaffold = ScaffoldMessenger.of(context);
                        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //       content: Text("your balance is low, Please top up/recharge to continue with our service, Thank you"),
                        //       duration:  Duration(minutes: 1),
                        //       action: SnackBarAction(label: 'x', onPressed: scaffold.hideCurrentSnackBar)
                        //   ),);
                        // }
                      });
                      Navigator.of(context).pop();
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => Dialog(
                          shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            height: 165,
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topCenter,
                              fit: StackFit.loose,
                              children: <Widget>[
                                Transform.translate(
                                  offset: Offset(0, -50),
                                  child: ClipOval(
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: FittedBox(
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                        //   ("https://eadn-wc01-4731180.nxedge.io/cdn/media/wp-content/uploads/2019/02/transportation-and-logistics-concept.jpg"
                                        // ),
                                          (
                                           "assets/recharge_wallet/success_payment.gif"
                                              //   "https://i.pinimg.com/originals/70/a5/52/70a552e8e955049c8587b2d7606cd6a6.gif"
                                          // "https://image.shutterstock.com/image-vector/warehouse-loading-dock-goods-vehicles-260nw-2044711208.jpg"
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                ),
                                Transform.translate(
                                  offset: Offset(0, 60),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "Success",
                                          // "Enter AWB number",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      TextButton(
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Close",
                                          // "Search"
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text("Pay"),

                  )
                ],
              ),
            ),
          );
        });
  }
  void openCheckout() async {
    var options = {
      'key': 'rzp_test_n7OuwwK5q9g6yi',
      'amount': (double.parse(currencyconvert.text)*100.roundToDouble()).toString(),
      'name': 'Drona',
      'currency': ConvertCurr.text,
      'theme':{
        'color':'#800080'
      },
      'description': _Detailcontroller.text,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: $response');
    // status.add("successs");
    Navigator.of(context, rootNavigator: true).pop('dialog');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:Text("SUCCESS: " + response.paymentId),
        duration: Duration(seconds: 2),
      ),
    );
    /*Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    String a = response.message;
    status.add("Failure");
    print("response.................................................................."+response.message);
    Navigator.of(context, rootNavigator: true).pop('dialog');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:Text("ERROR: " + response.code.toString() + " - " + response.message),
        duration: Duration(seconds: 2),
      ),
    );
    status.add(response.message);
    /* Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    String a = response.walletName;
    print("a="+response.walletName);
    Navigator.of(context, rootNavigator: true).pop('dialog');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:Text("EXTERNAL_WALLET: " + response.walletName),
        duration: Duration(seconds: 2),
      ),
    );
    /* Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT); */
  }
  }

class Payment {
  final String amount;
  Color color;
  String description;
  Payment(this.amount,this.color,this.description);
}
class Recharge {
  final String amount;
  Color color;
  Recharge(this.amount,this.color);
}