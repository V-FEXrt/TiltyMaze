//
//  GameCell.m
//  tiltyMaze
//
//  Created by V-FEXrt on 9/19/14.
//  Copyright (c) 2014 V-FEXrt. All rights reserved.
//

#import "GameCell.h"

@interface GameCell ()
@property UIImage* wallImage;
@property UIImage* roadImage;
@property UIImage* playerImage;
@property UIImage* enemyImage;
@property UIImage* goalImage;
@property UIImage* dotImage;
@property int oldState;
@end

@implementation GameCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.gameCellState = 0;
        self.oldState = 0;
        [self setBackgroundColor:[UIColor blackColor]];
        self.wallImage = [UIImage imageNamed:@"wall.png"];
        self.roadImage = [UIImage imageNamed:@"road.png"];
        self.playerImage = [UIImage imageNamed:@"player.png"];
        self.enemyImage = [UIImage imageNamed:@"enemy.png"];
        self.goalImage = [UIImage imageNamed:@"goal.png"];
        self.dotImage = [UIImage imageNamed:@"dot.png"];
    
    }
    return self;
}
-(void)updateGameCellState:(int)gameState{
    self.oldState = self.gameCellState;
    self.gameCellState = gameState;
    
    if (self.oldState != self.gameCellState) {
        
        if (self.gameCellState == 0) {
            //wall
            //[self setBackgroundColor:[UIColor blackColor]];
            [self setImage:self.wallImage];
            
        }else if(self.gameCellState == 1){
            //empty
            //[self setBackgroundColor:[UIColor whiteColor]];
            [self setImage:self.roadImage];
        }else if(self.gameCellState == 2){
            //player
            //[self setBackgroundColor:[UIColor greenColor]];
            [self setImage:self.playerImage];
        }else if(self.gameCellState == 3){
            //enemy
            //[self setBackgroundColor:[UIColor redColor]];
            [self setImage:self.enemyImage];
        }else if (self.gameCellState == 4){
            //[self setBackgroundColor:[UIColor blueColor]];
            [self setImage:self.goalImage];
        }else if (self.gameCellState == 5){
            //[self setBackgroundColor:[UIColor yellowColor]];
            [self setImage:self.dotImage];
        }
            

    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
