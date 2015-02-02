//
//  Character.m
//  tiltyMaze
//
//  Created by V-FEXrt on 9/19/14.
//  Copyright (c) 2014 V-FEXrt. All rights reserved.
//

#import "Character.h"

@interface Character ()
@property int movesMade;
@property NSString* collidedCode;
@property CGPoint oldLocation;
@property BOOL isFirstMove;
@property int TotalDots;
@property BOOL canJumpWall;
@end
@implementation Character
- (id)initWithMapCode:(NSString*)code AndLocation:(CGPoint)loc;
{
    self = [super init];
    if (self) {
        // Initialization code
        self.mapCode = code;
        self.location = loc;
        self.hasCharacterBeenPlaced = true;
        self.movesMade = 0;
        self.collidedCode = @"1";
        self.isFirstMove = true;
        self.numberOfWallJumps = 3;
        self.canJumpWall = false;
        self.userMoved = false;
        self.TotalDots = 0;

    }
    return self;
}
- (id)initWithMapCode:(NSString*)code{
    self = [super init];
    if (self) {
        // Initialization code
        self.mapCode = code;
        self.hasCharacterBeenPlaced =false;
        self.collidedCode = @"1";
        self.isFirstMove = true;
        self.numberOfWallJumps = 3;
        self.canJumpWall = false;
        self.userMoved = false;
        self.TotalDots = 0;

    }
    return self;
    
}
-(NSArray*)placeCharacterRandomlyOnMap:(NSArray *)map{
    NSMutableArray* mutMap = [map mutableCopy];
    NSMutableArray* mutRow;
    BOOL isCharcPlaced = false;
    self.collidedCode = @"1";
    self.isFirstMove = true;
    
    while (!isCharcPlaced) {
        int yToBePlaced = arc4random() % [mutMap count];
        int xToBePlaced = arc4random() % [[mutMap objectAtIndex:0]count];
        mutRow = [[mutMap objectAtIndex:yToBePlaced] mutableCopy];
        
        
        if ([[mutRow objectAtIndex:xToBePlaced]integerValue] == 1 ||[[mutRow objectAtIndex:xToBePlaced]integerValue] == 5) {
            //place here
            [mutRow replaceObjectAtIndex:xToBePlaced withObject:self.mapCode];
            [mutMap replaceObjectAtIndex:yToBePlaced withObject:mutRow];
            self.location = CGPointMake(xToBePlaced, yToBePlaced);
            isCharcPlaced = true;
            self.hasCharacterBeenPlaced = true;
        }
    
    }
    
    return [mutMap copy];
}

-(NSArray*)makeMovementWithDirection:(int)direction AndMap:(NSArray *)map{
        //0 South crashes if go off screen
        //1 East
        //2 North
        //3 West
    
    //if the character hasn't been set up correctly we need to fix that
    if (!self.hasCharacterBeenPlaced) {
        return nil;
    }
    
    self.userMoved = false;
    
    NSMutableArray* mutMap = [map mutableCopy];
    NSMutableArray* mutRow = [[mutMap objectAtIndex:self.location.x] mutableCopy];


    NSString* oldCollidedCode = self.collidedCode;
    self.oldLocation = self.location;
    

    
    switch (direction) {
        case 0:
            if (self.location.x + 1 < [[mutMap objectAtIndex:0]count]) {
                //mutRow = [[mutMap objectAtIndex:self.locationX+1] mutableCopy];
                mutRow = [[mutMap objectAtIndex:self.location.y] mutableCopy];
                
                if (!([[mutRow objectAtIndex:self.location.x+1] isEqualToString:@"0"]) || self.canJumpWall) {
                    self.collidedCode = [mutRow objectAtIndex:self.location.x+1];
                    [mutRow replaceObjectAtIndex:self.location.x+1 withObject:self.mapCode];
                    [mutMap replaceObjectAtIndex:self.location.y withObject:mutRow];
                    self.location = CGPointMake(self.location.x+1, self.location.y);
                    self.userMoved = true;
                }
            }
            break;
        case 1:
            if (self.location.y + 1 < [mutMap count]) {
                mutRow = [[mutMap objectAtIndex:self.location.y + 1] mutableCopy];
                //!([[mutRow objectAtIndex:self.locationY + 1] isEqualToString:@"0"])
                
                if (!([[mutRow objectAtIndex:self.location.x] isEqualToString:@"0"]) || self.canJumpWall){
                    self.collidedCode = [mutRow objectAtIndex:self.location.x];
                    [mutRow replaceObjectAtIndex:self.location.x withObject:self.mapCode];
                    [mutMap replaceObjectAtIndex:self.location.y + 1  withObject:mutRow];
                    self.location = CGPointMake(self.location.x, self.location.y+1);
                   
                    self.userMoved = true;
                }
            }
            break;
        case 2:
            if (self.location.x - 1 > -1) {
                mutRow = [[mutMap objectAtIndex:self.location.y] mutableCopy];
                //!([[mutRow objectAtIndex:self.locationY] isEqualToString:@"0"])
                if (!([[mutRow objectAtIndex:self.location.x - 1] isEqualToString:@"0"]) || self.canJumpWall){
                    self.collidedCode = [mutRow objectAtIndex:self.location.x-1];
                    [mutRow replaceObjectAtIndex:self.location.x-1 withObject:self.mapCode];
                    [mutMap replaceObjectAtIndex:self.location.y withObject:mutRow];
                    self.location = CGPointMake(self.location.x-1, self.location.y);
                
                    self.userMoved = true;
                }
            }
            break;
        case 3:
            if(self.location.y - 1 > -1){
                mutRow = [[mutMap objectAtIndex:self.location.y - 1] mutableCopy];
                //!([[mutRow objectAtIndex:self.locationY - 1] isEqualToString:@"0"])
                if (!([[mutRow objectAtIndex:self.location.x] isEqualToString:@"0"]) || self.canJumpWall){
                    self.collidedCode = [mutRow objectAtIndex:self.location.x];
                    [mutRow replaceObjectAtIndex:self.location.x withObject:self.mapCode];
                    [mutMap replaceObjectAtIndex:self.location.y - 1 withObject:mutRow];
                    self.location = CGPointMake(self.location.x, self.location.y-1);
                    
                    self.userMoved = true;
                }
            }
            break;
            
        default:
            break;
    }
    
    
    if (self.userMoved) {
        mutRow = [[mutMap objectAtIndex:self.oldLocation.y] mutableCopy];
        if ([self.mapCode isEqualToString:@"2"]) {
            if ([oldCollidedCode isEqualToString:@"0"]) {
                [mutRow replaceObjectAtIndex:self.oldLocation.x withObject:@"0"];
            }else{
                [mutRow replaceObjectAtIndex:self.oldLocation.x withObject:@"1"];
            }
            
        }else{
            if ([self.mapCode isEqualToString:@"3"] && [oldCollidedCode isEqualToString:@"3"]) {
                [mutRow replaceObjectAtIndex:self.oldLocation.x withObject:@"1"];
            }else{
                [mutRow replaceObjectAtIndex:self.oldLocation.x withObject:oldCollidedCode];
            }
        }
        
        
    
        if (self.isFirstMove && [self.mapCode isEqualToString:@"3"]) {
            [mutRow replaceObjectAtIndex:self.oldLocation.x withObject:[self getMapOpenCodeForMap:map]];
            self.isFirstMove = false;
        }
            
        
        
        
        
        [mutMap replaceObjectAtIndex:self.oldLocation.y withObject:mutRow];
        
        if ([self.mapCode isEqualToString:@"2"] && [self.collidedCode isEqualToString:@"5"]) {
            self.TotalDots--;
            //NSLog(@"Dots: %d", self.TotalDots);
        }
        
        if (self.canJumpWall && [self.collidedCode isEqualToString:@"0"]) {
            self.canJumpWall = false;
            self.numberOfWallJumps--;
        }
        
        self.movesMade++;
        
    }
    

    
    /*for (int i = 0; i<10; i++) {
        for (int k = 0; k<10; k++) {
            //printf("%d", [[[mutMap objectAtIndex:i]objectAtIndex:k]integerValue]);
        }
        printf("\n");
    }*/
    
    return [mutMap copy];
}
-(int)getMovesMade{
    return self.movesMade;
}
-(NSString*)getCollisionCode{
    return self.collidedCode;
}
-(void)resetTotalMovesMade{
    self.movesMade = 0;
}
-(NSString*)getMapOpenCodeForMap:(NSArray*)map{
    NSMutableArray *mutMap  = [map mutableCopy];
    NSMutableArray *mutRow;
    
    for (int y = 1; y < [mutMap count]; y++) {
        for (int x = 1; x < [[mutMap objectAtIndex:0]count]; x++) {
            
            if (x < [[mutMap objectAtIndex:0]count]) {
                //mutRow = [[mutMap objectAtIndex:self.locationX+1] mutableCopy];
                mutRow = [[mutMap objectAtIndex:y] mutableCopy];
                
                if (([[mutRow objectAtIndex:x] isEqualToString:@"5"])) {
                    return @"5";
                }
            }
        }
    }

    return @"1";
}
-(BOOL)areAllDotsGone{
    if (self.TotalDots <= 0) {
        return YES;
    }
    return NO;
}
-(int)howManyDotsInMap:(NSArray*)map{
    int numberOfDots = 0;
    for (int y = 0; y < [map count]; y++) {
        for (int x = 0; x < [[map objectAtIndex:0]count]; x++) {
            if ([[[map objectAtIndex:y]objectAtIndex:x]integerValue] == 5) {
                numberOfDots++;
            }
        }
    }
    
    numberOfDots++;
    
    self.TotalDots = numberOfDots;
    return numberOfDots;
}
-(void)allowWallJump{
    if (self.numberOfWallJumps != 0) {
       self.canJumpWall = true;
    }
}
@end
