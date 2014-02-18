//
//  SGCommandFormater.m
//  SoraGal
//
//  Created by conans on 2/18/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGCommandFormater.h"
#import "SGProcessCenter.h"
#import "SGScriptCommand.h"

@interface SGCommandFormater()

//Class properities.
@property (nonatomic, strong) SGProcessCenter *soraGalProcessCenter;

//Variables.
@property (nonatomic, strong) NSMutableArray *currentCommandsArray;

@end

@implementation SGCommandFormater

- (id)init{
    self = [super init];
    if(self){
        //Init the script processor.
        self.soraGalProcessCenter = [[SGProcessCenter alloc] init];
    }
    return self;
}

- (void)formatNextCommandInScript{
    //Get the next commands array.
    NSArray *commandArray = [self.soraGalProcessCenter nextLine];
    //Skip the array if it contains no command.
    while(([commandArray count] == 0) || (commandArray == nil)){
        commandArray = [self.soraGalProcessCenter nextLine];
    }
    
    if(commandArray){
        //Format the commands.
        self.currentCommandsArray = [[NSMutableArray alloc] init];
        NSArray *singleCommandArray;
        NSArray *currentCharacter;
        
        for(int i = 0; i < [commandArray count]; i++){
            SGScriptCommand *command = [commandArray objectAtIndex:i];  //Get the command.
            NSString *commandName = command.commandName;  //Cache command name.
            NSArray *commandParameters = command.commandParameters;  //Cache command parameters.
            
            //BGM related.
            if([commandName isEqualToString: @"setBGM"]){
                singleCommandArray = [NSArray arrayWithObjects:@"playBackgroundMusic", [commandParameters objectAtIndex:0], @"m4a", nil];
            }
            //Image related.
            else if ([commandName isEqualToString:@"setBG"]){
                if([commandParameters count] == 1){
                    singleCommandArray = [NSArray arrayWithObjects:@"changeBackground", [commandParameters objectAtIndex:0], @"jpg", @"1000", nil];
                }
                else if([commandParameters count] == 2){
                    singleCommandArray = [NSArray arrayWithObjects:@"changeBackground", [commandParameters objectAtIndex:0], @"jpg", [commandParameters objectAtIndex:1], nil];
                }
            }
            else if ([commandName isEqualToString:@"setCG"]){
                if([commandParameters count] == 1){
                    singleCommandArray = [NSArray arrayWithObjects:@"changeCGImage", [commandParameters objectAtIndex:0], @"jpg", @"1000", nil];
                }
                else if([commandParameters count] == 2){
                    singleCommandArray = [NSArray arrayWithObjects:@"changeCGImage", [commandParameters objectAtIndex:0], @"jpg", [commandParameters objectAtIndex:1], nil];
                }
            }
            else if([commandName isEqualToString:@"setBGColor"]){
                singleCommandArray = [NSArray arrayWithObjects:@"changePureColorBackground", [commandParameters objectAtIndex:0], nil];
            }
            //Character related/
            else if([commandName isEqualToString:@"setCharacterName"]){
                //Save the current character name to a temp string.
                currentCharacter = [commandParameters objectAtIndex:0];
            }
            else if([commandName isEqualToString:@"setCharacterImage"]){
                if([commandParameters count] == 1){
                    singleCommandArray = [NSArray arrayWithObjects:@"changeCharacterImage", [commandParameters objectAtIndex:0], @"png", @"1000", nil];
                }
                else if([commandParameters count] == 2){
                    singleCommandArray = [NSArray arrayWithObjects:@"changeCharacterImage", [commandParameters objectAtIndex:0], @"png", [commandParameters objectAtIndex:1], nil];
                }
            }
            else if([commandName isEqualToString:@"playCharacterVoice"]){
                singleCommandArray = [NSArray arrayWithObjects:@"playCharacterVoice", [commandParameters objectAtIndex:0], @"m4a", nil];
            }
            else if([commandName isEqualToString:@"showDialogText"]){
                if(currentCharacter){
                    singleCommandArray = [NSArray arrayWithObjects:@"showDialog", currentCharacter, [commandParameters objectAtIndex:0], nil];
                    
                    currentCharacter = nil;
                }
                else{
                    singleCommandArray = [NSArray arrayWithObjects:@"showDialog", @"", [commandParameters objectAtIndex:0], nil];
                }
            }
            else if([commandName isEqualToString:@"playCharacterVoice"]){
                singleCommandArray = [NSArray arrayWithObjects:@"@setVoice", [commandParameters objectAtIndex:0], @"m4a", nil];
            }
            else if([commandName isEqualToString:@"playCharacterVoice"]){
                singleCommandArray = [NSArray arrayWithObjects:@"@setSound", [commandParameters objectAtIndex:0], @"m4a", nil];
            }
            //Video related.
            else if([commandName isEqualToString:@"playVideo"]){
                //NSLog(@"SGCommandFormater : Suppported command %@, under development.", commandName);
            }
            //Settings related.
            else if([commandName isEqualToString:@"set"]){
                //NSLog(@"SGCommandFormater : Suppported command %@, under development.", commandName);
            }
            else{
                //NSLog(@"SGCommandFormater : Unsuppported command %@", commandName);
            }
            
            if(singleCommandArray){
                [self.currentCommandsArray addObject:singleCommandArray];
                singleCommandArray = nil;
            }
        }
    }
    else{
        self.currentCommandsArray  = nil;
        NSLog(@"SGCommandFormater : Reach the command ends.");
    }
}

- (NSArray *)getNextCommand{
    [self formatNextCommandInScript];
    
    if(self.currentCommandsArray){
        return [NSArray arrayWithArray:self.currentCommandsArray];
    }
    else{
        return nil;
    }  
}



















@end
