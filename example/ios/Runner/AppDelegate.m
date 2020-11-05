#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <WebEngage/WebEngage.h>

@implementation AppDelegate

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

@end
