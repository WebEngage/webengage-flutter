import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  late WebEngagePlugin _webEngagePlugin;
  late String os;

  void _onPushClick(Map<String, dynamic>? message, String? s) {
    print("This is a push click callback from native to flutter. Payload " +
        message.toString());
  }

  void _onPushActionClick(Map<String, dynamic>? message, String? s) {
    print(
        "This is a Push action click callback from native to flutter. Payload " +
            message.toString());
    print(
        "This is a Push action click callback from native to flutter. SelectedId " +
            s.toString());
  }

  void _onInAppPrepared(Map<String, dynamic>? message) {
    print("This is a inapp prepared callback from native to flutter. Payload " +
        message.toString());
  }

  void _onInAppClick(Map<String, dynamic>? message, String? s) {
    print("This is a inapp click callback from native to flutter. Payload " +
        message.toString());
  }

  void _onInAppShown(Map<String, dynamic>? message) {
    print("This is a callback on inapp shown from native to flutter. Payload " +
        message.toString());
  }

  void _onInAppDismiss(Map<String, dynamic>? message) {
    print(
        "This is a callback on inapp dismiss from native to flutter. Payload " +
            message.toString());
  }

  void _onTokenInvalidated(Map<String, dynamic>? message) {
    print(
        "This is a tokenInvalidated callback from native to flutter. Payload " +
            message.toString());
    WebEngagePlugin.setSecureToken("sn_ios",
        "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwiY3VpZCI6InNuX2lvcyIsImFkbWluIjp0cnVlLCJpYXQiOjE1MTYyMzkwMjJ9.Vssaf9-FgEzKWuZRM-n0f-52X6BV0xeSj-HNbdv_Faxy0tRXCiJFvK2M76MarG4fhlA1qcUmJ_-OhLdkBiP22CB-q7zo9gu-w3U5wADPFCelteM0fDH78QyCMQdJSRBHvrauB7SDcTyroQPNJ_CGQQl0yLLrTtYFSFqm9xkbDhzgODsVyZelN-vr7qIfr4isuWhgZZHCyLvpYdviSFiB7Jc5Rs-H7V5-aBMhYGnRGppgs35zqoO8Pjg8HjbTdFCcchIfx6-cBPv8UOVRoS6BESfJtKGcPDOt9FvjujW1oC3UTzLE4HxLva-OvDUxILviIycBwh7FMwPs2kL6tSKMSLsbt1hgCPU1XWPK4GBMHyu4orJbTvBvHJu_ARKWQBgD3y4XHzPPNW7-aulRV_Mq6IEOKlNPw3YrdgVCY6MRrThS3S2tlN4fe44JgUrWbAmQCbUim85Q9az9nz1Vs0spIzOzYWbmDemMtUfEa8vna00OTPyNaUGFxOLIZnfx3MbgfyY6YHv_V3YJH4BpW-jzAleYzZfjjkMja8UsDS2p_GM6ai9kHdqjRP_9ssaAl24pENBMgrevj-kMV_1S6uwbLv-MaaCyP6UeQw5SIkxu8HFgIJcGipXdIRnrnDSxonH_fgHQNhumQVeq-4kiIXbjlOcfnwDDl7jaZs55YRDmmBk");
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initWebEngage();
  }

  void initWebEngage() {
    _webEngagePlugin = new WebEngagePlugin();
    _webEngagePlugin.setUpPushCallbacks(_onPushClick, _onPushActionClick);
    _webEngagePlugin.setUpInAppCallbacks(_onInAppClick, _onInAppShown,
        _onInAppDismiss, _onInAppPrepared, _onTokenInvalidated);
    subscribeToPushCallbacks();
    subscribeToTrackDeeplink();
    subscribeToAnonymousIDCallback();
    _listenToAnonymousID();
  }

  var data = "";

  void _listenToAnonymousID() {
    _webEngagePlugin.anonymousActionStream.listen((event) {
      setState(() {
        data = "${event}";
      });
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await WebEngagePlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion!;
    });

    if (await Permission.notification.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      print("notification Permission is granted");
      WebEngagePlugin.setUserDevicePushOptIn(true);
    } else {
      print("notification Permission is denied.");
      WebEngagePlugin.setUserDevicePushOptIn(false);
    }
  }

  var anonymousId = "null";

  @override
  Widget build(BuildContext context) {
    data = data;
    print("build");
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: ListView(
            children: <Widget>[
              new ListTile(
                title: Text("$data"),
                onTap: () {
                  setState(() {
                    data = data;
                  });
                },
              ),
              new ListTile(
                title: Text("Login "),
                onTap: () {
                  String s = "sn_ios";
                  String jwtToken =
                      "ShubhameyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwiY3VpZCI6InNuX2lvcyIsImFkbWluIjp0cnVlLCJpYXQiOjE1MTYyMzkwMjJ9.Vssaf9-FgEzKWuZRM-n0f-52X6BV0xeSj-HNbdv_Faxy0tRXCiJFvK2M76MarG4fhlA1qcUmJ_-OhLdkBiP22CB-q7zo9gu-w3U5wADPFCelteM0fDH78QyCMQdJSRBHvrauB7SDcTyroQPNJ_CGQQl0yLLrTtYFSFqm9xkbDhzgODsVyZelN-vr7qIfr4isuWhgZZHCyLvpYdviSFiB7Jc5Rs-H7V5-aBMhYGnRGppgs35zqoO8Pjg8HjbTdFCcchIfx6-cBPv8UOVRoS6BESfJtKGcPDOt9FvjujW1oC3UTzLE4HxLva-OvDUxILviIycBwh7FMwPs2kL6tSKMSLsbt1hgCPU1XWPK4GBMHyu4orJbTvBvHJu_ARKWQBgD3y4XHzPPNW7-aulRV_Mq6IEOKlNPw3YrdgVCY6MRrThS3S2tlN4fe44JgUrWbAmQCbUim85Q9az9nz1Vs0spIzOzYWbmDemMtUfEa8vna00OTPyNaUGFxOLIZnfx3MbgfyY6YHv_V3YJH4BpW-jzAleYzZfjjkMja8UsDS2p_GM6ai9kHdqjRP_9ssaAl24pENBMgrevj-kMV_1S6uwbLv-MaaCyP6UeQw5SIkxu8HFgIJcGipXdIRnrnDSxonH_fgHQNhumQVeq-4kiIXbjlOcfnwDDl7jaZs55YRDmmBk";
                  WebEngagePlugin.userLoginWithSecureToken(s, jwtToken);
                  showToast("Login-" + s);
                },
              ),
              new ListTile(
                title: Text("Logout"),
                onTap: () {
                  WebEngagePlugin.userLogout();
                  showToast("Logout");
                },
              ),
              new ListTile(
                title: Text("Set FirstName"),
                onTap: () {
                  WebEngagePlugin.setUserFirstName('Sourabh');
                  showToast("User FirstName- Sourabh");
                },
              ),
              new ListTile(
                title: Text("Set LastName"),
                onTap: () {
                  WebEngagePlugin.setUserLastName('Gupta');
                  showToast("LastName Gupta");
                },
              ),
              new ListTile(
                title: Text("Set UserEmail"),
                onTap: () {
                  WebEngagePlugin.setUserEmail('ram@gmail.com');
                  showToast("Email - ram@gmail.com");
                },
              ),
              new ListTile(
                title: Text("Set UserHashedEmail"),
                onTap: () {
                  WebEngagePlugin.setUserHashedEmail(
                      '144e0424883546e07dcd727057fd3b62');
                  showToast("HashedEmail - 144e0424883546e07dcd727057fd3b62");
                },
              ),
              new ListTile(
                title: Text("Set UserPhone"),
                onTap: () {
                  WebEngagePlugin.setUserPhone('+919999900000');
                  showToast("Phone - +919999900000");
                },
              ),
              new ListTile(
                title: Text("Set UserHashedPhone"),
                onTap: () {
                  WebEngagePlugin.setUserHashedPhone(
                      'e0ec043b3f9e198ec09041687e4d4e8d');
                  showToast("HashedPhone - e0ec043b3f9e198ec09041687e4d4e8d");
                },
              ),
              new ListTile(
                title: Text("Set UserCompany"),
                onTap: () {
                  WebEngagePlugin.setUserCompany('WebEngage');
                  showToast("Company - WebEngage");
                },
              ),
              new ListTile(
                title: Text("Set UserBirthDate"),
                onTap: () {
                  WebEngagePlugin.setUserBirthDate('1994-05-24');
                  showToast("BirthDate - 1994-05-24");
                },
              ),
              new ListTile(
                title: Text("Set User Gender"),
                onTap: () {
                  WebEngagePlugin.setUserGender('male');
                  showToast("Gender - Male");
                },
              ),
              new ListTile(
                title: Text("Set User Location"),
                onTap: () {
                  WebEngagePlugin.setUserLocation(19.25, 72.45);
                  showToast("Location - 19.25, 72.45");
                },
              ),
              new ListTile(
                title: Text("Track Event with no attributes"),
                onTap: () {
                  WebEngagePlugin.trackEvent('Added to Cart');
                  showToast("Added to Cart tracked ");
                },
              ),
              new ListTile(
                title: Text("Opt-In  Push, InApp,email,sms"),
                onTap: () {
                  WebEngagePlugin.setUserOptIn('in_app', true);
                  WebEngagePlugin.setUserOptIn('sms', true);
                  WebEngagePlugin.setUserOptIn('push', true);
                  WebEngagePlugin.setUserOptIn('email', true);
                  showToast("Opt-In  Push, InApp,email,sms ");
                },
              ),
              new ListTile(
                title: Text("Opt-Out  Push, InApp,email,sms"),
                onTap: () {
                  WebEngagePlugin.setUserOptIn('in_app', false);
                  WebEngagePlugin.setUserOptIn('sms', false);
                  WebEngagePlugin.setUserOptIn('push', false);
                  WebEngagePlugin.setUserOptIn('email', false);
                  showToast("Opt-Out  Push, InApp,email,sms ");
                },
              ),
              new ListTile(
                title: Text("Track event with attributes"),
                onTap: () {
                  WebEngagePlugin.trackEvent("Cart Updated", {
                    "Product Details": [
                      {
                        "Product Name":
                            "Xiaomi Commuter Backpack 15.6-inch Laptop Bag Anti-theft Backpack For Business/Travel Backpack - Light Grey",
                        "Discount": 5,
                        "Currency": "AED",
                        "Product ID": "STRUS-1897338-ZJB4196GL-LIGHT G",
                        "Price Without Discount": 78,
                        "Quantity": 2,
                        "Price With Discount": 73,
                        "Image": [
                          "https://storeus-xcart.s3.me-central-1.amazonaws.com/images/product/1685024207646f6dc5d771e.jpg"
                        ]
                      }
                    ],
                    "Total Amount": 156,
                    "Quantity": 2,
                    "No. Of Products": 1,
                    "Region": "AE"
                  });
                  showToast("Order Placed tracked Amount: 808.48");
                },
              ),
              new ListTile(
                title: Text("Track Screen"),
                onTap: () {
                  WebEngagePlugin.trackScreen('Home Page');
                  showToast("Track Screen :Home Page");
                },
              ),
              new ListTile(
                title: Text("Track Screen with data"),
                onTap: () {
                  WebEngagePlugin.trackScreen(
                      'Product Page', {'Product Id': 'UHUH799'});
                  showToast(
                      "Track Screen :Product Page', {'Product Id': 'UHUH799'}");
                },
              ),
              new ListTile(
                title: Text("Set User attribute with string value "),
                onTap: () {
                  WebEngagePlugin.setUserAttribute(
                      "twitterusename", "saurav12994");
                  showToast("twitterusename:saurav12994");
                },
              ),
              // WebEngagePlugin.setUserAttribute("twitterusename", "saurav12994");
              // WebEngagePlugin.setUserAttribute("Subscribed to email", true);
              // WebEngagePlugin.setUserAttribute("Points earned", 2626);
              // WebEngagePlugin.setUserAttribute("Dollar Spent", 123.44);
              new ListTile(
                title: Text("Set User attribute with Double value "),
                onTap: () {
                  WebEngagePlugin.setUserAttribute("Dollar Spent", 123.44);
                  showToast("Dollar Spent:123.44");
                },
              ),
              new ListTile(
                title: Text("Set User attribute with Boolean value "),
                onTap: () {
                  WebEngagePlugin.setUserAttribute("Subscribed to email", true);
                  showToast("Subscribed to email:true");
                },
              ),
              new ListTile(
                title: Text("Set User attribute with Integer value "),
                onTap: () {
                  WebEngagePlugin.setUserAttribute("Points earned", 2626);
                  showToast("Points earned:2626");
                },
              ),
              new ListTile(
                title: Text("Set User attribute with Map value "),
                onTap: () {
                  var details = {'Usrname': 'tom', 'Passiword': 'pass@123'};

                  WebEngagePlugin.setUserAttributes(details);
                  showToast("Usrname':'tom','Passiword':'pass@123");
                },
              ),
              new ListTile(
                title: Text("Track Date"),
                onTap: () {
                  final DateTime now = DateTime.now();
                  final DateFormat formatter =
                      DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
                  WebEngagePlugin.trackEvent(
                      'Register', {'Registered On': formatter.format(now)});
                  showToast("Track ${formatter.format(now)}");
                },
              ),
              new ListTile(
                title: Text("Set User Device Push Opt in"),
                onTap: () {
                  WebEngagePlugin.setUserDevicePushOptIn(true);
                  showToast("UserDevice Push OptIn set to true");
                },
              ),
            ],
          )),
    );
  }

  void showToast(String msg) {
    // Fluttertoast.showToast(
    //     msg: msg,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }

  @override
  void dispose() {
    _webEngagePlugin.pushSink.close();
    _webEngagePlugin.pushActionSink.close();
    _webEngagePlugin.trackDeeplinkURLStreamSink.close();
    super.dispose();
  }

  void subscribeToPushCallbacks() async {
    //Push click stream listener
    _webEngagePlugin.pushStream.listen((event) {
      String? deepLink = event.deepLink;
      Map<String, dynamic> messagePayload = event.payload!;
      showDialogWithMessage("Push click callback: " + event.toString());
    });

    //Push action click listener
    _webEngagePlugin.pushActionStream.listen((event) {
      print("pushActionStream:" + event.toString());
      String? deepLink = event.deepLink;
      Map<String, dynamic>? messagePayload = event.payload;
      showDialogWithMessage("PushAction click callback: " + event.toString());
    });
  }

  void subscribeToTrackDeeplink() {
    _webEngagePlugin.trackDeeplinkStream.listen((location) {
      //Location URL
    });
  }

  void subscribeToAnonymousIDCallback() {
    // _webEngagePlugin.anonymousActionStream.listen((event) {
    //   //  var message = event as Map<String,dynamic>;
    //   this.setState(() {
    //     anonymousId  =  "${event}";
    //   });
    // });
  }

  final navigatorKey = GlobalKey<NavigatorState>();

  void showDialogWithMessage(String msg) {
    showDialog(
        context: navigatorKey.currentState!.overlay!.context,
        builder: (BuildContext context) {
          return Dialog(
              insetPadding: EdgeInsets.all(5.0),
              child: new Container(
                // padding: new EdgeInsets.all(10.0),
                decoration: new BoxDecoration(
                  color: Colors.white,
                ),
                child: new Text(
                  msg,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontFamily: 'helvetica_neue_light',
                  ),
                  textAlign: TextAlign.center,
                ),
              ));
        });
  }
}
