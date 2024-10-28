// Copyright 2020 WebEngage
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License, which can be
// found in the LICENSE file.
//
//  WebEngageConstants.h
//  Runner
//
//  Created by Uzma Sayyed on 03/11/20.
//

#ifndef WebEngageConstants_h
#define WebEngageConstants_h

#define WEBENGAGE_PLUGIN  @"webengage_flutter"

#define METHOD_NAME_INITIALISE  @"initialise"
#define METHOD_NAME_GET_PLATFORM_VERSION @"getPlatformVersion"
#define METHOD_NAME_SET_USER_LOGIN  @"userLogin"
#define METHOD_NAME_SET_USER_LOGIN_WITH_SECURE_TOKEN  @"userLoginWithSecureToken"
#define METHOD_NAME_SET_SECURE_TOKEN  @"setSecureToken"
#define METHOD_NAME_SET_USER_LOGOUT  @"userLogout"
#define METHOD_NAME_SET_USER_FIRST_NAME  @"setUserFirstName"
#define METHOD_NAME_SET_USER_LAST_NAME  @"setUserLastName"
#define METHOD_NAME_SET_USER_EMAIL  @"setUserEmail"
#define METHOD_NAME_SET_USER_HASHED_EMAIL  @"setUserHashedEmail"
#define METHOD_NAME_SET_USER_PHONE  @"setUserPhone"
#define METHOD_NAME_SET_USER_HASHED_PHONE  @"setUserHashedPhone"
#define METHOD_NAME_SET_USER_COMPANY  @"setUserCompany"
#define METHOD_NAME_SET_USER_BIRTHDATE  @"setUserBirthDate"
#define METHOD_NAME_SET_USER_GENDER  @"setUserGender"
#define METHOD_NAME_SET_USER_OPT_IN  @"setUserOptIn"
#define METHOD_NAME_SET_USER_LOCATION  @"setUserLocation"
#define METHOD_NAME_TRACK_EVENT  @"trackEvent"
#define METHOD_NAME_TRACK_SCREEN  @"trackScreen"
#define METHOD_NAME_SET_USER_ATTRIBUTE @"setUserAttribute"
#define METHOD_NAME_SET_USER_MAP_ATTRIBUTE @"setUserMapAttribute"

#define METHOD_NAME_ON_PUSH_CLICK @"onPushClick"
#define METHOD_NAME_ON_INAPP_SHOWN @"onInAppShown"
#define METHOD_NAME_ON_INAPP_CLICKED @"onInAppClick"
#define METHOD_NAME_ON_INAPP_DISMISS @"onInAppDismiss"
#define METHOD_NAME_ON_INAPP_PREPARED @"onInAppPrepared"
#define METHOD_NAME_ON_ANONYMOUS_ID_CHANGED @"onAnonymousIdChanged"
#define PARAM_PLATFORM @"platform"
#define PARAM_PAYLOAD @"payload"
#define PARAM_PLATFORM_VALUE @"iOS"
#define METHOD_NAME_ON_TOKEN_INVALIDATED @"onTokenInvalidated"

#define CHANNEL @"channel"
#define OPTIN @"optIn"
#define LAT @"lat"
#define LNG @"lng"
#define EVENT_NAME @"eventName"
#define ATTRIBUTES @"attributes"
#define ATTRIBUTE_NAME @"attributeName"
#define SCREEN_NAME @"screenName"
#define SCREEN_DATA @"screenData"
#define MALE @"male"
#define FEMALE @"female"
#define OTHER @"other"
#define PUSH @"push"
#define SMS @"sms"
#define IN_APP @"in_app"
#define EMAIL @"email"
#define WHATSAPP @"whatsapp"
#define VIBER @"viber"
#define ANONYMOUS_USER_ID @"anonymousUserID"
#define REASON @"reason"

#define METHOD_TRACK_DEEPLINK_URL@"onTrackDeeplinkURL"

#define USERID @"userIdentifier"
#define JWTTOKEN @"secureToken"

#endif /* WebEngageConstants_h */
