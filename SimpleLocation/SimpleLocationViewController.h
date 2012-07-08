//
//  ViewController.h
//  SimpleLocation
//
//  Created by Noto Kaname on 12/07/03.
//  Copyright (c) 2012年 能登 要. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CustomAnnotationView.h"
#import "CheckinViewController.h"

@interface SimpleLocationViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,CustomAnnotationViewDelegate,CheckinViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@end
