//
//  SearchViewController.m
//  ProfFinder
//
//  Created by Allison Allain on 3/22/14.
//  Copyright (c) 2014 Allison Wonderland Games. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchRequest.h"
#import "WebViewController.h"

#define FACULTY_INDEX 0
#define CAREER_FAIR_INDEX 1

typedef enum {
    CELL_VIEW = 100,
    IMAGE_VIEW, //101
    NAME_LABEL, //102
    WEBSITE_LABEL, //103
    DEPARTMENT_LABEL, //104
    HIGHLIGHT_TEXT_FIELD, //105
    FAIR_LOCATION_LABEL, //106
    FAIR_DATE_LABEL, //107
    FAIR_TIME_LABEL, //108
} UIVIEW_TAGS;

@interface SearchViewController ()
//Outlets
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UITextField *searchBar;
@end

@implementation SearchViewController

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //Load Data
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"SearchResultsUpdated" object:nil];
//    [self.tableView reloadData];
}

-(void) reloadTable {
//    NSLog(@"Segment:%d Data:%@", self.segmentedControl.selectedSegmentIndex, self.facultyData.parsedSearchResults.rows);
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search Pressed

-(IBAction) searchButtonPressed:(id)sender {

    if (!self.facultyData) {
        self.facultyData = [[SearchResults alloc] initSearchType:Faculty];
    }
    
    if (!self.fairData) {
        self.fairData = [[SearchResults alloc] initSearchType:CareerFair];
    }

    [self performSelector:@selector(reload) withObject:nil afterDelay:2];
}

-(void) reload {
//    [self.tableView reloadData];
    [self segementedControllerValueChanged: nil];
    [self.searchBar resignFirstResponder];
}

#pragma mark - Segmented Controller

- (IBAction)segementedControllerValueChanged:(id)sender {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case FACULTY_INDEX: {
            self.selectedData = self.facultyData;
            break;
        }
        case CAREER_FAIR_INDEX: {
            self.selectedData = self.fairData;
            break;
        }
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - TableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SingleRow *aResult = [self.selectedData.rows objectAtIndex:indexPath.row];

    UITableViewCell *cell = nil;
    switch (self.segmentedControl.selectedSegmentIndex) {
        case FACULTY_INDEX: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"FacultyCell"];
            
            UIImageView *profileImage = (UIImageView *)[cell viewWithTag:IMAGE_VIEW];
            if (!aResult.image) {
                NSURL *url = [NSURL URLWithString:aResult.profile_img_url];
                [SearchViewController loadFromURL:url callback:^(UIImage *callbackImage) {
                    aResult.image = callbackImage;
                    profileImage.image = aResult.image;
                }];
            } else {
                profileImage.image = aResult.image;
            }
            
            UILabel *nameLabel = (UILabel *)[cell viewWithTag:NAME_LABEL];
            nameLabel.text = aResult.name;
            
            UILabel *webLinkButton = (UILabel *)[cell viewWithTag:WEBSITE_LABEL];
            webLinkButton.text = aResult.profile_url;
            
            UILabel *departmentLabel = (UILabel *)[cell viewWithTag:DEPARTMENT_LABEL];
            departmentLabel.text = aResult.department;
            
            UITextView *textView = (UITextView*)[cell viewWithTag:HIGHLIGHT_TEXT_FIELD];
            textView.text = aResult.es_highlights;

            break;
        }
        case CAREER_FAIR_INDEX: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CareerFairCell"];
            
            UIImageView *profileImage = (UIImageView *)[cell viewWithTag:IMAGE_VIEW];
            int rand = arc4random()%7+1;
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"career-fair-%d", rand]];
            profileImage.image = image;
            
            UILabel *nameLabel = (UILabel *)[cell viewWithTag:NAME_LABEL];
            nameLabel.text = aResult.fair_name;
            
            UILabel *webLinkButton = (UILabel *)[cell viewWithTag:WEBSITE_LABEL];
            webLinkButton.text = aResult.career_center_link;
            
            UILabel *departmentLabel = (UILabel *)[cell viewWithTag:DEPARTMENT_LABEL];
            departmentLabel.text = aResult.institution;

            UILabel *locationLabel = (UILabel *)[cell viewWithTag:FAIR_LOCATION_LABEL];
            locationLabel.text = aResult.location;

            UILabel *fairDateLabel = (UILabel *)[cell viewWithTag:FAIR_DATE_LABEL];
            fairDateLabel.text = aResult.date;

            UILabel *fairTimeLabel = (UILabel *)[cell viewWithTag:FAIR_TIME_LABEL];
            fairTimeLabel.text = [NSString stringWithFormat:@"%@ - %@", aResult.start_end, aResult.end_time];

            
            UITextView *textView = (UITextView*)[cell viewWithTag:HIGHLIGHT_TEXT_FIELD];
            textView.text = aResult.es_highlights;
            
            break;
        }
        default:
            break;
    }
    

    return cell;
}

#pragma mark - TableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedData.rows.count;
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

    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    SingleRow *row = [self.selectedData.rows objectAtIndex:path.row];
    WebViewController *webViewController = (WebViewController*)segue.destinationViewController;
    if (row.career_center_link) {
        webViewController.url = row.career_center_link;
        webViewController.screenTitle = row.fair_name;
    } else if (row.profile_url){
        webViewController.url =row.profile_url;
        webViewController.screenTitle = row.name;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"No profile was available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

+ (void) loadFromURL: (NSURL*) url callback:(void (^)(UIImage *image))callback {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:imageData];
            callback(image);
        });
    });
}


@end
