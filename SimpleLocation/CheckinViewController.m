//
//  CheckinViewController.m
//  SimpleLocation
//
//  Created by Noto Kaname on 12/07/08.
//  Copyright (c) 2012年 能登 要. All rights reserved.
//

#import "SimpleLocation.h"
#import "CheckinViewController.h"
#import "AppDelegate.h"

@interface CheckinSegue : UIStoryboardSegue

@end

@implementation CheckinSegue

- (void) perform
{
    CheckinViewController* checkinViewController = (CheckinViewController*)self.sourceViewController;
    
    if( [self.identifier compare:@"Cancel"] == NSOrderedSame ){
        [checkinViewController.delegate checkinViewControllerDidCancel:checkinViewController];
    }else if( [self.identifier compare:@"Checkin"] == NSOrderedSame ){
        NSURL* URL = [NSURL URLWithString:[((AppDelegate*)[UIApplication sharedApplication].delegate).serverURL stringByAppendingPathComponent:@"checkin.php"] ];
        NSLog(@"URL=%@",URL );
        
        
        NSString* userid = ((AppDelegate*)[UIApplication sharedApplication].delegate).userid;
        
        NSString* requestBody = [NSString stringWithFormat:@"action=checkin&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@"
                                 ,kLatitude,[checkinViewController.latitudeAndLongitude objectForKey:kLatitude]
                                 ,kLongitude,[checkinViewController.latitudeAndLongitude objectForKey:kLongitude]
                                 ,kPlaceid,checkinViewController.placeid
                                 ,kUserid,userid
                                 ,kJSON,@"{}"
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
                            [checkinViewController.delegate checkinViewControllerDidCheckIn:checkinViewController];
                        });
                    }else{
                        NSLog(@"connectionDidFinishLoading: 解析エラー");
                        
                        NSLog(@"description=%@",[[dicResult valueForKey:@"description"] description] );
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [checkinViewController.delegate checkinViewControllerDidFailure:checkinViewController];
                        });
                    }
                }
            }
        });  
        
    } 
    
}

@end



@interface CheckinViewController ()
{
    NSArray* _chekins;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (NSString*) calculatePastTime:(NSDate*) pasttime;
- (void) configureCell:(UITableViewCell*)cell indexPath:(NSIndexPath*) indexPath;
@end

@implementation CheckinViewController
@synthesize tableView=_tableView;
@synthesize latitudeAndLongitude=_latitudeAndLongitude;
@synthesize parameters=_parameters;
@synthesize placeid=_placeid;
@synthesize delegate=delegate_;

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

    [_tableView reloadData];
    
    NSURL* URL = [NSURL URLWithString:[((AppDelegate*)[UIApplication sharedApplication].delegate).serverURL stringByAppendingPathComponent:@"checkin.php"] ];
    NSLog(@"URL=%@",URL );
    
    
#if 0
    NSDate* lastUpdate = [NSDate dateWithTimeIntervalSinceNow: - 1.0f * 60.0f];
    NSString* requestBody = [NSString stringWithFormat:@"action=searchCheckinWithLastupdate&%@=%@&%@=%u"
                             ,kPlaceid,_placeid
                             ,kLastupdate,(time_t) [lastUpdate timeIntervalSince1970]
                             ];
#else
    NSString* requestBody = [NSString stringWithFormat:@"action=searchCheckin&%@=%@"
                             ,kPlaceid,_placeid
                             ];
#endif    
    
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
                    _chekins = [dicResult valueForKey:@"checkins"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"_tableView=%@", _tableView );
                        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                            // 一覧の更新
                    });
                }else{
                    NSLog(@"connectionDidFinishLoading: 解析エラー");
                }
            }
            
        }
        
    });
    
    
    
    
//    _chekins
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 
#pragma mark Past time calculate
- (NSString*) calculatePastTime:(NSDate*) pasttime
{
    NSTimeInterval timeintervalPasttime = -[pasttime timeIntervalSinceNow];
#define ONE_DAY_PAST (60.0f * 60.0f * 24.0f)
#define ONE_HOUR_PAST (60.0f * 60.0)
    
    NSString* pastTimeText = nil;
    
    if( timeintervalPasttime < ONE_HOUR_PAST ){
        pastTimeText = [NSString stringWithFormat:@"%d分前", (NSInteger)(ceil(timeintervalPasttime / 60.0)) ];
    }else if( timeintervalPasttime < ONE_HOUR_PAST * 24.0f){
        pastTimeText = [NSString stringWithFormat:@"%d時間前", (NSInteger)(ceil(timeintervalPasttime / ONE_HOUR_PAST)) ];
    }else{
        NSInteger day = (NSInteger)(ceil(timeintervalPasttime / ONE_DAY_PAST));
        if( day <= 365 )
            pastTimeText = [NSString stringWithFormat:@"%d日前",day  ];
        else
            pastTimeText = [NSString stringWithFormat:@"%d年前",day / 365 ];
    }
    return pastTimeText;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 4 : [_chekins count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = nil;
    static NSString* CellIdentifierPlaceInfo = @"CellPlaceInfo";
    static NSString* CellIdentifierCheckin = @"CellCheckin";
    
    if( indexPath.section == 0 )
        CellIdentifier = CellIdentifierPlaceInfo;
    else if( indexPath.section == 1 )
        CellIdentifier = CellIdentifierCheckin;
    
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
                    cell.textLabel.text = @"名前";
                    cell.detailTextLabel.text = [[_parameters objectForKey:@"name"] description];
                    break;
                case 1:
                    cell.textLabel.text = @"住所";
                    cell.detailTextLabel.text = [[_parameters objectForKey:@"address"] description];
                    break;
                case 2:
                    cell.textLabel.text = @" ";
                    cell.detailTextLabel.text = [[_parameters objectForKey:@"address2"] description];
                    break;
                case 3:
                    cell.textLabel.text = @" ";
                    cell.detailTextLabel.text = [[_parameters objectForKey:@"address3"] description];
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            NSDictionary* dic = [_chekins objectAtIndex:indexPath.row];
            cell.textLabel.text = [[dic objectForKey:kUserid] description];
            id lastupdateValue = [dic objectForKey:kLastupdate];
  
            NSDate* lastupdate = [NSDate dateWithTimeIntervalSince1970:[lastupdateValue floatValue]];
            NSLog(@"lastupdate=%@", lastupdate );
            
            
            cell.detailTextLabel.text = [self calculatePastTime:lastupdate];
        }
            break;
        default:
            break;
    }
    
}

@end
