//
//  Smooth_Line_ViewAppDelegate.h
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/10/11.
//  Copyright 2011 culturezoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Smooth_Line_ViewViewController;

@interface Smooth_Line_ViewAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet Smooth_Line_ViewViewController *viewController;

@end
