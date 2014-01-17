//
//  SGTestFunctionsViewController.m
//  SoraGal
//
//  Created by conans on 1/16/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGTestFunctionsViewController.h"
#import "SGScriptHelper.h"


@interface SGTestFunctionsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *testDialogView;

@property (strong, nonatomic) NSString *testDialogString;

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
    [self displayCharInTextView];
}

- (void)getStringDataFromFile{
    //The path of the script txt.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"scriptExample" ofType:@"txt"];
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





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
