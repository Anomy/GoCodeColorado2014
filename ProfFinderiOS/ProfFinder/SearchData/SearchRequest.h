//
//  SearchResultsManager.h
//  ProfFinder
//
//  Created by Allison Allain on 3/22/14.
//  Copyright (c) 2014 Allison Wonderland Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "JSONModel.h"

@class SearchResults;

@interface SearchRequest : NSObject
@property (nonatomic, strong) SearchResults *parsedSearchResults;
- (void) jsonTapped:(id)sender;

@end

@interface SearchResults : NSObject
@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) NSString *numRows;

@end

@interface SingleRow : NSObject
//required: id name and department
//profile_url, profile_img_url
@property UIImage  *image;
@property NSString *id;
@property NSString *name;
@property NSString *department;
@property NSString *profile_url;
@property NSString *profile_img_url;
@property NSAttributedString *es_highlights;

-(id) initWithDict:(NSDictionary*)dict;

@end;
