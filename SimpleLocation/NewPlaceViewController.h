//
//  AddPlaceViewController.h
//  SimpleLocation
//
//  Created by Noto Kaname on 12/07/05.
//  Copyright (c) 2012年 能登 要. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationConfirmViewController.h"

@class ViewController;

@interface NewPlaceViewController : UITableViewController<LocationConfirmViewControllerDelegate>

@property(strong,nonatomic) NSNumber* latitude;
@property(strong,nonatomic) NSNumber* longitude;
@property(strong,nonatomic) NSString* name;
@property(strong,nonatomic) NSString* kana;
@property(strong,nonatomic) NSString* address;
@property(strong,nonatomic) NSString* address2;
@property(strong,nonatomic) NSString* address3;
@property(strong,nonatomic) NSDictionary* resultByPlaceUpdate;

@end
