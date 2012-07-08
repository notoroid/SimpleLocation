//
//  InputAddressViewController.m
//  SimpleLocation
//
//  Created by Noto Kaname on 12/07/06.
//  Copyright (c) 2012年 能登 要. All rights reserved.
//

#import "SimpleLocation.h"
#import "InputAddressViewController.h"
#import "locationConfirmViewController.h"

//@interface AddressCheckSegue : UIStoryboardSegue
//
//@end
//
//@implementation AddressCheckSegue
//
//- (void)perform
//{
//    InputAddressViewController* inputAddressViewController = (InputAddressViewController*)self.sourceViewController;
//    
//    if( [inputAddressViewController.textField.text length] <= 0 ){
//        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"住所入力確認" message:@"住所が入力されていません。" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//        [alertView show];
//    }else{
//        LocationConfirmViewController* locationConfirmViewController = (LocationConfirmViewController*)([self.destinationViewController navigationController].topViewController);
//        
//        locationConfirmViewController.reverseGeocording = inputAddressViewController.textField.text;
//        
//        [inputAddressViewController presentModalViewController:self.destinationViewController animated:YES];
//    }
//    
//}
//
//@end

@interface InputAddressViewController ()

@end

@implementation InputAddressViewController

@synthesize textField = _textField;
@synthesize propertyName=_propertyName;
@synthesize target=_target;
@synthesize isDouble=_isDouble;
@synthesize placeholder=_placeholder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) firedSave:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

    SEL selPutMethodSel = NSSelectorFromString([NSString stringWithFormat:@"set%@:",[_propertyName capitalizedString]] ); 
    if( [_target respondsToSelector:selPutMethodSel] ){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:selPutMethodSel withObject:_isDouble ? [NSNumber numberWithDouble:[_textField.text doubleValue] ] : _textField.text];
#pragma clang diagnostic pop    
    }else{
        NSLog(@"No set method.");
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(firedSave:);
    
    
    
    SEL selGetMethodSel = NSSelectorFromString(_propertyName); 
    if( [_target respondsToSelector:selGetMethodSel] ){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        _textField.text = [[_target performSelector:selGetMethodSel ] description];
#pragma clang diagnostic pop    
    }else{
        NSLog(@"No get method.");
    }
    
    _textField.placeholder = _placeholder;
    
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_textField becomeFirstResponder];
}


- (void)viewDidUnload
{
    [self setTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
//{
//    if( [segue.identifier compare:@"reverseGeocording"] == NSOrderedSame ){
//
//    }
//}


@end
