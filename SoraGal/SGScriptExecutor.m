//
//  SGScriptExecutor.m
//  SoraGal
//
//  Created by conans on 1/16/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGScriptExecutor.h"

@interface SGScriptExecutor()

@end

@implementation SGScriptExecutor

- (id)init{
    self = [super init];
    if(self){
        self.scriptHelper = [[SGScriptHelper alloc] init];
        [self.scriptHelper createScriptTokens];
    }
    return self;
}


@end




