class LinkItem {
  final String amount;
  final String code;
  final String entilment;

  LinkItem({this.amount, this.code, this.entilment});

  LinkItem.fromJson(Map<String, dynamic> json)
      : amount = json['Amount'],
        code = json['Code'],
        entilment = json['Entitlement'];

  Map<String, dynamic> toJson() {
    return {'Amount': amount, 'Code': code, 'Entitlement': entilment};
  }
}
