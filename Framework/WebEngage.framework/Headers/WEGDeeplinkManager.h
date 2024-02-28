//
//  WEGDeeplinkManager.h
//  WebEngage
//
//  Created by Uzma Sayyed on 19/11/20.
//  Copyright © 2020 Saumitra R. Bhave. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WEG_CUSTOM_DOMAIN             @"com.webengage.custom.domains"

NS_ASSUME_NONNULL_BEGIN

@interface WEGDeeplinkManager : NSObject <NSURLSessionDelegate>

typedef void (^WEGActionBlock)(NSString *);

/**
 @method
 
 @abstract a singleton of WEGDeeplinkManager
 */
+(instancetype)instance;

/**
 * Sets custom domain list for a WebEngage account
 * @param customDomains list of custom domains

 */
- (void)setCustomDomain: (NSArray*)customDomains;


/**
 * Tracks a link click and passes the redirected URL to the callback
 * @param webpageURL the URL that was clicked
 * @param callbackBlock the callback to send after the webpageURL is called
 * @discussion passes the string of the redirected URL to the callback
 */
- (void)getAndTrackDeeplink:(NSURL *)webpageURL callbackBlock:(WEGActionBlock)callbackBlock;

/**
 * Checks if the URL looks like a link rewritten by WebEngage
 * @param url the URL to check
 * @return YES if it looks like a link rewritten by WebEngage, NO otherwise
 */
- (BOOL)isWebEngageDeeplink:(NSURL *)url;


@end

NS_ASSUME_NONNULL_END
