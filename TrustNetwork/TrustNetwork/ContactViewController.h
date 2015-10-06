//
//  SecondViewController.h
//  TrustNetwork
//
//  Created by Abhinav Khanna on 9/8/15.
//  Copyright (c) 2015 Abhinav Khanna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic) UITableView* contactsTable;
+ (NSString*) formatPhoneNumber:(NSString*)phoneNumber;
- (IBAction)unwindToContactView:(UIStoryboardSegue *)segue;

@end

