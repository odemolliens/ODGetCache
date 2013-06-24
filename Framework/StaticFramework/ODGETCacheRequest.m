//
//  ODGETCacheRequest.m
//  ODGetCache
//
//  Created by Olivier Demolliens on 06/06/13.
//  Copyright (c) 2013 VW. All rights reserved.
//

#import "ODGETCacheRequest.h"
#define INT_OBJ(x) [NSNumber numberWithInt:x]

@interface ODGETCacheRequest()
-(void)addParameters:(ODRules*)rules;

@end

@implementation ODGETCacheRequest

- (id)initWithRules:(ODRules*)rules
{
    self = [super init];
    if (self) {
        [self addParameters:rules];
    }
    return self;
}

+ (id)requestWithURL:(NSURL *)newURL andRules:(ODRules*)rules
{
    ODGETCacheRequest *request = [[[self alloc] initWithURL:newURL] autorelease];
    [request addParameters:rules];
    return request;
}

+ (id)requestWithURL:(NSURL *)newURL withCacheDuration:(int)duration
{
    ODGETCacheRequest *request = [[[self alloc] initWithURL:newURL] autorelease];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setSecondsToCache:duration];
    return request;
}

-(void)addParameters:(ODRules*)rules
{
    NSMutableArray *arrayParameters = [[NSMutableArray alloc]init];
    
    if ([rules doNotReadFromCache]) {
        [arrayParameters addObject:INT_OBJ(ASIDoNotReadFromCacheCachePolicy)];
    }
    
    if ([rules doNotWriteToCache]) {
        [arrayParameters addObject:INT_OBJ(ASIDoNotWriteToCacheCachePolicy)];
    }
    
    if ([rules askServerIfModified]) {
        [arrayParameters addObject:INT_OBJ(ASIAskServerIfModifiedCachePolicy)];
    }
    
    if ([rules askServerIfModifiedWhenStale]) {
        [arrayParameters addObject:INT_OBJ(ASIAskServerIfModifiedWhenStaleCachePolicy)];
    }
    
    if ([rules onlyLoadIfNotCached]) {
        [arrayParameters addObject:INT_OBJ(ASIOnlyLoadIfNotCachedCachePolicy)];
    }
    
    if ([rules fallbackToCacheIfLoadFails]) {
        [arrayParameters addObject:INT_OBJ(ASIFallbackToCacheIfLoadFailsCachePolicy)];
    }
    
    if ([arrayParameters count]>0) {
        int combo = 0;
        
        for (NSNumber *box in arrayParameters) {
            combo |= [box intValue];
        }
        
        [self setCachePolicy:combo];
    }
   
    
    if ([rules keepOnlyDuringSession]) {
        [self setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
    }else{
        [self setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    }
    
    if ([rules duration]!=-1) {
        [self setSecondsToCache:[rules duration]];
    }
    
    [arrayParameters release];
    
    [self setDownloadCache:[ASIDownloadCache sharedCache]];
    
    if ([rules shouldRespectCacheControlHeaders]) {
        [[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:YES];
    }else{
        [[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
    }
}


@end
