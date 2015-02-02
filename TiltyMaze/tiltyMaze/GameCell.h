//
//  GameCell.h
//  tiltyMaze
//
//  Created by V-FEXrt on 9/19/14.
//  Copyright (c) 2014 V-FEXrt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameCell : UIImageView
@property int gameCellState;

-(void)updateGameCellState:(int)gameState;
@end
