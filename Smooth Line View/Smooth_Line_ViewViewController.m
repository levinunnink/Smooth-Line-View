//
//  Smooth_Line_ViewViewController.m
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/10/11.
//  Copyright 2011 culturezoo. All rights reserved.
//

#import "Smooth_Line_ViewViewController.h"
#import "CatmullRomSpline.h"

@interface Smooth_Line_ViewViewController ()
-(void)drawSpline;
@property (nonatomic,retain) NSMutableArray *pointsArray;
@end

@implementation Smooth_Line_ViewViewController
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
	
	if ([touch tapCount] == 2) {
		self.imageView.image = nil;
		return;
	}
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
	
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2) {
		self.imageView.image = nil;
		return;
	}
	
	if(!mouseSwiped) {
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
	}
    [self drawSpline];
}

-(void)drawSpline {
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

@synthesize imageView;
@synthesize pointsArray;
@end
