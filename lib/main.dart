import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/model/emanifest_model.dart';
import 'package:rooster/model/fhl_model.dart';
import 'package:rooster/model/slot_booking/main_slotbooking.dart';
import 'package:rooster/model/user_model.dart';
import 'package:rooster/theme_changer.dart';
import 'package:rooster/ui/loginscreen/new_login.dart';
import 'package:rooster/ui/loginscreen/new_signin_sigup.dart';
import 'package:rooster/ui/splashscreen/main_splashscreen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'generated/l10n.dart';
import 'languagechangeprovider.dart';
import 'model/chat_model/chat_messagemodel.dart';
import 'package:cron/cron.dart';
import 'package:rooster/string.dart';

Future<void> main() async {
  final cron = Cron();
  cron.schedule(Schedule.parse('*/5 * * * * *'), () async {
    //print('Runs every Five seconds');
    if (StringData.airportCodes.length == 0 ||
        StringData.specialhandlinggroup.length == 0 ||
        StringData.airlineCodes.length==0||
        StringData.contactType.length == 0 ||
        StringData.CHGSCode.length==0||
        StringData.currencyCode.length == 0) {
      StringData.loadAirportCode();
      StringData.loadtContactType();
      StringData.loadRateClassCode();
      StringData.loadAccId();
      StringData.loadShgCode();
      StringData.loadtCHGSCode();
      StringData.loadVolumeCode();
      StringData.loadAirlineCode();
      StringData.loadCurrency();
      StringData.loadExchangeRate();
    }
    // StringData.loadAirlineCode();
    //StringData.sendMessage("Corn test Notification");
    //await Future.delayed(Duration(seconds: 30));
    //await cron.close();
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => EAWBModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => FHLModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => MessageList(),
        ),
        ChangeNotifierProvider(
          create: (_) => SlotBookingList(),
        ),
        ChangeNotifierProvider(
          create: (_) => ManifestModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserModel(null, null),
        ),
        ChangeNotifierProvider(create: (_) => ThemeChanger())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return ChangeNotifierProvider<LanguageChangeProvider>(
      create: (context) => LanguageChangeProvider(),
      child: Builder(
        builder: (context) => MaterialApp(
          locale: Provider.of<LanguageChangeProvider>(context, listen: true)
              .currentLocale,
          //locale: new Locale("hi"),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          title: 'Rooster',
          theme: theme.themeData,
          darkTheme: ThemeData.dark()
            ..copyWith(
              backgroundColor: Colors.grey[800],
            ),

          themeMode: theme.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          home:
         // LoginPage(),
          //  ContentCard(),
          SplashScreen(),
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}
