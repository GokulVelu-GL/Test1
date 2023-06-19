import 'package:flutter/material.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/fhl_model.dart';

class AddFHLHouse extends StatefulWidget {
  final FHLModel fhlModel;
  final bool isView;

  AddFHLHouse({this.fhlModel, @required this.isView});

  @override
  _AddFHLHouseState createState() => _AddFHLHouseState();
}

class _AddFHLHouseState extends State<AddFHLHouse> {
  GlobalKey _addFHLHousesFormKey = new GlobalKey<FormState>();
  FHLModel _fhlModel;

  @override
  void initState() {
    _fhlModel = widget.fhlModel ?? new FHLModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).AddHouse,
          // "Add House"
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _addFHLHousesFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ! _fhlModel.houseDetails....
                  buildHouseDetails(),

                  Divider(
                    thickness: 2,
                    indent: MediaQuery.of(context).size.width * 0.3,
                    endIndent: MediaQuery.of(context).size.width * 0.3,
                  ),

                  // ! _fhlModel.qualityDetails....
                  buildQuantityDetails(),

                  Divider(
                    thickness: 2,
                    indent: MediaQuery.of(context).size.width * 0.3,
                    endIndent: MediaQuery.of(context).size.width * 0.3,
                  ),

                  // ! Customs Security....
                  buildCustomsSecurity(),

                  Divider(
                    thickness: 2,
                    indent: MediaQuery.of(context).size.width * 0.3,
                    endIndent: MediaQuery.of(context).size.width * 0.3,
                  ),

                  // ! ChargeDeclaration....
                  buildChargeDeclaration(),

                  Divider(
                    thickness: 2,
                    indent: MediaQuery.of(context).size.width * 0.3,
                    endIndent: MediaQuery.of(context).size.width * 0.3,
                  ),

                  // ! Special Requirements....
                  buildSpecialRequirements(),

                  Divider(
                    thickness: 2,
                    indent: MediaQuery.of(context).size.width * 0.3,
                    endIndent: MediaQuery.of(context).size.width * 0.3,
                  ),

                  // ! Shipper....
                  buildShipper(),

                  Divider(
                    thickness: 2,
                    indent: MediaQuery.of(context).size.width * 0.3,
                    endIndent: MediaQuery.of(context).size.width * 0.3,
                  ),

                  // ! Consignee....
                  buildConsignee(),

                  Divider(
                    thickness: 2,
                    indent: MediaQuery.of(context).size.width * 0.3,
                    endIndent: MediaQuery.of(context).size.width * 0.3,
                  ),

                  buildDialogButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDialogButtons(BuildContext context) {
    return !widget.isView
        ? Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 15, right: 8),
                  child: TextButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor)),
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                    child: Text(
                      S.of(context).Discard,
                      // "Discard"
                    ),
                  ),
                ),
                // ! ADD ....
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor)),
                      onPressed: () {
                        Navigator.pop(context, _fhlModel);
                      },
                      child: Text(
                        S.of(context).Add,
                        // "Add"
                      )),
                ),
              ],
            ),
          )
        : Container();
  }

  Widget buildConsignee() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Text(
                S.of(context).Consignee,
                //"Consignee",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
            ),

            // ! consigneeName....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.consigneeName,
                onChanged: (value) {
                  _fhlModel.consigneeName = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).Name,
                  //'Name',
                ),
              ),
            ),

            // ! consigneeAddress...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.consigneeAddress,
                onChanged: (value) {
                  _fhlModel.consigneeAddress = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).StreetAddress,
                  //'Street Address',
                ),
              ),
            ),

            // ! consigneePlace...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.consigneePlace,
                onChanged: (value) {
                  _fhlModel.consigneePlace = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).Place,
                  //'Place',
                ),
              ),
            ),
            // ! consigneeState...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.consigneeState,
                onChanged: (value) {
                  _fhlModel.consigneeState = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).State,
                  //'State',
                ),
              ),
            ),

            // ! consigneeCode, consigneeCode....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Row(
                children: [
                  // ! consigneeCode....
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        enabled: !widget.isView,
                        initialValue: _fhlModel.consigneeCode,
                        onChanged: (value) {
                          _fhlModel.consigneeCode = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              gapPadding: 2.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          labelText:
                          S.of(context).CountryCode,
                          //'Country Code',
                        ),
                      ),
                    ),
                  ),
                  // ! consigneePostCode....
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        enabled: !widget.isView,
                        initialValue: _fhlModel.consigneePostCode,
                        onChanged: (value) {
                          _fhlModel.consigneePostCode = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              gapPadding: 2.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          labelText:
                          S.of(context).PostCode,
                          //'Post Code',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ! consigneeIdentifier...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.consigneeIdentifier,
                onChanged: (value) {
                  _fhlModel.consigneeIdentifier = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).Identifier,
                  //'Identifier',
                ),
              ),
            ),

            // ! consigneeNumber...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.consigneeNumber,
                onChanged: (value) {
                  _fhlModel.consigneeNumber = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).ContactNumber
                  //'Contact Number',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShipper() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Text(
               S.of(context).Shipper,
               // "Shipper",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
            ),

            // ! shipperName....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.shipperName,
                onChanged: (value) {
                  _fhlModel.shipperName = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).Name,
                  //'Name',
                ),
              ),
            ),

            // ! shipperAddress...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.shipperAddress,
                onChanged: (value) {
                  _fhlModel.shipperAddress = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).StreetAddress,
                  //'Street Address',
                ),
              ),
            ),

            // ! shipperPlace...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.shipperPlace,
                onChanged: (value) {
                  _fhlModel.shipperPlace = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).Place
                  //'Place',
                ),
              ),
            ),
            // ! shipperState...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.shipperState,
                onChanged: (value) {
                  _fhlModel.shipperState = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).State,
                  //'State',
                ),
              ),
            ),

            // ! houseDetailsOrigin, houseDetailsDestination....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Row(
                children: [
                  // ! shipperCode....
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        enabled: !widget.isView,
                        initialValue: _fhlModel.shipperCode,
                        onChanged: (value) {
                          _fhlModel.shipperCode = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              gapPadding: 2.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          labelText:
                          S.of(context).CountryCode,
                          //'Country Code',
                        ),
                      ),
                    ),
                  ),
                  // ! shipperPostCode....
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        enabled: !widget.isView,
                        initialValue: _fhlModel.shipperPostCode,
                        onChanged: (value) {
                          _fhlModel.shipperPostCode = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              gapPadding: 2.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          labelText:
                          S.of(context).PostCode,
                          //'Post Code',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ! shipperIdentifier...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.shipperIdentifier,
                onChanged: (value) {
                  _fhlModel.shipperIdentifier = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).Identifier,
                  //'Identifier',
                ),
              ),
            ),

            // ! shipperNumber...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.shipperNumber,
                onChanged: (value) {
                  _fhlModel.shipperNumber = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).ContactNumber,
                  //'Contact Number',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSpecialRequirements() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Text(
                S.of(context).SpecialRequirements,
                //"Special Requirements",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Row(
                children: [
                  // ! specialRequirementSpecialCode....
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        enabled: !widget.isView,
                        initialValue: _fhlModel.specialRequirementSpecialCode,
                        onChanged: (value) {
                          _fhlModel.specialRequirementSpecialCode = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              gapPadding: 2.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          labelText:
                          S.of(context).SpecialCode,
                          //'Special Code',
                        ),
                      ),
                    ),
                  ),
                  // ! specialRequirementHarmonisedCode....
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        enabled: !widget.isView,
                        initialValue:
                            _fhlModel.specialRequirementHarmonisedCode,
                        onChanged: (value) {
                          _fhlModel.specialRequirementHarmonisedCode = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              gapPadding: 2.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          labelText:
                          S.of(context).HarmonisedCode,
                          //'Harmonised Code',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChargeDeclaration() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Text(
                S.of(context).Chargesdeclaration,
                //"Charges Declaration",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
            ),

            // ! chargeDeclarationCurrencyCode....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.chargeDeclarationCurrencyCode,
                onChanged: (value) {
                  _fhlModel.chargeDeclarationCurrencyCode = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).CurrencyCode,
                  //'Currency Code',
                ),
              ),
            ),

            // ! chargeDeclarationWeightValue....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.chargeDeclarationWeightValue,
                onChanged: (value) {
                  _fhlModel.chargeDeclarationWeightValue = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).WeightValue,
                  //'Weight Value',
                ),
              ),
            ),

            // ! chargeDeclarationOtherCharges....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.chargeDeclarationOtherCharges,
                onChanged: (value) {
                  _fhlModel.chargeDeclarationOtherCharges = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).OtherCharges,
                  //'Other Charges',
                ),
              ),
            ),

            // ! chargeDeclarationCarriageValue....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.chargeDeclarationCarriageValue,
                onChanged: (value) {
                  _fhlModel.chargeDeclarationCarriageValue = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).CarriageValue
                  //'Carriage Value',
                ),
              ),
            ),

            // ! chargeDeclarationCustomsValue....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.chargeDeclarationCustomsValue,
                onChanged: (value) {
                  _fhlModel.chargeDeclarationCustomsValue = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).CustomsValue,
                  //'Customs Value',
                ),
              ),
            ),

            // ! chargeDeclarationInsuranceValue....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.chargeDeclarationInsuranceValue,
                onChanged: (value) {
                  _fhlModel.chargeDeclarationInsuranceValue = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).InsuranceValue,
                  //'Insurance Value',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomsSecurity() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Text(
                S.of(context).CustomsSecurity,
                //"Customs Security",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
            ),

            // ! customsSecurityCountryCode....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.customsSecurityCountryCode,
                onChanged: (value) {
                  _fhlModel.customsSecurityCountryCode = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).CountryCode,
                  //'Country Code',
                ),
              ),
            ),

            // ! customsSecurityInfoIdentifier....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.customsSecurityInfoIdentifier,
                onChanged: (value) {
                  _fhlModel.customsSecurityInfoIdentifier = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).InfoIdentifier,
                  //'Info Identifier',
                ),
              ),
            ),

            // ! customsSecurityCSRCIdentifier....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.customsSecurityCSRCIdentifier,
                onChanged: (value) {
                  _fhlModel.customsSecurityCSRCIdentifier = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).CSRCIdentifier,
                  //'CSRC Identifier',
                ),
              ),
            ),

            // ! customsSecuritySCSRCIdentifier....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.customsSecuritySCSRCIdentifier,
                onChanged: (value) {
                  _fhlModel.customsSecuritySCSRCIdentifier = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).SCSRCIdentifier,
                  //'SCSRC Identifier',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuantityDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Text(
               S.of(context).QuantityDetails,
               // "Quantity Details",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
            ),

            // ! _fhlModel.quantityDetailsPieces....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.quantityDetailsPieces,
                onChanged: (value) {
                  _fhlModel.quantityDetailsPieces = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).Place,
                  //'Pieces',
                ),
              ),
            ),

            // ! houseDetailsOrigin, houseDetailsDestination....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Row(
                children: [
                  // ! _fhlModel.quantityDetailsWeight....
                  Expanded(
                    child: TextFormField(
                      enabled: !widget.isView,
                      initialValue: _fhlModel.quantityDetailsWeight,
                      onChanged: (value) {
                        _fhlModel.quantityDetailsWeight = value;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            gapPadding: 2.0,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        labelText:
                        S.of(context).Weight,
                        //'Weight',
                      ),
                    ),
                    flex: 7,
                  ),
                  // ! houseDetailsDestination....
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: !widget.isView
                          ? DropdownButton<String>(
                              icon: Icon(Icons.arrow_drop_down),
                              value: _fhlModel.quantityDetailsWeightUnit,
                              items: [
                                'K',
                                'L'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String text) {
                                setState(() {
                                  _fhlModel.quantityDetailsWeightUnit = text;
                                });
                              })
                          : Text(_fhlModel.quantityDetailsWeightUnit),
                    ),
                    flex: 3,
                  ),
                ],
              ),
            ),

            // ! houseDetailsDescription...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.quantityDetailsSLAC,
                onChanged: (value) {
                  _fhlModel.quantityDetailsSLAC = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).SLAC,
                 // 'SLAC',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHouseDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Text(

               S.of(context).HouseDetails,
               // "House Details",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
            ),

            // ! houseDetailsNumber....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.houseDetailsNumber,
                onChanged: (value) {
                  _fhlModel.houseDetailsNumber = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).HouseNumber,
                  //'House Number',
                ),
              ),
            ),

            // ! houseDetailsOrigin, houseDetailsDestination....
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: Row(
                children: [
                  // ! houseDetailsOrigin....
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        enabled: !widget.isView,
                        initialValue: _fhlModel.houseDetailsOrigin,
                        onChanged: (value) {
                          _fhlModel.houseDetailsOrigin = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              gapPadding: 2.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          labelText:
                          S.of(context).Origin,
                          //'Origin',
                        ),
                      ),
                    ),
                  ),
                  // ! houseDetailsDestination....
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        enabled: !widget.isView,
                        initialValue: _fhlModel.houseDetailsDestination,
                        onChanged: (value) {
                          _fhlModel.houseDetailsDestination = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              gapPadding: 2.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          labelText:
                          S.of(context).Destination,
                          //'Destination',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ! houseDetailsDescription...
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 15.0),
              child: TextFormField(
                enabled: !widget.isView,
                initialValue: _fhlModel.houseDetailsDescription,
                onChanged: (value) {
                  _fhlModel.houseDetailsDescription = value;
                },
                maxLines: 8,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      gapPadding: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  labelText:
                  S.of(context).Description,
                  //'Description',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
