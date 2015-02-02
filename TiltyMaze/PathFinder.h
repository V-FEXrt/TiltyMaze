//
//  PathFinder.h
//  tiltyMaze
//
//  Created by V-FEXrt on 9/26/14.
//  Copyright (c) 2014 V-FEXrt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PointClass.h"


@interface PathFinder : NSObject
- (id)initWithMaze:(NSArray*)maze StartingAt:(CGPoint)start EndingAt:(CGPoint)end;
-(int)returnShortestLength;
-(NSArray*)returnPathSolution;
-(int)returnShortestLengthForMultiGoalWithMaze:(NSArray*)maze StartingAt:(CGPoint)start AndTravelingThrough:(NSMutableArray*)points WithTotalNumberOfPoints:(int)numberOfPoints;
-(int)returnShortestLengthForDotsWithMaze:(NSArray*)maze StartingAt:(CGPoint)start AndTravelingThrough:(NSArray*)points WithTotalNumberOfPoints:(int)numberOfPoints;
@end
