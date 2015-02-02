//
//  PathFinder.m
//  tiltyMaze
//
//  Created by V-FEXrt on 9/26/14.
//  Copyright (c) 2014 V-FEXrt. All rights reserved.
//

#import "PathFinder.h"
@interface PathFinder ()
@property NSArray *maze;
@property int shortestLength;
@property const int OPEN_SPOT;
@property const int OPEN_SPOT2;
@property NSArray* placesVisited;
@property CGPoint startPoint;
@property CGPoint endPoint;
@property NSArray* correctPath;
@end

@implementation PathFinder

- (id)initWithMaze:(NSArray*)maze StartingAt:(CGPoint)start EndingAt:(CGPoint)end
{
    self = [super init];
    if (self) {
        self.maze = maze;
        self.OPEN_SPOT = 1;
        self.OPEN_SPOT2 = 5;
        int xSize = (int)[[self.maze objectAtIndex:0]count];
        int ySize = (int)[self.maze count];
        //self.placesVisited = [self arrayWithNumberAcross:self.ySize AndNumberDown:self.xSize];
        self.placesVisited = [self arrayWithNumberAcross:xSize AndNumberDown:ySize];
        
        
        self.startPoint = start;
        self.endPoint = end;
        self.shortestLength = -1;
        
        
        
    }
    return self;
}
-(int)returnShortestLength{
    
    self.shortestLength = -1;
    //NSLog(@"Start %f,%f\n End%f,%f",self.startPoint.x, self.startPoint.y, self.endPoint.x, self.endPoint.y);
    [self recursiveSearchWithStart:self.startPoint AndEnd:self.endPoint AndLength:0 AndVisitedArray:self.placesVisited AndMaze:self.maze];
    
    
    return self.shortestLength;
}

-(BOOL)recursiveSearchWithStart:(CGPoint)start AndEnd: (CGPoint)end AndLength: (int)length AndVisitedArray: (NSArray*)visited AndMaze:(NSArray*)maze{
    BOOL ansFound = false;
    int xSize = (int)[[maze objectAtIndex:0]count];
    int ySize = (int)[maze count];
    
    //NSLog(@"Start %f,%f\n End%f,%f",start.x, start.y, end.x, end.y);
    
    if(start.x == end.x && start.y == end.y && (self.shortestLength == -1 || length < self.shortestLength))
    {
        
        
        /*printf("\n");
        
        for (int i = 0; i < ySize; i++) {
            for (int k = 0; k < xSize; k++) {
                printf("%ld",(long)[[[visited objectAtIndex:i]objectAtIndex:k]integerValue]);
                
            }
            printf("\n");
        }
        printf("printed");*/
        

        self.correctPath = visited;
        self.shortestLength = length;
        return true;
    }
    //keep looking
    else
    {
        
        BOOL visitedXP;
        BOOL visitedXM;
        BOOL visitedYP;
        BOOL visitedYM;
        
        BOOL validXP = true;
        BOOL validXM = true;
        BOOL validYP = true;
        BOOL validYM = true;
        
        
        if (xSize > start.x+1 && start.y < ySize) {
            //if ([visited count] > start.x+1) {
            visitedXP = [[[visited objectAtIndex:start.y]objectAtIndex:start.x+1]integerValue];
            //visitedXP = [[[visited objectAtIndex:start.x + 1]objectAtIndex:start.y]integerValue];
            //NSLog(@"1");
            
        }else{
            validXP = false;
        }
        
        if (start.x - 1 >= 0 && start.x - 1 < xSize && ySize > start.y) {
            //if (start.x - 1 >= 0 && start.x - 1 < [visited count]) {
            visitedXM = [[[visited objectAtIndex:start.y]objectAtIndex:start.x- 1]integerValue];
            //visitedXM = [[[visited objectAtIndex:start.x - 1]objectAtIndex:start.y]integerValue];
            //NSLog(@"2");
        }else{
            validXM = false;
        }
        if (start.y + 1 < ySize && start.x < xSize) {
            //if (start.y + 1 < [[visited objectAtIndex:0]count]) {
            visitedYP = [[[visited objectAtIndex:start.y+1]objectAtIndex:start.x]integerValue];
            //visitedYP = [[[visited objectAtIndex:start.x]objectAtIndex:start.y + 1]integerValue];
            //NSLog(@"3");
        }else{
            validYP = false;
        }
        
        if (start.y - 1 >= 0 && ySize > start.y - 1 && xSize > start.x) {
            //if (start.y - 1 >= 0 && [[visited objectAtIndex:0] count] > start.y - 1) {
            visitedYM = [[[visited objectAtIndex:start.y-1]objectAtIndex:start.x]integerValue];
            //visitedYM = [[[visited objectAtIndex:start.x]objectAtIndex:start.y - 1]integerValue];
            //NSLog(@"4");
        }else{
            validYM = false;
        }
        
        
        
        if (start.x < xSize && start.y < ySize) {
            
        visited = [self ReplaceObjectAtIndexX:start.x AndIndexY:start.y WithObject:[NSString stringWithFormat:@"%d",true] InArray:visited];
            
        }
        
        
        
        if(!visitedXP && validXP && !ansFound)//right
        {
            //NSLog(@"5");
            if ([[[maze objectAtIndex:start.y]objectAtIndex:start.x+1]integerValue] == self.OPEN_SPOT || [[[maze objectAtIndex:start.y]objectAtIndex:start.x+1]integerValue] == self.OPEN_SPOT2 ) {
                
                
                ansFound = [self recursiveSearchWithStart:CGPointMake(start.x+1, start.y) AndEnd:end AndLength:length+1 AndVisitedArray:visited AndMaze:maze];
            }
        }
        
        if(!visitedXM &&  validXM && !ansFound)//left
        {
            //NSLog(@"6");
            if ([[[maze objectAtIndex:start.y]objectAtIndex:start.x-1]integerValue] == self.OPEN_SPOT || [[[maze objectAtIndex:start.y]objectAtIndex:start.x-1]integerValue] == self.OPEN_SPOT2) {
                ansFound = [self recursiveSearchWithStart:CGPointMake(start.x-1, start.y) AndEnd:end AndLength:length+1 AndVisitedArray:visited AndMaze:maze];
            }
        }
        
        if(!visitedYP && validYP && !ansFound)//up
        {
            //NSLog(@"7");
            if ([[[maze objectAtIndex:start.y+1]objectAtIndex:start.x]integerValue] == self.OPEN_SPOT || [[[maze objectAtIndex:start.y+1]objectAtIndex:start.x]integerValue] == self.OPEN_SPOT2) {
                ansFound = [self recursiveSearchWithStart:CGPointMake(start.x, start.y+1) AndEnd:end AndLength:length+1 AndVisitedArray:visited AndMaze:maze];
            }
            
        }
        if(!visitedYM && validYM && !ansFound)//down
        {
            //NSLog(@"8");
            if ([[[maze objectAtIndex:start.y-1]objectAtIndex:start.x]integerValue] == self.OPEN_SPOT || [[[maze objectAtIndex:start.y-1]objectAtIndex:start.x]integerValue] == self.OPEN_SPOT2) {
                
                ansFound = [self recursiveSearchWithStart:CGPointMake(start.x, start.y-1) AndEnd:end AndLength:length+1 AndVisitedArray:visited AndMaze:maze];
            }
        }
        
    }
    //NSLog(@"123");
    if(ansFound){
        return true;}
    return false;
}



-(NSArray*)arrayWithNumberAcross:(int)across AndNumberDown: (int)down{
    NSMutableArray* actualArray = [[NSMutableArray alloc]init];
    
    
    for (int i = 0; i < down; i++) {
        NSMutableArray* temp = [[NSMutableArray alloc]init];
        for (int k = 0 ; k < across; k++) {
            [temp addObject:[NSString stringWithFormat:@"%d",false]];
        }
        
        
        [actualArray addObject: temp];
        
    }
    return [actualArray copy];
}

-(NSArray*)ReplaceObjectAtIndexX:(int)x AndIndexY:(int)y WithObject:(NSString*)obj InArray:(NSArray*)array{
    NSMutableArray* tempArrayVisited = [array mutableCopy];
    NSMutableArray* tempArrayVisitedRow = [[tempArrayVisited objectAtIndex:y]mutableCopy];
    [tempArrayVisitedRow replaceObjectAtIndex:x withObject:obj];
    [tempArrayVisited replaceObjectAtIndex:y withObject:tempArrayVisitedRow];
    
    return [tempArrayVisited copy];
}
-(NSArray*)returnPathSolution{
    
    /*int matrix[4][5]  = {{1,2,3,4,5},
        {6,7,8,9, 10},
        {11,12,13,14, 15},
        {16,17,18,19,20}
    };*/
    
    //int w = 4;
    int w = (int)[self.correctPath count];
    //int h = 5;
    int h = (int)[[self.correctPath objectAtIndex:0]count];
    //int ret[h][w];
    NSMutableArray* rotatedPath = [[self arrayWithNumberAcross:h AndNumberDown:w] mutableCopy];
    
    for (int i = 0; i < h; ++i) {
        for (int j = 0; j < w; ++j) {
            //ret[i][j] = matrix[j][h - i - 1];
            rotatedPath[i][j] = self.correctPath[j][h - i - 1];
        }
    }

    /*for (int i=0; i<h; i++) {
        for (int j=0; j<w; j++) {
            NSLog(@"%@     ",rotatedPath[i][j]);
        }
        printf("\n");
    }*/

    
    return rotatedPath;
}
-(int)returnShortestLengthForMultiGoalWithMaze:(NSArray*)maze StartingAt:(CGPoint)start AndTravelingThrough:(NSMutableArray*)points WithTotalNumberOfPoints:(int)numberOfPoints{
    BOOL solutionFound = false;
    int lengthArray[numberOfPoints];
    int totalLength = 0;
    self.shortestLength = -1;
    
    int xSize = (int)[[maze objectAtIndex:0]count];
    int ySize = (int)[maze count];
    

    NSArray*visited = [self arrayWithNumberAcross:xSize AndNumberDown:ySize];
    
    
    while (!solutionFound) {
        //get all the possible lengths of close items

        for (int i = 0; i < numberOfPoints; i++) {
            //NSLog(@"Start %f,%f\n End%f,%f",start.x, start.y, points[i].x, points[i].y);
            PointClass* tempPoint = points[i];
            [self recursiveSearchWithStart:start AndEnd:CGPointMake(tempPoint.x, tempPoint.y) AndLength:0 AndVisitedArray:visited AndMaze:maze];
            
            
            lengthArray[i] = self.shortestLength;
            self.shortestLength = -1;
            //NSLog(@"Length:%d",lengthArray[i]);
           // NSLog(@"%d", lengthArray[i]);
        }
        
        //find the lowest length and index of that length
        int tempLength = lengthArray[0];
        int lowestIndex = 0;
        //NSLog(@"Length[%d}:%d", 0, lengthArray[0]);
        for (int i = 1; i < numberOfPoints; i++) {
            //NSLog(@"Length[%d}:%d", i, lengthArray[i]);
            if (tempLength > lengthArray[i] && lengthArray[i] != -1) {
                tempLength = lengthArray[i];
                lowestIndex = i;
            }
            
        }
        //NSLog(@"Lowest Index:%d", lowestIndex);
        
        //This is pretty complex actually
        
        //The new start point becomes the closest point
        PointClass* tempPoint = points[lowestIndex];
        start = CGPointMake(tempPoint.x, tempPoint.y);
        //We increase the total length
        totalLength += tempLength;
        //Here is the hard part
        //  Switch the lowest point to the end
        //  Then move what was at the end to the spot where the lowest point was
        tempPoint = points[numberOfPoints-1];
        CGPoint temp = CGPointMake(tempPoint.x, tempPoint.y);//temp = last item
        
        points[numberOfPoints-1] = points[lowestIndex]; //closest item == last item
        points[lowestIndex] = [[PointClass alloc]initWithX:temp.x AndY:temp.y];//last item == closest item
        
        //  Then decrease the 'number' of points in the array making the previous point 'invisible'
        if (numberOfPoints <= 1) {
            solutionFound = true;

        }else{
            numberOfPoints--;
        }
        
    }
    return totalLength;
}
-(int)returnShortestLengthForDotsWithMaze:(NSArray*)maze StartingAt:(CGPoint)start AndTravelingThrough:(NSArray*)points WithTotalNumberOfPoints:(int)numberOfPoints{
    NSMutableArray* newPoints = [points mutableCopy];
    BOOL solutionFound = false;
    int lengthArray[numberOfPoints];
    int totalLength = 0;
    self.shortestLength = -1;
    
    int xSize = (int)[[maze objectAtIndex:0]count];
    int ySize = (int)[maze count];
    
    BOOL foundNeihborCell = false;
    
    NSArray*emptyVisited = [self arrayWithNumberAcross:xSize AndNumberDown:ySize];
    NSArray*visited = [self arrayWithNumberAcross:xSize AndNumberDown:ySize];
    
    visited = [self ReplaceObjectAtIndexX:start.x AndIndexY:start.y WithObject:[NSString stringWithFormat:@"%d",true] InArray:visited];
    
    while (!solutionFound) {
        foundNeihborCell = false;
        if (start.x+1< xSize) {
            if ([[[maze objectAtIndex:start.y]objectAtIndex:start.x+1] isEqualToString:@"5"] && ![[[visited objectAtIndex:start.y]objectAtIndex:start.x+1]integerValue]) {
                
                totalLength++;
                start = CGPointMake(start.x+1, start.y);
                
                PointClass *check = [[PointClass alloc]init];
                int index = -1;
                while (start.x != check.x && start.y != check.y) {
                    index++;
                    check = newPoints[index];
                }
               
                /* for (int i = 0; i < numberOfPoints; i++) {
                    if (start.x == check.x && start.y == check.y) {
                        index = i;
                        check = points[i];
                        break;

                        
                    }
                }*/
                
                PointClass* temp = points[numberOfPoints-1];//temp = last item
                
                
                newPoints[numberOfPoints-1] = points[index]; //closest item == last item
                newPoints[index] = temp;
                
                numberOfPoints--;
                foundNeihborCell= true;
                visited = [self ReplaceObjectAtIndexX:start.x AndIndexY:start.y WithObject:[NSString stringWithFormat:@"%d",true] InArray:visited];
                //NSLog(@"D");
            }
            
        }
        if (start.x - 1 > -1) {
            if ([[[maze objectAtIndex:start.y]objectAtIndex:start.x-1] isEqualToString:@"5"] && ![[[visited objectAtIndex:start.y]objectAtIndex:start.x-1]integerValue]) {
                
                totalLength++;
                start = CGPointMake(start.x-1, start.y);
                
                PointClass* check = [[PointClass alloc]init];
                int index = -1;
                while (start.x != check.x && start.y != check.y) {
                    index++;
                    check = newPoints[index];
                }
                
                PointClass* temp = newPoints[numberOfPoints-1];//temp = last item
                
                newPoints[numberOfPoints-1] = newPoints[index]; //closest item == last item
                newPoints[index] = temp;
                
                numberOfPoints--;
                foundNeihborCell = true;
                visited = [self ReplaceObjectAtIndexX:start.x AndIndexY:start.y WithObject:[NSString stringWithFormat:@"%d",true] InArray:visited];
                //NSLog(@"U");
            }
            
        }
        if (start.y + 1 < ySize) {
            if ([[[maze objectAtIndex:start.y + 1]objectAtIndex:start.x] isEqualToString:@"5"]&& ![[[visited objectAtIndex:start.y+1]objectAtIndex:start.x]integerValue]) {
                
                totalLength++;
                start = CGPointMake(start.x, start.y+1);
                
                PointClass* check = [[PointClass alloc]init];
                int index = -1;
                while (start.x != check.x && start.y != check.y) {
                    index++;
                    check = newPoints[index];
                }
                
                PointClass* temp = newPoints[numberOfPoints-1];//temp = last item
                
                newPoints[numberOfPoints-1] = newPoints[index]; //closest item == last item
                newPoints[index] = temp;
                
                numberOfPoints--;
                foundNeihborCell = true;
                visited = [self ReplaceObjectAtIndexX:start.x AndIndexY:start.y WithObject:[NSString stringWithFormat:@"%d",true] InArray:visited];
                //NSLog(@"R");
            }
        }
        if (start.y - 1 > -1) {
            if ([[[maze objectAtIndex:start.y - 1]objectAtIndex:start.x] isEqualToString:@"5"]&& ![[[visited objectAtIndex:start.y - 1]objectAtIndex:start.x]integerValue]) {
                
                totalLength++;
                start = CGPointMake(start.x, start.y-1);
                
                PointClass* check = [[PointClass alloc]init];
                int index = -1;
                while (start.x != check.x && start.y != check.y) {
                    index++;
                    check = points[index];
                }
                
                PointClass* temp = newPoints[numberOfPoints-1];//temp = last item
                
                newPoints[numberOfPoints-1] = newPoints[index]; //closest item == last item
                newPoints[index] = temp;
                
                numberOfPoints--;
                foundNeihborCell = true;
                visited = [self ReplaceObjectAtIndexX:start.x AndIndexY:start.y WithObject:[NSString stringWithFormat:@"%d",true] InArray:visited];
                //NSLog(@"L");
            }
        }
        
        if (!foundNeihborCell){
            
            for (int i = 0; i < numberOfPoints; i++) {
                //NSLog(@"Start %f,%f\n End%f,%f",start.x, start.y, points[i].x, points[i].y);
                PointClass* temp = newPoints[i];
                if (start.x == temp.x && start.y == temp.y) {
                    
                }else{
                    if (!([[[visited objectAtIndex:temp.y]objectAtIndex:temp.x]integerValue] == true)) {
                        [self recursiveSearchWithStart:start AndEnd:CGPointMake(temp.x, temp.y) AndLength:0 AndVisitedArray:emptyVisited AndMaze:maze];
                    }
                    
                }
                
                
                lengthArray[i] = self.shortestLength;
                self.shortestLength = -1;
                //NSLog(@"Length:%d",lengthArray[i]);
                // NSLog(@"%d", lengthArray[i]);
            }
            
            //find the lowest length and index of that length
            int tempLength = lengthArray[0];
            int lowestIndex = 0;
            //NSLog(@"Length[%d}:%d", 0, lengthArray[0]);
            for (int i = 1; i < numberOfPoints; i++) {
                //NSLog(@"Length[%d}:%d", i, lengthArray[i]);
                if (tempLength > lengthArray[i] && lengthArray[i] != -1) {
                    tempLength = lengthArray[i];
                    lowestIndex = i;
                }
                
            }
            //NSLog(@"Lowest Index:%d", lowestIndex);
            
            //This is pretty complex actually
            
            //The new start point becomes the closest point
            PointClass* tempPoint = newPoints[lowestIndex];
            start = CGPointMake(tempPoint.x, tempPoint.y);
            //We increase the total length
            totalLength += tempLength;
            //Here is the hard part
            //  Switch the lowest point to the end
            //  Then move what was at the end to the spot where the lowest point was
            tempPoint = newPoints[numberOfPoints - 1];//temp = last item
            
            newPoints[numberOfPoints-1] = newPoints[lowestIndex]; //closest item == last item
            newPoints[lowestIndex] = tempPoint;//last item == closest item
            
            numberOfPoints--;
            visited = [self ReplaceObjectAtIndexX:start.x AndIndexY:start.y WithObject:[NSString stringWithFormat:@"%d",true] InArray:visited];
        }
        
        
        if (numberOfPoints <= 1) {
            solutionFound = true;
            
        }
        
    }
    return totalLength;

}


@end
