//
//  BezierView.m
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/18/11.
//  Copyright 2011 culturezoo. All rights reserved.
//

#import "BezierView.h"

@implementation BezierView
@dynamic curvePath;

- (UIBezierPath *)curvePath {
    return [[curvePath retain] autorelease];
}
- (void)setCurvePath:(UIBezierPath *)newPath {
    id tmp = curvePath;
    curvePath = [newPath retain];
    [tmp release];
    state = BezierStateNone;
    [self setNeedsDisplay];
}
- (void)_updateCurve {
    UIBezierPath *path = [self curvePath];
    [path moveToPoint:startPt];
    [path addCurveToPoint:endPt controlPoint1:cPt1 controlPoint2:cPt2];
}
- (void)_calcDefaultControls {
    if(ABS(startPt.x - endPt.x) > ABS(startPt.y - endPt.y)) {
        cPt1 = (CGPoint){(startPt.x + endPt.x) / 2, startPt.y};
        cPt2 = (CGPoint){cPt1.x, endPt.y};
    } else {
        cPt1 = (CGPoint){startPt.x, (startPt.y + endPt.y) / 2};
        cPt2 = (CGPoint){endPt.x, cPt1.y};
    }
}
- (void)drawRect:(CGRect)rect {
    [[UIColor blackColor] set];
    UIBezierPath *path = self.curvePath;
    path.lineWidth = 5.0;
    if(path) [path stroke];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"And we goi!");
    if(currentTouch) return;
    NSLog(@"Onward!");
    if(state == BezierStateNone) {
        state = BezierStateDefiningLine;
        currentTouch = [touches anyObject];
        startPt = [currentTouch locationInView:self];
    } else if(state == BezierStateDefiningCP1) {
        currentTouch = [touches anyObject];
        cPt1 = [currentTouch locationInView:self];
        [self _updateCurve];
    } else if(state == BezierStateDefiningCP2) {
        currentTouch = [touches anyObject];
        cPt2 = [currentTouch locationInView:self];
        [self _updateCurve];
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!currentTouch) return;
    if(state == BezierStateDefiningLine) {
        endPt = [currentTouch locationInView:self];
        [self _calcDefaultControls];
        [self _updateCurve];
    } else if(state == BezierStateDefiningCP1) {
        cPt1 = [currentTouch locationInView:self];
        [self _updateCurve];
    } else if(state == BezierStateDefiningCP2) {
        cPt2 = [currentTouch locationInView:self];
        [self _updateCurve];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!currentTouch) return;
    if(state == BezierStateDefiningLine) {
        state = BezierStateDefiningCP1;
    } else if(state == BezierStateDefiningCP1) {
        state = BezierStateDefiningCP2;
    } else if(state == BezierStateDefiningCP2) {
        state = BezierStateNone;
    }
    currentTouch = nil;
}
- (void)touchesCanceled:(NSSet *)touches withEvent:(UIEvent *)event {
    if(state == BezierStateDefiningLine) {
        self.curvePath = nil;
        state = BezierStateNone;
    }
    currentTouch = nil;
}
@end