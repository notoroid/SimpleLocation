//
//  CustomAnnotationView.m
//  DogFellow
//
//  Created by 能登 要 on 11/02/11.
//  Copyright 2011 能登 要. All rights reserved.
//

#import "SimpleLocation.h"
#import "CustomAnnotationView.h"

@implementation CustomAnnotationView

@synthesize delegate=_delegate;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	if (self) {
		// フレームサイズを適切な値に設定する
		CGRect myFrame = self.frame;
		myFrame.size.width = 57;
		myFrame.size.height = 57;
		self.frame = myFrame;	
		
		// 不透過処理のプロパティは、デフォルトではYES。これを
		// NOに設定することで、地図コンテンツが、レンダリング対象外のビューの領域を
		// 透かして見えるようになる。
		self.opaque = NO;
	}	
	return self;
}

- (void)singleClickMethod:(UITouch *)touch
{
	[delegate_ CustomAnnotationViewTouch:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if([touch tapCount] == 1)
    {
        // schedule "singleClickMethod" to be called with the touch object
        // in 0.25 seconds unless I cancel it first.
		lastTouchPoint = [touch locationInView:self];
		
		
        [self performSelector:@selector(singleClickMethod:) withObject:touch afterDelay:0.25];
        return;  // nothing left to do until either a second click or 0.25 seconds
    }
	
    if ([touch tapCount] == 2)
	{
        // cancel the scheduled call to "singleClickMethod"
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        // now perform the double click action
		
		//		[doubleTap doubleTapScrollView:self eventWithCount:2];
    }
}


@end
