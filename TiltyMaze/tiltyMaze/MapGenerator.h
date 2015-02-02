//
//  MapGenerator.h
//  tiltyMaze
//
//  Created by V-FEXrt on 9/21/14.
//  Copyright (c) 2014 V-FEXrt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapGenerator : NSObject
- (id)initWithNumberOfRows:(int)rows AndNumberOfColumns:(int)columns OpenPathAsString:(NSString*)pathCode;
-(NSArray*)getCurrentGeneratedMap;
-(NSArray*)generateNewMapWithRows:(int)rows AndNumberOfColumns:(int)columns OpenPathAsString:(NSString*)pathCode;
@end
