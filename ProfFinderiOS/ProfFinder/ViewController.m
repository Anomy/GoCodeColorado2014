//
//  ViewController.m
//  ProfFinder
//
//  Created by Allison Allain on 3/22/14.
//  Copyright (c) 2014 Allison Wonderland Games. All rights reserved.
//

#import "ViewController.h"
#import "UserDefaults.h"

@interface ViewController ()
//UI
@property (weak, nonatomic) IBOutlet UIButton *checkBox;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setCheckBoxImage];
    [self setTextFieldValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIFeedback

- (void) setCheckBoxImage {
    if ([UserDefaults getShouldStoreUsername]) {
        [self.checkBox setBackgroundImage:[UIImage imageNamed:@"checked_checkbox_128"] forState:UIControlStateNormal];
    }
    else {
        [self.checkBox setBackgroundImage:[UIImage imageNamed:@"unchecked_checkbox_128"] forState:UIControlStateNormal];
    }
}

- (void) setTextFieldValue {
    self.usernameTextField.text = [UserDefaults getUserStoredEmail];
}

- (IBAction)checkBoxPressed:(id)sender {
    BOOL shouldStore = [UserDefaults getShouldStoreUsername];
    [UserDefaults setShouldStoreUsername:!shouldStore];
    [self setCheckBoxImage];
}

- (IBAction) loginButtonPressed:(id)sender {
    if ([UserDefaults getShouldStoreUsername]) {
        [UserDefaults setUserStoredEmail:self.usernameTextField.text];
    }
    else {
        [UserDefaults setUserStoredEmail:nil];
    }
}
@end
