//
//  ibObject.m
//  ib3D
//
//  Created by Billy Connolly on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ibObject.h"

@implementation ibObject
@synthesize parent;
@synthesize children;
@synthesize position;
@synthesize rotation;
@synthesize scale;
@synthesize hidden;

- (id)init{
    self = [super init];
    if(self){
        self.parent = nil;
        self.children = [[NSMutableArray alloc] init];
        
        self.position = GLKVector3Make(0, 0, 0);
        self.rotation = GLKVector3Make(0, 0, 0);
        self.scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
        self.hidden = NO;
    }
    return self;
}

- (void)addChild:(ibObject *)child{
    [child setParent: self];
    [children addObject: child];
}

- (void)draw:(GLKMatrix4)viewProjectionMatrix{
    for(ibObject *object in self.children){
        if(![object hidden])
            [object draw:viewProjectionMatrix];
    }
}

- (void)update:(NSTimeInterval)deltaTime{
    for(ibObject *object in self.children){
        [object update:deltaTime];
    }
}

@end
