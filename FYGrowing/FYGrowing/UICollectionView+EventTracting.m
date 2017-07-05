//
//  UICollectionView+EventTracting.m
//  FYEventTracting
//
//  Created by Sen on 2016/12/23.
//  Copyright © 2016年 FY. All rights reserved.
//

#import "UICollectionView+EventTracting.h"
#import "UIControl+EventTracting.h"
#import "FYSwizzling.h"
#import "FYEventTractingDataManager.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "EventComponentManager.h"
#import "UIWindow+EventTractingTool.h"
#import "FYEventTrackingEntranceHeader.h"
#import "UIImage+EventTractingTool.h"

@implementation UICollectionView (EventTracting)

FYStaticHookClass(UICollectionView, AutoCrack,
                  void, @selector(setDelegate:),(id<UICollectionViewDelegate>)delegate)
{
    FYDynamicHookClass(delegate, void, @selector(collectionView:didSelectItemAtIndexPath:),(UICollectionView*)collectionView,(NSIndexPath*)indexPath)
    {
        // 获取当前cell
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        
        if ([EventComponentManager sharedManager].state == EventComponentStateSelect && cell.window != (UIWindow *)[EventComponentManager sharedManager].window) {
            
            NSString *xpath = [[FYEventTractingDataManager shareInstance] getXpathWithPage:cell];
            NSString *uiCode = [[FYEventTractingDataManager shareInstance] getUICodeForCurrentPage:cell];
            UIImage *image = [[UIWindow getImageWithFullScreenshot] circleImage:[cell.superview convertRect:cell.frame toView:cell.window]];
            NSString *itemId = [cell itemId];
            NSString *className = [[FYEventTractingDataManager shareInstance] getClassNameForCurrentPage:cell];
            
            [[EventComponentManager sharedManager] presentToSettingViewControllerWithXpath:xpath withItemId:itemId withClassName:className withUICode:uiCode withImage:image];
            
            return;
        }
        
        FYHookOrgin(collectionView,indexPath);
        
        [[FYEventTractingDataManager shareInstance] getEventModelWithNode:cell withType:FYEventNodeTypeClick];
    }
    FYDynamicHookEnd
    
    FYHookOrgin(delegate);
}
FYStaticHookEnd

@end
