//
//  SGScriptExpression.m
//  SoraGal
//
//  Created by conans on 1/23/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGScriptExpression.h"

@implementation SGScriptExpression

@end

#pragma mark SGScriptNode

@implementation SGScriptNode

- (void)putLineValue:(NSUInteger)line{
    self.line = line;
}

@end

#pragma mark SGScriptExpressionBlockNode

@implementation SGScriptExpressionBlockNode

- (id)init{
    self = [super init];
    if(self){
        self.expressions = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)pushExpressionBlock:(SGScriptNode *)expressionBlock{
    [self.expressions addObject:expressionBlock];
}

@end

#pragma mark SGScriptStringNode

@implementation SGScriptStringNode

- (id)initWithData:(NSString *)receivedData{
    self = [super init];
    if(self){
        self.data = receivedData;
    }
    return self;
}

@end

#pragma mark SGScriptOtherStringNode

@implementation SGScriptOtherStringNode

- (id)initWithData:(NSString *)receivedData{
    self = [super init];
    if(self){
        self.data = receivedData;
    }
    return self;
}

@end

#pragma mark SGScriptGameScriptGotoNode

@implementation SGScriptGameScriptGotoNode

- (id)initWithParameters:(NSArray *)receivedParameters{
    self = [super init];
    if(self){
        self.parameters = receivedParameters;
    }
    return self;
}

@end

#pragma mark SGScriptGameScriptLabelNode

@implementation SGScriptGameScriptLabelNode

- (id)initWithLabelName:(NSString *)receivedLabelName{
    self = [super init];
    if(self){
        self.labelName = receivedLabelName;
    }
    return self;
}

@end

#pragma mark SGScriptGameScriptBlockNode

@implementation SGScriptGameScriptBlockNode

- (id)initWithBlockContent:(NSString *)receivedBlockContent{
    self = [super init];
    if(self){
        self.blockContent = receivedBlockContent;
    }
    return self;
}

@end

#pragma mark SGScriptGameScriptCallFunctionNode

@implementation SGScriptGameScriptCallFunctionNode

- (id)initWithFunctionName:(NSString *)receivedFunctionName andParameters:(NSArray *)receivedParameters{
    self = [super init];
    if(self){
        self.functionName = receivedFunctionName;
        self.parameters = receivedParameters;
    }
    return self;
}

@end

#pragma mark SGScriptJavaScriptNode

@implementation SGScriptJavaScriptNode

- (id)initWithScriptText:(NSString *)receivedScriptText{
    self = [super init];
    if(self){
        self.scriptText = receivedScriptText;
    }
    return self;
}

@end
























