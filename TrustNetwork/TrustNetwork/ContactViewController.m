//
//  SecondViewController.m
//  TrustNetwork
//
//  Created by Abhinav Khanna on 9/8/15.
//  Copyright (c) 2015 Abhinav Khanna. All rights reserved.
//

#import "ContactViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

NSArray* contactsData;

@synthesize contactsTable;

- (IBAction)unwindToContactView:(UIStoryboardSegue *)segue {
    // nothing special needs to happen in this
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://localhost:8080/contact/list?actorUrn=%@", @"6507761881"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        contactsData = responseObject;
        [contactsTable reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    contactsData = [[NSArray alloc] init]; // create an empty data list.
    contactsTable = (UITableView*)[self.view viewWithTag:32];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [contactsData count];
}

+ (NSString*) formatPhoneNumber:(NSString*)phoneNumber {
    return [NSString stringWithFormat:@"(%@) %@-%@", [phoneNumber substringToIndex:3], [phoneNumber substringWithRange:NSMakeRange(3, 3)], [phoneNumber substringWithRange:NSMakeRange(6,4)]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ContactCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:30];
    [label sizeToFit];
    if ([contactsData count] > 0) {
        NSDictionary* question_data = [contactsData objectAtIndex:indexPath.row];
        NSString* title = [question_data objectForKey:@"name"];
        label.text = title;
        
        NSString* phoneNumber = [question_data objectForKey:@"member_urn"];
        NSString* formattedPhoneNumber;
        if (phoneNumber.length == 10) {
            formattedPhoneNumber = [NSString stringWithFormat:@"(%@) %@-%@", [phoneNumber substringToIndex:3], [phoneNumber substringWithRange:NSMakeRange(3, 3)], [phoneNumber substringWithRange:NSMakeRange(6,4)]];
        } else {
            formattedPhoneNumber = phoneNumber;
        }
        
        label = (UILabel *)[cell viewWithTag:31];
        [label sizeToFit];
        label.text = formattedPhoneNumber;
        
        label = (UILabel *)[cell viewWithTag:32];
        [label sizeToFit];
        label.text = [question_data objectForKey:@"relationship"];
        
        label = (UILabel *)[cell viewWithTag:33];
        [label sizeToFit];
        label.text = [question_data objectForKey:@"emailAddress"];
        
    }
    
    return cell;
}

@end
