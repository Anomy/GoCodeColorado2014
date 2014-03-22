//
//  SearchViewController.m
//  ProfFinder
//
//  Created by Allison Allain on 3/22/14.
//  Copyright (c) 2014 Allison Wonderland Games. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultsManager.h"
#import "BaseSearchResultModel.h"

@interface SearchViewController ()
//Outlets
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
//Data
@property (nonatomic, strong) SearchResultsManager *facultyData;
@property (nonatomic, strong) SearchResultsManager *fairData;
@end

@implementation SearchViewController

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
    
    //Load In Table
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    
    //Load Data
    self.facultyData = [[SearchResultsManager alloc] init];
    self.facultyData.searchResults = [NSArray arrayWithObjects:@"Prof 1", @"Prof 2", @"Prof 3", nil];
    
    self.fairData = [[SearchResultsManager alloc] init];
    self.fairData.searchResults = [NSArray arrayWithObjects:@"Fair 1", @"Fair 2", @"Fair 3 3", nil];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segmented Controller

- (IBAction)segementedControllerValueChanged:(id)sender {
    [self.tableView reloadData];
}

#pragma mark - TableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"BaseCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [[self getCurrentlySelectedData].searchResults objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Selected Data

- (SearchResultsManager*) getCurrentlySelectedData {
    SearchResultsManager *selectedDataSource = nil;
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: {
            selectedDataSource = self.facultyData;
            break;
        }
        case 1: {
            selectedDataSource = self.fairData;
            break;
        }
        default:
            break;
    }
    return selectedDataSource;
}


#pragma mark - TableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SearchResultsManager *selectedDataSource = [self getCurrentlySelectedData];
    return selectedDataSource.searchResults.count;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
