class OtherChargesItem {
  String description;
  int amount;
  String entitlement;
  double rate;
  bool useRate;
  String weight;
  double minimum;
  bool isExpanded;
  String prepaidcollect;

  OtherChargesItem(
      {this.description = "",
      this.amount = 0,
      this.entitlement = "",
      this.rate = 0.0,
      this.useRate = false,
      this.weight = "",
      this.minimum = 0.0,
      this.isExpanded = false,
      this.prepaidcollect=""
      });

  OtherChargesItem.fromJson(Map<String, dynamic> json)
      : amount = int.tryParse(json['Amount'].toString()),
        description = json['Code'],
        entitlement = json['Entitlement'],
        useRate = false,
        weight = "",
        isExpanded = false;

  Map<String, dynamic> toJson() {
    return {
      'Amount': amount,
      'Code':
      //entitlement=="Due agent"?
      description,
          //+"A":description+"C",
      'Entitlement': entitlement=="Due agent"?"A":"C",
    };
  }
}
