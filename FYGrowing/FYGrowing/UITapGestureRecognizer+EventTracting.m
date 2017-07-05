//
//  UITapGestureRecognizer+EventTracting.m
//  FYEventTracting
//
//  Created by 杨飞宇 on 2017/6/5.
//  Copyright © 2017年 FY. All rights reserved.
//

#import "UITapGestureRecognizer+EventTracting.h"
#import "FYSwizzling.h"
#import "FYEventTractingDataManager.h"
#import "FYEventTrackingEntranceHeader.h"
#import "EventComponentManager.h"
#import "UIWindow+EventTractingTool.h"
#import "UIImage+EventTractingTool.h"

@implementation UITapGestureRecognizer (EventTracting)

FYStaticHookClass(UITapGestureRecognizer, AutoCrack, void, @selector(setState:), (UIGestureRecognizerState)state)
{
    
    if ([EventComponentManager sharedManager].state == EventComponentStateSelect && self.view.window != (UIWindow *)[EventComponentManager sharedManager].window) {
        
        NSString *xpath = [[FYEventTractingDataManager shareInstance] getXpathWithPage:self.view];
        NSString *uiCode = [[FYEventTractingDataManager shareInstance] getUICodeForCurrentPage:self.view];
        UIImage *image = [[UIWindow getImageWithFullScreenshot] circleImage:[self.view.superview convertRect:self.view.frame toView:self.view.window]];
        NSString *itemId = [self.view itemId];
        NSString *className = [[FYEventTractingDataManager shareInstance] getClassNameForCurrentPage:self.view];
        
        [[EventComponentManager sharedManager] presentToSettingViewControllerWithXpath:xpath withItemId:itemId withClassName:className withUICode:uiCode withImage:image];
        
        return;
    }
    
    FYHookOrgin(state);
    
    if (UIGestureRecognizerStateEnded == state && [self isKindOfClass:[UITapGestureRecognizer class]]) {
        
        // 兼容旧版本
        if ([self.itemId length] > 0) {
            self.view.itemId = self.itemId;
        }
        [[FYEventTractingDataManager shareInstance] getEventModelWithNode:self.view withType:FYEventNodeTypeClick];
    }
    
}
FYStaticHookEnd

@end
