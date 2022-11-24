import 'dart:math';
import 'dart:io' show Platform;

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/screenroute.dart';
import 'package:rooster/ui/homescreen/configuration.dart';
import 'package:rooster/ui/homescreen/dashboard.dart';
import 'package:rooster/ui/homescreen/eawb.dart';
import 'package:rooster/ui/homescreen/ehouse.dart';
import 'package:rooster/ui/homescreen/emanifest.dart';
import 'package:rooster/ui/homescreen/iata_cargo_xml.dart';
import 'package:rooster/ui/homescreen/iata_one_record.dart';
import 'package:rooster/ui/homescreen/iataedi.dart';
import 'package:rooster/ui/homescreen/my_hawb.dart';
import 'package:rooster/ui/homescreen/policies.dart';
import 'package:rooster/ui/homescreen/social_media.dart';
import 'package:rooster/ui/homescreen/telex.dart';
import 'package:rooster/ui/homescreen/user_management.dart';
import 'package:rooster/ui/loginscreen/main_logincardscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../color_picker.dart';
import '../../theme_changer.dart';
import 'dashbord/menu_dashbord.dart';
import 'new_dashbord.dart';
import 'new_home.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _currentIndex = 0;
  PageController _pageController;
  final _pageOptions = [NewHomeScreen(), HomeDashboard(), Profile()];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // return Scaffold(
    //   backgroundColor: Colors.grey[100],
    //   bottomNavigationBar: SalomonBottomBar(
    //     currentIndex: _currentIndex,
    //     onTap: (i) => setState(() => _currentIndex = i),
    //     items: [
    //       /// Home
    //       SalomonBottomBarItem(
    //         icon: Icon(Icons.home),
    //         title: Text(
    //           S.of(context).Home
    //           //"Home"
    //         ),
    //         selectedColor: Colors.purple,
    //       ),
    //
    //       /// Likes
    //       SalomonBottomBarItem(
    //         icon: Icon(Icons.dashboard),
    //         title: Text(
    //             S.of(context).Dashboard
    //           // "Dashbord"
    //         ),
    //         selectedColor: Colors.pink,
    //       ),
    //
    //       /// Profile
    //       SalomonBottomBarItem(
    //         icon: Icon(Icons.person),
    //         title: Text(
    //             S.of(context).Profile
    //           // "Profile"
    //         ),
    //         selectedColor: Colors.teal,
    //       ),
    //     ],
    //   ),
    //   body: SafeArea(child: _pageOptions[_currentIndex]),
    // );
    return Scaffold(
      // backgroundColor: Theme.of(context).accentColor,
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          _currentIndex = index;
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text(
              S.of(context).Home
              //'Home'
            ),
            activeColor: Theme.of(context).accentColor,
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.dashboard),
              title: Text(
                S.of(context).Dashboard
                // 'Dashbord'
              ),
              activeColor: Theme.of(context).accentColor),
          BottomNavyBarItem(
              icon: Icon(Icons.person),
              title: Text(
                  S.of(context).Profile
                  //'Profile'
              ),
              activeColor: Theme.of(context).accentColor),
        ],
      ),
      // bottomNavigationBar: ConvexAppBar(
      //   backgroundColor: Theme.of(context).accentColor,
      //   initialActiveIndex: _currentIndex,
      //   onTap: (i) => setState(() => _currentIndex = i),
      //   style: TabStyle.textIn,
      //   activeColor: Theme.of(context).backgroundColor,
      //   items: [
      //     TabItem(
      //       icon: Icons.home,
      //       title: S.of(context).Home,
      //       // title: Text(
      //       //     S.of(context).Home
      //       //     //"Home"
      //       //   ),
      //     ),
      //     TabItem(
      //       icon: Icons.dashboard,
      //       title: S.of(context).Dashboard,
      //     ),
      //     TabItem(
      //       icon: Icons.person,
      //       title: S.of(context).Profile,
      //     ),
      //   ],
      // ),
      //body: SafeArea(child: _pageOptions[_currentIndex]),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[NewHomeScreen(),
            HomeDashboard()
            , UserProfile()],
        ),
      ),
    );
  }
}
