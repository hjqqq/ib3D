//
//  ibModel.h
//  ib3D
//
//  Created by Billy Connolly on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ibObject.h"
#import <GLKit/GLKit.h>
#import "ibMaterial.h"
#import "ibMaterialProperties.h"

@interface ibModel : ibObject{
    GLfloat *vdata;
    GLuint *indices;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    
    GLuint numVertices;
    GLuint numIndices;
    
    GLuint uniformMVPLocation;
    GLuint uniformNMLocation;
    
    ibMaterial *material;
}

@property (nonatomic, retain) ibMaterial *material;

- (id)initWithFile:(NSString *)modF withMaterialProperties:(ibMaterialProperties *)properties;
- (void)loadPly:(NSString *)data;
- (void)setupVBO;
- (void)cleanup;

@end
