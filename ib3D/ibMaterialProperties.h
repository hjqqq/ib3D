//
//  ibMaterialProperties.h
//  ib3D
//
//  Created by Billy Connolly on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ibString)
- (BOOL)beginsWith:(NSString *)string;
@end

enum{
    IBMATERIAL_NONE = 0,
    IBMATERIAL_DEBUG,
    IBMATERIAL_BASE,
    IBMATERIAL_TERRAIN
};

@interface ibMaterialProperties : NSObject{
    NSMutableDictionary *properties;
    int type;
}

- (id)initWithMaterialType:(int)t;
- (int)type;

- (void)setTexture1:(NSString *)texture1;
- (void)setTexture2:(NSString *)texture2;
- (NSString *)texture1;
- (NSString *)texture2;

@end
