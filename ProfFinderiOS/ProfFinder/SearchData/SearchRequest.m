//
//  SearchResultsManager.m
//  ProfFinder
//
//  Created by Allison Allain on 3/22/14.
//  Copyright (c) 2014 Allison Wonderland Games. All rights reserved.
//

#import "SearchRequest.h"
#import "BaseSearchResultModel.h"

#define KEY @"rUSj3bjkSrqPIpFybPammQ=="
#define SECRET @"1mEqgu13Ry6KzlbmoRNcSQ=="

#define API_URL @"https://api.datalanche.com/rpedela.gocodecolorado/query"
#define LIMIT 10

@implementation SearchRequest

- (id) init {
    self = [super init];
    if (self) {
        _parsedSearchResults = [[SearchResults alloc] init];
        [self jsonTapped:nil];
    }
    return self;
}


- (void) jsonTapped:(id)sender
{    
    NSString *params = [self getSerializedDict];
    NSData *postData = [params dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:API_URL]];
    [request setHTTPMethod:@"POST"];
    //Authorization: Basic BASE_64_ENCODE(API_KEY:API_SECRET)
    NSMutableString *authString = (NSMutableString*)[@"" stringByAppendingFormat:@"%@:%@", KEY, SECRET];
    NSString *encodedAuthData = [self base64Encode:[authString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *authHeader = [@"Basic " stringByAppendingFormat:@"%@", encodedAuthData];
    [request addValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"RESPONSE:%@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"DATA:%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSError *error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:&error];
    NSArray *rows = [json objectForKey:@"rows"];
    NSMutableArray *tempMutableRows = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *dict in rows) {
        SingleRow *aRow = [[SingleRow alloc] initWithDict:dict];
        [tempMutableRows addObject:aRow];
    }
    self.parsedSearchResults.rows = tempMutableRows;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchResultsUpdated" object:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"CONNECTION FINISHED");
}

#pragma mark - serialize

- (NSString*) getSerializedDict {
    return [self serialzedDictionary:[self parameters]];
}

- (NSDictionary*) parameters {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableArray *select = [[NSMutableArray alloc] initWithCapacity:0];
    [select addObject:@"id"];
    [select addObject:@"name"];
    [select addObject:@"department"];
    [select addObject:@"profile_url"];
    [select addObject:@"profile_img_url"];
    [select addObject:@"_es_highlights"];

    [dict setObject:select forKey:@"select"];
    [dict setObject:@"cu_faculty_profiles" forKey:@"from"];
    [dict setObject:@"reduced pressure" forKey:@"search"];
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"offset"];
    [dict setObject:[NSNumber numberWithInt:LIMIT] forKey:@"limit"];
    
    return dict;
}

- (NSString*) serialzedDictionary:(NSDictionary*) jsonDict {
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:nil];
    NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    return jsonString;
}


//Method Curtosy of datalanche
static char *alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
-(NSString *)base64Encode:(NSData *)plainText
{
    //static char *alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    int encodedLength = (4 * (([plainText length] / 3) + (1 - (3 - ([plainText length] % 3)) / 3))) + 1;
    char *outputBuffer = malloc(encodedLength);
    unsigned char *inputBuffer = (unsigned char *)[plainText bytes];
    
    NSInteger i;
    NSInteger j = 0;
    int remain;
    
    for(i = 0; i < [plainText length]; i += 3) {
        remain = [plainText length] - i;
        
        outputBuffer[j++] = alphabet[(inputBuffer[i] & 0xFC) >> 2];
        outputBuffer[j++] = alphabet[((inputBuffer[i] & 0x03) << 4) |
                                     ((remain > 1) ? ((inputBuffer[i + 1] & 0xF0) >> 4): 0)];
        
        if(remain > 1)
            outputBuffer[j++] = alphabet[((inputBuffer[i + 1] & 0x0F) << 2)
                                         | ((remain > 2) ? ((inputBuffer[i + 2] & 0xC0) >> 6) : 0)];
        else
            outputBuffer[j++] = '=';
        
        if(remain > 2)
            outputBuffer[j++] = alphabet[inputBuffer[i + 2] & 0x3F];
        else
            outputBuffer[j++] = '=';
    }
    
    outputBuffer[j] = 0;
    
    //    NSString *result = [NSString stringWithCString:outputBuffer length:strlen(outputBuffer)];
    NSString *result = [NSString stringWithCString:outputBuffer encoding:NSUTF8StringEncoding];
    free(outputBuffer);
    
    return result;
}

@end


@implementation SearchResults

-(id) init {
    self = [super init];
    if (self) {

    }
    return self;
}

@end

@implementation SingleRow
-(id) initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        _id = [self safeObjectForKey:dict withKey:@"id"];
        _name = [self safeObjectForKey:dict withKey:@"name"];
        _department = [self safeObjectForKey:dict withKey:@"department"];
        _profile_url = [self safeObjectForKey:dict withKey:@"profile_url"];
        _profile_img_url = [self safeObjectForKey:dict withKey:@"profile_img_url"];
        if ([dict objectForKey:@"_es_highlights"]) {
            NSDictionary *hilights = [dict objectForKey:@"_es_highlights"];
            NSArray *profileContent = [hilights objectForKey:@"profile_content"];
            if (hilights) {
                NSMutableString *trimString = [NSMutableString stringWithString:[profileContent firstObject]];
                [trimString replaceOccurrencesOfString:@"<strong>" withString:@"" options:0 range:NSMakeRange(0, [trimString length])];
                [trimString replaceOccurrencesOfString:@"</strong>" withString:@"" options:0 range:NSMakeRange(0, [trimString length])];
                _es_highlights = [[NSAttributedString alloc] initWithString:trimString];
            }
        }
    }
    return self;
}

-(NSString*) safeObjectForKey:(NSDictionary*) dict withKey:(NSString*)key {
    if (key) {
        if ([[dict objectForKey:key] isKindOfClass:[NSString class]]) {
            NSString *string = [dict objectForKey:key];
            if (string) {
                if (string.length > 0) {
                    return string;
                }
            }
        }
    }
    return nil;
}
@end
