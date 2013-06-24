//
//  RequestBuilder.m
//  OsTaLgO
//
//  Created by Olivier Demolliens on 22/09/11.
//  Copyright 2011 OsTaLgO. All rights reserved.
//


#import "ODRequestBuilderUtil.h"

#define NSRequestBuilderLog(fmt, ...)  //NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

@implementation ODRequestBuilderUtil


+(ODGETCacheRequest*)buildGetOrDeleteRequestWithUrl:(NSString*)uri withLogin:(NSString*)login withPassword:(NSString*)password withMode:(NSString*)mode andDuration:(int)duration
{
    NSAssert(([mode isEqualToString:GET] || [mode isEqualToString:DELETE]), @"Can't use this method for this mode");
    
    ODGETCacheRequest* request = [ODGETCacheRequest requestWithURL:[self buildUrlObject:[self encodeMy:uri]]withCacheDuration:duration ];
    request = [self setGeneralInformation:request withLogin:login withPassword:password withMode:mode];
    
    NSRequestBuilderLog(@"requestUrl:%@",[self encodeMy:uri]);
    NSRequestBuilderLog(@"login:%@",login);
    NSRequestBuilderLog(@"pwd:%@",password);
    
    request = [self setSecurityParameters:request];
    
    return request;
}

+(ODGETCacheRequest*)buildGetOrDeleteRequestWithUrl:(NSString*)uri withLogin:(NSString*)login withPassword:(NSString*)password withMode:(NSString*)mode andRules:(ODRules*)rules
{
    NSAssert(([mode isEqualToString:GET] || [mode isEqualToString:DELETE]), @"Can't use this method for this mode");
    
    ODGETCacheRequest* request = [ODGETCacheRequest requestWithURL:[self buildUrlObject:[self encodeMy:uri]] andRules:rules];
    request = [self setGeneralInformation:request withLogin:login withPassword:password withMode:mode];
    
    NSRequestBuilderLog(@"requestUrl:%@",[self encodeMy:uri]);
    NSRequestBuilderLog(@"login:%@",login);
    NSRequestBuilderLog(@"pwd:%@",password);
    
    request = [self setSecurityParameters:request];
    
    return request;
}

+(ASIHTTPRequest*)buildGetOrDeleteRequestWithUrl:(NSString*)uri withLogin:(NSString*)login withPassword:(NSString*)password withMode:(NSString*)mode
{
    
    NSAssert(([mode isEqualToString:GET] || [mode isEqualToString:DELETE]), @"Can't use this method for this mode");
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[self buildUrlObject:[self encodeMy:uri]]];
    request = [self setGeneralInformation:request withLogin:login withPassword:password withMode:mode];
    
    NSRequestBuilderLog(@"requestUrl:%@",[self encodeMy:uri]);
    NSRequestBuilderLog(@"login:%@",login);
    NSRequestBuilderLog(@"pwd:%@",password);
    
    request = [self setSecurityParameters:request];
    
    return request;
}

+(ASIFormDataRequest*)buildPostOrPutRequestWithUrl:(NSString*)uri withLogin:(NSString*)login withPassword:(NSString*)password withParams:(NSDictionary*)dict withMode:(NSString*)mode
{
    
    NSAssert(([mode isEqualToString:POST] || [mode isEqualToString:PUT]), @"Can't use this method for this mode");
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[self buildUrlObject:[self encodeMy:uri]]];
    request = [self setGeneralInformation:request withLogin:login withPassword:password withMode:mode];
    
    NSRequestBuilderLog(@"requestUrl:%@",[self encodeMy:uri]);
    NSRequestBuilderLog(@"login:%@",login);
    NSRequestBuilderLog(@"pwd:%@",password);
    
    request = [self buildDataRequest:request withParams:dict];
    request = [self setSecurityParameters:request];
    
    return request;
    
}

+(ASIHTTPRequest*)retryBuildingRequestGetDelete:(ASIHTTPRequest*)request
{
    NSRequestBuilderLog(@"rebuild ASIHTTPRequest request:%@",[[request url]absoluteString]);
    
    ASIHTTPRequest* newRequest = [self buildGetOrDeleteRequestWithUrl:[[request url]absoluteString] withLogin:[request username] withPassword:[request password] withMode:[request requestMethod]];
    [request release];
    return newRequest;
}

+(ASIFormDataRequest*)retryBuildingRequestPostPut:(ASIFormDataRequest*)request
{
    NSRequestBuilderLog(@"rebuild ASIFormDataRequest request:%@",[[request url]absoluteString]);
    
    ASIFormDataRequest* newRequest = [self buildPostOrPutRequestWithUrl:[[request url]absoluteString] withLogin:[request username] withPassword:[request password] withParams:nil withMode:[request requestMethod]];
    [newRequest setPostData:[request postData]];
    [request release];
    
    return newRequest;
}

+(NSURL*)buildUrlObject:(NSString*)url
{
    NSAssert(![url isEqualToString:@""],@"url can't be empty");
    
    return [NSURL URLWithString:url];
}

+(id)setGeneralInformation:(id)request withLogin:(NSString*)login withPassword:(NSString*)password withMode:(NSString*)mode
{
    NSAssert(([request isKindOfClass:[ASIHTTPRequest class]] || [request isKindOfClass:[ASIFormDataRequest class]]), @"Can't use this method for this type of object");
    
    [request setUsername:login];
    [request setPassword:password];
    [request setRequestMethod:mode];
    
    return request;
}


+(id)setSecurityParameters:(id)request
{
    [request setAuthenticationScheme:@"Basic"];
    [request setUseSessionPersistence:YES];
    [request setUseCookiePersistence:YES];
    [request setPersistentConnectionTimeoutSeconds:15.0];
    
    if([[request requestMethod] isEqualToString:GET])
    {
        [request setNumberOfTimesToRetryOnTimeout:3];
    }
    
    return request;
}

+(id)buildDataRequest:(id)request withParams:(NSDictionary*)dict
{
    NSEnumerator *enumerator ;
	id key;
	enumerator = [dict keyEnumerator];
    
    while ((key = [enumerator nextObject])) {
        NSRequestBuilderLog(@"PUT/POST:%@",[[dict objectForKey:key]JSONString]);
       // [request setPostValue:[[dict objectForKey:key]JSONString] forKey:[NSString stringWithFormat:@"%@",key]];
    }
    
    return request;
}

+(NSString *)encodeMy:(NSString *)str
{
    NSMutableString *uri_mut = [NSMutableString stringWithString:str];
    
    [uri_mut stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    str = (NSString*)uri_mut;
    return str;
}

@end
