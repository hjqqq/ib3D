//
//  ibMaterialProperties.m
//  ib3D
//
//  Created by Billy Connolly on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ibMaterialProperties.h"

@implementation NSString (ibString)

- (BOOL)beginsWith:(NSString *)string{
    int length = [string length];
    if([self length] >= length){
        if([[self substringToIndex: length - 1] isEqualToString:string] == NSOrderedSame)
            return YES;
        else
            return NO;
    }else{
        return NO;
    }
}

@end

@implementation ibMaterialProperties

- (id)initWithMaterialType:(int)t{
    self = [super init];
    if(self){
        properties = [[NSMutableDictionary alloc] init];
        type = t;
    }
    return self;
}

- (int)type{
    return type;
}

- (void)setTexture2:(NSString *)texture2{
    [properties setObject:texture2 forKey:@"Texture2"];
}

- (NSString *)texture2{
    return [properties objectForKey:@"Texture2"];
}

- (void)setTexture1:(NSString *)texture1{
    [properties setObject:texture1 forKey:@"Texture1"];
}

- (NSString *)texture1{
    return [properties objectForKey:@"Texture1"];
}

@end
