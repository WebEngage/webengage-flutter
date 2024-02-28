//
//  WEInLineNotificationProtocol.h
//  WebEngage
//
//  Created by Bhavesh Sarwar on 27/07/21.
//  Copyright © 2021 Saumitra R. Bhave. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol InLineNotificationsProtocol <NSObject>
@optional
- (void)propertiesReceived:(NSDictionary *)inLinePropertiesDetails;
- (void)screenNavigatedTo:(NSDictionary *)screenDetails;
@end

NS_ASSUME_NONNULL_END
