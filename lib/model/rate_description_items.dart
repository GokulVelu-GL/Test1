import 'package:flutter/foundation.dart';

import 'dimension_item.dart';

class RateDescriptionItem with ChangeNotifier {
  // Information
  int pieces;
  double grossWeight;
  String grossWeightUnit;
  String serviceCode;
  String rateClass;
  int itemNumber;
  int chargeableWeight;
  int rateCharge;
  int total;
  String autoCalculations;
  List<DimensionItem> dimList = List<DimensionItem>();
  // Nature and quantity of goods
  String natureAndQuantity;
   List<Map<String, dynamic>> dimensionsList = List<Map<String, dynamic>>();

//  get dimensionsList => _dimensionsList;
//
//  set dimensionsList(data) {
//    _dimensionsList = data;
//    notifyListeners();
//  }

  // Extra description
  String text;

  int width;
  int length;
  String unit;
  String volume;
  bool isExpanded;
  int dimpieces;
  int height;
  String row="";
  int dimweight;
  String lwhunit;
  String pwunit;
  String slac;
  String previousnatureofgoods;


  RateDescriptionItem(
//      this._dimensionsList,
      {this.isExpanded = false,
      this.pieces = 0,
      this.grossWeight = 0.0,
      this.grossWeightUnit = "",
      this.rateClass = "",
      this.itemNumber = 0,
      this.serviceCode = "",
      this.chargeableWeight = 0,
      this.rateCharge = 0,
      this.total = 0,
      this.autoCalculations = "",
      this.natureAndQuantity = "",
      this.dimensionsList,
      this.text = "",
        this.width,
        this.length,
        this. unit,
        this. volume,
        this.dimpieces,
        this.height, this.slac,
        this.previousnatureofgoods

      });
  RateDescriptionItem.fromJson(Map<String, dynamic> json)
      : pieces = json['Pieces'],
        grossWeight = json['Grossweight'],
        grossWeightUnit = json['Weight_Code'],
        serviceCode = json['Servicecode'],
        rateClass = json['Rateclass'],
        itemNumber = json['Itemnumber'],
        chargeableWeight = json['Chargeableweight'],
        rateCharge = json['RateorCharge'],
        total = json['Total'],
        natureAndQuantity = json['Description'];

        // length = json['length'],
        // width=json['width'],
        // height=json['height'],
        // lwhunit=json['lwhUnit'],
        // dimpieces=json['pieces'],
        // pwunit=json['pwUnit'],
        // dimweight=json['weight'];

        // text = json['Description'];

  //     "Pieces": "4",
  //     "Grossweight": "40",
  //     "Weight_Code": "K",
  //     "Servicecode": "H",
  //     "Rateclass": "Q",
  //     "Itemnumber": "12321",
  //     "Chargeableweight": "40",
  //     "RateorCharge": "45",
  //     "Total": "1800",
  //     "Description":
  //         "CONSOLIDATION \nOrigin:MV\nSLAC:5\nVolume:10CM3\n11X11X11MMT/4 40K\n"
  //   }

  Map<String, dynamic> toJson() {

    // model.summaryratedescription();
    String totdim="";
    for(int i = 0; i <dimensionsList.length; i++)
    {
      totdim += dimensionsList[i]['length'].toString() + "X" +
          dimensionsList[i]['width'].toString() + "X" +
          dimensionsList[i]['height'].toString() + "X" +
          dimensionsList[i]['lwhUnit'].toString() + ", " +
          dimensionsList[i]['pieces'].toString()+" "+
          dimensionsList[i]['weight'].toString() +
          dimensionsList[i]['pwUnit'].toString() + "\n";
    }
    dimensionsList.length.toInt()==0?totdim="NO DIMENSIONS AVAILABLE\n":
    // "SLAC "+slac+"\n"+
        totdim;
        // +"\nVOLUME "+volume.toUpperCase();
    return {

      'Pieces': pieces,
      'Grossweight': grossWeight,
      'Weight_Code': grossWeightUnit,
      'Servicecode': serviceCode,
      'Rateclass': rateClass,
      'Itemnumber': itemNumber,
      'Chargeableweight': chargeableWeight,
      'RateorCharge': rateCharge,
      'Total': total,
      'Description':
        natureAndQuantity + "\n"+
            "SLAC "+slac+"\n"+
            totdim
            +"VOLUME "+volume.toUpperCase(),
            // dimensionsList[i]['length'].toString() + "X" +
            // dimensionsList[i]['width'].toString() + "X" +
            // dimensionsList[i]['height'].toString() + "X" +
            // dimensionsList[i]['lwhUnit'].toString() + "X" +
            // dimensionsList[i]['pieces'].toString() + "  "
    // dimensionsList[1]['length'] .toString()+"X"+
    // dimensionsList[1]['width'] .toString()+"X"+
    // dimensionsList[1]['height'] .toString()+"X"+
    // dimensionsList[1]['lwhUnit'] .toString()+"X"+
    // dimensionsList[1]['pieces'] .toString()+" "

            // +dList()+row
            //+
            // "\n"+"VOLUME:"+volume
            // +"\n"+dimpieces.toString()
           // +"\nDIMS "+length.toString()+" x "+width.toString()+" x "+height.toString()+unit.toUpperCase()+" x "+ dimpieces.toString()
        //  "TEXTILES \nOrigin:MV\nSLAC:5\nVolume:10CM3\n11X11X11MMT/$pieces $grossWeight$grossWeightUnit\n",
    };


  }
  dList(){
    dimList.forEach((element) {
     row +=element.height.toString()+element.width.toString()+element.length.toString()+element.lwhunit.toString()+"\n";
    });
  }
  }

