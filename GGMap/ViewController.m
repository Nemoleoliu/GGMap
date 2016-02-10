//
//  ViewController.m
//  GGMap
//
//  Created by liuchang on 16/2/10.
//  Copyright © 2016年 liuchang. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UILabel *testLabel;
@property (nonatomic, strong) CLLocationManager *clm;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.testLabel];
    [self.mapView setFrame:self.view.bounds];
    [self.mapView setMapType:MKMapTypeSatellite];
    [self.mapView setShowsUserLocation:YES];
    [self.testLabel setFrame:CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, 100)];
    [self.testLabel setBackgroundColor:[UIColor blackColor]];
    [self.testLabel setTextColor:[UIColor whiteColor]];
    [self.testLabel setNumberOfLines:3];
    // Do any additional setup after loading the view, typically from a nib.
    CLLocationManager *clm = [[CLLocationManager alloc]init];
    
    clm.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    clm.delegate = self;
    [clm requestAlwaysAuthorization];
    [clm requestWhenInUseAuthorization];
    [clm startUpdatingLocation];
    self.clm = clm;
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
            // 用户还未决定
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"用户还未决定");
            break;
        }
            // 问受限
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            break;
        }
            // 定位关闭时和对此APP授权为never时调用
        case kCLAuthorizationStatusDenied:
        {
            // 定位是否可用（是否支持定位或者定位是否开启）
            if([CLLocationManager locationServicesEnabled])
            {
                NSLog(@"定位开启，但被拒");
            }else
            {
                NSLog(@"定位关闭，不可用");
            }
            //            NSLog(@"被拒");
            break;
        }
            // 获取前后台定位授权
        case kCLAuthorizationStatusAuthorizedAlways:
            //        case kCLAuthorizationStatusAuthorized: // 失效，不建议使用
        {
            NSLog(@"获取前后台定位授权");
            break;
        }
            // 获得前台定位授权
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"获得前台定位授权");
            break;
        }
        default:
            break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"location changed");
    for (CLLocation* location in locations) {
        [self.testLabel setText:[NSString stringWithFormat:@"%@", location]];
        [self centerMapOnLocation:location];
    }
    
}

-(void)centerMapOnLocation:(CLLocation*) location
{
    CLLocationDistance radius = 1000;
    MKCoordinateRegion curRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, radius*2.0, radius*2.0);
    [self.mapView setRegion:curRegion animated:YES];
}



-(MKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MKMapView alloc]init];
    }
    return _mapView;
}

-(UILabel *)testLabel
{
    if (!_testLabel) {
        _testLabel = [[UILabel alloc]init];
    }
    return _testLabel;
}

@end
