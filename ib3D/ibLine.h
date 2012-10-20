//
//  ibLine.h
//  ib3D
//
//  Created by Billy Connolly on 10/19/12.
//
//

#import "ibObject.h"
#import "ibMaterial.h"

@interface ibLine : ibObject{
    GLfloat *vdata;
        
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    
    GLuint uniformMVPLocation;
        
    ibMaterial *material;
}

- (id)initWithStart:(GLKVector3)s end:(GLKVector3)e color:(GLKVector3)c;

@property (nonatomic, retain) ibMaterial *material;

@end
