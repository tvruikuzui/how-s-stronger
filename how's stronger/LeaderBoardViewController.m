//
//  LeaderBoardViewController.m
//  how's stronger
//
//  Created by Aharon on 18/06/2017.
//  Copyright © 2017 Aharon. All rights reserved.
//

#import "LeaderBoardViewController.h"
#import "LeaderRow.h"

@implementation LeaderBoard
{
    UIButton * back;
    UITableView * leaders;
    NSURLSessionConfiguration * configuration;
    NSURLSession * session;
    NSMutableArray<LeaderRow*>* leaderArray;
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    leaders = [[UITableView alloc] initWithFrame:CGRectMake(10, 55, self.view.frame.size.width - 10*2, self.view.frame.size.height - 260) style:UITableViewStylePlain];
    leaders.delegate = self;
    leaders.dataSource = self;
    
    back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.frame = CGRectMake((self.view.frame.size.width-100)/2, (self.view.frame.size.height-40)/1.20, 100, 40);
    [back addTarget:self action:NSSelectorFromString(@"goBack:") forControlEvents:UIControlEventTouchUpInside];
    [back setTitle:@"back to game" forState:UIControlStateNormal];
    
    leaderArray = [[NSMutableArray alloc]init];
    configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    [self.view addSubview:back];
    [self.view addSubview:leaders];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self getLeaders];
}

-(void)goBack:(UIButton*)sender{
    [leaderArray removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getLeaders{
    NSURL * url = [NSURL URLWithString:@"http://35.184.144.226/strongest/"];
    session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSessionDataTask * task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(error == nil && data.length != 0){
                NSMutableArray * items = [[NSMutableArray alloc]init];
                NSArray * jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                if (error) {
                    NSLog(@"not good");
                }else{
                    for (NSDictionary* eachScore in jsonArray) {
                        LeaderRow *scorerRow = [[LeaderRow alloc]initWithJSONData:eachScore];
                        [leaderArray addObject:scorerRow];
                    }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [leaders reloadData];
                
                    });
                }
            }
        }];
        [task resume];
    });
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [leaderArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
    }
    LeaderRow * textForRow = leaderArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ score : %li",textForRow.name,textForRow.score];
    //NSString * score = [NSString stringWithFormat:@"%i",textForRow.score];
    //cell.detailTextLabel.text = score;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Our Leaders!!!";
}

@end
