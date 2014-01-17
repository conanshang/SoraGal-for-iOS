//
//  SGScriptToken.m
//  SoraGal
//
//  Created by conans on 1/17/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGScriptToken.h"

@implementation SGScriptToken

- (id)initWithScriptTokenType:(NSUInteger)type andText:(NSString *)text{
    self = [super init];
    if(self){
        self.tokenType = type;
        self.tokenText = text;
    }
    
    return self;
}

@end
