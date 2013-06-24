//
//  MySingleton..h
//  test singleton
//
//  Created by Jean-Luc Pedroni on 12/05/08.
//  Mail: jeanluc.pedroni AT free.fr
//
//  You can use it as you wish,
//  but please keep this header.
//

#import <Foundation/NSObject.h>
#import <Foundation/NSException.h>

@interface NSSingleton : NSObject {
}

+(void)cleanup;
// . [NSSingleton cleanup]  : Free all singletons.
// . [MySingleton cleanup] : Free MySingleton.

+(id)sharedInstance;
// Notes :
// . +(id)sharedInstance can be overridden to return the right type..
//   ex : (MySingleton *)sharedInstance { return [super sharedInstance]; }
// . Singleton initialization must be done as usual in -(id)init.
//
@end