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


@interface SGTestFunctionsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *testDialogView;

@property (strong, nonatomic) NSString *testDialogString;

@property (strong, nonatomic) SGScriptReader *testSGScriptReader;
@property (strong, nonatomic) SGScriptScanner *testScriptScanner;
@property (strong, nonatomic) SGScriptParser *testScriptParser;
@property (strong, nonatomic) SGScriptExecutor *testScriptExecutor;
@property (nonatomic, strong) SGProcessCenter *testScriptProcessCenter;
@property (strong, nonatomic) SGScriptHelper *testSGScriptHelper;

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
	
    [self getStringDataFromFile];
    //[self testReader];
    //[self testScanner];
    //[self testParser];
    //[self testExecutor];
    [self testProcessCenter];
    
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
    
    while([self.testScriptProcessCenter nextLine]){
        [resultArray addObject:self.testScriptProcessCenter.testCommandArray];
    }
    
    self.testDialogView.text = [NSString stringWithFormat:@"%lu", (unsigned long)[resultArray count]];
}























- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
