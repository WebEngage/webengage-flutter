#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <WebEngage/WebEngage.h>

@implementation AppDelegate

FlutterMethodChannel *channel;
#define WEBENGAGE_PLUGIN  @"webengage_flutter"
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    
    self.bridge = [WebEngagePlugin new];
    //Set in-app notification callbacks while initialising WebEngage SDK
    [[WebEngage sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions notificationDelegate:self.bridge];
    //Set push notiification click callback
    [WebEngage sharedInstance].pushNotificationDelegate = self.bridge;
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    [[[WebEngage sharedInstance] deeplinkManager] getAndTrackDeeplink:userActivity.webpageURL callbackBlock:^(id location){
        NSLog(@"Location Received:: %@", location);
        [self.bridge trackDeeplinkURLCallback:location];
    }];
    return YES;
}
@end
