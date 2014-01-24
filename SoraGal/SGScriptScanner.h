//
//  SGScriptScanner.h
//  SoraGal
//
//  Created by conans on 1/17/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGScriptExecutor.h"
#import "SGScriptReader.h"
#import "SGScriptToken.h"

@interface SGScriptScanner : NSObject

@property (nonatomic, strong) SGScriptToken *currentScriptToken;

@property BOOL ifSkipNewLine;
@property NSUInteger currentLine;

- (id)initWithReaderInstance:(SGScriptReader *)receivedReaderInstacnce;
- (NSUInteger)nextToken;

@end
