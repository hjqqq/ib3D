//
//  ibShader.m
//  ib3D
//
//  Created by Billy Connolly on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ibShader.h"
#import <GLKit/GLKit.h>

@implementation ibShader
@synthesize _program;

- (id)initWithShaderName:(NSString *)shaderName withType:(int)type{
    self = [super init];
    if(self){
        [self loadShaders: shaderName withType:type];
    }
    return self;
}

- (void)use{
    glUseProgram(_program);
}

- (void)dealloc{
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
    [super dealloc];
}

- (BOOL)loadShaders:(NSString *)shaderName withType:(int)type{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    _program = glCreateProgram();
    
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader %@.vsh", shaderName);
        return NO;
    }
    
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader %@.fsh", shaderName);
        return NO;
    }
    
    glAttachShader(_program, vertShader);
    glAttachShader(_program, fragShader);
    
    glBindAttribLocation(_program, GLKVertexAttribPosition, "a_position");
    if(type != IBMATERIAL_DEBUG)
        glBindAttribLocation(_program, GLKVertexAttribNormal, "a_normal");
    else
        glBindAttribLocation(_program, GLKVertexAttribColor, "a_color");

    if(type == IBMATERIAL_BASE || type == IBMATERIAL_TERRAIN)
        glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "a_texCoord");
    
    
    
    if(![self linkProgram:_program]){
        NSLog(@"Failed to link program: %d for shader: %@", _program, shaderName);
        
        if(vertShader){
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if(fragShader){
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if(_program){
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    if(vertShader){
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if(fragShader){
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (GLuint)locationForUniform:(const char *)uniform{
    GLuint uniformLoc = glGetUniformLocation(_program, uniform);
    return uniformLoc;
}

- (GLuint)locationForAttrib:(const char *)attrib{
    GLuint attribloc = glGetAttribLocation(_program, attrib);
    return attribloc;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

@end
