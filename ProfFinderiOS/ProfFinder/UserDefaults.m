//
//  UserDefaults.m
//  ProfFinder
//
//  Created by Allison Allain on 3/22/14.
//  Copyright (c) 2014 Allison Wonderland Games. All rights reserved.
//

#import "UserDefaults.h"

@implementation UserDefaults

#define STORED_EMAIL @"User_Email" 
#define SHOULD_STORE_EMAIL @"Remeber_Username"



+ (NSString*) getUserStoredEmail {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *storedEmail = [defaults objectForKey:STORED_EMAIL];
    if (storedEmail) {
        return storedEmail;
    }
    return nil;
}

+ (void) setUserStoredEmail:(NSString*) email {
    if (email) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:email forKey:STORED_EMAIL];
        [defaults synchronize];
    }
}

+ (BOOL) getShouldStoreUsername {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *shouldStoreEmail = [defaults objectForKey:SHOULD_STORE_EMAIL];
    return [shouldStoreEmail boolValue];
}

+ (void) setShouldStoreUsername:(BOOL) shouldStoreUsername {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *numberAsBool = [NSNumber numberWithBool:shouldStoreUsername];
    [defaults setObject:numberAsBool forKey:SHOULD_STORE_EMAIL];
    [defaults synchronize];
}

@end
