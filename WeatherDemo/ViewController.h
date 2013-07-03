//
//  ViewController.h
//  WeatherDemo
//
//  Created by panda zheng on 13-5-10.
//  Copyright (c) 2013年 panda zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherObject.h"

@interface ViewController : UIViewController <WeatherDelegate>
{
    WeatherObject *theWeather;
    
    IBOutlet UIImageView *current_Image;        //目前天气图
    IBOutlet UIImageView *today_Image;          //今天天气图
    IBOutlet UIImageView *tomorrow_Image;       //明天天气图
    
    IBOutlet UILabel *current_Date;             //目前日期
    IBOutlet UILabel *current_Temp;             //目前天气
    IBOutlet UILabel *current_Text;             //目前天气描述
    
    IBOutlet UILabel *today_Date;               //今天日期
    IBOutlet UILabel *today_Temp;               //今天天气
    IBOutlet UILabel *today_Text;               //今天天气描述
    
    IBOutlet UILabel *tomorrow_Date;            //明天日期
    IBOutlet UILabel *tomorrow_Temp;            //明天天气
    IBOutlet UILabel *tomorrow_Text;            //明天天气描述
    
    
    IBOutlet UINavigationItem *nav;
    IBOutlet UIActivityIndicatorView *actView;
}

@property (nonatomic,strong) WeatherObject *theWeather;
- (IBAction) refreshWeather: (id) sender;

@end
