//
//  Smooth_Line_ViewViewController.m
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/10/11.
//  Copyright 2011 culturezoo. All rights reserved.
//

#import "Smooth_Line_ViewViewController.h"

@implementation Smooth_Line_ViewViewController

- (void)viewDidLoad
{
    [self.view addSubview:[[[SmoothLineView alloc] initWithFrame:self.view.bounds] autorelease]];
}

@end


