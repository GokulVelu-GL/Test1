import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:rooster/model/eawb_model.dart';
import 'package:rooster/model/emanifest_model.dart';
import 'package:rooster/model/fhl_model.dart';
import 'package:rooster/model/slot_booking/main_slotbooking.dart';
import 'package:rooster/model/user_model.dart';
import 'package:rooster/theme_changer.dart';
import 'package:rooster/ui/hawb/offline_main_hawb/api.dart';
import 'package:rooster/ui/hawb/offline_main_hawb/model_class.dart';
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
  HttpOverrides.global = new MyHttpOverrides();
  // final cron = Cron();
  // cron.schedule(Schedule.parse('*/5 * * * * *'), () async {
  //   //print('Runs every Five seconds');
  //   if (StringData.airportCodes.length == 0 ||
  //       StringData.specialhandlinggroup.length == 0 ||
  //       StringData.airlineCodes.length==0 ||
  //       StringData.contactType.length == 0 ||
  //       StringData.CHGSCode.length==0 ||
  //       StringData.currencyCode.length == 0) {
  //     StringData.loadAirportCode();
  //     StringData.loadtContactType();
  //     StringData.loadRateClassCode();
  //     StringData.loadAccId();
  //     StringData.loadShgCode();
  //     StringData.loadtCHGSCode();
  //     StringData.loadVolumeCode();
  //     StringData.loadAirlineCode();
  //     StringData.loadCurrency();
  //     StringData.loadExchangeRate();
  //   }
  //   // StringData.loadAirlineCode();
  //   //StringData.sendMessage("Corn test Notification");
  //   //await Future.delayed(Duration(seconds: 30));
  //   //await cron.close();
  // });
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(AwbListOfflineAdapter());
  await Hive.openBox('AwbList');

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
        ChangeNotifierProvider(create: (_) => ThemeChanger()),
        ChangeNotifierProvider(
          create: (_) => Api(),
        ),
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
          builder: (context, widget) {
            return ResponsiveWrapper.builder(
              BouncingScrollWrapper.builder(context, widget),
              maxWidth: 1200,
              minWidth: 400.0,
              defaultScale: true,
              breakpoints: const [
                ResponsiveBreakpoint.resize(450, name: MOBILE),
                ResponsiveBreakpoint.autoScale(800, name: TABLET),
                ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                ResponsiveBreakpoint.autoScale(2460, name: "4K"),
              ],
              background: Container(
                color: const Color(0xFFF5F5F5),
              ),
            );
            EasyLoading.init();
          },
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
          // builder: EasyLoading.init(),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
