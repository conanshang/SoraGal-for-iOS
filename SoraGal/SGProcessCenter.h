//
//  SGProcessCenter.h
//  SoraGal
//
//  Created by conans on 2/3/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGProcessCenter : NSObject

- (NSArray *)nextLine;
- (NSNumber *)saveGameInScriptProcessorLevel;
- (void)loadGameInScriptProcessorLevel:(NSNumber *)currentLine;

@end
