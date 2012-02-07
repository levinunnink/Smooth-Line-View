#import <UIKit/UIKit.h>

enum {
    BezierStateNone = 0,
    BezierStateDefiningLine,
    BezierStateDefiningCP1,
    BezierStateDefiningCP2
};
@interface BezierView : UIView {
    CGPoint startPt, endPt, cPt1, cPt2;
    UInt8 state;
    UIBezierPath *curvePath;
@private
    UITouch *currentTouch;
}
@property (nonatomic, retain) UIBezierPath *curvePath;
@end
