class DimensionItem{
  int length;
  int width;
  int height;
  int dimpieces;
  int dimweight;
  String lwhunit;
  String pwunit;
  DimensionItem({
   this.length,
   this.width,
   this.height,
   this.dimpieces,
   this.dimweight,
    this.lwhunit,
    this.pwunit
});
  DimensionItem.fromJson(Map<String, dynamic> json)
      : length = json['length'],
  width=json['width'],
  height=json['height'],
  lwhunit=json['lwhUnit'],
  dimpieces=json['pieces'],
  pwunit=json['pwUnit'],
  dimweight=json['weight'];
  Map<String, dynamic> toJson() {
    return {
      'length':length,
      'width':width,
      'height':height,
      'lwhUnit':lwhunit,
      'weight':dimweight,
      'pieces':dimpieces,
      'pwUnit':pwunit
    };
  }
}