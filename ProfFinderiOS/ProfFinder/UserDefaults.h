//
//  UserDefaults.h
//  ProfFinder
//
//  Created by Allison Allain on 3/22/14.
//  Copyright (c) 2014 Allison Wonderland Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject
+ (NSString*) getUserStoredEmail;
+ (void) setUserStoredEmail:(NSString*) email;
+ (BOOL) getShouldStoreUsername;
+ (void) setShouldStoreUsername:(BOOL) shouldStoreUsername;
@end
