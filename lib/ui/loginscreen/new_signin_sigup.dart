import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../formatter.dart';
import '../../generated/l10n.dart';
import '../../model/user_model.dart';
import '../../string.dart';
import '../homescreen/main_homescreen.dart';
import 'bubble_indicator.dart';
import 'package:http/http.dart' as http;
class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration:  BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[
                      Theme.of(context).backgroundColor,
                      Theme.of(context).accentColor
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 1.0),
                    stops: <double>[0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 75.0),
                    child: Image(
                        height:
                        MediaQuery.of(context).size.height > 800 ? 191.0 : 150,
                        fit: BoxFit.fill,
                        color: Theme.of(context).accentColor,
                        image:  NetworkImage(
                       //  "https://img.lovepik.com/background/20211022/large/lovepik-aeronautical-background-of-science-and-technology-image_500847580.jpg"
                          // "https://img.freepik.com/free-vector/airplane-sky_1308-31202.jpg?w=2000"
                           'https://cdn-icons-png.flaticon.com/128/1350/1350120.png'
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: _buildMenuBar(context),
                  ),
                  Expanded(
                    flex: 2,
                    child: PageView(
                      controller: _pageController,
                      physics: const ClampingScrollPhysics(),
                      onPageChanged: (int i) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (i == 0) {
                          setState(() {
                            right = Colors.white;
                            left = Colors.black;
                          });
                        } else if (i == 1) {
                          setState(() {
                            right = Colors.black;
                            left = Colors.white;
                          });
                        }
                      },
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: const SignIn(),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: const SignUp(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: const BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: BubbleIndicatorPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onSignInButtonPress,
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: left,
                      fontSize: 16.0,
                      fontFamily: 'WorkSansSemiBold'),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onSignUpButtonPress,
                child: Text(
                  'Register',
                  style: TextStyle(
                      color: right,
                      fontSize: 16.0,
                      fontFamily: 'WorkSansSemiBold'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }
}


class SignIn extends StatefulWidget {
  const SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String mailId;
  String _password;
  String tenant;
  bool _obscureText = true;
  String resetMail;
  // TextEditingController loginEmailController = TextEditingController();
  // TextEditingController loginPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();

  bool _obscureTextPassword = true;


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


  Widget button = Text(
    //S.of(context).Login
      'Login',
      style: TextStyle(fontSize: 20));


  @override
  void dispose() {
    focusNodeEmail.dispose();
    focusNodePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 200.0,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding:  EdgeInsets.only(
                              top: 30.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: focusNodeEmail,
                            // controller: loginEmailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            // style:  TextStyle(
                            //     fontSize: 16.0,
                            //   color:Theme.of(context).accentColor,
                            //     // color: Colors.black
                            // ),
                            decoration:  InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.email,
                                color: Theme.of(context).accentColor,
                                size: 22.0,
                              ),
                              hintText: S.of(context).EmailId,
                              hintStyle: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  // color: Theme.of(context).accentColor,
                                  fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
                            ),
                            // onSubmitted: (_) {
                            //   focusNodePassword.requestFocus();
                            // },
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
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: focusNodePassword,
                            // controller: loginPasswordController,
                            obscureText: _obscureTextPassword,
                            style: const TextStyle(
                                fontFamily: 'WorkSansSemiBold',
                                fontSize: 16.0,
                                color: Colors.black
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon:  Icon(
                                Icons.password,
                                size: 22.0,
                                color: Theme.of(context).accentColor,
                              ),
                              hintText: 'Password',
                              hintStyle:  TextStyle(
                                  color: Theme.of(context).accentColor,
                                 fontSize: 17.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleLogin,
                                child: Icon(
                                  _obscureText ? Icons.visibility : Icons.visibility_off,
                                  size: 18.0,
                                  color: Theme.of(context).accentColor
                                ),
                              ),
                            ),
                            // onSubmitted: (_) {
                            //   _toggleSignInButton();
                            // },
                            onChanged: (value) => _password = value,
                            validator: (value) {
                              if (value.isEmpty) {
                                return S.of(context).Thisfieldisempty;
                                //"This field is empty";
                              }
                              return null;
                            },
                          ),
                          ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin:  EdgeInsets.only(top:190.0),
                decoration:  BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  // boxShadow: <BoxShadow>[
                  //   BoxShadow(
                  //     color: Theme.of(context).accentColor,
                  //     offset: Offset(1.0, 6.0),
                  //     blurRadius: 20.0,
                  //   ),
                  //   BoxShadow(
                  //     color: Theme.of(context).accentColor,
                  //     offset: Offset(1.0, 6.0),
                  //     blurRadius: 20.0,
                  //   ),
                  // ],
                  gradient: LinearGradient(
                      colors: <Color>[
                        Theme.of(context).accentColor,
                        Theme.of(context).accentColor
                      ],
                      begin: FractionalOffset(0.2, 0.2),
                      end: FractionalOffset(1.0, 1.0),
                      stops: <double>[0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: RaisedButton(
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
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(top: 170.0),
              //   decoration: const BoxDecoration(
              //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
              //     boxShadow: <BoxShadow>[
              //       BoxShadow(
              //         color: CustomTheme.loginGradientStart,
              //         offset: Offset(1.0, 6.0),
              //         blurRadius: 20.0,
              //       ),
              //       BoxShadow(
              //         color: CustomTheme.loginGradientEnd,
              //         offset: Offset(1.0, 6.0),
              //         blurRadius: 20.0,
              //       ),
              //     ],
              //     gradient: LinearGradient(
              //         colors: <Color>[
              //           CustomTheme.loginGradientEnd,
              //           CustomTheme.loginGradientStart
              //         ],
              //         begin: FractionalOffset(0.2, 0.2),
              //         end: FractionalOffset(1.0, 1.0),
              //         stops: <double>[0.0, 1.0],
              //         tileMode: TileMode.clamp),
              //   ),
              //   child: MaterialButton(
              //     highlightColor: Colors.transparent,
              //     splashColor: CustomTheme.loginGradientEnd,
              //     child: const Padding(
              //       padding:
              //       EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
              //       child: Text(
              //         'LOGIN',
              //         style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 25.0,
              //             fontFamily: 'WorkSansBold'),
              //       ),
              //     ),
              //     onPressed: ()
              //       {
              //          button is Text
              //             ? () {
              //           if (_formKey.currentState.validate()) {
              //             setState(() {
              //               button = CircularProgressIndicator(
              //                 backgroundColor: Colors.white,
              //               );
              //             });
              //             loginUser();
              //           }
              //         }
              //             : null;
              //       }
              //   ),
              // )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextButton(
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
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: 'WorkSansMedium'),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: <Color>[
                          Colors.white10,
                          Colors.white,
                        ],
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(1.0, 1.0),
                        stops: <double>[0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
                 Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Icon(Icons.flight,
                  color: Theme.of(context).backgroundColor,
                  )
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: <Color>[
                          Colors.white,
                          Colors.white10,
                        ],
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(1.0, 1.0),
                        stops: <double>[0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleSignInButton() {
    CustomSnackBar(context, const Text('Login button pressed'));
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
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
          StringData.loadAirlineCode();
          StringData.loadtContactType();
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
}



class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
   AnimationController cardController;
  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodeConfirmPassword = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodeName = FocusNode();

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
      // widget.cardController.reverse();
    } else {
      setState(() {
        button = Text('Create Account', style: TextStyle(fontSize: 20));
      });
      Scaffold.of(context)
      // ignore: deprecated_member_use
          .showSnackBar(SnackBar(content: Text(result["error"])));
    }
  }

  bool _obscureTextPassword = true;

  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfirmPasswordController =
  TextEditingController();

  @override
  void dispose() {
    focusNodePassword.dispose();
    focusNodeConfirmPassword.dispose();
    focusNodeEmail.dispose();
    focusNodeName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 360.0,
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //       top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          //   child: TextField(
                          //     focusNode: focusNodeName,
                          //     controller: signupNameController,
                          //     keyboardType: TextInputType.text,
                          //     textCapitalization: TextCapitalization.words,
                          //     autocorrect: false,
                          //     style: const TextStyle(
                          //         fontFamily: 'WorkSansSemiBold',
                          //         fontSize: 16.0,
                          //         color: Colors.black),
                          //     decoration: const InputDecoration(
                          //       border: InputBorder.none,
                          //       icon: Icon(
                          //      Icons.account_balance,
                          //         color: Colors.black,
                          //       ),
                          //       hintText: 'Name',
                          //       hintStyle: TextStyle(
                          //           fontFamily: 'WorkSansSemiBold', fontSize: 16.0),
                          //     ),
                          //     onSubmitted: (_) {
                          //       focusNodeEmail.requestFocus();
                          //     },
                          //   ),
                          // ),
                          Container(
                            width: 250.0,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 25.0, right: 25.0),
                            child: TextFormField(
                              focusNode: focusNodeEmail,
                              //controller: signupEmailController,
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              style: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Colors.black),
                              decoration:  InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(
                                  Icons.email,
                                    color: Theme.of(context).accentColor
                                ),
                                hintText: 'Email Id',
                                hintStyle: TextStyle(
                                    fontFamily: 'WorkSansSemiBold',
                                    color: Theme.of(context).accentColor,
                                    fontSize: 16.0),
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
                              // onSubmitted: (_) {
                              //   focusNodePassword.requestFocus();
                              // },
                            ),
                          ),
                          Container(
                            width: 250.0,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 25.0, right: 25.0),
                            child: TextFormField(
                              focusNode: focusNodePassword,
                              // controller: signupPasswordController,
                              // obscureText: _obscureTextPassword,
                              autocorrect: false,
                              style:  TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Theme.of(context).accentColor
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon:  Icon(
                                  Icons.lock,
                                    color: Theme.of(context).accentColor
                                ),
                                hintText: 'Password',
                                hintStyle:  TextStyle(
                                    fontFamily: 'WorkSansSemiBold',
                                    color: Theme.of(context).accentColor,
                                    fontSize: 16.0),
                                suffixIcon: GestureDetector(
                                  onTap: _toggleSignup,
                                  child: Icon(
                                    _obscureTextPassword
                                        ? Icons.remove_red_eye
                                        :  Icons.remove_red_eye,
                                    size: 15.0,
                                 color: Theme.of(context).accentColor,
                                  ),
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
                              // onSubmitted: (_) {
                              //   focusNodeConfirmPassword.requestFocus();
                              // },
                            ),
                          ),
                          Container(
                            width: 250.0,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 25.0, right: 25.0),
                            child: TextFormField(
                              focusNode: focusNodeConfirmPassword,
                              // controller: signupConfirmPasswordController,
                              // obscureText: _obscureTextConfirmPassword,
                              autocorrect: false,
                              style: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon:  Icon(
                                  Icons.lock,
                               color: Theme.of(context).accentColor,
                                ),
                                hintText: 'Confirmation',
                                hintStyle:  TextStyle(
                                    fontFamily: 'WorkSansSemiBold',
                                    color: Theme.of(context).accentColor,
                                    fontSize: 16.0),
                                suffixIcon: GestureDetector(
                                  onTap: _toggleSignupConfirm,
                                  child: Icon(
                                    _obscureTextConfirmPassword
                                        ? Icons.remove_red_eye
                                        :  Icons.remove_red_eye,
                                    size: 15.0,
                                      color: Theme.of(context).accentColor
                                  ),
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
                              // onSubmitted: (_) {
                              //   _toggleSignUpButton();
                              // },
                              textInputAction: TextInputAction.go,
                            ),
                          ),
                          Container(
                            width: 250.0,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),

                    Padding(
                      padding: const EdgeInsets.only(   top: 20.0, left: 25.0, right: 25.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              // focusNode: tenantFocusNode,
                              inputFormatters: [AllCapitalCase()],
                              textInputAction: TextInputAction.done,
                              // onFieldSubmitted: (value) {
                              //   tenantFocusNode.unfocus();
                              // },
                              decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.vpn_lock_sharp,
                                    color: Theme.of(context).accentColor,
                                  ),
                                border: InputBorder.none,
                                  hintText: S.of(context).CustomerCode,
                                  hintStyle:TextStyle(color: Theme.of(context).accentColor),
                                  //labelText: S.of(context).CustomerCode,
                                //  labelStyle: TextStyle(color: Theme.of(context).accentColor)
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
                    ),
                          Container(
                            width: 250.0,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 340.0),
                decoration:  BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  // boxShadow: <BoxShadow>[
                  //   BoxShadow(
                  //     color: CustomTheme.loginGradientStart,
                  //     offset: Offset(1.0, 6.0),
                  //     blurRadius: 20.0,
                  //   ),
                  //   BoxShadow(
                  //     color: CustomTheme.loginGradientEnd,
                  //     offset: Offset(1.0, 6.0),
                  //     blurRadius: 20.0,
                  //   ),
                  // ],
                  gradient: LinearGradient(
                      colors: <Color>[
                        Theme.of(context).accentColor,
                        Theme.of(context).accentColor
                      ],
                      begin: FractionalOffset(0.2, 0.2),
                      end: FractionalOffset(1.0, 1.0),
                      stops: <double>[0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: RaisedButton(
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
                )
              )
            ],
          ),
        ],
      ),
    );
  }

  void _toggleSignUpButton() {
    CustomSnackBar(context, const Text('SignUp button pressed'));
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
  }
}

class CustomSnackBar {
  CustomSnackBar(BuildContext context, Widget content,
      {SnackBarAction snackBarAction, Color backgroundColor = Colors.green}) {
    final SnackBar snackBar = SnackBar(
        action: snackBarAction,
        backgroundColor: backgroundColor,
        content: content,
        behavior: SnackBarBehavior.floating);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

