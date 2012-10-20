//
//  ViewController.h
//  ib3D
//
//  Created by Billy Connolly on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "ibEngine.h"

@interface ViewController : GLKViewController{
    ibEngine *engine;
    CGPoint lastTouch;
}

@property (strong, nonatomic) EAGLContext *context;
@property (nonatomic, retain) ibEngine *engine;

@end
