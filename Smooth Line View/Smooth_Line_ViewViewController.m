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


#import "Smooth_Line_ViewViewController.h"

#import <CoreMotion/CoreMotion.h>

@interface Smooth_Line_ViewViewController ()
@property (strong, nonatomic) IBOutlet UIView *canvasView;
@property (nonatomic) SmoothLineView * canvas;
@end

@implementation Smooth_Line_ViewViewController

- (void)viewDidLoad
{
    
    SmoothLineView * smoothLineView = [[SmoothLineView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                       self.view.frame.size.width,
                                                                                    self.view.frame.size.height)];
    self.canvas = smoothLineView;
    [self.canvasView addSubview:smoothLineView];
    
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}
- (IBAction)buttonDown:(id)sender {
    
    [self.canvas clear];
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [self.canvas clear];
}

- (IBAction)savePressed:(id)sender {
    
    [self.canvas savePath];
    
    
}

- (IBAction)loadPressed:(id)sender {
    
    [self.canvas loadPath];
    
}


@end


