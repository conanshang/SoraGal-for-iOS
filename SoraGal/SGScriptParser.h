//
//  SGScriptParser.h
//  SoraGal
//
//  Created by conans on 1/22/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGScriptExecutor.h"
#import "SGScriptScanner.h"
#import "SGScriptExpression.h"

@interface SGScriptParser : SGScriptExecutor

- (id)initWithScannerInstance:(SGScriptScanner *)receivedScannerInstance;
- (SGScriptExpressionBlockNode *)parse;

@end
