//
//  MapGenerator.m
//  tiltyMaze
//
//  Created by V-FEXrt on 9/21/14.
//  Copyright (c) 2014 V-FEXrt. All rights reserved.
//

#import "MapGenerator.h"
#import "Graph.h"

@interface MapGenerator ()
@property (nonatomic, strong) NSArray *maze;
@property int across;
@property int down;
@property (nonatomic, strong) Graph *graph;
@property NSString* pathCode;
@end
int randDirs[4] = {1,2,3,4};
@implementation MapGenerator
- (id)initWithNumberOfRows:(int)rows AndNumberOfColumns:(int)columns OpenPathAsString:(NSString*)pathCode//normal is @"1"
{
    self = [super init];
    if (self) {
        self.pathCode = pathCode;
        self.graph = [Graph graph];
        self.across = rows;
        self.down = columns;
        [self generateMapWithAcross:rows And:columns];
        self.maze = [self ConvertGraphToArray:self.graph];
        //NSLog(@"Rows%d Columns%d", rows, columns);
        
    }
    return self;
}
-(NSArray*)getCurrentGeneratedMap{

    return self.maze;
}
-(NSArray*)generateNewMapWithRows:(int)rows AndNumberOfColumns:(int)columns OpenPathAsString:(NSString*)pathCode{
    self.pathCode = pathCode;
    self.across = rows;
    self.down = columns;
    self.graph = [Graph graph];
    
    [self generateMapWithAcross:rows And:columns];
    return [self ConvertGraphToArray:self.graph];
}


-(void)generateMapWithAcross: (int)across And: (int)down{
    
    self.graph = [Graph graph];
    
    int r = arc4random() % down;
    while (r % 2 == 0) {
        r = arc4random() % down;
    }
    
    int c = arc4random() % across;
    while (c % 2 == 0) {
        c = arc4random() % across;
    }
    
    NSDictionary* options =
                        @{
                          @"value"    : self.pathCode,
                          @"across"   : [NSNumber numberWithInt: r],
                          @"down"     : [NSNumber numberWithInt: c],
                          };
                              
    GraphNode *node = [GraphNode nodeWithOptions:options];
    [self.graph addNode:node];
    
    [self recursionWithRow:r andColumn:c AndArray:randDirs andCurrentNode:node];
    
    
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

-(void)recursionWithRow:(int)r andColumn: (int)c AndArray:(int[])randArr andCurrentNode:(GraphNode*)node{
    [self shuffleArray];
    int newArr[4] ={randDirs[0], randDirs[1], randDirs[2], randDirs[3]};
    NSDictionary* options;
    GraphNode *nd1;
    GraphNode *nd2;
    NSString *direction;
    
    int newRNd1 = 0;
    int newCNd1 = 0;
    int newRNd2 = 0;
    int newCNd2 = 0;
    
    for (int i = 0; i < 4; i++) {
        switch (randArr[i]) {
            case 1: //Up
                if (r - 2 < 0) {
                    continue;
                }
                
                direction = @"N";
                newRNd1 = r - 1;
                newCNd1 = c;
                newRNd2 = r - 2;
                newCNd2 = c;
                
                break;
                
            case 2: // Right
                if (c + 2 > self.across - 1)
                    continue;

                direction = @"E";
                newRNd1 = r;
                newCNd1 = c + 1;
                newRNd2 = r;
                newCNd2 = c + 2;
                
                break;
                
            case 3: // Down
                if (r + 2 > self.down - 1)
                    continue;
                //S r+2
                direction = @"S";
                newRNd1 = r + 1;
                newCNd1 = c;
                newRNd2 = r + 2;
                newCNd2 = c;
                
                break;
                
            case 4: //Left
                if (c - 2 < 0)
                    continue;
                //W c-2
                direction = @"W";
                newRNd1 = r;
                newCNd1 = c - 1;
                newRNd2 = r;
                newCNd2 = c - 2;
                
                break;
                
            default:
                break;
        }
        
        if (newRNd1 > 9) {
            NSLog(@"");
        }
        
        options =
        @{
          @"value"    : self.pathCode,
          @"across"   : [NSNumber numberWithInt: newRNd1],
          @"down"     : [NSNumber numberWithInt: newCNd1],
          };
        
        nd1 = [GraphNode nodeWithOptions:options];

        
        options =
        @{
          @"value"    : self.pathCode,
          @"across"   : [NSNumber numberWithInt: newRNd2],
          @"down"     : [NSNumber numberWithInt: newCNd2],
          };
        
        nd2 = [GraphNode nodeWithOptions:options];
        
        if(![self.graph hasNode:nd2]){
        
        [self.graph addEdgeFromNode:node toNode:nd1 withOptions:@{@"direction" : direction}];
        [self.graph addEdgeFromNode:nd1 toNode:nd2 withOptions:@{@"direction" : direction}];
        
        [self recursionWithRow:newRNd2 andColumn:newCNd2 AndArray:newArr andCurrentNode:nd2];
        
        }
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
-(NSArray*)ConvertGraphToArray:(Graph*)graph{
    
    NSArray* arr = [self array:self.across And:self.down];
    
    for (GraphNode *node in graph.nodes) {
        int row = [node.options[@"across"] intValue];
        int col = [node.options[@"down"] intValue];
        arr [col][row] = node.options[@"value"];
    }
    
    for (int i = 0; i < self.across; i++) {
        for (int j = 0; j <self.down; j++) {
            printf("%d", [arr[i][j] intValue]);
        }
        printf(("\n"));
    }
    
    return arr;
}

@end

