// Copyright 2020 WebEngage
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License, which can be
// found in the LICENSE file.

#import "WebEngagePlugin.h"
#import <WebEngage/WebEngage.h>
#import "WebEngageConstants.h"

static FlutterMethodChannel* channel = nil;
NSString * const WEGPluginVersion = @"2.0.0-beta.1";
NSString * const DATE_FORMAT = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
int const DATE_FORMAT_LENGTH = 24;

@implementation WebEngagePlugin

NSString *_anonymousId = @"";

static WebEngagePlugin *_shared = nil;

+(WebEngagePlugin *)shared {
    @synchronized([WebEngagePlugin class]) {
        if (!_shared)
          _shared = [[self alloc] init];
        return _shared;
    }
    return nil;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    WebEngagePlugin* instance = [WebEngagePlugin shared];
    if(channel == nil){
        channel = [FlutterMethodChannel methodChannelWithName:WEBENGAGE_PLUGIN binaryMessenger:[registrar messenger]];
        [registrar addMethodCallDelegate:instance channel:channel];
    }
    [instance initialiseWEGVersions];
    [instance registerSDKSecurityCallback];
}

- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar{
    channel = nil;
}

- (void) handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([METHOD_NAME_GET_PLATFORM_VERSION isEqualToString:call.method]) {
        result([PARAM_PLATFORM_VALUE stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([METHOD_NAME_SET_USER_LOGIN isEqualToString:call.method]) {
        [self userLogin:call withResult:result];   
    } else if ([METHOD_NAME_SET_USER_LOGIN_WITH_SECURE_TOKEN isEqualToString:call.method]) {
        [self userLoginWithSecureToken:call withResult:result];
    }else if ([METHOD_NAME_SET_SECURE_TOKEN isEqualToString:call.method]) {
        [self setSecureToken:call withResult:result];
    } else if ([METHOD_NAME_SET_USER_LOGOUT isEqualToString:call.method]) {
        [self userLogout:call withResult:result];
    } else if ([METHOD_NAME_SET_USER_FIRST_NAME isEqualToString:call.method]) {
        [self setUserFirstName:call withResult:result];
    } else if ([METHOD_NAME_SET_USER_LAST_NAME isEqualToString:call.method]) {
        [self setUserLastName:call withResult:result];
    } else if ([METHOD_NAME_SET_USER_EMAIL isEqualToString:call.method]) {
        [self setUserEmail:call withResult:result];
    } else if ([METHOD_NAME_SET_USER_HASHED_EMAIL isEqualToString:call.method]) {
        [self setUserHashedEmail:call withResult:result];
    } else if ([METHOD_NAME_SET_USER_PHONE isEqualToString:call.method]) {
        [self setUserPhone:call withResult:result];
    } else if ([METHOD_NAME_SET_USER_HASHED_PHONE isEqualToString:call.method]) {
        [self setUserHashedPhone:call withResult:result];
    } else if ([METHOD_NAME_SET_USER_COMPANY isEqualToString:call.method]) {
        [self setUserCompany:call withResult:result];
    } else if ([METHOD_NAME_SET_USER_BIRTHDATE isEqualToString:call.method]) {
        [self setUserBirthDate:call withResult:result];
    } else if ([METHOD_NAME_SET_USER_GENDER isEqualToString:call.method]) {
        [self setUserGender:call withResult:result];
    } else if ([METHOD_NAME_SET_USER_OPT_IN isEqualToString:call.method]) {
        [self setUserOptIn:call withResult:result];
    } else if ([METHOD_NAME_SET_USER_LOCATION isEqualToString:call.method]) {
        [self setUserLocation:call withResult:result];
    } else if ([METHOD_NAME_TRACK_EVENT isEqualToString:call.method]) {
        [self trackEvent:call withResult:result];
    } else if ([METHOD_NAME_TRACK_SCREEN isEqualToString:call.method]) {
        [self trackScreen:call withResult:result];
    }else if ([METHOD_NAME_SET_USER_ATTRIBUTE isEqualToString:call.method]) {
        [self setUserAttribute:call withResult:result];
    }else if ([METHOD_NAME_SET_USER_MAP_ATTRIBUTE isEqualToString:call.method]) {
        [self setUserAttributes:call withResult:result];
    } else if ([METHOD_NAME_INITIALISE isEqualToString:call.method]) {
        NSDictionary *payload = @{@"anonymousUserID":_anonymousId};
        [channel invokeMethod:METHOD_NAME_ON_ANONYMOUS_ID_CHANGED arguments:payload];
        result(nil);
        NSLog(@"METHOD_NAME_INITIALISE");
    } else {
        result(FlutterMethodNotImplemented);
        return;
    }
}

- (void) initialisePlugin:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * userId = call.arguments;
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser login:userId];
    result(nil);
}

- (void) registerSDKSecurityCallback{
    [WEGJWTManager shared].tokenInvalidatedCallback = ^{
            NSLog(@"webengageBridge: JWT Token is Invalid. Please send valid ");
            NSDictionary *data = @{
                @"errorResponse" : @"401"
            };
            [channel invokeMethod:METHOD_NAME_ON_TOKEN_INVALIDATED arguments:data];
        };
}

- (void) userLogin:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * userId = call.arguments;
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser login:userId];
    result(nil);
}

- (void) userLoginWithSecureToken:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * userId = call.arguments[USERID];
    NSString * jwtToken = call.arguments[JWTTOKEN];
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser login:userId jwtToken:jwtToken];
    result(nil);
}

- (void) setSecureToken:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * userId = call.arguments[USERID];
    NSString * jwtToken = call.arguments[JWTTOKEN];
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser setSecureToken:userId jwtToken:jwtToken];
    result(nil);
}

- (void) userLogout:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser logout];
    result(nil);
}

- (void) setUserFirstName:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * firstName = call.arguments;
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser setFirstName:firstName];
    result(nil);
}

- (void) setUserLastName:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * lastName = call.arguments;
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser setLastName:lastName];
    result(nil);
}

- (void) setUserEmail:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * email = call.arguments;
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser setEmail:email];
    result(nil);
}

- (void) setUserHashedEmail:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * hashedEmail = call.arguments;
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser setHashedEmail:hashedEmail];
    result(nil);
}

- (void) setUserPhone:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * phone = call.arguments;
    WEGUser* weUser = [WebEngage sharedInstance].user;
    [weUser setPhone:phone];
    result(nil);
}

- (void) setUserHashedPhone:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * hashedPhone = call.arguments;
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser setHashedPhone:hashedPhone];
    result(nil);
}

- (void) setUserCompany:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * company = call.arguments;
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser setCompany:company];
    result(nil);
}

- (void) setUserBirthDate:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * birthDate = call.arguments;
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser setBirthDateString:birthDate];
    result(nil);
}

- (void) setUserGender:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * gender = call.arguments;
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser setGender:gender];
    result(nil);
}

- (void) setUserOptIn:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * channel = call.arguments[CHANNEL];
    NSLocale* locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    NSString* ch = [channel lowercaseStringWithLocale:locale];

    BOOL status = [call.arguments[OPTIN] boolValue];

    if ([ch isEqualToString:PUSH]) {
        [[WebEngage sharedInstance].user setOptInStatusForChannel:WEGEngagementChannelPush status:status];
    } else if ([ch isEqualToString:SMS]) {
        [[WebEngage sharedInstance].user setOptInStatusForChannel:WEGEngagementChannelSMS status:status];
    } else if ([ch isEqualToString:EMAIL]) {
        [[WebEngage sharedInstance].user setOptInStatusForChannel:WEGEngagementChannelEmail status:status];
    } else if ([ch isEqualToString:IN_APP]) {
        [[WebEngage sharedInstance].user setOptInStatusForChannel:WEGEngagementChannelInApp status:status];
    } else if ([ch isEqualToString:WHATSAPP]) {
        [[WebEngage sharedInstance].user setOptInStatusForChannel:WEGEngagementChannelWhatsapp status:status];
    }else if ([ch isEqualToString:VIBER]) {
             [[WebEngage sharedInstance].user setOptInStatusForChannel:WEGEngagementChannelViber status:status];
    } else {
        NSString * msg = [NSString stringWithFormat:@"Invalid channel: %@. Must be one of [push, sms, email, in_app, whatsapp].", ch];
        result([FlutterError errorWithCode:@"WebEngagePlugin" message:msg details:nil]);
        return;
    }
    result(nil);
}

- (void) setUserLocation:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSNumber * lat = call.arguments[LAT];
    NSNumber * lng = call.arguments[LNG];
    WEGUser * weUser = [WebEngage sharedInstance].user;
    [weUser setUserLocationWithLatitude:lat andLongitude:lng];
    result(nil);
}

- (void) trackEvent:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * eventName = call.arguments[EVENT_NAME];
    NSDictionary * attributes = call.arguments[ATTRIBUTES];
    id<WEGAnalytics> weAnalytics = [WebEngage sharedInstance].analytics;
    if (attributes && ![attributes isKindOfClass:[NSNull class]]) {
        [weAnalytics trackEventWithName:eventName andValue:attributes];
    }
    else{
        [weAnalytics trackEventWithName:eventName];
    }
    result(nil);
}

- (void) trackScreen:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString * screenName = call.arguments[SCREEN_NAME];
    NSDictionary * screenData = call.arguments[SCREEN_DATA];
    id<WEGAnalytics> weAnalytics = [WebEngage sharedInstance].analytics;
    if (screenData && ![screenData isKindOfClass:[NSNull class]]) {
        [weAnalytics navigatingToScreenWithName:screenName andData:screenData];
    }
    else{
        [weAnalytics navigatingToScreenWithName:screenName];
    }
    result(nil);
}

- (void) setUserAttribute:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString* attributeName = call.arguments[ATTRIBUTE_NAME];
    id value = call.arguments[ATTRIBUTES];
    [self setUserAttribute:attributeName withValue:value];
    result(nil);
}

- (void) setUserAttributes:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    id _dictionary = call.arguments[ATTRIBUTES];
    if ([_dictionary isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = (NSDictionary *)_dictionary;

        for (NSString *attributeName in dictionary) {
            id value = [dictionary objectForKey:attributeName];
            [self setUserAttribute:attributeName withValue:value];
        }
    }
    result(nil);

}

- (void)setUserAttribute:(NSString *)attributeName withValue:(id)value {
    if ([value isKindOfClass:[NSString class]]) {
        if ([value length] == DATE_FORMAT_LENGTH) {
            NSDate *date = [self getDate:value];
            if (date != nil) {
                [[WebEngage sharedInstance].user setAttribute:attributeName withDateValue:date];
            } else {
                [[WebEngage sharedInstance].user setAttribute:attributeName withStringValue:value];
            }
        } else {
            [[WebEngage sharedInstance].user setAttribute:attributeName withStringValue:value];
        }
    } else if ([value isKindOfClass:[NSNumber class]]) {
        [[WebEngage sharedInstance].user setAttribute:attributeName withValue:value];
    } else if ([value isKindOfClass:[NSArray class]]) {
        [[WebEngage sharedInstance].user setAttribute:attributeName withArrayValue:value];
    } else if ([value isKindOfClass:[NSDate class]]) {
        [[WebEngage sharedInstance].user setAttribute:attributeName withDateValue:value];
    }
}

- (NSDate *)getDate:(NSString *)strValue {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMAT];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate * date = [dateFormatter dateFromString:strValue];
    return date;
}

-(void)WEGHandleDeeplink:(NSString *)deeplink userData:(NSDictionary *)data{
    //Support for backward compatibility -start

    NSDictionary *payload = @{@"deeplink":deeplink,@"data":data};
    [channel invokeMethod:METHOD_NAME_ON_PUSH_CLICK arguments:payload];
    // -end

    if (data && [data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *splitCustomData = [self splitCustomDataFromArray:data[@"customData"]];
        NSDictionary *advancePayload = @{PARAM_PLATFORM:@"iOS",PARAM_PAYLOAD:@{@"data": splitCustomData ?: [NSNull null],@"deeplink": deeplink ?: [NSNull null]}};
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [channel invokeMethod:METHOD_NAME_OPTIMIZED_ON_PUSH_CLICK arguments:advancePayload];
        });

       // [channel invokeMethod:METHOD_NAME_OPTIMIZED_ON_PUSH_CLICK arguments:advancePayload];
    } else {
        NSLog(@"Error: userData is nil or not a dictionary");
    }
}

- (NSDictionary *)splitCustomDataFromArray:(NSArray *)customData {
    NSMutableDictionary *customDataDictionary = [NSMutableDictionary dictionary];

    for (NSDictionary *customItem in customData) {
        NSString *key = customItem[@"key"];
        id value = customItem[@"value"];

        // Check if key is not nil and value is not nil
        if (key && value) {
            // Use the value if it's not nil, otherwise use an empty string
            NSString *safeValue = (value != nil) ? value : @"";
            customDataDictionary[key] = safeValue;
        }
    }

    return [customDataDictionary copy];
}


-(NSDictionary *)notificationPrepared:(NSDictionary<NSString *,id> *)inAppNotificationData shouldStop:(BOOL *)stopRendering{
    [channel invokeMethod:METHOD_NAME_ON_INAPP_PREPARED arguments:inAppNotificationData];
    return inAppNotificationData;
}

-(void)notificationShown:(NSDictionary<NSString *,id> *)inAppNotificationData{
    [channel invokeMethod:METHOD_NAME_ON_INAPP_SHOWN arguments:inAppNotificationData];
}

-(void)notificationDismissed:(NSDictionary<NSString *,id> *)inAppNotificationData{
    [channel invokeMethod:METHOD_NAME_ON_INAPP_DISMISS arguments:inAppNotificationData];
}

-(void)notification:(NSMutableDictionary<NSString *,id> *)inAppNotificationData clickedWithAction:(NSString *)actionId{
    [inAppNotificationData setObject:actionId forKey:@"selectedActionId"];
    [channel invokeMethod:METHOD_NAME_ON_INAPP_CLICKED arguments:inAppNotificationData];
}

- (void)trackDeeplinkURLCallback:(NSString *)redirectLocationURL {
   // NSLog(@"trackDeeplinkURLCallback %@", redirectLocationURL);
    [channel invokeMethod:METHOD_TRACK_DEEPLINK_URL arguments:redirectLocationURL];
}

- (void)didReceiveAnonymousID:(NSString *)anonymousID forReason:(WEGReason)reason {
        _anonymousId = anonymousID;
        NSDictionary *payload = @{@"anonymousUserID":anonymousID};
        [channel invokeMethod:METHOD_NAME_ON_ANONYMOUS_ID_CHANGED arguments:payload];
}

 - (void) initialiseWEGVersions {
    WegVersionKey key = WegVersionKeyFL;
    [[WebEngage sharedInstance] setVersionForChildSDK:WEGPluginVersion forKey:key];;
 }

@end
