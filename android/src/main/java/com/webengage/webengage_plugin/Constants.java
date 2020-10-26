package com.webengage.webengage_plugin;

public interface Constants {

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
    String METHOD_NAME_TRACK_EVENT = "trackEvent";
    String METHOD_NAME_TRACK_SCREEN = "trackScreen";

    String METHOD_NAME_SET_USER_ATTRIBUTE_TIMESTAMP = "setUserAttributeTimestamp";
    String METHOD_NAME_SET_APP_STATUS = "setAppStatus";
    String METHOD_NAME_SHOW_IN_APP = "showInApp";
    String METHOD_NAME_LOGOUT = "logout";
    String METHOD_NAME_PUSH_TOKEN = "pushToken";
    String METHOD_NAME_PUSH_PAYLOAD = "pushPayload";

    String METHOD_NAME_ON_PUSH_CLICK = "onPushClick";
    String METHOD_NAME_ON_INAPP_SHOWN = "onInAppShown";
    String METHOD_NAME_ON_INAPP_CLICKED = "onInAppClick";

    String PARAM_PLATFORM = "platform";
    String PARAM_PAYLOAD = "payload";
    String PARAM_CAMPAIGN_ID = "campaignId";
    String PARAM_SCREEN_NAME = "screenName";
    String PARAM_DEEP_LINK = "deepLinkUrl";
    String PARAM_KEY_VALUE_PAIR = "kvPairs";
    String PARAM_PLATFORM_VALUE = "android";

    String INTEGRATION_TYPE = "flutter";
}
