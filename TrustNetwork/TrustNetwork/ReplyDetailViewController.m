//
//  ReplyDetailViewController.m
//  TrustNetwork
//
//  Created by Abhinav Khanna on 9/24/15.
//  Copyright © 2015 Abhinav Khanna. All rights reserved.
//

#import "ReplyDetailViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface ReplyDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *questionType;
@property (weak, nonatomic) IBOutlet UITextView *replyText;
@property (weak, nonatomic) IBOutlet UITabBarItem *yesBarItem;
@property (weak, nonatomic) IBOutlet UITabBar *YesNoBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *questionText;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UITabBar *nobar;
@property (weak, nonatomic) IBOutlet UITabBarItem *noTabBarItem;

@end

@implementation ReplyDetailViewController

@synthesize askerUrn;
@synthesize questionUrn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"askerUrn": askerUrn,
                             @"questionUrn": questionUrn,
                             @"actorUrn": @"6507761881"
                             };
    [manager POST:@"http://localhost:8080/respond/fetch/question/detail" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary* question_data = [responseObject objectForKey:@"question_data"];
        NSDictionary* reply_data = [responseObject objectForKey:@"reply_data"];
        // now set all the properties so that the view can be shown properly!
        self.questionText.text = [question_data objectForKey:@"questionText"];
        NSString* phoneNumber = [question_data objectForKey:@"asker_urn"];
        self.fromLabel.text = [NSString stringWithFormat:@"From: (%@) %@-%@", [phoneNumber substringToIndex:3], [phoneNumber substringWithRange:NSMakeRange(3, 3)], [phoneNumber substringWithRange:NSMakeRange(6,4)]];
        self.questionType.text = [NSString stringWithFormat:@"Type: %@", [question_data objectForKey:@"questionType"]];
        self.replyText.text = [reply_data objectForKey:@"replyText"];
        NSString* isYes = [reply_data objectForKey:@"isYes"];
        if ([isYes isEqualToString:@"1"]) {
            [self.YesNoBar setSelectedItem:self.yesBarItem];
        } else {
            [self.nobar setSelectedItem:self.noTabBarItem];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (sender == self.doneButton) {
        // its time to make the post request to post the reply to the server!
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString* dataString = [NSString stringWithFormat:@"{\"%@\": \"%@\", \"%@\": \"%i\", \"%@\": \"%i\"}",
                                @"replyText", self.replyText.text,
                                @"isYes", self.YesNoBar.selectedItem == self.yesBarItem,
                                @"isNo", self.nobar.selectedItem == self.noTabBarItem];
        NSDictionary *params = @{@"askerUrn": askerUrn,
                                 @"questionUrn": questionUrn,
                                 @"actorUrn": @"6507761881",
                                 @"data": dataString
                                 };
        [manager POST:@"http://localhost:8080/respond/reply" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}

@end
