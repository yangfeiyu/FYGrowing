//
//  B+hook.m
//  FYGrowing
//
//  Created by 杨飞宇 on 2017/7/5.
//  Copyright © 2017年 FY. All rights reserved.
//

#import "B+hook.h"
#import <objc/runtime.h>
#import "RSSwizzle.h"

@implementation B (hook)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod([self class], @selector(test));
        Method swizzleMethod = class_getInstanceMethod([self class], @selector(swizzle_test));
        
//        method_exchangeImplementations(originalMethod, swizzleMethod);
        
        BOOL didAddMethod = class_addMethod([self class], @selector(test), method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
        if (didAddMethod) {
            class_replaceMethod([self class], @selector(swizzle_test), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzleMethod);
        }
        
    });
}

@end
