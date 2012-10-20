//
//  ibObject.h
//  ib3D
//
//  Created by Billy Connolly on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface ibObject : NSObject{
    GLKVector3 position;
    GLKVector3 rotation;
    GLKVector3 scale;
    
    BOOL hidden;
    
    ibObject *parent;
    NSMutableArray *children;
}

@property (nonatomic, retain) ibObject *parent;
@property (nonatomic, retain) NSMutableArray *children;
@property GLKVector3 position;
@property GLKVector3 rotation;
@property GLKVector3 scale;
@property BOOL hidden;

- (id)init;
- (void)addChild:(ibObject *)child;

- (void)draw:(GLKMatrix4)viewProjectionMatrix;
- (void)update:(NSTimeInterval)deltaTime;

@end
