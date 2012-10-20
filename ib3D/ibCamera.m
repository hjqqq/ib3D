//
//  ibCamera.m
//  ib3D
//
//  Created by Billy Connolly on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ibCamera.h"

@implementation ibCamera
@synthesize viewProjectionMatrix;
@synthesize lookAt;
@synthesize up;
@synthesize ratio;
@synthesize fov;
@synthesize near;
@synthesize far;

- (id)initWithPosition:(GLKVector3)p lookAt:(GLKVector3)la ratio:(GLfloat)ra{
    self = [self initWithPosition:p lookAt:la fov:50.0f ratio:ra];
    return self;
}

- (id)initWithPosition:(GLKVector3)p lookAt:(GLKVector3)la fov:(GLfloat)f ratio:(GLfloat)ra{
    self = [super init];
    if(self){
        up.x = 0.0f;
        up.y = 1.0f;
        up.z = 0.0f;
        
        position.x = p.x;
        position.y = p.y;
        position.z = p.z;
        
        lookAt.x = la.x;
        lookAt.y = la.y;
        lookAt.z = la.z;
        
        self.ratio = ra;
        fov = f;
        near = 0.01f;
        far = 100.0f;
        
        [self rebuildMatrix];
    }
    return self;
}


- (void)rebuildMatrix{
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(fov), ratio, near, far);
    GLKMatrix4 lookAtMatrix = GLKMatrix4MakeLookAt(position.x, position.y, position.z, lookAt.x, lookAt.y, lookAt.z, up.x, up.y, up.z);
    viewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, lookAtMatrix);
}

- (void)setLookAt:(GLKVector3)la{
    lookAt.x = la.x;
    lookAt.y = la.y;
    lookAt.z = la.z;
    
    [self rebuildMatrix];
}

- (void)setPosition:(GLKVector3)p{
    position.x = p.x;
    position.y = p.y;
    position.z = p.z;
    
    [self rebuildMatrix];
}

- (void)setUp:(GLKVector3)u{
    up.x = u.x;
    up.y = u.y;
    up.z = u.z;
    
    [self rebuildMatrix];
}

- (void)setFov:(GLfloat)f{
    fov = f;
    [self rebuildMatrix];
}

- (void)setNear:(GLfloat)n{
    near = n;
    [self rebuildMatrix];
}

- (void)setFar:(GLfloat)f{
    far = f;
    [self rebuildMatrix];
}

@end
