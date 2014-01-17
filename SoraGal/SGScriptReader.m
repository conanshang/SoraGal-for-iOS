//
//  SGScriptReader.m
//  SoraGal
//
//  Created by conans on 1/16/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGScriptReader.h"

@interface SGScriptReader()

@property (nonatomic, strong) NSString *dataString; //This is the string will operate with.
@property NSUInteger scriptStringLength;
@property NSUInteger currentPosition;

@end

@implementation SGScriptReader

- (id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

- (id)initWithString:(NSString *)scriptString{
    self = [super init];
    if(self){
        if(!scriptString){
            scriptString = [[NSString alloc] init];
        }
        //Set the dateString from the received string.
        self.dataString = scriptString;
        //Get the length of the string.
        self.scriptStringLength = [scriptString length];
        //Set the current position to the start point.
        self.currentPosition = 0;
    }
    return self;
}

- (unichar)nextCharacter{
    unichar nextChar = 0;
    //If the reveived script is empty set nextChar to -1.
    if(self.currentPosition >= self.scriptStringLength){
        nextChar = -1;
    }
    //For Windows format txt, which new line mark is /r/n.
    if(([self.dataString characterAtIndex:self.currentPosition + 1] == '\r') && ([self.dataString characterAtIndex:self.currentPosition + 2] == '\n')){
        self.currentPosition += 2; //Skip the first one - /r.
        nextChar = [self.dataString characterAtIndex:self.currentPosition];
    }
    else{
        self.currentPosition++; //Move to the next one.
        nextChar = [self.dataString characterAtIndex:self.currentPosition];
    }

    return nextChar;
}

//Retract n char from the current position.
- (void)retractNCharacter:(NSUInteger) n{
    if(self.currentPosition < n){
        self.currentPosition = 0;
    }
    else{
        self.currentPosition -= n;
    }
}

@end
