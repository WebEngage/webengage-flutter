import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AppFirebaseService{

  static token(){
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
      print("App testing firebase token : $fcmToken");
    })
        .onError((err) {
      print("App testing firebase token error : $err}");
    });
  }

  static autoEnable() async {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
  }

  static void listenMessages(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('App testing firebase Got a message whilst in the foreground!');
      print('App testing firebase Message data: ${message.data}');

      if (message.notification != null) {
        print('App testing firebase Message also contained a notification: ${message.notification}');
      }
    });
  }



  static void backgroundHandler(){
   // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }


}