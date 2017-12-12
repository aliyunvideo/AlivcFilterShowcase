//
//  GPUImageFiveInputFilter.h
//  AlivcFilterShowcase
//
//  Created by Worthy on 2017/12/12.
//  Copyright © 2017年 worthyzhang. All rights reserved.
//

#import "GPUImageFourInputFilter.h"

extern NSString *const kGPUImageFiveInputTextureVertexShaderString;

@interface GPUImageFiveInputFilter : GPUImageFourInputFilter
{
    GPUImageFramebuffer *fifthInputFramebuffer;
    
    GLint filterFifthTextureCoordinateAttribute;
    GLint filterInputTextureUniform5;
    GPUImageRotationMode inputRotation5;
    GLuint filterSourceTexture5;
    CMTime fifthFrameTime;
    
    BOOL hasSetFourthTexture, hasReceivedFifthFrame, fifthFrameWasVideo;
    BOOL fifthFrameCheckDisabled;
}

- (void)disableFifthFrameCheck;

@end
