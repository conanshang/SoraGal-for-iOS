//
//  SGScriptExecutor.m
//  SoraGal
//
//  Created by conans on 1/16/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGScriptExecutor.h"
#import "SGScriptReader.h"
#import "SGScriptScanner.h"
#import "SGScriptParser.h"
#import "SGScriptToken.h"
#import "SGScriptExpression.h"
#import "SGScriptHelper.h"

@interface SGScriptExecutor()

@property (nonatomic, strong) SGScriptReader *scriptReader;
@property (nonatomic, strong) SGScriptScanner *scriptScanner;
@property (nonatomic, strong) SGScriptParser *scriptParser;

@property (nonatomic, strong) NSString *gameScriptString;
@property (nonatomic, strong) NSArray *gameScriptCommandArray;
@property (nonatomic, strong) NSDictionary *gameLabelDictionary;

@end

@implementation SGScriptExecutor

- (id)init{
    self = [super init];
    if(self){
    
    }
    return self;
}

- (id)initWithGameScriptString:(NSString *)receivedGameScriptString{
    self = [super init];
    if(self){
        self.gameScriptString = receivedGameScriptString;
        self.scriptReader = [[SGScriptReader alloc] initWithString:self.gameScriptString];
        self.scriptScanner = [[SGScriptScanner alloc] initWithReaderInstance:self.scriptReader];
        self.scriptParser = [[SGScriptParser alloc] initWithScannerInstance:self.scriptScanner];
        
        self.gameScriptCommandArray = [[self.scriptParser parse] expressions];
        
        NSMutableDictionary *tempGameLabelDictionary = [[NSMutableDictionary alloc] init];
        for(int i=0; i<[self.gameScriptCommandArray count]; i++){
            if([[self.gameScriptCommandArray objectAtIndex:i] isKindOfClass:[SGScriptGameScriptLabelNode class]]){
                [tempGameLabelDictionary setObject:[NSNumber numberWithInt:i] forKey:[[self.gameScriptCommandArray objectAtIndex:i] labelName]];
            }
        }
        
        self.gameLabelDictionary = tempGameLabelDictionary;
        tempGameLabelDictionary = nil;
    }
    return self;
}





@end



































