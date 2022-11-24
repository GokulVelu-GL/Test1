import 'package:flutter/cupertino.dart';

class UserModel with ChangeNotifier {
  String _email;
  String _token;
  UserModel(this._email, this._token);
  get email => _email;
  get token => _token;
  set email(value) {
    _email = value;
    notifyListeners();
  }

  set token(value) {
    _token = value;
    notifyListeners();
  }


}
