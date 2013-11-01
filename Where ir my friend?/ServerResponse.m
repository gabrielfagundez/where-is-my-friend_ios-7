//
//  ServerResponse.m
//  Where is my friend?
//
//  Created by MacDev on 11/1/13.
//  Copyright (c) 2013 MacDev. All rights reserved.
//

#import "ServerResponse.h"

@implementation ServerResponse

- (id)initialize :(NSInteger)c :(NSString*)j :(NSString*)i :(NSString*)n :(NSString*)m{
    
    if (self == [super init]){
        codigo = c;
        json = j;
        numId = i;
        name = n;
        mail = m;
    }
    return self;
}

- (NSInteger)getCodigo{
    return codigo;
}

- (NSString *)getJson{
    return json;
}

- (NSString *)getNumId{
    return numId;
}

- (NSString *)getName{
    return name;
}

- (NSString *)getMail{
    return mail;
}


@end

