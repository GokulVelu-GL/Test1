import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

import 'package:rooster/ui/payment_wallet/plan/planhome.dart';
import 'package:rooster/ui/payment_wallet/recharge_wallet.dart';

class SlidingCardsView extends StatefulWidget {
  @override
  _SlidingCardsViewState createState() => _SlidingCardsViewState();
}

class _SlidingCardsViewState extends State<SlidingCardsView> {
  PageController pageController;
  double pageOffset = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.8);
    pageController.addListener(() {
      setState(() => pageOffset = pageController.page);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: PageView(
        controller: pageController,
        children: <Widget>[
          SlidingCard(
            name: 'FREE TRIAL',
            date: '0 USD / 7 DAYS FREE TRIAL',
            description: 'Payment in trial mode are sample payments, no real money is involved in these payment',
            assetName: 'https://i.pinimg.com/originals/46/01/f7/4601f773e41c094849e10288a7aec5e8.png',
            offset: pageOffset,
          ),
          SlidingCard(
            name: 'SILVER',
            date: '20 USD / PER MONTH',
            description: 'Start making real transaction, Payment in silver mode are real payments',
            assetName: 'https://thumbs.dreamstime.com/b/user-group-icon-metal-silver-round-button-metallic-design-circle-isolated-white-background-black-white-concept-illustration-167075197.jpg',
            offset: pageOffset - 1,
          ),
          SlidingCard(
            name: 'GOLD',
            date: '25 USD / PER MONTH',
            description: 'Start making real transaction, Payment in gold mode are real payments',
            assetName: 'https://st2.depositphotos.com/3554337/11700/i/950/depositphotos_117005818-stock-photo-group-of-golden-people.jpg',
            offset: pageOffset - 1,
          ),

        ],
      ),
    );
  }
}

class SlidingCard extends StatelessWidget {
  final String name;
  final String date;
  final String description;
  final String assetName;
  final double offset;

  const SlidingCard({
    Key key,
    @required this.name,
    @required this.date,
    @required this.description,
    @required this.assetName,
    @required this.offset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));
    return Transform.translate(
      offset: Offset(-32 * gauss * offset.sign, 0),
      child: Card(
        margin: EdgeInsets.only(left: 8, right: 8, bottom: 24),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).accentColor,
                Colors.orange[700],
              ],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CustomPaint(
              painter: CardCustomPainter(),
              child: Stack(
                children: [
                  // Positioned(
                  //   bottom: 10,
                  //   left: 10,
                  //   child: Image.asset(
                  //     'assets/img.png',
                  //     color: Colors.purpleAccent.withOpacity(0.3),
                  //   ),
                  // ),
                  // Positioned(
                  //   bottom: 30,
                  //   left: 20,
                  //   child: Image.asset(
                  //     'assets/2.png',
                  //     color: Colors.white70,
                  //   ),
                  // ),
                  Container(
                    child: Column(
                      children: [
                        Center(
                          child: Image.asset(
                          "assets/plan/plan.gif",
                            //"https://cdn.dribbble.com/users/767646/screenshots/1943995/team.gif",
                            // "https://cliply.co/wp-content/uploads/2019/06/371906130_GEM_STONE_400px.gif",
                            //'https://cdn-icons-gif.flaticon.com/6172/6172524.gif',
                            // color: Theme.of(context).accentColor,
                            width: 300 * 0.4,
                          ),
                        ),

                        Transform.translate(
                          offset: Offset(3 * offset, 0),
                          child: Text(name, style: TextStyle(fontSize: 20)),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                       Text(date,

                       ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(description,
                          textAlign: TextAlign.center,
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            primary: Theme.of(context).backgroundColor,
                              elevation: 2,
                              backgroundColor: Theme.of(context).accentColor),
                            onPressed: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          RechargeWallet()
                                    //PaymentHomePage()
                                  ));
                            }, child: Text("RECHARGE"))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        // child: Column(
        //   children: <Widget>[
        //     ClipRRect(
        //       borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        //       child: Image.network(
        //         assetName,
        //         height: MediaQuery.of(context).size.height * 0.3,
        //         alignment: Alignment(-offset.abs(), 0),
        //         fit: BoxFit.cover,
        //       ),
        //     ),
        //     SizedBox(height: 8),
        //     Expanded(
        //       child: CardContent(
        //         name: name,
        //         date: date,
        //         offset: gauss,
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final String name;
  final String date;
  final double offset;

  const CardContent(
      {Key key,
        @required this.name,
        @required this.date,
        @required this.offset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Transform.translate(
            offset: Offset(8 * offset, 0),
            child: Text(name, style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 8),
          Transform.translate(
            offset: Offset(32 * offset, 0),
            child: Text(
              date,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Spacer(),
          Row(
            children: <Widget>[
              Transform.translate(
                offset: Offset(48 * offset, 0),
                child: TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor)),
                  child: Transform.translate(
                    offset: Offset(24 * offset, 0),
                    child: Text('RECHARGE'),
                  ),
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(32),
                  // ),
                  onPressed: () {},
                ),
              ),
              Spacer(),
              Transform.translate(
                offset: Offset(32 * offset, 0),
                child: Text(
                  'INR',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(width: 16),
            ],
          )
        ],
      ),
    );
  }
}