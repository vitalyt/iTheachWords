//
//  NSString+Interaction.m
//  iCollab
//
//  Created by Yalantis on 05.04.10.
//  Copyright 2010 Yalantis. All rights reserved.
//

#import "NSString+Interaction.h"
#import "JSON.h"

@implementation NSString (Interaction)

- (NSString *)flattenHTML {
	
	NSString *retValue = self;
    NSScanner *theScanner;
    NSString *text = nil;
	
    theScanner = [NSScanner scannerWithString:self];
	
    while ([theScanner isAtEnd] == NO) {
        [theScanner scanUpToString:@"<" intoString:NULL] ; 
        [theScanner scanUpToString:@">" intoString:&text] ;
        retValue = [retValue stringByReplacingOccurrencesOfString: [NSString stringWithFormat:@"%@>", text] withString:@" "];
    }
    return retValue;
}

- (BOOL) validateEmail {
    NSString *regexp = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexp]; 
	
    return [test evaluateWithObject:self];
}

- (BOOL) validateAlphanumeric {
    NSString *regexp = @"[\\w ]*"; 
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexp]; 
    return [test evaluateWithObject:self];
}

- (void) removeSpaces{
    NSMutableString *str = [[NSMutableString alloc]initWithString:self];
    while ([str hasPrefix:@" "]) {
        NSRange range;
        range.location = 0;
        range.length = 1;
        [str replaceCharactersInRange:range withString:@""];
    }
    while ([str hasSuffix:@" "]) {
        NSRange range;
        range.location = [str length]-1;
        range.length = 1;
        [str replaceCharactersInRange:range withString:@""];
    }
    self = str;
    [str release];
}

- (NSString *) translateString{
    if ([iTeachWordsAppDelegate isNetwork]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSString *url = [[NSString stringWithFormat:@"http://translate.google.ru/translate_a/t?client=x&text=%@&sl=%@&tl=%@",self,
                          [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY_CODE],
                          [[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF32BigEndianStringEncoding];
        NSLog(@"%@",response);
        NSDictionary *result = [[NSDictionary alloc] initWithDictionary:[response JSONValue]];
        if (!result || ![result objectForKey:@"sentences"] || [[result objectForKey:@"sentences"] count] == 0 ) {
            return NSLocalizedString(@"", @"");
        }
        return [[[result objectForKey:@"sentences"] objectAtIndex:0] objectForKey:@"trans"];
    }
    return nil;
}

@end
