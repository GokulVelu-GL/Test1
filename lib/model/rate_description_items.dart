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
 // String RateDescriptionOrigin;
  String previousnatureofgoods;
  String uldtype;
  String uldserial;
  String uldownercode;
  String HSCode;
  String origin;



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
        this.previousnatureofgoods,
        this.uldtype,
        this.uldserial,
        this.uldownercode,
        this.HSCode,
       // this.RateDescriptionOrigin,
        this.origin


      });
  RateDescriptionItem.fromJson(Map<String, dynamic> json)
      : pieces = int.tryParse(json['Pieces'].toString()),
        grossWeight = double.tryParse(json['Grossweight'].toString()),
        grossWeightUnit = json['Weight_Code'],
        serviceCode = json['Servicecode'],
        rateClass = json['Rateclass'],
        itemNumber = int.tryParse(json['Itemnumber'].toString()),
        chargeableWeight =
        //json['Chargeableweight'],
        int.tryParse(json['Chargeableweight'].toString()),
        rateCharge =
        //json['RateorCharge'],
        int.tryParse(json['RateorCharge'].toString()),
        total =
        //json['Total'],
        int.tryParse(json['Total'].toString()),
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
    String totdim = "";
    List<String> words = volume.split(" ");
    print("volume type");
    print(words[1].toString());
    for(int i = 0; i <dimensionsList.length; i++)
    {
      totdim += dimensionsList[i]['length'].toString() + "X" +
          dimensionsList[i]['width'].toString() + "X" +
          dimensionsList[i]['height'].toString() + " " +
          dimensionsList[i]['lwhUnit'].toString() + " " +
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
        natureAndQuantity,

      //+ "\n"+
       //     "SLAC "+slac+"\n"+
          //  totdim,
      //"VOLUME "+volume.toUpperCase(),
         "Volumetype": words[1].toString(),
          "Origin":
          //"ORIGIN: "+
              origin,
          "Volume":
          //"VOLUME: "+
             words[0].toString(),
          "SLAC":
         // "SLAC: "+
              slac,

      "DimensionsRateDescription": [
    // for(int i = 0; i <dimensionsList.length; i++)
    // {
    //   // totdim += dimensionsList[i]['length'].toString() + "X" +
    //   //     dimensionsList[i]['width'].toString() + "X" +
    //   //     dimensionsList[i]['height'].toString() + " " +
    //   //     dimensionsList[i]['lwhUnit'].toString() + " " +
    //   //     dimensionsList[i]['pieces'].toString()+" "+
    //   //     dimensionsList[i]['weight'].toString() +
    //   //     dimensionsList[i]['pwUnit'].toString() + "\n"
    //     "Length":  dimensionsList[i]['length'].toString(),
    //     "Width":  dimensionsList[i]['width'].toString(),
    //     "Height":   dimensionsList[i]['height'].toString(),
    //     "HeightCode":  dimensionsList[i]['lwhUnit'].toString(),
    //     "Pieces_dim":    dimensionsList[i]['pieces'].toString(),
    //     "Weight":  dimensionsList[i]['weight'].toString(),
    //     "WeightCode":   dimensionsList[i]['pwUnit'].toString()
    // }
            {
              "Length": "10",
              "Width": "20",
              "Height":"30",
              "HeightCode": "cm",
              "Pieces_dim": "10",
              "Weight": "100",
              "WeightCode": "K"
            }
          ],

      "ULDRateDescription": [
        {
       "Type1": uldtype,
       "Serial1": uldserial,
       "Ownercode1": uldownercode
        }
          ],
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

