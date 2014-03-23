//
//  WebViewController.m
//  ProfFinder
//
//  Created by Allison Allain on 3/23/14.
//  Copyright (c) 2014 Allison Wonderland Games. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    
    self.navigationController.title = self.screenTitle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
