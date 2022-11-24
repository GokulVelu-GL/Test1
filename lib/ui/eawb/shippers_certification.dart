import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rooster/formatter.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/ui/eawb/carriers_execution.dart';
import 'package:rooster/ui/eawb/signature/signature.dart';
import 'package:rooster/ui/eawb/static/custom_background.dart';
import 'package:rooster/ui/eawb/other_charges.dart';

class ShippersCertification extends StatefulWidget {
  ShippersCertification({Key key}) : super(key: key);

  @override
  _ShippersCertificationState createState() => _ShippersCertificationState();
}

class _ShippersCertificationState extends State<ShippersCertification> {
  final _shippersCertificationFormKey = GlobalKey<FormState>();

  FocusNode _shipperParticularsFocusNode = FocusNode();
  FocusNode _signatureOfShipperFocusNode = FocusNode();

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
              name:
              S.of(context).Shipperscertification,
              //"Shippers Certification",
              next: CarriersExecution(),
              previous: OtherCharges(),
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
                                      leading: Icon(Icons.contacts_rounded,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Name"),
                                      subtitle: Text("Identification of individual or company involved in the movement of a consignment\nExample: K WILSON "),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: Icon(Icons.note_alt,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text("Signature"),
                                      subtitle: Text("Name of signatory \nExample: K. WILSON"),
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
                      key: _shippersCertificationFormKey,
                      child: SingleChildScrollView(
                          child: Column(
                        children: <Widget>[

                          Text(
                            S.of(context).ShippercertifiesthattheparticularsonthefacehereofarecorrectandthatinsofarasanypartoftheconsignmentcontainsdangerousgoodssuchpartisproperlydescribedbynameandisinproperconditionforcarriagebyairaccordingtotheapplicableDangerousGoodsRegulations,
                            // "Shipper certifies that the particulars on the face hereof are correct and that insofar as any part of the consignment contains dangerous goods, such part is properly described by name and is in proper condition for carriage by air according to the applicable Dangerous Goods Regulations.",
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              // color: Colors.deepPurple,
                              fontWeight: FontWeight.w400,
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          shipperParticulars(model),
                          signatureOfShipper(model),
                          TextButton(
                              onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Signature()));
                          }, child: Text("Signature"))
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

  shipperParticulars(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.particularsOfShipper,
        focusNode: _shipperParticularsFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _shipperParticularsFocusNode,
              _signatureOfShipperFocusNode);
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
          S.of(context).Name+" *",
          //"Name",
          labelStyle:
          new TextStyle(
              color: Theme.of(context).accentColor,
            //color: Colors.deepPurple,
              fontSize: 16.0),
            suffixIcon: Icon(Icons.contacts,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
        ),
        onChanged: (text) {
          model.particularsOfShipper = text;
        },
      ),
    );
  }

  signatureOfShipper(model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: model.signatureOfShipper,
        focusNode: _signatureOfShipperFocusNode,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        inputFormatters: [AllCapitalCase()],
        onFieldSubmitted: (value) {
          _signatureOfShipperFocusNode.unfocus();
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: new BorderSide(
                  color: Theme.of(context).accentColor,
                //color: Colors.deepPurple,
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
          S.of(context).SignatureofShipperorhisAgent,
          labelStyle:
          new TextStyle(
              color: Theme.of(context).accentColor,
            //color: Colors.deepPurple,
              fontSize: 16.0),
            suffixIcon: Icon(Icons.note_alt,
              color: Theme.of(context).accentColor,
              // color: Colors.deepPurple,
            )
          //'Signature of Shipper or his Agent',
        ),
        onChanged: (text) {
          model.signatureOfShipper = text;
        },
      ),
    );
  }
}
