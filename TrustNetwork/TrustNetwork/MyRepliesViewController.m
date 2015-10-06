//
//  MyRepliesViewController.m
//  TrustNetwork
//
//  Created by Abhinav Khanna on 9/8/15.
//  Copyright (c) 2015 Abhinav Khanna. All rights reserved.
//

#import "MyRepliesViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "ReplyDetailViewController.h"

@interface MyRepliesViewController ()

@end

@implementation MyRepliesViewController

@synthesize replyTable;

NSArray* replyData;

- (IBAction)unwindToReplyList:(UIStoryboardSegue *)segue {
    // empty method for now
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    replyData = [[NSArray alloc] init]; // create an empty data list.
    replyTable = (UITableView*)[self.view viewWithTag:12];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://localhost:8080/respond/fetch?targetMember=%@", @"6507761881"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        replyData = responseObject;
        [replyTable reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [replyData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ReplyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:10];
    [label sizeToFit];
    if ([replyData count] > 0) {
        NSDictionary* question_data = [[replyData objectAtIndex:indexPath.row] objectForKey:@"question_data"];
        NSString* title;
        if ([question_data objectForKey:@"name"] == nil) {
            NSString* phoneNumber = [[replyData objectAtIndex:indexPath.row] objectForKey:@"asker_urn"];
            title = [NSString stringWithFormat:@"From: (%@) %@-%@", [phoneNumber substringToIndex:3], [phoneNumber substringWithRange:NSMakeRange(3, 3)], [phoneNumber substringWithRange:NSMakeRange(6,4)]];
        } else {
            title = [question_data objectForKey:@"name"];
        }
        
        NSString* question = [question_data objectForKey:@"questionText"];
        if (question == nil) {
            question = [question_data objectForKey:@"question"];
        }
        label.text = title;
        
        label = (UILabel *)[cell viewWithTag:11];
        [label sizeToFit];
        label.text = question;
    }
    
    return cell;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toReplyDetail"]) {
        // we are going to the detail page, don't forget to set the askerUrn for that View
        UINavigationController* dstNavigationController = segue.destinationViewController;
        ReplyDetailViewController* detailViewController = [[dstNavigationController viewControllers] objectAtIndex:0];
        NSIndexPath* selectedPath = [replyTable indexPathForSelectedRow];
        NSString* asker_urn = [[replyData objectAtIndex:selectedPath.row] objectForKey:@"asker_urn"];
        NSString* question_urn = [[replyData objectAtIndex:selectedPath.row] objectForKey:@"question_urn"];
        [detailViewController setAskerUrn:asker_urn];
        [detailViewController setQuestionUrn:question_urn];
    }
}


@end
