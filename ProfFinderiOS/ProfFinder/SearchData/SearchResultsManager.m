//
//  SearchResultsManager.m
//  ProfFinder
//
//  Created by Allison Allain on 3/22/14.
//  Copyright (c) 2014 Allison Wonderland Games. All rights reserved.
//

#import "SearchResultsManager.h"
#import "BaseSearchResultModel.h"

#define KEY @"rUSj3bjkSrqPIpFybPammQ=="
#define SECRET @"1mEqgu13Ry6KzlbmoRNcSQ=="

#define API_URL @"https://api.datalanche.com/rpedela.gocodecolorado/query"
#define LIMIT 10

//rpedela.gocodecolorado/query



@implementation SearchResultsManager

- (id) init {
    self = [super init];
    if (self) {
        _searchResults = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i<5; i++) {
            BaseSearchResultModel *model = [[BaseSearchResultModel alloc] initWithDict:nil];
            [_searchResults addObject:model];
        }
        
        [self jsonTapped:nil];
    }
    return self;
}


- (void)jsonTapped:(id)sender
{
    /*
     
     This is an example using curl to do a search. Having limit set to a reasonable number is very important. Without it, it will find all search results which could take minutes. Otherwise it should be a 1-2 seconds or less.
     
     curl "https://api.datalanche.com/rpedela.gocodecolorado/query" \
     -X POST \
     -u "API_KEY:API_SECRET" \
     -H "Content-Type: application/json" \
     -d '{
     "select": [
     "id",
     "name",
     "department",
     "profile_url",
     "profile_img_url",
     ],
     "from": "cu_faculty_profiles",
     "search": "reduced pressure",
     "offset": 0,
     "limit": 10
     }'
     
     
     */
//    // reset downloadData
//    downloadData = [[NSMutableData alloc] init];
//    NSString *urlString = [NSString stringWithFormat:@"%@/%@.json?security_token=%@", BASE_URL, [[self class] resourceCollectionName], [[SecKeyWrapper sharedWrapper] iTriageToken]];
    
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

    [dict setObject:select forKey:@"select"];
    [dict setObject:@"cu_faculty_profiles" forKey:@"from"];
    [dict setObject:@"reduced pressure" forKey:@"search"];
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"offset"];
    [dict setObject:[NSNumber numberWithInt:10] forKey:@"limit"];
    
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
