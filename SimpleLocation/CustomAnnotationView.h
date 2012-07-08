//
//  CustomAnnotationView.h
//  DogFellow
//
//  Created by 能登 要 on 11/02/11.
//  Copyright 2011 能登 要. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol CustomAnnotationViewDelegate;

@interface CustomAnnotationView : MKAnnotationView
{
	// カスタムのデータメンバ // カスタムのプロパティとメソッド
	id<CustomAnnotationViewDelegate> delegate_;
	CGPoint lastTouchPoint;
}

@property(nonatomic,weak) id<CustomAnnotationViewDelegate> delegate;

@end

@protocol CustomAnnotationViewDelegate
- (void)CustomAnnotationViewTouch:(CustomAnnotationView*)myAnnotationView;
@end

