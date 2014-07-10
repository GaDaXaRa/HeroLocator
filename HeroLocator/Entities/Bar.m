//
//  Bar.m
//  HeroLocator
//
//  Created by Miguel Santiago Rodríguez on 10/07/14.
//  Copyright (c) 2014 gadaxara. All rights reserved.
//

#import "Bar.h"

@implementation Bar

- (instancetype)initWithPlaceMark:(MKPlacemark *)placeMark {
    self = [super init];
    
    if (self) {
        _title = placeMark.name;
        _coordinate = placeMark.coordinate;
        _localType = 0;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _title = [dictionary valueForKey:@"name"];
        _coordinate.latitude = [[dictionary valueForKey:@"lat"] floatValue];
        _coordinate.longitude = [[dictionary valueForKey:@"lon"] floatValue];
        _localType = [[dictionary valueForKey:@"type"] integerValue];
    }
    
    return self;
}

@end
