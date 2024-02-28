//
//  WEGInlineRendrerHelper.h
//  WebEngage
//
//  Created by Bhavesh Sarwar on 02/02/22.
//  Copyright © 2022 Saumitra R. Bhave. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WEGInlineRendrerHelper : NSObject
+(NSMutableDictionary *)doOpen:(NSDictionary *)notification;
+(NSMutableDictionary *)doClick:(NSDictionary *)notification clickedData:(NSDictionary *)customData;
+(NSMutableDictionary *)doError:(NSDictionary *)notification;
@end

NS_ASSUME_NONNULL_END
