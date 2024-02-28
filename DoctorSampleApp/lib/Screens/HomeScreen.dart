import 'package:dev_sample_app/CommonComponents/Button.dart';
import 'package:dev_sample_app/Screens/EventsScreen.dart';
import 'package:dev_sample_app/Screens/ScreenNavigationScreen.dart';
import 'package:dev_sample_app/Screens/UserProfileScreen.dart';
import 'package:dev_sample_app/Screens/notification_inbox.dart';
import 'package:dev_sample_app/WEUtils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dev_sample_app/WEUtils/WEConstants.dart';
import 'package:flutter/services.dart';
import 'package:we_notificationinbox_flutter/utils/WELogger.dart';
import 'package:we_notificationinbox_flutter/we_notificationinbox_flutter.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dev_sample_app/Screens/InLine/InLineHomeScreen.dart';
import 'package:we_notificationinbox_flutter/src/we_notification_response.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String loginUser = WEConstants.login;
  final _weNotificationInboxFlutterPlugin = WENotificationinboxFlutter();
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    initWebEngage();
  }

  Future<void> initWebEngage() async {
    _getLoggedInUser();
    setState(() {
      getNotificationCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(WEConstants.appName),
        actions: [
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (prefs.getString('loggedInUser') != null) {
                _showLogoutDialog(context);
              } else {
                _showInputDialog(context);
              }
            },
            child: Text(
              loginUser,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () async {
                    setState(() {
                      // _notificationCount = 0;
                    });
                    navigateToScreen(context, WEConstants.notificationInbox);
                  }),
              Positioned(
                right: 11,
                top: 11,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    '$_notificationCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            CustomStyledButton(
              onPressed: () {
                navigateToScreen(context, WEConstants.userProfile);
              },
              label: WEConstants.userProfile,
            ),
            SizedBox(height: 20),
            CustomStyledButton(
              onPressed: () {
                navigateToScreen(context, WEConstants.events);
              },
              label: WEConstants.events,
            ),
            SizedBox(height: 20),
            CustomStyledButton(
              onPressed: () {
                navigateToScreen(context, WEConstants.screens);
              },
              label: WEConstants.screens,
            ),
            SizedBox(height: 20),
            CustomStyledButton(
              onPressed: () {
                navigateToScreen(context, WEConstants.inLine);
              },
              label: WEConstants.inLine,
            ),
          ],
        ),
      ),
    );
  }

  void navigateToScreen(BuildContext context, String screenName) {
    switch (screenName) {
      case WEConstants.userProfile:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfileScreen()),
        );
        break;
      case WEConstants.events:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventsScreen()),
        );
        break;
      case WEConstants.screens:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScreenNavigationScreen()),
        );
        break;
      case WEConstants.inLine:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InLineHomeScreen()),
        );
        break;
      case WEConstants.notificationInbox:
        resetNotificationCount();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationInbox()),
        );
        break;
      default:
        break;
    }
  }

  Future<void> _showInputDialog(BuildContext context) async {
    String username = '';
    String password = '';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(WEConstants.login),
          contentPadding: EdgeInsets.all(10),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: WEConstants.username),
                  onChanged: (value) {
                    username = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: WEConstants.password),
                  onChanged: (value) {
                    password = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (password == '') {
                  WebEngagePlugin.userLogin(username);
                } else {
                  WebEngagePlugin.userLogin(username, password);
                }

                Navigator.of(context).pop();

                // Save the username in local storage
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('loggedInUser', username);

                setState(() {
                  loginUser = username;
                });
              },
              child: Text(WEConstants.login),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout: $loginUser'),
          contentPadding: EdgeInsets.all(10),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                WebEngagePlugin.userLogout();
                Navigator.of(context).pop();

                // Save the username in local storage
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('loggedInUser');

                setState(() {
                  loginUser = 'Login';
                });
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loginUser = prefs.getString('loggedInUser') ?? WEConstants.login;
    });
  }

  Future<void> getNotificationCount() async {
    String notificationCount = "0";
    WENotificationResponse weNotificationResponse =
        await _weNotificationInboxFlutterPlugin.getNotificationCount();
    if (weNotificationResponse.isSuccess) {
      notificationCount = weNotificationResponse.response;
      if (kDebugMode) {
        print(
            "WebEngage-Sample-App: notificationCount in the sample App \n ${weNotificationResponse.response}");
      }
    } else {
      if (kDebugMode) {
        print(
            "WebEngage-Sample-App: Exception occurred while accessing Notification Count \n ${weNotificationResponse.errorMessage} ");
      }
    }
    if (!mounted) return;
    setState(() {
      _notificationCount = int.parse(notificationCount);
    });
  }

  Future<void> resetNotificationCount() async {
    try {
      await _weNotificationInboxFlutterPlugin.resetNotificationCount();
    } catch (error) {
      if (kDebugMode) {
        print("WebEngage-Sample-App: Error while reseting Notification count");
      }
    }
    if (!mounted) return;

    setState(() {
      _notificationCount = 0;
    });
  }
}
