//
//  UITableView+EventTracting.m
//  FYEventTracting
//
//  Created by Sen on 2016/12/22.
//  Copyright © 2016年 FY. All rights reserved.
//

#import "UITableView+EventTracting.h"
#import "FYSwizzling.h"
#import "FYEventTractingDataManager.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "EventComponentManager.h"
#import "UIWindow+EventTractingTool.h"
#import "FYEventTrackingEntranceHeader.h"
#import "UIImage+EventTractingTool.h"

@implementation UITableView (EventTracting)

FYStaticHookClass(UITableView, AutoCrack,
                  void, @selector(setDelegate:),(id<UITableViewDelegate>)delegate)
{
    FYDynamicHookClass(delegate, void, @selector(tableView:didSelectRowAtIndexPath:),(UITableView*)tableView,(NSIndexPath*)indexPath)
    {
        // 获取当前cell
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if ([EventComponentManager sharedManager].state == EventComponentStateSelect && cell.window != (UIWindow *)[EventComponentManager sharedManager].window) {
            
            NSString *xpath = [[FYEventTractingDataManager shareInstance] getXpathWithPage:cell];
            NSString *uiCode = [[FYEventTractingDataManager shareInstance] getUICodeForCurrentPage:cell];
            UIImage *image = [[UIWindow getImageWithFullScreenshot] circleImage:[cell.superview convertRect:cell.frame toView:cell.window]];
            NSString *itemId = [cell itemId];
            NSString *className = [[FYEventTractingDataManager shareInstance] getClassNameForCurrentPage:cell];
            
            [[EventComponentManager sharedManager] presentToSettingViewControllerWithXpath:xpath withItemId:itemId withClassName:className withUICode:uiCode withImage:image];
            
            return;
        }
        
        FYHookOrgin(tableView,indexPath);
        
        [[FYEventTractingDataManager shareInstance] getEventModelWithNode:cell withType:FYEventNodeTypeClick];
    }
    FYDynamicHookEnd
    
//    FYDynamicHookClass(delegate, UITableViewCell*, @selector(tableView:cellForRowAtIndexPath:), (UITableView*)tableView, (NSIndexPath*)indexPath)
//    {
//        // 获取当前cell
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        
//        [[FYEventTractingDataManager shareInstance] getEventModelWithNode:cell withType:FYEventNodeTypeScroll];
//        
//        return FYHookOrgin(tableView,indexPath);
//    }
//    FYDynamicHookEnd
    
    FYHookOrgin(delegate);
}
FYStaticHookEnd

@end
