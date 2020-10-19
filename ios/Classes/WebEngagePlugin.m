#import "WebEngagePlugin.h"
#import <WebEngage/WebEngage.h>

@implementation WebEngagePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"webengage_plugin"
            binaryMessenger:[registrar messenger]];
  WebEngagePlugin* instance = [[WebEngagePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"userLogin" isEqualToString:call.method]) {
      [self userLogin:call withResult:result];
  } else if ([@"userLogout" isEqualToString:call.method]) {
      [self userLogout:call withResult:result];
  } else if ([@"setUserFirstName" isEqualToString:call.method]) {
      [self setUserFirstName:call withResult:result];
  } else if ([@"setUserLastName" isEqualToString:call.method]) {
      [self setUserLastName:call withResult:result];
  } else if ([@"setUserEmail" isEqualToString:call.method]) {
      [self setUserEmail:call withResult:result];
  } else if ([@"setUserHashedEmail" isEqualToString:call.method]) {
      [self setUserHashedEmail:call withResult:result];
  } else if ([@"setUserPhone" isEqualToString:call.method]) {
      [self setUserPhone:call withResult:result];
  } else if ([@"setUserHashedPhone" isEqualToString:call.method]) {
      [self setUserHashedPhone:call withResult:result];
  } else if ([@"setUserCompany" isEqualToString:call.method]) {
      [self setUserCompany:call withResult:result];
  } else if ([@"setUserBirthDate" isEqualToString:call.method]) {
      [self setUserBirthDate:call withResult:result];
  } else if ([@"setUserGender" isEqualToString:call.method]) {
      [self setUserGender:call withResult:result];
  } else if ([@"setUserOptIn" isEqualToString:call.method]) {
      [self setUserOptIn:call withResult:result];
  } else if ([@"setUserLocation" isEqualToString:call.method]) {
      [self setUserLocation:call withResult:result];
  } else if ([@"trackEvent" isEqualToString:call.method]) {
      [self trackEvent:call withResult:result];
  } else if ([@"trackScreen" isEqualToString:call.method]) {
      [self trackScreen:call withResult:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void) userLogin:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * userId = call.arguments;
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser login:userId];
}

- (void) userLogout:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser logout];
}

- (void) setUserFirstName:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * firstName = call.arguments;
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser setFirstName:firstName];
}

- (void) setUserLastName:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * lastName = call.arguments;
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser setLastName:lastName];
}

- (void) setUserEmail:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * email = call.arguments;
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser setEmail:email];
}

- (void) setUserHashedEmail:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * hashedEmail = call.arguments;
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser setHashedEmail:hashedEmail];
}

- (void) setUserPhone:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * phone = call.arguments;
    WEGUser* weUser = [WebEngage sharedInstance].user;
    [weUser setPhone:phone];
}

- (void) setUserHashedPhone:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * hashedPhone = call.arguments;
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser setHashedPhone:hashedPhone];
}

- (void) setUserCompany:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * company = call.arguments;
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser setCompany:company];
}

- (void) setUserBirthDate:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * birthDate = call.arguments;
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser setBirthDateString:birthDate];
}

- (void) setUserGender:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * gender = call.arguments;
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser setGender:gender];
}

- (void) setUserOptIn:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * channel = call.arguments[@"channel"];
    NSLocale* locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    NSString* ch = [channel lowercaseStringWithLocale:locale];
    
    BOOL status = call.arguments[@"optIn"];
    
    if ([ch isEqualToString:@"push"]) {
        [[WebEngage sharedInstance].user setOptInStatusForChannel:WEGEngagementChannelPush status:status];
    } else if ([ch isEqualToString:@"sms"]) {
        [[WebEngage sharedInstance].user setOptInStatusForChannel:WEGEngagementChannelSMS status:status];
    } else if ([ch isEqualToString:@"email"]) {
        [[WebEngage sharedInstance].user setOptInStatusForChannel:WEGEngagementChannelEmail status:status];
    } else if ([ch isEqualToString:@"in_app"]) {
        [[WebEngage sharedInstance].user setOptInStatusForChannel:WEGEngagementChannelInApp status:status];
    } else if ([ch isEqualToString:@"whatsapp"]) {
        [[WebEngage sharedInstance].user setOptInStatusForChannel:WEGEngagementChannelWhatsapp status:status];
    } else {
        NSString * msg = [NSString stringWithFormat:@"Invalid channel: %@. Must be one of [push, sms, email, in_app, whatsapp].", ch];
        result([FlutterError errorWithCode:@"WebEngagePlugin" message:msg details:nil]);
    }
}

- (void) setUserLocation:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSNumber * lat = call.arguments[@"lat"];
    NSNumber * lng = call.arguments[@"lng"];
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser setUserLocationWithLatitude:lat andLongitude:lng];
}

- (void) trackEvent:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * eventName = call.arguments[@"eventName"];
    NSDictionary * attributes = call.arguments[@"attributes"];
    id<WEGAnalytics> weAnalytics = [WebEngage sharedInstance].analytics;
    [weAnalytics trackEventWithName:eventName andValue:attributes];
}

- (void) trackScreen:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * screenName = call.arguments[@"screenName"];
    NSDictionary * screenData = call.arguments[@"screenData"];
    id<WEGAnalytics> weAnalytics = [WebEngage sharedInstance].analytics;
    [weAnalytics navigatingToScreenWithName:screenName andData:screenData];
}

@end
