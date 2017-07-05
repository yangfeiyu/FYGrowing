//
//  UIViewController+EventTracting.m
//  FYEventTracting
//
//  Created by Sen on 2016/12/15.
//  Copyright © 2016年 FY. All rights reserved.
//

#import "UIViewController+EventTracting.h"
#import "FYEventTractingDataManager.h"
#import "FYSwizzling.h"
#import <objc/runtime.h>
#import "UIViewController+FYUniversalLog.h"

@implementation UIViewController (EventTracting)

FYStaticHookClass(UIViewController, AutoCrack, id, @selector(initWithNibName:bundle:), (NSString *)nibNameOrNil, (NSBundle *)nibBundleOrNil)
{
    if ([[FYEventTractingDataManager shareInstance] judgeVC:[self class]] && ![self isKindOfClass:[UINavigationController class]]) {
        FYDynamicHookClass(self, void, @selector(viewDidAppear:), (BOOL)animated)
        {
            FYHookOrgin(animated);
            
            UIViewController *vc = self;
            if (!vc.eventLock) {
                
                // refer设置
                [FYEventTractingDataManager shareInstance].referClass = [FYEventTractingDataManager shareInstance].currentClass;
                [FYEventTractingDataManager shareInstance].referClassName = [FYEventTractingDataManager shareInstance].currentClassName;
                [FYEventTractingDataManager shareInstance].currentClass = [self FY_urlSchema];
                [FYEventTractingDataManager shareInstance].currentClassName = NSStringFromClass([self class]);
                
                [[FYEventTractingDataManager shareInstance] getEventModelWithNode:vc withType:FYEventNodeTypeEnter];
                vc.eventLock = YES;
            }
        }
        FYDynamicHookEnd
        
        FYDynamicHookClass(self, void, @selector(viewDidDisappear:), (BOOL)animated)
        {
            UIViewController *vc = self;
            if (vc.eventLock) {
                
                [[FYEventTractingDataManager shareInstance] getEventModelWithNode:vc withType:FYEventNodeTypeLeave];
                vc.eventLock = NO;
                
                
            }
            
            FYHookOrgin(animated);
        }
        FYDynamicHookEnd
    }
    
    return FYHookOrgin(nibNameOrNil, nibBundleOrNil);
}
FYStaticHookEnd

FYStaticHookClass(UIViewController, AutoCrack, id, @selector(initWithCoder:), (NSCoder *)coder)
{
    if ([[FYEventTractingDataManager shareInstance] judgeVC:[self class]] && ![self isKindOfClass:[UINavigationController class]]) {
        FYDynamicHookClass(self, void, @selector(viewDidAppear:), (BOOL)animated)
        {
            FYHookOrgin(animated);
            
            UIViewController *vc = self;
            if (!vc.eventLock) {
                
                // refer设置
                [FYEventTractingDataManager shareInstance].referClass = [FYEventTractingDataManager shareInstance].currentClass;
                [FYEventTractingDataManager shareInstance].referClassName = [FYEventTractingDataManager shareInstance].currentClassName;
                [FYEventTractingDataManager shareInstance].currentClass = [self FY_urlSchema];
                [FYEventTractingDataManager shareInstance].currentClassName = NSStringFromClass([self class]);
                
                [[FYEventTractingDataManager shareInstance] getEventModelWithNode:vc withType:FYEventNodeTypeEnter];
                vc.eventLock = YES;
            }
        }
        FYDynamicHookEnd
        
        FYDynamicHookClass(self, void, @selector(viewDidDisappear:), (BOOL)animated)
        {
            UIViewController *vc = self;
            if (vc.eventLock) {
                
                [[FYEventTractingDataManager shareInstance] getEventModelWithNode:vc withType:FYEventNodeTypeLeave];
                vc.eventLock = NO;
                
            }
            
            FYHookOrgin(animated);
        }
        FYDynamicHookEnd
    }
    
    return FYHookOrgin(coder);
}
FYStaticHookEnd

- (void)setEventLock:(BOOL)eventLock {
    objc_setAssociatedObject(self, @selector(eventLock), @(eventLock), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)eventLock {
    return [objc_getAssociatedObject(self, @selector(eventLock)) boolValue];
}

@end
