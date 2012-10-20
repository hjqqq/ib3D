//
//  ViewController.m
//  ib3D
//
//  Created by Billy Connolly on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "StartScene.h"

@implementation ViewController

@synthesize context = _context;
@synthesize engine;

- (void)dealloc{
    [_context release];
    [engine release];
    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.context = [[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2] autorelease];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    lastTouch = CGPointMake(-1, -1);
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.drawableMultisample = GLKViewDrawableMultisample4X;
    self.preferredFramesPerSecond = 60;
    
    [EAGLContext setCurrentContext:self.context];
    
    NSLog(@"Sc bo: %f %f", [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    self.engine = [[ibEngine alloc] initWithViewSize:CGSizeMake([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)];
    StartScene *ss = [[StartScene alloc] init];
    [engine runWithScene: ss];
}

- (void)viewDidUnload{    
    [super viewDidUnload];
    
    [EAGLContext setCurrentContext:self.context];
    [engine cleanupGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    } else {
        return YES;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint touch = [[touches anyObject] locationInView: self.view];
    if(lastTouch.y != -1){
        GLfloat dx = touch.y - lastTouch.y;
        
        StartScene *ss = (StartScene *)[engine currentScene];
        ss.zoom += dx / 16.0f;
        lastTouch = touch;
    }else{
        lastTouch = touch;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    lastTouch = CGPointMake(-1, -1);
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update{
    [engine update:self.timeSinceLastUpdate];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [engine draw];
}

@end

