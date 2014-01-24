//
//  SGScriptReader.h
//  SoraGal
//
//  Created by conans on 1/16/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGScriptExecutor.h"

@interface SGScriptReader : NSObject

//Create a new Reader by send a string.
- (id)initWithString:(NSString *)scriptString;
//Get the next char in the string.
- (unichar)nextCharacter;
//Retract n char in from current position.
- (void)retractNCharacter:(NSUInteger) n;

@end
