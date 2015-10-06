//
//  QuestionDetailTableViewController.m
//  TrustNetwork
//
//  Created by Abhinav Khanna on 9/19/15.
//  Copyright (c) 2015 Abhinav Khanna. All rights reserved.
//

#import "QuestionDetailTableViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "QuestionTableViewCell.h"
#import "ReplyYesTableViewCell.h"
#import "ReplyNoTableViewCell.h"

@interface QuestionDetailTableViewController ()

@end

@implementation QuestionDetailTableViewController
@synthesize questionUrn;

NSMutableArray* questionData;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    questionData = [NSMutableArray new];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"askerUrn": @"6507761881",
                             @"questionUrn": questionUrn
                             };
    [manager POST:@"http://localhost:8080/ask/detail" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSArray* question_data = [NSArray arrayWithObject:[responseObject objectForKey:@"question_data"]];
        NSArray* reply_data = [responseObject objectForKey:@"reply_data"];
        [questionData addObjectsFromArray:question_data];
        [questionData addObjectsFromArray:reply_data];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [questionData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // return question height
        return 150;
    } else {
        // return the reply height
        return 150;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QuestionTableViewCell* cell = (QuestionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"QuestionCell" forIndexPath:indexPath];
        cell.questionSubject.text = [[questionData objectAtIndex:indexPath.row] objectForKey:@"questionText"];
        return cell;
    }
    
    // since currently there is no way of specifying yes o no, we are just going to assume all replies are of type
    // verify and YES responses
    // TODO -- implement the actual logic that will suppor the different types of responses that we want to allow depending on
    // question type
    NSString* isYes = [[questionData objectAtIndex:indexPath.row] objectForKey:@"isYes"];
    if ([isYes isEqualToString:@"1"]) {
        ReplyYesTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ReplyYesCell" forIndexPath:indexPath];
        cell.replyText.text = [[questionData objectAtIndex:indexPath.row] objectForKey:@"replyText"];
    
        NSString* phoneNumber = [[questionData objectAtIndex:indexPath.row] objectForKey:@"actor_urn"];
        cell.fromLabel.text = [NSString stringWithFormat:@"From: (%@) %@-%@", [phoneNumber substringToIndex:3], [phoneNumber substringWithRange:NSMakeRange(3, 3)], [phoneNumber substringWithRange:NSMakeRange(6,4)]];
        return cell;
    } else {
        ReplyNoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ReplyNoCell" forIndexPath:indexPath];
        cell.replyText.text = [[questionData objectAtIndex:indexPath.row] objectForKey:@"replyText"];
        
        NSString* phoneNumber = [[questionData objectAtIndex:indexPath.row] objectForKey:@"actor_urn"];
        cell.fromLabel.text = [NSString stringWithFormat:@"From: (%@) %@-%@", [phoneNumber substringToIndex:3], [phoneNumber substringWithRange:NSMakeRange(3, 3)], [phoneNumber substringWithRange:NSMakeRange(6,4)]];
        return cell;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
