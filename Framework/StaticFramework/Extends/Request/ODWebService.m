//
//  WebService.m
//  
//
//  Created by Olivier Demolliens on 06/11/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "ODWebService.h"

// Private stuff
#ifdef DEBUG
//WebService debug
#define NSRequestLog(fmt, ...) //NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#else

//WebService debug
#define NSRequestLog(fmt, ...)

#endif

@interface ODWebService ()

//Normal Request
-(void)requestFinished:(ASIHTTPRequest *)request;
-(void)requestFailed:(ASIHTTPRequest *)request;

//Images Request
- (void)imageFetchComplete:(ASIHTTPRequest *)request;
- (void)imageFetchFailed:(ASIHTTPRequest *)request;

//Upload Request
-(void)uploadFinished:(ASIHTTPRequest *)request;
-(void)uploadFailed:(ASIHTTPRequest *)request;

//Queue event
-(void)queueFinished:(ASINetworkQueue *)queue;

@end

/***
 *
 * requestMode_
 * 0 = Request
 * 1 = Request with images
 * 2 = Upload request files
 *
 */
@implementation ODWebService

@synthesize delegate = delegate_;

-(id)initForRequests
{
   isAlreadyCleaning_ = NO;
   
   self = [super init];
   
	if (self != nil) {
      requestMode_ = 0;
      
      networkQueue_ = [[ASINetworkQueue queue] retain];
      [networkQueue_ setShowAccurateProgress:YES];
      
      //Delegate
      
      [networkQueue_ setDelegate:self];
      
      //TODO: need make delegate
      //[networkQueue_ setUploadProgressDelegate:controller];
      
      //Request
      [networkQueue_ setRequestDidFinishSelector:@selector(requestFinished:)];
      [networkQueue_ setRequestDidFailSelector:@selector(requestFailed:)];
      [networkQueue_ setRequestDidReceiveResponseHeadersSelector:@selector(request:didReceiveBytes:)];
      
      //Queue
      [networkQueue_ setQueueDidFinishSelector:@selector(queueFinished:)];
      
   }
   return self;
}

-(id)initForUpload
{
   isAlreadyCleaning_ = NO;
   
   self = [super init];
   
	if (self != nil) {
      requestMode_ = 2;
      
      networkQueue_ = [ASINetworkQueue queue];
      
      [networkQueue_ setShowAccurateProgress:YES];
      
      //Delegate
      
      [networkQueue_ setDelegate:self];
      
      //Upload
      [networkQueue_ setRequestDidFailSelector:@selector(uploadFailed:)];
      [networkQueue_ setRequestDidFinishSelector:@selector(uploadFinished:)];
      [networkQueue_ setRequestDidReceiveResponseHeadersSelector:@selector(request:didReceiveBytes:)];
      
      //TODO: need make delegate
      //[networkQueue_ setUploadProgressDelegate:controller];
      
      //Queue
      [networkQueue_ setQueueDidFinishSelector:@selector(queueFinished:)];
   }
   
   return self;
}

-(id)initForGetImages
{
   isAlreadyCleaning_ = NO;

   self = [super init];
   
	if (self != nil) {
      requestMode_ = 3;
      networkQueue_ = [ASINetworkQueue queue];
      [networkQueue_ setShowAccurateProgress:YES];
      
      //Delegate
      
      [networkQueue_ setDelegate:self];
      
      //TODO: need make delegate
      //[networkQueue_ setUploadProgressDelegate:controller];
      
      //Images
      [networkQueue_ setRequestDidFinishSelector:@selector(imageFetchComplete:)];
      [networkQueue_ setRequestDidFailSelector:@selector(imageFetchFailed:)];
      [networkQueue_ setRequestDidReceiveResponseHeadersSelector:@selector(request:didReceiveBytes:)];
      
      //Queue
      [networkQueue_ setQueueDidFinishSelector:@selector(queueFinished:)];
      
   }
   
   return self;
}

-(ASINetworkQueue*)queue
{
   return networkQueue_;
}

-(void)doNetworkOperation:(id)request
{
   
   NSAssert(([request isKindOfClass:[ASIHTTPRequest class]] || [request isKindOfClass:[ASIFormDataRequest class]]), @"Can't use this method for this type of object");

   //Credential session
   [request setUseSessionPersistence:YES];
   
   if(requestMode_ <2){
      //Don't need it for upload
      //[request setTemporaryFileDownloadPath:[SystemFolderController filePathForTemporaryFiles]];
      
   }
   
   [request setAllowResumeForFileDownloads:YES];
   
   int new = 0;
   
   for(ASIHTTPRequest *requestTemp in [networkQueue_ operations]){
      
      if([[[request url]absoluteString]isEqualToString:[[requestTemp url]absoluteString]]){
         new = 1;
         break;
      }
   }
   
   if(new==0){
      [networkQueue_ addOperation:request];
   }else{
      //NSLog(@"Request is already calling");
   }
   
   
}

-(void)doNetworkOperations:(NSArray*)arrayRequest
{
   int i =0;
   for(ASIHTTPRequest *request in arrayRequest){
      //NSLog(@"request (%d) : %@",i,request.url);
      i++;
   }
   
   NSAssert([arrayRequest count] > 0, @"Array request can't be empty");
   //ASIFormDataRequest is a Kind of Class ASIHTTPRequest
   for(ASIHTTPRequest *request in arrayRequest){
      
      //Credential session
      [request setUseSessionPersistence:YES];
      
      if(requestMode_ <2){
         //Don't need it for upload
         //[request setTemporaryFileDownloadPath:[SystemFolderController filePathForTemporaryFiles]];
         
      }
      
      [request setAllowResumeForFileDownloads:YES];
      
      [networkQueue_ addOperation:request];
      
   }
}

-(void)launchNetworkOperations
{
   [networkQueue_ go];
}

-(void)cancelNetworkOperations
{
   // Stop anything already in the queue before removing it
   if(!isAlreadyCleaning_ && [networkQueue_ requestsCount]>0){
      
      [networkQueue_ cancelAllOperations];
      [networkQueue_ setDelegate:nil];
      [networkQueue_ setDownloadProgressDelegate:nil];
      [networkQueue_ setUploadProgressDelegate:nil];
      [networkQueue_ setRequestDidStartSelector:NULL];
      [networkQueue_ setRequestDidReceiveResponseHeadersSelector:NULL];
      [networkQueue_ setRequestDidFailSelector:NULL];
      [networkQueue_ setRequestDidFinishSelector:NULL];
      [networkQueue_ setQueueDidFinishSelector:NULL];
      [networkQueue_ setSuspended:YES];
      [self rebuildQueueIfNeedded];
      [self launchNetworkOperations];
      isAlreadyCleaning_ = NO;
   }
   
}

-(void)rebuildQueueIfNeedded
{
   if(networkQueue_.delegate==nil){
      [networkQueue_ setDelegate:self];
      
      switch (requestMode_) {
            
         case 0:
            [networkQueue_ setRequestDidFinishSelector:@selector(requestFinished:)];
            [networkQueue_ setRequestDidFailSelector:@selector(requestFailed:)];
            break;
            
         case 1:
            [networkQueue_ setRequestDidFinishSelector:@selector(imageFetchComplete:)];
            [networkQueue_ setRequestDidFailSelector:@selector(imageFetchFailed:)];
            break;
            
         case 2:
            [networkQueue_ setRequestDidFailSelector:@selector(uploadFailed:)];
            [networkQueue_ setRequestDidFinishSelector:@selector(uploadFinished:)];
            break;
            
         default:
            NSAssert(1+1==3, @"UNDEV rebuildQueueIfNeedded");
            break;
            
      }
      
      [networkQueue_ setQueueDidFinishSelector:@selector(queueFinished:)];
   }
}

-(int)numberOfRequest
{
   return [networkQueue_ requestsCount];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
   //NSLog(@"request url:%@",[request url]);
   //NSLog(@"WS:requestFinished:%@    \n\n statusCode:%i",[request responseString],[request responseStatusCode]);

   if([request responseStatusCode] == 200){

      //Here treatment response
      
      if ([delegate_ respondsToSelector:@selector(requestFinished:)]) {
         
         [delegate_ requestFinished:request];
         
         
      }else{
         NSAssert(1+1==3, @"WebService doesn't have delegate set");
      }
      
   }else{
      //4xx,500 - ErrorCode
      
      NSRequestLog(@"Request failed message :%@ - %i - %@",[ODErrorRequestUtil  errorMessage:[request responseStatusCode]],[request responseStatusCode],[request responseStatusMessage]);
      
      if ([delegate_ respondsToSelector:@selector(requestError:)]) {
         [delegate_ requestError:request];
      }else{
         NSAssert(1+1==3, @"WebService doesn't have delegate set");
      }
      
}
   
}

-(void)uploadFinished:(ASIHTTPRequest *)request
{
   NSLog(@"uploadFinished");
   // NSRequestLog(@"Request upload success message :%@ - %i - %@",[ErrorRequestUtil  errorMessage:[request responseStatusCode]],[request responseStatusCode],[request responseStatusMessage]);
   
   //Here treatment response
   
}

-(void)uploadFailed:(ASIHTTPRequest *)request
{
   NSLog(@"uploadFailed");
   //NSRequestLog(@"Request upload failed message :%@ - %i - %@",[ErrorRequestUtil  errorMessage:[request responseStatusCode]],[request responseStatusCode],[request responseStatusMessage]);
   
   //Here treatment response
   
   
}

- (void)imageFetchComplete:(ASIHTTPRequest *)request
{
	//NSRequestLog(@"Request images success message :%@ - %i - %@",[ErrorRequestUtil  errorMessage:[request responseStatusCode]],[request responseStatusCode],[request responseStatusMessage]);
   
   //Here treatment response
   
}

- (void)imageFetchFailed:(ASIHTTPRequest *)request
{
   // NSRequestLog(@"Request images failed message :%@ - %i - %@",[ErrorRequestUtil  errorMessage:[request responseStatusCode]],/[request responseStatusCode],[request responseStatusMessage]);
   
   //Here treatment response
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSRequestLog(@"Request failed:%@",[ODErrorRequestUtil errorMessage:[request responseStatusCode]]);
   
   //Here treatment response
   if ([delegate_ respondsToSelector:@selector(requestError:)]) {
      [delegate_ requestError:request];
   }
}

- (void)queueFinished:(ASINetworkQueue *)queue
{
   
   NSRequestLog(@"Queue finished");
   
   //
   //Here do delegate
   if ([delegate_ respondsToSelector:@selector(queueFinished:)]) {
      [delegate_ queueFinished:queue];
   }else{
      //NSAssert(1+1==3, @"WebService doesn't have delegate set");
   }
}

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
   
}

- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
   
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
   NSLog(@"response Headers:%@",responseHeaders);
   NSString * totalSize = [request.responseHeaders objectForKey:@"Content-Length"];
   NSLog(@"headers received. file size:%@",totalSize);
}

-(void)dealloc
{
    
   //Clear all current request before release it
   [networkQueue_ reset];
   //
   [networkQueue_ release];

   [super dealloc];
}

@end
