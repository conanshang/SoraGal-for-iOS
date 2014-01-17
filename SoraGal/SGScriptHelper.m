//
//  SGScriptHelper.m
//  SoraGal
//
//  Created by conans on 1/17/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGScriptHelper.h"

@interface SGScriptHelper()

@property (nonatomic, strong) NSMutableDictionary *tempScriptTokens;
@property (nonatomic, strong) NSMutableArray *tempBackwardScriptTokensMap;

@end

@implementation SGScriptHelper

- (id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

- (void)createScriptTokens{
    self.tempScriptTokens = [[NSMutableDictionary alloc] init];
    self.tempBackwardScriptTokensMap = [[NSMutableArray alloc] init];
    
    NSArray *array = [NSArray arrayWithObjects:@"EOS_TOKEN",@"JS_TOKEN",@"NEWLINE_TOKEN",@"EMPTYLINE_TOKEN",@"COMMA_TOKEN",@"SEMICOLON_TOKEN",@"DOT_TOKEN",@"STRING_TOKEN",@"OTHER_STRING_TOKEN",@"GAMESCRIPTSTRING_TOKEN",@"GAMESCRIPT_GOTO_TOKEN",@"GAMESCRIPT_LABEL_TOKEN",@"GAMESCRIPT_IDENTIFIER_TOKEN",@"GAMESCRIPT_IF_TOKEN",@"GAMESCRIPT_SELECT_TOKEN",@"LINECOMMENT_TOKEN",@"BLOCKCOMMENT_TOKEN",nil];
    
    for(int i=0; i<[array count]; i++){
        NSString *tokenName = [[array objectAtIndex:i] uppercaseString];
        [self.tempScriptTokens setObject:[NSString stringWithFormat:@"%u", i] forKey:tokenName];
        [self.tempBackwardScriptTokensMap addObject:tokenName];
    }
    
    self.scriptTokens = [NSDictionary dictionaryWithDictionary:self.tempScriptTokens];
    self.backwardScriptTokensMap = [NSArray arrayWithArray:self.tempBackwardScriptTokensMap];
}

@end
