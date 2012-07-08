//
//  LocationConfirmViewController.h
//  SimpleLocation
//
//  Created by Noto Kaname on 12/07/05.
//  Copyright (c) 2012年 能登 要. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol LocationConfirmViewControllerDelegate;

@interface LocationConfirmViewController : UIViewController<MKMapViewDelegate,UITableViewDataSource,UITableViewDataSource>

@property(weak,nonatomic) IBOutlet id<LocationConfirmViewControllerDelegate> delegate;
@property(strong,nonatomic) NSDictionary* latitudeAndLongitude;
@property(strong,nonatomic) NSDictionary* parameters;

@end

@protocol LocationConfirmViewControllerDelegate

- (void) locationConfirmViewControllerDidDone:(LocationConfirmViewController*)locationConfirmViewController result:(NSDictionary*)result;

@end
