//
//  SGScriptScanner.m
//  SoraGal
//
//  Created by conans on 1/17/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGScriptScanner.h"
#import "SGScriptReader.h"
#import "SGScriptToken.h"
#import "SGScriptHelper.h"

#define START_STATE 1
#define IDENTIFIER_STATE 2
#define JavaScriptBlock_STATE 3
#define GAMEDEFINEDFUNCTION_STATE 4
#define OTHER_STRING_STATE 5
#define STRING_STATE 6
#define GAMESCRIPT_STRING_STATE 7

@interface SGScriptScanner()

@property (nonatomic, strong) SGScriptReader *scriptReader;
@property (nonatomic, strong) SGScriptToken *currentScriptToken;
@property (nonatomic, strong) SGScriptHelper *scriptHelper;

@property NSUInteger currentLine;
@property BOOL ifSkipNewLine;
@property NSUInteger currentStatus;
@property BOOL ifInTheProcessOf_GAMEDEFINEDFUNCTION_STATE;
@property (nonatomic, strong) NSString *_bufferString;

@end

@implementation SGScriptScanner

- (id)init{
    self = [super init];
    if(self){
        
        
    }
    return self;
}

- (id)initWithString:(NSString *)receivedString{
    self = [super init];
    if(self){
        self.scriptReader = [self.scriptReader initWithString:receivedString];
        self.currentScriptToken = [[SGScriptToken alloc] init];
        self.scriptHelper = [[SGScriptHelper alloc] init];
        
        self.currentLine = 0;
        self.ifSkipNewLine = YES;
        self.currentStatus = START_STATE;
        self.ifInTheProcessOf_GAMEDEFINEDFUNCTION_STATE = NO;
        self._bufferString = [[NSString alloc] init];
    }
    return self;
}

- (NSUInteger)makeTokenWithType:(NSUInteger)type andText:(NSString *)text{
    self.currentScriptToken.tokenType = type;
    self.currentScriptToken.tokenText = text;
    self._bufferString = @"";
    
    return type;
}

- (NSString *)nextToken{
    [self.scriptHelper createScriptTokens];
    self._bufferString = @"";
    
    while(YES){
       
        
        
        
        
        
    }
    
    
    
    
}


















@end


















