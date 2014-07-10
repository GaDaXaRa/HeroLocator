//
//  LocationHelper.m
//  HeroLocator
//
//  Created by Miguel Santiago Rodríguez on 10/07/14.
//  Copyright (c) 2014 gadaxara. All rights reserved.
//

#import "LocationHelper.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationHelper ()<CLLocationManagerDelegate>

@property (strong ,nonatomic) CLLocationManager *locationManager;

@end

@implementation LocationHelper

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    }
    
    return _locationManager;
}

- (BOOL) isLocationEnabled {
    return [CLLocationManager locationServicesEnabled];
}

- (void) startMonitoring {
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading.trueHeading < 10 || newHeading.trueHeading > 350) {
        [self.delegate headingNorth];
    } else if (newHeading.trueHeading > 80 && newHeading.trueHeading < 100) {
        [self.delegate headingEast];
    } else if (newHeading.trueHeading > 170 && newHeading.trueHeading < 190) {
        [self.delegate headingSouth];
    } else if (newHeading.trueHeading > 260 && newHeading.trueHeading < 280) {
        [self.delegate headingWest];
    }
}

@end
