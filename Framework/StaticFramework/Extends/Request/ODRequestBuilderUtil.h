//
//  RequestBuilder.h
//  OsTaLgO
//
//  Created by Olivier Demolliens on 22/09/11.
//  Copyright 2011 OsTaLgO. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ODGETCacheRequest.h"

#define POST @"POST"
#define GET @"GET"
#define PUT @"PUT"
#define DELETE @"DELETE"

@interface ODRequestBuilderUtil:NSObject
{
    
}

//Request cached with duration + offlineMode
+(ODGETCacheRequest*)buildGetOrDeleteRequestWithUrl:(NSString*)uri withLogin:(NSString*)login withPassword:(NSString*)password withMode:(NSString*)mode andDuration:(int)duration;

//Request cached
+(ODGETCacheRequest*)buildGetOrDeleteRequestWithUrl:(NSString*)uri withLogin:(NSString*)login withPassword:(NSString*)password withMode:(NSString*)mode andRules:(ODRules*)rules;

//Request GET/DELETE
+(ASIHTTPRequest*)buildGetOrDeleteRequestWithUrl:(NSString*)uri withLogin:(NSString*)login withPassword:(NSString*)password withMode:(NSString*)mode;

//Request POST/PUT
+(ASIFormDataRequest*)buildPostOrPutRequestWithUrl:(NSString*)uri withLogin:(NSString*)login withPassword:(NSString*)password withParams:(NSDictionary*)dict withMode:(NSString*)mode;

//Building new request with existing request
+(ASIHTTPRequest*)retryBuildingRequestGetDelete:(ASIHTTPRequest*)request;
+(ASIFormDataRequest*)retryBuildingRequestPostPut:(ASIFormDataRequest*)request;

//Other stuff
+(NSURL*)buildUrlObject:(NSString*)url;
+(id)setGeneralInformation:(id)request withLogin:(NSString*)login withPassword:(NSString*)password withMode:(NSString*)mode;
+(id)setSecurityParameters:(id)request;
+(id)buildDataRequest:(id)request withParams:(NSDictionary*)dict;
+(NSString *)encodeMy:(NSString *)str;

@end
