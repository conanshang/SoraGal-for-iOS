//
//  SGTestFunctionsViewController.m
//  SoraGal
//
//  Created by conans on 1/16/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGTestFunctionsViewController.h"
#import "SGProcessCenter.h"
#import "SGScriptExecutor.h"
#import "SGScriptReader.h"
#import "SGScriptScanner.h"
#import "SGScriptParser.h"
#import "SGScriptHelper.h"
#import "SGScriptToken.h"
#import "SGAudioModule.h"
#import "SGTestSegueViewController.h"


@interface SGTestFunctionsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *testDialogView;

@property (strong, nonatomic) NSString *testDialogString;

@property (strong, nonatomic) SGScriptReader *testSGScriptReader;
@property (strong, nonatomic) SGScriptScanner *testScriptScanner;
@property (strong, nonatomic) SGScriptParser *testScriptParser;
@property (strong, nonatomic) SGScriptExecutor *testScriptExecutor;
@property (nonatomic, strong) SGProcessCenter *testScriptProcessCenter;
@property (strong, nonatomic) SGScriptHelper *testSGScriptHelper;
@property (nonatomic, strong) SGAudioModule *soraGalAudioModule;

@end

@implementation SGTestFunctionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //[self getStringDataFromFile];
    //[self testReader];
    //[self testScanner];
    //[self testParser];
    //[self testExecutor];
    //[self testProcessCenter];
    
    self.soraGalAudioModule = [[SGAudioModule alloc] init];
    //[self startMusic];
    [self testTheFolders];
    
}

- (void)getStringDataFromFile{
    //The path of the script txt.
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"scriptExample" ofType:@"txt"];
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"TestScript" ofType:@"txt"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gameConfiguration" ofType:@"txt"];
    //Put the script to a string.
    self.testDialogString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

- (void)displayCharInTextView{
    self.testSGScriptHelper = [[SGScriptHelper alloc] init];
    [self.testSGScriptHelper createScriptTokens];
    NSString *theString2 = [self.testSGScriptHelper.scriptTokens description];
    //NSString *theString = [self.testSGScriptHelper.scriptTokens objectForKey:@"JS_TOKEN"];
    if([[self.testSGScriptHelper.scriptTokens objectForKey:@"JS_TOKEN"] isKindOfClass:[NSNumber class]]){
        NSLog(@"It's NSNumber.");
    }
    
    self.testDialogView.text = theString2;
}

- (void)testReader{
    self.testSGScriptReader = [[SGScriptReader alloc] initWithString:self.testDialogString];
    
    unichar theChar = 0;
    NSString *testString = @"Start : \n";
    
    int i = 16;
    while (YES) {
        theChar = [self.testSGScriptReader nextCharacter];
        testString = [testString stringByAppendingString:[NSString stringWithCharacters:&theChar length:1]];
        
        if(theChar == 0x00B6){
            break;
        }
        i--;
    }
    
    self.testDialogView.text = testString;
}

- (void)testScanner{
    self.testSGScriptReader = [[SGScriptReader alloc] initWithString:self.testDialogString];
    self.testScriptScanner = [[SGScriptScanner alloc] initWithReaderInstance:self.testSGScriptReader];
    
    self.testSGScriptHelper = [[SGScriptHelper alloc] init];
    [self.testSGScriptHelper createScriptTokens];
    NSString *testString = @"Start : \n";
    
    int i = 30;
    while(YES){
        NSUInteger testData = [self.testScriptScanner nextToken];
        NSString *tokenType = [self.testSGScriptHelper.backwardScriptTokensMap objectAtIndex:testData];
        
        SGScriptToken *token = self.testScriptScanner.currentScriptToken;
        NSString *tokenString = token.tokenText;
        
        testString = [[testString stringByAppendingString:tokenType] stringByAppendingString:@" () "];
        if(tokenString){
            testString = [[testString stringByAppendingString:tokenString] stringByAppendingString:@"\n"];
        }
        else{
            testString = [testString stringByAppendingString:@"\n"];
        }
        
        
        if([tokenType isEqualToString:@"EOS_TOKEN"]){
            break;
        }
        i--;
    }
    
    self.testDialogView.text = testString;

}

- (void)testParser{
    self.testSGScriptReader = [[SGScriptReader alloc] initWithString:self.testDialogString];
    self.testScriptScanner = [[SGScriptScanner alloc] initWithReaderInstance:self.testSGScriptReader];
    self.testScriptParser = [[SGScriptParser alloc] initWithScannerInstance:self.testScriptScanner];
    
    SGScriptExpressionBlockNode *node = [self.testScriptParser parse];
    NSArray *resultArray = node.expressions;
    
    NSString *resultString = [resultArray description];
    
    self.testDialogView.text = resultString;
}

- (void)testExecutor{
    self.testScriptExecutor = [[SGScriptExecutor alloc] initWithGameScriptString:self.testDialogString];
    
    [self.testScriptExecutor next];
    NSArray *commandArray = self.testScriptExecutor.waitingCommandArray;
    
    self.testDialogView.text = [commandArray description];
}

- (void)testProcessCenter{
    self.testScriptProcessCenter = [[SGProcessCenter alloc] init];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    BOOL ifContinue = YES;
    while(ifContinue){
        NSArray *result = [self.testScriptProcessCenter nextLine];
        if(result){
            [resultArray addObject:result];
        }
        else{
            ifContinue = NO;
        }  
    }
    
    //NSMutableDictionary *gameStatusDictionary = self.testScriptProcessCenter.gameStatus;
    
    //self.testDialogView.text = [NSString stringWithFormat:@"%lu", (unsigned long)[gameStatusDictionary count]];
}

////Test auudio start and stop.
- (void)startMusic{
    [self.soraGalAudioModule playBackgroundMusic:@"02" andType:@"mp3"];
}

- (IBAction)startVoice:(id)sender {
    [self.soraGalAudioModule playBackgroundMusic:@"01" andType:@"m4a"];

}

- (IBAction)stopVoice:(id)sender {
    [self.soraGalAudioModule stopBackgroundMusic];

}

//Test folders.
- (void)testTheFolders{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"eden_1" ofType:@"jpg" inDirectory:@"GameData/CGs"];
    //NSString *path2 = [[NSBundle mainBundle] pathForResource:@"c1" ofType:@"jpg"];
    self.testDialogView.text = path;
}

//Test unwind modal segue.
- (IBAction)unwindFromViewController:(UIStoryboardSegue *)sender {
    SGTestSegueViewController *testController = sender.sourceViewController;
    float value = testController.testSlider.value;
    NSString *string = [NSString stringWithFormat:@"%f", value];
    
    self.testDialogView.text = string;
}











- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
