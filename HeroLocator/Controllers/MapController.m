//
//  MapController.m
//  HeroLocator
//
//  Created by Miguel Santiago Rodríguez on 10/07/14.
//  Copyright (c) 2014 gadaxara. All rights reserved.
//

#import "MapController.h"
#import <MapKit/MapKit.h>
#import "Bar.h"
#import "BarProvider.h"

@interface MapController ()<UIActionSheetDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) UIActionSheet *typeActionSheet;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISwitch *localSwitch;
@property (strong, nonatomic) NSMutableArray *cameras;

@property (strong, nonatomic) NSArray *barArray;

@end

@implementation MapController

- (NSMutableArray *)cameras {
    if (!_cameras) {
        _cameras = [[NSMutableArray alloc] init];
    }
    
    return _cameras;
}

- (NSArray *)barArray {
    if(!_barArray) {
        _barArray = [BarProvider createBarArrayFromFilePath:@"bar-list"];
    }
    
    return _barArray;
}

- (UIActionSheet *)typeActionSheet {
    if (!_typeActionSheet) {
        _typeActionSheet = [[UIActionSheet alloc] initWithTitle:@"Type" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Satellite", @"Map", @"Hybrid", nil];
    }
    
    return _typeActionSheet;
}

- (void)viewDidLoad {
    [self.map setShowsPointsOfInterest:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadBarPines];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.map removeAnnotations:self.map.annotations];
}

- (void)loadBarPines {
    for (Bar *bar in self.barArray) {
        [self.map addAnnotation:bar];
    }
}

- (IBAction)typePressed:(UIBarButtonItem *)sender {
    [self.typeActionSheet showFromBarButtonItem:sender animated:YES];
}

- (IBAction)centerPressed:(id)sender {
    [self centerMapInCoordinates:self.map.userLocation.coordinate];
}

- (IBAction)cameraPressed:(id)sender {
    [self buildCamerasArray];
    [self goToNextCamera];
}

- (void)buildCamerasArray {
    for (Bar *bar in self.barArray) {
        [self addCameraUsingBar:bar];
    }
}

- (void)goToNextCamera {
    if (![self.cameras count]) {
        return;
    }
    
    MKMapCamera *nextCamera = [self.cameras firstObject];
    [self.cameras removeObjectAtIndex:0];
    
    [UIView animateWithDuration:2 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.map.camera = nextCamera;
    } completion:^(BOOL finished) {
        [self goToNextCamera];
    }];
}

- (void)centerMapInCoordinates:(CLLocationCoordinate2D)coordinates {
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinates, 5000.0, 5000.0);
    MKCoordinateRegion fitRegion = [self.map regionThatFits:viewRegion];
    [self.map setRegion:fitRegion animated:YES];
}

- (void)localSearch:(NSString *)searchString {
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:[self buildSearchRequest:searchString]];
    [self.map removeAnnotations:self.map.annotations];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        for(MKMapItem *mapItem in response.mapItems) {
            [self.map addAnnotation:[[Bar alloc]initWithPlaceMark:mapItem.placemark]];
        }
    }];
}

- (MKLocalSearchRequest *)buildSearchRequest:(NSString *)searchString {
    MKLocalSearchRequest *searchRequest = [[MKLocalSearchRequest alloc] init];
    searchRequest.naturalLanguageQuery = searchString;
    searchRequest.region = self.map.region;
    return searchRequest;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view endEditing:YES];
    if (self.localSwitch.isOn) {
        [self localSearch:textField.text];
    } else {
        [self geolocateAddress:textField.text];
    }
}

- (IBAction)mapTouch:(UITapGestureRecognizer *)sender {
    CGPoint tapPoint = [sender locationInView:self.map];
    [self reverseGeolocationByPoint:tapPoint];
}

- (void)reverseGeolocationByPoint:(CGPoint)point {
    CLLocationCoordinate2D coordinate = [self.map convertPoint:point toCoordinateFromView:self.map];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count) {
            NSDictionary *dictionary = [[placemarks firstObject] addressDictionary];
            
            self.textField.text = [self stringWithAddressDictionary:dictionary];
        }
    }];
}

- (NSString *)stringWithAddressDictionary:(NSDictionary *)dictionary {
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@", dictionary[@"Street"]];
    [string appendString:[NSString stringWithFormat:@", %@", dictionary[@"City"]]];
    [string appendString:[NSString stringWithFormat:@", %@", dictionary[@"State"]]];
    [string appendString:[NSString stringWithFormat:@", %@", dictionary[@"ZIP"]]];
    
    return string.copy;
}

- (NSDictionary *)dictionaryWithAddress:(NSString *)address {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSArray *keys = @[@"Street", @"City"];
    NSArray *addressComponents = [address componentsSeparatedByString:@","];
    
    if ([addressComponents count] == 2) {
        [addressComponents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [dictionary setObject:obj forKey:keys[idx]];
        }];
    }
    
    return dictionary;
}

- (void)geolocateAddress:(NSString *)address {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressDictionary:[self dictionaryWithAddress:address] completionHandler:^(NSArray *placemarks, NSError *error) {
        if([placemarks count]) {
            CLPlacemark *placeMark = [placemarks firstObject];
            [self centerMapInCoordinates:placeMark.location.coordinate];
        }
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            self.map.mapType = MKMapTypeSatellite;
            break;
        case 1:
            self.map.mapType = MKMapTypeStandard;
            break;
        case 2:
            self.map.mapType = MKMapTypeHybrid;
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Map View Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annotationView = [self buildOrReuseAnnotation:annotation];
    if ([annotation isKindOfClass:[Bar class]]) {
        Bar *bar = annotation;
        UIImage *image;
        switch (bar.localType) {
            case classic_bar:
                image = [UIImage imageNamed:@"coffee"];
                break;
            case piano_bar:
                image = [UIImage imageNamed:@"guitar"];
                break;
            case pub:
                image = [UIImage imageNamed:@"wine-bottle"];
                break;
            case tapas_bar:
                image = [UIImage imageNamed:@"hammer"];
                break;
            default:
                image = [UIImage imageNamed:@"hammer"];
                break;
        }
        annotationView.image = image;
        annotationView.canShowCallout = YES;
    }
    
    return annotationView;
}

- (MKAnnotationView *)buildOrReuseAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annotationView = [self.map dequeueReusableAnnotationViewWithIdentifier:@"myBars"];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myBars"];
    }
    
    return annotationView;
}

- (void)addCameraUsingBar:(Bar *)bar {
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:bar.coordinate fromEyeCoordinate:bar.coordinate eyeAltitude:100];
    camera.pitch = 60;
    [self.cameras addObject:camera];
}

@end
