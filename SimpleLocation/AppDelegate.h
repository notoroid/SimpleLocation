//
//  AppDelegate.h
//  SimpleLocation
//
//  Created by Noto Kaname on 12/07/03.
//  Copyright (c) 2012年 能登 要. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign) BOOL canceledLocationService;
@property (nonatomic,retain) CLLocationManager* locationManager;
@property (nonatomic,readonly) NSString* serverURL;
@property (nonatomic,readonly) NSString* userid;

- (void) startStandardUpdatesWithDelegate:(id<CLLocationManagerDelegate>)delegate;
- (void) stopStandardUpdates;

@end
