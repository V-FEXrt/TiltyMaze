//
//  MainViewController.m
//  tiltyMaze
//
//  Created by V-FEXrt on 9/30/14.
//  Copyright (c) 2014 V-FEXrt. All rights reserved.
//

#import "MainViewController.h"
#import "SaveHandler.h"
#import "ViewController.h"

@interface MainViewController ()
@property SaveHandler* save;
@property ViewController *sec;
@property NSMutableArray* buttonArray;
@property UITextView* textView1;
@property UITextView* textView2;
@end

@implementation MainViewController



- (void)viewDidLoad
{

    
    self.save = [[SaveHandler alloc]init];
    self.buttonArray = [[NSMutableArray alloc]init];
    
    UIImageView*bkView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [bkView setBackgroundColor:[UIColor blackColor]];
    [bkView setImage:[UIImage imageNamed:@"maze.png"]];
    
    [self.view addSubview:bkView];
    
    NSArray* buttonNames = [[NSArray alloc]initWithObjects:@"Normal", @"Dot Collector", @"Multi-Goal",@"Hard Mode", @"Help",@"All Time Highs", nil];
    
    double deviceTypeMultiplier = .95;
    NSInteger fontSize = 20;
    NSInteger yValueChanger = 65;
    static NSInteger YOFFSET;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        deviceTypeMultiplier = 2;
        fontSize = 40;
        yValueChanger = 55;
        YOFFSET = 80;
    }
    else{
        yValueChanger = 50;
        YOFFSET = 30;
        //self.entireView.center = CGPointMake(self.entireView.center.x, self.entireView.center.y + 20);
    }
    
    for (int i = 0; i < [buttonNames count]; i++) {
        NSString *tempString = [buttonNames objectAtIndex:i];
        
        UIButton* tempButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.1, 0 + YOFFSET +(i * yValueChanger * deviceTypeMultiplier), self.view.frame.size.width * .8, 40 * deviceTypeMultiplier)];
        tempButton.tag = i;
        [tempButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [tempButton.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
        [tempButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tempButton setTitle:tempString forState:UIControlStateNormal];
        [tempButton addTarget:self action:@selector(perpareGameMode:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView* image = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.1, 0 + YOFFSET +(i* yValueChanger * deviceTypeMultiplier), self.view.frame.size.width * .8, 40 * deviceTypeMultiplier)];
        image.image = [UIImage imageNamed:@"menubutton.png"];
        [self.view addSubview:image];
        [self.view addSubview:tempButton];
        [self.buttonArray addObject:tempButton];
        [self.buttonArray addObject:image];
        
        
    }
    
    
    if ([self.save returnHelpState]) {
        
        UIButton*tempButton = [[UIButton alloc]init];
        tempButton.tag = 4;
        [self perpareGameMode:tempButton];
        [self.save updateHelpStateAsHide];
        
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)secondViewScreenControllerDidPressCancelButton:(UIViewController *)viewController sender:(id)sender
{
    // Do something with the sender if needed
    [viewController dismissViewControllerAnimated:YES completion:NULL];
    self.sec = nil;
}

- (IBAction)perpareGameMode:(UIButton *)sender {
    //ViewController *sec = [[ViewController alloc] initWithNibName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    if (sender.tag < 4) {
        
        NSString* storyboardName = @"";
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            //ipad
            storyboardName = @"Game_iPad";
        }else{
            storyboardName = @"Game_iPhone";
        }
        
        self.sec = [[UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        
        [self.sec setGameMode:(int)sender.tag];
        self.sec.delegate = self;
        self.sec.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:self.sec animated:YES completion:NULL];
    }else if(sender.tag == 4){
        
        for (int i = 0; i < [self.buttonArray count]; i++) {
            [[self.buttonArray objectAtIndex:i] setHidden:YES];
        }
        
        int multiplier = 1;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            multiplier = 2;
        }

        
        UITextView * text = [[UITextView alloc]initWithFrame:CGRectMake(40 * multiplier, 40 * multiplier, self.view.bounds.size.width - (80 * multiplier), self.view.bounds.size.height - (80 * multiplier))];
        [text setBackgroundColor:[UIColor grayColor]];
        [text setTextAlignment:NSTextAlignmentCenter];
        
        text.text = @"\n\nYour player is the green colored box; the enemy is red, avoid him at all costs. Your ultimate task is to navigate to the blue escape portal. Moving can be quite hard, try tilting your device and movement will come! If you find yourself in an emergency with the need to stop try tiliting lightly in the opposite direction. If that isn't enough try tapping your screen to jump over walls! Be careful though, the number of jumps are limited by the game mode. Finally, watch the Par, your score is determined by it!\n\nHappy Exploring!";
            
        

        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [text setFont:[UIFont systemFontOfSize:30]];
        }else{
            [text setFont:[UIFont systemFontOfSize:16]];
        }
        
        [text setEditable:NO];
        
        
        [self.view addSubview:text];
        
        UIButton* tempButton = [[UIButton alloc]initWithFrame:CGRectMake(50 * multiplier, 35 * multiplier, 200, 50)];
        [tempButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [tempButton setTitle:@"Menu" forState:UIControlStateNormal];
        [tempButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [tempButton addTarget:self action:@selector(hideTextView:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [text setFont:[UIFont systemFontOfSize:30]];
            [tempButton.titleLabel setFont:[UIFont systemFontOfSize:30]];
      
        }
        
        [self.view addSubview:tempButton];
    }else if (sender.tag == 5){
        
        for (int i = 0; i < [self.buttonArray count]; i++) {
            [[self.buttonArray objectAtIndex:i] setHidden:YES];
        }
        
        int multiplier = 1;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            multiplier = 2;
        }
        
        
        self.textView1 = [[UITextView alloc]initWithFrame:CGRectMake(40 * multiplier, 40 * multiplier, (self.view.bounds.size.width - (80 * multiplier))/4 * 3, self.view.bounds.size.height - (80 * multiplier))];
        self.textView2 = [[UITextView alloc]initWithFrame:CGRectMake(self.textView1.bounds.size.width + (40 * multiplier), 40 * multiplier, (self.view.bounds.size.width - (80 * multiplier))/4, self.view.bounds.size.height - (80 * multiplier))];
        [self.textView1 setDelegate:self];
        [self.textView2 setDelegate:self];
        [self.textView1 setShowsVerticalScrollIndicator:NO];
        
        
        [self.textView1 setBackgroundColor:[UIColor grayColor]];
        [self.textView2 setBackgroundColor:[UIColor grayColor]];
        [self.textView1 setTextAlignment:NSTextAlignmentLeft];
        [self.textView2 setTextAlignment:NSTextAlignmentRight];
        [self.textView1 setFont:[UIFont systemFontOfSize:20]];
        [self.textView2 setFont:[UIFont systemFontOfSize:20]];

        //text here
        
        

        self.textView1.text = @"\n\n\n\t\tLoading scores, please wait...";
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString* dataFromServer = [self getHighScores];
            NSArray* dataPoints = [dataFromServer componentsSeparatedByString:@","];
            NSString*leftViewText = @"";
            NSString*rightViewText = @"";
            NSString*tabValue = @"\t\t";
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                //tabValue = [tabValue stringByAppendingString:@"\t\t"];
                tabValue = [tabValue stringByAppendingString:@"\t\t"];
            }
            
            int place = 1;
            if ([dataPoints count] > 0) {
                for (int i = 0; i < [dataPoints count] - 1; i++) {
                    if (i%2==0) {
                        //name
                        leftViewText = [leftViewText stringByAppendingString:[NSString stringWithFormat:@"%@%d. %@\n",tabValue, place, dataPoints[i]]];
                        place++;
                    }else{
                        rightViewText = [rightViewText stringByAppendingString:[NSString stringWithFormat:@"%@\n", dataPoints[i]]];
                        
                    }
                    
                }
            }else{
                leftViewText = @"\n\n\n\t\tConnection is unavailable";
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.textView1.text = leftViewText;
                self.textView2.text = rightViewText;
            });
        });

        
         
        
        
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [self.textView1 setFont:[UIFont systemFontOfSize:40]];
            [self.textView1 setFont:[UIFont systemFontOfSize:40]];
        }
        
        [self.textView1 setEditable:NO];
        [self.textView2 setEditable:NO];
        
        
        [self.view addSubview:self.textView1];
        [self.view addSubview:self.textView2];
        
        UIButton* tempButton = [[UIButton alloc]initWithFrame:CGRectMake(50 * multiplier, 35 * multiplier, 200, 50)];
        [tempButton setTag:6];
        [tempButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [tempButton setTitle:@"Menu" forState:UIControlStateNormal];
        [tempButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [tempButton addTarget:self action:@selector(hideTextView:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [self.textView1 setFont:[UIFont systemFontOfSize:30]];
            [self.textView2 setFont:[UIFont systemFontOfSize:30]];
            [tempButton.titleLabel setFont:[UIFont systemFontOfSize:30]];
            
        }
        
        [self.view addSubview:tempButton];
        
 }
}
- (IBAction)hideTextView:(UIButton *)sender {
    [sender removeFromSuperview];
    NSArray* subV = [self.view subviews];
    [[subV objectAtIndex:[subV count]-1] removeFromSuperview];
    if (sender.tag == 6) {
        [[subV objectAtIndex:[subV count]-2] removeFromSuperview];
    }
    
    
    for (int i = 0; i < [self.buttonArray count]; i++) {
        [[self.buttonArray objectAtIndex:i] setHidden:NO];
    }
}
-(NSString*)getHighScores{
    NSError *err = nil;
    NSString *url = [[NSString stringWithFormat:@"http://www.tiltymaze.com/lookup.php"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *myTxtFile = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&err];
    if(err != nil) {
        //HANDLE ERROR HERE
        NSLog(@"Error: %@", err);
    }
    return myTxtFile;
}
#pragma mark Text View Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.textView1.contentOffset = scrollView.contentOffset;
    self.textView2.contentOffset = scrollView.contentOffset;
}

@end