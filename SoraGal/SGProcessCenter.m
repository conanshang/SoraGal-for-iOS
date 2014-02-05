//
//  SGProcessCenter.m
//  SoraGal
//
//  Created by conans on 2/3/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGProcessCenter.h"
#import "SGScriptExecutor.h"
#import "SGScriptCommand.h"

@interface SGProcessCenter()

@property (nonatomic, strong) SGScriptExecutor *gameExecutor;

@property (nonatomic, strong) NSDictionary *gameConfigMap;

@end

@implementation SGProcessCenter

- (id)init{
    self = [super init];
    if(self){
        [self initialGameEnvironment];
    }
    return self;
}

- (void)initialGameEnvironment{
    //Load the configuration file.
    [self loadGameConfiguration];
    
    //Create the SGScriptExecutor instance.
    [self createScriptExecutorInstance];
}

- (void)loadGameConfiguration{
    NSMutableDictionary *configProcessedMap = [[NSMutableDictionary alloc] init];
    
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"gameConfiguration" ofType:@"txt"];
    NSString *configString = [NSString stringWithContentsOfFile:configPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *configArray = [configString componentsSeparatedByString:@";"];
    
    for(NSString *string in configArray){
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(.+)\\s+:\\s+\\((\\S+)\\)" options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
        
        if([matches count]>0){
            //Matched string positions.
            NSTextCheckingResult *matchResult = [matches objectAtIndex:0];
            NSRange firstMatch = [matchResult rangeAtIndex:1];
            NSRange secondMatch = [matchResult rangeAtIndex:2];
            
            //Matched string.
            NSString *firstString = [string substringWithRange:firstMatch];
            NSString *secondString = [string substringWithRange:secondMatch];
            
            //Process information.
            [configProcessedMap setObject:secondString forKey:firstString];
            
        }
    }
    
    self.gameConfigMap = [NSDictionary dictionaryWithDictionary:configProcessedMap];
}

- (NSString *)loadScriptStringFromFileUsingConfigruation{
    NSString *scriptString;
    
    NSString *scriptName = [self.gameConfigMap objectForKey:@"Script Name"];
    NSString *scriptType = [self.gameConfigMap objectForKey:@"Script Type"];
    
    if(scriptName && scriptType){
        NSString *scriptPath = [[NSBundle mainBundle] pathForResource:scriptName ofType:scriptType];
        scriptString = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:nil];
    }
    else{
        NSLog(@"No such script file found.");
    }
    
    return scriptString;
}

- (void)createScriptExecutorInstance{
    NSString *scriptString = [self loadScriptStringFromFileUsingConfigruation];
    
    self.gameExecutor = [[SGScriptExecutor alloc] initWithGameScriptString:scriptString];
}

- (BOOL)nextLine{
    if([self.gameExecutor next]){
        self.testCommandArray = self.gameExecutor.waitingCommandArray;
        return YES;
    }
    else{
        return NO;
    }
}

- (void)saveGame{
    
}

- (void)loadGame{
    
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
//}'





@end
