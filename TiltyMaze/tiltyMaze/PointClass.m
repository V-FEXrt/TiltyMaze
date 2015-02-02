//
//  PointClass.m
//  tiltyMaze
//
//  Created by V-FEXrt on 10/20/14.
//  Copyright (c) 2014 V-FEXrt. All rights reserved.
//

#import "PointClass.h"

@implementation PointClass

- (id)initWithX:(int)x AndY:(int)y
{
    self = [super init];
    if (self) {
        
        self.x = x;
        self.y = y;
        
    }
    return self;
}

@end


