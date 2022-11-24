import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

class LanguageChangeProvider with ChangeNotifier{
  Locale _currentLocale =new Locale("en");


  Locale get currentLocale => _currentLocale;

  void changeLocale(String _locale){
    this._currentLocale = new Locale(_locale);
    //in this any changes in language are anything notifylistener is also update or notify
    notifyListeners();
  }
}