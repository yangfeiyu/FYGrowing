//
//  UIScrollView+EventTracting.m
//  FYEventTracting
//
//  Created by Sen on 2016/12/15.
//  Copyright © 2016年 FY. All rights reserved.
//

#import "UIScrollView+EventTracting.h"
#import "FYSwizzling.h"
#import "FYEventTractingDataManager.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIScrollView (EventTracting)

FYStaticHookClass(UIScrollView, AutoCrack, void, @selector(setDelegate:),(id<UITableViewDelegate>)delegate)
{
    FYDynamicAddMethodAndHookClass(delegate, void,, @selector(scrollViewDidEndDecelerating:), (UIScrollView*)scrollView)
    {
        FYHookOrgin(scrollView);
        [[FYEventTractingDataManager shareInstance] getEventModelWithNode:scrollView withType:FYEventNodeTypeScroll];
    }
    FYDynamicHookEnd
    
    FYHookOrgin(delegate);
}
FYStaticHookEnd

@end
