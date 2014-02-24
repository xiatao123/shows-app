//
//  Episode.m
//  showsApp
//
//  Created by Linkai Xi on 1/29/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import "Episode.h"

@implementation Episode


+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

-(NSDate*) buildCalendarDate{
    NSMutableString* calendarDate = [[NSMutableString alloc]init];
    NSArray* airArray = [[NSArray alloc]init];
    airArray = [self.FirstAired componentsSeparatedByString:@"-"];
    for(NSString* s in airArray){
        [calendarDate appendString:s];
    }
    NSArray* timeArray = [[NSArray alloc]init];
    timeArray = [self.Airs_Time componentsSeparatedByString:@" "];
   
    NSArray* hourArray = [[NSArray alloc]init];
    hourArray = [[timeArray objectAtIndex:0] componentsSeparatedByString:@":"];

    NSInteger hour = [[hourArray objectAtIndex:0] integerValue];
    if ([[timeArray objectAtIndex:1] isEqualToString:@"PM"]) {
        hour = hour + 12;
    }
    
    [calendarDate appendString:[NSString stringWithFormat:@"%d", hour]];
    [calendarDate appendString:[hourArray objectAtIndex:1]];
    //NSLog(@"~~~~~~%@", calendarDate);
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmm"];
    NSDate *date = [dateFormat dateFromString:calendarDate];
    return date;
}

@end
