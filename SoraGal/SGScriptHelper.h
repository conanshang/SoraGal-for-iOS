//
//  SGScriptHelper.h
//  SoraGal
//
//  Created by conans on 1/17/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGScriptHelper : NSObject

@property (nonatomic, strong) NSDictionary *scriptTokens;
@property (nonatomic, strong) NSArray *backwardScriptTokensMap;

- (void)createScriptTokens;

@end
