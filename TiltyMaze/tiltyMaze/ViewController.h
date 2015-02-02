//
//  ViewController.h
//  tiltyMaze
//
//  Created by V-FEXrt on 9/19/14.
//  Copyright (c) 2014 V-FEXrt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCell.h"
#import <CoreMotion/CoreMotion.h>
#import <iAd/iAd.h>
#import "CustomAlert.h"
#import "PointClass.h"

@protocol SecondViewScreenControllerDelegate <NSObject>

- (void)secondViewScreenControllerDidPressCancelButton:(UIViewController *)viewController sender:(id)sender;

// Any other button possibilities

@end

@interface ViewController : UIViewController <ADBannerViewDelegate, CustomAlertDelegate>
@property (strong, nonatomic) IBOutlet UILabel *loadingLbl;

@property (strong, nonatomic) IBOutlet UILabel *mazesClearedLabel;
@property (strong, nonatomic) IBOutlet UILabel *movesMadeLabel;
@property (strong, nonatomic) IBOutlet UILabel *parLabel;
@property int gameMode;
@property (weak, nonatomic) id<SecondViewScreenControllerDelegate>delegate;
@property ADBannerView *bannerView;
- (IBAction)cancelViewController:(id)sender;



@end
