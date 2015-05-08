//
//  Annotation.m
//  WeatherMap
//
//  Created by Eugeniya Pervushina on 7/5/15.
//  Copyright (c) 2015 Eugeniya Pervushina. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:placeName description:description image:(UIImage *)image {
    self = [super init];
    if (self != nil) {
        _coordinate = location;
        _title = placeName;
        _subtitle = description;
        _image = image;
    }
    
    return self;
}

-(void) drawRect:(CGRect)rect {
    [_image drawInRect:CGRectMake(30, 30.0, 30.0, 30.0)];
}

@end
