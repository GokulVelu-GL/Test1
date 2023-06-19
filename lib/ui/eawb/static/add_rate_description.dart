import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:rooster/formatter.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/rate_description_items.dart';

import '../../../model/eawb_model.dart';
import '../../drodowns/RateClassCode.dart';

class AddRateDescriptionForm extends StatefulWidget {
  AddRateDescriptionForm(
      {Key key,
      this.pieces,
      this.grossWeight,
      this.grossWeightUnit,
      this.rateClass,
      this.itemNumber,
      this.chargeableWeight,
      this.rateCharge,
      this.total,
      this.volume,
      this.autoCalculations,
      this.natureAndQuantity,
      this.dimensionsList,
      this.text,
      this.piece2})
      : super(key: key);

  // ! Information....
  final int pieces;
  final double grossWeight;
  final String grossWeightUnit;
  final String rateClass;
  final int itemNumber;
  final int chargeableWeight;
  final int rateCharge;
  final int total;
  final int volume;
  final int piece2;
  final String autoCalculations;
  final List<Map<String, dynamic>> dimensionsList;

  // ! Nature and quantity of goods....
  final String natureAndQuantity;


  // ! Extra description....
  final String text;

  @override
  _AddRateDescriptionFormState createState() => _AddRateDescriptionFormState();
}

class _AddRateDescriptionFormState extends State<AddRateDescriptionForm> {
  String previsousntureofgoods;
  MenuItem rateclassdropdown;
  List<MenuItem> item = new List<MenuItem>();
  List<MenuItem> items = [
    MenuItem('M', 'Minimum Charge'),
    MenuItem('N', 'Normal Rate'),
    MenuItem('Q', 'Quantity Rate'),
    MenuItem('B', 'Basic Charge'),
    MenuItem('K', 'Rate per Kilogram'),
    MenuItem('R', 'Class Rate Reduction'),
    MenuItem('S', 'Class Rate Surcharge'),
    MenuItem('U', 'Unit Load Device Basic Charge or Rate'),
    MenuItem('E', 'Unit Load Device Additional Rate'),
    MenuItem('X', 'Unit Load Device Additional Information'),
    MenuItem('Y', 'Unit Load Device Discount'),
    MenuItem('L', 'L'),
    MenuItem('W', 'W'),
  ];
  var totalPieces;
  int tottotPieces=0;
  int totalWeight=0;
  int chargesummrypreweightcharge=0;
  int chargesummrypostweightcharge=0;

  final _addRateDescriptionItemForm = GlobalKey<FormState>();

  int sumofdimpiecesK=0;
  int sumofdimpiecesL=0;
  int sumofdimweightK=0;

  // Information
  int pieces = 0;
  double grossWeight;
  List<String> grossWeightUnitValues = ['K', 'L'];
  String grossWeightUnit;
  List<String> rateClassValues = [
    'M',
    'N',
    'Q',
    'B',
    'K',
    'R',
    'S',
    'U',
    'E',
    'X',
    'Y',
    'L',
    'W'
  ];
  List<String> Autocalc_value = [
    'All fields are entered manually,no auto calculations will happen',
    'Only the total willbe calculated based on the chargeable weight, rate class and rate, if rate class is entered then a simple rate * chargeable weight calculation will be done',
    'The chargeable weight will be calculated as the higher of the gross weight and volumetric weight from the dimensions info And the total will be calculated',
    'Gross weight the number of pieces will be calculated from the weight and pieces information entered in the dimensions And the total will be calculated',
    'Gross weight, number of pieces, chargeable weight total will be calculated'
  ];
  String rateClass;
  int itemNumber;
  int chargeableWeight;
  int rateCharge;
  int total;
  int volume;
  List<String> autoCalculationList = [
    'No',
    'Total',
    'Charg, total',
    'Gross, total',
    'Gross, Charg, total'
  ];
  String unit;
  List<String> unitsList = ['mm', 'cm', 'dm', 'm', 'in', 'ft', 'yd'];
  List<String> RateClassF = <String>[
    'Minimum Charge',
    'Normal Rate',
    'Quantity Rate ',
    'Basic Charge',
    'Rate per Kilogram',
    'Class Rate Reduction',
    'Class Rate Surcharge',
    'Unit Load Device Basic Charge or Rate',
    'Unit Load Device Additional Rate',
    'Unit Load Device Additional Information',
    'Unit Load Device Discount',
    'L',
    'W'
  ];
  String autoCalculations;
  bool readOnly = true;
  bool consolidationvalue = false;
  static const defaultRatecharge = 0;
  static const defaultchargeableWeight = 0;
  static const defaultlength = 0;
  static const defaultheight = 0;
  static const defaultwidth = 0;
  static const defaultpieces = 0;
  static const defaultpiece = 0;
  static const defaultweight = 0;

  // This is the default tip percentage
  static const defaultTipPercentage = 15;

  int weight = defaultweight;
  int piece = defaultpiece;
  int _ChargeWeight = defaultchargeableWeight;
  int _Ratecharge = defaultRatecharge;
  int length = defaultlength;
  int width = defaultwidth;
  int height = defaultheight;
  // int weight = 0;
  // int piece = 0;
  // int _ChargeWeight = 0;
  // int _Ratecharge = 0;
  // int length = 0;
  // int width = 0;
  // int height = 0;

  var _piecesController = TextEditingController(text:
  //pieces.toString()
    defaultpieces.toString()
  );
  final _RatechargeController =
      TextEditingController(text: defaultRatecharge.toString());
  var _totalController = TextEditingController(text: 0.toString());
  var _volumeController = TextEditingController(text: 0.toString());
  var _volumetricController = TextEditingController(text: 0.toString());
  var _grossWeightController = TextEditingController(text: 0.toString());
  var RateClassController = TextEditingController();
  var natureofgoods = TextEditingController();
  var slacController = TextEditingController();
  var _chargeableWeightController =
      TextEditingController(text: defaultchargeableWeight.toString());
  String result = '0';
  String volumetricw = '0';
  String fact = '0';
  List<int> tempLVolume = []; // Pound based value
  List<int> tempKVolume = []; // Kilo based value
  List<int> tempLPieces = []; // Pound based value
  List<int> tempKPieces = [];
  String lwhunit = "cm";
  String slac;

  _piecesChanged() {
    setState(() {
     // pieces = int.tryParse(_piecesController.text);
      pieces = int.tryParse(_piecesController.text);

    });
  }

  _onchargeableWeightChanged() {
    setState(() {
      _ChargeWeight = int.tryParse(_chargeableWeightController.text);
      // _ChargeWeight=widget.chargeableWeight;
    });
  }

  _RatechargeChanged() {
    setState(() {
      _Ratecharge = int.tryParse(_RatechargeController.text);

    });
  }
  NatureofGoodsChanged() {
    setState(() {
      natureAndQuantity = natureofgoods.text;

    });
  }
  SLACChanged() {
    setState(() {
      slac = slacController.text;

    });
  }

  _getvolumegwK(index) {
    if (autoCalculations != 'No') {
      int factor = 6000;
      String unitValue;
      String unit = dimensionsList[index]['lwhUnit'] == null
          ? "cm"
          : dimensionsList[index]['lwhUnit'];
      String fu;
      double inc=1;
      print("Unit $unit");
      int indexPieces = dimensionsList[index]["pieces"] == null
          ? 1
          : dimensionsList[index]["pieces"];
      if (tempKPieces.isEmpty) {
        tempKPieces.insert(index, indexPieces);
        print("$indexPieces");
      } else if (tempKPieces.length - 1 >= index) {
        tempKPieces[index] = indexPieces;
        print("$indexPieces");
      } else {
        tempKPieces.insert(index, indexPieces);
        print("$indexPieces");
      }

      print("$tempKPieces");

       totalPieces = 0;

      tempKPieces.forEach((element) => totalPieces += element);
      print("$totalPieces");
      if (totalPieces == 0) {
        totalPieces = 1;
      }

      String unitDived;
      if (unit == "cm") {
        unitValue = "1";
        inc=1;
        fu = " cm3/kg";
        unit = "cm3";
      } else if (unit == "mm") {
        unitDived = unit;
        inc=1;
        unitValue = "1000";
        fu = " cm3/kg";
        unit = "cm3";
      } else if (unit == "dm") {
        unitValue = "1000";
        inc=1;
        fu = " cm3/kg";
        unit = "cm3";
      } else if (unit == "yd") {
       // in to yd
        //36 inch = 1 yard 36 * 36 * 36 = 46656
        unitValue = "46656";
        inc=16.387064;
        fu = " cm3/kg";
        unit = "in3";
      } else if (unit == "m") {

        unitValue = "1000000";
        fu = " cm3/kg";
        inc=1;
        unit = "cm3";
      } else if (unit == "ft") {
        // u= "28316.8466";
        //  12 in = 1 feet
        // 12 * 12 * 12 = 1728
        unitValue = "1728";
        fu = " cm3/kg";
        inc=16.387064;
        unit = "in3";
      } else if (unit == "in") {
        unitValue = "1";
        factor = 366;
        inc=1;
        fu = " in3/kg";
        unit = "in3";
      }
      // if (unit == "in") {
      //   fu = " in3/kg";
      // } else {
      //   //factor unit
      //   fu = " cm3/kg";
      // }

      dynamic volume;
      if (unitDived == "mm") {
        double unitVolume = ((dimensionsList[index]["length"] *
                    dimensionsList[index]["width"] *
                    dimensionsList[index]["height"]) *
                (indexPieces)) /
            int.parse(unitValue.toString());
        print("MM Volume: $volume");
        volume = unitVolume.ceil();
      } else {
        print("Volume: $unit");
        volume = (dimensionsList[index]["length"] *
                dimensionsList[index]["width"] *
                dimensionsList[index]["height"]) *
            (indexPieces * int.parse(unitValue.toString()));
      }

      //int tempListLength = tempKVolume.isEmpty ? 0 : tempKVolume.length;
      if (tempKVolume.isEmpty) {
        tempKVolume.insert(index, volume);
        print("$volume");
      } else if (tempKVolume.length - 1 >= index) {
        tempKVolume[index] = volume;
        print("$volume");
      } else {
        tempKVolume.insert(index, volume);
        print("$volume");
      }

      print("$volume");
      print("$tempKVolume");
      print("$index");
      //tempKVolume.
      var sum = 0;
      tempKVolume.forEach((element) => sum += element);
      print("$sum");
      // double incc = volume / inc;
      // print('$inc');
      //
      // double volumetric_weight = incc / factor;
      // print('$volumetric_weight');
      double volumetric_weight = sum / factor * inc;
      fact = factor.toString() + fu;

      volumetricw = volumetric_weight.toStringAsFixed(2);
      if (volumetric_weight < 0.5) {
        volumetricw = 0.5.toString();
      } else
        volumetricw = volumetric_weight.toStringAsFixed(2);

      //int pieces = piece;
      // int pi;
      // if (piece == 1) {
      //   pi = index + 1;
      // } else if (piece > 1) {
      //   pi = piece;
      // }

      int dimenPieces = 0;

      if (totalPieces > pieces) {
        dimenPieces = totalPieces;
      } else {}

      setState(() {
        _volumeController = TextEditingController(
            text: sum.toString() +
                " " +
                unit.toString() +
                " ( " +
                dimenPieces.toString() +
                " " +
                "pieces )");
        _volumetricController =
            TextEditingController(text: volumetricw + " kg");
        if (pieces == 0) {
          _piecesController =
              TextEditingController(text: dimenPieces.toString());
        }
        grossWeight = double.parse(volumetricw);
        if (volumetric_weight > _ChargeWeight) {
          _chargeableWeightController = TextEditingController(
              text: double.parse(volumetricw).ceil().toString());
          _grossWeightController =
              TextEditingController(text: grossWeight.ceil().toString());
        }
      });
    }
  }
  _getvolumegwL(index) {
    if (autoCalculations != 'No') {
      int factor = 166;
      String u;
      String unit = dimensionsList[index]['lwhUnit'] == null
          ? "cm"
          : dimensionsList[index]['lwhUnit'];
      String fu;
      double inc = 16.38;
      print("Unit $unit");

      // To select unit value based on user selected unit

      int indexPieces = dimensionsList[index]["pieces"] == null
          ? 1
          : dimensionsList[index]["pieces"];
      if (tempLPieces.isEmpty) {
        tempLPieces.insert(index, indexPieces);
        print("$indexPieces");
      } else if (tempLPieces.length - 1 >= index) {
        tempLPieces[index] = indexPieces;
        print("$indexPieces");
      } else {
        tempLPieces.insert(index, indexPieces);
        print("$indexPieces");
      }

      print("$tempLPieces");

       totalPieces = 0;
      tempLPieces.forEach((element) => totalPieces += element);
      print("$totalPieces");
      if (totalPieces == 0) {
        totalPieces = 1;
      }
      String unitDived;
      if (unit == "cm") {
        u = "1";
        unit = "cm3";
        inc = 16.38;
      } else if (unit == "mm") {
        unitDived = unit;
        u = "1000";
        unit = "cm3";
        inc = 16.38;
      } else if (unit == "dm") {
        u = "1000";
        inc = 16.38;
        unit = "cm3";
      } else if (unit == "yd") {
        u = "46656";
        unit = "in3";
        inc = 1;
      } else if (unit == "m") {
        u = "1000000";
        unit = "cm3";
        inc = 16.38;
      } else if (unit == "ft") {
        // u= "28316.8466";
        u = "1728";
        inc = 1;
        unit = "in3";
      } else if (unit == "in") {
        u = "1";
        inc = 1;
        fu = 'in3/lb';
        // factor= 366;
        unit = "in3";
      }

      fu = 'in3/lb';

      dynamic volume;
      if (unitDived == "mm") {
        double unitVolume = ((dimensionsList[index]["length"] *
            dimensionsList[index]["width"] *
            dimensionsList[index]["height"]) *
            (indexPieces)) /
            int.parse(u.toString());
        print("MM Volume: $volume");
        volume = unitVolume.ceil();
      } else {
        print("Volume: $unit");
        volume = (dimensionsList[index]["length"] *
            dimensionsList[index]["width"] *
            dimensionsList[index]["height"]) *
            (indexPieces * int.parse(u.toString()));
      }
      if (tempLVolume.isEmpty) {
        tempLVolume.insert(index, volume);
        print("$volume");
      } else if (tempLVolume.length - 1 >= index) {
        tempLVolume[index] = volume;
        print("$volume");
      } else {
        tempLVolume.insert(index, volume);
        print("$volume");
      }

      print("$volume");
      print("temp value");
      print("$tempLVolume");
      print("$index");


      var sum = 0;
      tempLVolume.forEach((element) => sum += element);
      print("temo sum ");

      print("$sum");

      double incc = sum / inc;
      print('$inc');

      double volumetric_weight = incc / factor;
      fact = factor.toString() + " " + fu;

      volumetricw = volumetric_weight.toStringAsFixed(2);
      if (volumetric_weight < 1) {
        volumetricw = 1.toString();
      } else
        volumetricw = volumetric_weight.toStringAsFixed(2);
      int pices = piece;
      // int pi;
      // if (piece == 1) {
      //   pi = index + 1;
      // } else if (piece > 1) {
      //   pi = piece;
      // }
      int dimenPieces = 0;

      if (totalPieces > pieces) {
        dimenPieces = totalPieces;
      } else {}

      setState(() {
        _volumeController = TextEditingController(
            text: sum.toString() +
                " " +
                unit.toString() +
                "( " +
                dimenPieces
                    .toString() +
                "pieces )");
        _volumetricController = TextEditingController(text: volumetricw + "lb");
        if (pieces == 0) {
          _piecesController = TextEditingController(text: dimenPieces.toString());
        }
        grossWeight = double.parse(volumetricw);
        if (volumetric_weight > _ChargeWeight) {
          _chargeableWeightController = TextEditingController(
              text: double.parse(volumetricw).ceil().toString());
          _grossWeightController =
              TextEditingController(text: grossWeight.ceil().toString());
        }
      });
    }
  }


  _calculateGrossWeight(int weight) {
    if (autoCalculations == "Gross, total") {
      if (weight > grossWeight) {
        _grossWeightController = TextEditingController(text: weight.toString());
        _chargeableWeightController =
            TextEditingController(text: "0".toString());
        // total= _Ratecharge;
      }
    } else if (autoCalculations == "Gross, Charg, total") {
      if (weight > grossWeight) {
        _grossWeightController = TextEditingController(text: weight.toString());
        _chargeableWeightController =
            TextEditingController(text: weight.toString());
        // total= _Ratecharge;
      }
    } else if (autoCalculations == "Charg, total") {
      if (weight > _ChargeWeight) {
        _chargeableWeightController =
            TextEditingController(text: weight.toString());
        _grossWeightController = TextEditingController(text: "0".toString());
        // total= _Ratecharge;
      }
    }
  }

  _totalkq() {
    setState(() {
      print(chargeableWeight);
      total = chargeableWeight * _Ratecharge;
      _totalController = TextEditingController(text: total.toString());
      print("Total Controller " + '$_totalController');
      _totalController = readOnly as TextEditingController;
    });
  }

  _getTotalyw() {
    setState(() {
      // if(rateClass =="Charg, total"){
      //   _ChargeWeight = grossWeight as int;
      // }
      //total = _ChargeWeight * _Ratecharge;
      // _chargeableWeightController=TextEditingController(text: grossWeight.ceil().toString());

      _totalController = TextEditingController(text: " ");
      print("Total Controller " + '$_totalController');
      _totalController = readOnly as TextEditingController;
    });
  }

  _getTotals() {
    setState(() {
      // total= _Ratecharge;
      _totalController = TextEditingController(text:
     // _Ratecharge
          rateCharge.toString());
      print("Total Controller " + '$_totalController');
      _totalController = readOnly as TextEditingController;
    });
  }

  @override
  void dispose() {
    _RatechargeController.dispose();
    _chargeableWeightController.dispose();
    _piecesController.dispose();
    _grossWeightController.dispose();
    super.dispose();
  }

  FocusNode piecesFocusNode = FocusNode();
  FocusNode grossWeightFocusNode = FocusNode();
  FocusNode itemNumberFocusNode = FocusNode();
  FocusNode chargeableWeightFocusNode = FocusNode();
  FocusNode rateChargeFocusNode = FocusNode();
  FocusNode totalFocusNode = FocusNode();


  // Nature and quantity of goods
  String natureAndQuantity;
  FocusNode natureAndQuantityFocusNode = FocusNode();
  List<Map<String, dynamic>> dimensionsList;

  // Extra description
  String text;
  FocusNode textFocusNode = FocusNode();

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  onSortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        dimensionsList.sort((a, b) => a['length'].compareTo(b['length']));
      } else {
        dimensionsList.sort((a, b) => b['length'].compareTo(a['length']));
      }
    }
  }

  newDataRow(int dimensionIndex) {
    return DataRow(
        key: ValueKey(dimensionsList[dimensionIndex]),
        // ! Very Important key for Delete the value....
        selected: dimensionsList[dimensionIndex]['isSelected'],
        onSelectChanged: (value) {
          setState(() {
            dimensionsList[dimensionIndex]['isSelected'] =
                !dimensionsList[dimensionIndex]['isSelected'];
          });
        },
        cells: [
          DataCell(
            TextFormField(
              initialValue: dimensionsList[dimensionIndex]['length'] == 0.0
                  ? ''
                  : '${dimensionsList[dimensionIndex]['length']}',
              onChanged: (value) {
                setState(() {
                  dimensionsList[dimensionIndex]['length'] = int.parse(value);
                  length = int.parse(value);
                });
              },
              keyboardType: TextInputType.number,
            ),
            // onLongPress: () {
            //   setState(() {
            //     dimensionsList[dimensionIndex]['isSelected'] =
            //         !dimensionsList[dimensionIndex]['isSelected'];
            //   });
            // },
          ), // DataColumn(label: Text('Length')),
          DataCell(
            TextFormField(
              initialValue: dimensionsList[dimensionIndex]['width'] == 0.0
                  ? ''
                  : '${dimensionsList[dimensionIndex]['width']}',
              onChanged: (value) {
                setState(() {
                  dimensionsList[dimensionIndex]['width'] = int.parse(value);
                  width = int.parse(value);
                });
              },
              keyboardType: TextInputType.number,
            ),
          ), // DataColumn(label: Text('Width')),

          DataCell(
            TextFormField(
              initialValue: dimensionsList[dimensionIndex]['height'] == 0.0
                  ? ''
                  : '${dimensionsList[dimensionIndex]['height']}',
              onChanged: (value) {
                setState(() {
                  dimensionsList[dimensionIndex]['height'] = int.parse(value);
                  height = int.parse(value);
                  if (grossWeightUnit == "L") {
                    _getvolumegwL(dimensionIndex);
                  } else {
                    print("height dimention");

                    _getvolumegwK(dimensionIndex);
                  }
                  //_getvolume(dimensionIndex);
                });
              },
              keyboardType: TextInputType.number,
            ),
          ), // DataColumn(label: Text('Height')),

          DataCell(
            DropdownButton<String>(
                icon: Icon(Icons.arrow_drop_down),
                value:
                    dimensionsList[dimensionIndex]['lwhUnit'] ?? unitsList[1],
                items: unitsList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String text) {
                  setState(() {
                    dimensionsList[dimensionIndex]['lwhUnit'] = text;
                    lwhunit = text;
                    if (grossWeightUnit == "L") {
                      _getvolumegwL(dimensionIndex);
                    } else
                      _getvolumegwK(dimensionIndex);
                  });
                }),
          ), // DataColumn(label: Text('Unit')),

          DataCell(
            TextFormField(
              initialValue: dimensionsList[dimensionIndex]['pieces'] == null
                  ? ''
                  : '${dimensionsList[dimensionIndex]['pieces']}',
              // controller: num3,
              //controller: _piecesController,
              // initialValue: dimensionsList[dimensionIndex]['pieces'] == 0.0
              //     ? ''
              //     : '${dimensionsList[dimensionIndex]['pieces']}',
              onChanged: (value) {
                setState(() {
                  dimensionsList[dimensionIndex]['pieces'] =
                      value == '' ? 1 : int.parse(value);
                  piece = value == '' ? 1 : int.parse(value);
                  if (grossWeightUnit == "K") {
                    sumofdimpiecesK+=dimensionsList[dimensionIndex]['pieces'];
                    _getvolumegwK(dimensionIndex);
                  } else if (grossWeightUnit == "L") {
                    sumofdimpiecesL+=dimensionsList[dimensionIndex]['pieces'];
                    _getvolumegwL(dimensionIndex);
                  }
                  // _getvolume(dimensionIndex);
                });
              },
              keyboardType: TextInputType.number,
            ),
          ), // DataColumn(label: Text('Pieces')),

          DataCell(
            TextFormField(
              initialValue: dimensionsList[dimensionIndex]['weight'] == null
                  ? ''
                  : '${dimensionsList[dimensionIndex]['weight']}',
              onChanged: (value) {
                setState(() {
                  dimensionsList[dimensionIndex]['weight'] = int.parse(value);
                  weight = int.parse(value);
                  _calculateGrossWeight(weight);
                });
              },
              keyboardType: TextInputType.number,
            ),
          ), // DataColumn(label: Text('Weight')),

          DataCell(
            DropdownButton<String>(
                icon: Icon(Icons.arrow_drop_down),
                value: dimensionsList[dimensionIndex]['pwUnit'] ?? 'K',
                items: ['K', 'L'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String text) {
                  setState(() {
                    int ttalWeight=0;
                    int totpic=0;
                    for(int i = 0; i <dimensionsList.length; i++){
                      totpic+= dimensionsList[i]["pieces"];
                      ttalWeight+= (dimensionsList[i]["pieces"] * dimensionsList[i]["weight"]);
                    }
                    totalWeight=ttalWeight;
                    tottotPieces= totpic;

                    print("total weight"+totalWeight.toString());
                    dimensionsList[dimensionIndex]['pwUnit'] = text;
                  });
                }),
          ), // DataColumn(label: Text('Unit')),
          // DataCell(Checkbox(
          //   value: dimensionsList[dimensionIndex]['isSelected'],
          //   onChanged: (value) {
          //     setState(() {
          //       dimensionsList[dimensionIndex]['isSelected'] =
          //           !dimensionsList[dimensionIndex]['isSelected'];
          //     });
          //   },
          // )),
        ]);
  }
  String rateclassdescription="";

  @override
  void initState() {
    // ! Information....
    // pieces = widget.pieces ?? 0;
    // grossWeight = widget.grossWeight ?? 0;
    // grossWeightUnit = widget.grossWeightUnit ?? 'K';
    // rateClass = widget.rateClass ?? 'M';
     itemNumber = widget.itemNumber ?? 0;
    // chargeableWeight = widget.chargeableWeight ?? 0;
    rateCharge = widget.rateCharge ?? 0;
    total = widget.total ?? 0;
    volume = widget.volume ?? 0;
    autoCalculations = widget.autoCalculations ?? 'No';

    // ! Nature and quantity of goods....
    natureAndQuantity = widget.natureAndQuantity ?? '';
    dimensionsList = widget.dimensionsList ?? new List<Map<String, dynamic>>();
    _chargeableWeightController.addListener(_onchargeableWeightChanged);
    _RatechargeController.addListener(_RatechargeChanged);
    _piecesController.addListener(_piecesChanged);
    natureofgoods.addListener(NatureofGoodsChanged);
    slacController.addListener(SLACChanged);
    // ! Extra description....
    text = widget.text ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.RateClassController.text=rateClass;
    return Consumer<EAWBModel>(
        builder: (context, model, child) => WillPopScope(
          onWillPop: () async {
            model.setStatus();
            return true;
            },
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: Text(
           // S.of(context).AddItem,
              "Add Commodity"
                  //" Rate Description"
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _addRateDescriptionItemForm,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, bottom: 15.0),
                              child: Text(
                                S.of(context).Information,
                                // "Information",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  // color: Colors.deepPurple,
                                  //decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),

                            // ! pieces....
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, bottom: 15.0),
                              child: TextFormField(
                                enableInteractiveSelection: false,
                                enabled:(autoCalculations=="Gross, total"||autoCalculations=="Gross, Charg, total")?false:true,

                                controller: _piecesController,
                                focusNode: piecesFocusNode,
                                // enabled: true, //Not clickable and not editable
                                //readOnly: ,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {
                                  _fieldFocusChange(context, piecesFocusNode,
                                      grossWeightFocusNode);
                                },
                                // initialValue:
                                // pieces == 0 ? "" : pieces.toString(),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  // _piecesController.text= value;
                                  pieces = int.parse(value);
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: (autoCalculations=="Gross, total"||autoCalculations=="Gross, Charg, total")?
                                  Theme.of(context).accentColor.withOpacity(0.2):Theme.of(context).backgroundColor,
                                  isDense: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Theme.of(context).accentColor,
                                        //color: Colors.deepPurple,
                                          width: 2
                                      ),
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
                                  //     borderRadius: BorderRadius.all(
                                  //         Radius.circular(8.0))),
                                  labelText: S.of(context).Pieces+" *",
                                  labelStyle: new TextStyle(
                                      color: Theme.of(context).accentColor,
                                    //color: Colors.deepPurple,
                                      fontSize: 16.0
                                  ),
                                  //'Pieces',
                                ),
                              ),
                            ),

                            // ! grossWeight & grossWeightUnit....
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, bottom: 15.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: TextFormField(
                                      enabled:(autoCalculations=="Gross, total"||autoCalculations=="Gross, Charg, total")?false:true,
                                      controller: _grossWeightController,
                                      focusNode: grossWeightFocusNode,
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (value) {
                                        grossWeightFocusNode.unfocus();
                                      },
                                      // initialValue: grossWeight == 0
                                      //     ? ""
                                      //     : grossWeight.toString(),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: (autoCalculations=="Gross, total"||autoCalculations=="Gross, Charg, total")?
                                        Theme.of(context).accentColor.withOpacity(0.2):Theme.of(context).backgroundColor,
                                        isDense: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Theme.of(context).accentColor,
                                              // color: Colors.deepPurple,
                                                width: 2),
                                            //gapPadding: 2.0,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                            color: Theme.of(context).accentColor,
                                            // color: Colors.deepPurple
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        // border: OutlineInputBorder(
                                        //     gapPadding: 2.0,
                                        //     borderRadius: BorderRadius.all(
                                        //         Radius.circular(8.0))),
                                        labelText: S.of(context).GrossWeight+" *",
                                        labelStyle: new TextStyle(
                                            color: Theme.of(context).accentColor,
                                          //color: Colors.deepPurple,
                                            fontSize: 16.0),
                                        //'Gross Weight',
                                      ),
                                      onChanged: (value) {
                                        grossWeight = double.parse(value);
                                        // _grossWeightController.text=value;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: DropdownButton<String>(
                                        isDense: true,
                                        icon: Icon(Icons.arrow_drop_down),
                                        value: grossWeightUnit,
                                        items: grossWeightUnitValues
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (String text) {
                                          setState(() {
                                            grossWeightUnit = text;
                                          });
                                        }),
                                  ),
                                ],
                              ),
                            ),

                            // ! rateClass....
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 15),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //     children: <Widget>[
                            //       Text(
                            //           S.of(context).Rateclass+" *"
                            //           //"Rate Class"
                            //           ,
                            //           style: TextStyle(
                            //               color: Theme.of(context).accentColor,
                            //             // color: Colors.deepPurple,
                            //               fontSize: 17.0)),
                            //       // Container(
                            //       //   color: Theme.of(context).accentColor.withOpacity(0.3),
                            //       //   padding: EdgeInsets.only(left: 10),
                            //       //   child: DropdownButton<String>(
                            //       //       isDense: true,
                            //       //       icon: Icon(Icons.arrow_drop_down),
                            //       //       value: rateClass,
                            //       //       items: rateClassValues
                            //       //           .map<DropdownMenuItem<String>>(
                            //       //               (String value) {
                            //       //         return DropdownMenuItem<String>(
                            //       //           value: value,
                            //       //           child: Text(value.toString()),
                            //       //         );
                            //       //       }).toList(),
                            //       //       onChanged: (String text) {
                            //       //         setState(() {
                            //       //           rateClass = text;
                            //       //         });
                            //       //       }),
                            //       // ),
                            //       TextButton(
                            //         onPressed: () => showDialog<String>(
                            //           context: context,
                            //           builder: (BuildContext context) =>
                            //               AlertDialog(
                            //             title: Center(
                            //               child:  Text(
                            //
                            //                 S.of(context).Rateclass,
                            //                 //'Rate Class',
                            //                 style: TextStyle(
                            //                   color: Theme.of(context).accentColor,
                            //                   //color: Colors.black
                            //                 ),
                            //               ),
                            //             ),
                            //             content: Container(
                            //                 height: 200,
                            //                 width: 300,
                            //                 child: Scrollbar(
                            //                   child: ListView.builder(
                            //                     shrinkWrap: true,
                            //                     itemCount: RateClassF.length,
                            //                     itemBuilder:
                            //                         (BuildContext context,
                            //                             int index) {
                            //                       return Card(
                            //                           shape:
                            //                               new RoundedRectangleBorder(
                            //                                   side: new BorderSide(
                            //                                       color: Colors
                            //                                           .grey,
                            //                                       width: 2.0),
                            //                                   borderRadius:
                            //                                       BorderRadius
                            //                                           .circular(
                            //                                               4.0)),
                            //                           child: ListTile(
                            //                             title: Text(
                            //                               '${rateClassValues[index]}',
                            //                               style: TextStyle(
                            //                                 color: Theme.of(context).accentColor,
                            //                                 // color: Colors.black
                            //                               ),
                            //                             ),
                            //                             subtitle: Text(
                            //                               '${RateClassF[index]}',
                            //                               textAlign:
                            //                                   TextAlign.left,
                            //                               style: TextStyle(
                            //                                 color: Theme.of(context).accentColor,
                            //                                 // color: Colors.deepPurple
                            //                               ),
                            //                             ),
                            //                           ));
                            //                     },
                            //                   ),
                            //                 )),
                            //             actions: <Widget>[
                            //               TextButton(
                            //                 onPressed: () =>
                            //                     Navigator.of(context).pop(),
                            //                 child: Center(
                            //                     child:  Text(
                            //
                            //                 S.of(context).Close,
                            //                 //  'Close',
                            //                   style: TextStyle(
                            //                     color: Theme.of(context).accentColor,
                            //                     //color: Colors.deepPurple
                            //                   ),
                            //                 )),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //         child: Icon(
                            //           Icons.help,
                            //           color: Theme.of(context).accentColor,
                            //           //color: Colors.black,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              child: TypeAheadField<RateClassCodeClass>(
                                  suggestionsCallback: RateClassCodeApi.getRateClassCode,
                                  itemBuilder: (context, RateClassCodeClass suggestion) {
                                    final code = suggestion;
                                    return ListTile(
                                      title: Text(code.RateClassCCode,
                                          style: TextStyle(
                                              color: Theme.of(context).accentColor)),
                                      subtitle: Text(code.RateClassName,
                                          style: TextStyle(
                                              color: Theme.of(context).accentColor)),
                                    );
                                  },
                                  textFieldConfiguration: TextFieldConfiguration(
                                   controller: RateClassController,
                                    inputFormatters: [AllCapitalCase()],
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context).accentColor,
                                          width: 2
                                          ),
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(8.0)),
                                        ),
                                        //border: InputBorder.none,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context).accentColor,
                                          width: 2
                                          ),
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(8.0)),

                                        ),
                                        border: OutlineInputBorder(
                                            // gapPadding: 1.0,
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(8.0),

                                            )),
                                        suffixText: rateclassdescription,
                                        labelText: "Rate Class*",
                                        //S.of(context).Origin,
                                        labelStyle:
                                        TextStyle(color: Theme.of(context).accentColor)
                                      //'Origin',
                                    ),
                                  ),
                                  onSuggestionSelected: (RateClassCodeClass suggestion) {
                                    setState(() {
                                      rateclassdescription = suggestion.RateClassName;
                                      this.RateClassController.text=suggestion.RateClassCCode;
                                      rateClass = suggestion.RateClassCCode;
                                    });
                                    // sippercontactList[index]['Shipper_Contact_Type'] =
                                    //     suggestion.contactCode;

                                    //_fhlModel.houseDetailsOrigin = suggestion.airportCode;
                                    //
                                  }),
                            ),
                            // Text(rateClass),
                            // Container(
                            //   margin: const EdgeInsets.only(bottom: 15),
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.all(
                            //         Radius.circular(8.0),),
                            //       border: Border.all(color: Theme.of(context).accentColor,
                            //         width: 2,
                            //       )
                            //   ),
                            //   padding: const EdgeInsets.only(bottom:10),
                            //   child: DropdownButton<MenuItem>(
                            //       isExpanded: true,
                            //       icon: Visibility (visible:false, child: Icon(Icons.arrow_downward)),
                            //       // icon: Icon(Icons.keyboard_arrow_down),
                            //       underline: SizedBox(),
                            //       value: rateclassdropdown,
                            //       onChanged: (MenuItem newValue) {
                            //         setState(() {
                            //           rateclassdropdown = newValue;
                            //           rateClass = newValue.RateClassCode;
                            //         });
                            //       },
                            //       items: items.map<DropdownMenuItem<MenuItem>>((MenuItem value) {
                            //         return DropdownMenuItem<MenuItem>(
                            //           value: value,
                            //           child: ListTile(
                            //             title: Text(value.RateClassCode),
                            //             trailing:  Text(value.name),
                            //
                            //           ),
                            //         );
                            //       }).toList()),
                            // ),

                            // ! itemNumber....
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, bottom: 15.0),
                              child: TextFormField(
                                focusNode: itemNumberFocusNode,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {
                                  _fieldFocusChange(context, itemNumberFocusNode,
                                      chargeableWeightFocusNode);
                                },
                                initialValue:
                                    itemNumber == 0 ? "" : itemNumber.toString(),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  itemNumber = int.parse(value);
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
                                  //     borderRadius: BorderRadius.all(
                                  //         Radius.circular(8.0))),
                                  labelText: S.of(context).ItemNumber+" *",
                                  labelStyle: new TextStyle(
                                      color: Theme.of(context).accentColor,
                                    //color: Colors.deepPurple,
                                      fontSize: 16.0),
                                  //'Item Number',
                                ),
                              ),
                            ),

                            // ! chargeableWeight....
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, bottom: 15.0),
                              child: TextFormField(
                                enableInteractiveSelection: false,
                                enabled: (autoCalculations=="Charg, total"||autoCalculations=="Gross, Charg, total")?false:true,
                                controller: _chargeableWeightController,
                                focusNode: chargeableWeightFocusNode,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {
                                  _fieldFocusChange(
                                      context,
                                      chargeableWeightFocusNode,
                                      rateChargeFocusNode);
                                },
                                // initialValue: chargeableWeight == 0
                                //     ? ""
                                //     : chargeableWeight.toString(),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  chargeableWeight = int.parse(value);
                                 // _chargeableWeightController.text=value;
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: (autoCalculations=="Charg, total"||autoCalculations=="Gross, Charg, total")?
                                  Theme.of(context).accentColor.withOpacity(0.2):Theme.of(context).backgroundColor,
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
                                  //     borderRadius: BorderRadius.all(
                                  //         Radius.circular(8.0))),
                                  labelText: S.of(context).Chargeableweight+" *",
                                  labelStyle: new TextStyle(
                                      color: Theme.of(context).accentColor,
                                    // color: Colors.deepPurple,
                                      fontSize: 16.0),
                                  //'Chargeable Weight',
                                ),
                              ),
                            ),

                            // ! rateCharge....
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, bottom: 15.0),
                              child: TextFormField(
                                controller: _RatechargeController,
                                focusNode: rateChargeFocusNode,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {
                                  _fieldFocusChange(context, rateChargeFocusNode,
                                      totalFocusNode);
                                },
                                // initialValue:
                                //     rateCharge == 0 ? "" : rateCharge.toString(),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  rateCharge = int.parse(value);
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
                                      //  color: Colors.deepPurple
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  // border: OutlineInputBorder(
                                  //     gapPadding: 2.0,
                                  //     borderRadius:
                                  //         BorderRadius.all(Radius.circular(8.0))),
                                  labelText: S.of(context).RateCharge+" *",
                                  labelStyle: new TextStyle(
                                      color: Theme.of(context).accentColor,
                                     // color: Colors.deepPurple,
                                      fontSize: 16.0),
                                  //'Rate Charge',
                                ),
                              ),
                            ),

                            // ! total....
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, bottom: 15.0),
                              child: TextFormField(
                                 enableInteractiveSelection: false,
                                enabled: false,
                                controller: _totalController,
                                focusNode: totalFocusNode,
                                readOnly: !readOnly,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (value) {
                                  totalFocusNode.unfocus();
                                },
                                //initialValue: total == 0 ? "" : total.toString(),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  total = int.parse(value);
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Theme.of(context).accentColor.withOpacity(0.2),
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
                                  labelText: S.of(context).Total+" *",
                                  labelStyle: new TextStyle(
                                      color: Theme.of(context).accentColor,
                                    //color: Colors.deepPurple,
                                      fontSize: 16.0),
                                  //'Total',
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding:
                            //   const EdgeInsets.only(top: 2.0, bottom: 15.0),
                            //   child: TextFormField(
                            //     controller: _volumeController,
                            //     focusNode: totalFocusNode,
                            //     readOnly: readOnly,
                            //     textInputAction: TextInputAction.done,
                            //     onFieldSubmitted: (value) {
                            //       totalFocusNode.unfocus();
                            //     },
                            //     //initialValue: total == 0 ? "" : total.toString(),
                            //     keyboardType: TextInputType.text,
                            //     onChanged: (value) {
                            //       //_getvolume()=int.parse(value);
                            //       // _getvolume();
                            //   setState(() {
                            //     volume = height * length + width* piece;
                            //     volume = int.parse(value);
                            //
                            //   });
                            //     },
                            //     decoration: InputDecoration(
                            //       isDense: true,
                            //       border: OutlineInputBorder(
                            //           gapPadding: 2.0,
                            //           borderRadius:
                            //           BorderRadius.all(Radius.circular(8.0))),
                            //       labelText:
                            //      "Volume",
                            //       //'Total',
                            //     ),
                            //
                            //   ),
                            // ),

                            // ! autoCalculations....
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 4, bottom: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    S.of(context).Autocalculations,
                                    // "Auto-calculations",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                      //color: Colors.deepPurple,
                                        fontSize: 17.0),
                                  ),
                                )),
                            Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 20,
                                    ),
                                    DropdownButton<String>(
                                        isDense: true,
                                        icon: Icon(Icons.arrow_drop_down),
                                        value: autoCalculations,
                                        items: autoCalculationList
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value,
                                                style: TextStyle(
                                                  color: Theme.of(context).accentColor,
                                                  //color: Colors.deepPurple
                                                )),
                                          );
                                        }).toList(),
                                        onChanged: (String text) {
                                          setState(() {
                                            autoCalculations = text;
                                            _getTipAmount(autoCalculations,
                                                rateClass, grossWeightUnit);
                                            print("totalValue: " +
                                                autoCalculations);
                                          });
                                        }),
                                    IconButton(
                                      icon: Icon(Icons.help,
                                          color: Theme.of(context).accentColor,
                                      ),
                                      onPressed: () => showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: Center(
                                            child:  Text(
                                           S.of(context).Autocalculations,
                                              //   'Auto-Calculations',
                                              style:
                                                  TextStyle(color: Colors.black),
                                            ),
                                          ),
                                          content: Container(
                                              height: 200,
                                              width: 300,
                                              child: Scrollbar(
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      autoCalculationList.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Card(
                                                      shape:
                                                          new RoundedRectangleBorder(
                                                              side: new BorderSide(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 2.0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.0)),
                                                      child: ListTile(
                                                        title: Text(
                                                          '${autoCalculationList[index]}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        subtitle: Text(
                                                          '${Autocalc_value[index]}',
                                                          style: TextStyle(
                                                            color: Theme.of(context).accentColor,
                                                            //  color: Colors.deepPurple
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: Center(
                                                  child:  Text(
                                               S.of(context).Close,
                                                    // 'Close',
                                                style: TextStyle(
                                                  color: Theme.of(context).accentColor,
                                                  //  color: Colors.deepPurple
                                                ),
                                              )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // child: Icon(
                                      //   Icons.help,
                                      //   color: Colors.black,
                                      // ),
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).Volume + " "+_volumeController.text,
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    // color: Colors.deepPurple,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  // "Volumetric Weight : "
                                  S.of(context).VolumetricWeight+" "+
                                      _volumetricController.text,
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    // color: Colors.deepPurple,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  S.of(context).Factor
                                  // "Factor : "
                                    +" "  + fact,
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    // color: Colors.deepPurple,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor.withOpacity(0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0)),
                                  border: Border.all(color: Theme.of(context).accentColor,
                                    width: 2,
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        "PPD",
                                        //"AWB",
                                        style: TextStyle(
                                            color: Theme.of(context).accentColor
                                        ),
                                      ),
                                      leading: Radio(
                                          fillColor: MaterialStateColor.resolveWith((states) => Theme.of(context).accentColor),
                                          value: "PPD",
                                          groupValue: model.chargesDeclarationWTVALCharges,
                                          onChanged: (value) {
                                            setState(() {
                                              model.chargesDeclarationWTVALCharges = value.toString();
                                            });
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        "COLL",
                                        //"Multiple AWBs",
                                        style: TextStyle(
                                            color: Theme.of(context).accentColor
                                        ),),
                                      leading: Radio(
                                          fillColor: MaterialStateColor.resolveWith((states) => Theme.of(context).accentColor),
                                          value: "COLL",
                                          groupValue: model.chargesDeclarationWTVALCharges,
                                          onChanged: (value) {
                                            setState(() {
                                              model.chargesDeclarationWTVALCharges = value.toString();
                                            });
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            //Container(child: _getvolume()),
                          ],
                        ),
                      ),
                    ),

                    // Divider(
                    //   thickness: 2,
                    //   indent: MediaQuery.of(context).size.width * 0.3,
                    //   endIndent: MediaQuery.of(context).size.width * 0.3,
                    // ),

                    Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, bottom: 15.0),
                              child: Text(
                                S.of(context).Natureandquantityofgoods,
                                // "Nature and quantity of goods",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  // color: Colors.deepPurple,
                                  // decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   children: <Widget>[
                            //     Checkbox(
                            //       value: consolidationvalue,
                            //       onChanged: (bool value) {
                            //         setState(() {
                            //           this.consolidationvalue = value;
                            //           if(consolidationvalue.toString()=="true")
                            //             this.natureofgoods=TextEditingController(text: "CONSOLIDATION");
                            //           // natureAndQuantity="CONSOLIDATION";
                            //           //   natureofgoods.text = "CONSOLIDATION";
                            //           else
                            //             this.natureofgoods=TextEditingController(text: " ");
                            //           // natureAndQuantity="";
                            //           // natureofgoods.clear();
                            //           // natureAndQuantity.clear();
                            //           print(natureofgoods.text);
                            //           print(consolidationvalue);
                            //           // monVal = value;
                            //         });
                            //       },
                            //     ),
                            //     Text(
                            //       S.of(context).Consolidation,
                            //       //"Consolidation",
                            //       style: TextStyle(
                            //         color: Theme.of(context).accentColor,
                            //         // color: Colors.deepPurple,
                            //         // decoration: TextDecoration.underline,
                            //         fontWeight: FontWeight.w700,
                            //         fontSize: 18.0,
                            //       ),
                            //     ),
                            //   ],
                            // ),

                            // ! natureAndQuantity....
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, bottom: 15.0),
                              child: TextFormField(
                                focusNode: natureAndQuantityFocusNode,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (value) {
                                  natureAndQuantityFocusNode.unfocus();
                                },
                                // initialValue: natureAndQuantity,
                                controller: this.natureofgoods,
                                keyboardType: TextInputType.text,
                                inputFormatters: [AllCapitalCase()],
                                onChanged: (value) {
                                  setState(() {
                                    natureAndQuantity = value;
                                    print(natureAndQuantity);
                                  });
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
                                  labelText: S.of(context).NatureandQuantity+" *",
                                  labelStyle: new TextStyle(
                                      color: Theme.of(context).accentColor,
                                    //color: Colors.deepPurple,
                                      fontSize: 16.0),
                                  //'Nature and quantity',
                                ),
                              ),
                            ),
                            // Text(natureAndQuantity),
                            // ! SLAC
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 2.0, bottom: 15.0),
                              child: TextFormField(
                                // initialValue: natureAndQuantity,
                                controller: this.slacController,
                                keyboardType: TextInputType.text,
                                inputFormatters: [AllCapitalCase()],
                                onChanged: (value) {
                                  setState(() {
                                    slac=value;
                                    // natureAndQuantity = value;
                                    // print(natureAndQuantity);
                                  });
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
                                  "SLAC",
                                  //S.of(context).NatureandQuantity+" *",
                                  labelStyle: new TextStyle(
                                      color: Theme.of(context).accentColor,
                                      //color: Colors.deepPurple,
                                      fontSize: 16.0),
                                  //'Nature and quantity',
                                ),
                              ),
                            ),
                            // ! dimensionsList....
                            Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Text(
                                    S.of(context).Dimensions,
                                    // 'Dimensions',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                      // color: Colors.deepPurple,
                                        fontSize: 17.0),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Theme.of(context).accentColor,
                                      // color: Colors.deepPurple,
                                    ),
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        totalPieces=0;
                                        totalWeight=0;
                                        dimensionsList.removeWhere(
                                            (element) => element['isSelected']);
                                      });
                                    },
                                  ),
                                ),

                                Expanded(
                                  flex: 2,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      color: Theme.of(context).accentColor,
                                      //color: Colors.deepPurple,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        dimensionsList.add({
                                          'isSelected': false,
                                          S.of(context).length
                                              //'length'
                                              : 0.0,
                                          //'height'
                                          S.of(context).height: 0.0,
                                          //'width'
                                          S.of(context).width: 0.0,
                                          //'lwhUnit'
                                          S.of(context).lwhunit: 'cm',
                                          //'pieces'
                                          S.of(context).Pieces: 0.0,
                                          //'weight'
                                          S.of(context).Weight: 0.0,
                                          //'pwUnit'
                                          S.of(context).pwunit: 'K',

                                          //'isSelected': false,
                                        });
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, bottom: 15.0),
                              child: Column(
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Builder(
                                      builder: (context) => DataTable(
                                        dataRowColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.selected))
                                            return Colors.deepPurple[50];
                                          return null; // Use the default value.
                                        }),
                                        showCheckboxColumn: false,
                                        columnSpacing: 12,
                                        columns: [
                                          DataColumn(
                                              label: Text(
                                            S.of(context).length,
                                                //'Len',
                                            style: TextStyle(
                                              color: Theme.of(context).accentColor,
                                              //   color: Colors.deepPurple
                                            ),
                                          )),
                                          DataColumn(
                                              label: Text(
                                                S.of(context).Width,
                                            // 'Wid',
                                            style: TextStyle(
                                              color: Theme.of(context).accentColor,
                                              // color: Colors.deepPurple
                                            ),
                                          )),
                                          DataColumn(
                                              label: Text(
                                           S.of(context).Height,
                                                // 'Hgt',
                                            style: TextStyle(
                                              color: Theme.of(context).accentColor,
                                              //color: Colors.deepPurple
                                            ),
                                          )),
                                          DataColumn(
                                              label: Text(
                                            '',
                                            style: TextStyle(
                                              color: Theme.of(context).accentColor,
                                              // color: Colors.deepPurple
                                            ),
                                          )),
                                          DataColumn(
                                              label: Text(
                                            S.of(context).Pieces,
                                                //'Pcs',
                                            style: TextStyle(
                                              color: Theme.of(context).accentColor,
                                              //   color: Colors.deepPurple
                                            ),
                                          )),
                                          DataColumn(
                                              label: Text(
                                            S.of(context).Weight,
                                                //'Wgt',
                                            style: TextStyle(
                                              color: Theme.of(context).accentColor,
                                              //  color: Colors.deepPurple
                                            ),
                                          )),
                                          DataColumn(
                                              label: Text(
                                            '',
                                            style: TextStyle(
                                              color: Theme.of(context).accentColor,
                                              // color: Colors.deepPurple
                                            ),
                                          )),
                                          // DataColumn(
                                          //     label: Text(
                                          //   '',
                                          //   style: TextStyle(
                                          //       color: Colors.deepPurple),
                                          // )),
                                        ],
                                        rows: List<DataRow>.generate(
                                          dimensionsList.length,
                                          (index) => newDataRow(index),
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
                    ),
                    // Divider(
                    //   thickness: 2,
                    //   indent: MediaQuery.of(context).size.width * 0.3,
                    //   endIndent: MediaQuery.of(context).size.width * 0.3,
                    // ),

                    // Card(
                    //   shape: RoundedRectangleBorder(
                    //     side: BorderSide(color: Colors.grey, width: 1),
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Column(
                    //       children: [
                    //         // ElevatedButton(
                    //         //   child: Text('CALC'),
                    //         //   onPressed: () {
                    //         //     setState(() {
                    //         //       int sum = int.parse(_lengthController.text) *
                    //         //           int.parse(_widthController.text) *
                    //         //           int.parse(_heightController.text);
                    //         //       int factor = 6000;
                    //         //       double volumetric_weight = sum / factor;
                    //         //       fact = factor.toString();
                    //         //       volumetricw =
                    //         //           volumetric_weight.toStringAsFixed(2);
                    //         //       result = sum.toString();
                    //         //       print("$sum");
                    //         //     });
                    //         //   },
                    //         // ),
                    //         SizedBox(height: 12),
                    //         // Column(
                    //         //   crossAxisAlignment: CrossAxisAlignment.start,
                    //         //   mainAxisAlignment: MainAxisAlignment.start,
                    //         //   children: [
                    //         //     Text(
                    //         //       "Volume :" + _volumeController.text,
                    //         //       style: TextStyle(
                    //         //         color: Colors.deepPurple[300],
                    //         //         fontWeight: FontWeight.w700,
                    //         //         fontSize: 16,
                    //         //       ),
                    //         //     ),
                    //         //     Text(
                    //         //       "Volumetric Weight :" +
                    //         //           _volumetricController.text,
                    //         //       style: TextStyle(
                    //         //         color: Colors.deepPurple[300],
                    //         //         fontWeight: FontWeight.w700,
                    //         //         fontSize: 16,
                    //         //       ),
                    //         //     ),
                    //         //     Text(
                    //         //       "Factor :" + fact + "/kg",
                    //         //       style: TextStyle(
                    //         //         color: Colors.deepPurple[300],
                    //         //         fontWeight: FontWeight.w700,
                    //         //         fontSize: 16,
                    //         //       ),
                    //         //     ),
                    //         //   ],
                    //         // ),
                    //         SizedBox(height: 12),
                    //         // ! Extra description....
                    //         // Padding(
                    //         //   padding:
                    //         //       const EdgeInsets.only(top: 2.0, bottom: 15.0),
                    //         //   child: Text(
                    //         //     S.of(context).ExtraDescription,
                    //         //     //"Extra description",
                    //         //     style: TextStyle(
                    //         //       color: Theme.of(context).accentColor,
                    //         //       // color: Colors.deepPurple,
                    //         //       // decoration: TextDecoration.underline,
                    //         //       fontWeight: FontWeight.w700,
                    //         //       fontSize: 20.0,
                    //         //     ),
                    //         //   ),
                    //         // ),
                    //         // Padding(
                    //         //   padding:
                    //         //       const EdgeInsets.only(top: 2.0, bottom: 15.0),
                    //         //   child: TextFormField(
                    //         //     focusNode: textFocusNode,
                    //         //     textInputAction: TextInputAction.done,
                    //         //     onFieldSubmitted: (value) {
                    //         //       textFocusNode.unfocus();
                    //         //     },
                    //         //     initialValue: text,
                    //         //     keyboardType: TextInputType.text,
                    //         //     inputFormatters: [AllCapitalCase()],
                    //         //     onChanged: (value) {
                    //         //       text = value;
                    //         //     },
                    //         //     decoration: InputDecoration(
                    //         //       isDense: true,
                    //         //       enabledBorder: OutlineInputBorder(
                    //         //           borderSide: new BorderSide(
                    //         //               color: Theme.of(context).accentColor,
                    //         //             //color: Colors.deepPurple,
                    //         //               width: 2),
                    //         //           //gapPadding: 2.0,
                    //         //           borderRadius:
                    //         //               BorderRadius.all(Radius.circular(8.0))),
                    //         //       focusedBorder: OutlineInputBorder(
                    //         //         borderSide: BorderSide(
                    //         //             width: 2,
                    //         //           color: Theme.of(context).accentColor,
                    //         //           // color: Colors.deepPurple
                    //         //         ),
                    //         //         borderRadius: BorderRadius.circular(8.0),
                    //         //       ),
                    //         //       // border: OutlineInputBorder(
                    //         //       //     gapPadding: 2.0,
                    //         //       //     borderRadius: BorderRadius.all(
                    //         //       //         Radius.circular(8.0))),
                    //         //       // labelText: S.of(context).Text,
                    //         //       //labelStyle: new TextStyle(
                    //         //       //  color: Colors.deepPurple, fontSize: 16.0),
                    //         //       //'Text',
                    //         //     ),
                    //         //   ),
                    //         // ),
                    //
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // ! Dialog Buttons....
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
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
                                  style:TextStyle(
                                      color:Theme.of(context).backgroundColor
                                  )
                                //"Discard"
                              ),
                            ),
                          ),
                          // ! ADD ....
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: TextButton(
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor)),
                                onPressed: () {
                                  print("SLAC"+slacController.text);
                                  print(pieces);
                                  setState(() {
                                    // model.rateDescriptionItemList.forEach((element) {
                                    //   previsousntureofgoods=element.natureAndQuantity;
                                    // });
                                    Navigator.of(context).pop(
                                        RateDescriptionItem(
                                            dimensionsList: dimensionsList,
                                            pieces: pieces,
                                            grossWeight: double.parse(
                                                _grossWeightController.text),
                                            grossWeightUnit: grossWeightUnit,
                                            rateClass: rateClass,
                                            itemNumber: itemNumber,
                                            chargeableWeight: double.parse(
                                                _chargeableWeightController
                                                    .text)
                                                .ceil(),
                                            rateCharge:
                                            int.parse(
                                                _RatechargeController.text),

                                            total: int.parse(
                                                _totalController.text),
                                            volume: _volumeController.text,
                                            slac: slacController.text,
                                            length: length,
                                            width: width,
                                            height: height,
                                            dimpieces: totalPieces,
                                            unit: lwhunit,
                                            autoCalculations: autoCalculations,
                                            natureAndQuantity:
                                            natureofgoods.text,
                                            previousnatureofgoods:natureofgoods.text,
                                            //natureAndQuantity,
                                            text: text));
                                    // model.summaryratedescription();
                                    // if (model.chargesDeclarationWTVALCharges ==
                                    //     "PPD") {
                                    //   chargesummrypreweightcharge +=
                                    //       int.parse(_totalController.text);
                                    //   model.chargeSummaryWeightChargePrepaid =
                                    //       (int.parse(model
                                    //           .chargeSummaryWeightChargePrepaid) +
                                    //           chargesummrypreweightcharge)
                                    //           .toString();
                                    //   model.chargeSummaryTotalPrepaid =
                                    //       (int.parse(
                                    //           model.chargeSummaryTotalPrepaid) +
                                    //           chargesummrypreweightcharge)
                                    //           .toString();
                                    // }
                                    //
                                    // if (model.chargesDeclarationWTVALCharges ==
                                    //     "PPD") {
                                    //   print("postpost"+chargesummrypreweightcharge.toString());
                                    //   if(model.chargeSummaryWeightChargePrepaid=="0"){
                                    //     model.chargeSummaryWeightChargePrepaid =
                                    //         (int.parse(model.chargeSummaryWeightChargePostpaid)+
                                    //     // ((int.parse(model.chargeSummaryWeightChargePrepaid))+
                                    //         int.parse(_totalController.text)).toString();
                                    //     chargesummrypreweightcharge=(int.parse(model.chargeSummaryWeightChargePostpaid)+
                                    //         int.parse(_totalController.text));
                                    //     model.chargeSummaryTotalPostpaid=(int.parse(model.chargeSummaryTotalPrepaid)-
                                    //         int.parse(model.chargeSummaryWeightChargePrepaid)).toString();
                                    //     model.chargeSummaryWeightChargePostpaid="0";
                                    //     model.chargeSummaryTotalPrepaid =
                                    //         (int.parse(
                                    //             model.chargeSummaryTotalPrepaid) +
                                    //             int.parse(
                                    //                 model.chargeSummaryWeightChargePrepaid)
                                    //         )
                                    //             .toString();
                                    //
                                    //   }
                                    //
                                    //   // else {
                                    //   //   chargesummrypreweightcharge +=
                                    //   //       int.parse(_totalController.text);
                                    //   //   model
                                    //   //       .chargeSummaryWeightChargePrepaid =
                                    //   //       (int.parse(model
                                    //   //           .chargeSummaryWeightChargePostpaid) +
                                    //   //           chargesummrypreweightcharge)
                                    //   //           .toString();
                                    //   //   model.chargeSummaryTotalPrepaid =
                                    //   //       (int.parse(
                                    //   //           model.chargeSummaryTotalPostpaid) +
                                    //   //           chargesummrypreweightcharge)
                                    //   //           .toString();
                                    //   // }
                                    // }
                                    //
                                    // if (model.chargesDeclarationWTVALCharges ==
                                    //     "COLL") {
                                    //   print("postpost"+chargesummrypreweightcharge.toString());
                                    //   if(model.chargeSummaryWeightChargePostpaid=="0"){
                                    //     model.chargeSummaryWeightChargePostpaid =(int.parse(model.chargeSummaryWeightChargePrepaid)+
                                    //         int.parse(_totalController.text)).toString();
                                    //     chargesummrypreweightcharge=(int.parse(model.chargeSummaryWeightChargePrepaid)+
                                    //         int.parse(_totalController.text));
                                    //     model.chargeSummaryTotalPrepaid=(int.parse(model.chargeSummaryTotalPrepaid)-
                                    //         int.parse(model.chargeSummaryWeightChargePrepaid)).toString();
                                    //     model.chargeSummaryWeightChargePrepaid="0";
                                    //     model.chargeSummaryTotalPostpaid =
                                    //         (int.parse(
                                    //             model.chargeSummaryTotalPostpaid) +
                                    //             int.parse(
                                    //                 model.chargeSummaryWeightChargePostpaid)
                                    //         )
                                    //             .toString();
                                    //   }
                                    //   else {
                                    //     chargesummrypostweightcharge +=
                                    //         int.parse(_totalController.text);
                                    //     model
                                    //         .chargeSummaryWeightChargePostpaid =
                                    //         (int.parse(model
                                    //             .chargeSummaryWeightChargePostpaid) +
                                    //             chargesummrypostweightcharge)
                                    //             .toString();
                                    //     model.chargeSummaryTotalPostpaid =
                                    //         (int.parse(
                                    //             model.chargeSummaryTotalPostpaid) +
                                    //             chargesummrypostweightcharge)
                                    //             .toString();
                                    //   }}

                                  });

                                },
                                child: Text(S.of(context).Add,
                                    style:TextStyle(
                                        color:Theme.of(context).backgroundColor
                                    )
                                    //  "Add"
                                    )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }

  _getTipAmount(String autocalc, String rateclass, String gWUnit) {
    if (gWUnit == "K") {
      if (autocalc != 'No') {
        setState(() {
          readOnly = !readOnly;
        });
        if (autocalc == "Total") {
          if (rateclass == 'M' || rateclass == 'B') {
            _getTotals();
          } else if (rateclass == 'Q' ||
              rateclass == 'N' ||
              rateclass == 'C' ||
              rateclass == 'K') {
            _totalkq();
            // _getTotal();
          } else if (rateclass == 'Y' ||
              rateclass == 'X' ||
              rateclass == 'E' ||
              rateclass == 'U' ||
              rateclass == 'S' ||
              rateclass == 'R' ||
              rateclass == 'W') {
            _getTotalyw();
            // _getTotal();
          }
        }
        if (autocalc == "Charg, total") {
          if (rateclass == 'M' || rateclass == 'B') {
            setState(() {
              // total= _Ratecharge;
              if (double.parse(volumetricw) > grossWeight) {
                _chargeableWeightController = TextEditingController(
                    text: double.parse(volumetricw).ceil().toString());
                // _grossWeightController =
                //     TextEditingController(text: grossWeight.ceil().toString());
               }
              else{
                _chargeableWeightController = TextEditingController(
                    text: grossWeight.ceil().toString());
              }
              //   _chargeableWeightController =
              //       TextEditingController(text: volumetricw.toString());
              _totalController =
                  TextEditingController(text: _Ratecharge.toString());
              print("Total Controller " + '$_totalController');
              _totalController = readOnly as TextEditingController;
              _chargeableWeightController = readOnly as TextEditingController;
              print("total"+_chargeableWeightController.text);
            });
          } else if (rateclass == 'Q' ||
              rateclass == 'N' ||
              rateclass == 'C' ||
              rateclass == 'K') {
            setState(() {
              if (double.parse(volumetricw) > grossWeight) {
                _chargeableWeightController = TextEditingController(
                    text: double.parse(volumetricw).ceil().toString());
                // _grossWeightController =
                //     TextEditingController(text: grossWeight.ceil().toString());
              }
              else{
                _chargeableWeightController = TextEditingController(
                    text: grossWeight.ceil().toString());
              }
              // total= _Ratecharge;
              // _chargeableWeightController =
              //     TextEditingController(text: grossWeight.ceil().toString());
              total =
                //  _ChargeWeight
                  //grossWeight.ceil() 
              int.parse(_chargeableWeightController.text)
                      * _Ratecharge;
              _totalController = TextEditingController(text: total.toString());
              // _totalController = TextEditingController(text: _Ratecharge.toString());
              print("Total Controller " + '$_totalController');
              _totalController = readOnly as TextEditingController;
              _chargeableWeightController = readOnly as TextEditingController;
            });
            // _getTotal();
          } else if (rateclass == 'Y' ||
              rateclass == 'X' ||
              rateclass == 'E' ||
              rateclass == 'U' ||
              rateclass == 'S' ||
              rateclass == 'R' ||
              rateclass == 'W') {
            setState(() {
              // total= _Ratecharge;
              if (double.parse(volumetricw) > grossWeight) {
                _chargeableWeightController = TextEditingController(
                    text: double.parse(volumetricw).ceil().toString());
                // _grossWeightController =
                //     TextEditingController(text: grossWeight.ceil().toString());
              }
              else{
                _chargeableWeightController = TextEditingController(
                    text: grossWeight.ceil().toString());
              }
              // _chargeableWeightController =
              //     TextEditingController(text: grossWeight.ceil().toString());
              _totalController = TextEditingController(text: "".toString());
              print("Total Controller " + _totalController.text);
              _totalController = readOnly as TextEditingController;
              _chargeableWeightController = readOnly as TextEditingController;
            });
            // _getTotal();
          }
        }
        if (autocalc == "Gross, total") {
          if (rateclass == 'M' || rateclass == 'B') {
            setState(() {
              // int chargetot;
              // int vol= volumetricw.toString() as int;
              // print('volumeeee: $vol');
              // if( vol > grossWeight.toInt()){
              //   chargetot = volumetricw.toString() as int;
              //   print(' vol $chargetot');
              // }
              // else{
              //   chargetot = grossWeight.toInt();
              //   print('gw $chargetot');
              // }
              // // total= _Ratecharge;
              // pieces = piece.toInt();
              // print('$pieces');
              // _piecesController = TextEditingController(text: piece.toString());
              _piecesController = TextEditingController(text: tottotPieces.toString());
              int GCTGweight=piece*weight;
              _grossWeightController =
                  TextEditingController(text: totalWeight.toString());

               // _chargeableWeightController =TextEditingController(text: grossWeight.toString());
               //

              _totalController =
                  TextEditingController(text: _Ratecharge.toString());
              print("Total Controller " + '$_totalController');
              _totalController = readOnly as TextEditingController;
              _grossWeightController = readOnly as TextEditingController;
              _piecesController = readOnly as TextEditingController;
            });
          } else if (rateclass == 'Q' ||
              rateclass == 'N' ||
              rateclass == 'C' ||
              rateclass == 'K') {
            setState(() {
              _piecesController = TextEditingController(text: tottotPieces.toString());
              int GCTGweight=piece*weight;
              // _chargeableWeightController =TextEditingController(text: grossWeight.toString());
              _grossWeightController =
                  TextEditingController(text: totalWeight.toString());
              // total= _Ratecharge;
              // _chargeableWeightController =TextEditingController(text: grossWeight.toString());
              total =
              //ChargeWeight
                chargeableWeight  * _Ratecharge;
              _totalController = TextEditingController(text: total.toString());
              // _totalController = TextEditingController(text: _Ratecharge.toString());
              print("Total Controller " + '$_totalController');
              _totalController = readOnly as TextEditingController;
              _chargeableWeightController = readOnly as TextEditingController;
              _piecesController = readOnly as TextEditingController;
              _grossWeightController = readOnly as TextEditingController;
            });
            // _getTotal();
          } else if (rateclass == 'Y' ||
              rateclass == 'X' ||
              rateclass == 'E' ||
              rateclass == 'U' ||
              rateclass == 'S' ||
              rateclass == 'R' ||
              rateclass == 'W') {
            setState(() {
              _piecesController = TextEditingController(text: tottotPieces.toString());
              int GCTGweight=piece*weight;
              // _chargeableWeightController =TextEditingController(text: grossWeight.toString());
              _grossWeightController =
                  TextEditingController(text: totalWeight.toString());
              // total= _Ratecharge;
              // _chargeableWeightController =TextEditingController(text: grossWeight.toString());
              // total = _ChargeWeight * _Ratecharge;
              _totalController = TextEditingController(text: "".toString());
              // _totalController = TextEditingController(text: _Ratecharge.toString());
              print("Total Controller " + '$_totalController');
              _totalController = readOnly as TextEditingController;
              _chargeableWeightController = readOnly as TextEditingController;
              _piecesController = readOnly as TextEditingController;
              _grossWeightController = readOnly as TextEditingController;
              // total= _Ratecharge;

              // _chargeableWeightController =TextEditingController(text: grossWeight.toString());
              // _totalController = TextEditingController(text: "".toString());
              // print("Total Controller " + '$_totalController');
              // _totalController= readOnly as TextEditingController;
              // _chargeableWeightController= readOnly as TextEditingController;
            });
            // _getTotal();
          }
        }
        if (autocalc == "Gross, Charg, total") {
          if (rateclass == 'M' || rateclass == 'B') {
            setState(() {
              _piecesController = TextEditingController(text: tottotPieces.toString());
              int GCTGweight=piece*weight;
              _grossWeightController =
                  TextEditingController(text: totalWeight.toString());
              if (double.parse(volumetricw) > totalWeight) {
                _chargeableWeightController = TextEditingController(
                    text: double.parse(volumetricw).ceil().toString());
                // _grossWeightController =
                //     TextEditingController(text: grossWeight.ceil().toString());
              }
              else{
                // _chargeableWeightController = TextEditingController(
                //     text: grossWeight.ceil().toString());
                // total= _Ratecharge;
                _chargeableWeightController =TextEditingController(text: totalWeight.toString());
              }

                 // if(pieces==""&&weight==""){
                 //   _chargeableWeightController = TextEditingController(
                 //       text: double.parse(volumetricw).ceil().toString());
                 // }
              // _chargeableWeightController = TextEditingController(
              //     text: double.parse(volumetricw).ceil().toString());
              _totalController =
                  TextEditingController(text: _Ratecharge.toString());
              print("Total Controller " + '$_totalController');
              // _totalController = readOnly as TextEditingController;
              // _grossWeightController = readOnly as TextEditingController;
              // _piecesController = readOnly as TextEditingController;
              //_chargeableWeightController= readOnly as TextEditingController;
            });
          } else if (rateclass == 'Q' ||
              rateclass == 'N' ||
              rateclass == 'C' ||
              rateclass == 'K') {
            setState(() {
              _piecesController = TextEditingController(text: tottotPieces.toString());
              int GCTGweight=piece*weight;
              _grossWeightController =
                  TextEditingController(text: totalWeight.toString());
              if (double.parse(volumetricw) > totalWeight) {
                _chargeableWeightController = TextEditingController(
                    text: double.parse(volumetricw).ceil().toString());
                // _grossWeightController =
                //     TextEditingController(text: grossWeight.ceil().toString());
              }
              else{
                // _chargeableWeightController = TextEditingController(
                //     text: grossWeight.ceil().toString());
                // total= _Ratecharge;
                _chargeableWeightController =TextEditingController(text: totalWeight.toString());
              }
              // total= _Ratecharge;
              // _chargeableWeightController = TextEditingController(
              //     text: totalWeight.toString());
              // _chargeableWeightController = TextEditingController(
              //     text: double.parse(volumetricw).ceil().toString());
              total =
                  //_ChargeWeight
              //totalWeight
                 int.parse(_chargeableWeightController.text) * _Ratecharge;
              _totalController = TextEditingController(text: total.toString());
              // _totalController = TextEditingController(text: _Ratecharge.toString());
              print("Total Controller " + '$_totalController');
              _totalController = readOnly as TextEditingController;
              _grossWeightController = readOnly as TextEditingController;

              _chargeableWeightController = readOnly as TextEditingController;
            });
            // _getTotal();
          } else if (rateclass == 'Y' ||
              rateclass == 'X' ||
              rateclass == 'E' ||
              rateclass == 'U' ||
              rateclass == 'S' ||
              rateclass == 'R' ||
              rateclass == 'W') {
            setState(() {
              _piecesController = TextEditingController(text: tottotPieces.toString());
              int GCTGweight=piece*weight;
              _grossWeightController =
                  TextEditingController(text: totalWeight.toString());
              if (double.parse(volumetricw) > totalWeight) {
                _chargeableWeightController = TextEditingController(
                    text: double.parse(volumetricw).ceil().toString());
                // _grossWeightController =
                //     TextEditingController(text: grossWeight.ceil().toString());
              }
              else{
                // _chargeableWeightController = TextEditingController(
                //     text: grossWeight.ceil().toString());
                // total= _Ratecharge;
                _chargeableWeightController =TextEditingController(text: totalWeight.toString());
              }
              // total= _Ratecharge;
              // _chargeableWeightController = TextEditingController(
              //     text: double.parse(volumetricw).ceil().toString());
              // _chargeableWeightController = TextEditingController(
              //     text: totalWeight.toString());
              _totalController = TextEditingController(text: "".toString());
              print("Total Controller " + '$_totalController');
              _totalController = readOnly as TextEditingController;
              _chargeableWeightController = readOnly as TextEditingController;
              _grossWeightController = readOnly as TextEditingController;
            });
            // _getTotal();
          }
        }
      }
    }
    if (gWUnit == "L") {
      if (autocalc != 'No') {
        setState(() {
          readOnly = !readOnly;
        });
        if (autocalc == "Total") {
          if (rateclass == 'M' || rateclass == 'B') {
            _getTotals();
          } else if (rateclass == 'Q' ||
              rateclass == 'N' ||
              rateclass == 'C' ||
              rateclass == 'K') {
            _totalkq();
            // _getTotal();
          } else if (rateclass == 'Y' ||
              rateclass == 'X' ||
              rateclass == 'E' ||
              rateclass == 'U' ||
              rateclass == 'S' ||
              rateclass == 'R' ||
              rateclass == 'W') {
            _getTotalyw();
            // _getTotal();
          }
        }
        if (autocalc == "Charg, total") {
          if (rateclass == 'M' || rateclass == 'B') {
            setState(() {
              // total= _Ratecharge;
              if (double.parse(volumetricw) > grossWeight) {
                _chargeableWeightController = TextEditingController(
                    text: double.parse(volumetricw).ceil().toString());
                // _grossWeightController =
                //     TextEditingController(text: grossWeight.ceil().toString());
              }
              else{
                _chargeableWeightController = TextEditingController(
                    text: grossWeight.ceil().toString());
              }
              // _chargeableWeightController =
              //     TextEditingController(text: grossWeight.ceil().toString());
              _totalController =
                  TextEditingController(text:
                  //_Ratecharge
                      rateCharge.toString());
              print("Total Controller " + '$_totalController');
              _totalController = readOnly as TextEditingController;
              _chargeableWeightController = readOnly as TextEditingController;
            });
          } else if (rateclass == 'Q' ||
              rateclass == 'N' ||
              rateclass == 'C' ||
              rateclass == 'K') {
            setState(() {
              // total= _Ratecharge;
              if (double.parse(volumetricw) > grossWeight) {
                _chargeableWeightController = TextEditingController(
                    text: double.parse(volumetricw).ceil().toString());
                // _grossWeightController =
                //     TextEditingController(text: grossWeight.ceil().toString());
              }
              else{
                _chargeableWeightController = TextEditingController(
                    text: grossWeight.ceil().toString());
              }
              // _chargeableWeightController =
              //     TextEditingController(text: grossWeight.ceil().toString());
              print("rate class C<K"+_ChargeWeight.toString());
              total =
                  //_ChargeWeight
              //grossWeight.ceil()
                int.parse(_chargeableWeightController.text)  * rateCharge;
                     //_Ratecharge;
              _totalController = TextEditingController(text: total.toString());
              // _totalController = TextEditingController(text: _Ratecharge.toString());
              print("Total Controller " + '$_totalController');
              _totalController = readOnly as TextEditingController;
              _chargeableWeightController = readOnly as TextEditingController;
            });
            // _getTotal();
          } else if (rateclass == 'Y' ||
              rateclass == 'X' ||
              rateclass == 'E' ||
              rateclass == 'U' ||
              rateclass == 'S' ||
              rateclass == 'R' ||
              rateclass == 'W') {
            setState(() {
              // total= _Ratecharge;
              if (double.parse(volumetricw) > grossWeight) {
                _chargeableWeightController = TextEditingController(
                    text: double.parse(volumetricw).ceil().toString());
                // _grossWeightController =
                //     TextEditingController(text: grossWeight.ceil().toString());
              }
              else{
                _chargeableWeightController = TextEditingController(
                    text: grossWeight.ceil().toString());
              }
              // _chargeableWeightController =
              //     TextEditingController(text: grossWeight.ceil().toString());
              _totalController = TextEditingController(text: "".toString());
              print("Total Controller " + '$_totalController');
              _totalController = readOnly as TextEditingController;
              _chargeableWeightController = readOnly as TextEditingController;
            });
            // _getTotal();
          }
        }
        if (autocalc == "Gross, total") {
          if (rateclass == 'M' || rateclass == 'B') {
            setState(() {
              // int chargetot;
              // int vol= volumetricw.toString() as int;
              // print('volumeeee: $vol');
              // if( vol > grossWeight.toInt()){
              //   chargetot = volumetricw.toString() as int;
              //   print(' vol $chargetot');
              // }
              // else{
              //   chargetot = grossWeight.toInt();
              //   print('gw $chargetot');
              // }
              // // total= _Ratecharge;
              // pieces = piece.toInt();
              // print('$pieces');
              // _piecesController = TextEditingController(text: piece.toString());
              _piecesController = TextEditingController(text: tottotPieces.toString());
              //pieces calculate from dimension calculation unit variable tottoPieces

              // _chargeableWeightController =TextEditingController(text: grossWeight.toString());
              //  String pw = piece.toString() * int.parse(weight).toString();
              // print('$pw');
              int pg = piece * weight;
              _grossWeightController =
                  TextEditingController(text: totalWeight.toString());
              _totalController =
                  TextEditingController(text:
                      //_Ratecharge
                      rateCharge.toString());
              print("Total Controller " + '$_totalController');
              _totalController = readOnly as TextEditingController;
              _grossWeightController = readOnly as TextEditingController;
              _piecesController = readOnly as TextEditingController;
            });
          } else if (rateclass == 'Q' ||
              rateclass == 'N' ||
              rateclass == 'C' ||
              rateclass == 'K') {
            setState(() {
              _piecesController = TextEditingController(text: tottotPieces.toString());
              // _chargeableWeightController =TextEditingController(text: grossWeight.toString());
              int pg = piece * weight;
              _grossWeightController =
                  TextEditingController(text: totalWeight.toString());
              // total= _Ratecharge;
              // _chargeableWeightController =TextEditingController(text: grossWeight.toString());
              total =
                  chargeableWeight * rateCharge;
                  //_ChargeWeight * _Ratecharge;
              _totalController = TextEditingController(text: total.toString());
              // _totalController = TextEditingController(text: _Ratecharge.toString());
              print("Total Controller " + '$_totalController');
              _totalController = readOnly as TextEditingController;
              _chargeableWeightController = readOnly as TextEditingController;
              _piecesController = readOnly as TextEditingController;
              _grossWeightController = readOnly as TextEditingController;
            });
            // _getTotal();
          } else if (rateclass == 'Y' ||
              rateclass == 'X' ||
              rateclass == 'E' ||
              rateclass == 'U' ||
              rateclass == 'S' ||
              rateclass == 'R' ||
              rateclass == 'W') {
            setState(() {
              _piecesController = TextEditingController(text: tottotPieces.toString());
              // _chargeableWeightController =TextEditingController(text: grossWeight.toString());
              int pg = piece * weight;
              _grossWeightController =
                  TextEditingController(text: totalWeight.toString());
              // total= _Ratecharge;
              // _chargeableWeightController =TextEditingController(text: grossWeight.toString());
              total =
                  chargeableWeight * rateCharge;
                  //_ChargeWeight * _Ratecharge;
              _totalController = TextEditingController(text: "".toString());
              // _totalController = TextEditingController(text: _Ratecharge.toString());
              print("Total Controller " + '$_totalController');
              _totalController = readOnly as TextEditingController;
              _chargeableWeightController = readOnly as TextEditingController;
              _piecesController = readOnly as TextEditingController;
              _grossWeightController = readOnly as TextEditingController;
              // total= _Ratecharge;

              // _chargeableWeightController =TextEditingController(text: grossWeight.toString());
              // _totalController = TextEditingController(text: "".toString());
              // print("Total Controller " + '$_totalController');
              // _totalController= readOnly as TextEditingController;
              // _chargeableWeightController= readOnly as TextEditingController;
            });
            // _getTotal();
          }
        }
        if (autocalc == "Gross, Charg, total") {
          if (rateclass == 'M' || rateclass == 'B') {
            setState(() {
              _piecesController = TextEditingController(text: tottotPieces.toString());
              int pg = piece * weight;
              _grossWeightController =
                  TextEditingController(text: totalWeight.toString());
              // total= _Ratecharge;
              //    _chargeableWeightController =TextEditingController(text: grossWeight.toString());
              // _chargeableWeightController = TextEditingController(
              //     text: double.parse(volumetricw).ceil().toString());
              if (double.parse(volumetricw) > totalWeight) {
                _chargeableWeightController = TextEditingController(
                    text: double.parse(volumetricw).ceil().toString());
                // _grossWeightController =
                //     TextEditingController(text: grossWeight.ceil().toString());
              }
              else{
                // _chargeableWeightController = TextEditingController(
                //     text: grossWeight.ceil().toString());
                // total= _Ratecharge;
                _chargeableWeightController =TextEditingController(text: totalWeight.toString());
              }
              // _chargeableWeightController = TextEditingController(
              //     text: totalWeight.toString());
              _totalController =
                  TextEditingController(text:
                  //_Ratecharge
                      rateCharge.toString());
              print("Total Controller " + '$_totalController');
              _totalController = readOnly as TextEditingController;
              _grossWeightController = readOnly as TextEditingController;
              _piecesController = readOnly as TextEditingController;
              //_chargeableWeightController= readOnly as TextEditingController;
            });
          } else if (rateclass == 'Q' ||
              rateclass == 'N' ||
              rateclass == 'C' ||
              rateclass == 'K') {
            setState(() {
              _piecesController = TextEditingController(text: tottotPieces.toString());
              //String pw = (piece * weight) as String;
              int pg = piece * weight;
              _grossWeightController =
                  TextEditingController(text: totalWeight.toString());
              // total= _Ratecharge;
              if (double.parse(volumetricw) > totalWeight) {
                _chargeableWeightController = TextEditingController(
                    text: double.parse(volumetricw).ceil().toString());
                // _grossWeightController =
                //     TextEditingController(text: grossWeight.ceil().toString());
              }
              else{
                // _chargeableWeightController = TextEditingController(
                //     text: grossWeight.ceil().toString());
                // total= _Ratecharge;
                _chargeableWeightController =TextEditingController(text: totalWeight.toString());
              }
              // _chargeableWeightController = TextEditingController(
              //     text: double.parse(volumetricw).ceil().toString());

              // _chargeableWeightController = TextEditingController(
              //     text: totalWeight.toString());
              total =
                  //totalWeight 
                    int.parse(_chargeableWeightController.text)  * rateCharge;
                  //_ChargeWeight * _Ratecharge;
              _totalController = TextEditingController(text: total.toString());
              // _totalController = TextEditingController(text: _Ratecharge.toString());
              print("Total Controller " + '$_totalController');
              _totalController = readOnly as TextEditingController;
              _grossWeightController = readOnly as TextEditingController;

              _chargeableWeightController = readOnly as TextEditingController;
            });
            // _getTotal();
          } else if (rateclass == 'Y' ||
              rateclass == 'X' ||
              rateclass == 'E' ||
              rateclass == 'U' ||
              rateclass == 'S' ||
              rateclass == 'R' ||
              rateclass == 'W') {
            setState(() {
              _piecesController = TextEditingController(text: tottotPieces.toString());
              int pg = piece * weight;
              _grossWeightController =
                  TextEditingController(text: totalWeight.toString());
              // total= _Ratecharge;
              // _chargeableWeightController = TextEditingController(
              //     text: double.parse(volumetricw).ceil().toString());
              if (double.parse(volumetricw) > totalWeight) {
                _chargeableWeightController = TextEditingController(
                    text: double.parse(volumetricw).ceil().toString());
                // _grossWeightController =
                //     TextEditingController(text: grossWeight.ceil().toString());
              }
              else{
                // _chargeableWeightController = TextEditingController(
                //     text: grossWeight.ceil().toString());
                // total= _Ratecharge;
                _chargeableWeightController =TextEditingController(text: totalWeight.toString());
              }
              // _chargeableWeightController = TextEditingController(
              //     text: totalWeight.toString());
              _totalController = TextEditingController(text: "".toString());
              print("Total Controller " + '$_totalController');
              _totalController = readOnly as TextEditingController;
              _chargeableWeightController = readOnly as TextEditingController;
              _grossWeightController = readOnly as TextEditingController;
            });
            // _getTotal();
          }
        }
      }
    }
  }
}
class MenuItem {
  String RateClassCode;
  String name;

  MenuItem(this.RateClassCode, this.name);
}

