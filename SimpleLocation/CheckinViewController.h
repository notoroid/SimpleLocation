//
//  CheckinViewController.h
//  SimpleLocation
//
//  Created by Noto Kaname on 12/07/08.
//  Copyright (c) 2012年 能登 要. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckinViewControllerDelegate;

@interface CheckinViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSDictionary* latitudeAndLongitude;
@property (nonatomic,strong) NSDictionary* parameters;
@property (nonatomic,strong) NSString* placeid;
@property (nonatomic,weak) id<CheckinViewControllerDelegate> delegate;

@end

@protocol CheckinViewControllerDelegate

-(void) checkinViewControllerDidCheckIn:(CheckinViewController*) checkinViewController;
-(void) checkinViewControllerDidCancel:(CheckinViewController*) checkinViewController;
-(void) checkinViewControllerDidFailure:(CheckinViewController*) checkinViewController;

@end
