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

//@class SearchResults;

typedef enum {
    Faculty = 0,
    CareerFair
} SearchType;

/*

//@interface SearchRequest : NSObject
@property (nonatomic, strong) SearchResults *parsedSearchResults;
@property (nonatomic, strong) NSURLConnection *connection;
//- (void) makeRequestWithSearchTerm:(NSString*)searchCriteria;
@end
*/

@interface SearchResults : NSObject
@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) NSString *numRows;

-(id) initSearchType:(SearchType)searchType;

@end

@interface SingleRow : NSObject
//required: id name and department
//profile_url, profile_img_url
@property (nonatomic, strong) UIImage  *image;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name; //yes - faculty
@property (nonatomic, strong) NSString *department; //yes - faculty
@property (nonatomic, strong) NSString *profile_url; //yes - faculty
@property (nonatomic, strong) NSString *profile_img_url; //yes - faculty
@property (nonatomic, strong) NSString *es_highlights; //unknown 
@property (nonatomic, strong) NSString *career_center_link;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, strong) NSString *fair_name;
@property (nonatomic, strong) NSString *institution;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *start_end;

-(id) initWithDict:(NSDictionary*)dict;

@end;
