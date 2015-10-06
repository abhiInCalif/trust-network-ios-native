//
//  MyQuestionsViewController.m
//  TrustNetwork
//
//  Created by Abhinav Khanna on 9/8/15.
//  Copyright (c) 2015 Abhinav Khanna. All rights reserved.
//

#import "MyQuestionsViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "QuestionDetailTableViewController.h"

@interface MyQuestionsViewController ()

@end

@implementation MyQuestionsViewController
@synthesize questionTable;

NSArray* myQuestionData;

- (IBAction)unwindToQuestionList:(UIStoryboardSegue *)segue {
    // empty method for now
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://localhost:8080/ask/list?askerUrn=%@", @"6507761881"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        myQuestionData = responseObject;
        [questionTable reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    myQuestionData = [[NSArray alloc] init]; // create an empty data list.
    questionTable = (UITableView*)[self.view viewWithTag:22];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myQuestionData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MyQuestionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    UILabel *label;
    if ([myQuestionData count] > 0) {
        NSDictionary* question_data = [myQuestionData objectAtIndex:indexPath.row];
        
        NSString* question;
        if ([question_data objectForKey:@"questionText"] == nil) {
            question = [question_data objectForKey:@"question"];
        } else {
            question = [question_data objectForKey:@"questionText"];
        }
        
        label = (UILabel *)[cell viewWithTag:20];
        [label sizeToFit];
        label.text = question;
    }
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"questionDetail"]) {
        NSIndexPath* selectedPath = [questionTable indexPathForSelectedRow];
        NSString* questionUrn = [[myQuestionData objectAtIndex:selectedPath.row] objectForKey:@"question_urn"];
        QuestionDetailTableViewController* destViewController = segue.destinationViewController;
        [destViewController setQuestionUrn:questionUrn];
    }
}


@end
