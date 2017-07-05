//
//  LJEventTractingDataManager.m
//  LJEventTracting
//
//  Created by 吴洋 on 2017/5/26.
//  Copyright © 2017年 Lianjia. All rights reserved.
//

#import "LJEventTractingDataManager.h"
#import "LJEventTractingModel.h"
#import "UIControl+DataManager.h"
#import "UIViewController+LJUniversalLog.h"
#import "LJEventTrackingEntranceHeader.h"
#import "LJEventTractingStorageManager.h"
#import <mach-o/dyld.h>
#import <mach-o/getsect.h>
#import <dlfcn.h>

@interface LJEventTractingDataManager() {
    void *_header;
}


@end

@implementation LJEventTractingDataManager

#pragma mark - Public

+ (instancetype)shareInstance {
    
    static LJEventTractingDataManager *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[LJEventTractingDataManager alloc] init];
    });
    
    return _instance;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _header = nil;
        [self _getImageHeader];
    }
    
    return self;
}

- (void)getEventModelWithNode:(id)view withType:(LJEventNodeType)type {
    
    if (![view isKindOfClass:[UIView class]] && ![view isKindOfClass:[UIViewController class]]) {
        return;
    }
    
    if (![view respondsToSelector:@selector(getEventModelWithPrivateData:withType:)]) {
        return;
    }
    
    [self _getEventModelWithNode:view withType:type];
}


#pragma mark - Private

// model处理
- (void)_getEventModelWithNode:(id)view withType:(LJEventNodeType)type {
    
    // 填充model的公共数据
    LJEventTractingModel *model = [LJEventTractingModel model];
    
    // 获取每种view的私有数据
    [view getEventModelWithPrivateData:model withType:type];
    
    // 填充页面相关数据
    model.pageSchema = [self getUICodeForCurrentPage:view];
    model.pageReferer = [self _getUICodeForReferPage:view];
    model.keyOrigin = [self getClassNameForCurrentPage:view];
    model.referrerOrigin = [self _getClassNameForReferPage:view];
    
    // 填充action字段数据
    NSMutableDictionary *actionDic = [NSMutableDictionary dictionaryWithDictionary:model.action];
    if ([[view extra] isKindOfClass:[NSDictionary class]]) {
        [actionDic setValue:[view extra] forKey:@"extra"];
    }
    if ([[view itemId] length] > 0) {
        [actionDic setValue:[view itemId] forKey:@"item_id"];
    }
    NSInteger index = [self getIndexOfRow:view];
    if (index >= 0) {
        [actionDic setValue:@(index) forKey:@"location"];
    }
    if ([view isKindOfClass:[UIView class]]) {
        [actionDic setValue:[self getXpathWithPage:view] forKey:@"xpath"];
    }
    model.action = actionDic;
    
    [[LJEventTractingStorageManager sharedInstance] saveModel:model];
}

// 获取current page UICode
- (NSString *)getUICodeForCurrentPage:(id)view {
    
    return [[self _getViewController:view] lj_urlSchema];
}

// 获取refer page UICode
- (NSString *)_getUICodeForReferPage:(id)view {

    return self.referClass;
}

// 获取current page ClassName
- (NSString *)getClassNameForCurrentPage:(id)view {
    
    return NSStringFromClass([[self _getViewController:view] class]);
}

// 获取refer page ClassName
- (NSString *)_getClassNameForReferPage:(id)view {
    
    return self.referClassName;
}


// 根据view获取current VC
- (UIViewController *)_getViewController:(id)view {
    
    if ([view isKindOfClass:[UIView class]]) {
        UIResponder *responder = view;
        while ((responder = [responder nextResponder]))
            if ([responder isKindOfClass: [UIViewController class]])
                return (UIViewController *)responder;
    } else {
        return view;
    }
    
    return nil;
}

// 获取location
- (NSInteger)getIndexOfRow:(UIView *)view {
    
    if (![view isKindOfClass:[UIView class]]) {
        return -1;
    }
    
    return [self _getIndexOfRow:view withCell:nil withList:nil];
}

// 获取location Assist
- (NSInteger)_getIndexOfRow:(UIView *)view withCell:(id)cell withList:(id)listView {
    
    if (cell && listView) {
        return [listView indexPathForCell:cell].row;
    }
    
    if (nil == view) {
        return -1;
    }
    
    id temCell = cell;
    id temListView = listView;
    if ([view isKindOfClass:[UITableViewCell class]] || [view isKindOfClass:[UICollectionViewCell class]]) {
        temCell = (UITableViewCell *)view;
    }
    
    if([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UICollectionView class]]) {
        temListView = (UITableView *)view;
    }
    
    view = [view superview];
    
    return [self _getIndexOfRow:view withCell:temCell withList:temListView];
}

// 获取xpath
- (NSString *)getXpathWithPage:(id)view {
    
    // 获取UIView
    UIView *currentView = nil;
    if ([view isKindOfClass:[UIViewController class]]) {
        currentView = ((UIViewController *)view).view;
    } else if ([view isKindOfClass:[UIView class]]) {
        currentView = view;
    }
    
    if (nil == view) {
        return @"";
    }
    
    NSMutableString *itemId = [[NSMutableString alloc] init];
    itemId = [self _getXpath:currentView result:itemId];
    return itemId;
}

// 获取xpath Assist
- (NSMutableString *)_getXpath:(UIView *)view result:(NSMutableString *)result {
    
    if (nil == view.superview) {
        [result appendFormat:@"/%@", NSStringFromClass([view class])];
    } else {
        UIView *superView = view.superview;
        NSInteger index = [superView.subviews indexOfObject:view];
        result = [self _getXpath:view.superview result:result];
        NSMutableString *currentViewDesc = [[NSMutableString alloc] initWithString:NSStringFromClass([view class])];
        [result appendFormat:@"/%@[%ld]", currentViewDesc, (long)index];
    }
    
    return result;
}

// 获取image Header
- (void)_getImageHeader {
    
    const char *execPath =  [NSBundle mainBundle].executableURL.absoluteString.UTF8String + 7;
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0; i < count; i ++) {
        const char *temPath = _dyld_get_image_name(i);
        if (strcmp(temPath,execPath) == 0 ) {
            _header = (void *)_dyld_get_image_header(i);
            break;
        }
    }
}

// 判断class是不是自定义UIViewController
- (BOOL)judgeVC:(Class)vcClass {
    
    Dl_info info;
    dladdr((__bridge const void *)(vcClass),&info);
    
    if (info.dli_fbase == _header) {
        return YES;
    } else {
        return NO;
    }
}

@end
