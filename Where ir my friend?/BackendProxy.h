//
//  BackendProxy.h
//  Where is my friend?
//
//  Created by MacDev on 10/31/13.
//  Copyright (c) 2013 MacDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerResponse.h"

@interface BackendProxy : NSObject{
    
}

+ (bool)internetConnection;
+ (ServerResponse *)login :(NSString*)email :(NSString*)pswd :(NSString*)plat :(NSString*)device :(NSString*)idiom;
+ (void)send :(NSString*)to;
+ (void)logout;
+ (void)resetBadgeCount;
+ (NSArray *)GetLastFriendsLocationsById;
+ (NSArray *)GetAllFriends;
+ (NSArray *)GetAll;
+ (void)Accept :(NSString *)idSol;
+ (void)Reject :(NSString *)idSol;
+ (void)setLocation :(NSString *)longit :(NSString *)latit;

@end
