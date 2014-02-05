//
//  SGScriptCommand.h
//  SoraGal
//
//  Created by conans on 2/3/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGScriptCommand : NSObject

@property (nonatomic, strong) NSString *commandName;
@property (nonatomic, strong) NSArray *commandParameters;
//Comamnd type has @"dialogComamnd" and @"scriptFunctionComamnd".
@property (nonatomic, strong) NSString *currentCommandType;

+ (id)createCommandWithCommandName:(NSString *)name andCommandParameters:(NSArray *)parameters;

@end
