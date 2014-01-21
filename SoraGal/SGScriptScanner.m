//
//  SGScriptScanner.m
//  SoraGal
//
//  Created by conans on 1/17/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGScriptScanner.h"
#import "SGScriptToken.h"
#import "SGScriptHelper.h"

#define START_STATE 1
#define IDENTIFIER_STATE 2
#define JavaScriptBlock_STATE 3
#define GAMEDEFINEDFUNCTION_STATE 4
#define OTHER_STRING_STATE 5
#define STRING_STATE 6
#define GAMESCRIPT_STRING_STATE 7
#define MAX_SCRIPT_STATUS_NUMBER 8

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

- (id)initWithReaderInstance:(SGScriptReader *)receivedReaderInstacnce{
    self = [super init];
    if(self){
        self.scriptReader = receivedReaderInstacnce;
        self.currentScriptToken = [[SGScriptToken alloc] init];
        self.scriptHelper = [[SGScriptHelper alloc] init];
        [self.scriptHelper createScriptTokens];
        
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

- (NSUInteger)nextToken{
    self._bufferString = @"";
    
    while(YES){
        switch (self.currentStatus) {
            //If in the START_STATE.
            case START_STATE:{
                unichar c = [self.scriptReader nextCharacter];
                
                if(c == '\n' || c == '\r'){
                    self.currentLine++;
                    self.ifInTheProcessOf_GAMEDEFINEDFUNCTION_STATE = NO;
                    
                    if(!self.ifSkipNewLine){
                        NSUInteger newTokenType = [[self.scriptHelper.scriptTokens objectForKey:@"NEWLINE_TOKEN"] unsignedIntegerValue];
                        return [self makeTokenWithType:newTokenType andText:nil];
                    }
                    
                    continue;
                }
                
                if(c == 0x00B6){
                    NSUInteger newTokenType = [[self.scriptHelper.scriptTokens objectForKey:@"EOS_TOKEN"] unsignedIntegerValue];
                    return [self makeTokenWithType:newTokenType andText:nil];
                }
                
                if(self.ifInTheProcessOf_GAMEDEFINEDFUNCTION_STATE){
                    switch (c) {
                        case 0x0022: case 0x0027:{
                            self.currentStatus = STRING_STATE;
                            self._bufferString = [NSString stringWithCharacters:&c length:1];
                        }
                            break;
                        
                        case ',':{
                            NSUInteger newTokenType = [[self.scriptHelper.scriptTokens objectForKey:@"COMMA_TOKEN"] unsignedIntegerValue];
                            return [self makeTokenWithType:newTokenType andText:nil];
                        }
                            break;
                            
                        case ';':{
                            NSUInteger newTokenType = [[self.scriptHelper.scriptTokens objectForKey:@"SEMICOLON_TOKEN"] unsignedIntegerValue];
                            return [self makeTokenWithType:newTokenType andText:nil];
                        }
                            break;
                            
                        default:{
                            self.currentStatus = OTHER_STRING_STATE;
                        }
                            break;
                    }
                }
                else{
                    self.currentStatus = GAMESCRIPT_STRING_STATE;
                }
            }
                break;
            
            //In GAMEDEFINEDFUNCTION_STATE.
            case GAMEDEFINEDFUNCTION_STATE:{
                NSUInteger result = [self processGAMEDEFINEDFUNCTION_STATE];
                if(result < MAX_SCRIPT_STATUS_NUMBER){
                    return result;
                }
            }
                break;
                
            //In JavaScriptBlock_STATE.
            case JavaScriptBlock_STATE:{
                NSUInteger result = [self processJavaScriptBlock_STATE];
                if(result < MAX_SCRIPT_STATUS_NUMBER){
                    return result;
                }
            }
                break;
            
            //In GAMESCRIPT_STRING_STATE.
            case GAMESCRIPT_STRING_STATE:{
                NSUInteger result = [self processGAMESCRIPT_STRING_STATE];
                if(result < MAX_SCRIPT_STATUS_NUMBER){
                    return result;
                }
            }
                break;
                
            //In STRING_STATE.
            case STRING_STATE:{
                NSUInteger result = [self processSTRING_STATE];
                if(result < MAX_SCRIPT_STATUS_NUMBER){
                    return result;
                }
            }
                break;
                
            //In OTHER_STRING_STATE.
            case OTHER_STRING_STATE:{
                NSUInteger result = [self processOTHER_STRING_STATE];
                if(result < MAX_SCRIPT_STATUS_NUMBER){
                    return result;
                }
            }
                break;
        }
    }
}

- (NSUInteger)processGAMESCRIPT_STRING_STATE{
    unichar theChar, theNextChar;
    BOOL ifEnd = NO;
    BOOL ifFirstLine = YES;
    NSMutableArray *lines = [[NSMutableArray alloc] init];
    NSDictionary *tokens = self.scriptHelper.scriptTokens;
    self._bufferString = @"";
    
    [self.scriptReader retractNCharacter:1];
    
    while(!ifEnd){
        theChar = [self.scriptReader nextCharacter];
        if(theChar == '@'){
            if([lines count] > 0){
                [self.scriptReader retractNCharacter:1];
                self.currentStatus = START_STATE;
                
                NSUInteger newTokenType = [[tokens objectForKey:@"GAMESCRIPTSTRING_TOKEN"] unsignedIntegerValue];
                NSString *tokenString = [lines componentsJoinedByString:@"\r\n"];
                return [self makeTokenWithType:newTokenType andText:tokenString];
            }
        
        
            theNextChar = [self.scriptReader nextCharacter];
            if(theNextChar == '{'){
                self.currentStatus = JavaScriptBlock_STATE;
                return MAX_SCRIPT_STATUS_NUMBER;
            }
            
            if((theNextChar>='a' && theNextChar<='z') || (theNextChar>='A' && theNextChar<='Z') || (theNextChar == '_')){
                self.currentStatus = GAMEDEFINEDFUNCTION_STATE;
                self._bufferString = [NSString stringWithCharacters:&theNextChar length:1];
                return MAX_SCRIPT_STATUS_NUMBER;
            }
        }
        
        if((theChar == 0x00B6) && ([[self.scriptHelper trimTheWhiteSpaceOfAString:self._bufferString] isEqualToString:@""])){
            self.currentStatus = START_STATE;
            [lines addObject:self._bufferString];
            
            NSUInteger newTokenType = [[tokens objectForKey:@"GAMESCRIPTSTRING_TOKEN"] unsignedIntegerValue];
            NSString *tokenString = [lines componentsJoinedByString:@"\r\n"];
            return [self makeTokenWithType:newTokenType andText:tokenString];
        }
        
        if((theChar == 0x00B6) && ([lines count] != 0)){
            break;
        }
        
        if(theChar == 0x00B6){
            self.currentStatus = START_STATE;
            return MAX_SCRIPT_STATUS_NUMBER;
        }
        
        if((theChar != '\r') && (theChar != '\n')){
            NSString *string = [NSString stringWithCharacters:&theChar length:1];
            self._bufferString = [self._bufferString stringByAppendingString:string];
            
            if((ifFirstLine == YES) && ([[self.scriptHelper trimTheWhiteSpaceOfAString:self._bufferString] isEqualToString:@""])){
                ifFirstLine = NO;
            }
        }
        else{
            self.currentLine++;
            self._bufferString = [self.scriptHelper trimTheWhiteSpaceOfAString:self._bufferString];
            
            if([self._bufferString isEqualToString:@""] && ifFirstLine == NO){
                ifEnd = YES;
            }
            
            if([self._bufferString isEqualToString:@""] && ifFirstLine == YES){
                theChar = [self.scriptReader nextCharacter];
                continue;
            }
            
            if([self._bufferString isEqualToString:@""] && ifFirstLine == YES){
                ifFirstLine = NO;
            }
            
            [lines addObject:self._bufferString];
            self._bufferString = @"";
        }
    }
    
    self.currentStatus = START_STATE;
    
    NSUInteger newTokenType = [[tokens objectForKey:@"GAMESCRIPTSTRING_TOKEN"] unsignedIntegerValue];
    NSString *tokenString = [lines componentsJoinedByString:@"\r\n"];
    return [self makeTokenWithType:newTokenType andText:tokenString];
}

- (NSUInteger)processJavaScriptBlock_STATE{
    NSDictionary *tokens = self.scriptHelper.scriptTokens;
    self._bufferString = @"";
    
    unichar theChar = [self.scriptReader nextCharacter];
    unichar theNextChar = [self.scriptReader nextCharacter];
    
    while (theChar != 0x00B6) {
        if(theChar == '}' && theChar == '@'){
            break;
        }
        
        self._bufferString = [self._bufferString stringByAppendingString:[NSString stringWithCharacters:&theChar length:1]];
        
        if(theChar == '\r' || theChar == '\n'){
            self.currentLine++;
        }
        
        theChar = theNextChar;
        theNextChar = [self.scriptReader nextCharacter];
    }
    
    self.currentStatus = START_STATE;
    
    NSUInteger newTokenType = [[tokens objectForKey:@"JS_TOKEN"] unsignedIntegerValue];
    NSString *newTokenString = self._bufferString;
    return [self makeTokenWithType:newTokenType andText:newTokenString];
}

- (NSUInteger)processGAMEDEFINEDFUNCTION_STATE{
    NSString *bufferString = self._bufferString;
    self._bufferString = @"";
    NSDictionary *tokens = self.scriptHelper.scriptTokens;
    
    while((![bufferString isEqualToString:@"\r"]) && (![bufferString isEqualToString:@"\n"]) && (![bufferString isEqualToString:@" "])){
        self._bufferString = [self._bufferString stringByAppendingString:bufferString];
        
        unichar theChar = [self.scriptReader nextCharacter];
        bufferString = [NSString stringWithCharacters:&theChar length:1];
    }
    NSString *functionName = self._bufferString;
    
    if((![bufferString isEqualToString:@"\r"]) && (![bufferString isEqualToString:@"\n"])){
        self.ifInTheProcessOf_GAMEDEFINEDFUNCTION_STATE = YES;
        self.currentStatus = START_STATE;
    }
    else{
        self.currentLine++;
        self.ifInTheProcessOf_GAMEDEFINEDFUNCTION_STATE = NO;
        self.currentStatus = START_STATE;
    }
    
    if([functionName isEqualToString:@"goto"]){
        NSUInteger newTokenType = [[tokens objectForKey:@"GAMESCRIPT_GOTO_TOKEN"] unsignedIntegerValue];
        return [self makeTokenWithType:newTokenType andText:nil];
    }
    else if([functionName isEqualToString:@"label"]){
        NSUInteger newTokenType = [[tokens objectForKey:@"GAMESCRIPT_LABEL_TOKEN"] unsignedIntegerValue];
        return [self makeTokenWithType:newTokenType andText:nil];
    }
    else{
        NSUInteger newTokenType = [[tokens objectForKey:@"GAMESCRIPT_IDENTIFIER_TOKEN"] unsignedIntegerValue];
        return [self makeTokenWithType:newTokenType andText:functionName];
    }
}

- (NSUInteger)processSTRING_STATE{
    NSDictionary *tokens = self.scriptHelper.scriptTokens;
    unichar theChar = [self.scriptReader nextCharacter];
    NSString *quotesType = self._bufferString;
    self._bufferString = @"";
    unichar preChar = 0;
    
    while(YES){
        if((([[NSString stringWithCharacters:&theChar length:1] isEqualToString:quotesType]) && (preChar != 0x005C)) || (theChar == 0x00B6)){ //0x005C is '\\' in unicode.
            break;
        }
        
        self._bufferString = [self._bufferString stringByAppendingString:[NSString stringWithCharacters:&theChar length:1]];
        preChar = theChar;
        theChar = [self.scriptReader nextCharacter];
        
        if(theChar != '\n' && theChar != '\r'){
            self.currentLine++;
        }
    }
    
    NSUInteger tokenType = [[tokens objectForKey:@"STRING_TOKEN"] unsignedIntegerValue];
    NSString *subBuffer = @"";
    
    if(self.ifInTheProcessOf_GAMEDEFINEDFUNCTION_STATE){
        theChar = [self.scriptReader nextCharacter];
        while(YES){
            if(theChar == ';' || theChar == '\n' || theChar == '\r' || theChar == ',' || theChar == 0x00B6){
                if(theChar == '\n' || theChar == '\r' || theChar == ','){
                    [self.scriptReader retractNCharacter:1];
                }
                break;
            }

            subBuffer = [subBuffer stringByAppendingString:[NSString stringWithCharacters:&theChar length:1]];
            theChar = [self.scriptReader nextCharacter];
        }
        
        if(![[self.scriptHelper trimTheWhiteSpaceOfAString:subBuffer] isEqualToString:@""]){
            unichar tempChar = '"';
            NSString *tempString = [NSString stringWithCharacters:&tempChar length:1];
            
            self._bufferString = [[[tempString stringByAppendingString:self._bufferString] stringByAppendingString:tempString] stringByAppendingString:subBuffer];
            tokenType = [[tokens objectForKey:@"OTHER_STRING_TOKEN"] unsignedIntegerValue];
        }
    }
    
    self.currentStatus = START_STATE;
    return [self makeTokenWithType:tokenType andText:self._bufferString];
}

- (NSUInteger)processOTHER_STRING_STATE{
    NSDictionary *tokens = self.scriptHelper.scriptTokens;
    [self.scriptReader retractNCharacter:1];
    unichar theChar = [self.scriptReader nextCharacter];
    self._bufferString = @"";
    
    while(YES){
        if(theChar == ';' || theChar == '\n' || theChar == '\r' || theChar == ',' || theChar == 0x00B6){
            if(theChar == '\n' || theChar == '\r' || theChar == ','){
                [self.scriptReader retractNCharacter:1];
            }
            break;
        }
        
        self._bufferString = [self._bufferString stringByAppendingString:[NSString stringWithCharacters:&theChar length:1]];
        theChar = [self.scriptReader nextCharacter];
    }
    
    self.currentStatus = START_STATE;
    
    NSUInteger newTokenType = [[tokens objectForKey:@"OTHER_STRING_TOKEN"] unsignedIntegerValue];
    return [self makeTokenWithType:newTokenType andText:self._bufferString];
}















@end


















