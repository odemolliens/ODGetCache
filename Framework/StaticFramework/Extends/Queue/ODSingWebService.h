//
//  ODUCWebService.h
//  ODUrlCacheManager
//
//  Created by Olivier Demolliens on 20/05/13.
//  Copyright (c) 2013 Olivier Demolliens. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSSingleton.h"

//Service
#import "ODWebService.h"

@interface ODSingWebService : NSSingleton

+(ODSingWebService *)shared;

-(ODWebService*)webService;

@end
