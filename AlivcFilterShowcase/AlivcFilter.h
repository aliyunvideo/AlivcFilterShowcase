//
//  AlivcFilter.h
//  AlivcFilterShowcase
//
//  Created by Worthy on 2017/12/5.
//  Copyright © 2017年 worthyzhang. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@interface AlivcFilter : NSObject
@property (nonatomic, strong) GPUImageFilter *filter;
- (instancetype)initWithConfigPath:(NSString *)path;
- (void)process;
-(void)remove;
- (void)addTarget:(id<GPUImageInput>)newTarget;
@end
