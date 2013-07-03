//
//  WeatherObject.h
//  WeatherDemo
//
//  Created by panda zheng on 13-5-10.
//  Copyright (c) 2013年 panda zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@protocol WeatherDelegate;

@interface WeatherObject : NSObject <CLLocationManagerDelegate,NSXMLParserDelegate>
{
    CLLocationManager *locationManager;
    NSDictionary *current_Weatherdata;      //目前天气资料
    NSDictionary *today_Weatherdata;        //今天天气资料
    NSDictionary *tomorrow_Weatherdata;     //明天天气资料
    NSDictionary *sunriseAndsunset;         //日出日落时间
    NSDictionary *location_Data;            //所在定位资料
    NSString     *woeid;                    //经纬度转换
    
    BOOL today;
    BOOL isStart;
    BOOL TemperatureF;
}

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) NSDictionary *current_Weatherdata;
@property (nonatomic,strong) NSDictionary *today_Weatherdata;
@property (nonatomic,strong) NSDictionary *tomorrow_Weatherdata;
@property (nonatomic,strong) NSDictionary *sunriseAndsunset;
@property (nonatomic,strong) NSDictionary *location_Data;
@property (nonatomic,strong) NSString *woeid;
@property (assign) id<WeatherDelegate> delegate;
@property (assign) BOOL TemperatureF;
- (void) updateWeather;

@end

//delegate
@protocol WeatherDelegate <NSObject>

@optional
- (void) getWeatherFinish;
- (void) getWeatherError;

@end






