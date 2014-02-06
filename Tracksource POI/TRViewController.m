//
//  TRViewController.m
//  Tracksource POI
//
//  Created by Paulo Luis Franchini Casaretto on 2/2/14.
//  Copyright (c) 2014 Paulo Luis Franchini Casaretto. All rights reserved.
//

#import "TRViewController.h"
#import "TRPoiViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface TRViewController () <CLLocationManagerDelegate, MKMapViewDelegate> {
	CLLocationManager *locationManager;
}
@property CLLocation *lastLocation;

@end

@implementation TRViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self.mapView setDelegate:self];
	CLLocationManager *manager = [[CLLocationManager alloc] init];
	locationManager = manager;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	manager.delegate = self;
	[manager startUpdatingLocation];
	
	UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
																				initWithTarget:self action:@selector(addPinToMap:)];
	lpgr.minimumPressDuration = 0.5; //
	[self.mapView addGestureRecognizer:lpgr];
	
}

- (void)addPinToMap:(UIGestureRecognizer *)gestureRecognizer
{
	
	if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
		return;
	
	CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
	CLLocationCoordinate2D touchMapCoordinate =
	[self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
	
	MKPointAnnotation *toAdd = [[MKPointAnnotation alloc]init];
	
	
	toAdd.coordinate = touchMapCoordinate;
	toAdd.title = @"Enviar POI";
	
	[self.mapView addAnnotation:toAdd];
	
}

#pragma mark --
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation {
	if([annotation isKindOfClass:[MKUserLocation class]])
		return nil;
	MKPinAnnotationView *view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"default_ping"];
	if (!view) {
		view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"default_ping"];
		view.animatesDrop = YES;
		view.canShowCallout = YES;
		UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
		view.rightCalloutAccessoryView = button;
	}
	return view;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	NSLog(@"HAH");
	[self performSegueWithIdentifier:@"poiSegue" sender:self];
}

#pragma mark --
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // omitting accuracy & cache checking
	CLLocation *newLocation = [locations lastObject];
	
	NSLog(@"holy shit %f, %f",2.0f * newLocation.horizontalAccuracy, self.lastLocation.horizontalAccuracy);
		
	if (2.0f * newLocation.horizontalAccuracy < self.lastLocation.horizontalAccuracy) {
		[self.mapView setRegion:MKCoordinateRegionMakeWithDistance(newLocation.coordinate, newLocation.horizontalAccuracy * 3.5, newLocation.horizontalAccuracy * 3.5) animated:YES];
		
	}
	
	self.lastLocation = newLocation;
	// [locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
