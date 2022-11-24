import 'package:rooster/model/dimension_item.dart';
import 'package:rooster/model/rate_description_items.dart';

class RateDescriptionModel {
  // ! 11 - Rate description (Add, Modify, remove)....
  List<RateDescriptionItem> rateDescriptionItemList = List<RateDescriptionItem>();
  List<DimensionItem> dimList = List<DimensionItem>();
  int rateDescriptionStatus = 0;

  void clearRateDescriptionModel() {
    this.rateDescriptionItemList.clear();
    this.rateDescriptionStatus = 0;
  }

  void setStatusRateDescriptionModel() {
    if (rateDescriptionItemList.length == 0) {
      rateDescriptionStatus = 0;
    } else {
      rateDescriptionStatus = 1;
    }
  }
}
