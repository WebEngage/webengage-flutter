import 'package:dev_sample_app/Screens/HomeScreen.dart';
import 'package:dev_sample_app/WEUtils/Utils.dart';
import 'package:dev_sample_app/WEUtils/WEConstants.dart';
import 'package:flutter/material.dart';
import 'package:dev_sample_app/Styles/Colors.dart';
import 'package:we_personalization_flutter/we_personalization_flutter.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import 'Screens/InLine/CustomScreen.dart';
import 'Screens/InLine/DetailScreen.dart';
import 'Screens/InLine/ListScreen.dart';
import 'WEUtils/Logger.dart';
import 'WEUtils/ScreenNavigator.dart';
import 'observer/RouteObserver.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() {
  runApp(MyHomePage());
}

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyHomePageState();
// }

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WECampaignCallback {
  @override
  void initState() {
    super.initState();
    WebEngagePlugin _webenagePlugin = WebEngagePlugin();
    WEPersonalization().init(enableLogs: true);
    WEPersonalization().registerWECampaignCallback(this);
    initSharedPref();
  }

  void initSharedPref() {
    Utils.initSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColors.webengagePurple,
      )),
      home: Scaffold(
        appBar: AppBar(
          title: Text(WEConstants.APP_TITLE),
        ),
        body: Container(),
      ),
      initialRoute: ScreenNavigator.SCREEN_HOME,
      routes: {
        ScreenNavigator.SCREEN_HOME: (context) => const HomeScreen(),
        ScreenNavigator.SCREEN_LIST: (context) => const ListScreen(),
        ScreenNavigator.SCREEN_DETAIL: (context) => const DetailScreen(),
        ScreenNavigator.SCREEN_CUSTOM: (context) => CustomInlineScreen(
              isDialog: false,
            )
      },
      navigatorKey: navigatorKey,
      navigatorObservers: [MyRouteObserver(), routeObserver],
    );
  }

  @override
  void onCampaignShown(data) {
    super.onCampaignShown(data);
    Logger.v("onCampaignShown ${data.toJson()}");
  }

  bool isValidUrl(String url) {
    Uri uri = Uri.parse(url);
    return uri.hasScheme;
  }

  @override
  void onCampaignClicked(String actionId, String deepLink, data) {
    super.onCampaignClicked(actionId, deepLink, data);
    if (deepLink.trim().isNotEmpty && isValidUrl(deepLink)) {
      ScreenNavigator.gotoDeepLinkScreen(
          navigatorKey.currentContext, "$deepLink");
    }
    Logger.v("onCampaignClicked $deepLink ${deepLink.length}");
    Logger.v("onCampaignClicked $actionId $deepLink ${data.toJson()}");
  }

  @override
  void onCampaignPrepared(data) {
    super.onCampaignPrepared(data);
    Logger.v("onCampaignPrepared ${data.toJson()}");
  }

  @override
  void onCampaignException(
      String? campaignId, String targetViewId, String error) {
    super.onCampaignException(campaignId, targetViewId, error);
    Logger.v("onCampaignException $campaignId $targetViewId $error");
  }
}

// class AuthenticationWrapper extends StatelessWidget {
//   bool isUserLoggedIn = false;

//   @override
//   Widget build(BuildContext context) {
//     return HomeScreen();
//   }
// }

