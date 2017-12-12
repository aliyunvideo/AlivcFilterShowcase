//
//  DragView.h
//  AlivcFilterShowcase
//
//  Created by Worthy on 2017/12/12.
//  Copyright © 2017年 worthyzhang. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@protocol DragViewDelegate
- (void)didDragFile:(NSString *)path;
@end

@interface DragView : GPUImageView
@property (nonatomic, weak) id<DragViewDelegate> delegate;
@end
