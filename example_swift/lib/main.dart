
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('flutter Handling a background message');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _platformVersion = 'Unknown';
  late WebEngagePlugin _webEngagePlugin;
  late String os;

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

  @override
  void initState() {
    super.initState();

    initPlatformState();
    initWebEngage();
    initFirebase();
  }

  Future<void> initFirebase() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
   _firebaseMessaging.setAutoInitEnabled(true);
   FirebaseMessaging.onMessage.listen((event) {
     print("flutter Firebase Notification received");
     //print("${event.notification!.body}");
      setState(() {
       // message = "${event.notification!.body}";
      });
   });



    // FirebaseMessaging messaging = FirebaseMessaging.instance;
    // // Set the background messaging handler early on, as a named top-level function
    // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //   print("message recieved");
    //   print(event.notification!.body);
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print('Message clicked!');
    // });
  }

  void initWebEngage() {
    _webEngagePlugin = new WebEngagePlugin();
    _webEngagePlugin.setUpInAppCallbacks(
        _onInAppClick, _onInAppShown, _onInAppDismiss, _onInAppPrepared);
    subscribeToPushCallbacks();
    subscribeToTrackDeeplink();
  }

  var message = "NO";

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

      // User login
      //   WebEngagePlugin.userLogin('saurav1237493cf');

      // User logout
      // WebEngagePlugin.userLogout();

      // Set user first name
      // WebEngagePlugin.setUserFirstName('John');

      // Set user last name
      // WebEngagePlugin.setUserLastName('Doe');

      // Set user email
      //WebEngagePlugin.setUserEmail('john.doe@gmail.com');

      // Set user hashed email
      // WebEngagePlugin.setUserHashedEmail('144e0424883546e07dcd727057fd3b62');

      // Set user phone number
      // WebEngagePlugin.setUserPhone('+551155256325');

      // Set user hashed phone number
      // WebEngagePlugin.setUserHashedPhone('e0ec043b3f9e198ec09041687e4d4e8d');

      // Set user company
      // WebEngagePlugin.setUserCompany('WebEngage');

      // Set user birth-date, supported format: 'yyyy-MM-dd'
      // WebEngagePlugin.setUserBirthDate('1994-05-24');

      // Set user gender, allowed values are ['male', 'female', 'other']
      // WebEngagePlugin.setUserGender('male');

      // Set opt-in status, channels: ['push', 'in_app', 'email', 'sms']
      // WebEngagePlugin.setUserOptIn('in_app', false);

      // Set user location
      // WebEngagePlugin.setUserLocation(19.25, 72.45);

      // Track simple event
      // WebEngagePlugin.trackEvent('Added to Cart');

      // Track event with attributes
      // WebEngagePlugin.trackEvent('Order Placed', {'Amount': 808.48});

      // Track screen
      // WebEngagePlugin.trackScreen('Home Page');

      // Track screen with data
      // WebEngagePlugin.trackScreen('Product Page', {'Product Id': 'UHUH799'});

      // Set User Attribute with  String value
      // WebEngagePlugin.setUserAttribute("twitterusename", "saurav12994");

      // Set User Attribute with  Boolean value
      // WebEngagePlugin.setUserAttribute("Subscribed to email", true);

      // Set User Attribute with  Integer value
      // WebEngagePlugin.setUserAttribute("Points earned", 2626);

      // Set User Attribute with  Double value
      // WebEngagePlugin.setUserAttribute("Dollar Spent", 123.44);

      // Set User Attribute with  Map value
      // var details = {'Usrname':'tom','Passiword':'pass@123'};
      // WebEngagePlugin.setUserAttributes(details);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
          appBar: AppBar(
            title: Text('Plugin example app'),
          ),
          body: ListView(
            children: <Widget>[
              new ListTile(
                title: Text("Login"+message),
                onTap: () {
                  String s = "test" + randomString(6);
                  WebEngagePlugin.userLogin(s);
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
                  WebEngagePlugin.setUserFirstName('John');
                  showToast("User FirstName- John");
                },
              ),
              new ListTile(
                title: Text("Set LastName"),
                onTap: () {
                  WebEngagePlugin.setUserLastName('Wick');
                  showToast("LastName Wick");
                },
              ),
              new ListTile(
                title: Text("Set UserEmail"),
                onTap: () {
                  WebEngagePlugin.setUserEmail('john.wick@gmail.com');
                  showToast("Email - john.wick@gmail.com");
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
                  WebEngagePlugin.trackEvent(
                      'Order Placed', {'Amount': 808.48});
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
      showToast("Push click callback: " + event.toString() );
    });

    //Push action click listener
    _webEngagePlugin.pushActionStream.listen((event) {
      print("pushActionStream:" + event.toString());
      String? deepLink = event.deepLink;
      Map<String, dynamic>? messagePayload = event.payload;
      showToast("PushAction click callback: " + event.toString());
    });
  }

  void subscribeToTrackDeeplink() {
    _webEngagePlugin.trackDeeplinkStream.listen((location) {
      //Location URL
    });
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
