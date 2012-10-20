//
//  ibTerrain.m
//  ib3D
//
//  Created by Billy Connolly on 10/16/12.
//
//

#import "ibTerrain.h"
#import "ibLine.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@implementation ibTerrain
@synthesize material;

- (id)initWithSize:(GLuint)s height:(GLfloat)h heightMapFile:(NSString *)hmf{
    self = [super init];
    if(self){
        ibMaterialProperties *properties = [[ibMaterialProperties alloc] initWithMaterialType: IBMATERIAL_TERRAIN];
        [properties setTexture2: @"terrainnormals.png"];
        self.material = [[ibMaterial alloc] initWithMaterialProperties: properties];
        
        size = s;
        height = h;
        
        heightMapFile = hmf;
        
        [self setupVBO];
        
        for(GLfloat x = 0; x < size; x+= (size / 20.0f)){
            for(GLfloat z = 0; z < size; z+= (size / 20.0f)){
                GLKVector3 vert = GLKVector3Make(x - (size / 2.0f), [self getHeightAt:x z:z], z - (size / 2.0f));
                GLKVector3 norm = [self getNormalAt:x z:z];
                norm = GLKVector3MultiplyScalar(norm, 30.0f);
                
                ibLine *line = [[ibLine alloc] initWithStart:vert end:GLKVector3Add(vert, norm) color:GLKVector3Make(0.0, 0.7, 0.1)];
                [self addChild: line];
            }
        }
    }
    return self;
}

- (void)readHeightMap{
    UIImage *heightMap = [[ibTextureManager sharedManager] loadImage: heightMapFile];
    CGImageRef image = [heightMap CGImage];
    NSUInteger imageWidth = CGImageGetWidth(image);
    NSUInteger imageHeight = CGImageGetHeight(image);
    
    if(imageWidth != imageHeight){
        NSLog(@"Image width != image height != size, quitting");
        exit(0);
    }
    
    imgSize = imageWidth;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(imgSize * imgSize * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * imgSize;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, imgSize, imgSize, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, imgSize, imgSize), image);
    CGContextRelease(context);
    
    [heightMap release];
    
    heights = malloc(imageWidth * imageWidth * sizeof(GLfloat));
    int byteIndex = 0;
    for(int x = 0; x < imageWidth * imageWidth; x++){
        heights[x] = (rawData[byteIndex] / 255.0f) * height;
        byteIndex += bytesPerPixel;
    }
    
    free(rawData);
}

- (void)calculateNormals{
    normals = malloc(imgSize * imgSize * sizeof(GLKVector3));
    for(int x = 0; x < imgSize; x++){
        for (int z = 0; z < imgSize; z++){
            if(x == 0 || z == 0){
                GLKVector3 norm = GLKVector3Normalize(GLKVector3Make((heights[(z*imgSize)+x] - heights[(z*imgSize)+x+1]) / 2.0f, 1, (heights[(z*imgSize)+x] - heights[((z+1)*imgSize)+x]) / 2));
                normals[(z*size) + x] = norm;
            }else if(x == imgSize - 1 || z == imgSize - 1){
                GLKVector3 norm = GLKVector3Normalize(GLKVector3Make((heights[(z*imgSize)+x-1] - heights[(z*imgSize)+x]) / 2.0f, 1, (heights[((z-1)*imgSize)+x] - heights[(z*imgSize)+x]) / 2));
                normals[(z*size) + x] = norm;
            }else{
                GLKVector3 norm = GLKVector3Normalize(GLKVector3Make((heights[(z*imgSize)+x-1] - heights[(z*imgSize)+x+1]) / 2.0f, 1, (heights[((z-1)*imgSize)+x] - heights[((z+1)*imgSize)+x]) / 2));
                normals[(z*size) + x] = norm;
            }
        }
    }
}

- (void)generateMesh{
    numVertices = size * size;
    numIndices = 2*(size - 1)*(size + 1) - 2;
    GLfloat sDiv2 = (GLfloat)(size - 1) / 2.0f;
    
    GLfloat *vertexData = malloc(numVertices*8*sizeof(GLfloat));
    GLuint *indexData = malloc(numIndices*sizeof(GLuint));
    memset(vertexData, 0, numVertices*8*sizeof(GLfloat));
    memset(indexData, 0, numIndices*sizeof(GLuint));
    
    for(int z = 0; z < size; z++){
        for(int x = 0; x < size; x++){
            long index = ((z * size) + x) * 8;
            GLuint imgX = ((GLfloat)x / size) * imgSize;
            GLuint imgZ = ((GLfloat)z / size) * imgSize;
            
            GLKVector3 normal = normals[(imgZ * imgSize) + imgX];
            
            vertexData[index] = (GLfloat)x - sDiv2;         // Vx
            vertexData[index + 1] = heights[(imgZ * imgSize) + imgX];//(rand() % 10000) / 100.0f;                  // Vy
            vertexData[index + 2] = (GLfloat)z - sDiv2;     // Vz
            vertexData[index + 3] = normal.x;                   // Nx
            vertexData[index + 4] = normal.y;                   // Ny
            vertexData[index + 5] = normal.z;                   // Nz
            vertexData[index + 6] = (rand() % 255) / 1020.0f;                   // U
            vertexData[index + 7] = (rand() % 255) / 510.0f;                   // V
            //NSLog(@"V[%i,%i] = %.2f,%.2f,%.2f", x, z, vertexData[index], vertexData[index + 1], vertexData[index + 2]);
        }
    }
    
    int i = 0;
    for(int z = 0; z < size - 1; z++){
        for(int x = 0; x < size; x++){
            indexData[i] = (size * z) + x;
            indexData[i + 1] = (size * (z + 1)) + x;
            i += 2;
        }
        if(z != size - 2){
            indexData[i] = (size * (z + 1)) + (size - 1); // repeat bottom right corner of last row
            indexData[i + 1] = (size * (z + 1)); // repeat top left corner of next row
            i += 2;
        }
    }
    
    /*NSLog(@"indices, %i, predicted: %i:", i, numIndices);
    for(int x = 0; x < i; x++){
        printf("%i ", indexData[x]);
    }*/
    
    vdata = vertexData;
    indices = indexData;
}

- (void)setupVBO{
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    
    //glBufferData(GL_ARRAY_BUFFER, sizeof(gCVD), gCVD, GL_STATIC_DRAW);
    
    [self readHeightMap];
    [self calculateNormals];
    [self generateMesh];
    
    glBufferData(GL_ARRAY_BUFFER, numVertices*8*sizeof(GLfloat), vdata, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray([[material shader] locationForAttrib:"a_position"]);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(0));
    
    glEnableVertexAttribArray([[material shader] locationForAttrib:"a_normal"]);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(12));
        
    // workaround to give vertex color in 2 dimensions
    glEnableVertexAttribArray([[material shader] locationForAttrib:"a_texCoord"]);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(24));
    
    glBindVertexArrayOES(0);
    
    uniformMVPLocation = [[material shader] locationForUniform:"u_modelViewProjectionMatrix"];
    uniformNMLocation = [[material shader] locationForUniform:"u_normalMatrix"];
}

- (void)draw:(GLKMatrix4)viewProjectionMatrix{
    if([material type] == IBMATERIAL_BASE){
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, [material texture].name);
    }
    
    GLKMatrix4 modelMatrix = GLKMatrix4MakeTranslation(position.x, position.y, position.z);
    modelMatrix = GLKMatrix4ScaleWithVector3(modelMatrix, scale);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, rotation.x, 1, 0, 0);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, rotation.y, 0, 1, 0);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, rotation.z, 0, 0, 1);
    
    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(viewProjectionMatrix, modelMatrix);
    GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelMatrix), NULL);
    
    [[material shader] use];
    glBindVertexArrayOES(_vertexArray);
    
    glUniformMatrix4fv(uniformMVPLocation, 1, 0, modelViewProjectionMatrix.m);
    glUniformMatrix3fv(uniformNMLocation, 1, 0, normalMatrix.m);
    
    //glUniform1i([[material shader] locationForUniform:"s_texture"], 0);
    
    glDrawElements(GL_TRIANGLE_STRIP, numIndices, GL_UNSIGNED_INT, indices);
    glBindVertexArrayOES(0);
    
    [super draw:modelViewProjectionMatrix];
}

- (GLfloat)getHeightAt:(GLfloat)x z:(GLfloat)z{
    x = (x < 0) ? 0 : x;
    z = (z < 0) ? 0 : z;
    x = (x > size) ? size : x;
    z = (z > size) ? size : z;
    
    GLuint imgX = (x / (GLfloat)size) * (GLfloat)imgSize;
    GLuint imgZ = (z / (GLfloat)size) * (GLfloat)imgSize;
    
    GLfloat triZ0 = heights[(imgZ * imgSize) + imgX];
    GLfloat triZ1 = heights[(imgZ * imgSize) + imgX + 1];
    GLfloat triZ2 = heights[((imgZ + 1) * imgSize) + imgX];
    GLfloat triZ3 = heights[((imgZ + 1) * imgSize) + imgX + 1];
    
    GLfloat avgHeight = 0.0f;
    GLfloat sqX = ((x / (GLfloat)size) * (GLfloat)imgSize) - imgX;
    GLfloat sqZ = ((z / (GLfloat)size) * (GLfloat)imgSize) - imgZ;

    if((sqX + sqZ) < 1){
        avgHeight = triZ0;
        avgHeight += (triZ1 - triZ0) * sqX;
        avgHeight += (triZ2 - triZ0) * sqZ;
    }else{
        avgHeight = triZ3;
        avgHeight += (triZ1 - triZ3) * (1.0f - sqZ);
        avgHeight += (triZ2 - triZ3) * (1.0f - sqX);
    }
    return avgHeight;
}

- (GLKVector3)getNormalAt:(GLfloat)x z:(GLfloat)z{
    x = (x < 0) ? 0 : x;
    z = (z < 0) ? 0 : z;
    x = (x > size) ? size : x;
    z = (z > size) ? size : z;
    
    GLuint imgX = (x / (GLfloat)size) * (GLfloat)imgSize;
    GLuint imgZ = (z / (GLfloat)size) * (GLfloat)imgSize;
    
    GLKVector3 triZ0 = normals[(imgZ * imgSize) + imgX];
    GLKVector3 triZ1 = normals[(imgZ * imgSize) + imgX + 1];
    GLKVector3 triZ2 = normals[((imgZ + 1) * imgSize) + imgX];
    GLKVector3 triZ3 = normals[((imgZ + 1) * imgSize) + imgX + 1];
    
    GLKVector3 avgNormal = GLKVector3Make(0, 0, 0);
    GLfloat sqX = ((x / (GLfloat)size) * (GLfloat)imgSize) - imgX;
    GLfloat sqZ = ((z / (GLfloat)size) * (GLfloat)imgSize) - imgZ;
    if((sqX + sqZ) < 1){
        avgNormal = triZ0;
        avgNormal = GLKVector3Add(avgNormal, GLKVector3MultiplyScalar(GLKVector3Subtract(triZ1, triZ0), sqX));
        avgNormal = GLKVector3Add(avgNormal, GLKVector3MultiplyScalar(GLKVector3Subtract(triZ2, triZ0), sqZ));
    }else{
        avgNormal = triZ3;
        avgNormal = GLKVector3Add(avgNormal, GLKVector3MultiplyScalar(GLKVector3Subtract(triZ1, triZ3), (1.0f - sqZ)));
        avgNormal = GLKVector3Add(avgNormal, GLKVector3MultiplyScalar(GLKVector3Subtract(triZ2, triZ3), (1.0f - sqX)));
    }
    return avgNormal;
}

- (void)update:(NSTimeInterval)deltaTime{
    [super update:deltaTime];
}

- (void)cleanup{
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
}

@end
