//
//  ibModel.m
//  ib3D
//
//  Created by Billy Connolly on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ibModel.h"

GLfloat gCVD[216] = 
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

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@implementation ibModel
@synthesize material;

- (id)initWithFile:(NSString *)modF withMaterialProperties:(ibMaterialProperties *)properties{
    self = [super init];
    if(self){
        NSString *path = [[NSBundle mainBundle] pathForResource:modF ofType:@"ply"];
        if(path){
            NSString *data = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            if(data){
                self.material = [[ibMaterial alloc] initWithMaterialProperties: properties];
                [properties release];
                
                [self loadPly: data];
                [self setupVBO];
            }else{
                NSLog(@"Error loading data for %@.ply", modF);
            }
            
        }else{
            NSLog(@"Error creating %@.ply file path.", modF);
        }
    }
    return self;
}

- (void)loadPly:(NSString *)data{
    NSArray *lines = [data componentsSeparatedByString:@"\n"];
    numVertices = [[lines objectAtIndex: 0] intValue];
    numIndices = [[lines objectAtIndex: 1] intValue];
    
    GLfloat *vertexData = malloc(numVertices*8*sizeof(GLfloat));
    GLuint *indexData = malloc(numIndices*3*sizeof(GLuint));
    memset(vertexData, 0, numVertices*8*sizeof(GLfloat));
    memset(indexData, 0, numIndices*3*sizeof(GLubyte));
    
    for(int x = 0; x < numVertices; x++){
        NSString *line = [lines objectAtIndex: x + 2];
        NSArray *vertexStrings = [line componentsSeparatedByString:@" "];
        if([vertexStrings count] != 8 && [vertexStrings count] != 6){
            NSLog(@"Vertex count not equal to 6 or 8, exiting.");
            exit(0);
        }
        for(int y = 0; y < [vertexStrings count]; y++){
            float currentValue = [[vertexStrings objectAtIndex: y] floatValue];
            vertexData[(x*8)+y] = currentValue;
        }
    }
    
    for(int x = 0; x < numIndices; x++){
        NSString *line = [[lines objectAtIndex: numVertices+2+x] substringFromIndex:2];
        NSArray *indexStrings = [line componentsSeparatedByString:@" "];
        if([indexStrings count] != 3){
            NSLog(@"Index count not equal to three, exiting.");
            exit(0);
        }
        for(int y = 0; y < [indexStrings count]; y++){
            GLuint currentValue = (GLuint)[[indexStrings objectAtIndex: y] intValue];
            indexData[(x*3)+y] = currentValue;
        }
    }
    
    vdata = vertexData;
    indices = indexData;
}

- (void)setupVBO{
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    //glBufferData(GL_ARRAY_BUFFER, sizeof(gCVD), gCVD, GL_STATIC_DRAW);
    
    glBufferData(GL_ARRAY_BUFFER, numVertices*8*sizeof(GLfloat), vdata, GL_STATIC_DRAW);
        
    glEnableVertexAttribArray([[material shader] locationForAttrib:"a_position"]);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(0));
    
    glEnableVertexAttribArray([[material shader] locationForAttrib:"a_normal"]);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(12));
    
    if([material type] == IBMATERIAL_BASE){
        glEnableVertexAttribArray([[material shader] locationForAttrib:"a_texCoord"]);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(24));
    }
        
    glBindVertexArrayOES(0);
    
    uniformMVPLocation = [[material shader] locationForUniform:"u_modelViewProjectionMatrix"];
    uniformNMLocation = [[material shader] locationForUniform:"u_normalMatrix"];
    
    /*for(int x = 0; x < numVertices; x++){
        NSLog(@"V:%f %f %f N:%f %f %f", vdata[(x*8)],vdata[(x*8)+1],vdata[(x*8)+2],vdata[(x*8)+3],vdata[(x*8)+4],vdata[(x*8)+5]);
    }
    
    NSLog(@"\n\n\n");
    
    for(int x = 0; x < numIndices; x++){
        GLuint f,s,t;
        f = indices[(x*3)];
        s = indices[(x*3)+1];
        t = indices[(x*3)+2];
        NSLog(@"I: %i %i %i", indices[(x*3)], indices[(x*3)+1], indices[(x*3)+2]);
    }*/
}

- (void)draw:(GLKMatrix4)viewProjectionMatrix{    
    if([material type] == IBMATERIAL_BASE){
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, [material texture].name);
    }
    
    GLKMatrix4 modelMatrix = GLKMatrix4MakeTranslation(position.x, position.y, position.z);
    modelMatrix = GLKMatrix4ScaleWithVector3(modelMatrix, scale);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, rotation.x, 1.0f, 1.0f, 1.0f);
    
    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(viewProjectionMatrix, modelMatrix);
    GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelMatrix), NULL);
    
    [[material shader] use];
    glBindVertexArrayOES(_vertexArray);
    
    glUniformMatrix4fv(uniformMVPLocation, 1, 0, modelViewProjectionMatrix.m);
    glUniformMatrix3fv(uniformNMLocation, 1, 0, normalMatrix.m);
    
    if([material type] == IBMATERIAL_BASE)
        glUniform1i([[material shader] locationForUniform:"s_texture"], 0);
    
    glDrawElements(GL_TRIANGLES, numIndices*3, GL_UNSIGNED_INT, indices);
    [super draw:viewProjectionMatrix];
}

- (void)update:(NSTimeInterval)deltaTime{
    [super update:deltaTime];
}

- (void)cleanup{
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
}

@end
