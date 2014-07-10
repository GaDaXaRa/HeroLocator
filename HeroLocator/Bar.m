//
//  Bar.m
//  HeroLocator
//
//  Created by Miguel Santiago Rodríguez on 10/07/14.
//  Copyright (c) 2014 gadaxara. All rights reserved.
//

#import "Bar.h"

@implementation Bar

+ (NSArray *)createBarArrayFromFilePath:(NSString *)filePath {
    NSArray *arrayFromFile = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filePath ofType:@"plist"]];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *barDictionary in arrayFromFile) {
        [returnArray addObject:[[Bar alloc] initWithDictionary:barDictionary]];
    }
    
    return [returnArray copy];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _name = [dictionary valueForKey:@"name"];
        _coordinate.latitude = [[dictionary valueForKey:@"lat"] floatValue];
        _coordinate.longitude = [[dictionary valueForKey:@"lon"] floatValue];
    }
    
    return self;
}

@end
