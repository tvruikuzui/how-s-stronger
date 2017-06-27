//
//  ViewController.m
//  how's stronger
//
//  Created by Aharon on 18/06/2017.
//  Copyright © 2017 Aharon. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "LeaderBoardViewController.h"

@interface ViewController ()<NSURLSessionDelegate>

@end

@implementation ViewController
{
    UIImage * clickHere;
    UILabel * points;
    UIButton * clicker;
    int score;
    CMMotionManager * motionManger;
    double max;
    UITextView * text;
    UIAlertController * submitScoreAlert;
    UIButton * submit;
    NSString * name;
    UIButton * moveToLeaderBoard;
    LeaderBoard * leaderBoardController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    score = 0;
    moveToLeaderBoard = [UIButton buttonWithType:UIButtonTypeSystem];
    [moveToLeaderBoard setTitle:@"LeaderBoard" forState:UIControlStateNormal];
    [moveToLeaderBoard addTarget:nil action:NSSelectorFromString(@"moveToLeaderboard:") forControlEvents:UIControlEventTouchUpInside];
    moveToLeaderBoard.frame = CGRectMake((self.view.frame.size.width-100)/2, (self.view.frame.size.height-40)/1.20, 100, 40);
    name = [[NSString alloc]init];
    [self initAlertView];
    text = [[UITextView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-150)/2, (self.view.frame.size.height-50)/4, 150, 50)];
    motionManger = [[CMMotionManager alloc] init];
    clickHere = [UIImage imageNamed:@"click-here.png"];
    clicker = [[UIButton alloc] init];
    [clicker setImage:clickHere forState:UIControlStateNormal];
    clicker.frame = CGRectMake(10, 20, 400, 300);
    [clicker setContentMode:UIViewContentModeScaleAspectFit];
    clicker.center = self.view.center;
    submit = [UIButton buttonWithType:UIButtonTypeSystem];
    submit.frame = CGRectMake((self.view.frame.size.width-100)/2, (self.view.frame.size.height-40)/1.35, 100, 40);
    [submit setTitle:@"submit score" forState:UIControlStateNormal];
    
    
    if (motionManger.accelerometerAvailable) {
        [clicker addTarget:nil action:NSSelectorFromString(@"handleClick:") forControlEvents:UIControlEventTouchDown];
        [clicker addTarget:nil action:NSSelectorFromString(@"handleRelese:") forControlEvents:UIControlEventTouchUpInside];
        
    }
    [submit addTarget:nil action:NSSelectorFromString(@"submitClicked:") forControlEvents:UIControlEventTouchUpInside];
    [text setFont:[UIFont boldSystemFontOfSize:15]];
    text.textAlignment = NSTextAlignmentCenter;
    text.text = @"tilt the phone as hard as u can!!!";
    [self.view addSubview:clicker];
    [self.view addSubview:text];
    [self.view addSubview:submit];
    [self.view addSubview:moveToLeaderBoard];
    NSLog(@"did load");
}

-(void)handleClick:(UIButton*)sender{
    NSLog(@"did got here");
    max = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [motionManger startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData * _Nullable data, NSError * _Nullable error) {
                
                if((data.acceleration.z + data.acceleration.x + data.acceleration.y) > max){
                    max = data.acceleration.z + data.acceleration.x + data.acceleration.y;
                    NSLog(@"did get max : %f", data.acceleration.z);
                }
            }];
    });
}

-(void)handleRelese:(UIButton*)sender{
    [motionManger stopAccelerometerUpdates];
    max *= 100;
    score = (int)max;
    text.text = [NSString stringWithFormat:@"%i",score];
    switch (score / 100) {
        case 0:
            text.textColor = [UIColor blackColor];
            [text setFont:[UIFont boldSystemFontOfSize:15]];
            break;
        case 1:
            text.textColor = [UIColor greenColor];
            break;
        case 2:
            text.textColor = [UIColor blueColor];
            break;
        case 3:
            text.textColor = [UIColor yellowColor];
            break;
        case 4:
            text.textColor = [UIColor grayColor];
            break;
        case 5:
            text.textColor = [UIColor redColor];
            [text setFont:[UIFont boldSystemFontOfSize:20]];
            break;
        case 6:
            text.textColor = [UIColor magentaColor];
            [text setFont:[UIFont boldSystemFontOfSize:23]];
            break;
        case 7:
            text.textColor = [UIColor orangeColor];
            [text setFont:[UIFont boldSystemFontOfSize:26]];
            break;
        case 8:
            text.textColor = [UIColor purpleColor];
            [text setFont:[UIFont boldSystemFontOfSize:29]];
            break;
        case 9:
            text.textColor = [UIColor lightGrayColor];
            [text setFont:[UIFont boldSystemFontOfSize:33]];
            break;
        case 10:
            text.textColor = [UIColor cyanColor];
            [text setFont:[UIFont boldSystemFontOfSize:36]];
            break;
        case 11:
            text.textColor = [UIColor darkGrayColor];
            [text setFont:[UIFont boldSystemFontOfSize:39]];
            break;
        case 12:
            [text setFont:[UIFont boldSystemFontOfSize:42]];
            break;
        default:
            break;
    }
}

-(void)submitClicked:(UIButton*)sender{
    [self presentViewController:submitScoreAlert animated:YES completion:nil];
}

-(void)initAlertView{
    submitScoreAlert = [UIAlertController alertControllerWithTitle:@"Submit Score" message:@"here we submiting score" preferredStyle:UIAlertControllerStyleAlert];
    [submitScoreAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Enter Name";
    }];
    UIAlertAction * actionSubmit = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 2), ^{
            
            NSString *post = [NSString stringWithFormat:@"{\"name\":\"%@\",\"score\":%i}",submitScoreAlert.textFields[0].text,score];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLen = [NSString stringWithFormat:@"%lu",(unsigned long) [postData length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
            [request setURL:[NSURL URLWithString:@"http://35.184.144.226/strongest/"]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:postData];
            [request setValue:postLen forHTTPHeaderField:@"Content-Lenght"];
            [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//            NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *urlSession = [NSURLSession sharedSession];
            NSURLSessionDataTask *taskRequest = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *res = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
                    text.textColor = [UIColor blackColor];
                    [text setFont:[UIFont boldSystemFontOfSize:15]];
                    if ([res isEqualToString:@"ok"]) {
                        text.text = @"You're Score Sent!!!";
                    }else{
                        text.text = @"Something Went Wrong We Working On It!!!";
                    }
                    submitScoreAlert.textFields[0].text = @"";
                });
            }];
            [taskRequest resume];
            
        });
    }];
    UIAlertAction * actionClose = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [submitScoreAlert addAction:actionSubmit];
    [submitScoreAlert addAction:actionClose];
}

-(void)moveToLeaderboard:(UIButton*)sender{
    if (leaderBoardController == nil) {
        leaderBoardController = [[LeaderBoard alloc]init];
    }
    [self presentViewController:leaderBoardController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
