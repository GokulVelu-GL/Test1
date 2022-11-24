import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/profile_model.dart';
import 'package:rooster/model/user_model.dart';
import 'package:rooster/string.dart';
import 'package:rooster/ui/homescreen/main_homescreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../languagechangeprovider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String mailId;
  String _password;
  String tenant;
  bool _obscureText = true;

  Widget button = Text(
      //S.of(context).Login
      'Login',
      style: TextStyle(fontSize: 20));

  String resetMail;

  @override
  void dispose() {
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  resentConfirmation() async {
    var response = await http.post(StringData.emailConfirmationAPI, body: {
      'email': mailId,
    });
    var result = json.decode(response.body);
    if (result["result"] == "success") {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(result["message"])));
    }
  }

  loginUser() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance(); // ! get SharedPreferences....
    try {
      var response = await http.post(StringData.loginAPI, body: {
        'email': mailId,
        'password': _password,
        'TenantName': "tenant"
      }, headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      var result = json.decode(response.body);

      if (result["result"] == "verified") {
        UserModel model = Provider.of<UserModel>(context,
            listen: false); // TODO:use the provide....
        model.email = mailId;
        model.token = result["token"];

        await prefs.setString(
            'token', result["token"].toString()); // ! Save the token local....
        await prefs.setString('email', mailId.toString());
        // ProfileModel profileModel = Provider.of<ProfileModel>(context,
        //     listen: false); // ! Save the email local....
        // profileModel.username = 'Gokul Velu';

        setState(() {
          button = Text(S.of(context).Login,
              //'Login'
              style: TextStyle(fontSize: 20));
        });
        if (StringData.airportCodes == null ||
            StringData.airportCodes.isEmpty ||
            StringData.specialhandlinggroup.isEmpty ||
            StringData.airlineCodes.isEmpty||
        StringData.contactType.isEmpty) {
          StringData.loadAirportCode();
          StringData.loadtContactType();
          StringData.loadAirlineCode();
          StringData.loadRateClassCode();
          StringData.loadShgCode();
          StringData.loadCurrency();

        }
        if (prefs.getStringList("exrate") == null) {
          StringData.loadExchangeRate();
          print('Shared preference ${prefs.getStringList("exrate")}');
          //print('Shared preference ${prefs.getStringList("exrate")}');
        }
        print('Shared preference ${prefs.getStringList("exrate")}');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      } else {
        setState(() {
          button = Text(S.of(context).Login,
              //'Login'
              style: TextStyle(fontSize: 20));
        });
        if (result["error"] ==
            "Your email address has not yet been confirmed") {
          showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 250,
                child: Stack(
                  overflow: Overflow.visible,
                  alignment: Alignment.topCenter,
                  fit: StackFit.loose,
                  children: <Widget>[
                    Transform.translate(
                      offset: Offset(0, -50),
                      child: ClipOval(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: FittedBox(
                            alignment: Alignment.center,
                            child: Image.asset("assets/images/logo.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, 60),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              S
                                  .of(context)
                                  .Youremailaddresshasnotyetbeenconfirmed,
                              //"Your email address has not yet been confirmed",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            elevation: 5,
                            onPressed: () {
                              Navigator.of(context).pop();
                              resentConfirmation();
                            },
                            child: Text(
                              S.of(context).ResentConfirmation,
                              //"Resent Confirmation"
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(result["error"])));
        }
      }
    } catch (e) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      print(e.toString());
    }
  }

  resetPassword() async {
    var response = await http.post(StringData.forgotPasswordAPI, body: {
      'email': resetMail,
    });
    var result = json.decode(response.body);

    if (result["result"] == "success") {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(result["message"])));
    }
  }

  final _formKey = GlobalKey<FormState>();

  FocusNode emailIdTextFieldFocusNode = FocusNode();
  FocusNode passwordTextFieldFocusNode = FocusNode();
  FocusNode tenantFieldFocusNode = FocusNode();

  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US'), 'lang': "en", "sh": "EN"},
    {'name': 'தமிழ்', 'locale': Locale('ta', 'IN'), 'lang': 'ta', "sh": "TA"},
    // {'name':'ಕನ್ನಡ','locale': Locale('kn','IN'),'lang': 'kn'},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN'), 'lang': 'hi', "sh": "Hi"},
    {'name': 'عربي', 'locale': Locale('ar', 'MY'), 'lang': 'ar', "sh": "AR"},
  ];

  buildLanguageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text(
              S.of(context).ChooseYourLanguage,
              style: TextStyle(color: Theme.of(context).accentColor),
              //  'Choose Your Language'
            ),
            content: Container(
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Text(
                          locale[index]['name'],
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                        onTap: () {
                          print(locale[index]['name']);
                          setState(() {
                            txt = index;
                          });

                          context
                              .read<LanguageChangeProvider>()
                              .changeLocale(locale[index]['lang']);
                          // updateLanguage(locale[index]['locale']);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Theme.of(context).accentColor,
                    );
                  },
                  itemCount: locale.length),
            ),
          );
        });
  }

  var txt = 0;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return
      Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: TextButton.icon(
              onPressed: () {
                buildLanguageDialog(context);
              },
              icon: Icon(
                Icons.language_outlined,
                color: Theme.of(context).accentColor,
              ),
              label: Text(
                S.of(context).Language,
                style: TextStyle(color: Theme.of(context).accentColor),
                //'Language'
              )),
          // child: Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: <Widget>[
          //     IconButton(
          //       icon: const Icon(Icons.language_outlined),
          //       onPressed: () {},
          //     ),
          //     Text('Language'),
          //     SizedBox(
          //       width: 4,
          //     )
          //   ],
          // ),
          // child:
          //  IconButton(
          //     icon: Icon(
          //       Icons.language,
          //       color: Colors.blue,
          //     ),
          //     onPressed: () {
          //       // buildLanguageDialog(context);
          //     }),
        ),
        Container(
          width: width * 0.9,
          height: height * 0.6,
          child: Center(
            child: Column(
              children: [
                // IconButton(
                //     alignment: Alignment.topRight,
                //     icon: Row(
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   children: [
                //     Icon(Icons.language,color: Colors.blue,),
                //     // Padding(
                //     //   padding: const EdgeInsets.only(left: 20),
                //     //   child: Text(
                //     //     S.of(context).Language,
                //     //     // "Language"
                //     //   ),
                //     // ),
                //   ],
                // ),
                //     onPressed: ()
                //     {
                //       buildLanguageDialog(context);
                //     }),
                Container(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      // child: Padding(
                      //   padding: EdgeInsets.symmetric(
                      //       vertical: 20.0, horizontal: 5.0),
                      //   child:
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Align(
                          //   alignment: Alignment.topRight,
                          //   child: IconButton(icon: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.end,
                          //     children: [
                          //       Icon(Icons.language,color: Colors.blue,),
                          //       // Padding(
                          //       //   padding: const EdgeInsets.only(left: 20),
                          //       //   child: Text(
                          //       //     S.of(context).Language,
                          //       //     // "Language"
                          //       //   ),
                          //       // ),
                          //     ],
                          //   ),
                          //       onPressed: ()
                          //       {
                          //         buildLanguageDialog(context);
                          //       }),
                          // ),
                          titleText(),
                          emailTextField(),
                          passwordTextField(),
                          //tenantTextField(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              forgetPasswordButton(),
                              loginButton(),
                            ],
                          )
                        ],
                        //),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  titleText() {
    return Text(
      S.of(context).Login,
      //"Login",
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  emailTextField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
        focusNode: emailIdTextFieldFocusNode,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).accentColor,
              ),
            ),
            icon: Icon(Icons.email, color: Theme.of(context).accentColor),
            labelText: S.of(context).EmailId,
            labelStyle: TextStyle(color: Theme.of(context).accentColor)
            //"Email Id",
            ),
        onFieldSubmitted: (value) {
          _fieldFocusChange(
              context, emailIdTextFieldFocusNode, passwordTextFieldFocusNode);
        },
        onChanged: (value) => mailId = value,
        validator: (value) {
          if (value.isEmpty) {
            return S.of(context).Thisfieldisempty;
            //"This field is empty";
          }
          return value.contains('@') && value.contains('.')
              ? null
              : S.of(context).InvalidEmailId;
          //"Invalid Email Id.";
        },
      ),
    );
  }

  passwordTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              focusNode: passwordTextFieldFocusNode,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) {
                passwordTextFieldFocusNode.unfocus();
              },
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                icon: Icon(
                  Icons.lock,
                  color: Theme.of(context).accentColor,
                ),
                labelText: S.of(context).Password,
                labelStyle: TextStyle(color: Theme.of(context).accentColor),
                //"Password",
                suffixIcon: IconButton(
                  onPressed: _toggle,
                  color: Theme.of(context).accentColor,
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
              onChanged: (value) => _password = value,
              obscureText: _obscureText,
              validator: (value) {
                if (value.isEmpty) {
                  return S.of(context).Thisfieldisempty;

                  //"This field is empty";
                }
                return null;
              },
            ),
            flex: 4,
          ),
        ],
      ),
    );
  }

  tenantTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              focusNode: tenantFieldFocusNode,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) {
                tenantFieldFocusNode.unfocus();
              },
              decoration: InputDecoration(
                  icon: Icon(Icons.vpn_lock_sharp),
                  //labelText: S.of(context).tenant,
                  //"Tenant",
                  labelText: S.of(context).CustomerCode
                  //"Customer Code",
                  // suffixIcon: IconButton(
                  //   onPressed: _toggleConfirmPassword,
                  //   icon: Icon(_obscureTextConfirmPassword
                  //       ? Icons.visibility
                  //       : Icons.visibility_off),
                  // ),
                  ),
              onChanged: (value) => tenant = value,
              validator: (val) {
                if (val.isEmpty) {
                  return S.of(context).Thisfieldisempty;
                  "This field is Empty";
                }
                return null;
              },
            ),
            flex: 4,
          ),
        ],
      ),
    );
  }

  forgetPasswordButton() {
    return FlatButton(
      onPressed: () {
        showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 300,
              child: Stack(
                overflow: Overflow.visible,
                alignment: Alignment.topCenter,
                fit: StackFit.loose,
                children: <Widget>[
                  Transform.translate(
                    offset: Offset(0, -50),
                    child: ClipOval(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: FittedBox(
                          alignment: Alignment.center,
                          child: Image.asset("assets/images/logo.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, 60),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            S.of(context).Entertheemailtoresetpassword,
                            textAlign: TextAlign.center,
                            //"Enter the email to reset password",
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return S.of(context).Thisfieldisempty;
                                "This field is empty";
                              }
                              return value.contains('@') && value.contains('.')
                                  ? null
                                  : S.of(context).InvalidEmailId;
                              //"Invalid Email Id.";
                            },
                            onChanged: (value) => resetMail = value,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Theme.of(context).primaryColor,
                            textInputAction: TextInputAction.done,
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
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: S.of(context).Enteremail,
                                //"Enter email",
                                labelText: S.of(context).email,
                                labelStyle: TextStyle(
                                    color: Theme.of(context).accentColor)
                                //"email"
                                ),
                          ),
                        ),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          elevation: 5,
                          onPressed: () {
                            Navigator.of(context).pop();
                            resetPassword();
                          },
                          child: Text(
                            S.of(context).ResetPassword,
                            //"Reset Password"
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      textColor: Theme.of(context).accentColor,
      child: Text(
        S.of(context).ForgetPassword,
        // "Forget Password"
      ),
    );
  }

  loginButton() {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      elevation: 8,
      onPressed: button is Text
          ? () {
              if (_formKey.currentState.validate()) {
                setState(() {
                  button = CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  );
                });
                loginUser();
              }
            }
          : null,
      textColor: Colors.white,
      padding: const EdgeInsets.all(0.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: button,
      ),
    );
  }
}
