//
//  MyRepliesViewController.h
//  TrustNetwork
//
//  Created by Abhinav Khanna on 9/8/15.
//  Copyright (c) 2015 Abhinav Khanna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRepliesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic) UITableView* replyTable;

- (IBAction)unwindToReplyList:(UIStoryboardSegue *)segue;

@end
