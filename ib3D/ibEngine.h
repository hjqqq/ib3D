//
//  ibEngine.h
//  ib3D
//
//  Created by Billy Connolly on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ibObject.h"
#import "ibShader.h"
#import "ibCamera.h"
#import "ibModel.h"
#import "ibTerrain.h"
#import "ibLine.h"
#import "ibScene.h"

@interface ibEngine : ibObject{
    ibCamera *mainCamera;
    ibScene *currentScene;
}

@property (nonatomic, retain) ibCamera *mainCamera;
@property (nonatomic, retain) ibScene *currentScene;

- (id)initWithViewSize:(CGSize)size;
- (void)cleanupGL;

- (void)draw;
- (void)update:(NSTimeInterval)deltaTime;

- (void)runWithScene:(ibScene *)startScene;

@end
