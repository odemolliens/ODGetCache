//
//  ODUCWebService.m
//  ODUrlCacheManager
//
//  Created by Olivier Demolliens on 20/05/13.
//  Copyright (c) 2013 Olivier Demolliens. All rights reserved.
//

#import "ODSingWebService.h"


@interface ODSingWebService ()

@property (nonatomic, retain)ODWebService *webService;

@end

@implementation ODSingWebService

@synthesize webService;

-(void)dealloc
{
    //
    // ConfSingleton cleanup
    //
    if ([self webService]) {
        [[self webService] release];
    }
    
    [super dealloc];
    
}

-(id)init
{
    id _self_ = [super init];
    
    if (_self_ != nil) {
        self = _self_;
        [self setWebService:[[[ODWebService alloc]initForRequests]autorelease]];
    }
    
    return (_self_);
}

+(ODSingWebService *)shared
{
    return (ODSingWebService *)[super sharedInstance];
}

-(ODWebService*)webService
{
    return webService;
}

@end
