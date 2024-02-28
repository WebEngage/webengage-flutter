//
//  WebEngage.h
//  WebEngage
//
//  Copyright (c) 2015 Webklipper Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEGUser.h"
#import "WEGAnalytics.h"
#import "WEGAppDelegate.h"
#import "WEGMobileBridge.h"
#import "WEGManualIntegration.h"
#import "WEGInAppNotificationProtocol.h"
#import "WEGDeeplinkManager.h"
#import "WEInLineNotificationProtocol.h"
#import "WEGInlineRendrerHelper.h"


FOUNDATION_EXPORT double WebEngageVersionNumber;
FOUNDATION_EXPORT const unsigned char WebEngageVersionString[];


/// This enum represents level of accuracy for tracking user's location.
typedef NS_ENUM(NSInteger, WEGLocationAccuracy){
    
    /// Uses the highest level of accuracy. Recommended for real time location tracking, as it requires more time and more power.
    WEGLocationAccuracyBest = 1,
    
    
    /// Accurate to the nearest kilometer. Recommended for city level location tracking, consumes less power.
    WEGLocationAccuracyForCity = 2,
    
    
    /// Accurate to the nearest kilometer. Recommended for country level location tracking, consumes less power.
    WEGLocationAccuracyForCountry = 3,
    
    
    /// Disables location tracking in WebEngage SDK. With this value, WebEngage will neither track any user location nor update it on dashboard.
    WEGLocationAccuracyDisable = 4
};



/**
 *  This is an umbrella header for WebEngage SDK. This facade will provide the app with all the features of WebEngage.
 */
@interface WebEngage : NSObject


/**
 *  Get an instance of WEGUser which provide different APIs for user identification and user level attributes.
 *
 *  @warning Application must initialize the SDK first by calling application:didFinishLaunchingWithOptions: or one
 *  of its overloads before accessing this property.
 */
@property (nonatomic, readonly) WEGUser *user;

/**
 *  Get an instance of NSMutableDictionary which provide the version of sdk-meta.
 *
 *  @warning Application must initialize the SDK first by calling application:didFinishLaunchingWithOptions: or one
 *  of its overloads before accessing this property.
 */
@property (nonatomic, weak, readwrite) NSMutableDictionary *WEGVersions;


/**
 *  Get an instance of WEGAnalytics which provide different APIs for event tracking and analytics.
 *  
 *  @warning Application must initialize the SDK first by calling application:didFinishLaunchingWithOptions: or one of its overloads before accessing this property.
 */
@property (nonatomic, readonly) id<WEGAnalytics> analytics;


/**
 *  A reference to an implementation of WEGAppDelegate protocol.
 *  
 * @warning SDK keeps only a week reference to notificationDelegate, its application's responsibility to maintain the ownership of this class and keep it in memory.
*/
@property (nonatomic, weak, readwrite) id<WEGAppDelegate> pushNotificationDelegate;

/**
 *  Set this property to set custom timeout for a session. If the time spent by the app in background session is less it's value, the SDK will not a new visitor session
 *
 * @warning Application must initialize the SDK first by calling application:didFinishLaunchingWithOptions: or one of its overloads before accessing this property.
*/
@property (nonatomic, readwrite) long sessionTimeOut;

/**
*  Get an instance of WEGDeeplinkManager which provides APIs for handling and tracking universal links
*
*  @warning Application must initialize the SDK first by calling application:didFinishLaunchingWithOptions: or one
*  of its overloads before accessing this property.
*/
@property (nonatomic, readonly) WEGDeeplinkManager *deeplinkManager;

/**
 *  This value indicates that the SDK has been successfully initialised.
 *
 *  @warning Application must initialize the SDK first by calling application:didFinishLaunchingWithOptions: or one of its overloads before accessing this property.
 */
@property (nonatomic, readonly) BOOL isEngaged;
/**
 *  This value indicates that the SDK has using base URL.
 */
@property (nonatomic) NSString* baseUrl;

/**
 *  Provides access to a Single Managed Instance of WebEngage.
 *
 *  @return A Single Global WebEngage object.
 *  
 *  @warning Application should use only this method to get an instance of WebEngage and never call alloc or init on
 *  the class.
 */
+ (instancetype)sharedInstance;


/**
 *  Initialize the SDK after validating the Info Plist WebEngage keys. App can access user or analytics after calling this method. This must be called from application delegate's application:didFinishLaunchingWithOptions: method (hence the same selector name) and preferably as the last statement of implementation.
 *
 *  @param application   The instance of application received in UIApplicationDelegate's callback.
 *  @param launchOptions The launchOptions dictionary received in UIApplicationDelegate's callback.
 *
 *  @return YES if the initialization was successful and SDK is ready to use. NO otherwise
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;


/**
 *  Initialize the SDK after validating the Info Plist WebEngage keys. App can access user or analytics after calling this method. This must be called from application delegate's application:didFinishLaunchingWithOptions: method (hence the same selector name) and preferably as the last statement of implementation.
 *
 *  @param application The instance of application received in UIApplicationDelegate's callback.
 *  @param launchOptions The launchOptions dictionary received in UIApplicationDelegate's callback.
 *  @param apnRegister   If SDK should register for Push Notifications automatically after setup is complete, pass NO if app wants to perform registration on its own, for Eg. after showing some UI to the user.
 *
 *  @return YES if the initialization was successful and SDK is ready to use. NO otherwise
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions autoRegister:(BOOL)apnRegister;


/**
 *  Initialize the SDK after validating the Info Plist WebEngage keys. App can access user or analytics after calling this method. This must be called from application delegate's application:didFinishLaunchingWithOptions: method (hence the same selector name) and preferably as the last statement of implementation.
 *
 *  @param application The instance of application received in UIApplicationDelegate's callback.
 *  @param launchOptions        The launchOptions dictionary received in UIApplicationDelegate's callback.
 *  @param notificationDelegate A reference to an implementation of WEGInAppNotificationProtocol. @warning SDK keeps only a week reference to notificationDelegate, its application's responsibility to maintain the ownership of this class and keep it in memory.
 *
 *  @return YES if the initialization was successful and SDK is ready to use. NO otherwise
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions notificationDelegate:(id<WEGInAppNotificationProtocol>)notificationDelegate;


/**
 *  Initialize the SDK after validating the Info Plist WebEngage keys. App can access user or analytics after calling this method. This must be called from application delegate's application:didFinishLaunchingWithOptions: method (hence the same selector name) and preferably as the last statement of implementation.
 *
 *  @param application The instance of application received in UIApplicationDelegate's callback.
 *  @param launchOptions        The launchOptions dictionary received in UIApplicationDelegate's callback.
 *  @param notificationDelegate A reference to an implementation of WEGInAppNotificationProtocol. @warning SDK keeps only a week reference to notificationDelegate, its application's responsibility to maintain the ownership of this class and keep it in memory.
 *  @param apnRegister          If SDK should register for Push Notifications automatically after setup is complete, pass NO if app wants to perform registration on its own, for Eg. after showing some UI to the user.
 *
 *  @return YES if the initialization was successful and SDK is ready to use. NO otherwise
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions notificationDelegate:(id<WEGInAppNotificationProtocol>)notificationDelegate autoRegister:(BOOL)apnRegister;

/**
 *  Initialize the SDK with the given License code. App can access user or analytics after calling this method. This must be called from application delegate's application:didFinishLaunchingWithOptions: method (hence the same selector name) and preferably as the last statement of implementation.
 *
 *  @param application   The instance of application received in UIApplicationDelegate's callback.
 *  @param launchOptions The launchOptions dictionary received in UIApplicationDelegate's callback.
 *  @param licenseCode The license code for your WebEngage account, that you can copy from the WebEngage dashboard.
 *
 *  @return YES if the initialization was successful and SDK is ready to use. NO otherwise
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions setLicenseCode:(NSString *)licenseCode;

/**
 *  Initialize the SDK with the given License code. App can access user or analytics after calling this method. This must be called from application delegate's application:didFinishLaunchingWithOptions: method (hence the same selector name) and preferably as the last statement of implementation.
 *
 *  @param application   The instance of application received in UIApplicationDelegate's callback.
 *  @param launchOptions The launchOptions dictionary received in UIApplicationDelegate's callback.
 *  @param notificationDelegate A reference to an implementation of WEGInAppNotificationProtocol. @warning SDK keeps only a week reference to notificationDelegate, its application's responsibility to maintain the ownership of this class and keep it in memory.
 *  @param apnRegister          If SDK should register for Push Notifications automatically after setup is complete, pass NO if app wants to perform registration on its own, for Eg. after showing some UI to the user.
 *  @param licenseCode The license code for your WebEngage account, that you can copy from the WebEngage dashboard.
 *
 *  @return YES if the initialization was successful and SDK is ready to use. NO otherwise
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions notificationDelegate:(id<WEGInAppNotificationProtocol>)notificationDelegate autoRegister:(BOOL)apnRegister setLicenseCode:(NSString *)licenseCode;

/**
 *  Enable or disable user location tracking in WebEngage SDK.
 *  Calling this method after initializing the SDK will force every launch of your app to track location with the given accuracy.
 *  If this method is not called then the SDK will track user location only if your app has permission to read location, with accuracy WEGLocationAccuracyForCity.
 *  If your app does not have permission to read location, SDK will not track any location.
 *  @param accuracy Accepts WEGLocationAccuracy Enum values. It sets the location accuracy to the given value.
    If WEGLocationAccuracyDisable is passed, WebEngage will stop tracking user's location, however you can manage location updates by using setUserLocationWithLatitude:andLongitude on user profile.
 */
- (void)autoTrackUserLocationWithAccuracy:(WEGLocationAccuracy)accuracy;


-(void)setInLineDelegates:(id <InLineNotificationsProtocol>)object;

@end
