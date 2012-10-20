//
//  ibTerrain.h
//  ib3D
//
//  Created by Billy Connolly on 10/16/12.
//
//

#import "ibObject.h"
#import "ibMaterial.h"

@interface ibTerrain : ibObject{
    GLuint size;
    GLuint imgSize;
    GLfloat height;
    
    GLfloat *vdata;
    GLuint *indices;
    
    GLfloat *heights;
    GLKVector3 *normals;
    
    GLuint numVertices;
    GLuint numIndices;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    
    GLuint uniformMVPLocation;
    GLuint uniformNMLocation;
    
    NSString *heightMapFile;
    
    ibMaterial *material;
}

@property (nonatomic, retain) ibMaterial *material;

- (id)initWithSize:(GLuint)s height:(GLfloat)h heightMapFile:(NSString *)hmf;

- (GLfloat)getHeightAt:(GLfloat)x z:(GLfloat)z;
- (GLKVector3)getNormalAt:(GLfloat)x z:(GLfloat)z;

- (void)readHeightMap;
- (void)generateMesh;
- (void)calculateNormals;
- (void)setupVBO;
- (void)cleanup;

@end
