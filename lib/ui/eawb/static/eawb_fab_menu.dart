import 'package:flutter/cupertino.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:rooster/generated/l10n.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EawbFabMenu extends StatelessWidget {
  const EawbFabMenu(this.context, this.dialVisible, {Key key})
      : super(key: key);

  final bool dialVisible;
  final BuildContext context;

  void _loaderDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<bool> _saveConfirmDialog(model) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Text(
             S.of(context).WouldyouliketoSave,
             // "Would you like to Save?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            content: new Text(
              S.of(context).YouhavemadeseveralchangesSavethefieldforfutureuse
             // 'You have made several changes!\nSave the field for future use.',
              ,textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  S.of(context).Cancel,
                  //  "Cancel"
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  S.of(context).Save,
                  //  "Save"
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _reloadConfirmDialog(model) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Text(
              S.of(context).WouldyouliketoReload,
              //"Would you like to Reload?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            content: new Text(
             S.of(context).Onreloadallthefeildswillsetbacktolastsavedata
              // 'On reload all the feilds will set back to last save data.',
             , textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  S.of(context).Cancel,
                  // "Cancel"
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  S.of(context).Ok
                  // "OK"
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _clearConfirmDialog(model) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Text(
             S.of(context).WouldyouliketoClear,
             // "Would you like to Clear?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            content: new Text(
             S.of(context).IfyouclearallthefieldwillbeDelete,
             // 'If you clear, all the field will be Delete!',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                    S.of(context).Cancel,
                  //  "Cancel"
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  S.of(context).Ok,
                  // "OK"
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EAWBModel>(
      builder: (context, model, child) => SpeedDial(
        // both default to 16
        marginRight: MediaQuery.of(context).size.height * 0.025,
        marginBottom: MediaQuery.of(context).size.height * 0.05,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 25.0),
        visible: dialVisible,
        closeManually: false,
        curve: Curves.elasticInOut,
        overlayColor: Colors.black,
        overlayOpacity: 0.75,
        onOpen: () => print('OPENING MENU'),
        onClose: () => print('CLOSING MENU'),
        backgroundColor: Theme.of(context).accentColor,
        //foregroundColor: Colors.black,
        elevation: 15.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.save),
              backgroundColor: Colors.green,
              label:
              S.of(context).Save,
              //'Save',
              labelStyle: TextStyle(
                //backgroundColor: Theme.of(context).accentColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              onTap: () async {
                if (await _saveConfirmDialog(model)) {
                  _loaderDialog();
                  bool isSaved = await model.inserteAWB();
                  Navigator.pop(context);
                  if (isSaved) {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:Text(
                          S.of(context).DataSavedSuccessfully,
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:Text(
                          S.of(context).Somethingwentwrong,
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    print(isSaved);
                  }
                }
              }),
          SpeedDialChild(
            child: Icon(Icons.print),
            backgroundColor: Colors.blue,
            label:
            S.of(context).Print,
            //'Print',
            labelStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
                //color: Theme.of(context).accentColor
               color: Colors.black,
            ),
            onTap: () async {
              _loaderDialog();
              String printData = await model.printEAWB();
              Navigator.pop(context);
              print('PRINT $printData');
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.backspace),
            backgroundColor: Colors.red,
            label:
            S.of(context).Clear,

            //'Clear',
            labelStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
             // color: Theme.of(context).accentColor
               color: Colors.black,
            ),
            onTap: () async {
              if (await _clearConfirmDialog(model)) {
                model.clearEAWB();
              }
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.autorenew),
            backgroundColor: Colors.cyan,
            label:
            S.of(context).Reload,
            //'Reload',
            labelStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,

               // color: Theme.of(context).accentColor
               color: Colors.black,
            ),
            onTap: () async {
              if (await _reloadConfirmDialog(model)) {
                _loaderDialog();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String result =
                    await model.getEAWB(prefs.getString("awbListid"));
                Navigator.pop(context);
                Navigator.of(context, rootNavigator: true).pop('dialog');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:Text(
                      result,
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
          // SpeedDialChild(
          //   child: Icon(Icons.filter_1),
          //   backgroundColor: Colors.indigo,
          //   label: 'Load Sample 1',
          //   labelStyle: TextStyle(
          //     fontSize: 16.0,
          //     fontWeight: FontWeight.w700,
          //     color: Colors.black,
          //   ),
          //   onTap: () => print('LOAD SAMPLE 1'),
          // ),
          // SpeedDialChild(
          //   child: Icon(Icons.filter_2),
          //   backgroundColor: Colors.brown,
          //   label: 'Load Sample 2',
          //   labelStyle: TextStyle(
          //     fontSize: 16.0,
          //     fontWeight: FontWeight.w700,
          //     color: Colors.black,
          //   ),
          //   onTap: () => print('LOAD SAMPLE 2'),
          // ),
          // SpeedDialChild(
          //   child: Icon(Icons.filter_3),
          //   backgroundColor: Colors.teal,
          //   label: 'Load Sample 3',
          //   labelStyle: TextStyle(
          //     fontSize: 16.0,
          //     fontWeight: FontWeight.w700,
          //     color: Colors.black,
          //   ),
          //   onTap: () => print('LOAD SAMPLE 3'),
          // ),
        ],
      ),
    );
  }
}
