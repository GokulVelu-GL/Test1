import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileModel {
  String username;
  String userEmailid = "gokulvelu22@gmail.com";
  String userRole = "";
  String phoneNumber = "";
  String profileImage = "";

  setValue() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = await preferences.getString('email');
  }

  ProfileModel({this.username, this.userEmailid, this.phoneNumber,
      this.profileImage, this.userRole});
  // get username => _username;
  // get userEmailid => _userEmailid;
  // set username(value) {
  //   _username = value;
  //   notifyListeners();
  // }

  // set userEmailid(value) {
  //   _userEmailid = value;
  //   notifyListeners();
  // }

  factory ProfileModel.fromJson(Map<String,dynamic> json){
    return ProfileModel(
        username:json['name'],
        userEmailid:json[''],
        phoneNumber:json[''],
        profileImage:json['base64'],
        userRole:json['role']
    );
  }
}
