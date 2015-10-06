//
//  AddAQuestionTableViewController.m
//  TrustNetwork
//
//  Created by Abhinav Khanna on 9/14/15.
//  Copyright (c) 2015 Abhinav Khanna. All rights reserved.
//

#import "AddAQuestionTableViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface AddAQuestionTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (weak, nonatomic) IBOutlet UITextView *questionInput;
@property (weak, nonatomic) IBOutlet UIPickerView *questionTypePicker;

@end

@implementation AddAQuestionTableViewController

NSArray* questionTypes;

- (void)viewDidLoad {
    [super viewDidLoad];
    questionTypes = [[NSArray alloc] initWithObjects:@"Verifications", @"Recommendations", @"Other", nil];
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
    return 3;
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return questionTypes.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return questionTypes[row];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender == self.doneButton) {
        // submit the request to create a new entry!
        // gather the information and make the network request to create the new contact!
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString* dataString = [NSString stringWithFormat:@"{\"%@\": \"%@\", \"%@\": \"%@\"}",
                                @"questionText", [self cleanQuestionText: self.questionInput.text],
                                @"questionType", [questionTypes objectAtIndex:[self.questionTypePicker selectedRowInComponent:0]]];
        NSDictionary *params = @{@"askerUrn": @"6507761881",
                                 @"data": dataString
                                 };
        [manager POST:@"http://localhost:8080/ask/create" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}

- (NSString*) cleanQuestionText:(NSString*)questionText {
    NSString* text = [questionText stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];;
    while ([text containsString:@"\n\n"]) {
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    }
    text = [text stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
    return text;
}

@end
