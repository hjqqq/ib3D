//
//  ibMaterial.h
//  ib3D
//
//  Created by Billy Connolly on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "ibShader.h"
#import "ibTextureManager.h"
#import "ibMaterialProperties.h"

@interface ibMaterial : NSObject{
    GLKTextureInfo *texture;
    GLKTextureInfo *texture2;
    ibShader *shader;
    
    int type;
}

@property (nonatomic, retain) ibShader *shader;
@property (nonatomic, retain) GLKTextureInfo *texture;
@property (nonatomic, retain) GLKTextureInfo *texture2;
@property int type;

- (id)initWithMaterialProperties:(ibMaterialProperties *)matProps;

@end
