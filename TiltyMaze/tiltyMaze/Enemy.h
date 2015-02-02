//
//  Enemy.h
//  tiltyMaze
//
//  Created by V-FEXrt on 9/20/14.
//  Copyright (c) 2014 V-FEXrt. All rights reserved.
//

#import "Character.h"

@interface Enemy : Character
-(NSArray*)runAIWithMap:(NSArray*)theMap andCharacterLocation:(CGPoint)location;
- (id)initWithMapCode:(NSString*)code;
@end
