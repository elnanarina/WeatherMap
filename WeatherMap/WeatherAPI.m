//
//  WeatherAPI.m
//  WeatherMap
//
//  Created by Eugeniya Pervushina on 6/5/15.
//  Copyright (c) 2015 Eugeniya Pervushina. All rights reserved.
//

#import "WeatherAPI.h"

@interface WeatherAPI () {
    NSString *_url;
    NSString *_urlIcon;
    NSString *_lang;
    UIImage *_iconImage;
    NSMutableDictionary *_weatherDictionary;
}
@end

@implementation WeatherAPI

- (id)init {
    if (self) {
        self = [super init];
        _url = @"http://api.openweathermap.org/data/2.5/weather/?q=";
        _urlIcon = @"http://api.openweathermap.org/img/w/";
    }
    
    return self;
}

- (void)_main {
    NSString *icon = [self getIconAddress];
    NSString *celsius = [self convertTemp];
    _imagePatch = [self loadIconWithId:icon];
    _image = [self createPinWithText:celsius andImage:_iconImage];
    
    NSLog(@"icon - %@, celsius - %@", icon, celsius);
}

- (void)searchForecastWeatherByCityName:(NSString *)cityName {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", _url, cityName];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response;
    
    NSData *getReply = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response error:nil];
    _weatherDictionary = [NSJSONSerialization JSONObjectWithData:getReply
                                                         options:kNilOptions
                                                           error:nil];
    [self _main];
}

- (NSString *)getIconAddress {
    NSArray *weatherArray = [_weatherDictionary objectForKey:@"weather"];
    NSDictionary *dict = [weatherArray objectAtIndex:0];
    NSString *iconString = [NSString stringWithFormat:@"%@", [dict objectForKey:@"icon"]];
    
    return iconString;
}

- (NSString *)convertTemp {
    NSDictionary *weatherArray = [_weatherDictionary objectForKey:@"main"];
    NSString *tempString = [NSString stringWithFormat:@"%@", [weatherArray objectForKey:@"temp"]];

    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *kelvin = [f numberFromString:tempString];
    NSNumber *celsius = [NSNumber numberWithInt:(int)([kelvin floatValue] - 273.15)];
    
    return [NSString stringWithFormat:@"%@", celsius];
}

- (NSString *)loadIconWithId:(NSString *)iconId {
    NSString *urlString = [NSString stringWithFormat:@"%@%@.png", _urlIcon, iconId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *imageBytes = [NSData dataWithContentsOfURL:url];
    _iconImage = [UIImage imageWithData: imageBytes];

    NSString *patchComponent = [NSString stringWithFormat:@"/%@", iconId];
    NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:patchComponent];
    [imageBytes writeToFile:imagePath atomically:YES];

    return imagePath;
}

- (UIImage *)createPinWithText:(NSString *)text andImage:(UIImage *)image {
    UIImage *img = [self drawText:text
                                inImage:image
                                atPoint:CGPointMake(0, 0)];
    return img;
}

- (UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point
{
    
    UIFont *font = [UIFont boldSystemFontOfSize:10];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,-10,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    
    [[UIColor whiteColor] set];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];

    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentRight;
    
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle,
                                  NSForegroundColorAttributeName: [UIColor blueColor]};
    
    NSString *temp = [NSString stringWithFormat:@"%@\u00B0C", text];
    [temp drawInRect:CGRectIntegral(rect) withAttributes:attributes];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
