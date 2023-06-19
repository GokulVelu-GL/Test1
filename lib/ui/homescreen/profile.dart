import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/profile_model.dart';
import 'package:rooster/model/user_model.dart';
import 'package:image/image.dart' as ImageProcess;
import 'package:rooster/ui/drodowns/airport_code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../string.dart';

void refreshToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var response = await http.get(Uri.parse(StringData.refreshTokenAPI),
      headers: {'x-access-tokens': prefs.getString('token')});
  var result = json.decode(response.body);
  if (result['result'] == 'verified') prefs.setString('token', result['token']);
  print(result);
}

Future<ProfileModel> profiledetails() async {
  var result;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //var response = await http.get(StringData.awblistAPI,
  //headers: {'x-access-tokens': prefs.getString('token')});
  //result = json.decode(response.body);

  //Alternative

  final url = Uri.parse(StringData.profileupload);
  final request = http.Request("GET", url);
  request.headers.addAll(<String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'x-access-tokens': prefs.getString('token')
  });

  request.body = jsonEncode({
    //"FlightList_id": id, //40,
    //"Manifest_Version": 2,
    //"FFM_PointOfLoading_AirportCode": flightLoading,
    //"FFM_PointOfUnLoading_AirportCode": flightUnloading
  });
  result = await request.send();

  final respStr = await result.stream.bytesToString();
  result = jsonDecode(respStr);

  //Alternative

  if (result['message'] == 'token expired') {
    refreshToken();
    profiledetails();
  } else {
    //getAWBlist();
    print(prefs.getString('token'));
  }
  print(" Profile Data" + '${result["name"]}');
  final profile = ProfileModel(
      username:result['name'],

      profileImage:result['base64'],
      userRole:result['role']
  );
  return profile;
}
class UserProfile extends StatefulWidget {
  const UserProfile({Key key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size.height - 185.0,
      child: Center(
        child: FutureBuilder<ProfileModel>(
          future: profiledetails(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //EasyLoading.show();
              print("Snapshot Data ${snapshot.data}");
              //getawblist=snapshot.data;
              return Profile(profile: snapshot.data);
            } else if (snapshot.hasError) {
              return Text(S.of(context).DataNotFound
                // "Data Not Found"
              );
            }

            // By default, show a loading spinner
            return CircularProgressIndicator();
            //return EasyLoading.show();
          },
        ),
      ),
    );
  }
}



class Profile extends StatefulWidget {
  ProfileModel profile;
  Profile({Key key,this.profile}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  /// Variables
  ProfileModel model;
  File imageFile;
  String emailid;
  String mobileNo;
  String teleFax;
  String _chosenValue;
  String _Teletype;
  String dropdownvalue = 'type';

  // List of items in our dropdown menu
  var EmailType = ['Professional', 'Personal', 'Office'];
  var TeleType = ["Telegram", "WhatsApp", "Fax"];
  String selectCtype;
  String selectEtype;
  String image;
  String initialCountryCode;
  // bool isExpanded= false;
  bool _expanded = false;
  bool _exp = false;
  final List<ExpenseList> expenseList = [];
  final List<ExpenseList> expenseL = [];
  final _formKey = GlobalKey<FormState>();
  final _TeleKey = GlobalKey<FormState>();
  bool isDropdownOpened = false;
  List<Map<String, dynamic>> mailList = [];
  List<Map<String, dynamic>> profilecontactList = [];
  TextEditingController ProfileContactType = new TextEditingController();
  TextEditingController ProfileEmailType = new TextEditingController();
  String name = '';
  TextEditingController Emailcontroller = new TextEditingController();
  TextEditingController Etypecontroller = new TextEditingController();
  TextEditingController Telecontroller = new TextEditingController();
  TextEditingController Teletypecontroller = new TextEditingController();

  int _ratingController;
  @override
  void initState() {
    //getProfileData();
    super.initState();
    Emailcontroller = new TextEditingController();
  }

  @override
  void dispose() {
    Emailcontroller.dispose();

    super.dispose();
  }

  void addEmail(String title, String description) {
    final expense = ExpenseList(
      id: description,
      title: title,
    );
    setState(() {
      expenseList.add(expense);
    });
  }

  void Emaildelete(String title) {
    setState(() {
      expenseList.removeWhere((element) => element.title == title);
    });
  }

  void addTele(String TeleNumber, String Tdescription, String countryCode) {
    final expense = ExpenseList(
      id: Tdescription,
      title: countryCode + " " + TeleNumber,
    );
    setState(() {
      expenseL.add(expense);
    });
  }

  void Teledelete(String title) {
    setState(() {
      expenseL.removeWhere((element) => element.title == title);
    });
  }

  Future<String> _showDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            "Add Email",
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TypeAheadField<ContactType>(
                    suggestionsCallback: ContacTypeApi.getContactType,
                    itemBuilder: (context, ContactType suggestion) {
                      final code = suggestion;
                      return ListTile(
                        title: Text(code.contactType,
                            style: TextStyle(
                                color: Theme.of(context).accentColor)),
                        subtitle: Text(code.contactCode,
                            style: TextStyle(
                                color: Theme.of(context).accentColor)),
                      );
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: ProfileEmailType,
                      // controller: Consigneecontype,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          //border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          border: OutlineInputBorder(
                              gapPadding: 2.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          labelText: "Type",
                          //S.of(context).Origin,
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor)
                          //'Origin',
                          ),
                    ),
                    onSuggestionSelected: (ContactType suggestion) {
                      List.generate(
                          profilecontactList.length,
                          (index) => profilecontactList[index]
                                  ['Consignee_Contact_Type'] =
                              suggestion.contactCode);
                      // sippercontactList[index]['Shipper_Contact_Type'] =
                      //     suggestion.contactCode;
                      ProfileEmailType.text = suggestion.contactType;
                      //_fhlModel.houseDetailsOrigin = suggestion.airportCode;
                      //
                    }),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  // initialValue: mailList[dimensionIndex]
                  // ['Shipper_Contact_Detail'] ==
                  //     0.0
                  //     ? ''
                  //     : '${mailList[dimensionI
                  //     ndex]}',
                  // onChanged: (value) {
                  //   setState(() {
                  //     mailList[dimensionIndex]=
                  //         value;
                  //   });
                  // },
                  autofocus: true,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      hintText: "Enter the Email"),
                  controller: Emailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the email address';
                    }
                    return null;
                  },
                ),

                // TextField(
                //   // initialValue: mailList[dimensionIndex]
                //   // ['Shipper_Contact_Detail'] ==
                //   //     0.0
                //   //     ? ''
                //   //     : '${mailList[dimensionI
                //   //     ndex]}',
                //   // onChanged: (value) {
                //   //   setState(() {
                //   //     mailList[dimensionIndex]=
                //   //         value;
                //   //   });
                //   // },
                //   autofocus: true,
                //   decoration: InputDecoration(hintText: "Enter the  type"),
                //   controller: Etypecontroller,
                // ),
                SizedBox(
                  height: 5,
                ),

                //static value for drop down

                // FormField<String>(validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please select the type';
                //   }
                //   return null;
                // }, builder: (FormFieldState<String> state) {
                //   return InputDecorator(
                //     decoration: InputDecoration(
                //       enabledBorder: UnderlineInputBorder(
                //         borderSide: BorderSide(
                //           color: Theme.of(context).accentColor,
                //         ),
                //       ),
                //       errorStyle:
                //           TextStyle(color: Colors.redAccent, fontSize: 16.0),
                //       hintText: 'Select Email type',
                //       // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)
                //       // )
                //     ),
                //     isEmpty: selectEtype == '',
                //     child: DropdownButtonHideUnderline(
                //       child: DropdownButton<String>(
                //         value: selectEtype,
                //         isDense: true,
                //         onChanged: (String newValue) {
                //           setState(() {
                //             selectEtype = newValue;
                //             state.didChange(newValue);
                //           });
                //         },
                //         items: EmailType.map((String value) {
                //           return DropdownMenuItem<String>(
                //             value: value,
                //             child: Text(value),
                //           );
                //         }).toList(),
                //       ),
                //     ),
                //   );
                // }),

                // DropdownButton<String>(
                //   hint: Text("type"),
                //   value: _chosenValue,
                //   items: <String>['Professional',
                //     'Personal',
                //     'office',]
                //       .map((String value) {
                //     return new DropdownMenuItem<String>(
                //       value: value,
                //       child: new Text(value),
                //     );
                //   }).toList(),
                //   onChanged: (String val) {
                //     setState(() {
                //       _chosenValue = val;
                //     });
                //   },
                // ),
              ],
            ),
          ),
          actions: [
            TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            TextButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    addEmail(Emailcontroller.text, ProfileEmailType.text
                        //selectEtype
                        // _chosenValue
                        //Etypecontroller.text
                        );
                    Navigator.pop(context);
                  }

                  // Emailcontroller.text.isNotEmpty
                  // ?
                  // addEmail(
                  //     Emailcontroller.text,
                  //     selectEtype
                  //   // _chosenValue
                  //     //Etypecontroller.text
                  //
                  // ):null;

                  Emailcontroller.clear();
                  ProfileEmailType.clear();
                  // Navigator.of(context).pop(Emailcontroller.text);
                  // Emailcontroller.clear();
                },
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                )),
          ],
        ),
      );

  Future<String> _showDialogTele() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Stack(children: [
            Text(
              "Add Contacts",
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ]),
          content: Form(
            key: _TeleKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TypeAheadField<ContactType>(
                    suggestionsCallback: ContacTypeApi.getContactType,
                    itemBuilder: (context, ContactType suggestion) {
                      final code = suggestion;
                      return ListTile(
                        title: Text(code.contactType,
                            style: TextStyle(
                                color: Theme.of(context).accentColor)),
                        subtitle: Text(code.contactCode,
                            style: TextStyle(
                                color: Theme.of(context).accentColor)),
                      );
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: ProfileContactType,
                      // controller: Consigneecontype,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          //border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          border: OutlineInputBorder(
                              gapPadding: 2.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          labelText: "Type",
                          //S.of(context).Origin,
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor)
                          //'Origin',
                          ),
                    ),
                    onSuggestionSelected: (ContactType suggestion) {
                      List.generate(
                          profilecontactList.length,
                          (index) => profilecontactList[index]
                                  ['Consignee_Contact_Type'] =
                              suggestion.contactCode);
                      // sippercontactList[index]['Shipper_Contact_Type'] =
                      //     suggestion.contactCode;
                      ProfileContactType.text = suggestion.contactType;
                      //_fhlModel.houseDetailsOrigin = suggestion.airportCode;
                      //
                    }),
                SizedBox(
                  height: 10,
                ),
                Container(
                    child: IntlPhoneField(
                  controller: Telecontroller,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                      // borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    //border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                      // borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),

                    //decoration for Input Field
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode: 'IN', //default contry code, NP for Nepal
                  onChanged: (phone) {
                    setState(() {
                      initialCountryCode = phone.countryCode as String;
                    });
                    //when phone number country code is changed
                    print(phone.completeNumber); //get complete number
                    print(phone.countryCode); // get country code only
                    print(phone.number); // only phone number
                  },
                )),
              ],
            ),
          ),
          actions: [
            TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            TextButton(
                onPressed: () {
                  if (_TeleKey.currentState.validate()) {
                    addTele(Telecontroller.text, ProfileContactType.text,
                        initialCountryCode
                        // _Teletype
                        //Teletypecontroller.text
                        );
                    Navigator.pop(context);
                  }

                  Telecontroller.clear();
                  Teletypecontroller.clear();
                  // Navigator.of(context).pop(Emailcontroller.text);
                  // Emailcontroller.clear();
                },
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                )),
          ],
        ),
      );

  Future<String> getProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailid = await prefs.getString('email');
    print("Email id" + emailid);
    return emailid;
  }

  /// Widget
  @override
  Widget build(BuildContext context) {
     image= widget.profile.profileImage;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            S.of(context).Profile,
            // "Profile"
          )),
      body: FutureBuilder(
          future: getProfileData(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return buildProfile(); // your widget
            } else
              return CircularProgressIndicator();
          }),
    );
  }
  Widget getImagenBase64() {
    // _imageBase64 = imagen;
    final UriData data = Uri.parse(widget.profile.profileImage).data;
    Uint8List myImage = data.contentAsBytes();
    // var _bytesImage = Base64Decoder().convert(widget.profile.profileImage);
    // const Base64Codec base64 = Base64Codec();
    //
    // // if (_imageBase64 == null) return new Container();
    // var bytes = base64.decode((widget.profile.profileImage).toString());

    return Image.memory(
      myImage,
      width: 200,
      fit: BoxFit.fitWidth,

    );
  }

  Widget buildProfile() {
    final double circleRadius = 120.0;
    print("Proile model" + '${emailid}');
    final UriData data = Uri.parse(widget.profile.profileImage).data;
    Uint8List myImage = data.contentAsBytes();
    bool isVisible = true;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(children: [
        // getImagenBase64(),
        Stack(children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(top: 15, bottom: 5, left: 15, right: 15),
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: circleRadius / 2.0,
                  ),
                  child: Container(
                    height: 150.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Theme.of(context).backgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.0,
                          offset: Offset(0.0, 5.0),
                        ),
                      ],
                    ),
                    width: double.infinity,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: circleRadius / 3,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                      color: Colors.grey,
                                      onPressed: () async {

                                        _getFromGallery();
                                      },
                                      icon: Image.asset(
                                        "assets/profile/galery.png"
                                          //"https://cdn-icons-png.flaticon.com/512/465/465599.png"
                                      )),
                                  Container(
                                    height: 40.0,
                                  ),
                                  IconButton(
                                      color: Colors.blue[100],
                                      onPressed: () {
                                        _getFromCamera();
                                        //print("Widget Email id" + '${emailid}');
                                      },
                                      icon: Image.asset(
                                      "assets/profile/camera.png"
                                      //    "https://cdn-icons-png.flaticon.com/512/2983/2983067.png"
                                      )),
                                ],
                              ),
                            ),
                            Text(
                              widget.profile.username,
                              //S.of(context).Gokul,
                              //"Gokul Velu",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15.0),
                            ),
                            Text(
                              widget.profile.userRole,
                              //S.of(context).Admin,
                              // "Admin",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0,
                                  color: Colors.green),
                            ),
                          ],
                        )),
                  ),
                ),
                CircularProfileAvatar(
                  '',
                  child: imageFile == null
                      ?
                      Image.memory(
                      myImage,
                         fit: BoxFit.fitHeight,
                      )

                  // Image.asset(
                  //        "assets/profile/default.png",
                  //        // "https://png.pngitem.com/pimgs/s/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png",
                  //         //"https://www.pngarea.com/pngm/4/5041637_beard-png-professional-business-man-icon-png-download.png",
                  //         fit: BoxFit.cover,
                  //       )
                      : Image.file(
                    imageFile,
                    // File(widget.profile.profileImage),
                          fit: BoxFit.cover,
                        ),
                  borderColor: Colors.black,
                  borderWidth: 2,
                  elevation: 5,
                  radius: 50,
                ),
              ],
            ),
          ),
        ]),
        Padding(
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Theme.of(context).backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0,
                  offset: Offset(0.0, 5.0),
                ),
              ],
            ),
            width: double.infinity,
            child: ListTile(
              leading: Icon(
                Icons.email,
                color: Theme.of(context).accentColor,
              ),
              title: TextFormField(
                initialValue: emailid,
                //"dronaeawb1@gmail.com", //emailid,
                onChanged: (value) {
                  setState(() {
                    emailid = value;
                  });
                },
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    enabledBorder: InputBorder.none),
              ),
              subtitle: Text(S.of(context).email),
              trailing: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () async {
                    final name = await _showDialog();
                    if (name == null || name.isEmpty) return;
                    setState(() {
                      this.name = name;
                    });
                  }),
            ),
          ),
        ),
        Container(
          child: Column(
            children: expenseList.map((e) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Theme.of(context).backgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.0,
                          offset: Offset(0.0, 5.0),
                        ),
                      ],
                    ),
                    width: 325,
                    child: ListTile(
                      leading: Icon(
                        Icons.email,
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(
                        '${e.title}',
                      ),
                      subtitle: Text(
                        '${e.id}',
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          return showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Center(child: Text('Delete')),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      Text('Would you like to delete'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(
                                      'Confirm',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                                    onPressed: () {
                                      Emaildelete(e.title);
                                      // Consigneecontactdelete(e.title);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          // Emaildelete(e.title);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Theme.of(context).backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0,
                  offset: Offset(0.0, 5.0),
                ),
              ],
            ),
            width: double.infinity,
            child: ListTile(
              leading: Icon(
                Icons.phone,
                color: Theme.of(context).accentColor,
              ),
              title: TextFormField(
                initialValue: "+91 9597774279",
                onChanged: (value) {
                  setState(() {
                    teleFax = value;
                  });
                },
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    enabledBorder: InputBorder.none),
              ),
              subtitle: Text("Mobile Number"
                  //S.of(context).Tele

                  ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () async {
                    final name = await _showDialogTele();
                    if (name == null || name.isEmpty) return;
                    setState(() {
                      this.name = name;
                    });
                  }),
            ),
          ),
        ),
        Container(
          child: Column(
            children: expenseL.map((e) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Theme.of(context).backgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.0,
                          offset: Offset(0.0, 5.0),
                        ),
                      ],
                    ),
                    width: 325,
                    child: ListTile(
                      leading: Icon(
                        Icons.phone,
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(
                        '${e.title}',
                      ),
                      subtitle: Text(
                        '${e.id}',
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          return showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Center(child: Text('Delete')),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                          'Would you like to delete Mobile number'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(
                                      'Confirm',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                                    onPressed: () {
                                      Teledelete(e.title);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          // Scontactdelete(e.title);
                        },

                        //  Teledelete(e.title);
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Theme.of(context).backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0,
                  offset: Offset(0.0, 5.0),
                ),
              ],
            ),
            width: double.infinity,
            child: ListTile(
              leading: Icon(
                Icons.phone,
                color: Theme.of(context).accentColor,
              ),
              title: TextFormField(
                initialValue: "+91 9597774279",
                onChanged: (value) {
                  setState(() {
                    teleFax = value;
                  });
                },
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    enabledBorder: InputBorder.none),
              ),
              subtitle: Text(S.of(context).TeleFax),
              trailing: Icon(
                Icons.arrow_right,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Theme.of(context).backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0,
                  offset: Offset(0.0, 5.0),
                ),
              ],
            ),
            width: double.infinity,
            child: ListTile(
              leading: Icon(
                Icons.place_outlined,
                color: Theme.of(context).accentColor,
              ),
              title: TextFormField(
                initialValue: "Chennai",
                onChanged: (value) {
                  setState(() {
                    emailid = value;
                  });
                },
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    enabledBorder: InputBorder.none),
              ),
              subtitle: Text(S.of(context).Address
                  //  "Address"
                  ),
              trailing: Icon(
                Icons.arrow_right,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ),
        // Padding(
        //   padding:
        //       const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(15.0),
        //       color: Theme.of(context).backgroundColor,
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.black26,
        //           blurRadius: 8.0,
        //           offset: Offset(0.0, 5.0),
        //         ),
        //       ],
        //     ),
        //     width: double.infinity,
        //     child: ListTile(
        //       leading: Icon(
        //         Icons.email,
        //         color: Theme.of(context).accentColor,
        //       ),
        //       title: TextFormField(
        //         initialValue: emailid,
        //         onChanged: (value) {
        //           setState(() {
        //             emailid = value;
        //           });
        //         },
        //         decoration: InputDecoration(enabledBorder: InputBorder.none),
        //       ),
        //       subtitle: Text(S.of(context).email),
        //       trailing: Icon(
        //         Icons.arrow_right,
        //         color: Theme.of(context).accentColor,
        //       ),
        //     ),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 20,
          ),
          child: Container(
              // width: 80,
              // height: 30,
              child: ElevatedButton.icon(
            onPressed: () {
              // Respond to button press
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).backgroundColor),
            ),
            icon: Icon(
              Icons.cloud_circle,
              size: 18,
              color: Theme.of(context).accentColor,
            ),
            label: Text(
              S.of(context).UpdateProfile,
              //"Update Profile",
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          )),
        )
      ]),
    );


    //  Scaffold(
    //     appBar: AppBar(
    //       title: Text("Image Picker"),
    //     ),
    //     // body: Container(
    //     //     child: imageFile == null
    //     //         ? Container(
    //     //             alignment: Alignment.center,
    //     //             child: Column(
    //     //               mainAxisAlignment: MainAxisAlignment.center,
    //     //               children: <Widget>[
    //     //                 RaisedButton(
    //     //                   color: Colors.greenAccent,
    //     //                   onPressed: () {
    //     //                     _getFromGallery();
    //     //                   },
    //     //                   child: Text("PICK FROM GALLERY"),
    //     //                 ),
    //     //                 Container(
    //     //                   height: 40.0,
    //     //                 ),
    //     //                 RaisedButton(
    //     //                   color: Colors.lightGreenAccent,
    //     //                   onPressed: () {
    //     //                     _getFromCamera();
    //     //                   },
    //     //                   child: Text("PICK FROM CAMERA"),
    //     //                 )
    //     //               ],
    //     //             ),
    //     //           )
    //     //         : Container(
    //     //             child: Image.file(
    //     //               imageFile,
    //     //               fit: BoxFit.cover,
    //     //             ),
    //     //           ))
    //     body: Column(
    //         //child: imageFile == null
    //         children: [

    //           SizedBox(
    //             height: 10,
    //           ),
    //           Container(
    //             alignment: Alignment.center,
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: <Widget>[
    //                 IconButton(
    //                     color: Colors.grey,
    //                     onPressed: () {
    //                       _getFromGallery();
    //                     },
    //                     icon: Icon(Icons.photo)),
    //                 Container(
    //                   height: 40.0,
    //                 ),
    //                 IconButton(
    //                     color: Colors.grey,
    //                     onPressed: () {
    //                       _getFromCamera();
    //                     },
    //                     icon: Icon(Icons.camera)),
    //               ],
    //             ),
    //           )
    //         ]));
  }

  /// Get from gallery
//   _getFromGallery() async {
//
//     // PickedFile pickedFile = await ImagePicker().getImage(
//     //   source: ImageSource.gallery,
//     //   maxWidth: 1800,
//     //   maxHeight: 1800,
//     // );
//     // _cropImage(pickedFile.path);
//     // if (pickedFile != null) {
//     //   setState(() {
//     //     _cropImage(pickedFile.path);
//     //     //imageFile = File(pickedFile.path);
//     //   });
//     // }
//     String imagepath = " /data/user/img.jpg";
// //image path, you can get it with image_picker package
//
//     File imagefile = File(imagepath); //convert Path to File
//     Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
//     String base64string = base64.encode(imagebytes); //convert bytes to base64 string
//     print(base64string);
//   }
  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() async{
        imageFile = File(pickedFile.path);
        Uint8List imagebytes = await imageFile.readAsBytes(); //convert to bytes
     String base64string = base64.encode(imagebytes);
     widget.profile.profileImage=base64string;

        // Uint8List _bytes = base64.decode(base64string);
        // imageFile = File.fromRawPath(_bytes);
     //convert bytes to base64 string
     //    final _imageFile = ImageProcess.decodeImage(
     //      imageFile.readAsBytesSync(),
     //    );
     //    String base64Image = base64Encode(ImageProcess.encodePng(_imageFile));
     //    imageFile=File(base64Image);

    print(base64string);
      });
    }
  }

  // Get from Camera
  _getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    // _cropImage(pickedFile.path);
    // if (pickedFile != null) {
    //   setState(() {
    //     //imageFile = File(pickedFile.path);
    //   });
    // }
  }

  /// Crop Image
  // Future<Null> _cropImage(filePath) async {
  //   File croppedImage = await ImageCropper.cropImage(
  //       sourcePath: filePath,
  //       maxWidth: 1080,
  //       maxHeight: 1080,
  //       aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
  //   if (croppedImage != null) {
  //     imageFile = croppedImage;
  //     setState(() {});
  //   }
  // }

  // _cropImage(filePath) async {
  //   File croppedImage = await ImageCropper.cropImage(
  //     sourcePath: filePath,
  //     maxWidth: 1080,
  //     maxHeight: 1080,
  //   );
  //   if (croppedImage != null) {
  //     imageFile = croppedImage;
  //     setState(() {
  //       //imageFile = File(croppedImage);
  //     });
  //   }
  // }
}

class ExpenseList {
  String title;
  String id;
  ExpenseList({
    @required this.title,
    @required this.id,
  });
}

// ignore: must_be_immutable
class ContactCard extends StatelessWidget {
  Icon cardIcon;
  String cardTitle;
  String cardSubTitle;

  //ContactCard(Icon icon, String s, String t);
  ContactCard({this.cardIcon, this.cardTitle, this.cardSubTitle});
  @override
  Widget build(BuildContext context) {
    print("cardTitle" + '$cardTitle');
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              offset: Offset(0.0, 5.0),
            ),
          ],
        ),
        width: double.infinity,
        child: ListTile(
          leading: cardIcon,
          title: Text(cardTitle),
          subtitle: Text(cardSubTitle),
          trailing: Icon(Icons.arrow_right),
        ),
      ),
    );
  }
}
