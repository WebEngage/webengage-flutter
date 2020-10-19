
# WebEngage Flutter

WebEngage Flutter Plugin.

## Installation

**1. Add WebEngage Flutter Plugin**

Add webengage_plugin in your `pubspec.yaml` file.

```yml
dependencies:
  webengage_plugin:
    git:
      url: https://github.com/WebEngage/webengage-flutter.git
```

## Initialization

**1. Initialize WebEngage**

### For Android

1. Add WebEngage configurations in `<your-project>/android/app/src/main/AndroidManifest.xml` file.
```xml
<manifest ...>
    <application
        ...
        android:name=".MainApplication"
        android:allowBackup="false">

        <meta-data android:name="com.webengage.sdk.android.key" android:value="YOUR-WEBENGAGE-LICENSE-CODE" />

        <meta-data android:name="com.webengage.sdk.android.debug" android:value="true" />
        ...
    </application>
</manifest>
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
        registerActivityLifecycleCallbacks(new WebEngageActivityLifeCycleCallbacks(this));
        ...
    }
    ...
}
```

### For iOS

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

## Track Users

```dart
import 'package:webengage_plugin/webengage_plugin.dart';
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
```

## Track Events
```dart
import 'package:webengage_plugin/webengage_plugin.dart';
...
    // Track simple event
      WebEngagePlugin.trackEvent('Added to Cart');

      // Track event with attributes
      WebEngagePlugin.trackEvent('Order Placed', {'Amount': 808.48});
```

## Push Notifications

### Push Notifications For Android

TODO

### Push Notifications For iOS

TODO

### Push Notification Callbacks

TODO

## In-app Notifications

### Track Screens
```dart
import 'package:webengage_plugin/webengage_plugin.dart';
...
    // Track screen
    WebEngagePlugin.trackScreen('Home Page');

    // Track screen with data
    WebEngagePlugin.trackScreen('Product Page', {'Product Id': 'UHUH799'});
```

### In-app Notification Callbacks

TODO
