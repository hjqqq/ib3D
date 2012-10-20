//
//  Shader.fsh
//  ib3D
//
//  Created by Billy Connolly on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

precision lowp float;
varying vec4 v_colorVarying;
varying vec2 v_texCoord;

uniform sampler2D s_texture;
uniform sampler2D s_normalMap;

void main()
{
    gl_FragColor = texture2D(s_texture, v_texCoord) + .25 * v_colorVarying;
}
