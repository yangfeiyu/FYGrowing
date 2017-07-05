//
//  UIControl+EventTracting.m
//  FYEventTracting
//
//  Created by Sen on 2016/12/15.
//  Copyright © 2016年 FY. All rights reserved.
//

#import "UIControl+EventTracting.h"
#import "FYSwizzling.h"
#import "FYEventTractingDataManager.h"
#import "EventComponentManager.h"
#import "UIWindow+EventTractingTool.h"
#import "FYEventTrackingEntranceHeader.h"
#import "UIImage+EventTractingTool.h"

@implementation UIControl (EventTracting)

FYStaticHookClass(UIControl, AutoCrack,
                  void, NSSelectorFromWords(_send,Actions,For,Events,:with,Event:),(UIControlEvents)events,(id)event)
{
    
    if ([EventComponentManager sharedManager].state == EventComponentStateSelect && self.window != (UIWindow *)[EventComponentManager sharedManager].window) {
        
        NSString *xpath = [[FYEventTractingDataManager shareInstance] getXpathWithPage:self];
        NSString *uiCode = [[FYEventTractingDataManager shareInstance] getUICodeForCurrentPage:self];
        UIImage *image = [[UIWindow getImageWithFullScreenshot] circleImage:[self.superview convertRect:self.frame toView:self.window]];
        NSString *itemId = [self itemId];
        NSString *className = [[FYEventTractingDataManager shareInstance] getClassNameForCurrentPage:self];
        
        [[EventComponentManager sharedManager] presentToSettingViewControllerWithXpath:xpath withItemId:itemId withClassName:className withUICode:uiCode withImage:image];
        
        return;
    }
    
    FYHookOrgin(events,event);
    
    if (events & UIControlEventTouchUpInside || (events & UIControlEventTouchDown && !(self.allControlEvents & UIControlEventTouchUpInside)))
    {
        [[FYEventTractingDataManager shareInstance] getEventModelWithNode:self withType:FYEventNodeTypeClick];
    }
}
FYStaticHookEnd

@end
