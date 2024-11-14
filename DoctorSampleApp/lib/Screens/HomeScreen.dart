import 'package:dev_sample_app/CommonComponents/Button.dart';
import 'package:dev_sample_app/Screens/EventsScreen.dart';
import 'package:dev_sample_app/Screens/InLine/InLineHomeScreen.dart';
import 'package:dev_sample_app/Screens/ScreenNavigationScreen.dart';
import 'package:dev_sample_app/Screens/UserProfileScreen.dart';
import 'package:dev_sample_app/Screens/notification_inbox.dart';
import 'package:dev_sample_app/WEUtils/WEConstants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_notificationinbox_flutter/src/we_notification_response.dart';
import 'package:we_notificationinbox_flutter/we_notificationinbox_flutter.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String loginUser = WEConstants.login;
  final _weNotificationInboxFlutterPlugin = WENotificationinboxFlutter();
  int _notificationCount = 0;
  String callbacksTxt = "";

  @override
  void initState() {
    super.initState();
    initWebEngage();
    handleMobile();
    handleWeb();
  }

  @override
  void dispose() {
    WebEngagePlugin().anonymousActionSink.close();
    WebEngagePlugin().pushSink.close();
    WebEngagePlugin().pushActionSink.close();
    super.dispose();
  }

  Future<void> initWebEngage() async {
    _getLoggedInUser();
    if (!kIsWeb) {
      setState(() {
        getNotificationCount();
      });
    }
  }

  void _updateCallbackTxt() {
    setState(() {
      callbacksTxt = callbacksTxt;
    });
  }

  void handleMobile() {
    WebEngagePlugin().anonymousActionStream.listen((event) {
      print("MILIND anonymousUserID");
      var anonymousId = event!['anonymousUserID'];
      callbacksTxt = "$callbacksTxt\nanonymousId : $anonymousId";
      _updateCallbackTxt();
    });
    void _onInAppPrepared(Map<String, dynamic>? message) {
      callbacksTxt = "$callbacksTxt\n _onInAppPrepared :";
      _updateCallbackTxt();
    }

    void _onInAppClick(Map<String, dynamic>? message, String? s) {
      var deeplink = WEUtils.getInAppDeeplink(message, s);
      callbacksTxt = "$callbacksTxt\n _onInAppClick : $deeplink";
      _updateCallbackTxt();
    }

    void _onInAppShown(Map<String, dynamic>? message) {
      callbacksTxt = "$callbacksTxt\n _onInAppShown ";
      _updateCallbackTxt();
    }

    void _onInAppDismiss(Map<String, dynamic>? message) {
      callbacksTxt = "$callbacksTxt\n _onInAppDismiss :";
      _updateCallbackTxt();
    }

    WebEngagePlugin().setUpInAppCallbacks(
        _onInAppClick, _onInAppShown, _onInAppDismiss, _onInAppPrepared);

    //push
    WebEngagePlugin().pushStream.listen((event) {
      String? deepLink = event.deepLink;
      Map<String, dynamic>? messagePayload = event.payload;
      callbacksTxt = "$callbacksTxt\n push deeplink : $deepLink";
      _updateCallbackTxt();
    });

    //Push action click listener
    WebEngagePlugin().pushActionStream.listen((event) {
      String? deepLink = event.deepLink;
      Map<String, dynamic>? messagePayload = event.payload;
      callbacksTxt = "$callbacksTxt\n push action deeplink : $deepLink";
      _updateCallbackTxt();
    });
  }

  void handleWeb() {
    WebEngagePlugin.web()?.onWebEngageReady(() {
      WebEngagePlugin.web()?.onSessionStarted(() {
        callbacksTxt = "$callbacksTxt\nonSessionStarted";
        _updateCallbackTxt();
      });

      WebEngagePlugin.web()?.checkPushNotificationSupport((bool) {
        callbacksTxt = "$callbacksTxt\ncheckPushNotificationSupport : $bool";
        _updateCallbackTxt();
      });

      WebEngagePlugin.web()?.checkSubscriptionStatus((bool) {
        callbacksTxt = "$callbacksTxt\ncheckSubscriptionStatus : $bool";
        if (!bool) {
          WebEngagePlugin.web()?.onPushSubscribe(() {
            callbacksTxt = "$callbacksTxt\nonPushSubscribed";
          });
        }
      });

      //Notification **
      WebEngagePlugin.web()
          ?.handleNotificationEvent(WENotificationActionType.onClose, (data) {
        callbacksTxt = "$callbacksTxt\nNotification Close : $data";
        _updateCallbackTxt();
      });
      WebEngagePlugin.web()
          ?.handleNotificationEvent(WENotificationActionType.onOpen, (data) {
        callbacksTxt = "$callbacksTxt\nNotification Open : $data";
        _updateCallbackTxt();
      });
      WebEngagePlugin.web()
          ?.handleNotificationEvent(WENotificationActionType.onClick, (data) {
        callbacksTxt = "$callbacksTxt\nNotification Click : $data";
        _updateCallbackTxt();
      });
      // **

      //
      // WebEngagePlugin.web()?.setOption("webpush.disablePrompt", false);
      // WebEngagePlugin.web()?.setOption("webpush.registerServiceWorker", true);

      //WebPushEvent**
      WebEngagePlugin.web()?.handleWebPushEvent(WEWebPushEvent.onWindowAllowed,
          () {
        callbacksTxt = "$callbacksTxt\n WebPushEvent onWindowAllowed";
        _updateCallbackTxt();
      });

      WebEngagePlugin.web()?.handleWebPushEvent(WEWebPushEvent.onPushRegistered,
          () {
        callbacksTxt = "$callbacksTxt\n WebPushEvent onPushRegistered";
        _updateCallbackTxt();
      });

      WebEngagePlugin.web()
          ?.handleWebPushEvent(WEWebPushEvent.onPushUnregistered, () {
        callbacksTxt = "$callbacksTxt\n WebPushEvent onPushUnregistered";
        _updateCallbackTxt();
      });

      WebEngagePlugin.web()?.handleWebPushEvent(WEWebPushEvent.onWindowDenied,
          () {
        callbacksTxt = "$callbacksTxt\n WebPushEvent onWindowDenied";
        _updateCallbackTxt();
      });

      WebEngagePlugin.web()?.handleWebPushEvent(WEWebPushEvent.onWindowViewed,
          () {
        callbacksTxt = "$callbacksTxt\n WebPushEvent onWindowViewed";
        _updateCallbackTxt();
      });
    });
    //******

    WebEngagePlugin.web()?.handleSurveyEvent(WESurveyEventType.onOpen, (data) {
      callbacksTxt = "$callbacksTxt\n WESurveyEventType onOpen $data";
      _updateCallbackTxt();
    });

    WebEngagePlugin.web()?.handleSurveyEvent(WESurveyEventType.onClose, (data) {
      callbacksTxt = "$callbacksTxt\n WESurveyEventType onClose $data";
      _updateCallbackTxt();
    });

    WebEngagePlugin.web()?.handleSurveyEvent(WESurveyEventType.onComplete,
        (data) {
      callbacksTxt = "$callbacksTxt\n WESurveyEventType onComplete $data";
      _updateCallbackTxt();
    });

    WebEngagePlugin.web()?.handleSurveyEvent(WESurveyEventType.onSubmit,
        (data) {
      callbacksTxt = "$callbacksTxt\n WESurveyEventType onSubmit $data";
      _updateCallbackTxt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("${WEConstants.appName} v1.0.1"),
        actions: [
          ElevatedButton(
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
              style: const TextStyle(
                color: Colors.blueAccent,
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
            const SizedBox(height: 20),
            CustomStyledButton(
              onPressed: () {
                navigateToScreen(context, WEConstants.userProfile);
              },
              label: WEConstants.userProfile,
            ),
            const SizedBox(height: 20),
            CustomStyledButton(
              onPressed: () {
                navigateToScreen(context, WEConstants.events);
              },
              label: WEConstants.events,
            ),
            const SizedBox(height: 20),
            CustomStyledButton(
              onPressed: () {
                navigateToScreen(context, WEConstants.screens);
              },
              label: WEConstants.screens,
            ),
            const SizedBox(height: 20),
            CustomStyledButton(
              onPressed: () {
                navigateToScreen(context, WEConstants.inLine);
              },
              label: WEConstants.inLine,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    callbacksTxt = "";
                  });
                },
                child: const Text(
                  "Clear Logs",
                  style: TextStyle(color: Colors.blue),
                )),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                color: Colors.grey[200],
                child: SingleChildScrollView(
                  child: Center(
                    child: Text("Callbacks : $callbacksTxt"),
                  ),
                ),
              ),
            )
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
          MaterialPageRoute(builder: (context) => const UserProfileScreen()),
        );
        break;
      case WEConstants.events:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EventsScreen()),
        );
        break;
      case WEConstants.screens:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ScreenNavigationScreen()),
        );
        break;
      case WEConstants.inLine:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InLineHomeScreen()),
        );
        break;
      case WEConstants.notificationInbox:
        resetNotificationCount();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationInbox()),
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
          title: const Text(WEConstants.login),
          contentPadding: const EdgeInsets.all(10),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: WEConstants.username),
                  onChanged: (value) {
                    username = value;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: WEConstants.password),
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
              child: const Text('Cancel'),
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
              child: const Text(WEConstants.login),
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
          contentPadding: const EdgeInsets.all(10),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
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
              child: const Text('Logout'),
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
