#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <WebEngage/WebEngage.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  
    [[WebEngage sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
