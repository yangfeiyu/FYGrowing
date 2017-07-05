//
//  B.m
//  FYGrowing
//
//  Created by 杨飞宇 on 2017/7/5.
//  Copyright © 2017年 FY. All rights reserved.
//

#import "B.h"

@implementation B

- (void)test {
    NSLog(@"B:test:%@",NSStringFromSelector(_cmd));
}

- (void)swizzle_test {
    NSLog(@"B:swizzle_test:%@",NSStringFromSelector(_cmd));
}

- (void)BtestMethod {
    NSLog(@"B:testMethod");
}

- (void)Bswizzle_testMethod {
    NSLog(@"B:swizzle_testMethod");
}

@end
