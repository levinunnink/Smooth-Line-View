//  The MIT License (MIT)
//
//  Copyright (c) 2013 Levi Nunnink
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//
//  Created by Levi Nunnink (@a_band) http://culturezoo.com
//  Copyright (C) Droplr Inc. All Rights Reserved
//

#import "SmoothLineView.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_COLOR               [UIColor blackColor]
#define DEFAULT_WIDTH               5.0f
#define DEFAULT_BACKGROUND_COLOR    [UIColor whiteColor]

static const CGFloat kPointMinDistance = 5.0f;
static const CGFloat kPointMinDistanceSquared = kPointMinDistance * kPointMinDistance;

@interface SmoothLineView ()
@property (nonatomic,assign) CGPoint currentPoint;
@property (nonatomic,assign) CGPoint previousPoint;
@property (nonatomic,assign) CGPoint previousPreviousPoint;

#pragma mark Private Helper function
CGPoint midPoint(CGPoint p1, CGPoint p2);
@end

@implementation SmoothLineView {
@private
	CGMutablePathRef _path;
}

#pragma mark UIView lifecycle methods

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  
  if (self) {
    // NOTE: do not change the backgroundColor here, so it can be set in IB.
		_path = CGPathCreateMutable();
    _lineWidth = DEFAULT_WIDTH;
    _lineColor = DEFAULT_COLOR;
    _empty = YES;
  }
  
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  
  if (self) {
    self.backgroundColor = DEFAULT_BACKGROUND_COLOR;
		_path = CGPathCreateMutable();
    _lineWidth = DEFAULT_WIDTH;
    _lineColor = DEFAULT_COLOR;
    _empty = YES;
  }
  
  return self;
}

- (void)drawRect:(CGRect)rect {
  // clear rect
  [self.backgroundColor set];
  UIRectFill(rect);
  
  // get the graphics context and draw the path
  CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextAddPath(context, _path);
  CGContextSetLineCap(context, kCGLineCapRound);
  CGContextSetLineWidth(context, self.lineWidth);
  CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
  
  CGContextStrokePath(context);
  
  self.empty = NO;
}

-(void)dealloc {
	CGPathRelease(_path);
}

#pragma mark private Helper function

CGPoint midPoint(CGPoint p1, CGPoint p2) {
  return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

#pragma mark Touch event handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];

  // initializes our point records to current location
  self.previousPoint = [touch previousLocationInView:self];
  self.previousPreviousPoint = [touch previousLocationInView:self];
  self.currentPoint = [touch locationInView:self];

  // call touchesMoved:withEvent:, to possibly draw on zero movement
  [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
	
	CGPoint point = [touch locationInView:self];
	
	// if the finger has moved less than the min dist ...
  CGFloat dx = point.x - self.currentPoint.x;
  CGFloat dy = point.y - self.currentPoint.y;
	
  if ((dx * dx + dy * dy) < kPointMinDistanceSquared) {
    // ... then ignore this movement
    return;
  }
  
  // update points: previousPrevious -> mid1 -> previous -> mid2 -> current
  self.previousPreviousPoint = self.previousPoint;
  self.previousPoint = [touch previousLocationInView:self];
  self.currentPoint = [touch locationInView:self];
  
  CGPoint mid1 = midPoint(self.previousPoint, self.previousPreviousPoint);
  CGPoint mid2 = midPoint(self.currentPoint, self.previousPoint);

  // to represent the finger movement, create a new path segment,
  // a quadratic bezier path from mid1 to mid2, using previous as a control point
  CGMutablePathRef subpath = CGPathCreateMutable();
  CGPathMoveToPoint(subpath, NULL, mid1.x, mid1.y);
  CGPathAddQuadCurveToPoint(subpath, NULL,
                            self.previousPoint.x, self.previousPoint.y,
                            mid2.x, mid2.y);
  
  // compute the rect containing the new segment plus padding for drawn line
  CGRect bounds = CGPathGetBoundingBox(subpath);
  CGRect drawBox = CGRectInset(bounds, -2.0 * self.lineWidth, -2.0 * self.lineWidth);
  
  // append the quad curve to the accumulated path so far.
	CGPathAddPath(_path, NULL, subpath);
	CGPathRelease(subpath);

  [self setNeedsDisplayInRect:drawBox];
}

#pragma mark interface

-(void)clear {
  CGMutablePathRef oldPath = _path;
  CFRelease(oldPath);
  _path = CGPathCreateMutable();
  [self setNeedsDisplay];
}

@end

