//
//  WEGManualIntegration.h
//  WebEngage
//
//  Created by Yogesh Singh on 16/05/19.
//  Copyright © 2019 Webklipper Technologies Pvt Ltd. All rights reserved.
//

#import <WebEngage/WebEngage.h>
#import <UserNotifications/UserNotifications.h>

@interface WEGManualIntegration : NSObject


/**
 Asks the delegate how to handle a notification that arrived while the app was running in the foreground.
 
 WebEngage uses the `notification` to update push notifications received by the user.
 
 To be implemented if and only if WEGManualIntegration is set to YES in Info.plist.
 
 @param center The shared user notification center object that received the notification.
 @param notification The notification that is about to be delivered.
 @code
 extension AppDelegate: UNUserNotificationCenterDelegate {

     @available(iOS 10.0, *)
     func userNotificationCenter(_ center: UNUserNotificationCenter,
                 willPresent notification: UNNotification,
                     withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

         print("center: ", center, "\nnotification: ", notification)

         WEGManualIntegration.userNotificationCenter(center, willPresent: notification)

         completionHandler([.alert, .badge, .sound])
     }
 }
 @endcode
 */
+ (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification;


/**
 The method will be called on the delegate by iOS when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from application:didFinishLaunchingWithOptions:
 
 WebEngage uses the `response` to update users activity on received push notification.
 
 To be implemented if and only if WEGManualIntegration is set to YES in Info.plist.
 
 @param center The shared user notification center object that received the notification.
 @param response The user’s response to the notification. This object contains the original notification and the identifier string for the selected action.
 @code
 extension AppDelegate: UNUserNotificationCenterDelegate {

     @available(iOS 10.0, *)
     func userNotificationCenter(_ center: UNUserNotificationCenter,
                      didReceive response: UNNotificationResponse,
                    withCompletionHandler completionHandler: @escaping () -> Void) {

         print("center: ", center, " response: ", response)

         WEGManualIntegration.userNotificationCenter(center, didReceive: response)

         completionHandler()
     }
 }
 @endcode
 */
+ (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response;


@end
