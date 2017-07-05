//
//  UIAlertController+EventTracting.m
//  FYEventTracting
//
//  Created by 杨飞宇 on 2017/6/2.
//  Copyright © 2017年 FY. All rights reserved.
//

#import "UIAlertController+EventTracting.h"
#import "FYSwizzling.h"
#import "FYEventTractingDataManager.h"

@implementation UIAlertController (EventTracting)

FYStaticHookClass(UIAlertController, AutoCrack,
                  void, NSSelectorFromWords(_dismiss,Anima,ted:tri,ggeringActi,on:trigg,eredByPopov,erDimmi,ngView:), (BOOL)animated, (UIAlertAction*)action, (UIView*)view)
{
    
    FYHookOrgin(animated, action, view);
    
    if ([self.actions count] == 2) {
        if (self.actions[0] == action) {
            [[FYEventTractingDataManager shareInstance] getEventModelWithNode:self.view withType:FYEventNodeTypeNegative];
        } else {
            [[FYEventTractingDataManager shareInstance] getEventModelWithNode:self.view withType:FYEventNodeTypePositive];
        }
    }
}
FYStaticHookEnd

@end
