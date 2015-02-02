//
//  Character.h
//  tiltyMaze
//
//  Created by V-FEXrt on 9/19/14.
//  Copyright (c) 2014 V-FEXrt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Character : NSObject
@property BOOL hasCharacterBeenPlaced;
@property NSString* mapCode;
@property CGPoint location;
@property int numberOfWallJumps;
@property BOOL userMoved;

- (id)initWithMapCode:(NSString*)code AndLocation:(CGPoint)loc;
- (id)initWithMapCode:(NSString*)code;
-(NSArray*)placeCharacterRandomlyOnMap:(NSArray*)map;
-(NSArray*)makeMovementWithDirection:(int)direction AndMap:(NSArray *)map;
-(int)getMovesMade;
-(NSString*)getCollisionCode;
-(void)resetTotalMovesMade;
-(BOOL)areAllDotsGone;
-(void)allowWallJump;
-(int)howManyDotsInMap:(NSArray*)map;
@end
