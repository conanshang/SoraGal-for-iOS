//
//  SGScriptHelper.h
//  SoraGal
//
//  Created by conans on 1/17/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGScriptHelper : NSObject

//Use token name to find string format of token number.
@property (nonatomic, strong) NSDictionary *scriptTokens;
//Use string format of token number to find the token name.
@property (nonatomic, strong) NSArray *backwardScriptTokensMap;
//The errors array.
@property (nonatomic, strong) NSMutableArray *scriptErrors;

//Before use the tokens.
//*First need to execute this function to create tokens.
- (void)createScriptTokens;
//Remove all the white space from a string.
- (NSString *)trimTheWhiteSpaceOfAString:(NSString *)string;
//Set script errors.
- (void)setErrorsWithType:(NSString *)errorType andMessage:(NSString *)errorMessage andLineNumber:(NSUInteger)lineNumber;

@end
