//
//  KeychainWrapper.h
//  ProximityBusinessDemo
//
//  Created by Josh Holton on 11/1/21.
//

#ifndef KeychainWrapper_h
#define KeychainWrapper_h


#endif /* KeychainWrapper_h */

#import <Foundation/Foundation.h>

@interface KeychainWrapper : NSObject
{
    NSString * service;
    NSString * group;
}

-(id) initWithService:(NSString *) service_ withGroup:(NSString*)group_;

-(BOOL) insert:(NSString *)key : (NSData *)data;
-(BOOL) update:(NSString*)key :(NSData*) data;
-(BOOL) remove: (NSString*)key;
-(NSData*) find:(NSString*)key;

@end

