//
//  WebService.h
//  Wort
//
//  Created by Olivier Demolliens on 06/11/12.
//  Copyright (c) 2012 neopixl. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "ODErrorRequestUtil.h"

@protocol WebServiceDelegate <NSObject>

-(void)requestFinished:(ASIHTTPRequest *)request;
-(void)requestError:(ASIHTTPRequest *)request;
-(void)requestFinishedWithObject:(NSObject*)object;
-(void)queueFinished:(ASINetworkQueue *)queue;

@optional

@end

@interface ODWebService : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate>
{
    ASINetworkQueue *networkQueue_;
    bool isAlreadyCleaning_;
    int mode_;
    int requestMode_;
}

//Init
-(id)initForRequests;
-(id)initForUpload;
-(id)initForGetImages;

//Public accessor
-(ASINetworkQueue*)queue;

//Request
-(void)doNetworkOperation:(id)request;

//Requests
-(void)doNetworkOperations:(NSArray*)arrayRequest;

//Operation
-(void)launchNetworkOperations;
-(void)cancelNetworkOperations;
-(int) numberOfRequest;
-(void)rebuildQueueIfNeedded; //Use when queue is nil


@property (nonatomic, assign) id<WebServiceDelegate> delegate;

@end
