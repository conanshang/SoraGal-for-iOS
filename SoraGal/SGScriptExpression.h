//
//  SGScriptExpression.h
//  SoraGal
//
//  Created by conans on 1/23/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGScriptExpression : NSObject



@end

#pragma mark SGScriptNode

@interface SGScriptNode : NSObject

@property NSUInteger line;
@property unichar valueType;
- (void)putLineValue:(NSUInteger)line;

@end

#pragma mark SGScriptExpressionBlockNode

@interface SGScriptExpressionBlockNode : SGScriptNode

@property (nonatomic, strong) NSMutableArray *expressions;
- (void)pushExpressionBlock:(SGScriptNode *)expressionBlock;

@end

#pragma mark SGScriptStringNode

@interface SGScriptStringNode : SGScriptNode

@property (nonatomic, strong) NSString *data;

- (id)initWithData:(NSString *)receivedData;

@end

#pragma mark SGScriptOtherStringNode

@interface SGScriptOtherStringNode : SGScriptNode

@property (nonatomic, strong) NSString *data;
- (id)initWithData:(NSString *)receivedData;

@end

#pragma mark SGScriptGameScriptGotoNode

@interface SGScriptGameScriptGotoNode : SGScriptNode

@property (nonatomic, strong) NSArray *parameters;
- (id)initWithParameters:(NSArray *)receivedParameters;

@end

#pragma mark SGScriptGameScriptLabelNode

@interface SGScriptGameScriptLabelNode : SGScriptNode

@property (nonatomic, strong) NSString *labelName;
- (id)initWithLabelName:(NSString *)receivedLabelName;

@end

#pragma mark SGScriptGameScriptBlockNode

@interface SGScriptGameScriptBlockNode : SGScriptNode

@property (nonatomic, strong) NSString *blockContent;
- (id)initWithBlockContent:(NSString *)receivedBlockContent;

@end

#pragma mark SGScriptGameScriptCallFunctionNode

@interface SGScriptGameScriptCallFunctionNode : SGScriptNode

@property (nonatomic, strong) NSString *functionName;
@property (nonatomic, strong) NSArray *parameters;
- (id)initWithFunctionName:(NSString *)receivedFunctionName andParameters:(NSArray *)receivedParameters;

@end

#pragma mark SGScriptJavaScriptNode

@interface SGScriptJavaScriptNode : SGScriptNode

@property (nonatomic, strong) NSString *scriptText;
- (id)initWithScriptText:(NSString *)receivedScriptText;

@end

















