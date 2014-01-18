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

@interface SGScriptScanner : SGScriptExecutor

- (id)initWithReaderInstance:(SGScriptReader *)receivedReaderInstacnce;

@end
