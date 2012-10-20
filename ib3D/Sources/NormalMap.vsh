//
//  Shader.vsh
//  ib3D
//
//  Created by Billy Connolly on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

attribute vec4 a_position;
attribute vec3 a_normal;
attribute vec2 a_texCoord;

varying vec4 v_colorVarying;
varying vec2 v_texCoord;

uniform mat4 u_modelViewProjectionMatrix;
uniform mat3 u_normalMatrix;

void main()
{
    vec3 eyeNormal = normalize(u_normalMatrix * a_normal);
    vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    vec4 diffuseColor = vec4(1.0, 1.0, 1.0, 1.0);
    
    float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
                 
    v_colorVarying = diffuseColor * nDotVP;
    
    v_texCoord = a_texCoord;
    gl_Position = u_modelViewProjectionMatrix * a_position;
}