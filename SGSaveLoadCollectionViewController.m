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
#define TOTAL_AVAILABLE_SAVINGDATA 10



#pragma mark - Base CollectionViewController

@interface SGBaseCollectionViewController()

//Variables.
@property (nonatomic, strong) NSMutableArray *savingDataArray;

@end

@implementation SGBaseCollectionViewController

//Layout setup.
- (void)setupTheLayout:(SGCustomCollectionViewFlowLayout *)layout forCollectionView:(UICollectionView *)collectionView{
    //Setup the flow layout.
    layout = [[SGCustomCollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(279, 108)]; //The cell's size.
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumLineSpacing = 2.0f;
    
    //Setup the collectionView.
    [collectionView setCollectionViewLayout:layout];
    collectionView.bounces = YES;
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setShowsVerticalScrollIndicator:NO];
}

//Load game saving data from Document folder.
- (void)loadGameSavingFileToArray:(NSArray *)receivingArray{
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
        NSMutableArray *saveDataArrayCreate = [[NSMutableArray alloc] initWithCapacity:TOTAL_AVAILABLE_SAVINGDATA];
        for(int i = 0; i < TOTAL_AVAILABLE_SAVINGDATA; i++){
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
    
    //NSLog(stringFromDate);
    
    return stringFromDate;
}


@end



#pragma mark - Save Game UICollectionViewController

@interface SGSaveCollectionViewController()

//IBOutlets.
@property (strong, nonatomic) IBOutlet SGCustomCollectionViewFlowLayout *saveCollectionViewFlowLayout;

//Private variables.
@property (nonatomic, strong) NSIndexPath *willSaveDataIndexPath;

@end

@implementation SGSaveCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Register the class.
    [self.collectionView registerClass:[SGSaveLoadItemCell class] forCellWithReuseIdentifier:@"saveGameCollectionCell"];
    
    //Setup the layout.
    [self setupTheLayout:self.saveCollectionViewFlowLayout forCollectionView:self.collectionView];
    
    //Set the deleagte of collectionView.
    self.collectionView.delegate = self;
    
    //Load saving data from file.
    [self loadGameSavingFileToArray:self.savingDataArray];
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
        cell.saveDataScreenShotImage.image = [self getSaveDataScreenShotImageByName:[saveDataOverAll objectForKey:@"screenshotName"]];
        cell.dateLabel.text = [self createCreationTimeString:[saveDataOverAll objectForKey:@"creationTime"] forTimeOrDate:CONVERT_DATE];
        cell.timeLabel.text = [self createCreationTimeString:[saveDataOverAll objectForKey:@"creationTime"] forTimeOrDate:CONVERT_TIME];
    }
    else{
        cell.saveDataScreenShotImage.image = nil;
        cell.dateLabel.text = @"No Data";
        cell.timeLabel.text = @"No Data";
    }
    
    return cell;
}


//If a cell was tapped - Delegate Method.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //Ask user if overide the savedata.
    if([[self.savingDataArray objectAtIndex:indexPath.item] isKindOfClass:[NSDictionary class]]){
        self.willSaveDataIndexPath = indexPath;
        
        //Create the alert view, by using the custom version.
        TCustomAlertView *overideAlert = [[TCustomAlertView alloc] initWithSuperView:self.view title:@"Already have a save data" detail:@"Do you want to override it ?" confirmText:@"Override" andCancelText:@"Cancel"];
        overideAlert.delegate = self;
        
        [overideAlert show];
    }
    else{
        [self saveDataAndAllowOverideInCollectionView:collectionView AtIndexPath:indexPath];
    }
}
//The delegate of custom alert view.
- (void)didConfirmButtonPressed{
    [self saveDataAndAllowOverideInCollectionView:self.collectionView AtIndexPath:self.willSaveDataIndexPath];
    self.willSaveDataIndexPath = nil;
}

- (BOOL)saveDataAndAllowOverideInCollectionView:(UICollectionView *)collectionView AtIndexPath:(NSIndexPath *)indexPath{
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
        
        //Set the screenshot and time text.
        cell.saveDataScreenShotImage.image = screenshotImage;
        cell.dateLabel.text = [self createCreationTimeString:currentTime forTimeOrDate:CONVERT_DATE];
        cell.timeLabel.text = [self createCreationTimeString:currentTime forTimeOrDate:CONVERT_TIME];
        
        //Reload the collection view to display the changes.
        [self.collectionView reloadData];
        
        return YES;
    }
    
    return NO;
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
    NSString *imageDataPath = [usersDocumentURL.path stringByAppendingPathComponent:[NSString stringWithFormat:@"saveData/screenShots/%ld.png", (long)screenshotIndexNumber]];
    
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

@end



#pragma mark - Load Game UICollectionViewController

@interface SGLoadCollectionViewController()

@property (strong, nonatomic) IBOutlet SGCustomCollectionViewFlowLayout *loadCollectionViewFlowLayout;

//Variables
@property (nonatomic, strong) NSIndexPath *willLoadDataIndexPath;

@end

@implementation SGLoadCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Register the class.
    [self.collectionView registerClass:[SGSaveLoadItemCell class] forCellWithReuseIdentifier:@"loadGameCollectionCell"];
    
    //Setup the layout.
    [self setupTheLayout:self.loadCollectionViewFlowLayout forCollectionView:self.collectionView];
    
    //Set the deleagte of collectionView.
    self.collectionView.delegate = self;
    
    //Load saving data from file.
    [self loadGameSavingFileToArray:self.savingDataArray];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.savingDataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"loadGameCollectionCell";
    SGSaveLoadItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    //Set the cell to no data for initial.
    cell.saveDataScreenShotImage.image = nil;
    cell.dateLabel.text = @"No Data";
    cell.timeLabel.text = @"No Data";
    
    //If having savedata, set the cell.
    if(self.savingDataArray){
        if([[self.savingDataArray objectAtIndex:indexPath.item] isKindOfClass:[NSDictionary class]]){
            //Get the specific save data for item of the inde path.
            NSDictionary *saveDataOverAll = [self.savingDataArray objectAtIndex:indexPath.item];
            
            //Set the cell.
            cell.saveDataScreenShotImage.image = [self getSaveDataScreenShotImageByName:[saveDataOverAll objectForKey:@"screenshotName"]];
            cell.dateLabel.text = [self createCreationTimeString:[saveDataOverAll objectForKey:@"creationTime"] forTimeOrDate:CONVERT_DATE];
            cell.timeLabel.text = [self createCreationTimeString:[saveDataOverAll objectForKey:@"creationTime"] forTimeOrDate:CONVERT_TIME];
        }
    }
    
    return cell;
}

- (IBAction)exitLoadGameScreen:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//If a cell was tapped - Delegate Method.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //Ask user if load the game data.
    if([[self.savingDataArray objectAtIndex:indexPath.item] isKindOfClass:[NSDictionary class]]){
        self.willLoadDataIndexPath = indexPath;
        
        //Create the alert view, by using the custom version.
        TCustomAlertView *overideAlert = [[TCustomAlertView alloc] initWithSuperView:self.view title:@"Load Game" detail:@"Do you want to load this save data ?" confirmText:@"Load Game" andCancelText:@"Cancel"];
        overideAlert.delegate = self;
        
        [overideAlert show];
    }
}
//The delegate of custom alert view.
- (void)didConfirmButtonPressed{
    //Return the game status dictionary to the main view controller.
    [_delegate reloadGameStatus:[[self.savingDataArray objectAtIndex:self.willLoadDataIndexPath.item] objectForKey:@"saveData"]];
    
    
}
- (void)didAlertViewDisappeared{
    //Dismiss this view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
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











































