//
//  LeaderRow.h
//  how's stronger
//
//  Created by Aharon on 25/06/2017.
//  Copyright © 2017 Aharon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderRow : NSObject

@property (strong) NSString * name;
@property (assign) NSInteger score;

-(id)initWithJSONData:(NSDictionary*)data;

@end
