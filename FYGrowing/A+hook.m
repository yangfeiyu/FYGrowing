//
//  A+hook.m
//  FYGrowing
//
//  Created by 杨飞宇 on 2017/7/5.
//  Copyright © 2017年 FY. All rights reserved.
//

#import "A+hook.h"
#import <objc/runtime.h>
#import "RSSwizzle.h"
#import "A.h"
#import "B.h"

@implementation A (hook)

+ (void)load
{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Method originalMethod = class_getInstanceMethod([self class], @selector(test));
//        Method swizzleMethod = class_getInstanceMethod([self class], @selector(swizzle_test));
//        
////        method_exchangeImplementations(originalMethod, swizzleMethod);
//        
//        BOOL didAddMethod = class_addMethod([self class], @selector(test), method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
//        if (didAddMethod) {
//            class_replaceMethod([self class], @selector(swizzle_test), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//        } else {
//            method_exchangeImplementations(originalMethod, swizzleMethod);
//        }
//        
//    });
    
//    [RSSwizzle swizzleClassMethod:NSSelectorFromString(@"test") inClass:NSClassFromString(@"A") newImpFactory:^id(RSSwizzleInfo *swizzleInfo) {
//        NSLog(@"A:swizzle_test");
//        return swizzleInfo;
//    }];
//    
//    [RSSwizzle swizzleClassMethod:NSSelectorFromString(@"test") inClass:NSClassFromString(@"B") newImpFactory:^id(RSSwizzleInfo *swizzleInfo) {
//        NSLog(@"B:swizzle_test");
//        return swizzleInfo;
//    }];
    
    RSSwizzleInstanceMethod(A, @selector(test), RSSWReturnType(void), RSSWReturnType(), RSSWReplacement({
        NSLog(@"A:swizzle_test");
    }), 0, NULL);
    
    RSSwizzleInstanceMethod(B, @selector(test), RSSWReturnType(void), RSSWReturnType(), RSSWReplacement({
        NSLog(@"B:swizzle_test");
    }), 0, NULL);
}
@end
