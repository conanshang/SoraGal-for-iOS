//
//  SGScriptExecutor.h
//  SoraGal
//
//  Created by conans on 1/16/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGScriptExecutor : NSObject

- (id)initWithGameScriptString:(NSString *)receivedGameScriptString;
- (NSDictionary *)saveGame;
- (void)loadGameFromSaveData:(NSDictionary *)saveData;

@end
