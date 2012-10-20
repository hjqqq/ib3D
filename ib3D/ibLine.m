
//
//  ibLine.m
//  ib3D
//
//  Created by Billy Connolly on 10/19/12.
//
//

#import "ibLine.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@implementation ibLine
@synthesize material;

- (id)initWithStart:(GLKVector3)s end:(GLKVector3)e color:(GLKVector3)c{
    self = [super init];
    if(self){
        ibMaterialProperties *properties = [[ibMaterialProperties alloc] initWithMaterialType: IBMATERIAL_DEBUG];
        self.material = [[ibMaterial alloc] initWithMaterialProperties: properties];
        
        vdata = malloc(12 * sizeof(GLfloat));
        vdata[0] = s.x;vdata[1] = s.y;vdata[2] = s.z;
        vdata[3] = c.r;vdata[4] = c.g;vdata[5] = c.b;
        vdata[6] = e.x;vdata[7] = e.y;vdata[8] = e.z;
        vdata[9] = c.r;vdata[10] = c.g;vdata[11] = c.b;
        
        glGenVertexArraysOES(1, &_vertexArray);
        glBindVertexArrayOES(_vertexArray);
        
        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        
        glBufferData(GL_ARRAY_BUFFER, 16*sizeof(GLfloat), vdata, GL_STATIC_DRAW);
        
        glEnableVertexAttribArray([[material shader] locationForAttrib:"a_position"]);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
        
        glEnableVertexAttribArray([[material shader] locationForAttrib:"a_color"]);
        glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
        
        glBindVertexArrayOES(0);
        
        uniformMVPLocation = [[material shader] locationForUniform:"u_modelViewProjectionMatrix"];
        
    }
    return self;
}

- (void)draw:(GLKMatrix4)viewProjectionMatrix{
    [[material shader] use];
    glBindVertexArrayOES(_vertexArray);
    
    // Ignores position/rotation and scale stuff
    
    glUniformMatrix4fv(uniformMVPLocation, 1, 0, viewProjectionMatrix.m);
    glLineWidth(2.0f);
    
    glDrawArrays(GL_LINES, 0, 2);
    glBindVertexArrayOES(0);
    [super draw: viewProjectionMatrix];
}

@end
