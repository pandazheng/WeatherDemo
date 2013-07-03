//
//  WeatherObject.m
//  WeatherDemo
//
//  Created by panda zheng on 13-5-10.
//  Copyright (c) 2013年 panda zheng. All rights reserved.
//
#define YQL_Weather @"http://query.yahooapis.com/v1/public/yql?q=select * from flickr.places where lon=%f and lat=%f and accuracy=6"

#import "WeatherObject.h"

@implementation WeatherObject
@synthesize woeid,locationManager;
@synthesize current_Weatherdata,today_Weatherdata;
@synthesize tomorrow_Weatherdata,sunriseAndsunset;
@synthesize location_Data;
@synthesize TemperatureF;

- (id) init
{
    self = [super init];
    if (self)
    {
        CLLocationManager *_locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [_locationManager setDistanceFilter:100000];
        self.locationManager = _locationManager;
        [locationManager setDelegate:self];
        today = YES;
    }
    return self;
}

- (void) updateWeather
{
    if (isStart) return;
    NSLog(@"update...");
    if ([CLLocationManager locationServicesEnabled])
    {
        NSLog(@"ok");
        [locationManager startUpdatingLocation];
    }
    else
    {
        NSLog(@"CLLocationManager 无法定位");
    }
}

#pragma mark -
#pragma mark locationManager delegate
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    isStart = YES;
    if (newLocation.horizontalAccuracy >= 0)
    {
        [locationManager stopUpdatingLocation];
        [self performSelectorInBackground:@selector(getWoeidData) withObject:nil];
    }
    else
    {
        NSLog(@"无效值");
        [locationManager stopUpdatingLocation];
        isStart = NO;
        if ([[self delegate] respondsToSelector:@selector(getWeatherError)])
        {
            [[self delegate] performSelector:@selector(getWeatherError)];
        }
    }
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位错误: %@",[error localizedDescription]);
    [locationManager stopUpdatingLocation];
    if ([[self delegate] respondsToSelector:@selector(getWeatherError)])
    {
        [[self delegate] performSelector:@selector(getWeatherError)];
    }
}

#pragma mark -
#pragma mark getWoeidXml/parserWoeidXml,parserWeatherXML
- (void) getWoeidData
{
    NSLog(@"将经纬度转换成woeid");
    CLLocationCoordinate2D coord = [locationManager.location coordinate];
    double latitude = coord.latitude;
    double longitude = coord.longitude;
    NSString *theStr = [[NSString stringWithFormat:YQL_Weather,longitude,latitude]
                        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *theURL = [[NSURL alloc] initWithString:theStr];
    [self performSelector:@selector(parserWoeid:) withObject:theURL];
}

- (void) parserWoeid: (NSURL *) url
{
    NSLog(@"start parserWoeid");
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser parse];
    
    if (woeid != nil && ![parser parserError])
    {
        [self performSelector:@selector(parserWeather)];
    }
    else
    {
        if ([[self delegate] respondsToSelector:@selector(getWeatherError)])
            [[self delegate] performSelector:@selector(getWeatherError)];
    }
}

- (void)parserWeather
{
	NSLog(@"start parserWeather");
	//取得華氏資料
	if(TemperatureF)
	{
		NSString *theStr = [NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%@",woeid];
		NSURL *theURL = [NSURL URLWithString:theStr];
		NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:theURL];
		[parser setDelegate:self];
		[parser parse];
	}
	else //取得攝氏資料
	{
		NSString *theStr = [NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%@&u=c",woeid];
		NSURL *theURL = [NSURL URLWithString:theStr];
		NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:theURL];
		[parser setDelegate:self];
		[parser parse];
	}
	isStart = NO;
	if([[self delegate]respondsToSelector:@selector(getWeatherFinish)])
		[[self delegate] performSelector:@selector(getWeatherFinish)];
	
	
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (qName) {
        elementName = qName;
    }
	if([elementName isEqualToString:@"place"])
	{
		self.woeid = [attributeDict objectForKey:@"woeid"];
		self.location_Data = attributeDict;
		return;
	}
	if([elementName isEqualToString:@"yweather:astronomy"])
	{
		self.sunriseAndsunset = attributeDict;
		return;
	}
	if([elementName isEqualToString:@"yweather:condition"])
	{
		self.current_Weatherdata = attributeDict;
		return;
	}
	if([elementName isEqualToString:@"yweather:forecast"])
	{
		if(today){
			self.today_Weatherdata = attributeDict;
			today = NO;
			return;
		}else{
			self.tomorrow_Weatherdata = attributeDict;
			today = YES;
			return;
		}
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (qName) {
        elementName = qName;
    }
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	NSLog(@"NSXMLParser錯誤:%@",[parseError localizedDescription]);
}


@end
