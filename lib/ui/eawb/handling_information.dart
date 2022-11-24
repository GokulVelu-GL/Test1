import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rooster/formatter.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/ui/eawb/charges_declaration.dart';
import 'package:rooster/ui/eawb/static/custom_background.dart';
import 'package:rooster/ui/eawb/rate_description.dart';

class HandlingInformation extends StatefulWidget {
  HandlingInformation({Key key}) : super(key: key);

  @override
  _HandlingInformationState createState() => _HandlingInformationState();
}

class _HandlingInformationState extends State<HandlingInformation> {
  final _handlingInformationFormKey = GlobalKey<FormState>();

  FocusNode _handlingInformationRequirementsFocusNode = FocusNode();
  FocusNode _handlingInformationSCIFocusNode = FocusNode();

  int _maxLinesForRequirements;

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
            child: Container(
              child: CustomBackground(
                  name:
                  S.of(context).Handlinginformation,
                  help: Text(""),
                  //"Handling Information",
                  next: RateDescription(),
                  previous: ChargesDeclaration(),
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _handlingInformationFormKey,
                        child: SingleChildScrollView(
                            child: Column(
                          children: <Widget>[requirements(model), sci(model)],
                        )),
                      ),
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  requirements(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.handlingInformationRequirements,
        focusNode: _handlingInformationRequirementsFocusNode,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          setState(() {
            _maxLinesForRequirements = _maxLinesForRequirements + 1;
          });
        },
        maxLines: _maxLinesForRequirements,
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
                //  color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          // border: OutlineInputBorder(
          //     gapPadding: 2.0,
          //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText:
          S.of(context).Requirements,
            labelStyle:
            new TextStyle(
                color: Theme.of(context).accentColor,
              //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(Icons.perm_device_information_outlined,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
          //'Requirements',
        ),
        onChanged: (text) {
          model.handlingInformationRequirements = text;
        },
      ),
    );
  }

  sci(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.handlingInformationSCI,
        focusNode: _handlingInformationSCIFocusNode,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _handlingInformationSCIFocusNode.unfocus();
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: new BorderSide(
                  color: Theme.of(context).accentColor,
                //  color: Colors.deepPurple,
                  width:2),
              //gapPadding: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(8.0))
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2,
              color: Theme.of(context).accentColor,
              //  color: Colors.deepPurple
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          // border: OutlineInputBorder(
          //     gapPadding: 2.0,
          //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText:
          S.of(context).SCI,
            labelStyle:
            new TextStyle(
                color: Theme.of(context).accentColor,
              //color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(Icons.dashboard_customize,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
          //'SCI',
        ),
        onChanged: (text) {
          model.handlingInformationSCI = text;
        },
      ),
    );
  }
}
