import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rooster/model/dimension_item.dart';
import 'package:rooster/model/eawb_models/accounting_information_model.dart';
import 'package:rooster/model/eawb_models/awb_consigment_details_model.dart';
import 'package:rooster/model/eawb_models/carriers_execution_model.dart';
import 'package:rooster/model/eawb_models/cc_charges_in_destination_currency_model.dart';
import 'package:rooster/model/eawb_models/charges_declaration_model.dart';
import 'package:rooster/model/eawb_models/charges_summary_model.dart';
import 'package:rooster/model/eawb_models/consignee_model.dart';
import 'package:rooster/model/eawb_models/handling_information_model.dart';
import 'package:rooster/model/eawb_models/issuer_model.dart';
import 'package:rooster/model/eawb_models/notify_model.dart';
import 'package:rooster/model/eawb_models/optional_shipping_information_model.dart';
import 'package:rooster/model/eawb_models/other_charges_model.dart';
import 'package:rooster/model/eawb_models/rate_description_model.dart';
import 'package:rooster/model/eawb_models/routing_and_flight_bookings_model.dart';
import 'package:rooster/model/eawb_models/shippers_certification_model.dart';
import 'package:rooster/model/eawb_models/special_handling_details_model.dart';
import 'package:rooster/model/rate_description_items.dart';
import 'package:rooster/string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import 'dimensons_model.dart';
import 'eawb_models/issuing_carriers_agent_model.dart';
import 'eawb_models/shipper_model.dart';
import 'other_charges_items.dart';

class EAWBModel
    with
        ChangeNotifier,
        ShipperModel, // 1
        ConsigneeModel, // 2
        IssuingCarriersAgentModel, // 3
        AWBConsigmentDetailsModel, // 4
        NotifyModel,
        RoutingAndFlightBookingsModel, // 5
        IssuerModel, // 6
        AccountingInformationModel, // 7
        OptionalShippingInformationModel, // 8
        ChargesDeclarationModel, // 9
        HandlingInformationModel, // 10
        RateDescriptionModel, // 11
        ChargesSummaryModel, // 12
        CcChargesInDestinationCurrencyModel, // 13
        OtherChargesModel, // 14
        ShippersCertificationModel, // 15
        CarriersExecutionModel, // 16
        NotifyModel,
        SpecialHandlingModel {
  void addOtherChargesItem(OtherChargesItem item) {
    otherChargesList.add(item);
    int dueAgentPrepaid = 0;
    int dueAgentPostpaid = 0;
    int carrierAgentPrepaid = 0;
    int carrierAgentPostpaid = 0;
    int totalCalc = 0;

    otherChargesList.forEach((element) {
      totalCalc = element.amount;
      // if (chargesDeclarationOtherCharges == 'PPD') {
      //   chargeSummaryTotalPrepaid  = totalCalc.toString();
      // } else {
      //   chargeSummaryTotalPostpaid += totalCalc.toString();
      // }
      if (element.entitlement == 'Due agent') {
        if (chargesDeclarationOtherCharges == "PPD") {
          dueAgentPrepaid += element.amount;
          chargeSummaryDueAgentPrepaid = dueAgentPrepaid.toString();
        }
        if (chargesDeclarationOtherCharges == 'COLL') {
          dueAgentPostpaid += element.amount;
          chargeSummaryDueAgentPostpaid = dueAgentPostpaid.toString();
        }
      } else {
        if (chargesDeclarationOtherCharges == "PPD") {
          carrierAgentPrepaid += element.amount;
          chargeSummaryDueCarrierPrepaid = carrierAgentPrepaid.toString();
        }
        if (chargesDeclarationOtherCharges == 'COLL') {
          carrierAgentPostpaid += element.amount;
          chargeSummaryDueCarrierPostpaid = carrierAgentPostpaid.toString();
        }
      }
    });
    if (chargesDeclarationOtherCharges == 'PPD') {
      chargeSummaryTotalPrepaid  = (int.parse(chargeSummaryTotalPrepaid)+totalCalc).toString();

    }
    if(chargesDeclarationOtherCharges == 'COLL') {
       // chargeSummaryTotalPrepaid  = (int.parse(chargeSummaryTotalPrepaid)-totalCalc).toString();
      chargeSummaryTotalPostpaid =(int.parse(chargeSummaryTotalPostpaid)+ totalCalc).toString();
    }

    notifyListeners();
  }
  // void addOtherChargesItem(OtherChargesItem item) {
  //   otherChargesList.add(item);
  //   int dueAgentPrepaid = 0;
  //   int dueAgentPostpaid = 0;
  //   int carrierAgentPrepaid = 0;
  //   int carrierAgentPostpaid = 0;
  //   int totalCalc = 0;
  //   int totalCalcPost=0;
  //   int totprepaid=0;
  //   int totpostpaid=0;
  //   int initialprepaid;
  //   String prestatus;
  //   String poststatus;
  //   otherChargesList.forEach((element) {
  //
  //
  //     //totalCalc += element.amount;
  //     print("total calc"+totalCalc.toString());
  //     if (element.entitlement == 'Due agent') {
  //       if (element.prepaidcollect=="PPD") {
  //         prestatus=element.prepaidcollect;
  //         totalCalc=element.amount;
  //         print("ini"+chargeSummaryTotalPrepaid);
  //         dueAgentPrepaid += element.amount;
  //
  //         if(totprepaid==0) {
  //           totprepaid = 0;
  //           print("000" + totprepaid.toString());
  //         } else {
  //           totprepaid -= element.amount;
  //           print("ballance"+totprepaid.toString());
  //         }
  //         print("preprepaid "+totprepaid.toString()+"element"+element.amount.toString());
  //         // chargeSummaryTotalPostpaid+=  (int.parse(
  //         //     chargeSummaryTotalPostpaid)+element.amount)
  //         // // ) -totprepaid)
  //         //      .toString()
  //         //     ;
  //         print(chargeSummaryTotalPostpaid);
  //         print(totprepaid);
  //         chargeSummaryDueAgentPrepaid = dueAgentPrepaid.toString();
  //         // chargeSummaryTotalPostpaid = chargeSummaryTotalPostpaid;
  //         //
  //         //  (int.parse(
  //         //      chargeSummaryTotalPostpaid) + totprepaid
  //         //      //element.amount
  //         // ).toString();
  //         //  totprepaid-=element.amount;
  //       }
  //       if (element.prepaidcollect=="COLL") {
  //         prestatus=element.prepaidcollect;
  //         // print(" post status"+poststatus);
  //         totalCalcPost=element.amount;
  //         print("ini"+chargeSummaryTotalPrepaid);
  //         dueAgentPostpaid += element.amount;
  //
  //         // totpostpaid+= element.amount;
  //         chargeSummaryDueAgentPostpaid = dueAgentPostpaid.toString();
  //         if(totpostpaid==0) {
  //           totpostpaid = 0;
  //           print("000" + totprepaid.toString());
  //         } else {
  //           totpostpaid -= element.amount;
  //           print("ballance post "+totpostpaid.toString());
  //         }
  //         print("pOSTprepaid "+totprepaid.toString()+" POSTelement "+element.amount.toString());
  //         // chargeSummaryTotalPostpaid =(int.parse(chargeSummaryTotalPostpaid)
  //         //     + element.amount
  //         // ).toString();
  //       }
  //     } else {
  //       if (element.prepaidcollect=="PPD") {
  //         prestatus=element.prepaidcollect;
  //         totalCalc=element.amount;
  //         print("ini"+chargeSummaryTotalPrepaid);
  //         carrierAgentPrepaid += element.amount;
  //         // totprepaid+= element.amount;
  //         chargeSummaryDueCarrierPrepaid = carrierAgentPrepaid.toString();
  //         if(totprepaid==0) {
  //           totprepaid = 0;
  //           print("000" + totprepaid.toString());
  //         } else {
  //           totprepaid -= element.amount;
  //           print("ballance"+totprepaid.toString());
  //         }
  //         print("preprepaid "+totprepaid.toString()+"element"+element.amount.toString());
  //         // chargeSummaryTotalPostpaid =(int.parse(chargeSummaryTotalPostpaid)
  //         //     // + element.amount
  //         // ).toString();
  //       }
  //       if (element.prepaidcollect=="COLL") {
  //         prestatus=element.prepaidcollect;
  //         totalCalcPost=element.amount;
  //         print("ini"+chargeSummaryTotalPrepaid);
  //         carrierAgentPostpaid += element.amount;
  //
  //         // totpostpaid+= element.amount;
  //
  //         chargeSummaryDueCarrierPostpaid = carrierAgentPostpaid.toString();
  //         if(totpostpaid==0) {
  //           totpostpaid = 0;
  //           print("000" + totprepaid.toString());
  //         } else {
  //           totpostpaid -= element.amount;
  //           print("ballance post "+totpostpaid.toString());
  //         }
  //         print("pOSTprepaid "+totprepaid.toString()+" POSTelement "+element.amount.toString());
  //         // chargeSummaryTotalPostpaid =(int.parse(chargeSummaryTotalPostpaid)
  //         //     // + element.amount
  //         // ).toString();
  //       }
  //     }
  //
  //     // if (
  //     // //chargesDeclarationOtherCharges
  //     // element.prepaidcollect  == 'PPD') {
  //     //   (totprepaid==0)?
  //     //   chargeSummaryTotalPrepaid =(int.parse(chargeSummaryTotalPrepaid)
  //     //     //  +initialprepaid
  //     //        + element.amount
  //     //   ).toString():
  //     //   chargeSummaryTotalPrepaid =(int.parse(chargeSummaryTotalPrepaid)
  //     //          + element.amount
  //     //       - totprepaid
  //     //   ).toString();
  //     //   print("1Prepaid "+totprepaid.toString()+" "+chargeSummaryTotalPrepaid);
  //     // }
  //     //else {
  //     //   // chargeSummaryTotalPostpaid = totalCalc.toString();
  //     //   chargeSummaryTotalPostpaid =(int.parse(chargeSummaryTotalPostpaid)
  //     //       + element.amount
  //     //   ).toString();
  //     //   print("Postpaid "+chargeSummaryTotalPostpaid);
  //     // }
  //   });
  //   print(poststatus);
  //   // if(prestatus == 'PPD'){
  //   //   totalCalcPost=0;
  //   // }
  //   // if(poststatus=="COLL"){
  //   //   totalCalc=0;
  //   // }
  //   if (
  //   //chargesDeclarationOtherCharges
  //   prestatus == 'PPD') {
  //     print("Pre change"+totalCalc.toString());
  //     (totprepaid==0)?
  //     chargeSummaryTotalPrepaid =(int.parse(chargeSummaryTotalPrepaid)
  //         //  +initialprepaid
  //         + totalCalc- totprepaid
  //     ).toString():
  //     chargeSummaryTotalPrepaid =(int.parse(chargeSummaryTotalPrepaid)
  //         + totalCalc
  //         - totprepaid
  //     ).toString();
  //     print("1Prepaid "+totprepaid.toString()+" "+chargeSummaryTotalPrepaid);
  //   }
  //   if(prestatus=="COLL"){
  //     // print("COLL  ............"+poststatus);
  //     (totpostpaid==0)?
  //     chargeSummaryTotalPostpaid =(int.parse(chargeSummaryTotalPostpaid)
  //         //  +initialprepaid
  //         + totalCalcPost -totpostpaid
  //     ).toString():
  //     // chargeSummaryTotalPostpaid = totalCalc.toString();
  //     chargeSummaryTotalPostpaid =(int.parse(chargeSummaryTotalPostpaid)
  //         +totalCalcPost
  //         -totpostpaid
  //         // + element.amount
  //     ).toString();
  //     print("Postpaid "+chargeSummaryTotalPostpaid);
  //   }
  //   notifyListeners();
  // }

  void deleteOtherChargesItem(OtherChargesItem item) {
    int dueAgentPrepaid = 0;
    int dueAgentPostpaid = 0;
    int carrierAgentPrepaid = 0;
    int carrierAgentPostpaid = 0;
    int totalCalc = 0;
    int totalCalcPost=0;
    int totprepaid=0;
    int totpostpaid=0;
    int initialprepaid;
    String prestatus;
    String poststatus;
    otherChargesList.forEach((element) {


      //totalCalc += element.amount;
      print("total calc"+totalCalc.toString());
      if (element.entitlement == 'Due agent') {
        if (element.prepaidcollect=="PPD") {
          prestatus=element.prepaidcollect;
          totalCalc=element.amount;
          print("ini"+chargeSummaryTotalPrepaid);
          dueAgentPrepaid =(dueAgentPrepaid==0)?dueAgentPrepaid=dueAgentPrepaid:dueAgentPrepaid-= element.amount;

          if(totprepaid==0) {
            totprepaid = 0;
            print("000" + totprepaid.toString());
          } else {
            totprepaid -= element.amount;
            print("ballance"+totprepaid.toString());
          }
          print("preprepaid "+totprepaid.toString()+"element"+element.amount.toString());
          // chargeSummaryTotalPostpaid+=  (int.parse(
          //     chargeSummaryTotalPostpaid)+element.amount)
          // // ) -totprepaid)
          //      .toString()
          //     ;
          print(chargeSummaryTotalPostpaid);
          print(totprepaid);
          chargeSummaryDueAgentPrepaid = dueAgentPrepaid.toString();
          // chargeSummaryTotalPostpaid = chargeSummaryTotalPostpaid;
          //
          //  (int.parse(
          //      chargeSummaryTotalPostpaid) + totprepaid
          //      //element.amount
          // ).toString();
          //  totprepaid-=element.amount;
        }
        if (element.prepaidcollect=="COLL") {
          prestatus=element.prepaidcollect;
          // print(" post status"+poststatus);
          totalCalcPost=element.amount;
          print("ini"+chargeSummaryTotalPrepaid);
          // dueAgentPostpaid -= element.amount;
          dueAgentPostpaid =(dueAgentPostpaid==0)?dueAgentPostpaid=dueAgentPostpaid:dueAgentPostpaid-= element.amount;


          // totpostpaid+= element.amount;
          chargeSummaryDueAgentPostpaid = dueAgentPostpaid.toString();
          if(totpostpaid==0) {
            totpostpaid = 0;
            print("000" + totprepaid.toString());
          } else {
            totpostpaid -= element.amount;
            print("ballance post "+totpostpaid.toString());
          }
          print("pOSTprepaid "+totprepaid.toString()+" POSTelement "+element.amount.toString());
          // chargeSummaryTotalPostpaid =(int.parse(chargeSummaryTotalPostpaid)
          //     + element.amount
          // ).toString();
        }
      } else {
        if (element.prepaidcollect=="PPD") {
          prestatus=element.prepaidcollect;
          totalCalc=element.amount;
          print("ini"+chargeSummaryTotalPrepaid);
          // carrierAgentPrepaid += element.amount;
          carrierAgentPrepaid =(carrierAgentPrepaid==0)?carrierAgentPrepaid=carrierAgentPrepaid:carrierAgentPrepaid-= element.amount;
          // totprepaid+= element.amount;
          chargeSummaryDueCarrierPrepaid = carrierAgentPrepaid.toString();
          if(totprepaid==0) {
            totprepaid = 0;
            print("000" + totprepaid.toString());
          } else {
            totprepaid -= element.amount;
            print("ballance"+totprepaid.toString());
          }
          print("preprepaid "+totprepaid.toString()+"element"+element.amount.toString());
          // chargeSummaryTotalPostpaid =(int.parse(chargeSummaryTotalPostpaid)
          //     // + element.amount
          // ).toString();
        }
        if (element.prepaidcollect=="COLL") {
          prestatus=element.prepaidcollect;
          totalCalcPost=element.amount;
          print("ini"+chargeSummaryTotalPrepaid);
          carrierAgentPostpaid += element.amount;
          carrierAgentPostpaid =(carrierAgentPostpaid==0)?carrierAgentPostpaid=carrierAgentPostpaid:carrierAgentPostpaid-= element.amount;

          // totpostpaid+= element.amount;

          chargeSummaryDueCarrierPostpaid = carrierAgentPostpaid.toString();
          if(totpostpaid==0) {
            totpostpaid = 0;
            print("000" + totprepaid.toString());
          } else {
            totpostpaid -= element.amount;
            print("ballance post "+totpostpaid.toString());
          }
          print("pOSTprepaid "+totprepaid.toString()+" POSTelement "+element.amount.toString());
          // chargeSummaryTotalPostpaid =(int.parse(chargeSummaryTotalPostpaid)
          //     // + element.amount
          // ).toString();
        }
      }

      // if (
      // //chargesDeclarationOtherCharges
      // element.prepaidcollect  == 'PPD') {
      //   (totprepaid==0)?
      //   chargeSummaryTotalPrepaid =(int.parse(chargeSummaryTotalPrepaid)
      //     //  +initialprepaid
      //        + element.amount
      //   ).toString():
      //   chargeSummaryTotalPrepaid =(int.parse(chargeSummaryTotalPrepaid)
      //          + element.amount
      //       - totprepaid
      //   ).toString();
      //   print("1Prepaid "+totprepaid.toString()+" "+chargeSummaryTotalPrepaid);
      // }
      //else {
      //   // chargeSummaryTotalPostpaid = totalCalc.toString();
      //   chargeSummaryTotalPostpaid =(int.parse(chargeSummaryTotalPostpaid)
      //       + element.amount
      //   ).toString();
      //   print("Postpaid "+chargeSummaryTotalPostpaid);
      // }
    });
    print(poststatus);
    // if(prestatus == 'PPD'){
    //   totalCalcPost=0;
    // }
    // if(poststatus=="COLL"){
    //   totalCalc=0;
    // }
    if (
    //chargesDeclarationOtherCharges
    prestatus == 'PPD') {
      print("Pre change"+totalCalc.toString());
      (totprepaid==0)?
      chargeSummaryTotalPrepaid =(int.parse(chargeSummaryTotalPrepaid)
          //  +initialprepaid
          - totalCalc+ totprepaid
      ).toString():
      chargeSummaryTotalPrepaid =(int.parse(chargeSummaryTotalPrepaid)
          - totalCalc
          + totprepaid
      ).toString();
      print("1Prepaid "+totprepaid.toString()+" "+chargeSummaryTotalPrepaid);
    }
    if(prestatus=="COLL"){
      // print("COLL  ............"+poststatus);
      (totpostpaid==0)?
      chargeSummaryTotalPostpaid =(int.parse(chargeSummaryTotalPostpaid)
          //  +initialprepaid
          - totalCalcPost -totpostpaid
      ).toString():
      // chargeSummaryTotalPostpaid = totalCalc.toString();
      chargeSummaryTotalPostpaid =(int.parse(chargeSummaryTotalPostpaid)
          -totalCalcPost
          -totpostpaid
          // + element.amount
      ).toString();
      print("Postpaid "+chargeSummaryTotalPostpaid);
    }

    // int dueAgentPrepaid = 0;
    // int dueAgentPostpaid = 0;
    // int carrierAgentPrepaid = 0;
    // int carrierAgentPostpaid = 0;
    // int totalCalc = 0;
    // int totprepaid=0;
    // int totpostpaid=0;

    // otherChargesList.remove(item);
    // otherChargesList.forEach((element) {
    //   totalCalc -= element.amount;
    //   if (element.entitlement == 'Due agent') {
    //     if (
    //     //chargesDeclarationOtherCharges == "PPD"&&
    //         element.prepaidcollect=="PPD") {
    //       if (totprepaid == 0) {
    //         dueAgentPrepaid = element.amount;
    //       } else
    //       {  print("remove prepid " + (element.amount).toString());
    //       totprepaid -= element.amount;
    //       dueAgentPrepaid = totprepaid;
    //
    //       chargeSummaryDueAgentPrepaid = dueAgentPrepaid.toString();
    //     }
    //     }
    //     if (
    //     //chargesDeclarationOtherCharges == 'COLL'&&
    //         element.prepaidcollect=="COLL") {
    //       if (totpostpaid == 0) {
    //         dueAgentPostpaid = element.amount;
    //       }else
    //       totpostpaid -= element.amount;
    //       chargeSummaryDueAgentPostpaid = dueAgentPostpaid.toString();
    //     }
    //   } else {
    //     if (
    //     //chargesDeclarationOtherCharges == "PPD"&&
    //         element.prepaidcollect=="PPD") {
    //
    //       totprepaid-= element.amount;
    //       carrierAgentPrepaid = totprepaid;
    //       print(element.amount+totprepaid);
    //       chargeSummaryDueCarrierPrepaid = carrierAgentPrepaid.toString();
    //     }
    //     if (
    //     //chargesDeclarationOtherCharges == 'COLL'&&
    //         element.prepaidcollect=="COLL") {
    //       carrierAgentPostpaid -= element.amount;
    //       chargeSummaryDueCarrierPostpaid = carrierAgentPostpaid.toString();
    //     }
    //   }
    //   if (
    //   //chargesDeclarationOtherCharges
    //      element.prepaidcollect == 'PPD') {
    //     chargeSummaryTotalPrepaid =(int.parse(chargeSummaryTotalPrepaid)-element.amount).toString();
    //         //totalCalc.toString();
    //   } else {
    //     chargeSummaryTotalPostpaid = (int.parse(chargeSummaryTotalPrepaid)-element.amount).toString();
    //   }
    // });
    // otherChargesList.forEach((element) {

    //   totalCalc += element.amount;
    //   print("total calc"+totalCalc.toString());
    //   if (element.entitlement == 'Due agent') {
    //     if (element.prepaidcollect=="PPD") {
    //       (dueAgentPrepaid==0)?dueAgentPrepaid=element.amount:dueAgentPrepaid -= element.amount;
    //       totprepaid+= element.amount;
    //       chargeSummaryDueAgentPrepaid = dueAgentPrepaid.toString();
    //     }
    //     if (element.prepaidcollect=="COLL") {
    //       (dueAgentPostpaid==0)?dueAgentPostpaid = element.amount:dueAgentPostpaid -= element.amount;
    //       totpostpaid+= element.amount;
    //       chargeSummaryDueAgentPostpaid = dueAgentPostpaid.toString();
    //     }
    //   } else {
    //     if (element.prepaidcollect=="PPD") {
    //       (carrierAgentPrepaid==0)?carrierAgentPrepaid=element.amount:carrierAgentPrepaid -= element.amount;
    //       totprepaid+= element.amount;
    //       chargeSummaryDueCarrierPrepaid = carrierAgentPrepaid.toString();
    //     }
    //     if (element.prepaidcollect=="COLL") {
    //       (carrierAgentPostpaid==0)?carrierAgentPostpaid=element.amount:carrierAgentPostpaid -= element.amount;
    //       totpostpaid+= element.amount;
    //       chargeSummaryDueCarrierPostpaid = carrierAgentPostpaid.toString();
    //     }
    //   }
    //
    //   if (
    //   //chargesDeclarationOtherCharges
    //   element.prepaidcollect  == 'PPD') {
    //     chargeSummaryTotalPrepaid =(int.parse(chargeSummaryTotalPrepaid)- element.amount).toString();
    //     print("Prepaid "+chargeSummaryTotalPrepaid);
    //   } else {
    //     // chargeSummaryTotalPostpaid = totalCalc.toString();
    //     chargeSummaryTotalPostpaid =(int.parse(chargeSummaryTotalPostpaid)- element.amount).toString();
    //     print("Postpaid "+chargeSummaryTotalPostpaid);
    //   }
    // });
    otherChargesList.remove(item);
    notifyListeners();
  }

  void summaryratedescription(){
    int total=0;
    // rateDescriptionItemList.forEach((element) {
    //   total+=element.total;
    // });
    // chargeSummaryWeightChargePrepaid=total.toString();
      int tott=0;
      int pt=0;
      rateDescriptionItemList.forEach((element) {
         pt= element.total;
        tott+=int.parse(element.total.toString());
        // int to=
        //     //int.parse(model.chargeSummaryWeightChargePrepaid)+
        //     tott;
        // print(to.toString());

        // model.chargeSummaryWeightChargePrepaid=to.toString();
        //

        print("chargesumm"+chargeSummaryWeightChargePrepaid);
        print("single"+pt.toString());

      });
      chargeSummaryWeightChargePrepaid=tott.toString();
      chargeSummaryTotalPrepaid=(int.parse(chargeSummaryTotalPrepaid)+pt).toString();
      // model.summaryratedescription();

  }
  void addRateDescriptionItem(RateDescriptionItem item) {
    rateDescriptionItemList.add(item);
    if(chargesDeclarationWTVALCharges=="PPD"){
      int weightchargepre=0;
      int totalpre =0;
      rateDescriptionItemList.forEach((element) {
        totalpre=element.total;
        weightchargepre+=element.total;
      });
      chargeSummaryWeightChargePrepaid=weightchargepre.toString();
      chargeSummaryTotalPrepaid=(int.parse(chargeSummaryTotalPrepaid)+totalpre).toString();
          //(int.parse(chargeSummaryWeightChargePrepaid)+weightchargepre).toString();
    }
    if(chargesDeclarationWTVALCharges=="COLL"){
      int weightchargepost=0;
      int totalpost=0;
      rateDescriptionItemList.forEach((element) {
        totalpost=element.total;
        weightchargepost+=element.total;
      });
      chargeSummaryWeightChargePostpaid=
      weightchargepost.toString();
      chargeSummaryTotalPostpaid=(int.parse(chargeSummaryTotalPostpaid)+totalpost).toString();
      //(int.parse(chargeSummaryWeightChargePostpaid)+weightchargepost).toString();
    }
    notifyListeners();
  }

  void deleteRateDescriptionItem(RateDescriptionItem item) {
    rateDescriptionItemList.remove(item);
    notifyListeners();
  }

  void clearEAWB() {
    clearShipperModel(); //1
    clearConsigneeModel(); //2
    clearIssuingCarriersAgentModel(); //3
    clearRoutingAndFlightBookingsModel(); //4
    clearAWBConsigmentDetailsModel(); //5
    clearNotify();
    clearIssuerModel(); //6
    clearAccountingInformationModel(); //6
    clearOptionalShippingInformationModel(); //7
    clearChargesDeclarationModel(); //8
    clearHandlingInformationModel(); //9
    clearRateDescriptionModel(); //10
    clearChargesSummaryModel(); //11
    clearCcChargesInDestinationCurrencyModel(); //12
    clearOtherChargesModel(); //13
    clearShippersCertificationModel(); //14
    clearCarriersExecutionModel(); //15
    clearSpecialHandlingModel();
    setStatus(); // setStatus ....
    notifyListeners();
  }

  void setStatus() {
    setStatusShipperModel();
    setStatusConsigneeModel();
    setStatusIssuingCarriersAgentModel();
    setStatusRoutingAndFlightBookingsModel();
    setStatusAWBConsigmentDetailsModel();
    setNotifyStatus();
    setStatusIssuerModel();
    setStatusAccountingInformationModel();
    setStatusOptionalShippingInformationModel();
    setStatusChargesDeclarationModel();
    setStatusHandlingInformationModel();
    setStatusRateDescriptionModel();
    setStatusChargesSummaryModel();
    setStatusCcChargesInDestinationCurrencyModel();
    setStatusOtherChargesModel();
    setStatusShippersCertificationModel();
    setStatusCarriersExecutionModel();
    setStatusSpecialHandlingDetailsModel();
    notifyListeners();
  }

  void refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(StringData.refreshTokenAPI,
        headers: {'x-access-tokens': prefs.getString('token')});
    var result = json.decode(response.body);
    if (result['result'] == 'verified')
      prefs.setString('token', result['token']);
  }

  Future<String> getEAWB(String eawbid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final url = Uri.parse(StringData.eawbbyid);
    final request = http.Request("GET", url);
    request.headers.addAll(<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-access-tokens': prefs.getString('token')
    });
    request.body = jsonEncode({"AWBList_id": eawbid});
    var eawbData;
    var res = await request.send();
    final responseData = await res.stream.bytesToString();
    eawbData = jsonDecode(responseData);
    print("Respstr ${responseData}");

    print(eawbid);
    print("@@@@@@@@@@@@@@@@@");
    if (eawbData['message'] == 'token expired') {
      refreshToken();
      getEAWB(eawbid);
    } else {
      var jsonData = eawbData["eawb"];

      if (jsonData.length != 0) {
        clearEAWB();
        jsonData = jsonData[0];
        //   if (eawbData['message'] == "Valid AWB Number") {
        String data;
        // ! 1 - Shipper....
        shipperAccountNumber = jsonData['Shipper_Account_Number'];
        // ! convert SHIPPER_NAME_AND_ADDRESS to name and address....
        //data = jsonData['SHIPPER_NAME_AND_ADDRESS'].replaceAll('\\n', '\n');
        shipperName = jsonData['Shipper_Name'];
        shipperAddress = jsonData['Shipper_Street_Address'];
        shipperPlace = jsonData['Shipper_Place'];
        shipperState = jsonData['Shipper_StateorProvince'];
        shipperCountryCode = jsonData['Shipper_Country_code'];
        shipperPostCode = jsonData['Shipper_Post_Code'];
        shipperContactType = jsonData['Shipper_Contact1_Type'];
        shipperContactNumber = jsonData['Shipper_Contact1_Number'];

        // ! 2 - Consignee....
        consigneeAccountNumber = jsonData['Consignee_Account_Number'];
        // ! convert CONSIGNEE_NAME_AND_ADDRESS to name and address....
        consigneeName = jsonData['Consignee_Name'];
        consigneeAddress = jsonData['Consignee_Street_Address'];
        consigneePlace = jsonData['Consignee_Place'];
        consigneeState = jsonData['Consignee_StateorProvince'];
        consigneeCountryCode = jsonData['Consignee_Country_code'];
        consigneePostCode = jsonData['Consignee_Post_Code'];
        consigneeContactType = jsonData['Consignee_Contact1_Type'];
        consigneeContactNumber = jsonData['Consignee_Contact1_Number'];

        // ! 3 - Issuing carrier's agent....
        // ! convert ISSUING_CARRIER_AGENT_NAME_AND_CITY to name and address
        // data = jsonData['Carrier_Agent_NameAndCity'].replaceAll('\\n', '\n');
        issuingCarrierAgentName = jsonData[
        'Carrier_Agent_NameAndCity']; //data.substring(0, data.indexOf('\n'));
        //issuingCarrierAgentCity = data.substring(data.indexOf('\n') + 2);
        issuingCarrierAgentPlace = jsonData['Carrier_Agent_Place'];
        issuingCarrierAgentCassAddress = jsonData['Carrier_Agent_CASS_Address'];
        issuingCarrierAgentIATACode = jsonData['Carrier_Agent_IATA_Code'];
        issuingCarrierAgentAccountNumber = jsonData['Carrier_Agent_Account_No'];

        // ! 4 - Routing and flight bookings....
        //routeAndFlightDeparture = jsonData['Routing_To'];
        routeAndFlightTo1 = jsonData['Routing_To1'];
        routeAndFlightBy1 = jsonData['Routing_By1'];
        routeAndFlightTo2 = jsonData['Routing_To2'];
        routeAndFlightBy2 = jsonData['Routing_By2'];
        referenceNumber = jsonData['Reference_Number'];
        information = jsonData['Information'];
        airline = jsonData['Airline'];
        flight = jsonData[' Flight'];
        date = jsonData['Date'];
        airline1 = jsonData['Airline1'];
        flight1 = jsonData['Flight1'];
        date1 = jsonData['Date1'];

        // ! 5- AWB consigment details....
        awbConsigmentDetailsAWBNumber = jsonData['Consigment_AWB_Prefix'] +
            jsonData['Consigment_Serial_Number'];
        //awbConsigmentDetailsDepAirportCode =
        // jsonData['DEPARTURE_AIRPORT_CODE'];

        awbConsigmentOriginPrefix = jsonData['Consigment_Origin_Prefix'];
        awbConsigmentDestination = jsonData['Consigment_Destination'];
        awbConsigmentPices = jsonData['Consigment_Number_Of_Pieces'];
        awbConsigmentWeightCode = jsonData['Consigment_Weight_Code'];
        awbConsigmentWeight = jsonData['Consigment_Weight'];
        awbConsigmentVolumeCode = jsonData['Consigment_Volume_Code'];
        awbConsigmentVolume = jsonData['Consigment_Volume'].toString();
        awbConsigmentDensity = jsonData['Consigment_Density_Group'];

        //notify model
        notifyName = jsonData['Notify_Name'];
        nofityStreetAddress = jsonData['Notify_Street_Address'];
        notifyPlace = jsonData['Notify_Place'];
        notifyState = jsonData['Notify_StateorProvince'];
        notifyCountryCode = jsonData['Notify_Country_code'];
        notifyPostCode = jsonData['Notify_Post_Code'];
        notifyContactType = jsonData['Notify_Contact1_Type'];
        notifyContactNumber = jsonData['Notify_Contact1_Number'];

        // // ! 6 - Issuer....
        issuerBy = jsonData['ISSUED_BY'];

        // // ! 7 - Accounting information....
        // accountingInformationDetails = jsonData['ACCOUNTING_INFORMATION'];

        // // ! 8 - Optional Shipping Information....
        // refNo1 = jsonData['REFERENCE_NUMBER_1'];
        // refNo2 = jsonData['REFERENCE_NUMBER_2'];
        // refNo3 = jsonData['REFERENCE_NUMBER_3'];

        SpecialServiceRequest = jsonData['Special_Service_Request'];
        OtherServiceInformation = jsonData['Other_Service_Information'];
        SCI = jsonData['Customs_origin_SCI_code'];

        // ! 9 - Charges declaration....
        chargesDeclarationCurrency = jsonData['Chargedec_Currency'];
        chargesDeclarationCHGSCode = jsonData['Chargedec_CHCG'];
        chargesDeclarationValueForCarriage =
        jsonData['Chargedec_Value_For_Carriage'].toString() == ""
            ? "NVD"
            : jsonData['Chargedec_Value_For_Carriage'];
        chargesDeclarationValueForCustoms =
        jsonData['Chargedec_Value_For_Customs'].toString() == ""
            ? "NCV"
            : jsonData['Chargedec_Value_For_Customs'];
        chargesDeclarationWTVALCharges = jsonData['Chargedec_WT_Or_VAL'];
        chargesDeclarationOtherCharges = jsonData['Chargedec_Other'];
        chargesDeclarationAmountOfInsurance =
        jsonData['Chargedec_Amount_Of_Insurance'].toString() == ""
            ? "NCV"
            : jsonData['Chargedec_Amount_Of_Insurance'];

        SPH1 = jsonData['SHC1'];
        SPH2 = jsonData['SHC2'];
        SPH3 = jsonData['SHC3'];
        SPH4 = jsonData['SHC4'];
        SPH5 = jsonData['SHC5'];
        SPH6 = jsonData['SHC6'];
        SPH7 = jsonData['SHC7'];
        SPH8 = jsonData['SHC8'];
        SPH9 = jsonData['SHC9'];

        // // ! 10 - Handling information....
        // handlingInformationRequirements = jsonData['REQUIREMENTS'];
        // handlingInformationSCI = jsonData['SCI'];

        // // TODO : 11 - Rate description (Add, Modify, remove)....
        // // TODO: NO_OF_PIECES_RCP_TOTAL.... [json array]....
        // // TODO: GROSS_WEIGHT_DESCRIPTION....
        // // TODO: GROSS_WEIGHT_TOTAL....
        // // TODO: KG_LB_TOTAL....
        // // TODO: NATURE_AND_QUANTITY_OF_GOODS_DESCRIPTION....
        // // TODO : TOTAL....

        // // ! 12 - Charges summary....
        chargeSummaryWeightChargePrepaid = jsonData['Prepaid_Weight_Charge'];
        chargeSummaryWeightChargePostpaid = jsonData['Collect_Weight_Charge'];
        chargeSummaryValuationChargePrepaid =
        jsonData['Prepaid_Valuation_Charge'];
        chargeSummaryValuationChargePostpaid =
        jsonData['Collect_Valuation_Charge'];
        chargeSummaryTaxPrepaid = jsonData['Prepaid_Tax'];
        chargeSummaryTaxPostpaid = jsonData['Collect_Tax'];
        chargeSummaryDueAgentPrepaid =
        jsonData['Prepaid_Other_Charges_Due_Agent'];
        chargeSummaryDueAgentPostpaid =
        jsonData['Collect_Other_Charges_Due_Agent'];
        chargeSummaryDueCarrierPrepaid =
        jsonData['Prepaid_Other_Charges_Due_Carrier'];
        chargeSummaryDueCarrierPostpaid =
        jsonData['Collect_Other_Charges_Due_Carrier'];
        chargeSummaryTotalPrepaid = jsonData['Prepaid_Total'];
        chargeSummaryTotalPostpaid = jsonData['Collect_Total'];

        // // ! 13 - CC charges in destination currency....
        // currencyConversionRates = jsonData['CURRENCY_CONVERSION_RATES'];
        // ccChargesInDest = jsonData['CC_CHARGES_IN_DESTINATION_CURRENCY'];
        // chargesAtDest = jsonData['CHARGES_AT_DESTINATION'];

        // // TODO : 14 - Other charges (add, modify, remove)....

        //Other charges
        //print("other ${}");
        //List<dynamic> otherList = jsonData['AWB_OtherCharges'];

        var map1 = Map.fromIterable(jsonData['AWB_OtherCharges'] as List);
        List<dynamic> otherList = map1.keys.toList();
        for (int i = 0; i < otherList.length; i++) {
          otherChargesList.add(OtherChargesItem.fromJson(
              Map<String, dynamic>.from(otherList[i])));
        }
        // var map2 = Map.fromIterable(jsonData['description'] as List);
        // List<dynamic> dimenList = map2.keys.toList();
        // for (int i = 0; i < dimenList.length; i++) {
        //   dimList.add(DimensionItem.fromJson(
        //       Map<String, dynamic>.from(dimenList[i])));
        // }

        // print(map1);
        //print(otherList);
        //print(otherChargesList);

        //otherChargesList = otherList.cast<OtherChargesItem>();
        //otherChargesList = otherList.toList() as List<OtherChargesItem>;
        // otherChargesList =
        //  OtherChargesItem.fromJson(jsonDecode(jsonData['AWB_OtherCharges']))
        //as List<OtherChargesItem>;
        //List<OtherChargesItem>.from(jsonDecode(otherList.toString()));
        //print(otherChargesList.toString());
        // // ! 15 - Shipper's certification....
        // particularsOfShipper = jsonData['SIGNATURE_OF_SHIPPER_OR_HIS_AGENT'];
        signatureOfShipper = jsonData['Shipper_Signature'];

        // // ! 16 - Carrier's execution....
        //carriersExecutionRemarks = jsonData['CARRIER_EXECUTION_REMARKS'];
        executedOn = jsonData['Carrier_Date'];
        atPlace = jsonData['Carrier_Place'];
        signatureOfIssuingCarrier = jsonData['Carrier_Signature'];

        notifyListeners();
        setStatus();
        return "AWB Number Loaded";
      } else {
        return 'New Air Waybill Number';
      }
    }
    notifyListeners();
    return 'New Air Waybill Number';
  }

  Future<dynamic> inserteAWB() async {
    /**
        Two char code fields:
        Shipper_Contact1_Type
        Shipper_Contact2_Type
        Consignee_Contact1_Type
        Consignee_Contact2_Type
        Consigment_Weight_Code
        Consigment_Volume_Code
        Notify_Contact1_Type
        Notify_Contact2_Type
        Sender_Reference_Sender_Office_Function_Designator
        Sender_Reference_Sender_Office_Company_Designator
        Commision_Information_CASS_Indicator
        Sales_Incentive_Charge_Amount
     */
    var result;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(StringData.eawbbyid,
        headers: <String, String>{
          'x-access-tokens': prefs.getString('token'),
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "AWBList_id": prefs.getString("awbListid"),
          "Shipper_Account_Number": shipperAccountNumber.toString(),
          "Shipper_Name": shipperName.toString(),
          "Shipper_Street_Address": shipperAddress.toString(),
          "Shipper_Place": shipperPlace.toString(),
          "Shipper_StateorProvince": shipperState.toString(),
          "Shipper_Country_code": shipperCountryCode.toString(),
          "Shipper_Post_Code": shipperPostCode.toString(),
          "Shipper_Contact1_Type": shipperContactType,
          "Shipper_Contact1_Number": shipperContactNumber,
          "Shipper_Contact2_Type": "yu",
          "Shipper_Contact2_Number": "srty",
          "Consignee_Account_Number": consigneeAccountNumber.toString(),
          "Consignee_Name": consigneeName.toString(),
          "Consignee_Street_Address": consigneeAddress.toString(),
          "Consignee_Place": consigneePlace.toString(),
          "Consignee_StateorProvince": consigneeState.toString(),
          "Consignee_Country_code": consigneeCountryCode.toString(),
          "Consignee_Post_Code": consigneePostCode.toString(),
          "Consignee_Contact1_Type": consigneeContactType,
          "Consignee_Contact1_Number": consigneeContactNumber,
          "Consignee_Contact2_Type": "",
          "Consignee_Contact2_Number": "",
          "Consigment_AWB_Prefix":
          awbConsigmentDetailsAWBNumber.substring(0, 3),
          "Consigment_Serial_Number":
          awbConsigmentDetailsAWBNumber.substring(4),
          "Consigment_Origin_Prefix": awbConsigmentOriginPrefix.toString(),
          "Consigment_Destination": awbConsigmentDestination.toString(),
          "Consigment_Number_Of_Pieces": awbConsigmentPices.toString(),
          "Consigment_Weight_Code": awbConsigmentWeightCode.toString(),
          "Consigment_Weight": awbConsigmentWeight.toString(),
          "Consigment_Volume_Code": awbConsigmentVolumeCode.toString(),
          "Consigment_Volume": awbConsigmentVolume,
          "Consigment_Density_Group": awbConsigmentDensity,
          "Notify_Name": notifyName,
          "Notify_Street_Address": notifyState,
          "Notify_Place": notifyPlace,
          "Notify_StateorProvince": notifyState,
          "Notify_Country_code": notifyCountryCode,
          "Notify_Post_Code": notifyPostCode,
          "Notify_Contact1_Type": notifyContactType,
          "Notify_Contact1_Number": notifyContactNumber,
          "Notify_Contact2_Type": "",
          "Notify_Contact2_Number": "",
          "Carrier_Agent_NameAndCity": issuingCarrierAgentName,
          "Carrier_Agent_Place": issuingCarrierAgentPlace,
          "Carrier_Agent_IATA_Code": issuingCarrierAgentIATACode,
          "Carrier_Agent_CASS_Address": issuingCarrierAgentCassAddress,
          "Carrier_Agent_Account_No": issuingCarrierAgentAccountNumber,
          "Routing_To": routeAndFlightTo1,
          "Routing_By_First_Carrier": routeAndFlightBy1,
          "Routing_To1": routeAndFlightTo2,
          "Routing_By1": routeAndFlightBy2,
          "Routing_To2": routeAndFlightTo3,
          "Routing_By2": routeAndFlightBy3,
          "Reference_Number": referenceNumber,
          "Information": information,
          "Airline": airline,
          "Flight": flight,
          "Date": date,
          "Airline1": airline1,
          "Flight1": flight1,
          "Date1": date1,
          "Chargedec_Currency": chargesDeclarationCurrency,
          "Chargedec_Value_For_Carriage": chargesDeclarationValueForCarriage,
          "Chargedec_Value_For_Customs": chargesDeclarationValueForCustoms,
          "Chargedec_Amount_Of_Insurance": chargesDeclarationAmountOfInsurance,
          "Chargedec_CHCG": chargesDeclarationCHGSCode,
          "Chargedec_WT_Or_VAL": chargesDeclarationWTVALCharges,
          "Chargedec_Other": chargesDeclarationOtherCharges,
          "SHC1": SPH1,
          "SHC2": SPH2,
          "SHC3": SPH3,
          "SHC4": SPH4,
          "SHC5": SPH5,
          "SHC6": SPH6,
          "SHC7": SPH7,
          "SHC8": SPH8,
          "SHC9": SPH9,
          "Special_Service_Request": SpecialServiceRequest,
          "Other_Service_Information": OtherServiceInformation,
          "Customs_origin_SCI_code": SCI,
          "Prepaid_Weight_Charge": chargeSummaryWeightChargePrepaid,
          "Prepaid_Valuation_Charge": chargeSummaryValuationChargePrepaid,
          "Prepaid_Tax": chargeSummaryTaxPrepaid,
          "Prepaid_Other_Charges_Due_Agent": chargeSummaryDueAgentPrepaid,
          "Prepaid_Other_Charges_Due_Carrier": chargeSummaryDueCarrierPrepaid,
          "Prepaid_Total": chargeSummaryTotalPrepaid,
          "Collect_Weight_Charge": chargeSummaryWeightChargePostpaid,
          "Collect_Valuation_Charge": chargeSummaryValuationChargePostpaid,
          "Collect_Tax": chargeSummaryTaxPostpaid,
          "Collect_Other_Charges_Due_Agent": chargeSummaryDueAgentPostpaid,
          "Collect_Other_Charges_Due_Carrier": chargeSummaryDueCarrierPostpaid,
          "Collect_Total": chargeSummaryTotalPostpaid,
          "CC_Charges_Destination_Currency": destCurrencyCode,
          "CC_Charges_Currency_Conv_Rates": currencyConversionRates,
          "CC_Charges_In_Dest": ccChargesInDest,
          "CC_Charges_At_Dest": chargesAtDest,
          "CC_Charges_Total": totalCollect,
          "Shipper_Signature": signatureOfShipper,
          "Carrier_Date":
          executedOn.replaceAll("-", "/").toString(), //"03/05/2022"
          "Carrier_Place": atPlace,
          "Carrier_Signature": signatureOfIssuingCarrier,
          "AWB_AccountInformation": [
            {"AccountId": "fgdfgsf", "Information": "fghdfhhdtrt"},
            {"AccountId": "lkjhl", "Information": "yui"},
            {"AccountId": "mhfj", "Information": "sery"},
            {"AccountId": "brg", "Information": "my"}
          ],
          "AWB_OtherCharges": otherChargesList,
          "AWB_Othercustomsinformation": [
            {
              "Countrycode": "mhf",
              "InformationIdentifier": "sery",
              "CustomsIdentifier": "mhfj",
              "Information": "sery"
            },
            {
              "Countrycode": "brg",
              "InformationIdentifier": "my",
              "CustomsIdentifier": "mhfj",
              "Information": "sery"
            }
          ],
          "AWB_RateDescription": [
            {
              "Pieces": 99,
              "Grossweight": 4567,
              "Weight_Code": "K",
              "Servicecode": 45,
              "Rateclass": "L",
              "Itemnumber": "6987678",
              "Chargeableweight": 989,
              "RateorCharge": "Rate",
              "Total": 45,
              "Autocalculations": "N",
              "DimensionsRateDescription": [
                {
                  "Length": 87,
                  "Width": 46,
                  "Height": 68,
                  "HeightCode": "cm",
                  "Pieces_dim": 45,
                  "Weight": 687,
                  "WeightCode": "K"
                },
                {
                  "Length": 58,
                  "Width": 69,
                  "Height": 48,
                  "HeightCode": "cm",
                  "Pieces_dim": 54,
                  "Weight": 78,
                  "WeightCode": "K"
                }
              ],
              "ULDRateDescription": [
                {"Type": "fgfgh", "Serial": "mhuji", "Ownercode": "SE"},
                {"Type": "GTR", "Serial": "DER", "Ownercode": "ER"}
              ]
            },
            {
              "Pieces": 55,
              "Grossweight": 65,
              "Weight_Code": "K",
              "Servicecode": 455,
              "Rateclass": "L",
              "Itemnumber": "13456",
              "Chargeableweight": 68,
              "RateorCharge": "Rate",
              "Total": 45,
              "Autocalculations": "Y",
              "DimensionsRateDescription": [
                {
                  "Length": 87,
                  "Width": 46,
                  "Height": 68,
                  "HeightCode": "cm",
                  "Pieces_dim": 45,
                  "Weight": 687,
                  "WeightCode": "K"
                },
                {
                  "Length": 58,
                  "Width": 69,
                  "Height": 48,
                  "HeightCode": "cm",
                  "Pieces_dim": 54,
                  "Weight": 78,
                  "WeightCode": "K"
                }
              ],
              "ULDRateDescription": [
                {"Type": "fgfgh", "Serial": "mhuji", "Ownercode": "SE"},
                {"Type": "GTR", "Serial": "DER", "Ownercode": "ER"}
              ]
            }
          ],
          "AWB_OTHER_PARTICIPANT_INFORMATION": [],
          "AWB_Contacts": [
            {"Shipper_Contact1_Type":"Mobile","Shipper_Contact1_Number":"6381939229"}
          ],
        }));

    result = json.decode(response.body);
    print(result);
    if (result['message'] == 'token expired') {
      refreshToken();
      inserteAWB();
    } else {
      result = json.decode(response.body);
      print("insert eawb result"+response.body);
      print(prefs.getString('token'));
      print("date '${executedOn.replaceAll("-", "/").toString()}'");
      if (response.statusCode == 201) {
        print("Data inserted");
        return true;
        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content: Text("Data inserted"),
        //   duration: Duration(seconds: 1),
        // ));
        // Navigator.push(context, HomeScreenRoute(MyEawb()));
        // print("Data inserted");
      } else {
        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content: Text("Data inserted faild"),
        //   duration: Duration(seconds: 1),
        // ));
        print("Data insertion failed");
        return false;
      }
    }
    //return response.body == 'eAWB Saved';

  }

  Future<String> getAWBid(String awbnumber) async {
    var result;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(StringData.getAwbid);
    final request = http.Request("GET", url);
    request.headers.addAll(<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-access-tokens': prefs.getString('token')
    });
    print(awbnumber.substring(3));
    request.body = jsonEncode({
      "prefix": awbnumber.substring(0, 3),
      "wayBillNumber": awbnumber.substring(4)
    });
    var jsonData;
    var res = await request.send();
    final respStr = await res.stream.bytesToString();
    jsonData = jsonDecode(respStr);
    if (jsonData["message"] == "token expired") {
      refreshToken();
      getAWBid(awbnumber);
    } else {
      print("Respstr ${respStr}");

      if (jsonData.length != 0) {

        var data = jsonData["awb"][0]['id'].toString();

        print("object ${data}");

        return data;
      } else {
        return "Not found";
      }
    }
  }

  Future<String> printEAWB() async {

    String jsonList = jsonEncode(otherChargesList);
    print(jsonList);
    SharedPreferences prefs =
    await SharedPreferences.getInstance(); // ! get SharedPreferences....
    var response = await http.post(StringData.printEAWBAPI,
        headers: {
          'x-access-tokens': prefs.getString('token'),
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            "I33": "AWB",
            "Shipper_Account_Number": shipperAccountNumber.toString(),
            "Shipper_Name": shipperName.toString() +
                "\n" +
                shipperAddress.toString() +
                "," +
                shipperPlace +
                "," +
                shipperState +
                ",\n" +
                shipperCountryCode +
                "," +
                shipperPostCode.toString() +
                "," +
                "\n" +
                newshipperContactList[0].Shipper_Contact_Type.toUpperCase()+"," +
                newshipperContactList[0].Shipper_Contact_Detail,
                // shipperContactType.toString() +
                // "," +
                // shipperContactNumber.toString(),
            "Consignee_Account_Number": consigneeAccountNumber.toString(),
            "Consignee_Name": consigneeName.toString() +
                "\n" +
                consigneeAddress.toString() +
                "," +
                consigneePlace +
                "," +
                consigneeState +
                ",\n" +
                consigneeCountryCode +
                "," +
                consigneePostCode.toString() +
                "," +
                "\n" +
                newconsigneeContactList[0].Consignee_Contact_Type.toUpperCase()+","+
                newconsigneeContactList[0].Consignee_Contact_Detail,
                // consigneeContactType.toString() +
                // "," +
                // consigneeContactNumber.toString(),
            "Consigment_AWB_Prefix":
            awbConsigmentDetailsAWBNumber.substring(0, 3),
            "Consigment_Serial_Number":
            awbConsigmentDetailsAWBNumber.substring(4),
            "Consigment_Origin_Prefix": awbConsigmentOriginPrefix,
            "Consigment_Destination": awbConsigmentDestination,
            "Consigment_Number_Of_Pieces": awbConsigmentPices,
            "Consigment_Weight_Code": awbConsigmentWeightCode,
            "Consigment_Weight": awbConsigmentWeight,
            "Consigment_Volume_Code": awbConsigmentVolumeCode,
            "Consigment_Volume": awbConsigmentVolume,
            "Consigment_Density_Group": awbConsigmentDensity,
            "Notify_Name": notifyName +
                "\n" +
                nofityStreetAddress +
                "," +
                notifyPlace +
                "," +
                notifyState +
                "," +
                notifyCountryCode +
                "," +
                notifyPostCode.toString() +
                "," +
                "\n" +
                newnotifyContactList[0].Notify_Contact_Type.toUpperCase()+","+
                newnotifyContactList[0].Notify_Contact_Detail,
                // notifyContactType.toString() +
                // "," +
                // notifyContactNumber.toString(),
            "Carrier_Agent_NameAndCity": issuingCarrierAgentName,
            "Carrier_Agent_Place": issuingCarrierAgentCity,
            "Carrier_Agent_IATA_Code": issuingCarrierAgentIATACode,
            "Carrier_Agent_CASS_Address": issuingCarrierAgentCassAddress,
            "Carrier_Agent_Account_No": issuingCarrierAgentAccountNumber,
            "Routing_To": routeAndFlightTo1,
            "Routing_By_First_Carrier": routeAndFlightBy1,
            "Routing_To1": routeAndFlightTo2,
            "Routing_By1": routeAndFlightBy2,
            "Routing_To2": routeAndFlightTo3,
            "Routing_By2": routeAndFlightBy3,
            "Reference_Number": referenceNumber,
            "Information": information,
            "Flight": routeAndFlightNumber1 + "/" + routeAndFlightDate1,
            "Flight1": routeAndFlightNumber2 + "/" + routeAndFlightDate2,
            "Chargedec_Currency": chargesDeclarationCurrency,
            "Chargedec_Value_For_Carriage": chargesDeclarationValueForCarriage,
            "Chargedec_Value_For_Customs": chargesDeclarationValueForCustoms,
            "Chargedec_Amount_Of_Insurance":
            chargesDeclarationAmountOfInsurance,
            "Chargedec_CHCG": chargesDeclarationCHGSCode,
            "Chargedec_WT_Or_VAL": chargesDeclarationWTVALCharges,
            "Chargedec_Other": chargesDeclarationOtherCharges,
            "SHC1":
            "EAP ELI       \n MUST BE KEPT ABOVE 5 DEGREES CELSIUS\nEXTRA CHARGE DUE TO SPECIAL HANDLING REQUIREMENTS",
            "Customs_origin_SCI_code": "T1",
            "Prepaid_Weight_Charge": chargeSummaryWeightChargePrepaid,
            "Prepaid_Valuation_Charge": chargeSummaryValuationChargePrepaid,
            "Prepaid_Tax": chargeSummaryTaxPrepaid,
            "Prepaid_Other_Charges_Due_Agent": chargeSummaryDueAgentPrepaid,
            "Prepaid_Other_Charges_Due_Carrier": chargeSummaryDueCarrierPrepaid,
            "Prepaid_Total": chargeSummaryTotalPrepaid,
            "Collect_Weight_Charge": chargeSummaryWeightChargePostpaid,
            "Collect_Valuation_Charge": chargeSummaryValuationChargePostpaid,
            "Collect_Tax": chargeSummaryTaxPostpaid,
            "Collect_Other_Charges_Due_Agent": chargeSummaryDueAgentPostpaid,
            "Collect_Other_Charges_Due_Carrier":
            chargeSummaryDueCarrierPostpaid,
            "Collect_Total": chargeSummaryTotalPostpaid,
            "CC_Charges_Currency_Conv_Rates":
            "USD to " + destCurrencyCode + ":" + currencyConversionRates,
            "CC_Charges_Currency_Conv_Rates2":
            chargesDeclarationCurrency + " to USD:" + baseCurencyrate,
            "CC_Charges_In_Dest": ccChargesInDest,
            "CC_Charges_At_Dest": chargesAtDest,
            "CC_Charges_Total": totalCollect,
            "Shipper_Signature": signatureOfShipper,
            "Carrier_Date": executedOn,
            "Carrier_Place": atPlace,
            "Carrier_Signature": signatureOfIssuingCarrier,
            "Pieces": "10",
            "Grossweight": "50",
            "Weight_Code": "K",
            "Rateclass": "Q",
            "Itemnumber": "12345",
            "Chargeableweight": "50",
            "RateorCharge": "60",
            "Description":
            "CONSOLIDATION \nORIGIN:MV\nSLAC:5\nVOLUME:15\n11X12X13/14",
            "contactshipper": [
              {
                "AWB_Contacts_type": "TE",
                "AWB_Contacts_detail": "9876543212",
                "AWB_Contact_Entity": "shipper"
              }
            ],
            "Ratedescription": rateDescriptionItemList,
            // "Ratedescription": [
            //   {
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
            // ],
            "dimmm": otherChargesList
            // "dimmm": [
            //   {
            //     "Amount": otherChargesList[0].amount,
            //     "Code": otherChargesList[0].description,
            //     "Entitlement": otherChargesList[0].minimum
            //   }
            // ]
          },
        ));

    response = await http.get(StringData.fileEAWBAPI(response.body),
        headers: {'x-access-tokens': prefs.getString('token')});

    print("print pdf ---"+response.body);

    var data = response.bodyBytes;

    //Get external storage directory
    Directory directory = await getExternalStorageDirectory();
    //Get directory path
    String path = directory.path;
    //Create an empty file to write PDF data
    File file = File('$path/Output.pdf');
    //Write PDF data
    await file.writeAsBytes(data, flush: true);
    //Open the PDF document in mobile
    OpenFile.open('$path/Output.pdf');

    return "Data";
  }

//   void loadSampleData() {
//     int flagOffset = 0x1F1E6;
//     int asciiOffset = 0x41;
//
//     String country = "IN";
//
//     int firstChar = country.codeUnitAt(0) - asciiOffset + flagOffset;
//     int secondChar = country.codeUnitAt(1) - asciiOffset + flagOffset;
//     String flag =
//         String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
//     clearShipperModel(); //1
//     clearConsigneeModel(); //2
//     clearIssuingCarriersAgentModel(); //3
//     clearRoutingAndFlightBookingsModel(); //4
//     //clearAWBConsigmentDetailsModel(); //5
//     clearNotify();
//     clearIssuerModel(); //6
//     clearAccountingInformationModel(); //6
//     clearOptionalShippingInformationModel(); //7
//     clearChargesDeclarationModel(); //8
//     clearHandlingInformationModel(); //9
//     clearRateDescriptionModel(); //10
//     clearChargesSummaryModel(); //11
//     clearCcChargesInDestinationCurrencyModel(); //12
//     clearOtherChargesModel(); //13
//     clearShippersCertificationModel(); //14
//     clearCarriersExecutionModel(); //15
//     setStatus(); // setStatus ....
//     notifyListeners();
//
//     RateDescriptionItem rateModel;
//     shipperAccountNumber = '1111111111';
//     // ! convert SHIPPER_NAME_AND_ADDRESS to name and address....
//     //data = jsonData['SHIPPER_NAME_AND_ADDRESS'].replaceAll('\\n', '\n');
//     shipperName = 'MAHOGANY PRIVATE LIMITED';
//     shipperAddress = 'AVINASHI ';
//
//     shipperPlace = 'AVINASHI';
//     shipperState = 'TAMILNADU';
//     shipperCountryCode = 'IN';
//     shipperPostCode = '654564';
//     // shipperContactType = 'TE';
//     // shipperContactNumber = '9876543212';
//     newshipperContactList.add(
//         ShipperExpenseList (
//             Shipper_Contact_Type:"MOBILE",
//             Shipper_Contact_Detail:"+916381929090",
//             flag:flag
//         ));
//     print("Shipper contact"+newshipperContactList.toString());
//
// //     // ! 2 - Consignee....
//     consigneeAccountNumber = "222222222222";
//     // ! convert CONSIGNEE_NAME_AND_ADDRESS to name and address....
//     consigneeName = "TIME Moonstone Hotel Apartments";
//     consigneeAddress = "Al Maktoum Road Town Center";
//     consigneePlace = "Block B";
//     consigneeState = "Fujairah";
//     consigneeCountryCode = "AE";
//     consigneePostCode = "00000";
//     String Consigneecountry = consigneeCountryCode;
//
//     int ConsigneefirstChar = Consigneecountry.codeUnitAt(0) - asciiOffset + flagOffset;
//     int ConsigneesecondChar = Consigneecountry.codeUnitAt(1) - asciiOffset + flagOffset;
//     String Consigneeflag =
//         String.fromCharCode(ConsigneefirstChar) + String.fromCharCode(ConsigneesecondChar);
//     // consigneeContactType = "TE";
//     // consigneeContactNumber = "8300803649";
//     newconsigneeContactList.add(
//         ConsigneeExpenseList(
//             Consignee_Contact_Type:"Telegram",
//             Consignee_Contact_Detail: "+919500867623",
//             flag:Consigneeflag
//         )
//     );
// //
// //       // ! 3 - Issuing carrier's agent....
// //       // ! convert ISSUING_CARRIER_AGENT_NAME_AND_CITY to name and address
//     // data = jsonData['Carrier_Agent_NameAndCity'].replaceAll('\\n', '\n');
//     issuingCarrierAgentName = "MORRISON EXPRESS LOGISTICS PTE LTD";
//     issuingCarrierAgentCity = "COIMBATORE";
//     issuingCarrierAgentIATACode = "3230043";
//     issuingCarrierAgentAccountNumber = "ABC94269";
//     issuingCarrierAgentCassAddress = "1234";
//     issuingCarrierAgentPlace = "COIMBATORE";
// //     // ! 4 - Routing and flight bookings....
//     // routeAndFlightDeparture = "";
//     routeAndFlightTo1 = "FJR";
//     routeAndFlightBy1 = "EK";
//     routeAndFlightTo2 = "";
//     routeAndFlightBy2 = "";
//     routeAndFlightTo3 = "";
//     routeAndFlightBy3 = "";
//     referenceNumber = "";
//     information = "";
//     airline = "";
//     routeAndFlightNumber1 = "EK885";
//     routeAndFlightDate1 = "07NOV2022";
//     airline1 = "";
//     routeAndFlightNumber2 = "";
//     routeAndFlightDate2 = "";
//
// //     // ! 5- AWB consigment details....
//     //awbConsigmentDetailsAWBNumber = "61872442672";
//     // awbConsigmentDetailsDepAirportCode = jsonData['DEPARTURE_AIRPORT_CODE'];
//
//     awbConsigmentOriginPrefix = "CJB";
//     awbConsigmentDestination = "FJR";
//     awbConsigmentPices = "20";
//     awbConsigmentWeightCode = "K";
//     awbConsigmentWeight = "50";
//     awbConsigmentVolumeCode = "cm";
//     awbConsigmentVolume = "60";
//     awbConsigmentDensity = "DC";
//
//
// //     //notify model
//     notifyName = "SPICES RESTAURANT";
//     nofityStreetAddress = "AVINASHI";
//     notifyPlace = "AVINASHI";
//     notifyState = "TAMILNADU";
//     notifyCountryCode = "IN";
//     notifyPostCode = "676767";
//     String Notifycountry = notifyCountryCode;
//
//     int NotifyfirstChar = Notifycountry.codeUnitAt(0) - asciiOffset + flagOffset;
//     int NotifysecondChar = Notifycountry.codeUnitAt(1) - asciiOffset + flagOffset;
//     String Notifyflag =
//         String.fromCharCode(NotifyfirstChar) + String.fromCharCode(NotifysecondChar);
//     newnotifyContactList.add(
//         NotifyExpenseList(
//             Notify_Contact_Type: "Telegram",
//             Notify_Contact_Detail: "8300803649",
//             flag:Notifyflag
//         )
//     );
//     // notifyContactType = "TE";
//     // notifyContactNumber = "8300803649";
//     issuerBy = "MORRISON EXPRESS LOGISTICS PVT LTD";
//     accountingInformationId="A1234";
//     accountingInformationDetails = "MUST BE SAFE";
//     referenceNumber = "88888888";
//     refNo2 = " ";
//     chargesDeclarationCurrency = "INR";
//     chargesDeclarationCHGSCode = "PP";
//     chargesDeclarationValueForCarriage = "NVD";
//     chargesDeclarationValueForCustoms = "NCV";
//     chargesDeclarationAmountOfInsurance = "99";
//     handlingInformationSCI = "T1";
//     handlingInformationRequirements =
//     "EXTRA CHARGE DUE TO SPECIAL HANDLING REQUIREMENTS";
//     chargeSummaryWeightChargePrepaid = "1800";
//     chargeSummaryWeightChargePostpaid = "0";
//     chargeSummaryValuationChargePrepaid = "0";
//     chargeSummaryValuationChargePostpaid = "350";
//     chargeSummaryTaxPrepaid = "100";
//     chargeSummaryTaxPostpaid = "10";
//     chargeSummaryDueAgentPrepaid ="100";
//     chargeSummaryDueAgentPostpaid ="0";
//     chargeSummaryDueCarrierPrepaid ="0";
//     chargeSummaryDueCarrierPostpaid ="0";
//     chargeSummaryTotalPrepaid = "2000";
//     chargeSummaryTotalPostpaid = "360";
//     currencyConversionRates = "3";
//     //inr to usd 1inr =77usd
//     baseCurencyrate = "77.55";
//     destCurrencyCode = "AED";
//     ccChargesInDest = "15.98";
//     chargesAtDest = "3";
//     totalCollect = "18.98";
//     particularsOfShipper="MAHOGANY";
//     signatureOfShipper = "MAHOGANY PRIVATE";
//     //Ratedescription
//     rateDescriptionItemList.add(RateDescriptionItem(
//       // isExpanded: false,
//         pieces: 4,
//         grossWeight: 40,
//         grossWeightUnit: "K",
//         serviceCode: "H",
//         rateClass: "Q",
//         itemNumber: 12321,
//         autoCalculations: "Total",
//         chargeableWeight: 40,
//         rateCharge: 45,
//         total: 1800,
//         dimensionsList: [
//           {
//             'isSelected': false,
//             'length': '10',
//             'width': '100',
//             'height': '10',
//             'pwUnit': 'K',
//             'lwhUnit': 'cm',
//             'pieces': '5',
//             'weight': '50'
//           },
//         ],
//         volume: "50000 CM3",
//         natureAndQuantity: "TEXTILES",
//         slac: "25",
//         text: ""));
//     otherChargesList.add(
//       OtherChargesItem(
//           description: "CC",
//           isExpanded: false,
//           entitlement: "Due agent",
//           weight: "Manual data entry for\n customs purposes",
//           amount: 100,
//           minimum: 10,
//           rate: 10,
//           prepaidcollect:"PPD",
//           useRate: false),
//     );
//     executedOn = "09OCT2022";
//     atPlace = "COIMBATORE";
//     signatureOfIssuingCarrier = "MAHOGANY PRIVATE";
//     //rateDescriptionItemList.add();
//     // rateModel.pieces = 1;
//     // rateModel.grossWeight = 40;
//     // rateModel.grossWeightUnit = "L";
//     // rateModel.serviceCode = "H";
//     // rateModel.rateClass = "Q";
//     // rateModel.itemNumber = 12321;
//     // rateModel.chargeableWeight = 40;
//     // rateModel.rateCharge = 45;
//     // rateModel.total = 2800;
//
//     // rateModel.natureAndQuantity =
//     //     "CONSOLIDATION\nOrigin:MV\nSLAC:6\nVolume:20CM3\n12X12X12MMT/550K";
//
//
//     SPH1="EAWB";
//     SPH2="EAWB";
//     SpecialServiceRequest="T1";
//     OtherServiceInformation="T2";
//     SCI="T1";
//
//     notifyListeners();
//     setStatus();
//   }

  void loadSampleData1() {
    int flagOffset = 0x1F1E6;
    int asciiOffset = 0x41;

    String country = "IN";

    int firstChar = country.codeUnitAt(0) - asciiOffset + flagOffset;
    int secondChar = country.codeUnitAt(1) - asciiOffset + flagOffset;
    String flag =
        String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
    clearShipperModel(); //1
    clearConsigneeModel(); //2
    clearIssuingCarriersAgentModel(); //3
    clearRoutingAndFlightBookingsModel(); //4
    //clearAWBConsigmentDetailsModel(); //5
    clearNotify();
    clearIssuerModel(); //6
    clearAccountingInformationModel(); //6
    clearOptionalShippingInformationModel(); //7
    clearChargesDeclarationModel(); //8
    clearHandlingInformationModel(); //9
    clearRateDescriptionModel(); //10
    clearChargesSummaryModel(); //11
    clearCcChargesInDestinationCurrencyModel(); //12
    clearOtherChargesModel(); //13
    clearShippersCertificationModel(); //14
    clearCarriersExecutionModel(); //15
    setStatus(); // setStatus ....
    notifyListeners();

    RateDescriptionItem rateModel;
    shipperAccountNumber = '33333333333';
    // ! convert SHIPPER_NAME_AND_ADDRESS to name and address....
    //data = jsonData['SHIPPER_NAME_AND_ADDRESS'].replaceAll('\\n', '\n');
    shipperName = 'MAHOGANY PRIVATE LIMITED';
    shipperAddress = 'AVINASHI ';

    shipperPlace = 'AVINASHI';
    shipperState = 'TAMILNADU';
    shipperCountryCode = 'IN';
    shipperPostCode = '654564';
    // shipperContactType = 'TE';
    // shipperContactNumber = '9876543212';
    newshipperContactList.add(
        ShipperExpenseList (
            Shipper_Contact_Type:"MOBILE",
            Shipper_Contact_Detail:"+916381929090",
            flag:flag
        ));
//     // ! 2 - Consignee....
    consigneeAccountNumber = "222222222222";
    // ! convert CONSIGNEE_NAME_AND_ADDRESS to name and address....
    consigneeName = "NAVEEN";
    consigneeAddress = "Al Khoory Inn Hotel";
    consigneePlace = "Al Khoory Inn Hotel";
    consigneeState = "DUBAI";

    consigneeCountryCode = "AE";
    consigneePostCode = "000000";
    String Consigneecountry = consigneeCountryCode;

    int ConsigneefirstChar = Consigneecountry.codeUnitAt(0) - asciiOffset + flagOffset;
    int ConsigneesecondChar = Consigneecountry.codeUnitAt(1) - asciiOffset + flagOffset;
    String Consigneeflag =
        String.fromCharCode(ConsigneefirstChar) + String.fromCharCode(ConsigneesecondChar);
    // consigneeContactType = "TE";
    // consigneeContactNumber = "8300803649";
    newconsigneeContactList.add(
        ConsigneeExpenseList(
            Consignee_Contact_Type:"Telegram",
            Consignee_Contact_Detail: "+971950086762",
            flag:Consigneeflag
        )
    );
    // consigneeContactType = "TE";
    // consigneeContactNumber = "8300803649";


//
//       // ! 3 - Issuing carrier's agent....
//       // ! convert ISSUING_CARRIER_AGENT_NAME_AND_CITY to name and address
    // data = jsonData['Carrier_Agent_NameAndCity'].replaceAll('\\n', '\n');
    issuingCarrierAgentName = "MORRISON EXPRESS LOGISTICS PTE LTD";
    issuingCarrierAgentCity = "COIMBATORE";
    issuingCarrierAgentIATACode = "3230043";
    issuingCarrierAgentAccountNumber = "ABC94269";
    issuingCarrierAgentCassAddress = "1234";
    issuingCarrierAgentPlace = "COIMBATORE";
//     // ! 4 - Routing and flight bookings....
    // routeAndFlightDeparture = "";
    routeAndFlightTo1 = "DXB";
    routeAndFlightBy1 = "EK";
    routeAndFlightTo2 = "";
    routeAndFlightBy2 = "";
    routeAndFlightTo3 = "";
    routeAndFlightBy3 = "";
    referenceNumber = "";
    information = "";
    airline = "";
    routeAndFlightNumber1 = "EK885";
    routeAndFlightDate1 = "07NOV2022";
    airline1 = "";
    routeAndFlightNumber2 = "";
    routeAndFlightDate2 = "";

//     // ! 5- AWB consigment details....
    //awbConsigmentDetailsAWBNumber = "61872442672";
    // awbConsigmentDetailsDepAirportCode = jsonData['DEPARTURE_AIRPORT_CODE'];

    awbConsigmentOriginPrefix = "CJB";
    awbConsigmentDestination = "DXB";
    awbConsigmentPices = "20";
    awbConsigmentWeightCode = "K";
    awbConsigmentWeight = "50";
    awbConsigmentVolumeCode = "CC";
    awbConsigmentVolume = "60";
    awbConsigmentDensity = "DC";

//     //notify model
    notifyName = "SPICES RESTAURANT";
    nofityStreetAddress = "AVINASHI";
    notifyPlace = "AVINASHI";
    notifyState = "TAMILNADU";
    notifyCountryCode = "IN";
    notifyPostCode = "676767";
    String Notifycountry = notifyCountryCode;

    int NotifyfirstChar = Notifycountry.codeUnitAt(0) - asciiOffset + flagOffset;
    int NotifysecondChar = Notifycountry.codeUnitAt(1) - asciiOffset + flagOffset;
    String Notifyflag =
        String.fromCharCode(NotifyfirstChar) + String.fromCharCode(NotifysecondChar);
    newnotifyContactList.add(
        NotifyExpenseList(
            Notify_Contact_Type: "Telegram",
            Notify_Contact_Detail: "+918300803649",
            flag:Notifyflag
        )
    );

    // notifyContactType = "TE";
    // notifyContactNumber = "8300803649";
    issuerBy = "MORRISON EXPRESS LOGISTICS PVT LTD";
    accountingInformationId ="A124";
    accountingInformationDetails = "MUST BE SAFE";
    referenceNumber = "88888888";
    refNo2 = " ";
    chargesDeclarationCurrency = "INR";
    chargesDeclarationCHGSCode = "PP";
    chargesDeclarationValueForCarriage = "NVD";
    chargesDeclarationValueForCustoms = "NCV";
    chargesDeclarationAmountOfInsurance = "99";
    handlingInformationSCI = "T1";
    handlingInformationRequirements =
    "EXTRA CHARGE DUE TO SPECIAL HANDLING REQUIREMENTS";
    chargeSummaryWeightChargePrepaid = "15750";
    chargeSummaryWeightChargePostpaid = "0";
    chargeSummaryValuationChargePrepaid = "0";
    chargeSummaryValuationChargePostpaid = "350";
    chargeSummaryTaxPrepaid = "100";
    chargeSummaryTaxPostpaid = "10";
    chargeSummaryDueAgentPrepaid ="100";
    chargeSummaryDueAgentPostpaid ="0";
    chargeSummaryDueCarrierPrepaid ="0";
    chargeSummaryDueCarrierPostpaid ="0";
    chargeSummaryTotalPrepaid = "15950";
    chargeSummaryTotalPostpaid = "360";
    currencyConversionRates = "3";
    baseCurencyrate = "77";
    destCurrencyCode = "AED";
    ccChargesInDest = "15.98";
    chargesAtDest = "3";
    totalCollect = "18.98";
    particularsOfShipper="MAHOGANY";
    signatureOfShipper = "MAHOGANY PRIVATE";
    rateDescriptionItemList.add(RateDescriptionItem(
      // isExpanded: false,
        pieces: 35,
        grossWeight: 350,
        grossWeightUnit: "K",
        serviceCode: "H",
        rateClass: "Q",
        itemNumber: 12321,
        autoCalculations: "Total",
        chargeableWeight: 350,
        rateCharge: 45,
        total: 15750,
        dimensionsList: [
          {
            'isSelected': false,
            'length': '10',
            'width': '10',
            'height': '10',
            'pwUnit': 'K',
            'lwhUnit': 'cm',
            'pieces': '35',
            'weight': '350'
          },
        ],
        volume: "35000 CM3",
        natureAndQuantity: "TEXTILES",
        slac: "35",
        text: ""));
    //Ratedescription
    // rateDescriptionItemList.add(RateDescriptionItem(
    //   // isExpanded: false,
    //     pieces: 4,
    //     grossWeight: 40,
    //     grossWeightUnit: "K",
    //     serviceCode: "H",
    //     rateClass: "Q         Quantity Rate",
    //     itemNumber: 12321,
    //     autoCalculations: "No",
    //     chargeableWeight: 40,
    //     rateCharge: 45,
    //     total: 1800,
    //     dimensionsList: [
    //       {
    //         'isSelected': false,
    //         'length': '10',
    //         'width': '100',
    //         'height': '10',
    //         'pwUnit': 'K',
    //         'lwhUnit': 'cm',
    //         'pices': '5',
    //         'weight': '50'
    //       },
    //     ],
    //     volume: "",
    //     natureAndQuantity: "TEXTILES",
    //     text: ""));
    otherChargesList.add(
      OtherChargesItem(
          description: "CC",
          isExpanded: false,
          entitlement: "Due agent",
          weight: "Manual data entry for\ncustoms purposes",
          amount: 100,
          minimum: 10,
          rate: 10,
          prepaidcollect:"PPD",
          useRate: false),
    );
    executedOn = "08NOV2022";
    atPlace = "COIMBATORE";
    signatureOfIssuingCarrier = "MAHOGANY PRIVATE";
    //rateDescriptionItemList.add();
    // rateModel.pieces = 1;
    // rateModel.grossWeight = 40;
    // rateModel.grossWeightUnit = "L";
    // rateModel.serviceCode = "H";
    // rateModel.rateClass = "Q";
    // rateModel.itemNumber = 12321;
    // rateModel.chargeableWeight = 40;
    // rateModel.rateCharge = 45;
    // rateModel.total = 2800;

    // rateModel.natureAndQuantity =
    //     "CONSOLIDATION\nOrigin:MV\nSLAC:6\nVolume:20CM3\n12X12X12MMT/550K";

    SPH1="EAWB";
    SPH2="EAWB";
    SpecialServiceRequest="T1";
    OtherServiceInformation="T2";
    SCI="T1";

    notifyListeners();
    setStatus();
  }

  void loadSampleData() {
    int flagOffset = 0x1F1E6;
    int asciiOffset = 0x41;

    String country = "IN";

    int firstChar = country.codeUnitAt(0) - asciiOffset + flagOffset;
    int secondChar = country.codeUnitAt(1) - asciiOffset + flagOffset;
    String flag =
        String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
    clearShipperModel(); //1
    clearConsigneeModel(); //2
    clearIssuingCarriersAgentModel(); //3
    clearRoutingAndFlightBookingsModel(); //4
    //clearAWBConsigmentDetailsModel(); //5
    clearNotify();
    clearIssuerModel(); //6
    clearAccountingInformationModel(); //6
    clearOptionalShippingInformationModel(); //7
    clearChargesDeclarationModel(); //8
    clearHandlingInformationModel(); //9
    clearRateDescriptionModel(); //10
    clearChargesSummaryModel(); //11
    clearCcChargesInDestinationCurrencyModel(); //12
    clearOtherChargesModel(); //13
    clearShippersCertificationModel(); //14
    clearCarriersExecutionModel(); //15
    setStatus(); // setStatus ....
    notifyListeners();

    RateDescriptionItem rateModel;
    shipperAccountNumber = '33333333333';
    // ! convert SHIPPER_NAME_AND_ADDRESS to name and address....
    //data = jsonData['SHIPPER_NAME_AND_ADDRESS'].replaceAll('\\n', '\n');
    shipperName = 'KRISH PRIVATE LIMITED';
    shipperAddress = 'FIRE BRIGADE LANE';

    shipperPlace = 'BARAKHAMBA';
    shipperState = 'NEW DELHI';
    shipperCountryCode = 'IN';
    shipperPostCode = '110001';
    // shipperContactType = 'TE';
    // shipperContactNumber = '9876543212';
    newshipperContactList.add(
        ShipperExpenseList (
            Shipper_Contact_Type:"MOBILE",
            Shipper_Contact_Detail:"+916381929090",
            flag:flag
        ));
//     // ! 2 - Consignee....
    consigneeAccountNumber = "222222222222";
    // ! convert CONSIGNEE_NAME_AND_ADDRESS to name and address....
    consigneeName = "NAVEEN";
    consigneeAddress = "HỒ CHÍ MINH";
    consigneePlace = "HO CHI MINH";
    consigneeState = "DA NANG";

    consigneeCountryCode = "VN";
    consigneePostCode = "000000";
    String Consigneecountry = consigneeCountryCode;

    int ConsigneefirstChar = Consigneecountry.codeUnitAt(0) - asciiOffset + flagOffset;
    int ConsigneesecondChar = Consigneecountry.codeUnitAt(1) - asciiOffset + flagOffset;
    String Consigneeflag =
        String.fromCharCode(ConsigneefirstChar) + String.fromCharCode(ConsigneesecondChar);
    // consigneeContactType = "TE";
    // consigneeContactNumber = "8300803649";
    newconsigneeContactList.add(
        ConsigneeExpenseList(
            Consignee_Contact_Type:"Telegram",
            Consignee_Contact_Detail: "+8495008676211",
            flag:Consigneeflag
        )
    );
    // consigneeContactType = "TE";
    // consigneeContactNumber = "8300803649";


//
//       // ! 3 - Issuing carrier's agent....
//       // ! convert ISSUING_CARRIER_AGENT_NAME_AND_CITY to name and address
    // data = jsonData['Carrier_Agent_NameAndCity'].replaceAll('\\n', '\n');
    issuingCarrierAgentName = "MORRISON EXPRESS LOGISTICS PTE LTD";
    issuingCarrierAgentCity = "NEW DELHI";
    issuingCarrierAgentIATACode = "3230043";
    issuingCarrierAgentAccountNumber = "ABC94269";
    issuingCarrierAgentCassAddress = "1234";
    issuingCarrierAgentPlace = "NEW DELHI";
//     // ! 4 - Routing and flight bookings....
    // routeAndFlightDeparture = "";
    routeAndFlightTo1 = "HAN";
    routeAndFlightBy1 = "6P";
    routeAndFlightTo2 = "";
    routeAndFlightBy2 = "";
    routeAndFlightTo3 = "";
    routeAndFlightBy3 = "";
    referenceNumber = "";
    information = "";
    airline = "";
    routeAndFlightNumber1 = "6P174";
    routeAndFlightDate1 = "07NOV2022";
    airline1 = "";
    routeAndFlightNumber2 = "";
    routeAndFlightDate2 = "";

//     // ! 5- AWB consigment details....
    //awbConsigmentDetailsAWBNumber = "61872442672";
    // awbConsigmentDetailsDepAirportCode = jsonData['DEPARTURE_AIRPORT_CODE'];

    awbConsigmentOriginPrefix = "DEL";
    awbConsigmentDestination = "HAN";
    awbConsigmentPices = "20";
    awbConsigmentWeightCode = "K";
    awbConsigmentWeight = "50";
    awbConsigmentVolumeCode = "CC";
    awbConsigmentVolume = "60";
    awbConsigmentDensity = "DC";

//     //notify model
    notifyName = "SPICES RESTAURANT";
    nofityStreetAddress = "BARAKHAMBA";
    notifyPlace = "BARAKHAMBA";
    notifyState = "NEW DELHI";
    notifyCountryCode = "IN";
    notifyPostCode = "676767";
    String Notifycountry = notifyCountryCode;

    int NotifyfirstChar = Notifycountry.codeUnitAt(0) - asciiOffset + flagOffset;
    int NotifysecondChar = Notifycountry.codeUnitAt(1) - asciiOffset + flagOffset;
    String Notifyflag =
        String.fromCharCode(NotifyfirstChar) + String.fromCharCode(NotifysecondChar);
    newnotifyContactList.add(
        NotifyExpenseList(
            Notify_Contact_Type: "Telegram",
            Notify_Contact_Detail: "+918300803649",
            flag:Notifyflag
        )
    );

    // notifyContactType = "TE";
    // notifyContactNumber = "8300803649";
    issuerBy = "MORRISON EXPRESS LOGISTICS PVT LTD";
    accountingInformationId ="A124";
    accountingInformationDetails = "MUST BE SAFE";
    referenceNumber = "88888888";
    refNo2 = " ";
    chargesDeclarationCurrency = "INR";
    chargesDeclarationCHGSCode = "PP";
    chargesDeclarationValueForCarriage = "NVD";
    chargesDeclarationValueForCustoms = "NCV";
    chargesDeclarationAmountOfInsurance = "99";
    handlingInformationSCI = "T1";
    handlingInformationRequirements =
    "EXTRA CHARGE DUE TO SPECIAL HANDLING REQUIREMENTS";
    chargeSummaryWeightChargePrepaid = "15750";
    chargeSummaryWeightChargePostpaid = "0";
    chargeSummaryValuationChargePrepaid = "0";
    chargeSummaryValuationChargePostpaid = "350";
    chargeSummaryTaxPrepaid = "100";
    chargeSummaryTaxPostpaid = "10";
    chargeSummaryDueAgentPrepaid ="100";
    chargeSummaryDueAgentPostpaid ="0";
    chargeSummaryDueCarrierPrepaid ="0";
    chargeSummaryDueCarrierPostpaid ="0";
    chargeSummaryTotalPrepaid = "15950";
    chargeSummaryTotalPostpaid = "360";
    currencyConversionRates = "302.45";
    baseCurencyrate = "77";
    destCurrencyCode = "VND";
    ccChargesInDest = "108882.13";
    chargesAtDest = "3";
    totalCollect = "108885.13";
    particularsOfShipper="MAHOGANY";
    signatureOfShipper = "MAHOGANY PRIVATE";
    rateDescriptionItemList.add(RateDescriptionItem(
      // isExpanded: false,
        pieces: 35,
        grossWeight: 350,
        grossWeightUnit: "K",
        serviceCode: "H",
        rateClass: "Q",
        itemNumber: 12321,
        autoCalculations: "Total",
        chargeableWeight: 350,
        rateCharge: 45,
        total: 15750,
        previousnatureofgoods: "TEXTILES",
        dimensionsList: [
          {
            'isSelected': false,
            'length': '10',
            'width': '10',
            'height': '10',
            'pwUnit': 'K',
            'lwhUnit': 'cm',
            'pieces': '35',
            'weight': '350'
          },
        ],
        volume: "35000 CM3",
        natureAndQuantity: "TEXTILES",
        slac: "35",
        text: ""));
    //Ratedescription
    // rateDescriptionItemList.add(RateDescriptionItem(
    //   // isExpanded: false,
    //     pieces: 4,
    //     grossWeight: 40,
    //     grossWeightUnit: "K",
    //     serviceCode: "H",
    //     rateClass: "Q         Quantity Rate",
    //     itemNumber: 12321,
    //     autoCalculations: "No",
    //     chargeableWeight: 40,
    //     rateCharge: 45,
    //     total: 1800,
    //     dimensionsList: [
    //       {
    //         'isSelected': false,
    //         'length': '10',
    //         'width': '100',
    //         'height': '10',
    //         'pwUnit': 'K',
    //         'lwhUnit': 'cm',
    //         'pices': '5',
    //         'weight': '50'
    //       },
    //     ],
    //     volume: "",
    //     natureAndQuantity: "TEXTILES",
    //     text: ""));
    otherChargesList.add(
      OtherChargesItem(
          description: "CC",
          isExpanded: false,
          entitlement: "Due agent",
          weight: "Manual data entry for\ncustoms purposes",
          amount: 100,
          minimum: 10,
          rate: 10,
          prepaidcollect:"PPD",
          useRate: false),
    );
    executedOn = "07NOV2022";
    atPlace = "NEW DELHI";
    signatureOfIssuingCarrier = "MAHOGANY PRIVATE";
    //rateDescriptionItemList.add();
    // rateModel.pieces = 1;
    // rateModel.grossWeight = 40;
    // rateModel.grossWeightUnit = "L";
    // rateModel.serviceCode = "H";
    // rateModel.rateClass = "Q";
    // rateModel.itemNumber = 12321;
    // rateModel.chargeableWeight = 40;
    // rateModel.rateCharge = 45;
    // rateModel.total = 2800;

    // rateModel.natureAndQuantity =
    //     "CONSOLIDATION\nOrigin:MV\nSLAC:6\nVolume:20CM3\n12X12X12MMT/550K";

    SPH1="EAWB";
    SPH2="EAWB";
    SpecialServiceRequest="T1";
    OtherServiceInformation="T2";
    SCI="T1";

    notifyListeners();
    setStatus();
  }
}
