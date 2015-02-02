//
//  playerLevel.h
//  
//
//  Created by Ashley Coleman on 1/23/14.
//  Copyright (c) 2014 Ashley Coleman. All rights reserved.



//  This class handles all data saving interaction

#import <Foundation/Foundation.h>

@interface SaveHandler : NSObject
@property (nonatomic, strong)NSString* filePath;

-(int)returnCleared;
-(void)addClearedByAmount:(int)score;
-(BOOL)returnIntroState;
-(void)updateIntroStateAsHide:(BOOL)hide;
-(BOOL)returnHelpState;
-(void)updateHelpStateAsHide;
-(NSString*)returnUsername;
-(void)updateUsernameToString:(NSString*)name;
@end
