import '../enum/we_notification_events.dart';
import '../enum/we_survey_event.dart';

abstract class WEWeb {
  void onSessionStarted(Function callback);

  void setOption(optionKey, value);

  void setNotificationOption(optionKey, value);

  void setSurveyOption(optionKey, value);

  void onWebEngageReady(Function callback);

  void handleSurveyEvent(WESurveyEventType eventType, callback);

  void handleNotificationEvent(WENotificationActionType eventType, callback);

  void handleWebPushEvent(WEWebPushEvent eventType, Function callback);

  void promptPushNotification();

  void onPushSubscribe(Function callback);

  void checkSubscriptionStatus(Function(bool) callback);

  void checkPushNotificationSupport(Function(bool) callback);
}
