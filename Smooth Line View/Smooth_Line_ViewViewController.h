//
//  Smooth_Line_ViewViewController.h
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/10/11.
//  Copyright 2011 culturezoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Smooth_Line_ViewViewController : UIViewController {
    @private
    CGPoint lastPoint;
	BOOL mouseSwiped;	
	int mouseMoved;
    UIImageView *imageView;
    NSMutableArray *pointsArray;
}
@property (nonatomic,retain) UIImageView *imageView;
-(IBAction)toggleDrawMethod:(id)sender;
-(IBAction)clear:(id)sender;
@end
