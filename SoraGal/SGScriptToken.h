//
//  SGScriptToken.h
//  SoraGal
//
//  Created by conans on 1/17/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGScriptToken : NSObject

@property NSUInteger tokenType;
@property (nonatomic, strong) NSString *tokenText;

- (id)initWithScriptTokenType:(NSUInteger)type andText:(NSString *)text;

@end
