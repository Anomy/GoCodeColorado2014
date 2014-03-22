//
//  SearchResultsManager.m
//  ProfFinder
//
//  Created by Allison Allain on 3/22/14.
//  Copyright (c) 2014 Allison Wonderland Games. All rights reserved.
//

#import "SearchResultsManager.h"
#import "BaseSearchResultModel.h"

@implementation SearchResultsManager

- (id) init {
    self = [super init];
    if (self) {
        _searchResults = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i<5; i++) {
            BaseSearchResultModel *model = [[BaseSearchResultModel alloc] initWithDict:nil];
            [_searchResults addObject:model];
        }
    }
    return self;
}

@end
