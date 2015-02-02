//
//  MapGenerator.m
//  tiltyMaze
//
//  Created by V-FEXrt on 9/21/14.
//  Copyright (c) 2014 V-FEXrt. All rights reserved.
//

#import "MapGenerator.h"

@interface MapGenerator ()
@property (nonatomic, strong) NSArray *maze;
@property NSString* pathCode;
@end
int randDirs[4] = {1,2,3,4};
@implementation MapGenerator
- (id)initWithNumberOfRows:(int)rows AndNumberOfColumns:(int)columns OpenPathAsString:(NSString*)pathCode//normal is @"1"
{
    self = [super init];
    if (self) {
        self.pathCode = pathCode;
        [self generateMapWithAcross:rows And:columns];
        //NSLog(@"Rows%d Columns%d", rows, columns);
        
    }
    return self;
}
-(NSArray*)getCurrentGeneratedMap{

    return self.maze;
}
-(NSArray*)generateNewMapWithRows:(int)rows AndNumberOfColumns:(int)columns OpenPathAsString:(NSString*)pathCode{
    self.pathCode = pathCode;
    [self generateMapWithAcross:rows And:columns];
    return self.maze;
}


-(void)generateMapWithAcross: (int)across And: (int)down{
    
    NSMutableArray* tempMaze = [[self array:across And:down] mutableCopy];
    
    int r = arc4random() % across;
    while (r % 2 == 0) {
        r = arc4random() % across;
    }
    
    int c = arc4random() % down;
    while (c % 2 == 0) {
        c = arc4random() % down;
    }
    
    //NSLog(@"StartPoint X%d Y%d",r, c);
    
    NSMutableArray* tempRow = [[tempMaze objectAtIndex:r] mutableCopy];
    [tempRow replaceObjectAtIndex:c withObject:self.pathCode];
    [tempMaze replaceObjectAtIndex:r withObject:tempRow];
    
    self.maze = [tempMaze copy];
    [self shuffleArray];
    [self recursionWithRow:r andColumn:c AndArray:randDirs];
    
    
}

-(void)shuffleArray{
    for (int i = 0; i < 10; i++) {
        int a = arc4random() % 4;
        int b = arc4random() % 4;
        int temp = randDirs[a];
        randDirs[a] = randDirs[b];
        randDirs[b] = temp;
    }
    
    
}

-(void)recursionWithRow:(int)r andColumn: (int)c AndArray:(int[])randArr{
    [self shuffleArray];
    int newArr[4] ={randDirs[0], randDirs[1], randDirs[2], randDirs[3]};
    
    
    NSMutableArray*tempMap = [self.maze mutableCopy];
    NSMutableArray*tempRow;
    for (int i = 0; i < 4; i++) {
        switch (randArr[i]) {
            case 1: //up
                if (r - 2 <= 0) {
                    continue;
                }
                if ([[[tempMap objectAtIndex:r-2]objectAtIndex:c]integerValue] != [self.pathCode integerValue]) {
                    
                    tempRow = [tempMap objectAtIndex:r-2];
                    [tempRow replaceObjectAtIndex:c withObject:self.pathCode];
                    [tempMap replaceObjectAtIndex:r-2 withObject:tempRow];
                    
                    tempRow = [tempMap objectAtIndex:r-1];
                    [tempRow replaceObjectAtIndex:c withObject:self.pathCode];
                    [tempMap replaceObjectAtIndex:r-1 withObject:tempRow];
                    
                    [self recursionWithRow:r-2 andColumn:c AndArray:newArr];
                }
                break;
            case 2: // Right
                // Whether 2 cells to the right is out or not
                if (c + 2 >= [[tempMap objectAtIndex:0]count] - 1)
                    continue;
                if ([[[tempMap objectAtIndex:r]objectAtIndex:c+2]integerValue] != [self.pathCode integerValue]) {
                    
                    tempRow = [tempMap objectAtIndex:r];
                    [tempRow replaceObjectAtIndex:c+2 withObject:self.pathCode];
                    [tempMap replaceObjectAtIndex:r withObject:tempRow];
                    
                    tempRow = [tempMap objectAtIndex:r];
                    [tempRow replaceObjectAtIndex:c+1 withObject:self.pathCode];
                    [tempMap replaceObjectAtIndex:r withObject:tempRow];
                    
                    [self recursionWithRow:r andColumn:c+2 AndArray:newArr];
                    
                    
                }
                break;
                
            case 3: // Down
                // Whether 2 cells down is out or not
                if (r + 2 >= [self.maze count] - 1)
                    continue;
                
                if ([[[tempMap objectAtIndex:r+2]objectAtIndex:c]integerValue] != [self.pathCode integerValue]) {
                    
                    tempRow = [tempMap objectAtIndex:r+2];
                    [tempRow replaceObjectAtIndex:c withObject:self.pathCode];
                    [tempMap replaceObjectAtIndex:r+2 withObject:tempRow];
                    
                    tempRow = [tempMap objectAtIndex:r+1];
                    [tempRow replaceObjectAtIndex:c withObject:self.pathCode];
                    [tempMap replaceObjectAtIndex:r+1 withObject:tempRow];
                    
                    [self recursionWithRow:r+2 andColumn:c AndArray:newArr];
                }
                
                break;
                
            case 4: // Left
                // Whether 2 cells to the left is out or not
                if (c - 2 <= 0)
                    continue;
                if ([[[tempMap objectAtIndex:r]objectAtIndex:c-2]integerValue] != [self.pathCode integerValue]) {
                    
                    tempRow = [tempMap objectAtIndex:r];
                    [tempRow replaceObjectAtIndex:c-2 withObject:self.pathCode];
                    [tempMap replaceObjectAtIndex:r withObject:tempRow];
                    
                    tempRow = [tempMap objectAtIndex:r];
                    [tempRow replaceObjectAtIndex:c-1 withObject:self.pathCode];
                    [tempMap replaceObjectAtIndex:r withObject:tempRow];
                    
                    
                    [self recursionWithRow:r andColumn:c-2 AndArray:newArr];
                }
                break;
                
            default:
                break;
        }
        self.maze = [tempMap copy];
    }
}

-(NSArray*)array:(int)across And:(int)down{
    NSMutableArray* actualArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < across; i++) {
        
        NSMutableArray* temp = [[NSMutableArray alloc]init];
        for (int k = 0 ; k < down; k++) {
            
            [temp addObject:@"0"];
            
        }
        
        [actualArray addObject: temp];
        
    }
    //NSLog(@"across: %d down%d", across, down);
    

    return actualArray;
}
@end

