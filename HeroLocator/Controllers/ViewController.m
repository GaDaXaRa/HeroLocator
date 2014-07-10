//
//  ViewController.m
//  HeroLocator
//
//  Created by Miguel Santiago Rodríguez on 10/07/14.
//  Copyright (c) 2014 gadaxara. All rights reserved.
//

#import "ViewController.h"
#import "LocationHelper.h"

@interface ViewController ()<LocationHelperDelegate>

@property (strong ,nonatomic) LocationHelper *locationHelper;

@property (weak, nonatomic) IBOutlet UIImageView *northImage;
@property (weak, nonatomic) IBOutlet UIImageView *eastImage;
@property (weak, nonatomic) IBOutlet UIImageView *southImage;
@property (weak, nonatomic) IBOutlet UIImageView *westImage;

@property (strong, nonatomic) UIImage *imageFary;

@end

@implementation ViewController

- (UIImage *)imageFary {
    return [UIImage imageNamed:@"fary"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.locationHelper = [[LocationHelper alloc] init];
    self.locationHelper.delegate = self;
    if ([self.locationHelper isLocationEnabled]) {
        [self.locationHelper startMonitoring];
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    self.locationHelper = nil;
    [super viewDidDisappear:animated];
}

- (void)resetImages {
    self.northImage.image = nil;
    self.southImage.image = nil;
    self.eastImage.image = nil;
    self.westImage.image = nil;
}

- (void)headingNorth {
    [self resetImages];
    self.northImage.image = self.imageFary;
}

- (void)headingSouth {
    [self resetImages];
    self.southImage.image = self.imageFary;
}

- (void)headingEast {
    [self resetImages];
    self.eastImage.image = self.imageFary;
}

- (void)headingWest {
    [self resetImages];
    self.westImage.image = self.imageFary;
}

@end
