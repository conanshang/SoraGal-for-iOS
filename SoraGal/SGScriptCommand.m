//
//  SGScriptCommand.m
//  SoraGal
//
//  Created by conans on 2/3/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGScriptCommand.h"

@implementation SGScriptCommand

+ (id)createCommandWithCommandName:(NSString *)name andCommandParameters:(NSArray *)parameters{
    return [[self alloc] initWithCommandName:name andCommandParameters:parameters];
}

- (id)initWithCommandName:(NSString *)name andCommandParameters:(NSArray *)parameters{
    self = [super init];
    if(self){
        self.commandName = name;
        self.commandParameters = parameters;
    }
    return self;
}

@end
