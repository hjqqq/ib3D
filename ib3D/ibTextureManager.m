//
//  ibTextureManager.m
//  ib3D
//
//  Created by Billy Connolly on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ibTextureManager.h"

static ibTextureManager *manager = nil;

@implementation ibTextureManager

+ (id)sharedManager {
    @synchronized(self) {
        if (manager == nil)
            manager = [[self alloc] init];
    }
    return manager;
}

- (GLKTextureInfo *)loadTexture:(NSString *)texture{
    NSString *path = [[NSBundle mainBundle] pathForResource:texture ofType:@""];
    NSError *error;
    if(path != nil){
        NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:GLKTextureLoaderOriginBottomLeft];
        GLKTextureInfo *tex = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
        return tex;
    }else{
        NSLog(@"Error loading texture %@.", texture);
        return nil;
    }
}

- (UIImage *)loadImage:(NSString *)image{
    NSString *path = [[NSBundle mainBundle] pathForResource:image ofType:@""];
    if(path != nil){
        UIImage *img = [[UIImage alloc] initWithContentsOfFile: path];
        return img;
    }else{
        NSLog(@"Error loading image %@.", image);
        return nil;
    }
}

@end
