//
//  SGScriptHelper.m
//  SoraGal
//
//  Created by conans on 1/17/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGScriptHelper.h"

@interface SGScriptHelper()

//Mutable version for temporary use.
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

//Create script tokens
- (void)createScriptTokens{
    self.tempScriptTokens = [[NSMutableDictionary alloc] init];
    self.tempBackwardScriptTokensMap = [[NSMutableArray alloc] init];
    
    //Token names array.
    NSArray *array = [NSArray arrayWithObjects:@"EOS_TOKEN",@"JS_TOKEN",@"NEWLINE_TOKEN",@"EMPTYLINE_TOKEN",@"COMMA_TOKEN",@"SEMICOLON_TOKEN",@"DOT_TOKEN",@"STRING_TOKEN",@"OTHER_STRING_TOKEN",@"GAMESCRIPTSTRING_TOKEN",@"GAMESCRIPT_GOTO_TOKEN",@"GAMESCRIPT_LABEL_TOKEN",@"GAMESCRIPT_IDENTIFIER_TOKEN",@"GAMESCRIPT_IF_TOKEN",@"GAMESCRIPT_SELECT_TOKEN",@"LINECOMMENT_TOKEN",@"BLOCKCOMMENT_TOKEN",nil];
    
    //Create the tokens.
    for(int i=0; i<[array count]; i++){
        NSString *tokenName = [[array objectAtIndex:i] uppercaseString];
        [self.tempScriptTokens setObject:[NSNumber numberWithInt:i] forKey:tokenName];
        [self.tempBackwardScriptTokensMap addObject:tokenName];
    }
    
    //Create the non-mutable version.
    self.scriptTokens = [NSDictionary dictionaryWithDictionary:self.tempScriptTokens];
    self.backwardScriptTokensMap = [NSArray arrayWithArray:self.tempBackwardScriptTokensMap];
    
    //Let the system to release the temporary tokens.
    self.tempScriptTokens = nil;
    self.tempBackwardScriptTokensMap = nil;
}

//Remove the blanks in a string.
- (NSString *)trimTheWhiteSpaceOfAString:(NSString *)string{
    NSArray *newString = [string componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
    NSString *noSpaceString = [newString componentsJoinedByString:@""];
    
    return noSpaceString;
}

//Handle the errors.
- (void)setErrorsWithType:(NSString *)errorType andMessage:(NSString *)errorMessage andLineNumber:(NSUInteger)lineNumber{
    NSDictionary *error = [NSDictionary dictionaryWithObjectsAndKeys:@"errorType", errorType, @"errorMessage", errorMessage, @"errorLineNumber", [NSNumber numberWithInt:lineNumber], nil];
    
    [self.scriptErrors addObject:error];
    error = nil;
}



















@end
