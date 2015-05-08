//
//  ViewController.m
//  WeatherMap
//
//  Created by Eugeniya Pervushina on 5/5/15.
//  Copyright (c) 2015 Eugeniya Pervushina. All rights reserved.
//

#import "ViewController.h"
#define METERS_PER_MILE 1609.344

@interface ViewController () {
    NSString *_cityName;
    UIImage *_iconImage;
    float _latitude;
    float _longitude;
    int _zoom;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _latitude = 42.98f;
    _longitude = -81.23f;
    _cityName = @"London";
    _weatherAPI = [[WeatherAPI alloc] init];
    [_weatherAPI searchForecastWeatherByCityName:_cityName];
    _iconImage = _weatherAPI.image;
    
    _mapView.delegate = self;

    _annotation = [[Annotation alloc] initWithCoordinates:CLLocationCoordinate2DMake(_latitude, _longitude) placeName:@"" description:@"" image:_iconImage];
    [_mapView addAnnotation:_annotation];
    
    _zoom = 1000;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = _latitude;
    zoomLocation.longitude = _longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, _zoom*METERS_PER_MILE, _zoom*METERS_PER_MILE);

    [_mapView setRegion:viewRegion animated:YES];
}

#pragma mark - Zoom

- (IBAction)zoomIn:(id)sender {
    MKCoordinateSpan span;
    span.latitudeDelta = _mapView.region.span.latitudeDelta / 2;
    span.longitudeDelta = _mapView.region.span.latitudeDelta / 2;
    MKCoordinateRegion region;
    region.span = span;
    region.center = _mapView.region.center;
    
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)zoomOut:(id)sender {
    MKCoordinateSpan span;
    span.latitudeDelta = _mapView.region.span.latitudeDelta * 2;
    span.longitudeDelta = _mapView.region.span.latitudeDelta * 2;
    MKCoordinateRegion region;
    region.span = span;
    region.center = _mapView.region.center;
    
    [self.mapView setRegion:region animated:YES];    
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *annotationViewReuseIdentifier = @"";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewReuseIdentifier];
    
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewReuseIdentifier];
    }
    
    annotationView.image = _iconImage;
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

@end
