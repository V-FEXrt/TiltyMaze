//
//  playerLevel.m
//  
//
//  Created by Ashley Coleman on 1/23/14.
//  Copyright (c) 2014 Ashley Coleman. All rights reserved.
//


#import "SaveHandler.h"

@interface SaveHandler()
@property (nonatomic,strong) NSDictionary *myDictionary;
@property (nonatomic,strong) NSMutableDictionary *mutableDict;
@property (nonatomic,strong) NSNumber *numOfValue;
@property int intValue;
@property int count;
@end

@implementation SaveHandler
-(id)init{
    self = [super init];
    if (self) {
        
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
        NSString * documentsDir = paths[0];
        self.filePath = [documentsDir stringByAppendingString:@"save.dat"];
        
        
        self.myDictionary = [[NSDictionary alloc] initWithContentsOfFile:self.filePath];
        if (self.myDictionary == NULL) {
            self.filePath = [[NSBundle mainBundle]pathForResource:@"list" ofType:@"plist"];
            self.myDictionary = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
            self.filePath = [documentsDir stringByAppendingString:@"save.dat"];
            [self.myDictionary writeToFile:self.filePath atomically:YES];
            self.myDictionary = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
        }
        
        
        
        self.mutableDict = [[NSMutableDictionary alloc]init];
        self.mutableDict = [self.myDictionary mutableCopy];
        
    }
    return self;
}
-(int)returnCleared{ //returns the players level
    self.myDictionary = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
    self.mutableDict = [self.myDictionary mutableCopy];
    self.numOfValue = [self.mutableDict objectForKey:@"cleared"];
    self.intValue = [self.numOfValue intValue];
    return self.intValue;
}
-(void)addClearedByAmount:(int)score{ //increases the players level by 1

    self.myDictionary = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
    self.mutableDict = [self.myDictionary mutableCopy];
    self.numOfValue = [self.mutableDict objectForKey:@"cleared"];
    self.intValue = [self.numOfValue intValue];
    self.intValue += score;
    self.numOfValue = [NSNumber numberWithInt:self.intValue];
    [self.mutableDict setObject:self.numOfValue forKey:@"cleared"];
    [self.mutableDict writeToFile:self.filePath atomically:YES];

}
-(BOOL)returnIntroState{//bool should show intro?
    self.myDictionary = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
    self.mutableDict = [self.myDictionary mutableCopy];
    self.numOfValue = [self.mutableDict objectForKey:@"intro"];
    self.intValue = [self.numOfValue intValue];
    if (self.intValue == 0) {
        return TRUE;
    }else{
        return FALSE;
    }
}
-(void)updateIntroStateAsHide:(BOOL)hide{//runs the intro scene on load of app, not on homescreen return
    self.myDictionary = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
    self.mutableDict = [self.myDictionary mutableCopy];
    if (hide) {
        
        self.intValue = 1;
    }else{
        
        self.intValue = 0;
    }
    self.numOfValue = [NSNumber numberWithInt:self.intValue];
    [self.mutableDict setObject:self.numOfValue forKey:@"intro"];
    [self.mutableDict writeToFile:self.filePath atomically:YES];
}
-(BOOL)returnHelpState{
    self.myDictionary = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
    self.mutableDict = [self.myDictionary mutableCopy];
    self.numOfValue = [self.mutableDict objectForKey:@"help"];
    self.intValue = [self.numOfValue intValue];
    if (self.intValue == 0) {
        return TRUE;
    }else{
        return FALSE;
    }
    
}
-(void)updateHelpStateAsHide{
    self.myDictionary = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
    self.mutableDict = [self.myDictionary mutableCopy];

    self.intValue = 1;

    self.numOfValue = [NSNumber numberWithInt:self.intValue];
    [self.mutableDict setObject:self.numOfValue forKey:@"help"];
    [self.mutableDict writeToFile:self.filePath atomically:YES];
    
}
-(NSString*)returnUsername{
    self.myDictionary = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
    self.mutableDict = [self.myDictionary mutableCopy];
    return [self.mutableDict objectForKey:@"username"];
}
-(void)updateUsernameToString:(NSString*)name{
    self.myDictionary = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
    self.mutableDict = [self.myDictionary mutableCopy];
    
    [self.mutableDict setObject:name forKey:@"username"];
    [self.mutableDict writeToFile:self.filePath atomically:YES];
}
@end
