import '../enum/notification_event_type.dart';
import '../enum/survey_event_type.dart';

abstract class WEWeb {
  void onSessionStarted(Function callback);

  void setOption(optionKey, value);

  void setNotificationOption(optionKey, value);

  void setSurveyOption(optionKey, value);

  void onWebEngageReady(Function callback);

  void handleSurveyEvent(SurveyEventType eventType, callback);

  void handleNotificationEvent(NotificationEventType eventType, callback);

  void handleWebPushEvent(WebPushEventType eventType, Function callback);

  void promptPushNotification();

  void onPushSubscribe(Function callback);

  void checkSubscriptionStatus(Function(bool) callback);

  void checkPushNotificationSupport(Function(bool) callback);
}
