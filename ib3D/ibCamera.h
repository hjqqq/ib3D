//
//  ibCamera.h
//  ib3D
//
//  Created by Billy Connolly on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ibObject.h"
#import <GLKit/GLKit.h>

@interface ibCamera : ibObject{
    GLKVector3 lookAt;
    GLKVector3 up;

    GLKMatrix4 viewProjectionMatrix;
    
    GLfloat ratio;
    GLfloat fov;
    GLfloat near;
    GLfloat far;
}

@property (readonly) GLKMatrix4 viewProjectionMatrix;
@property (nonatomic) GLKVector3 lookAt;
@property (nonatomic) GLKVector3 up;
@property (nonatomic) GLfloat ratio;
@property (nonatomic) GLfloat fov;
@property (nonatomic) GLfloat near;
@property (nonatomic) GLfloat far;

- (id)initWithPosition:(GLKVector3)p lookAt:(GLKVector3)la ratio:(GLfloat)ra;
- (id)initWithPosition:(GLKVector3)p lookAt:(GLKVector3)la fov:(GLfloat)f ratio:(GLfloat)ra;

- (void)rebuildMatrix;

@end
