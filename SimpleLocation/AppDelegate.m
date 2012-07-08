//
//  AppDelegate.m
//  SimpleLocation
//
//  Created by Noto Kaname on 12/07/03.
//  Copyright (c) 2012年 能登 要. All rights reserved.
//

#import "SimpleLocation.h"
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window = _window;
@synthesize canceledLocationService=_canceledLocationService;
@synthesize locationManager=locationManager_;

- (NSString*) serverURL
{
#warning Incomplete method implementation.
    return @"この箇所を設置したサーバーに置き換えてください";
}

- (NSString*) userid
{
#warning Incomplete method implementation.
    return @"この箇所をサービスにログインしたユーザー名で置き換えてください。";
}

//- (void)dealloc
//{
//    [_window release];
//    [super dealloc];
//}

// - (void) startStandardUpdates
- (void) startStandardUpdatesWithDelegate:(id<CLLocationManagerDelegate>)delegate;
{
	if( locationManager_ == nil )
		locationManager_ = [[CLLocationManager alloc] init];
    
	locationManager_.delegate = delegate;
	locationManager_.desiredAccuracy = kCLLocationAccuracyBest;
	
	// 新しいイベント用に、移動の閾値を設定する
	locationManager_.distanceFilter = 3;
	
	[locationManager_ startUpdatingLocation];
}

- (void) stopStandardUpdates
{
	if( locationManager_ != nil ){
		locationManager_.delegate = nil;
		[locationManager_ stopUpdatingLocation];
            // ここから5分程で終了させる
	}
	
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

@end
