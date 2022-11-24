import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/ui/loginscreen/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../languagechangeprovider.dart';
import '../../model/user_model.dart';
import '../../string.dart';
import '../homescreen/main_homescreen.dart';


class ContentCard extends StatefulWidget {
  @override
  _ContentCardState createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  bool showInput = true;
  bool showInputTabOptions = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (!showInput) {
          setState(() {
            showInput = true;
            showInputTabOptions = true;
          });
          return Future(() => false);
        } else {
          return Future(() => true);
        }
      },
      child: SafeArea(
        child: Scaffold(
          body:  Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "https://images.pexels.com/photos/1110670/pexels-photo-1110670.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
                  //  "https://images.pexels.com/photos/333525/pexels-photo-333525.jpeg?auto=compress&cs=tinysrgb&w=600"
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: DefaultTabController(
              child: new LayoutBuilder(
                builder:
                    (BuildContext context, BoxConstraints viewportConstraints) {
                  return Column(
                    children: <Widget>[
                      _buildContentContainer(viewportConstraints),
                    ],
                  );
                },
              ),
              length: 3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentContainer(BoxConstraints viewportConstraints) {
    return Expanded(
      child: SingleChildScrollView(
        child: new ConstrainedBox(
          constraints: new BoxConstraints(
            minHeight: viewportConstraints.maxHeight - 48.0,
          ),
          child: new IntrinsicHeight(
            child: showInput
                ? _buildMulticityTab()
                : PriceTab(
              height: viewportConstraints.maxHeight - 48.0,
              onPlaneFlightStart: () =>
                  setState(() => showInputTabOptions = false),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMulticityTab() {
    return Column(
      children: <Widget>[
        MulticityInput(),
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
          child: FloatingActionButton(
            onPressed: () => setState(() {
              showInput = false;
            } ),
            child: Icon(Icons.flight, size: 36.0),
          ),
        ),
      ],
    );
  }
}

class AnimatedDot extends AnimatedWidget {
final Color color;
static final double size = 24.0;

AnimatedDot({
Key key,
Animation<double> animation,
@required this.color,
}) : super(key: key, listenable: animation);

@override
Widget build(BuildContext context) {
  Animation<double> animation = super.listenable;
  return Positioned(
    top: animation.value,
    child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Color(0xFFDDDDDD), width: 1.0)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: DecoratedBox(
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        )),
  );
}
}



class PriceTab extends StatefulWidget {
  final double height;
  final VoidCallback onPlaneFlightStart;

  const PriceTab({Key key, this.height, this.onPlaneFlightStart})
      : super(key: key);

  @override
  _PriceTabState createState() => _PriceTabState();
}

class _PriceTabState extends State<PriceTab> with TickerProviderStateMixin {
  final double _initialPlanePaddingBottom = 16.0;
  final double _minPlanePaddingTop = 16.0;
  final List<FlightStop> _flightStops = [
    FlightStop("JFK", "ORY", "JUN 05", "6h 25m", "\$851", "9:26 am - 3:43 pm"),
    FlightStop("MRG", "FTB", "JUN 20", "6h 25m", "\$532", "9:26 am - 3:43 pm"),
    FlightStop("ERT", "TVS", "JUN 20", "6h 25m", "\$718", "9:26 am - 3:43 pm"),
    FlightStop("KKR", "RTY", "JUN 20", "6h 25m", "\$663", "9:26 am - 3:43 pm"),
  ];
  final List<GlobalKey<FlightStopCardState>> _stopKeys = [];

  AnimationController _planeSizeAnimationController;
  AnimationController _planeTravelController;
  AnimationController _dotsAnimationController;
  AnimationController _fabAnimationController;
  Animation _planeSizeAnimation;
  Animation _planeTravelAnimation;
  Animation _fabAnimation;

  List<Animation<double>> _dotPositions = [];

  double get _planeTopPadding =>
      _minPlanePaddingTop +
          (1 - _planeTravelAnimation.value) * _maxPlaneTopPadding;

  double get _maxPlaneTopPadding =>
      widget.height -
          _minPlanePaddingTop -
          _initialPlanePaddingBottom -
          _planeSize;

  double get _planeSize => _planeSizeAnimation.value;

  @override
  void initState() {
    super.initState();
    _initSizeAnimations();
    _initPlaneTravelAnimations();
    _initDotAnimationController();
    _initDotAnimations();
    _initFabAnimationController();
    _flightStops
        .forEach((stop) => _stopKeys.add(new GlobalKey<FlightStopCardState>()));
    _planeSizeAnimationController.forward();
  }

  @override
  void dispose() {
    _planeSizeAnimationController.dispose();
    _planeTravelController.dispose();
    _dotsAnimationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[_buildPlane()]
          ..addAll(_flightStops.map(_buildStopCard))
          ..addAll(_flightStops.map(_mapFlightStopToDot))
          ..add(_buildFab()),
      ),
    );
  }

  Widget _buildStopCard(FlightStop stop) {
    int index = _flightStops.indexOf(stop);
    double topMargin = _dotPositions[index].value -
        0.5 * (FlightStopCard.height - AnimatedDot.size);
    bool isLeft = index.isOdd;
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: topMargin),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isLeft ? Container() : Expanded(child: Container()),
            Expanded(
              child: FlightStopCard(
                key: _stopKeys[index],
                flightStop: stop,
                isLeft: isLeft,
              ),
            ),
            !isLeft ? Container() : Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  Widget _mapFlightStopToDot(stop) {
    int index = _flightStops.indexOf(stop);
    bool isStartOrEnd = index == 0 || index == _flightStops.length - 1;
    Color color = isStartOrEnd ? Colors.red : Colors.green;
    return AnimatedDot(
      animation: _dotPositions[index],
      color: color,
    );
  }

  Widget _buildPlane() {
    return AnimatedBuilder(
      animation: _planeTravelAnimation,
      child: Column(
        children: <Widget>[
          AnimatedPlaneIcon(animation: _planeSizeAnimation),
          Container(
            width: 2.0,
            height: _flightStops.length * FlightStopCard.height * 0.8,
            color: Color.fromARGB(255, 200, 200, 200),
          ),
        ],
      ),
      builder: (context, child) => Positioned(
        top: _planeTopPadding,
        child: child,
      ),
    );
  }

  Widget _buildFab() {
    return Positioned(
      bottom: 16.0,
      child: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: () => Navigator
              .of(context)
              .push(FadeRoute(builder: (context) => LoginScreen())),
          child: Icon(Icons.check, size: 36.0),
        ),
      ),
    );
  }

  _initSizeAnimations() {
    _planeSizeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 340),
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 500), () {
          widget?.onPlaneFlightStart();
          _planeTravelController.forward();
        });
        Future.delayed(Duration(milliseconds: 700), () {
          _dotsAnimationController.forward();
        });
      }
    });
    _planeSizeAnimation =
        Tween<double>(begin: 60.0, end: 36.0).animate(CurvedAnimation(
          parent: _planeSizeAnimationController,
          curve: Curves.easeOut,
        ));
  }

  _initPlaneTravelAnimations() {
    _planeTravelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _planeTravelAnimation = CurvedAnimation(
      parent: _planeTravelController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _initDotAnimations() {
    //what part of whole animation takes one dot travel
    final double slideDurationInterval = 0.4;
    //what are delays between dot animations
    final double slideDelayInterval = 0.2;
    //at the bottom of the screen
    double startingMarginTop = widget.height;
    //minimal margin from the top (where first dot will be placed)
    double minMarginTop =
        _minPlanePaddingTop + _planeSize + 0.5 * (0.8 * FlightStopCard.height);

    for (int i = 0; i < _flightStops.length; i++) {
      final start = slideDelayInterval * i;
      final end = start + slideDurationInterval;

      double finalMarginTop = minMarginTop + i * (0.8 * FlightStopCard.height);
      Animation<double> animation = new Tween(
        begin: startingMarginTop,
        end: finalMarginTop,
      ).animate(
        new CurvedAnimation(
          parent: _dotsAnimationController,
          curve: new Interval(start, end, curve: Curves.easeOut),
        ),
      );
      _dotPositions.add(animation);
    }
  }

  void _initDotAnimationController() {
    _dotsAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animateFlightStopCards().then((_) => _animateFab());
        }
      });
  }

  Future _animateFlightStopCards() async {
    return Future.forEach(_stopKeys, (GlobalKey<FlightStopCardState> stopKey) {
      return new Future.delayed(Duration(milliseconds: 250), () {
        stopKey.currentState.runAnimation();
      });
    });
  }

  void _initFabAnimationController() {
    _fabAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 300));
    _fabAnimation = new CurvedAnimation(
        parent: _fabAnimationController, curve: Curves.easeOut);
  }

  _animateFab() {
    _fabAnimationController.forward();
  }
}


class FlightStopCard extends StatefulWidget {
  final FlightStop flightStop;
  final bool isLeft;
  static const double height = 80.0;
  static const double width = 140.0;

  const FlightStopCard(
      {Key key, @required this.flightStop, @required this.isLeft})
      : super(key: key);

  @override
  FlightStopCardState createState() => FlightStopCardState();
}

class FlightStopCardState extends State<FlightStopCard>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _cardSizeAnimation;
  Animation<double> _durationPositionAnimation;
  Animation<double> _airportsPositionAnimation;
  Animation<double> _datePositionAnimation;
  Animation<double> _pricePositionAnimation;
  Animation<double> _fromToPositionAnimation;
  Animation<double> _lineAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 600));
    _cardSizeAnimation = new CurvedAnimation(
        parent: _animationController,
        curve: new Interval(0.0, 0.9, curve: new ElasticOutCurve(0.8)));
    _durationPositionAnimation = new CurvedAnimation(
        parent: _animationController,
        curve: new Interval(0.05, 0.95, curve: new ElasticOutCurve(0.95)));
    _airportsPositionAnimation = new CurvedAnimation(
        parent: _animationController,
        curve: new Interval(0.1, 1.0, curve: new ElasticOutCurve(0.95)));
    _datePositionAnimation = new CurvedAnimation(
        parent: _animationController,
        curve: new Interval(0.1, 0.8, curve: new ElasticOutCurve(0.95)));
    _pricePositionAnimation = new CurvedAnimation(
        parent: _animationController,
        curve: new Interval(0.0, 0.9, curve: new ElasticOutCurve(0.95)));
    _fromToPositionAnimation = new CurvedAnimation(
        parent: _animationController,
        curve: new Interval(0.1, 0.95, curve: new ElasticOutCurve(0.95)));
    _lineAnimation = new CurvedAnimation(
        parent: _animationController,
        curve: new Interval(0.0, 0.2, curve: Curves.linear));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void runAnimation() {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: FlightStopCard.height,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => new Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            buildLine(),
            // buildCard(),
            // buildDurationText(),
            // buildAirportNamesText(),
            // buildDateText(),
            // buildPriceText(),
            // buildFromToTimeText(),
          ],
        ),
      ),
    );
  }

  double get maxWidth {
    RenderBox renderBox = context.findRenderObject();
    BoxConstraints constraints = renderBox?.constraints;
    double maxWidth = constraints?.maxWidth ?? 0.0;
    return maxWidth;
  }

  Positioned buildDurationText() {
    double animationValue = _durationPositionAnimation.value;
    return Positioned(
      top: getMarginTop(animationValue), //<--- animate vertical position
      right: getMarginRight(animationValue), //<--- animate horizontal pozition
      child: Text(
        widget.flightStop.duration,
        style: new TextStyle(
          fontSize: 10.0 * animationValue, //<--- animate fontsize
          color: Colors.grey,
        ),
      ),
    );
  }

  Positioned buildAirportNamesText() {
    double animationValue = _airportsPositionAnimation.value;
    return Positioned(
      top: getMarginTop(animationValue),
      left: getMarginLeft(animationValue),
      child: Text(
        "${widget.flightStop.from} \u00B7 ${widget.flightStop.to}",
        style: new TextStyle(
          fontSize: 14.0*animationValue,
          color: Colors.grey,
        ),
      ),
    );
  }

  Positioned buildDateText() {
    double animationValue = _datePositionAnimation.value;
    return Positioned(
      left: getMarginLeft(animationValue),
      child: Text(
        "${widget.flightStop.date}",
        style: new TextStyle(
          fontSize: 14.0 * animationValue,
          color: Colors.grey,
        ),
      ),
    );
  }

  Positioned buildPriceText() {
    double animationValue = _pricePositionAnimation.value;
    return Positioned(
      right: getMarginRight(animationValue),
      child: Text(
        "${widget.flightStop.price}",
        style: new TextStyle(
          fontSize: 16.0* animationValue, color: Colors.black, fontWeight: FontWeight.bold,),
      ),
    );
  }

  Positioned buildFromToTimeText() {
    double animationValue = _fromToPositionAnimation.value;
    return Positioned(
      left: getMarginLeft(animationValue),
      bottom: getMarginBottom(animationValue),
      child: Text(
        "${widget.flightStop.fromToTime}",
        style: new TextStyle(
          fontSize: 12.0* animationValue, color: Colors.grey, fontWeight: FontWeight.w500,),
      ),
    );
  }

  Widget buildLine() {
    double animationValue = _lineAnimation.value;
    double maxLength = maxWidth - FlightStopCard.width;
    return Align(
        alignment: widget.isLeft ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          height: 2.0,
          width: maxLength * animationValue,
          color: Color.fromARGB(255, 200, 200, 200),
        ));
  }

  // Positioned buildCard() {
  //   double animationValue = _cardSizeAnimation.value;
  //   double minOuterMargin = 8.0;
  //   double outerMargin =
  //       minOuterMargin + (1 - animationValue) * maxWidth;
  //   return Positioned(
  //     right: widget.isLeft ? null : outerMargin,
  //     left: widget.isLeft ? outerMargin : null,
  //     child: Transform.scale(
  //       scale: animationValue,
  //       child: Container(
  //         width: 140.0,
  //         height: 80.0,
  //         child: new Card(
  //           color: Colors.grey.shade100,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  double getMarginBottom(double animationValue) {
    double minBottomMargin = 8.0;
    double bottomMargin =
        minBottomMargin + (1 - animationValue) * minBottomMargin;
    return bottomMargin;
  }

  double getMarginTop(double animationValue) {
    double minMarginTop = 8.0;
    double marginTop =
        minMarginTop + (1 - animationValue) * FlightStopCard.height * 0.5;
    return marginTop;
  }

  double getMarginLeft(double animationValue) {
    return getMarginHorizontal(animationValue, true);
  }

  double getMarginRight(double animationValue) {
    return getMarginHorizontal(animationValue, false);
  }

  double getMarginHorizontal(double animationValue, bool isTextLeft) {
    if (isTextLeft == widget.isLeft) {
      double minHorizontalMargin = 16.0;
      double maxHorizontalMargin = maxWidth - minHorizontalMargin;
      double horizontalMargin =
          minHorizontalMargin + (1 - animationValue) * maxHorizontalMargin;
      return horizontalMargin;
    } else {
      double maxHorizontalMargin = maxWidth - FlightStopCard.width;
      double horizontalMargin = animationValue * maxHorizontalMargin;
      return horizontalMargin;
    }
  }
}

class FlightStop {
  String from;
  String to;
  String date;
  String duration;
  String price;
  String fromToTime;

  FlightStop(this.from, this.to, this.date, this.duration, this.price,
      this.fromToTime);
}

class TicketFlightStop {
  String from;
  String fromShort;
  String to;
  String toShort;
  String flightNumber;

  TicketFlightStop(
      this.from, this.fromShort, this.to, this.toShort, this.flightNumber);
}


class AnimatedPlaneIcon extends AnimatedWidget {
  AnimatedPlaneIcon({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = super.listenable;
    return Icon(
      Icons.airplanemode_active,
      color: Colors.red,
      size: animation.value,
    );
  }
}

class MulticityInput extends StatefulWidget {
  @override
  MulticityInputState createState() {
    return new MulticityInputState();
  }
}

class MulticityInputState extends State<MulticityInput>
    with TickerProviderStateMixin {

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
  String mailId;
  String _password;
  String tenant;
  bool _obscureText = true;

  Widget button = Text(
    //S.of(context).Login
      'Login',
      style: TextStyle(fontSize: 20));

  String resetMail;
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
  AnimationController textInputAnimationController;

  @override
  void initState() {
    super.initState();
    textInputAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    textInputAnimationController.dispose();

    super.dispose();
  }
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.blue.withOpacity(0.5),
      padding: EdgeInsets.only(
        top: 200
      ),
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
            enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(
                    color: Theme.of(context).accentColor,
                    //color: Colors.deepPurple,
                    width: 2),
                //gapPadding: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(15.0))
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).accentColor,
                //  color: Colors.deepPurple
              ),
                borderRadius: BorderRadius.all(Radius.circular(15.0))
            ),
            prefixIcon: Icon(Icons.email, color: Theme.of(context).accentColor),
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

  CurvedAnimation _buildInputAnimation({double begin, double end}) {
    return new CurvedAnimation(
        parent: textInputAnimationController,
        curve: Interval(begin, end, curve: Curves.linear)
    );
  }

}

class FadeRoute<T> extends MaterialPageRoute<T> {
  FadeRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 100);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    //if (settings.isInitialRoute)
    //  return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return new FadeTransition(opacity: animation, child: child);
  }
}