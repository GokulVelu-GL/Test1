class ManifestBulkModel {
  String prefix;
  String awbNumber;
  String origin;
  String destination;
  String pieces;
  String totalPieces;
  String weight;
  String totalWeight;
  String weightUnit;
  String mash;
  String dg;
  String volume;
  String volumeUnit;
  String natureOfGoods;
  String customsExamIndicator;
  String customsExamOrderNo;
  String customsExamDateTime;
  String scanType;
  String internalRemarks;
  String manifestRemarks;
  String officeUseRemarks;

  ManifestBulkModel(
      {this.prefix = "",
      this.awbNumber = "",
      this.origin = "",
      this.destination = "",
      this.pieces = "",
      this.totalPieces = "",
      this.weight = "",
      this.totalWeight = "",
      this.weightUnit = "",
      this.dg = "",
      this.volume = "",
      this.volumeUnit = "",
      this.natureOfGoods = "",
      this.customsExamDateTime = "",
      this.customsExamOrderNo = "",
      this.customsExamIndicator = "",
      this.scanType = "",
      this.internalRemarks = "",
      this.manifestRemarks = "",
      this.officeUseRemarks = ""});

  ManifestBulkModel.fromJson(Map<String, dynamic> json)
      : prefix = json['FFM_AWB_Identification_AirlinePrefix'],
        awbNumber = json['FFM_AWB_Identification_AWB_SerialNumber'],
        origin = json['FFM_AirportCode_Origin'],
        destination = json['FFM_AirportCode_Destination'],
        dg = json['FFM_Consignment_Detail_DensityGroup'],
        natureOfGoods = json['FFM_Consignment_Detail_NatureOfGoods'],
        pieces = json['FFM_Consignment_Detail_NumberOfPieces'],
        weight = json['FFM_Consignment_Detail_Quantity_Detail_Weight'],
        weightUnit = json['FFM_Consignment_Detail_Quantity_Detail_Weight_Code'],
        totalPieces =
            json['FFM_Consignment_Detail_TotalConsignment_NumberOfPieces'],
        volume = json['FFM_Consignment_Detail_VolumeAmount'],
        volumeUnit = json['FFM_Consignment_Detail_VolumeCode'],
        customsExamDateTime = json['RT_CustomsExaminationDateTime'],
        customsExamIndicator = json['RT_CustomsExaminationIndicator'],
        customsExamOrderNo = json['RT_CustomsExaminationOrderNo'],
        officeUseRemarks = json['RT_ForOfficeUseRemarks'],
        internalRemarks = json['RT_InternalRemarks'],
        manifestRemarks = json['RT_ManifestRemarks'],
        scanType = json['RT_ScanType'];
  // origin = json['FFM_AirportCode_Origin'];

  Map<String, dynamic> toJson() {
    return {
      "FFM_AWB_Identification_AWB_SerialNumber": awbNumber,
      "FFM_AWB_Identification_AirlinePrefix": prefix,
      "FFM_Aircraft_Identification_Day": "",
      "FFM_Aircraft_Identification_Month": "",
      "FFM_AirportCode_Destination": destination,
      "FFM_AirportCode_Origin": origin,
      "FFM_Consignment_Detail_DensityGroup": dg,
      "FFM_Consignment_Detail_DensityIndicator": "",
      "FFM_Consignment_Detail_NatureOfGoods": natureOfGoods,
      "FFM_Consignment_Detail_NumberOfPieces": pieces,
      "FFM_Consignment_Detail_Quantity_Detail_Weight": weight,
      "FFM_Consignment_Detail_Quantity_Detail_Weight_Code": weightUnit,
      "FFM_Consignment_Detail_Shipment_Description_Code": "T",
      "FFM_Consignment_Detail_Special_Handling_Code1": "",
      "FFM_Consignment_Detail_Special_Handling_Code2": "",
      "FFM_Consignment_Detail_Special_Handling_Code3": "",
      "FFM_Consignment_Detail_Special_Handling_Code4": "",
      "FFM_Consignment_Detail_Special_Handling_Code5": "",
      "FFM_Consignment_Detail_Special_Handling_Code6": "",
      "FFM_Consignment_Detail_Special_Handling_Code7": "",
      "FFM_Consignment_Detail_Special_Handling_Code8": "",
      "FFM_Consignment_Detail_Special_Handling_Code9": "",
      "FFM_Consignment_Detail_TotalConsignment_NumberOfPieces": totalPieces,
      "FFM_Consignment_Detail_TotalConsignment_Shipment_Description_Code": "",
      "FFM_Consignment_Detail_VolumeAmount": volume,
      "FFM_Consignment_Detail_VolumeCode": volumeUnit,
      "FFM_Consignment_Onward_Movement_Information": [],
      "FFM_CustomsOrigin_Code": "",
      "FFM_Dimension_Details": [],
      "FFM_First_Other_Service_Information": "",
      "FFM_OtherCustoms_Information": [],
      "FFM_PointOfLoading_Aircraft_Registeration": "",
      "FFM_PointOfLoading_AirportCode_Arrival": "",
      "FFM_PointOfLoading_ISO_Country_Code": "",
      "FFM_Second_Other_Service_Information": "",
      "RT_BillofEntryNo": "",
      "RT_CustomsExaminationDateTime": customsExamDateTime,
      "RT_CustomsExaminationIndicator": customsExamIndicator,
      "RT_CustomsExaminationOfficerName": "",
      "RT_CustomsExaminationOrderNo": customsExamOrderNo,
      "RT_CustomsRemarks": "",
      "RT_ForOfficeUseRemarks": officeUseRemarks,
      "RT_InternalRemarks": internalRemarks,
      "RT_ManifestRemarks": manifestRemarks,
      "RT_PhysicalVerification": "",
      "RT_ScanType": scanType,
      "RT_Scanned_Indicator": "",
      "RT_ShippingBillNo": ""
    };
  }
}
