//
//  SGScriptExecutor.h
//  SoraGal
//
//  Created by conans on 1/16/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGScriptExecutor : NSObject

@property (nonatomic, strong) NSArray *waitingCommandArray;

- (id)initWithGameScriptString:(NSString *)receivedGameScriptString;
- (BOOL)next;

@end
