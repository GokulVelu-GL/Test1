
import 'package:flutter/material.dart';
import 'package:rooster/ui/payment_wallet/plan/sliding.dart';

import '../../homescreen/main_homescreen.dart';
import 'bottom_sheet.dart';
import 'dart:ui';


class PlanPage extends StatefulWidget {
  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Container(
        decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: NetworkImage("https://img1.picmix.com/output/stamp/normal/1/0/7/9/1289701_e1c8c.gif"),
          fit: BoxFit.cover,
        ),
      ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 8),
                  Header(),
                  SizedBox(height: 40),
                  SizedBox(height: 8),
                   SlidingCardsView(),

                ],
              ),
            ),
          ),
          ExhibitionBottomSheet(), //use this or ScrollableExhibitionSheet
        ],
      ),
    );
  }
}


class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          child: Text(
            'Pricing Plans That Fit Your Business',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
            style: TextButton.styleFrom( //<-- SEE HERE
              side: BorderSide(width: 1.0),
              elevation: 5,
        shape:
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
            ),
              primary: Theme.of(context).backgroundColor,
              backgroundColor: Theme.of(context).accentColor
            ),
            onPressed: (){
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      HomeScreen()));
              }, child: Text("Skip",
        ))
      ],
    );
  }
}

class CardCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.32);
    path.quadraticBezierTo(size.width * 0.20, size.height * 0.45,
        size.width * 0.49, size.height * 0.45);
    path.quadraticBezierTo(
        size.width * 0.73, size.height * 0.45, size.width, size.height * 0.32);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

