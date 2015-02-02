//
//  Enemy.m
//  tiltyMaze
//
//  Created by V-FEXrt on 9/20/14.
//  Copyright (c) 2014 V-FEXrt. All rights reserved.
//

#import "Enemy.h"
#import "PathFinder.h"

@interface Enemy ()
@property int direction;
@property bool mutEx;
@property int countForLoop;
@end

@implementation Enemy
- (id)initWithMapCode:(NSString*)code AndLocation:(CGPoint)loc;
{
    self = [super init];
    if (self) {
        
        self.mapCode = code;
        self.location = loc;
        self.mutEx = false;
        self.direction = 1;
        
    }
    return self;
}
- (id)initWithMapCode:(NSString*)code{
    self = [super init];
    if (self) {
        
        self.mapCode = code;
        self.hasCharacterBeenPlaced = false;
        self.mutEx = false;
        self.direction = 1;
        
    }
    return self;
}
-(NSArray*)runAIWithMap:(NSArray*)theMap andCharacterLocation:(CGPoint)location{
    
    //Loop until the valid move
    NSArray*mapToReturn;
    
    if (!self.mutEx) {
        self.mutEx = !self.mutEx;
        self.countForLoop = 0;
        do {
            if (arc4random() % 10 == 0) {
                self.direction = arc4random() % 4;
            }
            //if ([self canMoveInDirection:self.direction inMap:theMap]) {
                mapToReturn = [self makeMovementWithDirection:self.direction AndMap:theMap];
            
            //}
            self.countForLoop++;
            if (self.countForLoop > 15) {
                break;
            }
            
        } while (!self.userMoved);
        self.mutEx = !self.mutEx;
        return mapToReturn;
    }
    
    return theMap;
    
    /*self.direction = arc4random() % 4;
    return [self makeMovementWithDirection:self.direction AndMap:theMap];*/
    
    
    //Choose the correct direction based on [path returnPathSolution]
    
    /*BOOL directionToMove;
     
     PathFinder* path = [[PathFinder alloc]initWithMaze:theMap StartingAt:self.location EndingAt:location];
    
    [path returnShortestLength];
    
    NSArray* pathToTravel = [path returnPathSolution];
    
    
    if (self.location.x + 1 < [[pathToTravel objectAtIndex:0]count] && [[[pathToTravel objectAtIndex:self.location.y]objectAtIndex:self.location.x+1] isEqualToString:@"1"]) {
        //move to the 'right'
        directionToMove = 0;
        NSLog(@"Right");
    }else if (self.location.x - 1 > -1  && [[[pathToTravel objectAtIndex:self.location.y]objectAtIndex:self.location.x - 1] isEqualToString:@"1"]){
        directionToMove = 0;
        NSLog(@"LEft");
    }else if(self.location.y + 1 < [pathToTravel count] && [[[pathToTravel objectAtIndex:self.location.y + 1]objectAtIndex:self.location.x] isEqualToString:@"1"]){
        directionToMove = 0;
        NSLog(@"Down");
    }else if(self.location.y - 1 > -1  && [[[pathToTravel objectAtIndex:self.location.y - 1]objectAtIndex:self.location.x] isEqualToString:@"1"]){
        directionToMove = 0;
        NSLog(@"Up");
    }else{
        NSLog(@"else");
        self.direction = arc4random() % 4;
    }
    
    return [self makeMovementWithDirection:self.direction AndMap:theMap];*/
    
}




-(BOOL)canMoveInDirection:(int)dir inMap:(NSArray*)map{
    NSMutableArray* mutMap = [map mutableCopy];
    NSMutableArray* mutRow = [[mutMap objectAtIndex:self.location.x] mutableCopy];

    switch (dir) {
        case 0:
            if (self.location.x + 1 < [[mutMap objectAtIndex:0]count]) {
                mutRow = [[mutMap objectAtIndex:self.location.y] mutableCopy];
                if (!([[mutRow objectAtIndex:self.location.x+1] isEqualToString:self.mapCode])){
                    return TRUE;
                }
            }
            break;
        case 1:
            if (self.location.y + 1 < [mutMap count]) {
                mutRow = [[mutMap objectAtIndex:self.location.y + 1] mutableCopy];
                if (!([[mutRow objectAtIndex:self.location.x] isEqualToString:self.mapCode])){
                    return TRUE;
                }
            }
            break;
        case 2:
            if (self.location.x - 1 > -1) {
                mutRow = [[mutMap objectAtIndex:self.location.y] mutableCopy];
                //!([[mutRow objectAtIndex:self.locationY] isEqualToString:@"0"])
                if (!([[mutRow objectAtIndex:self.location.x - 1] isEqualToString:self.mapCode])){
                    return TRUE;
                }
            }
            break;
        case 3:
            if(self.location.y - 1 > -1){
                mutRow = [[mutMap objectAtIndex:self.location.y - 1] mutableCopy];
                //!([[mutRow objectAtIndex:self.locationY - 1] isEqualToString:@"0"])
                if (!([[mutRow objectAtIndex:self.location.x] isEqualToString:@"0"])){
                    return TRUE;
                }
            }
            break;
            
        default:
            break;
    }
        return FALSE;
}

        

@end
