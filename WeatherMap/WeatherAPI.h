//
//  WeatherAPI.h
//  WeatherMap
//
//  Created by Eugeniya Pervushina on 6/5/15.
//  Copyright (c) 2015 Eugeniya Pervushina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WeatherAPI : NSObject

@property (nonatomic, strong) NSString *imagePatch;
@property (nonatomic, strong) NSString *temperature;
@property (nonatomic) UIImage *image;

- (id)init;
- (void)_main;
- (void)searchForecastWeatherByCityName:(NSString *)cityName;

@end
