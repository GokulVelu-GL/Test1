import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rooster/formatter.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/string.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key, this.cardController}) : super(key: key);
  final AnimationController cardController;
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String userName;
  String mailId;
  String _newPassword, _confirmPassword;
  String uid;
  String tenant;

  Widget button = Text('Create Account', style: TextStyle(fontSize: 20));

  bool _obscureTextNewPassword = true;
  final _formKey = GlobalKey<FormState>();
  static final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');

  void _toggleNewPassword() {
    setState(() {
      _obscureTextNewPassword = !_obscureTextNewPassword;
    });
  }

  bool _obscureTextConfirmPassword = true;
  void _toggleConfirmPassword() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
  }

  registerUser() async {
    var response = await http.post(StringData.registerAPI, body: {
      'email': mailId,
      'password': _newPassword,
      'retype_password': _confirmPassword,
      'TenantName': tenant
    });
    print(response.body);
    var result = json.decode(response.body);
    print(result);
    if (result["result"] == "registered successfully") {
      setState(() {
        button = Text('Create Account', style: TextStyle(fontSize: 20));
      });
      Scaffold.of(context)
          // ignore: deprecated_member_use
          .showSnackBar(SnackBar(content: Text(result["message"])));
      widget.cardController.reverse();
    } else {
      setState(() {
        button = Text('Create Account', style: TextStyle(fontSize: 20));
      });
      Scaffold.of(context)
          // ignore: deprecated_member_use
          .showSnackBar(SnackBar(content: Text(result["error"])));
    }
  }

  FocusNode emailidFocusNode = FocusNode();
  FocusNode newPasswordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  FocusNode tenantFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Transform(
      origin: Offset((width * 0.90) / 2, (height * 0.60) / 2),
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(pi),
      child: Container(
        width: width * 0.9,
        height: height * 0.6,
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  titleText(),
                  emailTextField(),
                  newPasswordTextField(),
                  confirmPasswordTextField(),
                  tenantTextField(),
                  createAccountButton(),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  titleText() {
    return Text(
      S.of(context).Register,
      //"Register",
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  emailTextField() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: TextFormField(
        focusNode: emailidFocusNode,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, emailidFocusNode, newPasswordFocusNode);
        },
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).accentColor,
              ),
            ),
            icon: Icon(
              Icons.email,
              color: Theme.of(context).accentColor,
            ),
            labelText: S.of(context).EmailId,
            labelStyle: TextStyle(color: Theme.of(context).accentColor)
            //  "Email Id",
            ),
        onChanged: (value) => mailId = value,
        validator: (value) {
          if (value.isEmpty) {
            return S.of(context).Thisfieldisempty;
            //"This field is Empty";
          }
          return value.contains('@') && value.contains('.')
              ? null
              : S.of(context).InvalidEmailId;
          //"Invalid Email Id.";
        },
      ),
    );
  }

  newPasswordTextField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              focusNode: newPasswordFocusNode,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                _fieldFocusChange(
                    context, newPasswordFocusNode, confirmPasswordFocusNode);
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
                labelText: S.of(context).NewPassword,
                labelStyle: TextStyle(color: Theme.of(context).accentColor),
                //"New Password",
                suffixIcon: IconButton(
                  color: Theme.of(context).accentColor,
                  onPressed: _toggleNewPassword,
                  icon: Icon(_obscureTextNewPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
              ),
              onChanged: (value) => _newPassword = value,
              obscureText: _obscureTextNewPassword,
              validator: (val) {
                if (val.isEmpty) return S.of(context).Thisfieldisempty;

                //"This field is Empty";
                if (val.length < 5) return S.of(context).Passwordistooshort;
                //"Password is too short";
                if (!val.contains(new RegExp(r'[0-9]')))
                  return S.of(context).Passwordmusthaveatleasnonenumber;
                //"Password must have atleast \none number";
                if (!val.contains(new RegExp(r'[A-Z]')))
                  return S
                      .of(context)
                      .Passwordmustcontainatleastonespecialcharacter;
                //"Password must have atleast \none capital letter";
                if (!val.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]')))
                  return S
                      .of(context)
                      .Passwordmustcontainatleastonespecialcharacter;
                //"Password must contain atleast \none special character";
                return null;
              },
            ),
            flex: 4,
          ),
        ],
      ),
    );
  }

  confirmPasswordTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              focusNode: confirmPasswordFocusNode,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) {
                confirmPasswordFocusNode.unfocus();
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
                labelText: S.of(context).ConfirmPassword,
                labelStyle: TextStyle(color: Theme.of(context).accentColor),
                //"Confirm Password",
                suffixIcon: IconButton(
                  color: Theme.of(context).accentColor,
                  onPressed: _toggleConfirmPassword,
                  icon: Icon(_obscureTextConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
              ),
              onChanged: (value) => _confirmPassword = value,
              obscureText: _obscureTextConfirmPassword,
              validator: (val) {
                if (val.isEmpty) {
                  return S.of(context).Thisfieldisempty;
                  //"This field is Empty";
                }
                if (_newPassword != _confirmPassword) {
                  return S.of(context).Passworddoesnotmatch;
                  // "Password does not match";
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
              focusNode: tenantFocusNode,
              inputFormatters: [AllCapitalCase()],
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) {
                tenantFocusNode.unfocus();
              },
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  icon: Icon(
                    Icons.vpn_lock_sharp,
                    color: Theme.of(context).accentColor,
                  ),
                  labelText: S.of(context).CustomerCode,
                  labelStyle: TextStyle(color: Theme.of(context).accentColor)
                  //"Customer Code",
                  //labelText: S.of(context).tenant,
                  //"Tenant",
                  // suffixIcon: IconButton(
                  //   onPressed: _toggleConfirmPassword,
                  //   icon: Icon(_obscureTextConfirmPassword
                  //       ? Icons.visibility
                  //       : Icons.visibility_off),
                  // ),
                  ),
              onChanged: (value) {
                tenant = value;
              },
              validator: (val) {
                if (!validCharacters.hasMatch(val)) {
                  return "Only alphanumeric are allowed";
                }
                if (val.isEmpty) {
                  return S.of(context).Thisfieldisempty;
                  //"This field is Empty";
                }
                return null;
              },
            ),
            flex: 4,
          ),
          IconButton(
              onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text(
                        S.of(context).CustomerCode,
                        // 'Customer Code',
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                        S
                                .of(context)
                                .IfyouareregisteringasasolouserpleasechooseyourownCUSTOMERCODEexampleABC123 +
                            S
                                .of(context)
                                .OtherwiseifyouarepartofanorganizationpleaseinputyourorganizationCUSTOMERCODEexampleROOSTER123,
                        // "If you are registering as a solo user, please choose your own CUSTOMER CODE (example: ABC123)." +
                        //     " Otherwise if you are part of an organization, please input your organization's CUSTOMER CODE (example: ROOSTER123)",
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: Text(
                            S.of(context).Cancel,
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                            //'Cancel'
                          ),
                        ),
                      ],
                    ),
                  ),
              icon: Icon(
                Icons.info,
                color: Theme.of(context).accentColor,
              ))
        ],
      ),
    );
  }

  createAccountButton() {
    // ignore: deprecated_member_use
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
                registerUser();
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
