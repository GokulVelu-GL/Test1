import 'package:flutter/cupertino.dart';

class HomeScreenRoute extends PageRouteBuilder {
  final Widget nextScreen;

  HomeScreenRoute(this.nextScreen)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                  child: child,
                  position: Tween(begin: Offset(0, 1), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: animation, curve: Curves.easeInOut))),
        );
}

class RightScreenRoute extends PageRouteBuilder {
  final Widget nextScreen;

  RightScreenRoute(this.nextScreen)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                  child: child,
                  position: Tween(begin: Offset(1, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: animation, curve: Curves.easeInOut))),
        );
}

class LeftScreenRoute extends PageRouteBuilder {
  final Widget nextScreen;

  LeftScreenRoute(this.nextScreen)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                  child: child,
                  position: Tween(begin: Offset(-1, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: animation, curve: Curves.easeInOut))),
        );
}
