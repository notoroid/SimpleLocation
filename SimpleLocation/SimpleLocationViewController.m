//
//  ViewController.m
//  SimpleLocation
//
//  Created by Noto Kaname on 12/07/03.
//  Copyright (c) 2012年 能登 要. All rights reserved.
//

#import "SimpleLocation.h"
#import "SimpleLocationViewController.h"
#import "AppDelegate.h"
#import "CustomAnnotationView.h"
#import "FigureRenderer.h"
#import "NewPlaceViewController.h"
//#import "Reachability.h"
#import "CheckinViewController.h"

static NSInteger s_mapID = 0;

static double degreesToRadians(double degrees) {return degrees * M_PI / 180;}
static double radiansToDegrees(double radians) {return radians * 180 / M_PI;}

@interface CustomAnnotation :NSObject <MKAnnotation>
{

}

// その他のメソッドとプロパティ
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSDictionary* parameters;
@property (nonatomic, readonly) NSString* placeid;

- (id)initWithLocation:(CLLocationCoordinate2D)coord andParameters:(NSDictionary*)parameters andPlaceid:(NSString*)placeid;
@end

@implementation CustomAnnotation

@synthesize coordinate=_coordinate;
@synthesize parameters=_parameters;
@synthesize placeid=_placeid;

- (id)initWithLocation:(CLLocationCoordinate2D)coord andParameters:(NSDictionary*)parameters andPlaceid:(NSString*)placeid
{
	if ( (self = [super init]) != nil ){
		_coordinate = coord; 
		_parameters = [[NSDictionary alloc] initWithDictionary:parameters];
		_placeid = [placeid copy];
	}
	return self;
}

- (NSString *)title
{
	return [_parameters objectForKey:@"name"] != nil ? [_parameters objectForKey:@"name"] : @"これはタイトル";
}

- (NSString *)subtitle
{
	return @"これはサブタイトル";
}

@end

static NSDictionary* convertRadius( NSDictionary* latitudeAndLongitude,double radius)
{
    NSNumber* latitude = [latitudeAndLongitude objectForKey:@"latitude"];
    const double latitudeValue = [latitude doubleValue];
    
    NSNumber* longitude = [latitudeAndLongitude objectForKey:@"longitude"];
    const double longitudeValue = [longitude doubleValue];
    
    double diameter = 40000000.0f * cos( degreesToRadians(latitudeValue));
    double diameterPerDegree = diameter / 360.0f;
    double unitMeter = (radius / diameterPerDegree);
    
    
    double diameter2 = 40000000.0f * cos( degreesToRadians(.0f));
    double diameterPerDegree2 = diameter2 / 360.0f;
    double unitMeter2 = (radius / diameterPerDegree2);
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithDouble:unitMeter],kLatitudeRadius
            ,[NSNumber numberWithDouble:latitudeValue - unitMeter],kLatBegin
            ,[NSNumber numberWithDouble:latitudeValue + unitMeter],kLatEnd
            ,[NSNumber numberWithDouble:unitMeter2],longitudeRadius
            ,[NSNumber numberWithDouble:longitudeValue - unitMeter2],kLongBegin
            ,[NSNumber numberWithDouble:longitudeValue + unitMeter2],kLongEnd
            ,nil];
}

@interface SimpleLocationViewController ()
{
    NSArray* _places;
    BOOL _initializedRegion;
    BOOL _initializedCurrentLocation;
    NSDictionary* _latitudeAndLongitudeDic;
    UIImage* _customAnotationImage;
    UIImage* _placeIconImage;
//    Reachability* _internetReach;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (readonly,nonatomic) UIImage* customAnotationImage;
@property (readonly,nonatomic) UIImage* placeIconImage;

- (void) configureCell:(UITableViewCell*)cell indexPath:(NSIndexPath*) indexPath;
- (void) reloadPlacesWithLatidudeAndLongitude:(NSDictionary*)dicLatidudeAndLongitude;
@end

@implementation SimpleLocationViewController
@synthesize tableView = _tableView;
@synthesize mapView=_mapView;

- (UIImage*) customAnotationImage
{
    if( _customAnotationImage == nil )
        _customAnotationImage = [FigureRenderer createImageWithFigureType:FigureRendererTypeCustomPin];
    return _customAnotationImage;
}

- (UIImage*) placeIconImage
{
    if( _placeIconImage == nil ){
        _placeIconImage = [FigureRenderer createImageWithFigureType:FigureRendererTypePlaceIcon ];
    }
    return _placeIconImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"チェックイン";

	UIBarButtonItem* reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(firedReload:)];
	self.navigationItem.rightBarButtonItem = reloadButton;
    
//    _internetReach = [Reachability reachabilityForInternetConnection];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	_mapView.showsUserLocation = YES;
	
	// リロード処理を読み込み
	[self firedReload:self];
}

- (void) firedReload:(id)sender
{
	AppDelegate* appDelegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
	if( !appDelegate.canceledLocationService  ){
		BOOL isReloadData = NO;
		
		if( sender == self && appDelegate.locationManager.delegate != self ){
			isReloadData = YES;
		}else if (sender != self ) {
			isReloadData = YES;
			_places = nil;
			// 位置情報を削除する
		}
        
		if (isReloadData) {
			[appDelegate startStandardUpdatesWithDelegate:self];
		}		
		
	}
}


- (void)viewDidUnload
{
//    _internetReach = nil;
    _mapView = nil;
    [self setTableView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



- (void) reloadPlacesWithLatidudeAndLongitude:(NSDictionary*)dicLatidudeAndLongitude
{
//    if( _internetReach.currentReachabilityStatus == NotReachable ){
//
//        
//    }else{

        NSDictionary* dicRadius = convertRadius( dicLatidudeAndLongitude , 1500.0f /*M*/ );
        NSLog(@"dicRadius=%@",dicRadius );
        
        // 緯度経度から場所を問い合わせる
        // dogid を取得する
        NSURL* URL = [NSURL URLWithString:[((AppDelegate*)[UIApplication sharedApplication].delegate).serverURL stringByAppendingPathComponent:@"checkin.php"] ];
        NSLog(@"URL=%@",URL );
        
        NSString* requestBody = [NSString stringWithFormat:@"action=searchPlace&%@=%@&%@=%@&%@=%@&%@=%@"
                                 ,kLongBegin,[dicRadius objectForKey:kLongBegin]
                                 ,kLongEnd,[dicRadius objectForKey:kLongEnd]
                                 ,kLatBegin,[dicRadius objectForKey:kLatBegin]
                                 ,kLatEnd,[dicRadius objectForKey:kLatEnd]
                                 ];
        
        NSLog(@"requestBody=%@",requestBody );
        NSData *myRequestData = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
        
        [request setHTTPMethod: @"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        [request setHTTPBody: myRequestData];
        
        s_mapID++;
        NSInteger currentMapID = _mapView.tag = s_mapID;
            // IDを生成
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSURLResponse* response = nil;
            NSError* error = nil;
            NSData* dataPlaces = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            //		char* buffer = malloc([dataResult length] + 1);
            //		memcpy(buffer,[dataResult bytes],[dataResult length]);
            //		buffer[[dataResult length]] = '\0';
            //        NSLog(@"%s",buffer);
            
            if( error != nil ){
                char* buffer = malloc([dataPlaces length] + 1);
                memcpy(buffer,[dataPlaces bytes],[dataPlaces length]);
                buffer[[dataPlaces length]] = '\0';
                NSString* result = [NSString stringWithUTF8String:buffer];
                NSLog(@"result=%@", result );
                free(buffer);
                
                NSLog(@"error: %@",[error userInfo]);
//                if( _internetReach.currentReachabilityStatus == NotReachable ){
//                    
//                }
            }else{
                /*NSError**/ error = nil;
                NSDictionary* dicResult = [NSJSONSerialization JSONObjectWithData:dataPlaces options:0 error:&error];
                if( error != nil ){
                    char* buffer = malloc([dataPlaces length] + 1);
                    memcpy(buffer,[dataPlaces bytes],[dataPlaces length]);
                    buffer[[dataPlaces length]] = '\0';
                    NSString* result = [NSString stringWithUTF8String:buffer];
                    NSLog(@"result=%@", result );
                    free(buffer);
                    
                    NSLog(@"error: %@",[error userInfo]);
                    //                abort();
                }else{
                    NSString* status = [dicResult valueForKey:@"status"];
                    if( [status compare:@"succeeded"] == NSOrderedSame ){
                        _places = [dicResult valueForKey:@"places"];
                        
                        
                        NSLog(@"_places=%@",_places );
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if( _mapView.tag == currentMapID ){
                                NSLog(@"_tableView=%@", _tableView );
                                [_tableView reloadData];
                                // 一覧の更新
                                
                                
                                [_mapView removeAnnotations:_mapView.annotations];
                                
                                NSMutableArray* array = [NSMutableArray array];
                                NSInteger index = 0;
                                for( NSDictionary* dic in _places ){
                                    CLLocationDegrees latitude = [[dic valueForKey:@"lat"] floatValue];
                                    CLLocationDegrees longitude = [[dic valueForKey:@"long"] floatValue];
                                    
                                    //				NSLog(@"dic=%@", dic );
                                    
                                    CustomAnnotation* anotation = [[CustomAnnotation alloc]
                                                                   initWithLocation: CLLocationCoordinate2DMake(latitude,longitude)
                                                                   andParameters:[dic valueForKey:@"parameters"]
                                                                   andPlaceid:[dic valueForKey:@"placeid"]
                                                                   ];
                                    [array addObject:anotation];
                                    index++;
                                }
                                [_mapView addAnnotations:array];
                            }else{
                                NSLog(@"地図は更新済み");
                            }
                        });
                    }else{
                        NSLog(@"connectionDidFinishLoading: 解析エラー");
                    }
                }
                
            }
            
        });
        
//    }

}

- (void) firedUpdateCurretPlace:(id)sender
{
	[self reloadPlacesWithLatidudeAndLongitude:_latitudeAndLongitudeDic ];
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	
	NSDate* eventDate = newLocation.timestamp;
	NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
	if( abs(howRecent) < 15.0 ){
		//		DogFellowAppDelegate* appDelegate = (DogFellowAppDelegate*)([UIApplication sharedApplication].delegate);
		//		appDelegate.latitudeAndLongitudeDic
//		[_latitudeAndLongitudeDic release];
		_latitudeAndLongitudeDic = [[NSDictionary alloc] initWithObjectsAndKeys:
									[NSNumber numberWithFloat:newLocation.coordinate.latitude],@"latitude"
									,[NSNumber numberWithFloat:newLocation.coordinate.longitude],@"longitude"
									,nil
									];
		if( !_initializedRegion ){
			[_mapView setRegion:MKCoordinateRegionMakeWithDistance( newLocation.coordinate , 200 , 200 )  animated:YES];
			_initializedRegion = YES;
            
            AppDelegate* appDelegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
            [appDelegate stopStandardUpdates];
		}else{
			MKCoordinateRegion newRegion = _mapView.region;	
			newRegion.center.latitude = newLocation.coordinate.latitude;
			newRegion.center.longitude = newLocation.coordinate.longitude;
			[_mapView setRegion:newRegion animated:YES];
		}
		
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
		[self performSelector:@selector(firedUpdateCurretPlace:) withObject:nil afterDelay:3.0f /*3秒毎更新*/];
	}else{
		
	}
	
}

/*
 - (void)locationManager:(CLLocationManager *)manager
 didUpdateHeading:(CLHeading *)newHeading 
 {
 NSDate* eventDate = newHeading.timestamp;
 NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
 if( abs(howRecent) < 15.0 ){
 //		heading_ = newHeading.trueHeading; // 地軸からの方向
 }
 }
 */

/*
 - (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
 {
 DFLog([NSString stringWithFormat:@"locationManager: didChangeAuthorizationStatus: call"]);
 }
 */

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	AppDelegate* appDelegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
	appDelegate.canceledLocationService = YES;
	
	/*
	 if( self.disabled == YES ){
	 self.disabled = NO;
	 [self.waitingView removeFromSuperview];
	 self.waitingView.hidden = YES;
	 [self rotateTweetToggleView:tweetToggleView_ rotated:YES];
	 }
	 */
	//	canceledLocationService_ = YES;
}


#pragma mark -
#pragma mark MKMapView delegate method(s)

#pragma mark -
#pragma mark CustomAnnotation2 delegate method 
- (void)CustomAnnotationViewTouch:(CustomAnnotationView*)myAnnotationView
{
	NSLog(@"CustomAnnotationViewTouch: call");
    
	// 配列から要素を検索
	for( NSDictionary* dic in _places ){
		NSString* placeid = [dic objectForKey:@"placeid"];
		if( [((CustomAnnotation*)(myAnnotationView.annotation)).placeid compare:placeid] == NSOrderedSame ){
            /*
			CheckinDetailViewController* controller = [[CheckinDetailViewController alloc] initWithNibName:(NSString *)@"CheckinDetailViewController" bundle:nil];
			controller.twitterAccount = twitterAccount_;
			controller.token = token_;
			controller.placeid = placeid;
			controller.checkinInformations = dic;
			
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
			*/
			break;
		}		
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	// これがユーザの位置の場合は、単にnilを返す
	if ([annotation isKindOfClass:[MKUserLocation class]])
		return nil;
    
	// カスタム注釈を処理する
	if ([annotation isKindOfClass:[CustomAnnotation class]]) {
		// まず、既存のピン注釈ビューをキューから取り出すことを試みる
		MKPinAnnotationView* pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
		if (!pinView) {
			// 既存のピン注釈ビューが利用できない場合は、新しいビューを作成する
#if 1  // カスタムアノテーションビュー
			CustomAnnotationView* customAnnotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotation"];
			customAnnotationView.delegate = self;
			pinView = (MKPinAnnotationView*) customAnnotationView;
#else   // デフォルトのアノテーションビュー
			pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
													   reuseIdentifier:@"CustomPinAnnotation"];
			pinView.pinColor = MKPinAnnotationColorRed; pinView.animatesDrop = YES; pinView.canShowCallout = YES;
			
			// 詳細ディスクロージャボタンを吹き出しに追加する
			UIButton* rightButton = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
			[rightButton addTarget:self action:@selector(myShowDetailsMethod:) forControlEvents:UIControlEventTouchUpInside];
			pinView.rightCalloutAccessoryView = rightButton;
#endif
		}else{
			((CustomAnnotationView*)pinView).delegate = self;
			pinView.annotation = annotation;
		}

        // イメージの格納
		if ([pinView isKindOfClass:[CustomAnnotationView class]] ) {
            pinView.image = self.customAnotationImage;
        }
		
		return pinView;
	}
    
	return nil;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
	NSLog(@"mapView: regionWillChangeAnimated:");
}

- (void) firedUpdatePlace:(id)sender
{
    MKCoordinateRegion region = _mapView.region;
    
    NSDictionary* dicLatitudeAndLongitude = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             [NSNumber numberWithFloat:region.center.latitude],kLatitude
                                             ,[NSNumber numberWithFloat:region.center.longitude],kLongitude
                                             ,nil
                                             ];        
    
    [self reloadPlacesWithLatidudeAndLongitude:dicLatitudeAndLongitude ];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	NSLog(@"mapView: regionDidChangeAnimated:");
    
    if( _initializedRegion && _mapView.alpha != 1.0f ){
        [UIView animateWithDuration:.5f animations:^{
            _mapView.alpha = 1.0f;
        }];
        _initializedCurrentLocation = YES;
    }else if(_initializedCurrentLocation){
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
		[self performSelector:@selector(firedUpdatePlace:) withObject:nil afterDelay:1.0f /*1秒毎更新*/];
            // 位置情報を更新
    }
    
}


- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
	NSLog(@"mapViewWillStartLoadingMap: call");
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
	NSLog(@"mapViewDidFinishLoadingMap: call");
    
}

- (void)

:(MKMapView *)mapView withError:(NSError *)error
{
	NSLog(@"mapViewDidFailLoadingMap: call");
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    NSLog(@"prepareForSegue: call");
    
    if( [segue.destinationViewController isKindOfClass:[NewPlaceViewController class]] ){
        NewPlaceViewController* newPlaceViewController = (NewPlaceViewController*)(segue.destinationViewController);

        newPlaceViewController.latitude = [_latitudeAndLongitudeDic objectForKey:kLatitude];
        newPlaceViewController.longitude = [_latitudeAndLongitudeDic objectForKey:kLongitude];
        
        
        newPlaceViewController.latitude = [NSNumber numberWithDouble:43.05402f];
        newPlaceViewController.longitude = [NSNumber numberWithDouble:141.43939f];

    }else if( [segue.destinationViewController isKindOfClass:[UINavigationController class]] ){
        UINavigationController* navController = (UINavigationController*)segue.destinationViewController;
        if( [navController.topViewController isKindOfClass:[CheckinViewController class]] ){
            NSIndexPath* indexPath = [_tableView indexPathForSelectedRow];
            
            NSDictionary* place = [_places objectAtIndex:indexPath.row];
            NSString* placeid = [[place objectForKey:@"placeid"] description];
            
            NSLog(@"placeid=%@", placeid );
            NSLog(@"parameters=%@", [place objectForKey:@"parameters"] );
            
            CheckinViewController* checkinViewController = (CheckinViewController*)navController.topViewController;
            checkinViewController.placeid = placeid;
            checkinViewController.latitudeAndLongitude = _latitudeAndLongitudeDic;
            checkinViewController.parameters = [place objectForKey:@"parameters"];
            checkinViewController.delegate = self;
            
        }
        
    }
    
}

- (void) locationConfirmViewControllerDidDone:(LocationConfirmViewController*)locationConfirmViewController
{
    
}

- (void) locationConfirmViewControllerDidCancel:(LocationConfirmViewController*)locationConfirmViewController
{
    
}

- (void) locationConfirmViewControllerDidFailureSpecifyLocation:(LocationConfirmViewController*)locationConfirmViewController
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = nil;
    static NSString* CellIdentifierAddCurrentLocation = @"CellPlace";
    
    if( indexPath.section == 0 )
        CellIdentifier = CellIdentifierAddCurrentLocation;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self configureCell:cell indexPath:indexPath];
    
    return cell;
}

- (void) configureCell:(UITableViewCell*)cell indexPath:(NSIndexPath*) indexPath
{
    NSDictionary* dic = [_places objectAtIndex:indexPath.row];
    NSDictionary* dicParameters = [dic objectForKey:@"parameters"];
    
    NSLog(@"dicParameters=%@", dicParameters );
    
    cell.imageView.image = self.placeIconImage;
    cell.textLabel.text = [[dicParameters objectForKey:@"name"] description];
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - 
#pragma mark CheckinViewController
-(void) checkinViewControllerDidCheckIn:(CheckinViewController*) checkinViewController
{
    NSIndexPath* indexPath = [_tableView indexPathForSelectedRow];    
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void) checkinViewControllerDidCancel:(CheckinViewController*) checkinViewController
{
    NSIndexPath* indexPath = [_tableView indexPathForSelectedRow];    
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self dismissModalViewControllerAnimated:YES];
}

-(void) checkinViewControllerDidFailure:(CheckinViewController*) checkinViewController
{
    NSIndexPath* indexPath = [_tableView indexPathForSelectedRow];    
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self dismissModalViewControllerAnimated:YES];
}



@end
