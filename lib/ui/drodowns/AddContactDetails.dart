import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddContactdetails extends ChangeNotifier {
  String identifier;
  String contactNumber;

  AddContactdetails(
//      this._dimensionsList,
      {
    this.identifier,
    this.contactNumber,
  });
  // static List<AddContactdetails> getUsers() {
  //   return <AddContactdetails>[
  //     AddContactdetails(identifier: "Telegram", contactNumber: "+919597774279"),
  //     AddContactdetails(
  //         identifier: "Whats App", contactNumber: "+918300803649"),
  //   ];
  // }
}
