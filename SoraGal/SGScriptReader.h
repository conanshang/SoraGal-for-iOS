//
//  SGScriptReader.h
//  SoraGal
//
//  Created by conans on 1/16/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGScriptReader : NSObject

- (id)initWithString:(NSString *)scriptString;
- (unichar)nextCharacter;
- (void)retractNCharacter:(NSUInteger) n;


@end
