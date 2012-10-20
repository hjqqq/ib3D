//
//  ibEngine.m
//  ib3D
//
//  Created by Billy Connolly on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ibEngine.h"
#import "ibTextureManager.h"

@implementation ibEngine
@synthesize mainCamera;
@synthesize currentScene;

- (id)initWithViewSize:(CGSize)size{
    self = [super init];
    if(self){
        self.currentScene = nil;
        
        glEnable(GL_DEPTH_TEST);
        glEnable(GL_CULL_FACE);
        glFrontFace(GL_CCW);
        glCullFace(GL_BACK);
        self.mainCamera = [[ibCamera alloc] initWithPosition:GLKVector3Make(0.0f, 3.0f, 5.0f) lookAt:GLKVector3Make(0, 0, 0) ratio:size.width / size.height];
    }
    return self;
}

- (void)cleanupGL{
    
}

- (void)runWithScene:(ibScene *)startScene{
    self.currentScene = startScene;
    [startScene setParent: self];
}

- (void)draw{
    GLKMatrix4 viewProjectMatrix = [mainCamera viewProjectionMatrix];
    if(currentScene != nil)
        [currentScene draw:viewProjectMatrix];
}

- (void)update:(NSTimeInterval)deltaTime{
    if(currentScene != nil)
        [currentScene update:deltaTime];
}

@end

/*GLfloat gCubeVertexData[216] = 
 {
 // Data layout for each line below is:
 // positionX, positionY, positionZ,     normalX, normalY, normalZ,
 0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f,
 0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,
 0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
 0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
 0.5f, 0.5f, 0.5f,          1.0f, 0.0f, 0.0f,
 0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,
 
 0.5f, 0.5f, -0.5f,         0.0f, 1.0f, 0.0f,
 -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
 0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
 0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
 -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
 -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,
 
 -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,
 -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
 -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
 -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
 -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
 -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,
 
 -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,
 0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
 -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
 -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
 0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
 0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,
 
 0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,
 -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
 0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
 0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
 -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
 -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,
 
 0.5f, -0.5f, -0.5f,        0.0f, 0.0f, -1.0f,
 -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
 0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
 0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
 -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
 -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f
 };
 
 GLfloat gSquareVertexData[] = {
 0.5f, 0.5f, 0.0f,           0.0f, 0.0f, 1.0f,    1.0f, 1.0f,
 -0.5f, 0.5f, -.5f,          0.0f, 0.0f, 1.0f,    0.0f, 1.0f,
 -0.5f, -0.5f, 0.0f,         0.0f, 0.0f, 1.0f,    0.0f, 0.0f,
 
 -0.5f, -0.5f, 0.0f,         0.0f, 0.0f, 1.0f,    0.0f, 0.0f,
 0.5f, -0.5f, -.5f,          0.0f, 0.0f, 1.0f,    1.0f, 0.0f,
 0.5f, 0.5f, 0.0f,           0.0f, 0.0f, 1.0f,    1.0f, 1.0f
 
 };*/