//
//  SearchViewController.h
//  ProfFinder
//
//  Created by Allison Allain on 3/22/14.
//  Copyright (c) 2014 Allison Wonderland Games. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class SearchRequest;
@class SearchResults;

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
+ (void) loadFromURL: (NSURL*) url callback:(void (^)(UIImage *image))callback;

@property (nonatomic, strong) SearchResults *facultyData;
@property (nonatomic, strong) SearchResults *fairData;
@property (nonatomic, strong) SearchResults *selectedData;

@end
