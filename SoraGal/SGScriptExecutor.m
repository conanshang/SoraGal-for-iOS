//
//  SGScriptExecutor.m
//  SoraGal
//
//  Created by conans on 1/16/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGScriptExecutor.h"
#import "SGProcessCenter.h"
#import "SGScriptReader.h"
#import "SGScriptScanner.h"
#import "SGScriptParser.h"
#import "SGScriptExpression.h"
#import "SGScriptCommand.h"
#import "SGScriptHelper.h"

@interface SGScriptExecutor()

@property (nonatomic, strong) SGScriptReader *scriptReader;
@property (nonatomic, strong) SGScriptScanner *scriptScanner;
@property (nonatomic, strong) SGScriptParser *scriptParser;

@property (nonatomic, strong) NSString *gameScriptString;
@property (nonatomic, strong) NSArray *gameScriptCommandArray;
@property (nonatomic, strong) NSDictionary *gameLabelDictionary; //All the tittles.
@property NSUInteger currentScriptCommandPosition;
@property (nonatomic, strong) NSMutableArray *tempGameCommandWaitingArray;


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
        [self processGameScriptString:receivedGameScriptString];
        [self initialOtherVariables];
    }
    return self;
}

- (void)loadAnotherScriptString:(NSString *)receivedAnotherGameScriptString{
    [self processGameScriptString:receivedAnotherGameScriptString];
}

- (void)processGameScriptString:(NSString *)receivedGameScriptString{
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
    
    self.currentScriptCommandPosition = 0;
}

- (void)initialOtherVariables{
    self.tempGameCommandWaitingArray = [[NSMutableArray alloc] init];
}

//- (NSDictionary *)saveGame{
//    NSUInteger tempScriptCommandPosition = self.currentScriptCommandPosition - 1; //Mention!! The situation of -1.
//    
//    if(tempScriptCommandPosition > [self.gameScriptCommandArray count]){
//        tempScriptCommandPosition = [self.gameScriptCommandArray count] - 1;
//    }
//    
//    NSDictionary *tempGameScenarios = [NSDictionary dictionaryWithDictionary:self.gameScenarios];
//    
//    NSDictionary *tempSaveDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.optionalVariables, @"global", tempGameScenarios, @"scenarios", tempScriptCommandPosition, @"commandPosition", nil];
//    
//    
//    return tempSaveDataDictionary;
//}
//
//- (void)loadGameFromSaveData:(NSDictionary *)saveData{
//    // this.scriptManager.messageCenter.broadcast("LOADEVENT",null);
//    
//    self.optionalVariables = [saveData objectForKey:@"global"];
//    
//    //    for(var key in data.environ){
//    //        if(data.environ.hasOwnProperty(key)){
//    //            var cmd = data.environ[key];
//    //            this[cmd.functionName].apply(this,cmd.params);
//    //        }
//    //    }
//    
//    self.currentScriptCommandPosition = [[saveData objectForKey:@"commandPosition"] unsignedIntegerValue];
//}

- (BOOL)next{
    if(self.currentScriptCommandPosition > [self.gameScriptCommandArray count]){
        return NO;
    }
    
    SGScriptNode *expression = [self.gameScriptCommandArray objectAtIndex:self.currentScriptCommandPosition];
    [self executeExpression:expression];
    self.currentScriptCommandPosition++;
    
    self.gameCommandWaitingArray = self.tempGameCommandWaitingArray;
    self.tempGameCommandWaitingArray = nil;
    
    return YES;
}

- (void)executeExpression:(id)expression{
    if([expression isKindOfClass:[SGScriptJavaScriptNode class]]){
        NSLog(@"Not support JavaScript command in iOS version.");
        return;
    }
    
    if([expression isKindOfClass:[SGScriptGameScriptGotoNode class]]){  //Need add Multi-script files support.
        SGScriptGameScriptGotoNode *tempGotoNode = expression;
        NSArray *gotoParameters = [self processExpressionParameters:tempGotoNode.parameters];
        [self gotoLabel:[gotoParameters objectAtIndex:0]];
        
        return;
    }
    
    if([expression isKindOfClass:[SGScriptGameScriptBlockNode class]]){
        SGScriptGameScriptBlockNode *tempBlockNode = expression;
        [self outputDialogString:tempBlockNode.blockContent];
        
        return;
    }
    
    if([expression isKindOfClass:[SGScriptGameScriptCallFunctionNode class]]){
        SGScriptGameScriptCallFunctionNode *tempFunctionNode = expression;
        [self callScriptFunction:tempFunctionNode];
        
        return;
    }
}

- (NSArray *)processExpressionParameters:(NSArray *)parameters{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [parameters count]; i++){
        if([[parameters objectAtIndex:i] isKindOfClass:[SGScriptStringNode class]]){
            SGScriptStringNode *tempStringNode = [parameters objectAtIndex:i];
            [result insertObject:tempStringNode.data atIndex:i];
            
            continue;
        }
        
        if([[parameters objectAtIndex:i] isKindOfClass:[SGScriptOtherStringNode class]]){
            SGScriptOtherStringNode *tempOtherStringNode = [parameters objectAtIndex:i];
            
            if([tempOtherStringNode.data isKindOfClass:[NSString class]]){
                [result insertObject:tempOtherStringNode.data atIndex:i];
            }
            else{
                NSLog(@"Not support JavaScript command in iOS version.");
            }
            
            continue;
        }
    }
    
    return result;
}

- (void)callScriptFunction:(SGScriptGameScriptCallFunctionNode *)functionNode{
    
}

- (void)outputDialogString:(NSString *)string{
    NSDictionary *processResult = [self processCharacterTextImageAndVoiceInDialogString:string];
    
    if([processResult objectForKey:@"name"]){
        SGScriptCommand *command = [SGScriptCommand createCommandWithCommandName:@"setCharacterName" andCommandParameters:[NSArray arrayWithObject:[processResult objectForKey:@"name"]]];
        [self.tempGameCommandWaitingArray addObject:command];
    }
    
    if([processResult objectForKey:@"image"]){
        SGScriptCommand *command = [SGScriptCommand createCommandWithCommandName:@"setCharacterImage" andCommandParameters:[NSArray arrayWithObject:[processResult objectForKey:@"image"]]];
        [self.tempGameCommandWaitingArray addObject:command];
    }
    
    if([processResult objectForKey:@"voice"]){
        SGScriptCommand *command = [SGScriptCommand createCommandWithCommandName:@"playCharacterVoice" andCommandParameters:[NSArray arrayWithObject:[processResult objectForKey:@"voice"]]];
        [self.tempGameCommandWaitingArray addObject:command];
    }
    
    NSString *dialogText = [processResult objectForKey:@"dialogText"];
    SGScriptCommand *newCommand = [SGScriptCommand createCommandWithCommandName:@"showDialogText" andCommandParameters:[NSArray arrayWithObject:dialogText]];
    [self.tempGameCommandWaitingArray addObject:newCommand];    
}

- (void)gotoLabel:(NSString *)labelName{
    if(![self.gameLabelDictionary objectForKey:labelName]){
        NSLog(@"No such label");
    }
    
    self.currentScriptCommandPosition = [[self.gameLabelDictionary objectForKey:labelName] unsignedIntegerValue];
}

- (NSDictionary *)processCharacterTextImageAndVoiceInDialogString:(NSString *)sourceString{
    NSString *characterProperty = @"";
    NSString *dialogText = @"";
    NSDictionary *result;
    
    //Find '：'
    unichar fullWidthForm = 0xFF1A;
    NSRange symbolRange = [sourceString rangeOfString:[NSString stringWithCharacters:&fullWidthForm length:1]];
    NSUInteger theLocation = symbolRange.location;
    NSUInteger theLength = symbolRange.length;
    
    //Seperate string by '：'
    if(theLength != 0){
        characterProperty = [sourceString substringToIndex:theLocation];
        dialogText = [sourceString substringFromIndex:theLocation + 1];
    }
    else{
        dialogText = sourceString;
    }
    
    //Use regular expression to seperate name, image and voice.
    NSString *characterName;
    NSString *characterImage;
    NSString *characterVoice;
    
    if(![characterProperty isEqualToString:@""]){
        //Seprate the characterProperty string.
        NSArray *characterPropertyArray = [characterProperty componentsSeparatedByString:@","];
        
        for(NSString *string in characterPropertyArray){
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\S+?)\\((\\S+?)\\)" options:NSRegularExpressionCaseInsensitive error:&error];
            NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
            
            if([matches count]>0){
                //Matched string positions.
                NSTextCheckingResult *matchResult = [matches objectAtIndex:0];
                NSRange firstMatch = [matchResult rangeAtIndex:1];
                NSRange secondMatch = [matchResult rangeAtIndex:2];
                
                //Matched string.
                NSString *firstString = [string substringWithRange:firstMatch];
                NSString *secondString = [string substringWithRange:secondMatch];
                
                //Process character information.
                if([firstString isEqualToString:@"voice"]){
                    characterVoice = secondString;
                }
                else{
                    characterName = firstString;
                    characterImage = secondString;
                }
            }
            else if([matches count] == 0){
                characterName = string;
            }
        }
        
        //Put information to the result.
        result = [NSDictionary dictionaryWithObjectsAndKeys:characterName, @"name", characterImage, @"image", characterVoice, @"voice", dialogText, @"dialogText", nil];
    }
    
    return result;
}












@end












































