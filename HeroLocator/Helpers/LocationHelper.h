//
//  LocationHelper.h
//  HeroLocator
//
//  Created by Miguel Santiago Rodríguez on 10/07/14.
//  Copyright (c) 2014 gadaxara. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocationHelperDelegate <NSObject>

- (void)headingNorth;

- (void)headingSouth;

- (void)headingEast;

- (void)headingWest;

@end

@interface LocationHelper : NSObject

@property (weak, nonatomic) id<LocationHelperDelegate> delegate;

- (BOOL) isLocationEnabled;

- (void) startMonitoring;

@end
