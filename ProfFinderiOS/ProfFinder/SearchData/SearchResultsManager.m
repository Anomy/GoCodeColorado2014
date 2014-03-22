//
//  SearchResultsManager.m
//  ProfFinder
//
//  Created by Allison Allain on 3/22/14.
//  Copyright (c) 2014 Allison Wonderland Games. All rights reserved.
//

#import "SearchResultsManager.h"
#import "BaseSearchResultModel.h"

static NSString * const BaseURLString = @"http://www.raywenderlich.com/demos/weather_sample/";

@implementation SearchResultsManager

- (id) init {
    self = [super init];
    if (self) {
        _searchResults = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i<5; i++) {
            BaseSearchResultModel *model = [[BaseSearchResultModel alloc] initWithDict:nil];
            [_searchResults addObject:model];
        }
        
        [self jsonTapped:nil];
    }
    return self;
}


- (void)jsonTapped:(id)sender
{
    // 1
    NSString *string = [NSString stringWithFormat:@"%@weather.php?format=json", BaseURLString];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        NSDictionary *weather = (NSDictionary *)responseObject;
        NSLog(@"weather:%@", responseObject);
        NSString *title = @"JSON Retrieved";
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];
}

@end
