//
//  ServerResponse.h
//  Where is my friend?
//
//  Created by MacDev on 11/1/13.
//  Copyright (c) 2013 MacDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerResponse : NSObject{
    
    NSInteger codigo;
    NSString *json;
    NSString *numId;
    NSString *name;
    NSString *mail;
    
}

- (id)initialize :(NSInteger)c :(NSString*)j :(NSString*)i :(NSString*)n :(NSString*)m;
- (NSInteger)getCodigo;
- (NSString *)getJson;
- (NSString *)getNumId;
- (NSString *)getName;
- (NSString *)getMail;

@end