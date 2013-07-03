//
//  ViewController.m
//  WeatherDemo
//
//  Created by panda zheng on 13-5-10.
//  Copyright (c) 2013年 panda zheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize theWeather;

- (IBAction) refreshWeather:(id)sender
{
    [theWeather updateWeather];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    WeatherObject *_theWeather = [[WeatherObject alloc] init];
    [_theWeather setDelegate:self];
    self.theWeather = _theWeather;
    [actView startAnimating];
    [theWeather updateWeather];
}

- (void) getWeatherFinish
{
	NSLog(@"目前天氣資料:%@",[theWeather current_Weatherdata]);//目前天氣資料
	NSLog(@"今天天氣資料:%@",[theWeather today_Weatherdata]);//今天天氣資料
	NSLog(@"明天天氣資料:%@",[theWeather tomorrow_Weatherdata]);//明天天氣資料
	NSLog(@"日出日落時間:%@",[theWeather sunriseAndsunset]);//日出日落時間
	NSLog(@"所在位置資訊:%@",[theWeather location_Data]);//所在位置資訊
	
	
	[actView stopAnimating];
	nav.title = [theWeather.location_Data objectForKey:@"name"];
	
	NSDateFormatter *format = [[NSDateFormatter alloc]init];
	NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
	[format setLocale:locale];
	[format setDateFormat:@"hh:mm a"];
	
	//取得日出日落時間
	NSDate *sunRise  = [format dateFromString:[theWeather.sunriseAndsunset objectForKey:@"sunrise"]];
	NSDate *sunSet	 = [format dateFromString:[theWeather.sunriseAndsunset objectForKey:@"sunset"]];
	
	//取日出日落小時, 不取到分鐘
	[format setDateFormat:@"HH"];
	int sunrise = [[format stringFromDate:sunRise]intValue];
	int sunset = [[format stringFromDate:sunSet]intValue];
	int nowtime = [[format stringFromDate:[NSDate date]]intValue];

	
	//code for weather picture
	int code = [[theWeather.current_Weatherdata objectForKey:@"code"]intValue];
	int code2 = [[theWeather.today_Weatherdata objectForKey:@"code"]intValue];
	int code3 = [[theWeather.tomorrow_Weatherdata objectForKey:@"code"]intValue];
	
	//日出 - 目前時間 - 日落 = 取白天的pic
	//只處理當前的日出or日落的圖片, 今天整天跟明天都用白天的圖片
	if(nowtime >= sunrise && nowtime <= sunset)
	{
		UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:
														[NSURL URLWithString:[NSString stringWithFormat:@"http://l.yimg.com/a/i/us/nws/weather/gr/%dd.png",code]]]];
		[current_Image setImage:image];
	}
	else//取日落後的pic
	{
		UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:
														[NSURL URLWithString:[NSString stringWithFormat:@"http://l.yimg.com/a/i/us/nws/weather/gr/%dn.png",code]]]];
		[current_Image setImage:image];

	}
	current_Date.text = @"Currently";
	current_Temp.text = [NSString stringWithFormat:@"Temp: %@°",[theWeather.current_Weatherdata objectForKey:@"temp"]];
	current_Text.text = [NSString stringWithFormat:@"%@",[theWeather.current_Weatherdata objectForKey:@"text"]];
	
	
	UIImage *image2 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:
													 [NSURL URLWithString:[NSString stringWithFormat:@"http://l.yimg.com/a/i/us/nws/weather/gr/%dd.png",code2]]]];
	[today_Image setImage:image2];
	today_Date.text = [NSString stringWithFormat:@"%@",[theWeather.today_Weatherdata objectForKey:@"date"]];
	today_Temp.text = [NSString stringWithFormat:@"H: %@°  L: %@°",[theWeather.today_Weatherdata objectForKey:@"high"],[theWeather.today_Weatherdata objectForKey:@"low"]];
	today_Text.text = [NSString stringWithFormat:@"%@",[theWeather.today_Weatherdata objectForKey:@"text"]];

	
	UIImage *image3 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:
													 [NSURL URLWithString:[NSString stringWithFormat:@"http://l.yimg.com/a/i/us/nws/weather/gr/%dd.png",code3]]]];
	[tomorrow_Image setImage:image3];
	tomorrow_Date.text = [NSString stringWithFormat:@"%@",[theWeather.tomorrow_Weatherdata objectForKey:@"date"]];
	tomorrow_Temp.text = [NSString stringWithFormat:@"H: %@°  L: %@°",[theWeather.tomorrow_Weatherdata objectForKey:@"high"],[theWeather.tomorrow_Weatherdata objectForKey:@"low"]];
	tomorrow_Text.text = [NSString stringWithFormat:@"%@",[theWeather.tomorrow_Weatherdata objectForKey:@"text"]];


}

- (void) getWeatherError
{
    NSLog(@"错误发生");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
