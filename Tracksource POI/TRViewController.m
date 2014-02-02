//
//  TRViewController.m
//  Tracksource POI
//
//  Created by Paulo Luis Franchini Casaretto on 2/2/14.
//  Copyright (c) 2014 Paulo Luis Franchini Casaretto. All rights reserved.
//

#import "TRViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface TRViewController () <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
}
@property CLLocation *currentLocation;

@end

@implementation TRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	CLLocationManager *manager = [[CLLocationManager alloc] init];
	locationManager = manager;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	manager.delegate = self;
	[manager startUpdatingLocation];
	
	[[RACObserve(self, currentLocation) ignore:nil] subscribeNext:^(CLLocation *newLocation) {
		
		NSLog(@"holy shit %f, %f, %f",newLocation.coordinate.latitude, newLocation.coordinate.longitude, newLocation.horizontalAccuracy);
	}];
	
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // omitting accuracy & cache checking
    CLLocation *location = [locations lastObject];
    self.currentLocation = location;
		// [locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
