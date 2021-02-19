#import <Flutter/Flutter.h>
#import <WebEngage/WebEngage.h>

@interface WebEngagePlugin : NSObject<FlutterPlugin,WEGAppDelegate,WEGInAppNotificationProtocol>
- (void)trackDeeplinkURLCallback:(NSString *)redirectLocationURL;
@end
