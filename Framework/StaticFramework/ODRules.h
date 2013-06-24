//
//  ODRules.h
//  ODGetCache
//
//  Created by Olivier Demolliens on 06/06/13.
//  Copyright (c) 2013 VW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIDownloadCache.h"

@interface ODRules : NSObject
{
    
    /* Cache Policy */
    bool doNotReadFromCache;
    bool doNotWriteToCache;
    bool askServerIfModifiedWhenStale;
    bool askServerIfModified;
    bool onlyLoadIfNotCached;
    bool fallbackToCacheIfLoadFails;
    /* Storage Policy */
    bool keepOnlyDuringSession;
    
    int duration;
    
    bool shouldRespectCacheControlHeaders;
}

@property(nonatomic,assign)bool doNotReadFromCache;
@property(nonatomic,assign)bool doNotWriteToCache;
@property(nonatomic,assign)bool askServerIfModifiedWhenStale;
@property(nonatomic,assign)bool askServerIfModified;
@property(nonatomic,assign)bool onlyLoadIfNotCached;
@property(nonatomic,assign)bool fallbackToCacheIfLoadFails;

@property(nonatomic,assign)bool keepOnlyDuringSession;

@property(nonatomic,assign)int duration;

@property(nonatomic,assign)bool shouldRespectCacheControlHeaders;

+(ODRules*)defaultRules;
+(ODRules*)noCacheRules;
+(ODRules*)reloadOnlyIfStaledWithDuration:(int)duration;
+(ODRules*)alwaysAskServer;
+(ODRules*)reloadOnlyIfStaledAndKeepOnlyDuringSessionWithDuration:(int)duration;
+(ODRules*)alwaysAskServerAndKeepOnlyDuringSession;

@end
