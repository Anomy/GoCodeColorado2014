//
//  BaseSearchResultModel.m
//  ProfFinder
//
//  Created by Allison Allain on 3/22/14.
//  Copyright (c) 2014 Allison Wonderland Games. All rights reserved.
//

#import "BaseSearchResultModel.h"

@implementation BaseSearchResultModel

- (id)initWithDict:(NSDictionary*) dict {
    self = [super init];
    if (self) {
        dict = @{IMAGE_URL_KEY : @"https://pbs.twimg.com/profile_images/446670026171367424/jaHV0iuu.jpeg", NAME_KEY : @"Aly", DEPARTMENT_NAME_KEY : @"Informatics", WEBSITE_URL_KEY : @"https://twitter.com/AnomicAli"};

        _imageURL = [dict objectForKey:IMAGE_URL_KEY];
        _name = [dict objectForKey:NAME_KEY];
        _departmentName = [dict objectForKey:DEPARTMENT_NAME_KEY];
        _websiteURL = [dict objectForKey:WEBSITE_URL_KEY];
    }
    return self;

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
