//
//  LoginPhoneNumberViewController.m
//  TrustNetwork
//
//  Created by Abhinav Khanna on 10/5/15.
//  Copyright © 2015 Abhinav Khanna. All rights reserved.
//

#import "LoginPhoneNumberViewController.h"
#import "ReadWritePlist.h"

@interface LoginPhoneNumberViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstPhoneNumberInput;
@property (weak, nonatomic) IBOutlet UITextField *secondPhoneNumberInput;
@property (weak, nonatomic) IBOutlet UITextField *thirdPhoneNumberInput;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ReadWritePlist *rwPlist = [ReadWritePlist new];
    NSDictionary* existingData = [rwPlist readFromPlist:@"PhoneNumber"];
    if (![[existingData objectForKey:@"phoneNumber"] isEqualToString:@""]) {
        // forward the page to next view
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9][0-9][0-9]" options:0 error:nil];
    if ([self.firstPhoneNumberInput.text length] != 3 || ![regex matchesInString:self.firstPhoneNumberInput.text options:0 range:NSMakeRange(0, 2)]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Format"
                                                        message:@"The first part of a phone number consists of exactly 3 digits."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    } else if ([self.secondPhoneNumberInput.text length] != 3 || ![regex matchesInString:self.secondPhoneNumberInput.text options:0 range:NSMakeRange(0, 2)]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Format"
                                                        message:@"The second part of a phone number consists of exactly 3 digits."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    } else if ([self.thirdPhoneNumberInput.text length] != 4 || ![regex matchesInString:self.thirdPhoneNumberInput.text options:0 range:NSMakeRange(0, 3)]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Format"
                                                        message:@"The second part of a phone number consists of exactly 4 digits."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    } else {
        return YES;
    }
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (sender == self.loginButton) {
        // login segue
        // store the result in some type of preferences folder for easy access later
        ReadWritePlist* rwPlist = [ReadWritePlist new];
        [rwPlist writeToPlist:[NSString stringWithFormat:@"%@%@%@", self.firstPhoneNumberInput.text, self.secondPhoneNumberInput.text, self.thirdPhoneNumberInput.text]];
        NSDictionary* existingData = [rwPlist readFromPlist:@"PhoneNumber"];
        // make network call to register a new member.
        printf("Hello world");
    }
}


@end
