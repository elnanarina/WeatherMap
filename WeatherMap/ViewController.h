//
//  ViewController.h
//  WeatherMap
//
//  Created by Eugeniya Pervushina on 5/5/15.
//  Copyright (c) 2015 Eugeniya Pervushina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import "WeatherAPI.h"

@interface ViewController : UIViewController <MKMapViewDelegate> 

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) Annotation *annotation;
@property (nonatomic, strong) WeatherAPI *weatherAPI;

- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;

@end

