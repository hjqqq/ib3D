//
//  StartScene.h
//  ib3D
//
//  Created by Billy Connolly on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ibScene.h"
#import "ibEngine.h"

@interface StartScene : ibScene{
    GLfloat angle;
    ibTerrain *terrain;
    
    GLfloat zoom;
}

@property GLfloat zoom;

@end
