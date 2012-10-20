//
//  StartScene.m
//  ib3D
//
//  Created by Billy Connolly on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StartScene.h"
#import "ibCamera.h"
#import "ibEngine.h"
#import "ibMaterialProperties.h"

@implementation StartScene
@synthesize zoom;

- (id)init{
    self = [super init];
    if(self){
        ibMaterialProperties *props = [[ibMaterialProperties alloc] initWithMaterialType:IBMATERIAL_BASE];
        [props setTexture1: @"SphereMap.png"];
        //ball3 = [[ibModel alloc] initWithFile:@"Ball3" withMaterialProperties:props];
        //[self addChild: ball3];
        
        angle = 0.0f;
        zoom = 5.0f;

        terrain = [[ibTerrain alloc] initWithSize:257 height:100 heightMapFile:@"terrain257.png"];
        [terrain setScale:GLKVector3Make(0.5 / (257 / 9), 0.5 / (257 / 9), 0.5 / (257 / 9))];
        [self addChild: terrain];
    }
    return self;
}

- (void)update:(NSTimeInterval)deltaTime{
    angle += .5f * deltaTime;
    //[terrain setRotation: GLKVector3Add([terrain rotation], GLKVector3Make(0, .5*deltaTime, 0))];
    ibEngine *engine = (ibEngine *)[self parent];
    [[engine mainCamera] setPosition: GLKVector3Make(zoom * cosf(angle), 3.0f, zoom * sinf(angle))];
    [super update: deltaTime];
}

@end
