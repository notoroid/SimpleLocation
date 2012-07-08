//
//  AddPlaceViewController.m
//  SimpleLocation
//
//  Created by Noto Kaname on 12/07/05.
//  Copyright (c) 2012年 能登 要. All rights reserved.
//

#import "SimpleLocation.h"
#import "NewPlaceViewController.h"
#import "LocationConfirmViewController.h"
#import "InputAddressViewController.h"

@interface InputCheckSeque : UIStoryboardPopoverSegue


@end

@implementation InputCheckSeque

- (void) perform
{
    NewPlaceViewController* newPlaceViewController = (NewPlaceViewController*)self.sourceViewController;

    LocationConfirmViewController* locationConfirmViewController = (LocationConfirmViewController*)(((UINavigationController*)self.destinationViewController).topViewController);
    locationConfirmViewController.latitudeAndLongitude = [NSDictionary dictionaryWithObjectsAndKeys:newPlaceViewController.latitude,kLatitude
                                                                                                    ,newPlaceViewController.longitude,kLongitude,nil];
    
    
    NSDictionary* dicJSON = [NSDictionary dictionaryWithObjectsAndKeys: newPlaceViewController.name,@"name"
                                                                        ,newPlaceViewController.kana,@"kana"
                                                                        ,newPlaceViewController.address,@"address"
                                                                        ,newPlaceViewController.address2,@"address2"
                                                                        ,newPlaceViewController.address3,@"address3", nil];
    
//    NSError* error = nil;
//    NSData* dataParameters = [NSJSONSerialization dataWithJSONObject:dicJSON options:0 error:&error];
    
    locationConfirmViewController.parameters = dicJSON/*[NSString stringWithCharacters:[dataParameters bytes] length:[dataParameters length]]*/;
    
    locationConfirmViewController.delegate = newPlaceViewController;
    [newPlaceViewController presentModalViewController:self.destinationViewController animated:YES];
    
    UIViewController* vc = newPlaceViewController.modalViewController;
    NSLog(@"vc=%@",vc );
}

@end


@interface NewPlaceViewController ()
{
    NSIndexPath* _lastSelectedIndexPath;
}
- (void) configureCell:(UITableViewCell*)cell indexPath:(NSIndexPath*) indexPath;
@end

@implementation NewPlaceViewController

@synthesize latitude=_latitude;
@synthesize longitude=_longitude;
@synthesize name=_name;
@synthesize kana=_kana;
@synthesize address=_address;
@synthesize address2=_address2;
@synthesize address3=_address3;
@synthesize resultByPlaceUpdate=_resultByPlaceUpdate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if( _lastSelectedIndexPath ){
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:_lastSelectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        _lastSelectedIndexPath = nil;
    }
    
    if( _resultByPlaceUpdate != nil ){
        [self.navigationController popToRootViewControllerAnimated:YES];
        _resultByPlaceUpdate = nil;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
                    cell.detailTextLabel.text = [_latitude description];
                    break;
                case 1:
                    cell.textLabel.text = @"経度";
                    cell.detailTextLabel.text = [_longitude description];
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
                    cell.detailTextLabel.text = [_name description];
                    break;
                case 1:
                    cell.textLabel.text = @"かな";
                    cell.detailTextLabel.text = [_kana description];
                    break;
                case 2:
                    cell.textLabel.text = @"住所";
                    cell.detailTextLabel.text = [_address description];
                    break;
                case 3:
                    cell.textLabel.text = @"住所2";
                    cell.detailTextLabel.text = [_address2 description];
                    break;
                case 4:
                    cell.textLabel.text = @"住所3";
                    cell.detailTextLabel.text = [_address3 description];
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    if( [segue.identifier compare:@"LatitudeAndLongitude"] == NSOrderedSame || [segue.identifier compare:@"Perameters"] == NSOrderedSame ){

        NSLog(@"segue.identifier=%@", segue.identifier );
        
        
        NSIndexPath* indexPath = _lastSelectedIndexPath = [self.tableView indexPathForSelectedRow];
        InputAddressViewController* inputAddressViewController = (InputAddressViewController*)segue.destinationViewController;

        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        inputAddressViewController.target = self;
        inputAddressViewController.placeholder = cell.textLabel.text;
        
        switch (indexPath.section) {
            case 0:
            {
                switch (indexPath.row) {
                    case 0:
                        inputAddressViewController.propertyName = @"latitude";
                        inputAddressViewController.isDouble = YES;
                        break;
                    case 1:
                        inputAddressViewController.propertyName = @"longitude";
                        inputAddressViewController.isDouble = YES;
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
                        inputAddressViewController.propertyName = @"name";
                        break;
                    case 1:
                        inputAddressViewController.propertyName = @"kana";
                        break;
                    case 2:
                        inputAddressViewController.propertyName = @"address";
                        break;
                    case 3:
                        inputAddressViewController.propertyName = @"address2";
                        break;
                    case 4:
                        inputAddressViewController.propertyName = @"address3";
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
}

- (void) locationConfirmViewControllerDidDone:(LocationConfirmViewController*)locationConfirmViewController result:(NSDictionary*)result
{
    self.resultByPlaceUpdate = result;
    [self dismissModalViewControllerAnimated:NO];
}

@end
