//
//  Smooth_Line_ViewViewController.m
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/10/11.
//  Copyright 2011 culturezoo. All rights reserved.
//

#import "Smooth_Line_ViewViewController.h"
#import "CatmullRomSpline.h"
#include <math.h>
#include <stdio.h>

@interface Smooth_Line_ViewViewController ()
-(void)drawSpline;
-(void)drawBezier;
@property (nonatomic,retain) NSMutableArray *pointsArray;
@end

static BOOL drawBezier = NO;

@implementation Smooth_Line_ViewViewController

-(IBAction)toggleDrawMethod:(id)sender{
    NSLog(@"[sender titleForSegmentAtIndex:[sender selectedSegmentIndex]] %@",[sender titleForSegmentAtIndex:[sender selectedSegmentIndex]]);
    if([[sender titleForSegmentAtIndex:[sender selectedSegmentIndex]] isEqualToString:@"Bezier Curve"]){
        drawBezier = YES;
    }else{
        drawBezier = NO;
    }
}
-(IBAction)clear:(id)sender {
    self.imageView.image = nil;
}
- (void)viewDidLoad
{
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.pointsArray = [NSMutableArray array];
    [self.view addSubview:self.imageView];
    [super viewDidLoad];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	mouseSwiped = NO;
	UITouch *touch = [touches anyObject];
    [self.pointsArray removeAllObjects];
	lastPoint = [touch locationInView:self.view];
	//lastPoint.y -= 20;
    [self.pointsArray addObject:[NSValue valueWithCGPoint:lastPoint]];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	mouseSwiped = YES;
	
	UITouch *touch = [touches anyObject];	
	CGPoint currentPoint = [touch locationInView:self.view];
	//currentPoint.y -= 20;
	
	
	UIGraphicsBeginImageContext(self.view.frame.size);
	[self.imageView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 0.1);
	CGContextBeginPath(UIGraphicsGetCurrentContext());
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
	CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	lastPoint = currentPoint;
    
	mouseMoved++;
	
	if (mouseMoved == 10) {
		mouseMoved = 0;
	}
    [self.pointsArray addObject:[NSValue valueWithCGPoint:currentPoint]];
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 0.1);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    CGContextFlush(UIGraphicsGetCurrentContext());
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //[self drawSpline];
    //[self drawCosine];
    /*if (drawBezier) {
        [self drawBezier];
    }else{
        [self drawSpline];
    }*/
    if ([self.pointsArray count]>15) {
        [self drawBezier];
    }else{
        [self drawSpline];
    }
}

-(void)drawSpline {
    NSLog(@"Drawing Spline");
    UIGraphicsBeginImageContext(CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height));
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 8.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.557, 0.0, 0.0, 0.9);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
	
    CGPoint firstPoint = [[self.pointsArray objectAtIndex:0] CGPointValue];
    
    CatmullRomSpline *currentSpline = [CatmullRomSpline catmullRomSplineAtPoint:firstPoint];
    int i = 0;
    for(NSValue *v in self.pointsArray){
        if (i>0) {
            [currentSpline addPoint:[v CGPointValue]];
        }
        i++;
    }
    BOOL isFirst = YES;
    for (int i =0;i<[[currentSpline asPointArray] count];i++) {
		CGPoint currentPoint = [[[currentSpline asPointArray] objectAtIndex:i] CGPointValue];
		if(isFirst){
			lastPoint = [[[currentSpline asPointArray] objectAtIndex:0] CGPointValue];
		}else {
			lastPoint = [[[currentSpline asPointArray] objectAtIndex:i-1] CGPointValue];
		}
		//lastPoint.y += 50;
		//currentPoint.y += 50;
		
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
		isFirst = NO;
	}
	
    CGContextStrokePath(UIGraphicsGetCurrentContext());
	CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(),YES);
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

-(void)drawBezier {
    NSLog(@"Drawing Bezier");
    UIGraphicsBeginImageContext(CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height));
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 8.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.5, 0.0, 0.9);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
	
    int curIndex = 0;
    CGFloat x0,y0,x1,y1,x2,y2,x3,y3;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path,NULL,[[self.pointsArray objectAtIndex:0] CGPointValue].x,[[self.pointsArray objectAtIndex:0] CGPointValue].y);

    for(NSValue *v in self.pointsArray){
        
        if(curIndex >= 4){
            for (int i=curIndex;i>=curIndex-4;i--) {
                int step = (curIndex-i);
                switch (step) {
                    case 0:
                        x3 = [(NSValue*)[self.pointsArray objectAtIndex:i-1] CGPointValue].x;
                        y3 = [(NSValue*)[self.pointsArray objectAtIndex:i-1] CGPointValue].y;	
                        break;
                    case 1:
                        x2 = [(NSValue*)[self.pointsArray objectAtIndex:i-1] CGPointValue].x;
                        y2 = [(NSValue*)[self.pointsArray objectAtIndex:i-1] CGPointValue].y;						
                        break;
                    case 2:
                        x1 = [(NSValue*)[self.pointsArray objectAtIndex:i-1] CGPointValue].x;
                        y1 = [(NSValue*)[self.pointsArray objectAtIndex:i-1] CGPointValue].y;						
                        break;
                    case 3:
                        x0 = [(NSValue*)[self.pointsArray objectAtIndex:i-1] CGPointValue].x;
                        y0 = [(NSValue*)[self.pointsArray objectAtIndex:i-1] CGPointValue].y;						
                        break;	
                    default:
                        break;
                }			
            }
            
            
            double smooth_value = 0.5;
            
            double xc1 = (x0 + x1) / 2.0;
            double yc1 = (y0 + y1) / 2.0;
            double xc2 = (x1 + x2) / 2.0;
            double yc2 = (y1 + y2) / 2.0;
            double xc3 = (x2 + x3) / 2.0;
            double yc3 = (y2 + y3) / 2.0;
            
            double len1 = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0));
            double len2 = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1));
            double len3 = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2));
            
            double k1 = len1 / (len1 + len2);
            double k2 = len2 / (len2 + len3);
            
            double xm1 = xc1 + (xc2 - xc1) * k1;
            double ym1 = yc1 + (yc2 - yc1) * k1;
            
            double xm2 = xc2 + (xc3 - xc2) * k2;
            double ym2 = yc2 + (yc3 - yc2) * k2;
            
            // Resulting control points. Here smooth_value is mentioned
            // above coefficient K whose value should be in range [0...1].
            double ctrl1_x = xm1 + (xc2 - xm1) * smooth_value + x1 - xm1;
            double ctrl1_y = ym1 + (yc2 - ym1) * smooth_value + y1 - ym1;
            
            double ctrl2_x = xm2 + (xc2 - xm2) * smooth_value + x2 - xm2;
            double ctrl2_y = ym2 + (yc2 - ym2) * smooth_value + y2 - ym2;	
            
            CGPathMoveToPoint(path,NULL,x1,y1);
            CGPathAddCurveToPoint(path,NULL,ctrl1_x,ctrl1_y,ctrl2_x,ctrl2_y, x2,y2);
            CGPathAddLineToPoint(path,NULL,x2,y2);
        }
        curIndex++;
    }
	CGContextAddPath(UIGraphicsGetCurrentContext(), path);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
	CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(),YES);
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

}

@synthesize imageView;
@synthesize pointsArray;
@end


