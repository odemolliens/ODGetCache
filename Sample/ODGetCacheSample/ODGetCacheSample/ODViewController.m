//
//  ODViewController.m
//  ODGetCacheSample
//
//  Created by Olivier Demolliens on 09/06/13.
//  Copyright (c) 2013 Olivier Demolliens. All rights reserved.
//

#import "ODViewController.h"

//Request builder
#import <ODGetCache-iOS/ODRequestBuilderUtil.h>

//Request
#import <ODGetCache-iOS/ODGETCacheRequest.h>

@interface ODViewController ()

@end

@implementation ODViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Init Queue
    [[[ODSingWebService shared]webService]setDelegate:self];
    [[[ODSingWebService shared]webService]launchNetworkOperations];
    
    //ODUrlCacheRequestBuilder build
    ODGETCacheRequest *rQ =[ODRequestBuilderUtil buildGetOrDeleteRequestWithUrl:@"http://www.earthtools.org/timezone-1.1/40.71417/-74.00639" withLogin:@"" withPassword:@"" withMode:@"GET" andDuration:10];
    
    [rQ setDelegate:self];
    
    [[[ODSingWebService shared]webService]doNetworkOperation:rQ];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    BOOL success = [request didUseCachedResponse];
    NSLog(@"------------>>>>>>> Success is %@\n", (success ? @"YES" : @"NO"));
    NSLog(@"download finished:%@",[request responseString]);
}

-(void)requestError:(ASIHTTPRequest *)request
{
    BOOL success = [request didUseCachedResponse];
    NSLog(@"------------>>>>>>> Success is %@\n", (success ? @"YES" : @"NO"));
    NSLog(@"requestError finished");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[ODSingWebService shared]release];
    [super dealloc];
}

@end
