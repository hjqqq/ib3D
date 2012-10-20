//
//  ibShader.h
//  ib3D
//
//  Created by Billy Connolly on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ibMaterialProperties.h"

@interface ibShader : NSObject{
    NSString *filePath;
    GLuint _program;
}

@property GLuint _program;

- (id)initWithShaderName:(NSString *)shaderName withType:(int)type;

- (void)use;
- (GLuint)locationForUniform:(const char *)uniform;
- (GLuint)locationForAttrib:(const char *)attrib;

- (BOOL)loadShaders:(NSString *)shaderName withType:(int)type;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;

@end
