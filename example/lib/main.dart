import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:webengage_plugin/webengage_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  WebEngagePlugin _webEngagePlugin;
  void _onPushClick(Map<String, dynamic> message) {
    print("This is a push click callback from native to flutter. Payload " +
        message.toString());
  }
  @override
  void initState() {
    super.initState();
    initPlatformState();
    _webEngagePlugin = new WebEngagePlugin();
    // _webEngagePlugin.setCleverTapPushClickedPayloadReceivedHandler(pushClickedPayloadReceived);
    _webEngagePlugin.setUpPushCallbacks(_onPushClick);
  }
  void pushClickedPayloadReceived(Map<String, dynamic> map) {
    print("pushClickedPayloadReceived called");
    // this.setState(() async {
    //   var data = jsonEncode(map);
    //   print("on Push Click Payload = " + data.toString());
    // });
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
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
      _platformVersion = platformVersion;

      // User login
      // WebEngagePlugin.userLogin('202010191050');

      // User logout
      // WebEngagePlugin.userLogout();

      // Set user first name
      // WebEngagePlugin.setUserFirstName('John');

      // Set user last name
      // WebEngagePlugin.setUserLastName('Doe');

      // Set user email
      // WebEngagePlugin.setUserEmail('john.doe@gmail.com');

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
