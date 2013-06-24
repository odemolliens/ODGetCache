//
//  ODRules.m
//  ODGetCache
//
//  Created by Olivier Demolliens on 06/06/13.
//  Copyright (c) 2013 VW. All rights reserved.
//

#import "ODRules.h"

@implementation ODRules

@synthesize doNotReadFromCache;
@synthesize doNotWriteToCache;
@synthesize askServerIfModifiedWhenStale;
@synthesize askServerIfModified;
@synthesize onlyLoadIfNotCached;
@synthesize fallbackToCacheIfLoadFails;

@synthesize keepOnlyDuringSession;

@synthesize duration;

@synthesize shouldRespectCacheControlHeaders;

+(ODRules*)rules
{
    return [[[ODRules alloc]init]autorelease];
}

+(ODRules*)defaultRules
{
    ODRules *rules = [self rules];
    //Parameters
    [rules setDoNotReadFromCache:NO];
    [rules setDoNotWriteToCache:NO];
    [rules setKeepOnlyDuringSession:NO];
    [rules setAskServerIfModifiedWhenStale:NO];
    [rules setAskServerIfModified:NO];
    [rules setFallbackToCacheIfLoadFails:YES];
    [rules setDuration:-1];
    [rules setShouldRespectCacheControlHeaders:YES];
    //
    return rules;
}

+(ODRules*)noCacheRules
{
    ODRules *rules = [self rules];
    //Parameters
    [rules setDoNotReadFromCache:YES];
    [rules setDoNotWriteToCache:YES];
    [rules setKeepOnlyDuringSession:YES];
    [rules setAskServerIfModifiedWhenStale:NO];
    [rules setAskServerIfModified:NO];
    [rules setFallbackToCacheIfLoadFails:YES];
    [rules setDuration:-1];
    [rules setShouldRespectCacheControlHeaders:YES];
    //
    return rules;
}

+(ODRules*)reloadOnlyIfStaledWithDuration:(int)duration
{
    ODRules *rules = [self rules];
    //Parameters
    [rules setDoNotReadFromCache:YES];
    [rules setDoNotWriteToCache:YES];
    [rules setKeepOnlyDuringSession:NO];
    [rules setAskServerIfModifiedWhenStale:YES];
    [rules setAskServerIfModified:NO];
    [rules setFallbackToCacheIfLoadFails:YES];
    [rules setDuration:duration];
    [rules setOnlyLoadIfNotCached:YES];
    [rules setShouldRespectCacheControlHeaders:NO];
    //
    return rules;
}

+(ODRules*)alwaysAskServer
{
    ODRules *rules = [self rules];
    //Parameters
    [rules setDoNotReadFromCache:YES];
    [rules setDoNotWriteToCache:YES];
    [rules setKeepOnlyDuringSession:NO];
    [rules setAskServerIfModifiedWhenStale:NO];
    [rules setAskServerIfModified:YES];
    [rules setFallbackToCacheIfLoadFails:YES];
    [rules setShouldRespectCacheControlHeaders:NO];
    [rules setDuration:-1];
    
    //
    return rules;
}

+(ODRules*)reloadOnlyIfStaledAndKeepOnlyDuringSessionWithDuration:(int)duration
{
    ODRules *rules = [self rules];
    //Parameters
    [rules setDoNotReadFromCache:YES];
    [rules setDoNotWriteToCache:YES];
    [rules setKeepOnlyDuringSession:YES];
    [rules setAskServerIfModifiedWhenStale:YES];
    [rules setAskServerIfModified:NO];
    [rules setFallbackToCacheIfLoadFails:YES];
    [rules setShouldRespectCacheControlHeaders:NO];
    [rules setDuration:duration];
    //
    return rules;
}

+(ODRules*)alwaysAskServerAndKeepOnlyDuringSession
{
    ODRules *rules = [self rules];
    //Parameters
    [rules setDoNotReadFromCache:YES];
    [rules setDoNotWriteToCache:YES];
    [rules setKeepOnlyDuringSession:YES];
    [rules setAskServerIfModifiedWhenStale:NO];
    [rules setAskServerIfModified:YES];
    [rules setFallbackToCacheIfLoadFails:YES];
    [rules setShouldRespectCacheControlHeaders:NO];
    [rules setDuration:-1];
    //
    return rules;
}

@end
