//
//  WEGInAppNotificationProtocol.h
//  WebEngage
//
//  Copyright (c) 2015 Webklipper Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 In order to use In-app notification message callbacks, your application must define a class which implements the WEGInAppNotificationProtocol
 
 Set conforming class as the notification callback delegate during SDK initialization using one of following APIs:
 
 @code
 WebEngage.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions, notificationDelegate: self)
 
 // OR
 
 WebEngage.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions, notificationDelegate: self, autoRegister: true)
 
 @endcode
 
 @remarks Read more at https://docs.webengage.com/docs/ios-callbacks
 
 */
@protocol WEGInAppNotificationProtocol <NSObject>
@optional

/**
 In-App Notification Prepared callback gets triggered before the in-app message is shown to your users.
 
 It allows you to customize the UI, colors, CTAs (buttons) and content of the In-app message received from WebEngage before displaying it to your users.

 Delegate callback will be invoked on an arbitary background queue, so if required perform any UIKit- related operations by enqueuing on main queue
 
 @param inAppNotificationData In-App Notification Message Data used for rendering the message
 @param stopRendering Assigning the value of stopRendering to YES will not render the notification for the users
 @return You can modify the In-App Notification Message Data which will then be used for rendering the message
 */
- (NSDictionary *)notificationPrepared:(NSDictionary<NSString *, id> *)inAppNotificationData shouldStop:(BOOL *)stopRendering;


/**
 In-App Notification Shown callback gets triggered after the notification is shown.

 Delegate callback will be invoked on main queue.
 
 @param inAppNotificationData In-App Notification Message Data used for rendering the message
 */
- (void)notificationShown:(NSDictionary<NSString *, id> *)inAppNotificationData;


/**
 In-App Notification Clicked callback gets triggered when the user clicks the call to action button on the notification.

 Delegate callback will be invoked on main queue.
 
 @param inAppNotificationData In-App Notification Message Data used for rendering the message
 @param actionId The ID of the button which is clicked. You can look up the button IDs in the inAppNotificationData dictionary.
 */
- (void)notification:(NSDictionary<NSString *, id> *)inAppNotificationData clickedWithAction:(NSString *)actionId;


/**
 In-App Notification Dismissed callback gets triggered when the user dismisses the notification.
 
 Delegate callback will be invoked on main queue.

 @param inAppNotificationData In-App Notification Message Data used for rendering the message
 */
- (void)notificationDismissed:(NSDictionary<NSString *, id> *)inAppNotificationData;

@end
