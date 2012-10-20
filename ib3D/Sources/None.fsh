//
//  Shader.fsh
//  ib3D
//
//  Created by Billy Connolly on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

precision lowp float;
varying vec4 v_colorVarying;

void main(){
    gl_FragColor = .25 * v_colorVarying;
}
