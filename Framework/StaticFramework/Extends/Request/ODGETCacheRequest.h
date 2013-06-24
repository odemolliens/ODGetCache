//
//  ODGETCacheRequest.h
//  ODGetCache
//
//  Created by Olivier Demolliens on 06/06/13.
//  Copyright (c) 2013 VW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ODRules.h"

@interface ODGETCacheRequest : ASIHTTPRequest
{
  
}

- (id)initWithRules:(ODRules*)rules;
+ (id)requestWithURL:(NSURL *)newURL andRules:(ODRules*)rules;
+ (id)requestWithURL:(NSURL *)newURL withCacheDuration:(int)duration;

@end
