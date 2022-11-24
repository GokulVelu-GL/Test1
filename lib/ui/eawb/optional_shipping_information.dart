import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rooster/formatter.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/ui/eawb/accounting_information.dart';
import 'package:rooster/ui/eawb/charges_declaration.dart';
import 'package:rooster/ui/eawb/static/custom_background.dart';

class OptionalShippingInformation extends StatefulWidget {
  OptionalShippingInformation({
    Key key,
  }) : super(key: key);

  @override
  _OptionalShippingInformationState createState() =>
      _OptionalShippingInformationState();
}

class _OptionalShippingInformationState
    extends State<OptionalShippingInformation> {
  final _optionalShippingInformationFormKey = GlobalKey<FormState>();

  FocusNode _optionalShippingInformationRef1FocusNode = FocusNode();
  FocusNode _optionalShippingInformationRef2FocusNode = FocusNode();
  FocusNode _optionalShippingInformationRef3FocusNode = FocusNode();

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
              previous: AccountingInformation(),
              next: ChargesDeclaration(),
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
                                      leading: Icon(Icons.contact_page,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Reference 1"),
                                      subtitle: Text("A reference used to identify a specific booking or file\nExample: 12"),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.perm_device_information,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Information"),
                                      subtitle: Text("Remarks relating to a shipment\nExample: MUST BE SAFE"),
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
              name:
              S.of(context).OptionalShippingInformation,
              //"Optional Shipping Information",
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Form(
                    key: _optionalShippingInformationFormKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          ref1(model),
                          ref2(model),
                          //ref3(model),
                        ],
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

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  ref1(EAWBModel model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.refNo1,
        focusNode: _optionalShippingInformationRef1FocusNode,
        textInputAction: TextInputAction.next,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _optionalShippingInformationRef1FocusNode,
              _optionalShippingInformationRef2FocusNode);
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
                // color: Colors.deepPurple
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          // border: OutlineInputBorder(
          //     gapPadding: 2.0,
          //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
          labelText:
          S.of(context).Reference1,
            labelStyle:
            new TextStyle(
                color: Theme.of(context).accentColor,
              //  color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(Icons.contact_page ,
              color: Theme.of(context).accentColor,
              //   color: Colors.deepPurple,
            )
          //'Reference 1',
        ),
        onChanged: (text) {
          setState(() {
            model.refNo1 = text;
          });
        },
      ),
    );
  }

  ref2(EAWBModel model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.refNo2,
        focusNode: _optionalShippingInformationRef2FocusNode,
        textInputAction: TextInputAction.next,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _optionalShippingInformationRef2FocusNode,
              _optionalShippingInformationRef3FocusNode);
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: new BorderSide(
                  color: Theme.of(context).accentColor
                //color: Colors.deepPurple
                  ,width:2),
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
          S.of(context).Information,
            labelStyle:
            new TextStyle(
                color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
                fontSize: 16.0),
            suffixIcon: Icon(Icons.perm_device_information,
              color: Theme.of(context).accentColor,
              //  color: Colors.deepPurple,
            )
          //'Information',
        ),
        onChanged: (text) {
          setState(() {
            model.refNo2 = text;
          });
        },
      ),
    );
  }

  // ref3(EAWBModel model) {
  //   return Container(
  //     margin: EdgeInsets.all(10.0),
  //     child: TextFormField(
  //       initialValue: model.refNo3,
  //       focusNode: _optionalShippingInformationRef3FocusNode,
  //       textInputAction: TextInputAction.done,
  //       inputFormatters: [AllCapitalCase()],
  //       onFieldSubmitted: (value) {
  //         _optionalShippingInformationRef3FocusNode.unfocus();
  //       },
  //       decoration: InputDecoration(
  //         border: OutlineInputBorder(
  //             gapPadding: 2.0,
  //             borderRadius: BorderRadius.all(Radius.circular(8.0))),
  //         labelText: 'Reference 3',
  //       ),
  //       onChanged: (text) {
  //         setState(() {
  //           model.refNo3 = text;
  //         });
  //       },
  //     ),
  //   );
  // }
}
