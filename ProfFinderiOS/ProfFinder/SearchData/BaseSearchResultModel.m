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
        dict = @{IMAGE_URL_KEY : @"https://pbs.twimg.com/profile_images/446670026171367424/jaHV0iuu.jpeg", NAME_KEY : @"Aly", DEPARTMENT_NAME_KEY : @"Informatics", WEBSITE_URL_KEY : @"https://twitter.com/AnomicAli", HILIGHTS_KEY : @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."};

        _imageURL = [dict objectForKey:IMAGE_URL_KEY];
        _name = [dict objectForKey:NAME_KEY];
        _departmentName = [dict objectForKey:DEPARTMENT_NAME_KEY];
        _websiteURL = [dict objectForKey:WEBSITE_URL_KEY];
        _hilightsblurb = [NSAttributedString attributedStringWithAttachment:[dict objectForKey:HILIGHTS_KEY]];
    }
    return self;

}


@end
