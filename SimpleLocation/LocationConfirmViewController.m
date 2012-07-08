//
//  LocationConfirmViewController.m
//  SimpleLocation
//
//  Created by Noto Kaname on 12/07/05.
//  Copyright (c) 2012年 能登 要. All rights reserved.
//

#import "SimpleLocation.h"
#import "LocationConfirmViewController.h"
#import "URLEncodeUtil.h"
#import "NewPlaceViewController.h"
#import "AppDelegate.h"

@interface PlaceSubmitCancelSegue : UIStoryboardSegue

@end

@implementation PlaceSubmitCancelSegue
- (void) perform
{
    LocationConfirmViewController* locationConfirmViewController = self.sourceViewController;
    [locationConfirmViewController.delegate locationConfirmViewControllerDidDone:locationConfirmViewController result:nil];
}
@end


@interface PlaceSubmitDoneSegue : UIStoryboardSegue

@end

@implementation PlaceSubmitDoneSegue

- (void) perform
{
    LocationConfirmViewController* locationConfirmViewController = self.sourceViewController;
    
    NSError* error = nil;
    NSData* dataJson = [NSJSONSerialization dataWithJSONObject:locationConfirmViewController.parameters options:0 error:&error];
    NSString* encodedJSON = encodeURIComponentFromData(dataJson);
    
    
    NSURL* URL = [NSURL URLWithString:[((AppDelegate*)[UIApplication sharedApplication].delegate).serverURL stringByAppendingPathComponent:@"checkin.php"] ];
    NSLog(@"URL=%@",URL );
    
    NSString* requestBody = [NSString stringWithFormat:@"action=update&%@=%@&%@=%@&%@=%@"
                             ,kLatitude,[locationConfirmViewController.latitudeAndLongitude objectForKey:kLatitude]
                             ,kLongitude,[locationConfirmViewController.latitudeAndLongitude objectForKey:kLongitude]
                             ,kJSON,encodedJSON
                             ];
    
    NSLog(@"requestBody=%@",requestBody );
    NSData *myRequestData = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: myRequestData];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURLResponse* response = nil;
        NSError* error = nil;
        NSData* dataResult = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if( error != nil ){
            char* buffer = malloc([dataResult length] + 1);
            memcpy(buffer,[dataResult bytes],[dataResult length]);
            buffer[[dataResult length]] = '\0';
            NSString* result = [NSString stringWithUTF8String:buffer];
            NSLog(@"result=%@", result );
            free(buffer);
            
            NSLog(@"error: %@",[error userInfo]);
            //            abort();
            //            if( _internetReach.currentReachabilityStatus == NotReachable ){
            //                
            //                
            //            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"場所登録の失敗" message:@"場所登録に失敗しました。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            });
        }else{
            /*NSError**/ error = nil;
            NSDictionary* dicResult = [NSJSONSerialization JSONObjectWithData:dataResult options:0 error:&error];
            if( error != nil ){
                char* buffer = malloc([dataResult length] + 1);
                memcpy(buffer,[dataResult bytes],[dataResult length]);
                buffer[[dataResult length]] = '\0';
                NSString* result = [NSString stringWithUTF8String:buffer];
                NSLog(@"result=%@", result );
                free(buffer);
                
                NSLog(@"error: %@",[error userInfo]);
                //                abort();
            }else{
                NSString* status = [dicResult valueForKey:@"status"];
                if( [status compare:@"succeeded"] == NSOrderedSame ){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"場所登録の成功" message:@"場所登録に成功しました。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                        [locationConfirmViewController.delegate locationConfirmViewControllerDidDone:locationConfirmViewController result:dicResult];
                    });
                    
                }else{
                    NSLog(@"connectionDidFinishLoading: 解析エラー");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"場所登録の失敗" message:@"場所登録に失敗しました。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                    });
                }
            }
        }
    });      


}

@end

@interface LocationConfirmViewController ()
{
    BOOL _initializedRegion;
    __weak IBOutlet MKMapView *_mapView;
}

@end



@implementation LocationConfirmViewController

@synthesize delegate=_delegate;
@synthesize latitudeAndLongitude=_latitudeAndLongitude;
@synthesize parameters=_parameters;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CLLocation* newLocation = [[CLLocation alloc] initWithLatitude:[[_latitudeAndLongitude objectForKey:@"latitude"] doubleValue] longitude:[[_latitudeAndLongitude objectForKey:@"longitude"] doubleValue] ];
    [_mapView setRegion:MKCoordinateRegionMakeWithDistance( newLocation.coordinate , 200 , 200 )  animated:YES];
    _initializedRegion = YES;
    
//    self.navigationItem.rightBarButtonItem.target = self;
//    self.navigationItem.rightBarButtonItem.action = @selector(fireDone:);
}

//- (void) fireDone:(id)sender
//{
//    NSLog(@"fireDone: call");
//    
//  
//    
//}

- (void)viewDidUnload
{
    _mapView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark MKMapView delegate method(s)

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	// これがユーザの位置の場合は、単にnilを返す
	if ([annotation isKindOfClass:[MKUserLocation class]])
		return nil;
    
	return nil;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
	NSLog(@"mapView: regionWillChangeAnimated:");
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	NSLog(@"mapView: regionWillChangeAnimated:");
    
    if( _initializedRegion && _mapView.alpha != 1.0f ){
        [UIView animateWithDuration:.5f animations:^{
            _mapView.alpha = 1.0f;
            
        }];
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

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    NSLog(@"mapViewDidFailLoadingMap: call");
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 2 : 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = nil;
    static NSString* CellIdentifierAddCurrentLocation = @"CellLatLong";
    static NSString* CellIdentifierAddReverseGeometry = @"CellPlaceInfo";
    
    if( indexPath.section == 0 )
        CellIdentifier = CellIdentifierAddCurrentLocation;
    else if( indexPath.section == 1 )
        CellIdentifier = CellIdentifierAddReverseGeometry;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self configureCell:cell indexPath:indexPath];
    
    return cell;
}

- (void) configureCell:(UITableViewCell*)cell indexPath:(NSIndexPath*) indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"緯度";
                    cell.detailTextLabel.text = [[_latitudeAndLongitude objectForKey:@"latitude"] description];
                    break;
                case 1:
                    cell.textLabel.text = @"経度";
                    cell.detailTextLabel.text = [[_latitudeAndLongitude objectForKey:@"longitude"] description];
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"名前";
                    cell.detailTextLabel.text = [[_parameters objectForKey:@"name"] description];
                    break;
                case 1:
                    cell.textLabel.text = @"かな";
                    cell.detailTextLabel.text = [[_parameters objectForKey:@"kana"] description];
                    break;
                case 2:
                    cell.textLabel.text = @"住所";
                    cell.detailTextLabel.text = [[_parameters objectForKey:@"address"] description];
                    break;
                case 3:
                    cell.textLabel.text = @"住所2";
                    cell.detailTextLabel.text = [[_parameters objectForKey:@"address2"] description];
                    break;
                case 4:
                    cell.textLabel.text = @"住所3";
                    cell.detailTextLabel.text = [[_parameters objectForKey:@"address3"] description];
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     //     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     //     // ...
     //     // Pass the selected object to the new view controller.
     //     [self.navigationController pushViewController:detailViewController animated:YES];
     //     */
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




@end
