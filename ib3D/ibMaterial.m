//
//  ibMaterial.m
//  ib3D
//
//  Created by Billy Connolly on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ibMaterial.h"

@implementation ibMaterial
@synthesize shader;
@synthesize texture;
@synthesize texture2;
@synthesize type;

- (id)initWithMaterialProperties:(ibMaterialProperties *)matProps{
    self = [super init];
    if(self){
        self.type = [matProps type];
        
        if(type == IBMATERIAL_NONE){
            self.shader = [[ibShader alloc] initWithShaderName:@"None" withType:type];
        }else if(type == IBMATERIAL_DEBUG){
            self.shader = [[ibShader alloc] initWithShaderName:@"Debug" withType:type];
        }else if(type == IBMATERIAL_BASE){
            self.shader = [[ibShader alloc] initWithShaderName:@"Base" withType:type];
            self.texture = [[ibTextureManager sharedManager] loadTexture:[matProps texture1]];
        }else if(type == IBMATERIAL_TERRAIN){
            self.shader = [[ibShader alloc] initWithShaderName:@"Terrain" withType:type];
            self.texture2 = [[ibTextureManager sharedManager] loadTexture:[matProps texture2]];
        }
    }
    return self;
}

@end
