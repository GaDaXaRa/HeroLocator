//
//  BarProvider.m
//  HeroLocator
//
//  Created by Miguel Santiago Rodríguez on 10/07/14.
//  Copyright (c) 2014 gadaxara. All rights reserved.
//

#import "BarProvider.h"
#import "Bar.h"

@implementation BarProvider

+ (NSArray *)createBarArrayFromFilePath:(NSString *)filePath {
    NSArray *arrayFromFile = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filePath ofType:@"plist"]];
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:[arrayFromFile count]];
    
    for (NSDictionary *barDictionary in arrayFromFile) {
        [returnArray addObject:[[Bar alloc] initWithDictionary:barDictionary]];
    }
    
    return [returnArray copy];
}

@end
