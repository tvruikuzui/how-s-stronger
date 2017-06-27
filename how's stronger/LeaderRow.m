//
//  LeaderRow.m
//  how's stronger
//
//  Created by Aharon on 25/06/2017.
//  Copyright © 2017 Aharon. All rights reserved.
//

#import "LeaderRow.h"

@implementation LeaderRow

@synthesize name;
@synthesize score;

-(id)initWithJSONData:(NSDictionary *)data{
    self = [super init];
    if(self){
        self.name = [data objectForKey:@"name"];
        self.score = [[data objectForKey:@"score"]integerValue];
    }
    return self;
}

@end
