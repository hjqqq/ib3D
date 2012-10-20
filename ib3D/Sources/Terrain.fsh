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

void main(){
    gl_FragColor = .6 * vec4(v_texCoord.x, v_texCoord.y, 0, 1) + (.35 * v_colorVarying);
}
