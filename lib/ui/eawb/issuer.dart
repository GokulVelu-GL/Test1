import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rooster/formatter.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/ui/eawb/accounting_information.dart';
import 'package:rooster/ui/eawb/awb_consignment_details.dart';
import 'package:rooster/ui/eawb/notify.dart';
import 'package:rooster/ui/eawb/static/custom_background.dart';

class Issuer extends StatefulWidget {
  Issuer({Key key}) : super(key: key);

  @override
  _IssuerState createState() => _IssuerState();
}

class _IssuerState extends State<Issuer> {
  final _issuerFormKey = GlobalKey<FormState>();

  FocusNode _issuerByFocusNode = FocusNode();

  int _issuerByMaxLineCount;

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
              previous: AlsoNotify(),
              next: AccountingInformation(),
              help: Text(""),
              name:
              S.of(context).Issuer,
              //"Issuer",
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _issuerFormKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[issuerBy(model)],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  issuerBy(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        maxLines: _issuerByMaxLineCount,
        initialValue: model.issuerBy,
        focusNode: _issuerByFocusNode,
        textInputAction: TextInputAction.newline,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _issuerByMaxLineCount = _issuerByMaxLineCount + 1;
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: new BorderSide(
                  color: Theme.of(context).accentColor,
                // color: Colors.deepPurple,
                  width:2),
              //gapPadding: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(8.0))
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2,
              color: Theme.of(context).accentColor,
              //color: Colors.deepPurple
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          // border: OutlineInputBorder(
          //     gapPadding: 2.0,
          //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText:
        //  S.of(context).IssuerBy
              "Issued By"+" *",
            labelStyle:
            new TextStyle(
                color: Theme.of(context).accentColor,
              //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon:
            Icon(Icons.contacts_rounded,
              color: Theme.of(context).accentColor,
              //   color: Colors.deepPurple,
            )
          //'Issuer By',
        ),
        onChanged: (text) {
          setState(() {
            model.issuerBy = text;
          });
        },
      ),
    );
  }
}
