//
//  SGScriptParser.m
//  SoraGal
//
//  Created by conans on 1/22/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGScriptParser.h"

#define EOS_TOKEN 0
#define JS_TOKEN 1
#define NEWLINE_TOKEN 2
#define EMPTYLINE_TOKEN 3
#define COMMA_TOKEN 4
#define SEMICOLON_TOKEN 5
#define DOT_TOKEN 6
#define STRING_TOKEN 7
#define OTHER_STRING_TOKEN 8
#define GAMESCRIPTSTRING_TOKEN 9
#define GAMESCRIPT_GOTO_TOKEN 10
#define GAMESCRIPT_LABEL_TOKEN 11
#define GAMESCRIPT_IDENTIFIER_TOKEN 12
#define GAMESCRIPT_IF_TOKEN 13
#define GAMESCRIPT_SELECT_TOKEN 14
#define LINECOMMENT_TOKEN 15
#define BLOCKCOMMENT_TOKEN 16

@interface SGScriptParser()

@property (nonatomic, strong) SGScriptScanner *scriptScanner;
@property (nonatomic, strong) SGScriptToken *currentScriptToken;
@property (nonatomic, strong) SGScriptToken *lookAheadToken;

@property BOOL ifLookAheadTokenHasBeenUsed;

@end

@implementation SGScriptParser

- (id)initWithScannerInstance:(SGScriptScanner *)receivedScannerInstance{
    self = [super init];
    if(self){
        self.scriptScanner = receivedScannerInstance;
        self.currentScriptToken = [[SGScriptToken alloc] init];
        self.lookAheadToken = [[SGScriptToken alloc] init];
        self.ifLookAheadTokenHasBeenUsed = YES;
    }
    return self;
}

- (NSUInteger)nextToken{
    NSUInteger token = 0;
    NSDictionary *tokens = self.scriptHelper.scriptTokens;
    
    if(self.ifLookAheadTokenHasBeenUsed){
        token = [self.scriptScanner nextToken];
        while((token == [[tokens objectForKey:@"LINECOMMENT_TOKEN"] unsignedIntegerValue]) || (token == [[tokens objectForKey:@"BLOCKCOMMENT_TOKEN"] unsignedIntegerValue])){
            //Skip the comment.
            token = [self.scriptScanner nextToken];
        }
        
        self.currentScriptToken.tokenType = token;
        self.currentScriptToken.tokenText = self.scriptScanner.currentScriptToken.tokenText;
        
        return token;
    }
    else{
        self.currentScriptToken.tokenType = self.lookAheadToken.tokenType;
        self.currentScriptToken.tokenText = self.lookAheadToken.tokenText;
        self.ifLookAheadTokenHasBeenUsed = YES;
        
        return self.currentScriptToken.tokenType;
    }
}

- (NSUInteger)lookAhead{
    NSUInteger token = 0;
    NSDictionary *tokens = self.scriptHelper.scriptTokens;
    
    if(self.ifLookAheadTokenHasBeenUsed){
        token = [self.scriptScanner nextToken];
        while((token == [[tokens objectForKey:@"LINECOMMENT_TOKEN"] unsignedIntegerValue]) || (token == [[tokens objectForKey:@"BLOCKCOMMENT_TOKEN"] unsignedIntegerValue])){
            //Skip the comment.
            token = [self.scriptScanner nextToken];
        }
        
        self.lookAheadToken.tokenType = token;
        self.lookAheadToken.tokenText = self.scriptScanner.currentScriptToken.tokenText;
        self.ifLookAheadTokenHasBeenUsed = NO;
        
        return token;
    }
    else{
        return self.lookAheadToken.tokenType;
    }
}

- (void)matchNewLine{
    NSDictionary *tokens = self.scriptHelper.scriptTokens;
    self.scriptScanner.ifSkipNewLine = NO;
    
    //Skip thensemicolon
    if(([self lookAhead] == [[tokens objectForKey:@"NEWLINE_TOKEN"] unsignedIntegerValue]) || ([self lookAhead] == [[tokens objectForKey:@"EOS_TOKEN"] unsignedIntegerValue])){
        [self lookAhead];
    }
    else{
        //Needs for error report.
        NSLog(@"Expecting a new line");
    }
    
    self.scriptScanner.ifSkipNewLine = YES;
}

- (void)skipError{
    NSDictionary *tokens = self.scriptHelper.scriptTokens;
    self.scriptScanner.ifSkipNewLine = NO;
    
    while(([self lookAhead] != [[tokens objectForKey:@"NEWLINE_TOKEN"] unsignedIntegerValue]) && ([self lookAhead] != [[tokens objectForKey:@"EOS_TOKEN"] unsignedIntegerValue])){
        [self nextToken];
    }
    
    self.scriptScanner.ifSkipNewLine = YES;
}

- (SGScriptExpressionBlockNode *)parse{
    SGScriptExpressionBlockNode *rootNode = [[SGScriptExpressionBlockNode alloc] init];
    [self parseExpressions:rootNode];
    
    return rootNode;
}

- (void)parseExpressions:(SGScriptExpressionBlockNode *)expressionBlockNode{
    NSDictionary *tokens = self.scriptHelper.scriptTokens;
    
    while([self lookAhead] != [[tokens objectForKey:@"EOS_TOKEN"] unsignedIntegerValue]){
        SGScriptNode *expressionNode = [self parseExpression];
        if(expressionNode){
            [expressionBlockNode pushExpressionBlock:expressionNode];
        }
    }
}

- (SGScriptNode *)parseExpression{
    switch ([self nextToken]) {
        case GAMESCRIPTSTRING_TOKEN:{
            [self nextToken];
            SGScriptGameScriptBlockNode *node = [[SGScriptGameScriptBlockNode alloc] initWithBlockContent:self.currentScriptToken.tokenText];
            [node setLine:self.scriptScanner.currentLine];
            
            return node;
        }
            break;
            
        case GAMESCRIPT_GOTO_TOKEN:{
            [self nextToken];
            SGScriptGameScriptGotoNode *node = [self parseGameScriptGotoExpression];
            [node setLine:self.scriptScanner.currentLine];
            
            return node;
        }
            break;
            
        case GAMESCRIPT_LABEL_TOKEN:{
            SGScriptGameScriptLabelNode *node = [self parseGameScriptLabelExpression];
            [node setLine:self.scriptScanner.currentLine];
            
            return node;
        }
            break;
            
        case GAMESCRIPT_IDENTIFIER_TOKEN:{
            SGScriptGameScriptCallFunctionNode *node = [self parseGameScriptCallFunction];
            [node setLine:self.scriptScanner.currentLine];
            
            return node;
        }
            break;
            
        case JS_TOKEN:{
            [self nextToken];
            SGScriptJavaScriptNode *node = [[SGScriptJavaScriptNode alloc] initWithScriptText:self.currentScriptToken.tokenText];
            [node setLine:self.scriptScanner.currentLine];
            
            return node;
        }
            break;
            
        case STRING_TOKEN:{
            [self nextToken];
            SGScriptStringNode *node = [[SGScriptStringNode alloc] initWithData:self.currentScriptToken.tokenText];
            [node setLine:self.scriptScanner.currentLine];
            
            return node;
        }
            break;
            
        case OTHER_STRING_TOKEN:{
            [self nextToken];
            SGScriptOtherStringNode *node = [[SGScriptOtherStringNode alloc] initWithData:self.currentScriptToken.tokenText];
            [node setLine:self.scriptScanner.currentLine];
            
            return node;
        }
            break;
            
        default:{
            [self nextToken];
        }
            break;
    }
    
    return nil;
}

- (NSArray *)parseGameScriptCommandParameters{
    NSDictionary *tokens = self.scriptHelper.scriptTokens;
    NSMutableArray *tempParameters = [[NSMutableArray alloc] init];
    SGScriptNode *expression = [[SGScriptNode alloc] init];
    
    self.scriptScanner.ifSkipNewLine = NO;
    while(([self lookAhead] != [[tokens objectForKey:@"NEWLINE_TOKEN"] unsignedIntegerValue]) && ([self lookAhead] != [[tokens objectForKey:@"EOS_TOKEN"] unsignedIntegerValue]) && ([self lookAhead] != [[tokens objectForKey:@"SEMICOLON_TOKEN"] unsignedIntegerValue])){
        
        if([self lookAhead] != [[tokens objectForKey:@"COMMA_TOKEN"] unsignedIntegerValue]){
            expression = [self parseExpression];
        }
        else{
            [tempParameters addObject:expression];
            expression = nil;
            [self nextToken];
        }
    }
    
    if(expression != nil){
        [tempParameters addObject:expression];
    }
    
    if([self lookAhead] == [[tokens objectForKey:@"SEMICOLON_TOKEN"] unsignedIntegerValue]){
        [self nextToken];
    }
    
    self.scriptScanner.ifSkipNewLine = YES;
    NSArray *parameters = [NSArray arrayWithArray:tempParameters];
    tempParameters = nil;
    
    return parameters;
}

- (SGScriptGameScriptGotoNode *)parseGameScriptGotoExpression{
    NSArray *parameters = [self parseGameScriptCommandParameters];
    [self matchNewLine];
    
    SGScriptGameScriptGotoNode *node = [[SGScriptGameScriptGotoNode alloc] initWithParameters:parameters];
    
    return node;
}

- (SGScriptGameScriptLabelNode *)parseGameScriptLabelExpression{
    NSDictionary *tokens = self.scriptHelper.scriptTokens;
    
    [self nextToken];
    NSString *labelName;
    
    if([self lookAhead] == [[tokens objectForKey:@"STRING_TOKEN"] unsignedIntegerValue]){
        [self nextToken];
        labelName = self.currentScriptToken.tokenText;
        [self matchNewLine];
        
        SGScriptGameScriptLabelNode *node = [[SGScriptGameScriptLabelNode alloc] initWithLabelName:labelName];
        return node;
    }
    else{
        [self skipError];
        return nil;
    }
}

- (SGScriptGameScriptCallFunctionNode *)parseGameScriptCallFunction{
    NSString *functionName;
    
    [self nextToken];
    functionName = self.currentScriptToken.tokenText;
    NSArray *parameters = [self parseGameScriptCommandParameters];
    [self matchNewLine];
    
    SGScriptGameScriptCallFunctionNode *node = [[SGScriptGameScriptCallFunctionNode alloc] initWithFunctionName:functionName andParameters:parameters];
    return node;
}
































@end
