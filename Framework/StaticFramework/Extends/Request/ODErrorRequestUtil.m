//
//  ErrorRequestUtil.m
//  OsTaLgO
//
//  Created by Olivier Demolliens on 22/09/11.
//  Copyright 2011 OsTaLgO. All rights reserved.
//

#import "ODErrorRequestUtil.h"

@implementation ODErrorRequestUtil


+(NSString*)errorMessage:(NSUInteger)codeResponse
{
    switch (codeResponse) {
        case 0:
            return @"0";
        case 206:
            return @"206 - Partial Content";
            break;
        case 302:
            return @"302";
            break;
        case 401:
            return @"401";
        case 402:
            return @"402";
            break;
        case 403:
            return @"403";
            break;
        case 404:
            return @"404";
            break;
        case 415:
            return @"415";
            break;
        case 499:
            return @"499";
            break;
        case 500:
            return @"500";
            break;
        default:
            NSAssert(1+1==3, @"Error Code undefinissed:%i",codeResponse);
            return nil;
            break;
    }
}

@end