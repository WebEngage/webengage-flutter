# WebEngage Flutter SDK

For more information checkout our [website](https://webengage.com/) and [documentation](https://docs.webengage.com/docs).

## Installation

**Add WebEngage Flutter Plugin**

- Add webengage_flutter in your `pubspec.yaml` file.
```yml
dependencies:
webengage_flutter: 1.0.1
```
- Run `flutter packages get` to install the SDK

## Initialization

### Android
1. Initialize WebEngage in main.dart in initState();
```dart
WebEngagePlugin _webEngagePlugin = new WebEngagePlugin();
```
2.  Initialize WebEngage Android SDK in your `<your-project>/android/app/src/main/java/<your-package-path>/MainApplication.java` class.
```java
...
import com.webengage.sdk.android.WebEngageActivityLifeCycleCallbacks;
import io.flutter.app.FlutterApplication;

public class MainApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
         WebEngageConfig webEngageConfig = new WebEngageConfig.Builder()
                .setWebEngageKey("YOUR_LICENCSE_CODE")
                .setAutoGCMRegistrationFlag(false)
                .setLocationTrackingStrategy(LocationTrackingStrategy.ACCURACY_BEST)
                .setDebugMode(true) // only in development mode
                .build();
        WebengageInitializer.initialize(this,webEngageConfig);
        ...
    }
    ...
}
```

#### Push Notifications

1. Add below dependencies in app-level build gradle
```groovy
    implementation platform('com.google.firebase:firebase-bom:25.12.0')
    implementation 'com.google.firebase:firebase-analytics'
    implementation 'com.google.firebase:firebase-messaging:20.2.1'
    implementation 'com.google.android.gms:play-services-ads:15.0.1'
```
2. Add the following to your dependencies section in project/build.gradle
```groovy
        classpath 'com.google.gms:google-services:4.3.4'
```
3. Firebase tokens can be passed to WebEngage using FirebaseMessagingService
 ```java
import com.google.firebase.messaging.FirebaseMessagingService;
import com.webengage.sdk.android.WebEngage;

public class MyFirebaseMessagingService extends FirebaseMessagingService {
    @Override
    public void onNewToken(String s) {
        super.onNewToken(s);
        WebEngage.get().setRegistrationID(s);
    }
}
```
It is also recommended that you pass Firebase token to WebEngage from onCreate of your Application class as shown below. This will ensure that changes in user’s Firebase token are communicated to WebEngage.
```java
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.iid.FirebaseInstanceId;
import com.google.firebase.iid.InstanceIdResult;
import com.webengage.sdk.android.WebEngage;

public class MainApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
    FirebaseMessaging.getInstance().getToken()
    .addOnCompleteListener(new OnCompleteListener<String>() {
        @Override
        public void onComplete(@NonNull Task<String> task) {
          if (!task.isSuccessful()) {
            Log.w(TAG, "Fetching FCM registration token failed", task.getException());
            return;
          }
          // Get new FCM registration token
          String token = task.getResult();
          WebEngage.get().setRegistrationID(token);
        }
    });
     
    }
}
```
4. Pass Messages to WebEngage
Create a class that extends FirebaseMessagingService and pass messages to WebEngage.
All incoming messages from WebEngage will contain key source with the value as webengage.
```java
package your.application.package;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import com.webengage.sdk.android.WebEngage;

public class MyFirebaseMessagingService extends FirebaseMessagingService {
  @Override
  public void onMessageReceived(RemoteMessage remoteMessage) {
    Map<String, String> data = remoteMessage.getData();
    if(data != null) {
      if(data.containsKey("source") && "webengage".equals(data.get("source"))) {
        WebEngage.get().receive(data);
      }
    }
  }
}
```
Next, register the service to the application element of your AndroidManifest.xml as follows.
```xml
<service
    android:name=".MyFirebaseMessagingService">
    <intent-filter>
        <action android:name="com.google.firebase.MESSAGING_EVENT"/>
    </intent-filter>
</service>
```

### iOS

1. Add WebEngage configurations `<your-project>/ios/<YourApp>/Info.plist` file.
```
<dict>
	<key>WEGLicenseCode</key>
	<string>YOUR-WEBENGAGE-LICENSE-CODE</string>

	<key>WEGLogLevel</key>
	<string>VERBOSE</string>
    ...
</dict>
```

2. Initialize WebEngage iOS SDK in `<your-project>/ios/<YourApp>/AppDelegate.m` file.
```objectivec
#import <WebEngage/WebEngage.h>
...

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary * launchOptions {
    ...
  
    [[WebEngage sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
```

#### Push Notifications
**Push Notification Callbacks**

1. Add Below code in AppDelegate.h file

```
  #import <WebEngagePlugin.h>
  
  @property (nonatomic, strong) WebEngagePlugin *bridge;
```
2. Add Below code in AppDelegate.m file

```
    self.bridge = [WebEngagePlugin new];
    //For setting push click callback set pushNotificationDelegate after webengage SDK is initialised
    
    [[WebEngage sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions notificationDelegate:self.bridge];
    [WebEngage sharedInstance].pushNotificationDelegate = self.bridge;
```

3. Add below subscribeToPushCallbacks() method in main.dart and call it from initMethod()
```dart
  void subscribeToPushCallbacks() {
      //Push click stream listener
      _webEngagePlugin.pushStream.listen((event) {
        String deepLink = event.deepLink;
        Map<String, dynamic> messagePayload = event.payload;
      });

      //Push action click listener
      _webEngagePlugin.pushActionStream.listen((event) {
        print("pushActionStream:" + event.toString());
        String deepLink = event.deepLink;
        Map<String, dynamic> messagePayload = event.payload;
      });
  }
```

4. Add below code in dispose() of the main.dart
```dart
  //Close the streams in dispose()
  @override
  void dispose() {
    _webEngagePlugin.pushSink.close();
    _webEngagePlugin.pushActionSink.close();
    super.dispose();
  }
```

**Universal Link**
1. Add Below code in AppDelegate.m file
```
  - (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
  [[[WebEngage sharedInstance] deeplinkManager] getAndTrackDeeplink:userActivity.webpageURL callbackBlock:^(id location){
    [self.bridge trackDeeplinkURLCallback:location];
  }];
  return YES;
}
```

2. Add below subscribeToTrackUniversalLink() method in main.dart and call it from initMethod()
```
 void subscribeToTrackUniversalLink() {
    _webEngagePlugin.trackDeeplinkStream.listen((location) {
      print("trackDeeplinkStream: " + location);
    });
  }
```

3. Add below code in dispose() of the main.dart
```dart
  //Close the streams in dispose()
  @override
  void dispose() {
    _webEngagePlugin.trackDeeplinkURLStreamSink.close();
    super.dispose();
  }
```
## Track Users

```dart
import 'package:webengage_flutter/webengage_flutter.dart';
...
    // User login
    WebEngagePlugin.userLogin('3254');

    // User logout
    WebEngagePlugin.userLogout();

    // Set user first name
    WebEngagePlugin.setUserFirstName('John');

    // Set user last name
    WebEngagePlugin.setUserLastName('Doe');

    // Set user email
    WebEngagePlugin.setUserEmail('john.doe@gmail.com');

    // Set user hashed email
    WebEngagePlugin.setUserHashedEmail('144e0424883546e07dcd727057fd3b62');

    // Set user phone number
    WebEngagePlugin.setUserPhone('+551155256325');

    // Set user hashed phone number
    WebEngagePlugin.setUserHashedPhone('e0ec043b3f9e198ec09041687e4d4e8d');

    // Set user company
    WebEngagePlugin.setUserCompany('WebEngage');

    // Set user birth-date, supported format: 'yyyy-MM-dd'
    WebEngagePlugin.setUserBirthDate('1994-05-24');

    // Set user gender, allowed values are ['male', 'female', 'other']
    WebEngagePlugin.setUserGender('male');

    // Set user channel opt-in status
    WebEngagePlugin.setUserOptIn('in_app', false);

    // Set user location
    WebEngagePlugin.setUserLocation(19.25, 72.45);

    // Set User Attribute with  String value
    WebEngagePlugin.setUserAttribute("twitterusename", "saurav12994");

    // Set User Attribute with  Boolean value
    WebEngagePlugin.setUserAttribute("Subscribed to email", true);

    // Set User Attribute with  Integer value
    WebEngagePlugin.setUserAttribute("Points earned", 2626);

    // Set User Attribute with  Double value
    WebEngagePlugin.setUserAttribute("Dollar Spent", 123.44);

    // Set User Attribute with  Map value
    var details = {'Usrname':'tom','Passiword':'pass@123'};
    WebEngagePlugin.setUserAttributes(details);
```

## Track Events
```dart
import 'package:webengage_flutter/webengage_flutter.dart';
...
    // Track simple event
      WebEngagePlugin.trackEvent('Added to Cart');

      // Track event with attributes
      WebEngagePlugin.trackEvent('Order Placed', {'Amount': 808.48});
```

## In-app Notifications

### Track Screens
```dart
import 'package:webengage_flutter/webengage_flutter.dart';
...
    // Track screen
    WebEngagePlugin.trackScreen('Home Page');

    // Track screen with data
    WebEngagePlugin.trackScreen('Product Page', {'Product Id': 'UHUH799'});
```

### In-app Notification Callbacks

1. Add Below code in AppDelegate.h file

```
  #import <WebEngagePlugin.h>
  
  @property (nonatomic, strong) WebEngagePlugin *bridge;
```
2. Add Below code in AppDelegate.m file

``` 
    self.bridge = [WebEngagePlugin new];
    //For setting in-app click callback set notificationDelegate while initialising WebEngage SDK
    
    [[WebEngage sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions notificationDelegate:self.bridge];
```
3. Add Below Method in main.dart
```dart
 void _onInAppPrepared(Map<String, dynamic> message) {
    print("This is a inapp Prepated callback from native to flutter. Payload " +
        message.toString());
  }
  void _onInAppClick(Map<String, dynamic> message,String s) {
    print("This is a inapp click callback from native to flutter. Payload " +
        message.toString());

  }

  void _onInAppShown(Map<String, dynamic> message) {
    print("This is a callback on inapp shown from native to flutter. Payload " +
        message.toString());
  }

  void _onInAppDismiss(Map<String, dynamic> message) {
    print("This is a callback on inapp dismiss from native to flutter. Payload " +
        message.toString());
  }
````
4. Add Below code inside initmethod() in main.dart
```dart
_webEngagePlugin.setUpInAppCallbacks(
        _onInAppClick, _onInAppShown, _onInAppDismiss, _onInAppPrepared);
```


## More Info
- Checkout the [Sample main.dart](https://github.com/WebEngage/webengage-flutter/blob/development_flutter_sdk/example/lib/main.dart) for the sample application.
- Checkout the [developer documentation](https://docs.webengage.com/docs)

## Questions?
Reach out to our [Support Team](https://webengage.com/) for further assistance.

## Plugin info
[WebEngage Flutter SDK](https://pub.dev/packages/webengage_flutter)
