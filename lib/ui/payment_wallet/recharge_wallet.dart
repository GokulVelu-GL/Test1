import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rooster/ui/homescreen/main_homescreen.dart';
import 'package:rooster/ui/payment_wallet/add_wallet.dart';
import 'package:rooster/ui/payment_wallet/plan/planhome.dart';

import '../../formatter.dart';
import '../../generated/l10n.dart';
import '../../string.dart';
import '../drodowns/airport_code.dart';
class RechargeWallet extends StatefulWidget {
  const RechargeWallet({Key key}) : super(key: key);

  @override
  State<RechargeWallet> createState() => _RechargeWalletState();
}

class _RechargeWalletState extends State<RechargeWallet> with TickerProviderStateMixin{
  bool selected = false;
  List status=[];
  List text = [];
  List name=[];
  var toCurrencyExchangeRate;

  int sum =0;
  double per =0.0;
  double used=0;
  TextEditingController _controller = TextEditingController(text: "0");
  TextEditingController currencyconvert = TextEditingController(text: "0");

  TextEditingController DateController = TextEditingController();
  // TextEditingController nameController = TextEditingController();
  TextEditingController ConvertCurr = TextEditingController();
  DateTime current =DateTime.now();
  //String date = DateFormat('dd-MM-yyyy').add_jms().format(DateTime.now()).toString();
  String date = DateFormat('dd-MM-yyyy kk:mm').format(DateTime.now());

  Razorpay _razorpay;
  // TextEditingController _controller =TextEditingController();
  TextEditingController _Detailcontroller =TextEditingController();
  TextEditingController Currencycontroller =TextEditingController();
  int one, two, three;
  double con;
  double quotedUSDValue, quotedToCurrencyValue;
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

  @override
  Widget build(BuildContext context) {
    int flagOffset = 0x1F1E6;
    int asciiOffset = 0x41;

    String country = "USD";

    int firstChar = country.codeUnitAt(0) - asciiOffset + flagOffset;
    int secondChar = country.codeUnitAt(1) - asciiOffset + flagOffset;

    String emoji =
        String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString() );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Recharge Wallet"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  HomeScreen()),
            );
          }, icon: Icon(Icons.next_plan)),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(left: 40.0, right: 40.0,top:30.0),
                child: TextField(

                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      suffixIcon:
                      Material(
                      //   elevation: 10.0,
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
                          BorderSide(color: Theme.of(context).accentColor, width: 1.0)
                      ),
                      // helperText: 'base currency is United States Dollar ('+format.currencySymbol+')',
                      // helperStyle: TextStyle(
                      //   color: Theme.of(context).accentColor
                      // ),
                      // prefixIcon: Icon(Icons.money,
                      //   size: 25,
                      //   color: Theme.of(context).accentColor,
                      // ),
                      prefixText: format.currencySymbol,
                      suffixText: emoji+" USD ",

                      labelText: 'Base currency is USD('+format.currencySymbol+')',
                      labelStyle: TextStyle(
                          color: Theme.of(context).accentColor
                      ),
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

                  // onChanged: (text){
                  //   _controller.text=text;
                  // },
                ),

              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {

                      one=int.parse(_controller.text)+10;
                      _controller.text=one.toString();
                    },
                    child: Text("+ "+ format.currencySymbol+"10",
                      style: TextStyle(
                          color: Theme.of(context).accentColor
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {

                      one=int.parse(_controller.text)+20;
                      _controller.text=one.toString();
                    },
                    child: Text("+ "+ format.currencySymbol+"20",
                      style: TextStyle(
                          color: Theme.of(context).accentColor
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {

                      one=int.parse(_controller.text)+25;
                      _controller.text=one.toString();
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
              Container(
                  margin: EdgeInsets.only(left: 40.0,right: 40.0),
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
                            //      //gapPadding: 20.0,
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
                            labelText: 'Desired Payment Currency Code',
                           // S.of(context).CurrencyCode,
                            //"Currency Code",
                            prefixText: flag,
                            labelStyle: new TextStyle(
                                color: Theme.of(context).accentColor,
                                // color: Colors.deepPurple,
                                fontSize: 16.0),
                            // contentPadding: EdgeInsets.all(19.0),
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
                         toCurrencyExchangeRate =
                        StringData.getCurrencyrate("USD",ConvertCurr.text.toString() );
                        print(ConvertCurr);
                        double quotedUSDValue, quotedToCurrencyValue;
                        if(toCurrencyExchangeRate!=null){
                          // quotedToCurrencyValue =
                          //     (double.tryParse(_controller.text) * quotedToCurrencyValue) /
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
                            this.currencyconvert.text=(int.parse(_controller.text)*(int.parse(toCurrencyExchangeRate))).toString();


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
                          setState(() {
                            currencyconvert.text=(int.parse(_controller.text)*(int.parse(toCurrencyExchangeRate))).toString();
                            //
                            // this.currencyconvert.text =
                            //     baseCurrencyExchangeRate.toString();
                            // convertvalue= baseCurrencyExchangeRate.toString();
                          });
                       //  }
                         print('Rate:${toCurrencyExchangeRate}');
                      })
              ),
              SizedBox(
                height: 5,
              ),
              // TextButton(
              //   style: TextButton.styleFrom(
              //       primary: Theme.of(context).backgroundColor,
              //       backgroundColor: Theme.of(context).accentColor
              //   ),
              //   onPressed: () {
              //     // currencyconvert.text = (double.parse(quotedToCurrencyValue.toString())*100.roundToDouble()).toString();
              //     currencyconvert.text=(int.parse(_controller.text)*(int.parse(toCurrencyExchangeRate))).toString();
              //   },
              //   child: Text("Rate"),),
              Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(left: 40.0,right: 40.0),
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
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 40.0,right: 40.0),
                child: TextField(
                  readOnly: true,
                  enableInteractiveSelection: true,
                  keyboardType: TextInputType.number,
                  controller: currencyconvert,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      // fillColor: Colors.grey,
                      suffixIcon:
                      Material(
                      //   elevation: 10.0,
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
                      // Icon(Icons.money,
                      //   size: 25,
                      //   color: Theme.of(context).accentColor,
                      // ),
                      labelText : "Amount to be Paid ",
                      helperText : "(calculated against base currency)",
                      helperStyle: TextStyle(
                        color: Theme.of(context).accentColor
                      ),
                      labelStyle: TextStyle(
                          color: Theme.of(context).accentColor
                      ),
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
                              // width: 5,
                              color: Theme.of(context).accentColor
                          )
                      )
                  ),
                  onChanged: (text){
                    setState(() {
                      currencyconvert.text=text;
                    });
                  },
                ),


              ),
              SizedBox(
                height: 20,
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
                      labelText: "Payment Remarks",
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
              SizedBox(
                height: 20,
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
                    if(int.parse(_controller.text)<=25) {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddWallet(total:
                                  _controller.text,
                                      //currencyconvert.text,
                                      Currency: ConvertCurr.text
                                  )
                            //PaymentHomePage()
                          ));
                      openCheckout();
                      print(currencyconvert.text);
                    }
                    if(int.parse(_controller.text)<=25&&per<=1.0&&sum<=2000){
                      print("Ans"+sum.toString());
                      text.add(_controller.text);
                      // // text.add((double.parse(_controller.text)*100.roundToDouble()).toString(),);
                      // name.add(_Detailcontroller.text);
                      //used space
                      sum =sum + int.parse(_controller.text);
                      //percentage
                      per =((sum/2000)*100)*0.01;
                      used =(sum/2000)*100;
                      print(per);

                      // sum=sum+value;

                      // _controller.clear();
                      // _Detailcontroller.clear();
                      print(used);


                      // category.remove(_controller.text);
                    } if(sum>20){
                      final scaffold = ScaffoldMessenger.of(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Wallet balance cannot exceed 25 USD"),
                          duration:  Duration(minutes: 1),
                          action: SnackBarAction(label: 'x', onPressed: scaffold.hideCurrentSnackBar)
                      ));
                    }
                    if(int.parse(_controller.text)<=5){
                      final scaffold = ScaffoldMessenger.of(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("your balance is low, Please top up/recharge to continue with our service, Thank you"),
                          duration:  Duration(minutes: 1),
                          action: SnackBarAction(label: 'x', onPressed: scaffold.hideCurrentSnackBar)
                      ),);
                    }
                  });
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(
                  //         builder: (BuildContext context) =>
                  //             AddWallet(total:_controller.text)
                  //       //PaymentHomePage()
                  //     ));
                  print("add ........................................."+_controller.text);
                  // _controller.clear();
                  // _Detailcontroller.clear();
                },
                child: Text("Pay"),

              ),
              Image.asset(
              "assets/recharge_wallet/recharge_wallet.gif"
                //  "https://www.arkasoftwares.com/blog/wp-content/uploads/2021/01/Near-Field-Communication.gif"
              ),
            ],
          ),
        ),
      ),
    );
  }
  void openCheckout() async {
    var options = {
      'key': 'rzp_test_n7OuwwK5q9g6yi',
      'amount': (double.parse(currencyconvert.text)*100.roundToDouble()).toString(),
      'name': 'Drona',
      'currency':ConvertCurr.text,
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
    // Navigator.of(context).push(
    //     MaterialPageRoute(
    //         builder: (BuildContext context) =>
    //             AddWallet(total:
    //             _controller.text,
    //                 //currencyconvert.text,
    //                 Currency:ConvertCurr.text
    //             )
    //       //PaymentHomePage()
    //     ));
    print('Success Response: $response');
    // status.add("successs");
    Scaffold.of(context).showSnackBar(SnackBar(content: Text("SUCCESS: " + response.paymentId)));
    /*Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    String a = response.message;
    status.add("Failure");
    print("response.................................................................."+response.message);
    Scaffold.of(context).showSnackBar(SnackBar(content: Text ("ERROR: " + response.code.toString() + " - " + response.message)));
    status.add(response.message);
    /* Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    String a = response.walletName;
    print("a="+response.walletName);
    Scaffold.of(context).showSnackBar(SnackBar(content: Text("EXTERNAL_WALLET: " + response.walletName)));

    /* Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT); */
  }
}
