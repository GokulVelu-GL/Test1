import 'dart:math';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rooster/generated/l10n.dart';

import 'loginscreen.dart';
import 'registerscreen.dart';

class LoginCardScreen extends StatefulWidget {
  @override
  _LoginCardScreenState createState() => _LoginCardScreenState();
}

class _LoginCardScreenState extends State<LoginCardScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _cardController;
  Animation _cardAnimation;

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _cardAnimation = Tween(begin: 0.0, end: pi).animate(_cardController);
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _cardController,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                // Container(
                //   decoration: BoxDecoration(
                //     image: DecorationImage(
                //       image: NetworkImage(
                //           ""
                //       ),
                //       fit: BoxFit.fill,
                //     ),
                //   ),
                // ),
                FlareActor(
                  "assets/anim/rooster.flr",
                  artboard: "LoginBackground",
                  animation: "city-cloud",
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Transform(
                            origin:
                                Offset((width * 0.92) / 2, (height * 0.60) / 2),
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(_cardAnimation.value),
                            child: Opacity(
                              opacity: 0.9,
                              child: Card(
                                elevation: 5,
                                child: _cardAnimation.value < pi / 2
                                    ? LoginScreen()
                                    : RegisterScreen(
                                        cardController: _cardController,
                                      ),
                              ),
                            )),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 8.0),
                          child: RichText(
                              text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: _cardAnimation.value < pi / 2
                                      ? S.of(context).Donthaveanaccount
                                      // ? "Don't have an account ? "
                                      : S.of(context).Alreadyhaveanaccount
                                  // "Already have an account ? "
                                  ,
                                  style: TextStyle(
                                 //   color: Colors.grey[200],
                                  )),
                              TextSpan(
                                  text: _cardAnimation.value < pi / 2
                                      ? S.of(context).CreateAccount
                                      // ? "Create Account "
                                      : S.of(context).Login,
                                  //"Log In ",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      _cardController.isDismissed
                                          ? _cardController.forward()
                                          : _cardController.reverse();
                                    },
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    // color: Colors.white,
                                  ))
                            ],
                          )),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
