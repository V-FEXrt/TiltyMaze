//
//  MainViewController.h
//  tiltyMaze
//
//  Created by V-FEXrt on 9/30/14.
//  Copyright (c) 2014 V-FEXrt. All rights reserved.
//

#import "ViewController.h"
@interface MainViewController : UIViewController <SecondViewScreenControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *introScene;

@end
