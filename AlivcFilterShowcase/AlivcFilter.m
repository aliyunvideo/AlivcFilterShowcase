//
//  AlivcFilter.m
//  AlivcFilterShowcase
//
//  Created by Worthy on 2017/12/5.
//  Copyright © 2017年 worthyzhang. All rights reserved.
//

#import "AlivcFilter.h"
#import "GPUImageFourInputFilter.h"
#import "GPUImageFiveInputFilter.h"

@interface AlivcFilter()
@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) GPUImagePicture *pic1;
@property (nonatomic, strong) GPUImagePicture *pic2;
@property (nonatomic, strong) GPUImagePicture *pic3;
@property (nonatomic, strong) GPUImagePicture *pic4;
@end
@implementation AlivcFilter
-(instancetype)initWithConfigPath:(NSString *)path {
    self = [super init];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
    NSArray *filters = dict[@"filters"];
    _images = filters[0][@"images"];
    
    NSString *fragment = filters[0][@"fragment"];
    // 删除opengles语法
    fragment = [fragment stringByReplacingOccurrencesOfString:@"precision highp float;" withString:@""];
    fragment = [fragment stringByReplacingOccurrencesOfString:@"precision mediump float;" withString:@""];
    fragment = [fragment stringByReplacingOccurrencesOfString:@"precision lowp float;" withString:@""];

    fragment = [fragment stringByReplacingOccurrencesOfString:@"highp" withString:@""];
    fragment = [fragment stringByReplacingOccurrencesOfString:@"mediump" withString:@""];
    fragment = [fragment stringByReplacingOccurrencesOfString:@"lowp" withString:@""];
    NSString *dir = [path stringByDeletingLastPathComponent];
    
    if (_images.count == 0) {
        GPUImageFilter *filter = [[GPUImageFilter alloc] initWithFragmentShaderFromString:fragment];
        _filter = filter;
    }else if(_images.count == 1) {
        GPUImageTwoInputFilter *filter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromString:fragment];
        _filter = filter;
        _pic1 = [[GPUImagePicture alloc] initWithURL:[NSURL fileURLWithPath:[dir stringByAppendingPathComponent:_images[0]]]];
        ;
        [_pic1 addTarget:_filter atTextureLocation:1];
    }else if(_images.count == 2) {
        GPUImageThreeInputFilter *filter = [[GPUImageThreeInputFilter alloc] initWithFragmentShaderFromString:fragment];
        _filter = filter;
        _pic1 = [[GPUImagePicture alloc] initWithURL:[NSURL fileURLWithPath:[dir stringByAppendingPathComponent:_images[0]]]];
        ;
        _pic2 = [[GPUImagePicture alloc] initWithURL:[NSURL fileURLWithPath:[dir stringByAppendingPathComponent:_images[1]]]];
        ;
        [_pic1 addTarget:_filter atTextureLocation:1];
        [_pic2 addTarget:_filter atTextureLocation:2];

    }else if(_images.count == 3) {
        GPUImageFourInputFilter *filter = [[GPUImageFourInputFilter alloc] initWithFragmentShaderFromString:fragment];
        _filter = filter;
        _pic1 = [[GPUImagePicture alloc] initWithURL:[NSURL fileURLWithPath:[dir stringByAppendingPathComponent:_images[0]]]];
        ;
        _pic2 = [[GPUImagePicture alloc] initWithURL:[NSURL fileURLWithPath:[dir stringByAppendingPathComponent:_images[1]]]];
        ;
        _pic3 = [[GPUImagePicture alloc] initWithURL:[NSURL fileURLWithPath:[dir stringByAppendingPathComponent:_images[2]]]];
        ;
        [_pic1 addTarget:_filter atTextureLocation:1];
        [_pic2 addTarget:_filter atTextureLocation:2];
        [_pic3 addTarget:_filter atTextureLocation:3];
    }else if(_images.count == 4) {
        GPUImageFiveInputFilter *filter = [[GPUImageFiveInputFilter alloc] initWithFragmentShaderFromString:fragment];
        _filter = filter;
        _pic1 = [[GPUImagePicture alloc] initWithURL:[NSURL fileURLWithPath:[dir stringByAppendingPathComponent:_images[0]]]];
        ;
        _pic2 = [[GPUImagePicture alloc] initWithURL:[NSURL fileURLWithPath:[dir stringByAppendingPathComponent:_images[1]]]];
        ;
        _pic3 = [[GPUImagePicture alloc] initWithURL:[NSURL fileURLWithPath:[dir stringByAppendingPathComponent:_images[2]]]];
        ;
        _pic4 = [[GPUImagePicture alloc] initWithURL:[NSURL fileURLWithPath:[dir stringByAppendingPathComponent:_images[3]]]];
        ;
        [_pic1 addTarget:_filter atTextureLocation:1];
        [_pic2 addTarget:_filter atTextureLocation:2];
        [_pic3 addTarget:_filter atTextureLocation:3];
        [_pic4 addTarget:_filter atTextureLocation:4];   
    }
    return self;
}

-(void)process {
    [_pic1 processImage];
    [_pic2 processImage];
    [_pic3 processImage];
    [_pic4 processImage];
}

-(void)remove {
    [_pic1 removeAllTargets];
    [_pic2 removeAllTargets];
    [_pic3 removeAllTargets];
    [_pic4 removeAllTargets];
    [_filter removeAllTargets];
}

@end
