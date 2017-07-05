//
//  ViewController.m
//  FYGrowing
//
//  Created by 杨飞宇 on 2017/7/4.
//  Copyright © 2017年 FY. All rights reserved.
//

#import "ViewController.h"
#import "A.h"
#import "B.h"

#define PRINT_TOKEN(token) NSLog(" is %d", token)

@interface ViewController ()

@property (nonatomic, strong) A *a;
@property (nonatomic, strong) B *b;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.a = [[A alloc] init];
    [self.a test];
    
    NSLog(@"---------");
    
    self.b = [[B alloc] init];
    [self.b test];
    
    NSString *a = @"fdfd";
}


@end
