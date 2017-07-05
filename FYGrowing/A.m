//
//  A.m
//  FYGrowing
//
//  Created by 杨飞宇 on 2017/7/5.
//  Copyright © 2017年 FY. All rights reserved.
//

#import "A.h"

@implementation A

- (void)test {
    [super test];
    NSLog(@"A:test:%@", NSStringFromSelector(_cmd));
}

- (void)swizzle_test {
    [super swizzle_test];
    NSLog(@"A:swizzle_test:%@",NSStringFromSelector(_cmd));
}

- (void)AtestMethod {
    NSLog(@"A:testMethod");
}

- (void)Aswizzle_testMethod {
    NSLog(@"A:swizzle_testMethod");
}

@end
