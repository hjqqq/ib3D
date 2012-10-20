//
//  ibTextureManager.h
//  ib3D
//
//  Created by Billy Connolly on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface ibTextureManager : NSObject{
    
}

+ (id)sharedManager;

- (GLKTextureInfo *)loadTexture:(NSString *)texture;
- (UIImage *)loadImage:(NSString *)image;

@end
