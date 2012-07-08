//
//  FigureRenderer.m
//  Eertyks
//
//  Created by Noto Kaname on 12/05/03.
//  Copyright (c) 2012年 Irimasu Densan Planning. All rights reserved.
//

#import "FigureRenderer.h"
//#import "cocos2d.h"

@implementation FigureRenderer

+ (void) renderWithFigureType:(FigureRendererType)figureRendererType
{
    switch (figureRendererType) {
        case FigureRendererTypeCustomPin:
        {
            //// General Declarations
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            //// Color Declarations
            UIColor* color = [UIColor colorWithRed: 0.12 green: 0.63 blue: 0.8 alpha: 1];
            UIColor* color2 = [UIColor colorWithRed: 0.13 green: 0.44 blue: 0.55 alpha: 1];
            UIColor* color3 = [UIColor colorWithRed: 0.54 green: 0.82 blue: 0.92 alpha: 1];
            UIColor* color4 = [UIColor colorWithRed: 0.26 green: 0.26 blue: 0.26 alpha: 0.2];
            UIColor* color5 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
            
            //// Shadow Declarations
            UIColor* shadow = color5;
            CGSize shadowOffset = CGSizeMake(0, -0);
            CGFloat shadowBlurRadius = 4;
            
            
            //// Bezier 3 Drawing
            UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
            [bezier3Path moveToPoint: CGPointMake(16.21, 19.23)];
            [bezier3Path addCurveToPoint: CGPointMake(15.11, 21.63) controlPoint1: CGPointMake(14.92, 19.89) controlPoint2: CGPointMake(13.81, 20.97)];
            [bezier3Path addCurveToPoint: CGPointMake(19.8, 21.63) controlPoint1: CGPointMake(16.4, 22.3) controlPoint2: CGPointMake(18.5, 22.3)];
            [bezier3Path addCurveToPoint: CGPointMake(20.9, 19.23) controlPoint1: CGPointMake(21.09, 20.97) controlPoint2: CGPointMake(22.2, 19.89)];
            [bezier3Path addCurveToPoint: CGPointMake(16.21, 19.23) controlPoint1: CGPointMake(19.61, 18.56) controlPoint2: CGPointMake(17.51, 18.56)];
            [bezier3Path closePath];
            [bezier3Path moveToPoint: CGPointMake(21.32, 15.9)];
            [bezier3Path addCurveToPoint: CGPointMake(27.04, 20.15) controlPoint1: CGPointMake(29.08, 16.82) controlPoint2: CGPointMake(27.04, 20.15)];
            [bezier3Path addLineToPoint: CGPointMake(14.69, 29.5)];
            [bezier3Path addCurveToPoint: CGPointMake(9.97, 20.15) controlPoint1: CGPointMake(14.69, 29.5) controlPoint2: CGPointMake(10.38, 21.51)];
            [bezier3Path addCurveToPoint: CGPointMake(21.32, 15.9) controlPoint1: CGPointMake(10.88, 19) controlPoint2: CGPointMake(13.56, 14.97)];
            [bezier3Path closePath];
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
            [color4 setFill];
            [bezier3Path fill];
            CGContextRestoreGState(context);
            
            
            
            //// Bezier 2 Drawing
            UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
            [bezier2Path moveToPoint: CGPointMake(12.74, 12.01)];
            [bezier2Path addCurveToPoint: CGPointMake(12.74, 16.35) controlPoint1: CGPointMake(11.49, 13.21) controlPoint2: CGPointMake(11.49, 15.15)];
            [bezier2Path addCurveToPoint: CGPointMake(17.26, 16.35) controlPoint1: CGPointMake(13.99, 17.54) controlPoint2: CGPointMake(16.01, 17.54)];
            [bezier2Path addCurveToPoint: CGPointMake(17.26, 12.01) controlPoint1: CGPointMake(18.51, 15.15) controlPoint2: CGPointMake(18.51, 13.21)];
            [bezier2Path addCurveToPoint: CGPointMake(12.74, 12.01) controlPoint1: CGPointMake(16.01, 10.81) controlPoint2: CGPointMake(13.99, 10.81)];
            [bezier2Path closePath];
            [bezier2Path moveToPoint: CGPointMake(20.66, 8.25)];
            [bezier2Path addCurveToPoint: CGPointMake(21.87, 17.6) controlPoint1: CGPointMake(23.3, 10.78) controlPoint2: CGPointMake(23.71, 14.66)];
            [bezier2Path addLineToPoint: CGPointMake(15, 29)];
            [bezier2Path addLineToPoint: CGPointMake(8.13, 17.6)];
            [bezier2Path addCurveToPoint: CGPointMake(9.34, 8.25) controlPoint1: CGPointMake(6.29, 14.66) controlPoint2: CGPointMake(6.7, 10.78)];
            [bezier2Path addCurveToPoint: CGPointMake(20.66, 8.25) controlPoint1: CGPointMake(12.47, 5.25) controlPoint2: CGPointMake(17.53, 5.25)];
            [bezier2Path closePath];
            [color setFill];
            [bezier2Path fill];
            
            
            
            //// Bezier 4 Drawing
            UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
            [bezier4Path moveToPoint: CGPointMake(20.23, 8.01)];
            [bezier4Path addCurveToPoint: CGPointMake(22.48, 13.33) controlPoint1: CGPointMake(21.87, 9.47) controlPoint2: CGPointMake(22.62, 11.42)];
            [bezier4Path addCurveToPoint: CGPointMake(20.23, 8.93) controlPoint1: CGPointMake(22.36, 11.73) controlPoint2: CGPointMake(21.61, 10.16)];
            [bezier4Path addCurveToPoint: CGPointMake(9.27, 8.93) controlPoint1: CGPointMake(17.2, 6.25) controlPoint2: CGPointMake(12.3, 6.25)];
            [bezier4Path addCurveToPoint: CGPointMake(7.02, 13.33) controlPoint1: CGPointMake(7.89, 10.16) controlPoint2: CGPointMake(7.14, 11.73)];
            [bezier4Path addCurveToPoint: CGPointMake(9.27, 8.01) controlPoint1: CGPointMake(6.88, 11.42) controlPoint2: CGPointMake(7.63, 9.47)];
            [bezier4Path addCurveToPoint: CGPointMake(20.23, 8.01) controlPoint1: CGPointMake(12.3, 5.33) controlPoint2: CGPointMake(17.2, 5.33)];
            [bezier4Path closePath];
            [bezier4Path moveToPoint: CGPointMake(11.71, 13.86)];
            [bezier4Path addCurveToPoint: CGPointMake(12.56, 15.28) controlPoint1: CGPointMake(11.8, 14.34) controlPoint2: CGPointMake(12.09, 14.86)];
            [bezier4Path addCurveToPoint: CGPointMake(16.94, 15.28) controlPoint1: CGPointMake(13.77, 16.35) controlPoint2: CGPointMake(15.73, 16.35)];
            [bezier4Path addCurveToPoint: CGPointMake(17.81, 13.79) controlPoint1: CGPointMake(17.42, 14.86) controlPoint2: CGPointMake(17.7, 14.34)];
            [bezier4Path addCurveToPoint: CGPointMake(16.94, 16.19) controlPoint1: CGPointMake(17.97, 14.64) controlPoint2: CGPointMake(17.68, 15.54)];
            [bezier4Path addCurveToPoint: CGPointMake(12.56, 16.19) controlPoint1: CGPointMake(15.73, 17.27) controlPoint2: CGPointMake(13.77, 17.27)];
            [bezier4Path addCurveToPoint: CGPointMake(11.69, 13.79) controlPoint1: CGPointMake(11.82, 15.54) controlPoint2: CGPointMake(11.53, 14.64)];
            [bezier4Path addLineToPoint: CGPointMake(11.71, 13.86)];
            [bezier4Path closePath];
            [color3 setFill];
            [bezier4Path fill];
            
            
            
            //// Bezier Drawing
            UIBezierPath* bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint: CGPointMake(12.56, 12.01)];
            [bezierPath addCurveToPoint: CGPointMake(12.56, 16.35) controlPoint1: CGPointMake(11.35, 13.21) controlPoint2: CGPointMake(11.35, 15.15)];
            [bezierPath addCurveToPoint: CGPointMake(16.94, 16.35) controlPoint1: CGPointMake(13.77, 17.54) controlPoint2: CGPointMake(15.73, 17.54)];
            [bezierPath addCurveToPoint: CGPointMake(16.94, 12.01) controlPoint1: CGPointMake(18.15, 15.15) controlPoint2: CGPointMake(18.15, 13.21)];
            [bezierPath addCurveToPoint: CGPointMake(12.56, 12.01) controlPoint1: CGPointMake(15.73, 10.81) controlPoint2: CGPointMake(13.77, 10.81)];
            [bezierPath closePath];
            [bezierPath moveToPoint: CGPointMake(20.23, 8.25)];
            [bezierPath addCurveToPoint: CGPointMake(21.4, 17.6) controlPoint1: CGPointMake(22.79, 10.78) controlPoint2: CGPointMake(23.19, 14.66)];
            [bezierPath addLineToPoint: CGPointMake(14.75, 29)];
            [bezierPath addLineToPoint: CGPointMake(8.1, 17.6)];
            [bezierPath addCurveToPoint: CGPointMake(9.27, 8.25) controlPoint1: CGPointMake(6.31, 14.66) controlPoint2: CGPointMake(6.71, 10.78)];
            [bezierPath addCurveToPoint: CGPointMake(20.23, 8.25) controlPoint1: CGPointMake(12.3, 5.25) controlPoint2: CGPointMake(17.2, 5.25)];
            [bezierPath closePath];
            [color2 setStroke];
            bezierPath.lineWidth = 0.5;
            [bezierPath stroke];
        }
            break;
    case FigureRendererTypePlaceIcon:
        {
            //// General Declarations
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            //// Color Declarations
            UIColor* color = [UIColor colorWithRed: 0.06 green: 0.64 blue: 0.8 alpha: 1];
            UIColor* color2 = [UIColor colorWithRed: 0.11 green: 0.44 blue: 0.55 alpha: 1];
            UIColor* color3 = [UIColor colorWithRed: 0.53 green: 0.83 blue: 0.92 alpha: 1];
            UIColor* color4 = [UIColor colorWithRed: 0.26 green: 0.26 blue: 0.26 alpha: 0.2];
            UIColor* color5 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
            
            //// Shadow Declarations
            UIColor* shadow = color5;
            CGSize shadowOffset = CGSizeMake(0, -0);
            CGFloat shadowBlurRadius = 4;
            
            
            //// Bezier 3 Drawing
            UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
            [bezier3Path moveToPoint: CGPointMake(15.21, 14.23)];
            [bezier3Path addCurveToPoint: CGPointMake(14.11, 16.63) controlPoint1: CGPointMake(13.92, 14.89) controlPoint2: CGPointMake(12.81, 15.97)];
            [bezier3Path addCurveToPoint: CGPointMake(18.8, 16.63) controlPoint1: CGPointMake(15.4, 17.3) controlPoint2: CGPointMake(17.5, 17.3)];
            [bezier3Path addCurveToPoint: CGPointMake(19.9, 14.23) controlPoint1: CGPointMake(20.09, 15.97) controlPoint2: CGPointMake(21.2, 14.89)];
            [bezier3Path addCurveToPoint: CGPointMake(15.21, 14.23) controlPoint1: CGPointMake(18.61, 13.56) controlPoint2: CGPointMake(16.51, 13.56)];
            [bezier3Path closePath];
            [bezier3Path moveToPoint: CGPointMake(20.32, 10.9)];
            [bezier3Path addCurveToPoint: CGPointMake(26.04, 15.15) controlPoint1: CGPointMake(28.08, 11.82) controlPoint2: CGPointMake(26.04, 15.15)];
            [bezier3Path addLineToPoint: CGPointMake(13.69, 24.5)];
            [bezier3Path addCurveToPoint: CGPointMake(8.97, 15.15) controlPoint1: CGPointMake(13.69, 24.5) controlPoint2: CGPointMake(9.38, 16.51)];
            [bezier3Path addCurveToPoint: CGPointMake(20.32, 10.9) controlPoint1: CGPointMake(9.88, 14) controlPoint2: CGPointMake(12.56, 9.97)];
            [bezier3Path closePath];
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
            [color4 setFill];
            [bezier3Path fill];
            CGContextRestoreGState(context);
            
            
            
            //// Bezier 2 Drawing
            UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
            [bezier2Path moveToPoint: CGPointMake(11.74, 7.01)];
            [bezier2Path addCurveToPoint: CGPointMake(11.74, 11.35) controlPoint1: CGPointMake(10.49, 8.21) controlPoint2: CGPointMake(10.49, 10.15)];
            [bezier2Path addCurveToPoint: CGPointMake(16.26, 11.35) controlPoint1: CGPointMake(12.99, 12.54) controlPoint2: CGPointMake(15.01, 12.54)];
            [bezier2Path addCurveToPoint: CGPointMake(16.26, 7.01) controlPoint1: CGPointMake(17.51, 10.15) controlPoint2: CGPointMake(17.51, 8.21)];
            [bezier2Path addCurveToPoint: CGPointMake(11.74, 7.01) controlPoint1: CGPointMake(15.01, 5.81) controlPoint2: CGPointMake(12.99, 5.81)];
            [bezier2Path closePath];
            [bezier2Path moveToPoint: CGPointMake(19.66, 3.25)];
            [bezier2Path addCurveToPoint: CGPointMake(20.87, 12.6) controlPoint1: CGPointMake(22.3, 5.78) controlPoint2: CGPointMake(22.71, 9.66)];
            [bezier2Path addLineToPoint: CGPointMake(14, 24)];
            [bezier2Path addLineToPoint: CGPointMake(7.13, 12.6)];
            [bezier2Path addCurveToPoint: CGPointMake(8.34, 3.25) controlPoint1: CGPointMake(5.29, 9.66) controlPoint2: CGPointMake(5.7, 5.78)];
            [bezier2Path addCurveToPoint: CGPointMake(19.66, 3.25) controlPoint1: CGPointMake(11.47, 0.25) controlPoint2: CGPointMake(16.53, 0.25)];
            [bezier2Path closePath];
            [color setFill];
            [bezier2Path fill];
            
            
            
            //// Bezier 4 Drawing
            UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
            [bezier4Path moveToPoint: CGPointMake(19.23, 3.01)];
            [bezier4Path addCurveToPoint: CGPointMake(21.48, 8.33) controlPoint1: CGPointMake(20.87, 4.47) controlPoint2: CGPointMake(21.62, 6.42)];
            [bezier4Path addCurveToPoint: CGPointMake(19.23, 3.93) controlPoint1: CGPointMake(21.36, 6.73) controlPoint2: CGPointMake(20.61, 5.16)];
            [bezier4Path addCurveToPoint: CGPointMake(8.27, 3.93) controlPoint1: CGPointMake(16.2, 1.25) controlPoint2: CGPointMake(11.3, 1.25)];
            [bezier4Path addCurveToPoint: CGPointMake(6.02, 8.33) controlPoint1: CGPointMake(6.89, 5.16) controlPoint2: CGPointMake(6.14, 6.73)];
            [bezier4Path addCurveToPoint: CGPointMake(8.27, 3.01) controlPoint1: CGPointMake(5.88, 6.42) controlPoint2: CGPointMake(6.63, 4.47)];
            [bezier4Path addCurveToPoint: CGPointMake(19.23, 3.01) controlPoint1: CGPointMake(11.3, 0.33) controlPoint2: CGPointMake(16.2, 0.33)];
            [bezier4Path closePath];
            [bezier4Path moveToPoint: CGPointMake(10.71, 8.86)];
            [bezier4Path addCurveToPoint: CGPointMake(11.56, 10.28) controlPoint1: CGPointMake(10.8, 9.34) controlPoint2: CGPointMake(11.09, 9.86)];
            [bezier4Path addCurveToPoint: CGPointMake(15.94, 10.28) controlPoint1: CGPointMake(12.77, 11.35) controlPoint2: CGPointMake(14.73, 11.35)];
            [bezier4Path addCurveToPoint: CGPointMake(16.81, 8.79) controlPoint1: CGPointMake(16.42, 9.86) controlPoint2: CGPointMake(16.7, 9.34)];
            [bezier4Path addCurveToPoint: CGPointMake(15.94, 11.19) controlPoint1: CGPointMake(16.97, 9.64) controlPoint2: CGPointMake(16.68, 10.54)];
            [bezier4Path addCurveToPoint: CGPointMake(11.56, 11.19) controlPoint1: CGPointMake(14.73, 12.27) controlPoint2: CGPointMake(12.77, 12.27)];
            [bezier4Path addCurveToPoint: CGPointMake(10.69, 8.79) controlPoint1: CGPointMake(10.82, 10.54) controlPoint2: CGPointMake(10.53, 9.64)];
            [bezier4Path addLineToPoint: CGPointMake(10.71, 8.86)];
            [bezier4Path closePath];
            [color3 setFill];
            [bezier4Path fill];
            
            
            
            //// Bezier Drawing
            UIBezierPath* bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint: CGPointMake(11.56, 7.01)];
            [bezierPath addCurveToPoint: CGPointMake(11.56, 11.35) controlPoint1: CGPointMake(10.35, 8.21) controlPoint2: CGPointMake(10.35, 10.15)];
            [bezierPath addCurveToPoint: CGPointMake(15.94, 11.35) controlPoint1: CGPointMake(12.77, 12.54) controlPoint2: CGPointMake(14.73, 12.54)];
            [bezierPath addCurveToPoint: CGPointMake(15.94, 7.01) controlPoint1: CGPointMake(17.15, 10.15) controlPoint2: CGPointMake(17.15, 8.21)];
            [bezierPath addCurveToPoint: CGPointMake(11.56, 7.01) controlPoint1: CGPointMake(14.73, 5.81) controlPoint2: CGPointMake(12.77, 5.81)];
            [bezierPath closePath];
            [bezierPath moveToPoint: CGPointMake(19.23, 3.25)];
            [bezierPath addCurveToPoint: CGPointMake(20.4, 12.6) controlPoint1: CGPointMake(21.79, 5.78) controlPoint2: CGPointMake(22.19, 9.66)];
            [bezierPath addLineToPoint: CGPointMake(13.75, 24)];
            [bezierPath addLineToPoint: CGPointMake(7.1, 12.6)];
            [bezierPath addCurveToPoint: CGPointMake(8.27, 3.25) controlPoint1: CGPointMake(5.31, 9.66) controlPoint2: CGPointMake(5.71, 5.78)];
            [bezierPath addCurveToPoint: CGPointMake(19.23, 3.25) controlPoint1: CGPointMake(11.3, 0.25) controlPoint2: CGPointMake(16.2, 0.25)];
            [bezierPath closePath];
            [color2 setStroke];
            bezierPath.lineWidth = 0.5;
            [bezierPath stroke];
        }
            break;
    default:
        break;
    }
}

+ (CGSize) sizeForFigureType:(FigureRendererType)figureRendererType
{
    CGSize size = CGSizeZero;
    switch (figureRendererType) {
    case FigureRendererTypeCustomPin:
        size =  CGSizeMake(30.0f,52.0f);
        break;
    case FigureRendererTypePlaceIcon:
        size =  CGSizeMake(30.0f,26.0f);
        break;
    default:
        break;
    }
    return size;
}

+ (NSString*) keyNameWithFigureType:(FigureRendererType)figureRendererType
{
    NSString* keyName = nil;
    switch (figureRendererType) {
    case FigureRendererTypeCustomPin:
        keyName = @"FigureRendererTypeCustomPin";
        break;
    case FigureRendererTypePlaceIcon:
        keyName = @"FigureRendererTypePlaceIcon";
        break;
    default:
        break;
    }
    return keyName;
}

+ (UIImage*) createImageWithFigureType:(FigureRendererType)figureRendererType
{
    CGSize sizeImage = [FigureRenderer sizeForFigureType:figureRendererType ];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(sizeImage.width ,sizeImage.height ) , NO , [UIScreen mainScreen].scale );
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    
    [FigureRenderer renderWithFigureType:figureRendererType];
    
    CGContextRestoreGState(context);
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();        
    
    return image;
}

//+ (CCSprite*) createSpriteWithFigureType:(FigureRendererType)figureRendererType
//{
//    CCSprite* sprite = nil;
//    
//    // タイトル画面の作成
//    NSAutoreleasePool* autoreleasePool = [[NSAutoreleasePool alloc] init];
//    {
//        UIImage* image = [self createImageWithFigureType:figureRendererType];
//        sprite = [[CCSprite alloc] initWithCGImage:[image CGImage] key:[FigureRenderer keyNameWithFigureType:figureRendererType] ];
//    }
//    [autoreleasePool release];    
//    
//    return [sprite autorelease]/*autoreleasePool を抜けてからautorelease 指定を行う*/;
//}

//+ (CCSpriteBatchNode*) createBatchNodeWithFigureType:(FigureRendererType)figureRendererType
//{
//    CCSpriteBatchNode* batchNode = nil;
//    
//    // タイトル画面の作成
//    NSAutoreleasePool* autoreleasePool = [[NSAutoreleasePool alloc] init];
//    {
//        CGSize sizeImage = [FigureRenderer sizeForFigureType:figureRendererType ];
//        
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(sizeImage.width ,sizeImage.height ) , NO , [UIScreen mainScreen].scale );
//        
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSaveGState(context);
//        
//        
//        [FigureRenderer renderWithFigureType:figureRendererType];
//        
//        CGContextRestoreGState(context);
//        
//        UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
//        CCTexture2D* texture2d = [[[CCTexture2D alloc] initWithImage:image] autorelease];
//        batchNode = [[CCSpriteBatchNode alloc] initWithTexture:texture2d capacity:29/*defaultCapacity*/ ];
//        
//        UIGraphicsEndImageContext();        
//    }
//    [autoreleasePool release];    
//    
//    return [batchNode autorelease]/*autoreleasePool を抜けてからautorelease 指定を行う*/;
//}



@end
