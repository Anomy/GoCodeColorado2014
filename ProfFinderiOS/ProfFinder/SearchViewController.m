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

#define FACULTY_INDEX 0
#define CAREER_FAIR_INDEX 1

typedef enum {
    CELL_VIEW = 100,
    IMAGE_VIEW, //101
    NAME_LABEL, //102
    WEBSITE_LABEL, //103
    DEPARTMENT_LABEL, //104
} UIVIEW_TAGS;

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
    self.fairData = [[SearchResultsManager alloc] init];
    
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
    UITableViewCell *cell = nil;
    switch (self.segmentedControl.selectedSegmentIndex) {
        case FACULTY_INDEX: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"FacultyCell"];
            break;
        }
        case CAREER_FAIR_INDEX: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CareerFairCell"];
            break;
        }
        default:
            break;
    }
    
    SearchResultsManager *searchResults = [self getCurrentlySelectedData];
    BaseSearchResultModel *model = [searchResults.searchResults objectAtIndex:[indexPath row]];
    
    UIImageView *profileImage = (UIImageView *)[cell viewWithTag:IMAGE_VIEW];
    if (!model.image) {
        NSURL *url = [NSURL URLWithString:model.imageURL];
        [BaseSearchResultModel loadFromURL:url callback:^(UIImage *callbackImage) {
            model.image = callbackImage;
            profileImage.image = model.image;
        }];
    } else {
        profileImage.image = model.image;
    }
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:NAME_LABEL];
    nameLabel.text = model.name;

    UILabel *webLinkButton = (UILabel *)[cell viewWithTag:WEBSITE_LABEL];
    webLinkButton.text = model.websiteURL;

    UILabel *departmentLabel = (UILabel *)[cell viewWithTag:DEPARTMENT_LABEL];
    departmentLabel.text = model.departmentName;

    return cell;
}

#pragma mark - Selected Data

- (SearchResultsManager*) getCurrentlySelectedData {
    SearchResultsManager *selectedDataSource = nil;
    switch (self.segmentedControl.selectedSegmentIndex) {
        case FACULTY_INDEX: {
            selectedDataSource = self.facultyData;
            break;
        }
        case CAREER_FAIR_INDEX: {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (self.segmentedControl.selectedSegmentIndex) {
        case FACULTY_INDEX: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"FacultyCell"];
            break;
        }
        case CAREER_FAIR_INDEX: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CareerFairCell"];
            break;
        }
        default:
            return 20;
            break;
    }
    return cell.frame.size.height;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
