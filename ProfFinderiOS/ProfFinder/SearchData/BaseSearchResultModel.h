//
//  BaseSearchResultModel.h
//  ProfFinder
//
//  Created by Allison Allain on 3/22/14.
//  Copyright (c) 2014 Allison Wonderland Games. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IMAGE_URL_KEY @"image_url"
#define NAME_KEY @"name"
#define DEPARTMENT_NAME_KEY @"department_name"
#define WEBSITE_URL_KEY @"website_url"
#define HILIGHTS_KEY @"hilights"

@interface BaseSearchResultModel : NSObject
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *departmentName;
@property (nonatomic, strong) NSAttributedString *hilightsblurb;
@property (nonatomic, strong) NSString *websiteURL;

- (id)initWithDict:(NSDictionary*) dict;
+ (void) loadFromURL: (NSURL*) url callback:(void (^)(UIImage *image))callback;

@end
