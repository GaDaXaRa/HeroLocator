//
//  Bar.h
//  HeroLocator
//
//  Created by Miguel Santiago Rodríguez on 10/07/14.
//  Copyright (c) 2014 gadaxara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum {
    classic_bar = 0,
    tapas_bar = 1,
    piano_bar = 2,
    pub = 3
} BAR_TYPE;

@interface Bar : NSObject <MKAnnotation>

- (instancetype)initWithPlaceMark:(MKPlacemark *)placeMark;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) NSString *title;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) BAR_TYPE localType;

@end
