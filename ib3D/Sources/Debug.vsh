//
//  Shader.vsh
//  ib3D
//
//  Created by Billy Connolly on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

attribute vec4 a_position;
attribute vec4 a_color;

varying vec4 v_colorVarying;

uniform mat4 u_modelViewProjectionMatrix;

void main(){
    
    v_colorVarying = a_color;
    gl_Position = u_modelViewProjectionMatrix * a_position;
}