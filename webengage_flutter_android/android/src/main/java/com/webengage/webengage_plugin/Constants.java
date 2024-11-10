// Copyright 2020 WebEngage
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License, which can be
// found in the LICENSE file.

package com.webengage.webengage_plugin;

public interface Constants {
     String WEBENGAGE_PLUGIN = "webengage_flutter";

    interface MethodName {
        String METHOD_NAME_INITIALISE = "initialise";
        String METHOD_NAME_SET_USER_LOGIN = "userLogin";
        String METHOD_NAME_SET_USER_LOGOUT = "userLogout";
        String METHOD_NAME_SET_USER_FIRST_NAME = "setUserFirstName";
        String METHOD_NAME_SET_USER_LAST_NAME = "setUserLastName";
        String METHOD_NAME_SET_USER_EMAIL = "setUserEmail";
        String METHOD_NAME_SET_USER_HASHED_EMAIL = "setUserHashedEmail";
        String METHOD_NAME_SET_USER_PHONE = "setUserPhone";
        String METHOD_NAME_SET_USER_HASHED_PHONE = "setUserHashedPhone";
        String METHOD_NAME_SET_USER_COMPANY = "setUserCompany";
        String METHOD_NAME_SET_USER_BIRTHDATE = "setUserBirthDate";
        String METHOD_NAME_SET_USER_GENDER = "setUserGender";
        String METHOD_NAME_SET_USER_OPT_IN = "setUserOptIn";
        String METHOD_NAME_SET_USER_LOCATION = "setUserLocation";
        String METHOD_NAME_SET_USER_ATTRIBUTE = "setUserAttribute";
        String METHOD_NAME_SET_USER_STRING_ATTRIBUTE = "setUserStringAttribute";
        String METHOD_NAME_SET_USER_INT_ATTRIBUTE = "setUserIntAttribute";
        String METHOD_NAME_SET_USER_DOUBLE_ATTRIBUTE = "setUserDoubleAttribute";
        String METHOD_NAME_SET_USER_BOOL_ATTRIBUTE = "setUserBoolAttribute";
        String METHOD_NAME_SET_USER_DATE_ATTRIBUTE = "setUserDateAttribute";
        String METHOD_NAME_SET_USER_LIST_ATTRIBUTE = "setUserListAttribute";
        String METHOD_NAME_SET_USER_MAP_ATTRIBUTE = "setUserMapAttribute";
        String METHOD_NAME_TRACK_EVENT = "trackEvent";
        String METHOD_NAME_TRACK_SCREEN = "trackScreen";
        String METHOD_NAME_ON_PUSH_CLICK = "onPushClick";
        String METHOD_NAME_ON_PUSH_ACTION_CLICK = "onPushActionClick";
        String METHOD_NAME_ON_INAPP_SHOWN = "onInAppShown";
        String METHOD_NAME_ON_INAPP_CLICKED = "onInAppClick";
        String METHOD_NAME_ON_INAPP_DISMISS = "onInAppDismiss";
        String METHOD_NAME_ON_INAPP_PREPARED = "onInAppPrepared";
        String METHOD_NAME_SET_USER_DEVICE_PUSH_OPT_IN = "setDevicePushOptIn";
        String METHOD_NAME_ON_ANONYMOUS_ID_CHANGED = "onAnonymousIdChanged";
        String METHOD_NAME_START_GAID_TRACKING = "startGAIDTracking";
        String METHOD_NAME_ON_TOKEN_INVALIDATED = "onTokenInvalidated";
        String METHOD_NAME_SET_USER_LOGIN_WITH_SECURE_TOKEN = "userLoginWithSecureToken";
        String METHOD_NAME_SET_SECURE_TOKEN = "setSecureToken";

        String METHOD_NAME_ON_PUSH_CLICK_V2 = "onPushClickV2";
        String METHOD_NAME_ON_PUSH_ACTION_CLICK_V2 = "onPushActionClickV2";
     }

    interface PARAM {
        String PARAM_PLATFORM = "platform";
        String PARAM_PAYLOAD = "payload";
        String PARAM_PLATFORM_VALUE = "android";
    }

    public interface ARGS {
        String CHANNEL = "channel";
        String OPTIN = "optIn";
        String LAT = "lat";
        String LNG = "lng";
        String EVENT_NAME = "eventName";
        String ATTRIBUTES = "attributes";
        String ATTRIBUTE_NAME = "attributeName";
        String SCREEN_NAME = "screenName";
        String SCREEN_DATA = "screenData";
        String MALE = "male";
        String FEMALE = "female";
        String OTHER = "other";
        String PUSH = "push";
        String SMS = "sms";
        String IN_APP = "in_app";
        String EMAIL = "email";
        String WHATSAPP = "whatsapp";
        String VIBER = "viber";
        String SELECTED_ACTION_ID = "selectedActionId";
        String ANONYMOUS_USER_ID = "anonymousUserID";
        String USER_ID = "userIdentifier";
        String SECURE_TOKEN = "secureToken";
    }

}
