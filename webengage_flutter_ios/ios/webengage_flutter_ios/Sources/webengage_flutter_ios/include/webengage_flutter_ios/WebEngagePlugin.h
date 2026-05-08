// Copyright 2020 WebEngage
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License, which can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <WebEngage/WebEngage.h>

@interface WebEngagePlugin : NSObject<FlutterPlugin,WEGAppDelegate,WEGInAppNotificationProtocol>
- (void)trackDeeplinkURLCallback:(NSString *)redirectLocationURL;
- (void)initialiseWEGVersions;
- (void)registerSDKSecurityCallback;
@end
