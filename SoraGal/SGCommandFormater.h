//
//  SGCommandFormater.h
//  SoraGal
//
//  Created by conans on 2/18/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGCommandFormater : NSObject

- (NSArray *)getNextCommand;
- (NSNumber *)getCurrentLineNumber;
- (void)reloadLineFrom:(NSNumber *)lineNumber;

@end
