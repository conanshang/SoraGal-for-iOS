//
//  SGSaveLoadCollectionViewController.m
//  SoraGal
//
//  Created by conans on 2/23/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGSaveLoadCollectionViewController.h"
#import "SGSaveLoadItemCell.h"

#define CONVERT_DATE 0
#define CONVERT_TIME 1

#pragma mark - Save Game UICollectionViewController

@interface SGSaveCollectionViewController () <UICollectionViewDelegate, UIAlertViewDelegate>

//IBOutlets.
@property (strong, nonatomic) IBOutlet SGCustomCollectionViewFlowLayout *saveCollectionViewFlowLayout;

//Private variables.
@property (nonatomic, strong) NSMutableArray *savingDataArray;

@end

@implementation SGSaveCollectionViewController

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
    
    //Register the class.
    [self.collectionView registerClass:[SGSaveLoadItemCell class] forCellWithReuseIdentifier:@"saveGameCollectionCell"];
    
    //Setup the layout.
    [self setupTheLayout];
    
    //Set the deleagte of collectionView.
    self.collectionView.delegate = self;
    
    //Load saving data from file.
    [self loadGameSavingFile];
}

- (void)setupTheLayout{
    //Setup the flow layout.
    self.saveCollectionViewFlowLayout = [[SGCustomCollectionViewFlowLayout alloc] init];
    [self.saveCollectionViewFlowLayout setItemSize:CGSizeMake(279, 108)]; //The cell's size.
    [self.saveCollectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.saveCollectionViewFlowLayout.minimumLineSpacing = 2.0f;
    
    //Setup the collectionView.
    [self.collectionView setCollectionViewLayout:self.saveCollectionViewFlowLayout];
    self.collectionView.bounces = YES;
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
}

//Load game saving data from Document folder.
- (void)loadGameSavingFile{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *usersDocumentURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *saveDataPath = [usersDocumentURL.path stringByAppendingPathComponent:@"saveData/soraGalSavingData.plist"];
    
    if([fileManager fileExistsAtPath:saveDataPath]){
        self.savingDataArray = [NSMutableArray arrayWithContentsOfFile:saveDataPath];
    }
    else{
        //If create the saveData folder.
        [self checkIfNeedToCreateTheSaveDataFolder];
        
        //Create an empty saveData array.
        NSMutableArray *saveDataArrayCreate = [[NSMutableArray alloc] initWithCapacity:10];
        for(int i = 0; i < 10; i++){
            [saveDataArrayCreate addObject:@"NSNull"];
        }
        
        //Save the empty saveData file.
        self.savingDataArray = saveDataArrayCreate;
        BOOL ifSave = [self.savingDataArray writeToFile:saveDataPath atomically:YES];
        if(ifSave){
            NSLog(@"New Save Data Created.");
        }
    }
}

//Check if need to create the saveData folder. If need, create it.
- (void)checkIfNeedToCreateTheSaveDataFolder{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *usersDocumentURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *saveDataFolderPath = [usersDocumentURL.path stringByAppendingPathComponent:@"saveData"];
    
    BOOL ifItsFolder;
    BOOL ifExsitSaveDataFolder = [fileManager fileExistsAtPath:saveDataFolderPath isDirectory:&ifItsFolder];
    if(ifExsitSaveDataFolder && ifItsFolder){
        return;
    }
    else{
        [fileManager createDirectoryAtPath:saveDataFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

//Load the cells.
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.savingDataArray count];
}

//Set the cell.
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"saveGameCollectionCell";
    SGSaveLoadItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if([[self.savingDataArray objectAtIndex:indexPath.item] isKindOfClass:[NSDictionary class]]){
        //Get the specific save data.
        NSDictionary *saveDataOverAll = [self.savingDataArray objectAtIndex:indexPath.item];
        //Set the cell.
        cell.saveDateCreationDateString = [self createCreationTimeString:[saveDataOverAll objectForKey:@"creationTime"] forTimeOrDate:CONVERT_DATE];
        cell.saveDateCreationTimeString = [self createCreationTimeString:[saveDataOverAll objectForKey:@"creationTime"] forTimeOrDate:CONVERT_TIME];
        cell.saveDataScreenShotImage.image = [self getSaveDataScreenShotImageByName:[saveDataOverAll objectForKey:@"screenshotName"]];
    }
    else{
        cell.saveDateCreationDateString = @"No Data";
        cell.saveDataScreenShotImage.image = nil;
    }

    return cell;
}

//Load the screenshot image.
- (UIImage *)getSaveDataScreenShotImageByName:(NSString *)screenshotName{
    NSURL *usersDocumentURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *imageDataPath = [usersDocumentURL.path stringByAppendingPathComponent:[NSString stringWithFormat:@"saveData/screenShots/%@", screenshotName]];
    
    return [UIImage imageWithContentsOfFile:imageDataPath];
}

//Output formatted date string.
- (NSString *)createCreationTimeString:(NSDate *)date forTimeOrDate:(NSInteger)typeInteger{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if(typeInteger == CONVERT_DATE){
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    else if(typeInteger == CONVERT_TIME){
        [formatter setDateFormat:@"HH:mm"];
    }
    
    //Optionally for time zone converstions
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    return stringFromDate;
}

//If a cell was tapped - Delegate Method.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //Get current time.
    NSDate *currentTime = [NSDate date];
    
    //Create screenshot and its image name.
    UIImage *screenshotImage = [self getAndSaveCurrentGameScreenshot:indexPath.item];
    NSString *screenShotName = [NSString stringWithFormat:@"%ld.png", (long)indexPath.item];
    
    //Get saveData
    NSDictionary *saveDataDictionary = [self getCurrentGameStatus];
    
    //Create the plist.
    NSDictionary *saveDataObject = [NSDictionary dictionaryWithObjectsAndKeys:currentTime, @"creationTime", screenShotName, @"screenshotName", saveDataDictionary, @"saveData", nil];
    
    //Write to file.
    [self.savingDataArray replaceObjectAtIndex:indexPath.item withObject:saveDataObject];
    NSURL *usersDocumentURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *saveDataPath = [usersDocumentURL.path stringByAppendingPathComponent:@"saveData/soraGalSavingData.plist"];
    BOOL ifSaveGameSuccess = [self.savingDataArray writeToFile:saveDataPath atomically:YES];
    
    //Display in the saveGame page.
    if(ifSaveGameSuccess){
        static NSString *identifier = @"saveGameCollectionCell";
        SGSaveLoadItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        cell.saveDataScreenShotImage.image = screenshotImage;
        //Reload the collection view to display the changes.
        [self.collectionView reloadData];
    }
}

//Get the current game status - use delegate.
- (NSDictionary *)getCurrentGameStatus{
    NSDictionary *returnData = [_delegate returnCurrentGameStatus];
    if(returnData){
        return returnData;
    }
    else{
        return nil;
    }
}

//Get and save the screenshot - use delegate.
- (UIImage *)getAndSaveCurrentGameScreenshot:(NSInteger)screenshotIndexNumber{
    //Get the generated screenshot from delegate.
    UIImage *currentGameScreenshotImage = [_delegate returnCurrentScreenshot];
    
    //Get the path.
    NSURL *usersDocumentURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *imageDataPath = [usersDocumentURL.path stringByAppendingPathComponent:[NSString stringWithFormat:@"saveData/screenShots/%ld.png", screenshotIndexNumber]];
    
    //Check if need to create the screenshots folder.
    [self checkIfNeedToCreateTheScreenshotsFolder];
    
    //Save the image.
    [UIImagePNGRepresentation(currentGameScreenshotImage) writeToFile:imageDataPath atomically:YES];
    
    return currentGameScreenshotImage;
}

//Check if need to create the screenshots' folder in saveData folder. If need, create it.
- (void)checkIfNeedToCreateTheScreenshotsFolder{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *usersDocumentURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *screenshotsFolderPath = [usersDocumentURL.path stringByAppendingPathComponent:@"saveData/screenShots"];
    
    BOOL ifItsFolder;
    BOOL ifExsitScreenshotsFolder = [fileManager fileExistsAtPath:screenshotsFolderPath isDirectory:&ifItsFolder];
    if(ifExsitScreenshotsFolder && ifItsFolder){
        return;
    }
    else{
        [fileManager createDirectoryAtPath:screenshotsFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

//Back to game.
- (IBAction)exitSaveGameScreen:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



#pragma mark - Load Game UICollectionViewController

@interface SGLoadCollectionViewController ()

@property (strong, nonatomic) IBOutlet SGCustomCollectionViewFlowLayout *loadCollectionViewFlowLayout;

@end

@implementation SGLoadCollectionViewController

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
    
    //Register the class.
    [self.collectionView registerClass:[SGSaveLoadItemCell class] forCellWithReuseIdentifier:@"loadGameCollectionCell"];
    
    //Setup the layout.
    [self setupTheLayout];
}

- (void)setupTheLayout{
    //Setup the flow layout.
    self.loadCollectionViewFlowLayout = [[SGCustomCollectionViewFlowLayout alloc] init];
    [self.loadCollectionViewFlowLayout setItemSize:CGSizeMake(279, 108)]; //The cell's size.
    [self.loadCollectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.loadCollectionViewFlowLayout.minimumLineSpacing = 2.0f;
    
    //Setup the collectionView.
    [self.collectionView setCollectionViewLayout:self.loadCollectionViewFlowLayout];
    self.collectionView.bounces = YES;
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"loadGameCollectionCell";
    
    SGSaveLoadItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"eden_1" ofType:@"jpg" inDirectory:@"GameData/CGs"];
    cell.saveDataScreenShotImage.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    return cell;
}

- (IBAction)exitLoadGameScreen:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



#pragma mark - Custom the UICollectionViewFlowLayout

@implementation SGCustomCollectionViewFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *theLayout = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    for(int i = 1; i < [theLayout count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = theLayout[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = theLayout[i - 1];
        
        NSInteger maximumSpacing = 2; //Set the cell space in the same line in vertical scrolling mode.
        
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return theLayout;
}

@end











































