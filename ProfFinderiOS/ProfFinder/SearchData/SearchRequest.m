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
#define LIMIT 5

/*
@implementation SearchRequest

- (id) initWtihSearchType:(SearchType)searchType {
    self = [super init];
    if (self) {
        self.parsedSearchResults = [[SearchResults alloc] init];
    }
    return self;
}
*/
/*
- (void) makeRequestWithSearchTerm:(NSString*)searchCriteria
{
    [self.parsedSearchResults.rows removeAllObjects];
    
    
    NSString *params = [self getSerializedDict:searchCriteria];
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

    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self.connection start];

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (self.connection == connection) {
        NSLog(@"RESPONSE:%@", response);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (self.connection == connection) {
        
        NSError *error;
        NSLog(@"data:%@", data);
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:&error];
        NSLog(@"json:%@", json);
        NSArray *rows = [json objectForKey:@"rows"];
        NSLog(@"rows:%@", rows);
        
        for (NSDictionary *dict in rows) {
            SingleRow *aRow = [[SingleRow alloc] initWithDict:dict];
            [self.parsedSearchResults.rows addObject:aRow];
        }
        NSLog(@"self.parsedSearchResults.rows:%@", self.parsedSearchResults.rows);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.connection == connection) {
        NSLog(@"CONNECTION FINISHED");
        [self postNotif];
    }
}

-(void) postNotif {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchResultsUpdated" object:self];
}


#pragma mark - serialize

- (NSString*) getSerializedDict:(NSString*) searchCriteria {
    return [self serialzedDictionary:[self parameters:searchCriteria]];
}

- (NSDictionary*) parameters:(NSString*) searchCriteria {
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
    [dict setObject:searchCriteria forKey:@"search"];
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
 */

@implementation SearchResults

-(id) initSearchType:(SearchType)searchType {
    self = [super init];
    if (self) {
        if (searchType == Faculty) {
            [self parseDict:[self getFacultyData]];
        } else {
            [self parseDict:[self getCareerFairData]];
        }
    }
    return self;
}

-(void) parseDict:(NSDictionary*)dataToParse {
    
    _rows = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *array = [NSArray arrayWithArray:[dataToParse objectForKey:@"rows"]];
    for (NSDictionary *dict in array) {
        SingleRow *aRow = [[SingleRow alloc] initWithDict:dict];
        [_rows addObject:aRow];
    }
    _numRows = [NSString stringWithFormat:@"%d", _rows.count];
}

-(NSDictionary*) getCareerFairData {
    NSString *textPath = [[NSBundle mainBundle] pathForResource:@"CareerFair" ofType:@"txt"];
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:textPath encoding:NSUTF8StringEncoding error:&error];  //error checking omitted
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSLog(@"CAREER FAIR:%@", jsonDict);
    return jsonDict;
}

-(NSDictionary*) getFacultyData {
    NSString *textPath = [[NSBundle mainBundle] pathForResource:@"Informatics" ofType:@"txt"];
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:textPath encoding:NSUTF8StringEncoding error:&error];  //error checking omitted
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSLog(@"Faculty:%@", jsonDict);
    return jsonDict;
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
                NSString *baseString = [profileContent firstObject];
                if (baseString) {
                    NSMutableString *trimString = [NSMutableString stringWithString:baseString];
                    [trimString replaceOccurrencesOfString:@"<strong>" withString:@"" options:0 range:NSMakeRange(0, [trimString length])];
                    [trimString replaceOccurrencesOfString:@"</strong>" withString:@"" options:0 range:NSMakeRange(0, [trimString length])];
                    _es_highlights = [self safeObjectForKey:dict withKey:@"career_center_link"];
                }
            }
        }
        _career_center_link =[self safeObjectForKey:dict withKey:@"career_center_link"];
        _date = [self safeObjectForKey:dict withKey:@"date"];
        _description = [self safeObjectForKey:dict withKey:@"description"];
        _end_time = [self safeObjectForKey:dict withKey:@"end_time"];
        _fair_name = [self safeObjectForKey:dict withKey:@"fair_name"];
        _institution = [self safeObjectForKey:dict withKey:@"institution"];
        _location = [self safeObjectForKey:dict withKey:@"location"];
        _start_end = [self safeObjectForKey:dict withKey:@"start_end"];
        
        NSLog(@"dict:%@", dict);
    }
    return self;
}

-(NSString*) safeObjectForKey:(NSDictionary*) dict withKey:(NSString*)key {
    if (key) {
        if (![[dict objectForKey:key] isKindOfClass:[NSNull class]]) {
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
