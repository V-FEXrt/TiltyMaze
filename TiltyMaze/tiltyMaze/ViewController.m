//
//  ViewController.m
//  tiltyMaze
//
//  Created by V-FEXrt on 9/19/14.
//  Copyright (c) 2014 V-FEXrt. All rights reserved.
//

#import "ViewController.h"
#import "Character.h"
#import "Enemy.h"
#import "MapGenerator.h"
#import "SaveHandler.h"
#import "PathFinder.h"
#import "AppDelegate.h"


@interface ViewController ()
@property NSArray * gameCellArray;
@property NSArray * map;
@property Character* testCharacter;
@property Enemy* testEnemy;
@property Character* testGoal;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property MapGenerator* mapGen;
@property SaveHandler* saver;
@property NSMutableArray* goalsArray;
@property int numberOfGoals;
@property AppDelegate* appDelegateVar;
@property int playerDirection;
@property BOOL isAlertBeingShown;
@property NSMutableArray* arrayOfEnemies;
@property NSTimer* timer;
@property int gamePar;
@property BOOL backgroundDidComplete;
@property BOOL didLoadDidComplete;
@property UIView* gameView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    self.backgroundDidComplete = false;
    self.didLoadDidComplete = false;
    [self.loadingLbl setTextColor:[UIColor whiteColor]];
    
    UIView*backgroundView;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 135, self.view.bounds.size.width, 540)];
    }else{
        if([[UIScreen mainScreen] bounds].size.width > 560){
            backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 250)];
        }else{
            backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, self.view.bounds.size.width, 200)];
        }
        
    }
    
    
    
    [backgroundView setBackgroundColor:[UIColor blackColor]];
    [self.view insertSubview:backgroundView atIndex:0];
    

    int score = [self.saver returnCleared];
    int modifyDifficult = score / 1000;
    modifyDifficult++;
    
    int gridnum  =(10+modifyDifficult) + (arc4random() % 5);
    int gridnum2;
    
    if(gridnum > 50){
        gridnum = 50;
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        gridnum2= gridnum*2;
    }else{
        gridnum2 = gridnum*2 + (gridnum/2);
        
    }
    
    if (gridnum%2==0) {
        gridnum++;
    }
    if (gridnum2%2==0) {
        gridnum2++;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.gameCellArray = [self arrayWithNumberAcross:gridnum2 AndNumberDown:gridnum];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addGameCellToUI];
            if (self.didLoadDidComplete) {
                [self drawMap:self.map];
                [backgroundView removeFromSuperview];
            }
            self.backgroundDidComplete = true;
        });
    });
    
    
    self.isAlertBeingShown = false;
    self.arrayOfEnemies = [[NSMutableArray alloc]init];
    self.playerDirection = 4;
    self.parLabel.text = [NSString stringWithFormat:@"Par:"];
    
    //get the AppDelegate
    self.appDelegateVar = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    //allocate the save class
    self.saver = [[SaveHandler alloc]init];
    
    //allocate add banner
    self.bannerView = [[ADBannerView alloc]initWithAdType:ADAdTypeBanner];
    [self.bannerView setAlpha:0];
    [self.bannerView setDelegate:self];
    
    //_bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    [self.bannerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    

    
    CGRect contentFrame = self.view.bounds;
    CGRect bannerFrame = _bannerView.frame;
    bannerFrame.size.width = contentFrame.size.width;
    self.bannerView.frame = bannerFrame;
    bannerFrame = _bannerView.frame;
    contentFrame.size.height -= _bannerView.frame.size.height;
    bannerFrame.origin.y = contentFrame.size.height;
    self.bannerView.frame = bannerFrame;
    
    
    [self.view addSubview:self.bannerView];

    


    
    //background looks good gray
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    //create class to create 'random' maps
    NSString* pathCode = @"1";
    if (self.gameMode == 1) {
        pathCode = @"5";
    }
    
    self.mapGen = [[MapGenerator alloc]initWithNumberOfRows:gridnum2 AndNumberOfColumns:gridnum OpenPathAsString:pathCode];

    self.map = [self.mapGen getCurrentGeneratedMap];
    NSArray* mapCopy = self.map;
    
    //class to read accelerometer
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2;
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
      withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
          [self outputAccelertionData:accelerometerData.acceleration];
           if(error){
             NSLog(@"%@", error);}
       }];
    
    //allocate the player
    self.testCharacter = [[Character alloc]initWithMapCode:@"2"];
    
    self.map = [self.testCharacter placeCharacterRandomlyOnMap:self.map];
    
    //allocate the 'ai'
    self.testEnemy = [[Enemy alloc]initWithMapCode:@"3"];
    self.map = [self.testEnemy placeCharacterRandomlyOnMap:self.map];
    //allocate the 'exit'
    
    if (self.gameMode == 2) {//multiGoal
        self.numberOfGoals = 5;
        self.goalsArray = [[NSMutableArray alloc]init];
        NSMutableArray*locationArray = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < self.numberOfGoals; i++) {
           
            Character *testGoal = [[Character alloc]initWithMapCode:@"4"];
            self.map = [testGoal placeCharacterRandomlyOnMap:self.map];
            PointClass* tempPoint = [[PointClass alloc]initWithX:testGoal.location.x AndY:testGoal.location.y];
            [locationArray addObject:tempPoint];
            [self.goalsArray addObject:testGoal];
            
        }
        
        PathFinder* path = [[PathFinder alloc]initWithMaze:mapCopy StartingAt:self.testCharacter.location EndingAt:self.testGoal.location];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 self.gamePar = [path returnShortestLengthForMultiGoalWithMaze:mapCopy StartingAt:self.testCharacter.location AndTravelingThrough:locationArray WithTotalNumberOfPoints:self.numberOfGoals];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.parLabel.text = [NSString stringWithFormat:@"Par: %d", self.gamePar];
            });
        });
        
    }else if(self.gameMode == 1){
        //self.testGoal = [[Character alloc]initWithMapCode:@"5"];
        //self.map = [self.testGoal placeCharacterRandomlyOnMap:self.map];
        PathFinder* path = [[PathFinder alloc]initWithMaze:mapCopy StartingAt:self.testCharacter.location EndingAt:self.testGoal.location];
        
        int numberOfPoints = [self numberOfItems:@"5" InMap:mapCopy];
        
        NSMutableArray *dotPointArray = [[NSMutableArray alloc]init];
        
        
        for (int y = 0; y < [mapCopy count]; y++) {
            for (int x = 0; x < [[mapCopy objectAtIndex:0]count]; x++) {
                //arrayOfPoints
                if ([[[mapCopy objectAtIndex:y]objectAtIndex:x] isEqualToString:@"5"]) {
                    PointClass*temp = [[PointClass alloc]initWithX:x AndY:y];
                    [dotPointArray addObject:temp];

                }
            }
        }
        
        //background

        self.parLabel.text = [NSString stringWithFormat:@"Par:"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    self.gamePar = [path returnShortestLengthForDotsWithMaze:mapCopy StartingAt:self.testCharacter.location AndTravelingThrough:dotPointArray WithTotalNumberOfPoints:numberOfPoints];
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.parLabel.text = [NSString stringWithFormat:@"Par: %d", self.gamePar];
                });
        });
        
        [self.testCharacter howManyDotsInMap:self.map];
    }else if(self.gameMode == 0 || self.gameMode == 3){
        self.testGoal = [[Character alloc]initWithMapCode:@"4"];
        self.map = [self.testGoal placeCharacterRandomlyOnMap:self.map];
        PathFinder* path = [[PathFinder alloc]initWithMaze:mapCopy StartingAt:self.testCharacter.location EndingAt:self.testGoal.location];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.gamePar = [path returnShortestLength];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.parLabel.text = [NSString stringWithFormat:@"Par: %d", self.gamePar];
            });
        });
        
        [self.testCharacter setNumberOfWallJumps:1];
        if (self.gameMode == 3) {
            [self.testCharacter setNumberOfWallJumps:-1];//this gives unlimited jumps
            
            [self.arrayOfEnemies removeAllObjects];
            
            int numberEnemies = 5;
            Enemy*temp;
            for (int i = 0; i < numberEnemies; i++) {
                temp = [[Enemy alloc]initWithMapCode:@"3"];
                [temp placeCharacterRandomlyOnMap:self.map];
                [self.arrayOfEnemies addObject:temp];
            }
            
        }
    }

    
    
    
    
    //allocate labels
    self.movesMadeLabel.text = [NSString stringWithFormat:@"Moves:%d", [self.testCharacter getMovesMade]];
    self.mazesClearedLabel.text = @"Score";

    
    
    //draw the map
    if (self.backgroundDidComplete) {
        [self drawMap:self.map];
        [backgroundView removeFromSuperview];
    }
    self.didLoadDidComplete = true;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(callAI) userInfo:nil repeats:YES];
    
    [super viewDidLoad];
}
-(void)callAI{
    if (![self.appDelegateVar shouldGamePause] && !self.isAlertBeingShown) {
        self.map = [self.testEnemy runAIWithMap:self.map andCharacterLocation:self.testCharacter.location];
        
        
        if (self.gameMode == 3) {
            int doesntMove = arc4random() % [self.arrayOfEnemies count];
            
            for (int i = 0; i < [self.arrayOfEnemies count]; i++) {
                if (i != doesntMove) {
                Enemy*temp = [self.arrayOfEnemies objectAtIndex:i];
                self.map = [temp runAIWithMap:self.map andCharacterLocation:temp.location];
                }
            }
        
        }
        if (self.backgroundDidComplete) {
            [self drawMap:self.map];
        }
        
    }
    
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    //0 South crashes if go off screen
    //1 East
    //2 North
    //3 West
    if (![self.appDelegateVar shouldGamePause] && !self.isAlertBeingShown) {
    
        if (acceleration.y>0.3) {
            //NSLog(@"Up");
            if (self.playerDirection == 3) {
                self.playerDirection = 4;
            }else{
                self.playerDirection = 1;//0
            }
        }else if (acceleration.y< -0.3){
            
            //NSLog(@"Down");
            
            if (self.playerDirection == 1) {
                self.playerDirection = 4;
            }else{
                self.playerDirection = 3;//4
            }
        }
        if (acceleration.x>0.3) {
            //NSLog(@"Right");
            
            if (self.playerDirection == 2) {
                self.playerDirection = 4;
            }else{
                self.playerDirection = 0;
            }
            
        }else if (acceleration.x< -0.3){
          
            //NSLog(@"Left");
            if (self.playerDirection == 0) {
                self.playerDirection = 4;
            }else{
                self.playerDirection = 2;//0
            }
        }
        
        if (!self.isAlertBeingShown) {
            
            self.map = [self.testCharacter makeMovementWithDirection:self.playerDirection AndMap:self.map];
            
            if (self.backgroundDidComplete) {
                    [self drawMap:self.map];
            }
            
            
          
            
        }

    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //[[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //self.gameCellArray = [self arrayWithNumberAcross:10 AndNumberDown:10];
    //[self generateRandomMapWithNumberAcross:10 AndNumberDown:10];
}

-(NSArray*)arrayWithNumberAcross:(int)across AndNumberDown: (int)down{
    NSMutableArray* actualArray = [[NSMutableArray alloc]init];

    double deviceWidth = self.view.bounds.size.width;
    double deviceHeigth = self.view.bounds.size.height;
    
    double possibleCellWidth = deviceWidth / across;
    double possibleCellHeigth = deviceHeigth / down;
    
    double actualCellSize;
    int offsetHeigth = 0, offsetWidth = 0;
    int sizeOfEmptyArea = 0;
    //cell heigth becomes the smaller of the 2 possible sizes
    if (possibleCellHeigth>possibleCellWidth) {
        actualCellSize = possibleCellWidth;
        sizeOfEmptyArea = deviceHeigth - (down * possibleCellWidth);
        offsetHeigth = sizeOfEmptyArea/2;
        
        /*if (across*possibleCellWidth < deviceWidth) {
            //add to width
            offsetOffset = deviceWidth - (across* possibleCellWidth);
            offsetWidth += offsetOffset;
        }*/
    
        
    }else if(possibleCellWidth>possibleCellHeigth){
        actualCellSize = possibleCellHeigth;
        sizeOfEmptyArea = deviceWidth - (across * possibleCellHeigth);
        offsetWidth = sizeOfEmptyArea/2;
        
        /*if(down*possibleCellHeigth < deviceHeigth){
            //add to heigth
            offsetOffset = deviceHeigth - (down* possibleCellHeigth);
            offsetHeigth += offsetOffset;
        }*/
    }else{
        actualCellSize = possibleCellHeigth * 0.9;
        offsetHeigth = deviceHeigth * 0.05;
        offsetWidth = deviceWidth * 0.05;
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    offsetHeigth += self.bannerView.bounds.size.height / 3;
    //offsetWidth += self.bannerView.bounds.size.height;
    }else{
            offsetHeigth -= self.bannerView.bounds.size.height / 4;
    }
    
    
    for (int i = 0; i < across; i++) {
        NSMutableArray* temp = [[NSMutableArray alloc]init];
        for (int k = 0 ; k < down; k++) {
            GameCell* gCell = [[GameCell alloc]initWithFrame:CGRectMake((actualCellSize*i) + offsetWidth, (actualCellSize*k) + offsetHeigth, actualCellSize, actualCellSize)];
            
            [temp addObject:gCell];
            [gCell setTag:1];
            
            }
        
        [actualArray addObject: temp];
        
    }
    return [actualArray copy];
}
-(void)addGameCellToUI{
    self.gameView = [[UIView alloc]initWithFrame:self.view.bounds];
    
    for (int i = 0; i < [self.gameCellArray count]; i++) {
        NSArray *row = [self.gameCellArray objectAtIndex:i];
        for (int k = 0 ; k < [[self.gameCellArray objectAtIndex:0]count]; k++) {

            GameCell* temp = [row objectAtIndex:k];
            [temp updateGameCellState:1];
            [self.gameView addSubview:temp];
        }
    }
    [self.view insertSubview:self.gameView atIndex:1];
    [self.loadingLbl setHidden:YES];
}
-(void)drawMap:(NSArray*)mapArray{

    
    if (![self.appDelegateVar shouldGamePause]) {
        
        self.movesMadeLabel.text = [NSString stringWithFormat:@"Moves:%d", [self.testCharacter getMovesMade]];
        self.mazesClearedLabel.text = [NSString stringWithFormat:@"Score:%d", [self.saver returnCleared]];
        
        for (int i = 0; i < [mapArray count] ; i++) {
            for (int k = 0 ; k < [[mapArray objectAtIndex:0] count] ; k++) {
                NSArray* cellRowArray = [self.gameCellArray objectAtIndex:i];
                GameCell* tempCell = [cellRowArray objectAtIndex:k];
                
                //only update the map if it has changed.
                int newGameCellState =[[[mapArray objectAtIndex:i]objectAtIndex:k]intValue];

                [tempCell updateGameCellState:newGameCellState];
                    //if the cell changed check all the ones around it to see if
                    //they are another item.
                    //function detectCollisionAtX: AndY:
                    //function collisionsDetectedBetweenMapCode: AndMapCode:
                
                tempCell = nil;
                
            }
        }
        

        [self checkIfGameOver];
    }
}
-(void)checkIfGameOver{
    BOOL multiGoal = false;
    BOOL dots = false;
    BOOL hardMode = false;
    
    if (self.gameMode == 2) {
        multiGoal = true;
    }else if(self.gameMode == 1){
        dots = true;
    }else if(self.gameMode == 3){
        hardMode = true;
    }
    
    
    if (multiGoal) {
      if([[self.testCharacter getCollisionCode]integerValue] == 4){
          if (![self doesMap:self.map ContainMapCode:@"4"]) {
            [self runWin];
          }
        }
        
        if ([[self.testCharacter getCollisionCode]integerValue] == 3 || [[self.testEnemy getCollisionCode]integerValue]== 2){//lost
            [self runLose];
        }
    }else if(dots){
        if ([self.testCharacter areAllDotsGone]) {
            [self runWin];
        }
        
        if ([[self.testCharacter getCollisionCode]integerValue] == 3 || [[self.testEnemy getCollisionCode]integerValue]== 2)
        {//lost
            [self runLose];
            
        }
        
    }else if(hardMode){
        if ([[self.testCharacter getCollisionCode]integerValue] == 4) {
            
            [self runWin];
        }
        
        if ([[self.testCharacter getCollisionCode]integerValue] == 3) {
            [self runLose];
        }else{
            for (int i = 0; i < [self.arrayOfEnemies count]; i++) {
                Enemy* temp = [self.arrayOfEnemies objectAtIndex:i];
                if ([[temp getCollisionCode]integerValue] == 2) {
                    [self runLose];
                }
            }
        }
        
    }else{//single goal
        
        if ([[self.testCharacter getCollisionCode]integerValue] == 4) {

            [self runWin];
        }
        
        if ([[self.testCharacter getCollisionCode]integerValue] == 3 || [[self.testEnemy getCollisionCode]integerValue]== 2)
        {//lost
            [self runLose];
            
        }

    }


}
-(void)runLose{
    /*UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"You Lose" message:@"" delegate:self cancelButtonTitle:@"New Game" otherButtonTitles:nil, nil];
    [alert show];*/
    
    //self.containerView.hidden = YES;
    
    CustomAlert *alert = [[CustomAlert alloc] initWithTitle:@"You Lose" message:nil delegate:self cancelButtonTitle:@"Continue" otherButtonTitle:nil];
    
    self.isAlertBeingShown = true;
    [alert showInView:self.view];
    
    [self loadNewGame];
    
}
-(void)runWin{
    /*UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"You Win" message:@"" delegate:self cancelButtonTitle:@"New Game" otherButtonTitles:nil, nil];
    [alert show];*/
    
    //self.containerView.hidden = YES;
    
    CustomAlert *alert = [[CustomAlert alloc] initWithTitle:@"You Win" message:nil delegate:self cancelButtonTitle:@"Continue" otherButtonTitle:@"Submit Score"];
    
    alert.tag = 2;
    
    self.isAlertBeingShown = true;
    [alert showInView:self.view];
    
    int score = 1;
    
    if ([self.testCharacter getMovesMade] <= self.gamePar) {
        score = 100;
    }else if([self.testCharacter getMovesMade] - self.gamePar < 100){
        score = 100 - ([self.testCharacter getMovesMade] - self.gamePar);
    }
    
    [self.saver addClearedByAmount:score];
    [self loadNewGame];
}

-(void)loadNewGame{

    [self.gameView removeFromSuperview];
    
    [self.loadingLbl setHidden:NO];
    
    self.playerDirection = 4;
    
    self.backgroundDidComplete = false;
    self.didLoadDidComplete = false;
    
    int score = [self.saver returnCleared];
    int modifyDifficult = score / 1000;
    modifyDifficult++;
    
    int gridnum  = (10+modifyDifficult) + (arc4random() % 5);
    int gridnum2;
    
    if(gridnum > 50){
        gridnum = 50;
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        gridnum2= gridnum*2;
    }else{
        gridnum2 = gridnum*2 + (gridnum/2);
        
    }
    
    if (gridnum%2==0) {
        gridnum++;
    }
    if (gridnum2%2==0) {
        gridnum2++;
    }
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.gameCellArray = [self arrayWithNumberAcross:gridnum2 AndNumberDown:gridnum];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addGameCellToUI];
            if (self.didLoadDidComplete) {
                [self drawMap:self.map];
            }
            self.backgroundDidComplete = true;
        });
    });

    
    
    [self.testCharacter resetTotalMovesMade];
    
    NSString*pathCode = @"1";
    if (self.gameMode == 1) {
        pathCode = @"5";
    }
    self.map = [self.mapGen generateNewMapWithRows:gridnum2 AndNumberOfColumns:gridnum OpenPathAsString:pathCode];
    
    
    NSArray* mapCopy = self.map;
    
    
    
    
    self.map = [self.testEnemy placeCharacterRandomlyOnMap:self.map];
    self.map = [self.testCharacter placeCharacterRandomlyOnMap:self.map];
    [self.testCharacter howManyDotsInMap:self.map];
    [self.testCharacter setNumberOfWallJumps:3];

    if (self.gameMode == 2) {
        self.numberOfGoals = 5;
        self.goalsArray = [[NSMutableArray alloc]init];
        NSMutableArray*locationArray = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < self.numberOfGoals; i++) {
            
            Character *testGoal = [[Character alloc]initWithMapCode:@"4"];
            self.map = [testGoal placeCharacterRandomlyOnMap:self.map];
            PointClass* tempPoint = [[PointClass alloc]initWithX:testGoal.location.x AndY:testGoal.location.y];
            [locationArray addObject:tempPoint];
            [self.goalsArray addObject:testGoal];
            testGoal = nil;
            
        }
        
        PathFinder* path = [[PathFinder alloc]initWithMaze:mapCopy StartingAt:self.testCharacter.location EndingAt:self.testGoal.location];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.gamePar = [path returnShortestLengthForMultiGoalWithMaze:mapCopy StartingAt:self.testCharacter.location AndTravelingThrough:locationArray WithTotalNumberOfPoints:self.numberOfGoals];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.parLabel.text = [NSString stringWithFormat:@"Par: %d", self.gamePar];
            });
        });
        
    }
    if (self.gameMode == 1) {
            PathFinder* path = [[PathFinder alloc]initWithMaze:mapCopy StartingAt:self.testCharacter.location EndingAt:self.testGoal.location];
            
        
        int numberOfPoints = [self numberOfItems:@"5" InMap:mapCopy];
        
        NSMutableArray *dotPointArray = [[NSMutableArray alloc]init];
        
        
        for (int y = 0; y < [mapCopy count]; y++) {
            for (int x = 0; x < [[mapCopy objectAtIndex:0]count]; x++) {
                //arrayOfPoints
                if ([[[mapCopy objectAtIndex:y]objectAtIndex:x] isEqualToString:@"5"]) {
                    PointClass*temp = [[PointClass alloc]initWithX:x AndY:y];
                    [dotPointArray addObject:temp];
                    
                }
            }
        }
            
            //int shortestPath = [path returnShortestLengthForMultiGoalWithMaze:mapCopy StartingAt:self.testCharacter.location AndTravelingThrough:dotPointArray WithTotalNumberOfPoints:numberOfPoints];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.gamePar = [path returnShortestLengthForDotsWithMaze:mapCopy StartingAt:self.testCharacter.location AndTravelingThrough:dotPointArray WithTotalNumberOfPoints:numberOfPoints];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.parLabel.text = [NSString stringWithFormat:@"Par: %d", self.gamePar];
            });
        });
        
    }else if(self.gameMode == 0 || self.gameMode == 3){
        self.map = [self.testGoal placeCharacterRandomlyOnMap:self.map];
        
        PathFinder* path = [[PathFinder alloc]initWithMaze:mapCopy StartingAt:self.testCharacter.location EndingAt:self.testGoal.location];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.gamePar = [path returnShortestLength];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.parLabel.text = [NSString stringWithFormat:@"Par: %d", self.gamePar];
            });
        });
        
        [self.testCharacter setNumberOfWallJumps:1];
        if (self.gameMode == 3) {
            [self.testCharacter setNumberOfWallJumps:-1];//this gives unlimited jumps
            
            [self.arrayOfEnemies removeAllObjects];
            
            int numberEnemies = 5;
            Enemy*temp;
            for (int i = 0; i < numberEnemies; i++) {
                temp = [[Enemy alloc]initWithMapCode:@"3"];
                [temp placeCharacterRandomlyOnMap:self.map];
                [self.arrayOfEnemies addObject:temp];
            }
            
        }
    }
    
    
    if (self.backgroundDidComplete) {
        [self drawMap:self.map];
    }
    self.didLoadDidComplete = true;
    
}
-(BOOL)doesMap:(NSArray*)map ContainMapCode:(NSString*)code{
    
    for (int i = 0; i < [self.goalsArray count]; i++) {
        Character*temp = self.goalsArray[i];
        CGPoint goalPoint = temp.location;
        if ([[[self.map objectAtIndex:goalPoint.y]objectAtIndex:goalPoint.x] isEqualToString:code]) {
            return true;
        }
        
    }
    return false;
}
#pragma mark iAd Degelate Methods
-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [UIView beginAnimations:Nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:1];
    [UIView commitAnimations];
}
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [UIView beginAnimations:Nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:0];
    [UIView commitAnimations];
}

-(int)numberOfItems:(NSString*)item InMap:(NSArray*)map{
    int count = 0;
    for (int y = 0; y < [map count]; y++) {
        for (int x = 0; x < [[map objectAtIndex:0]count]; x++) {
            if ([[[map objectAtIndex:y]objectAtIndex:x] isEqualToString:item]) {
                count++;
            }
        }
    }
    
    return  count;
}

- (IBAction)cancelViewController:(id)sender {
    self.testCharacter = nil;
    self.testEnemy = nil;
    self.testGoal = nil;
    
    [self.timer invalidate];
    self.timer = nil;
    
    /*[self.view delete:self.testCharacter];
    [self.view delete:self.testGoal];
    [self.view delete:self.testEnemy];*/

    [self.delegate secondViewScreenControllerDidPressCancelButton:self sender:nil]; // Use nil or any other object to send as a sender
}
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    [self.testCharacter allowWallJump];
}
-(void)customAlertView:(CustomAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 
    if (alertView.tag == 2 && buttonIndex == 1) {
        CustomAlert* alert = [[CustomAlert alloc]initWithTitle:@"Enter a username" message:@"TextLabel" delegate:self cancelButtonTitle:@"Submit" otherButtonTitle:nil];
        /*UITextField* txtField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, alert.bounds.size.width, 10)];
        [alert addSubview:txtField];*/
        alert.textValue.text = [self.saver returnUsername];
        alert.tag = 5;
        
        [alert showInView:self.view];
        
    }else if(alertView.tag == 5){
        UITextField* temp = alertView.textValue;
        NSLog(@"%@", alertView.textValue.text);
        [self updateHighScoreWithName:temp.text andScore:[self.saver returnCleared]];
        [self.saver updateUsernameToString:temp.text];
        self.isAlertBeingShown = false;
        
    }else{
        self.isAlertBeingShown = false;
    }
    
    
}
-(void)updateHighScoreWithName:(NSString*)name andScore:(int)score{
    if (![name isEqualToString:@""]) {
        name = [name stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSString *url = [[NSString stringWithFormat:@"http://www.tiltymaze.com/update.php?name=%@&score=%d", name,score] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    }
}
@end
