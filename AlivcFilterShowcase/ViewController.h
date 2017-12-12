//
//  ViewController.h
//  AlivcFilterShowcase
//
//  Created by Worthy on 2017/12/5.
//  Copyright © 2017年 worthyzhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <GPUImage.h>
#import "DragView.h"

@interface ViewController : NSViewController 

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet DragView *glView;
@property (weak) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak) IBOutlet NSLayoutConstraint *widthConstraint;

@end

