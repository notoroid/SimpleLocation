//
//  InputAddressViewController.h
//  SimpleLocation
//
//  Created by Noto Kaname on 12/07/06.
//  Copyright (c) 2012年 能登 要. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputAddressViewController : UIViewController

@property(weak, nonatomic) IBOutlet UITextField *textField;
@property(strong, nonatomic) NSString* propertyName;
@property(weak, nonatomic) NSObject* target;
@property(assign,nonatomic) BOOL isDouble;
@property(strong,nonatomic) NSString* placeholder;
@end
