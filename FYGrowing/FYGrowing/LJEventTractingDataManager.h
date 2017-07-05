//
//  FYEventTractingDataManager.h
//  FYEventTracting
//
//  Created by 杨飞宇 on 2017/5/26.
//  Copyright © 2017年 FY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FYEventNodeType) {
    FYEventNodeTypeClick = 0,
    FYEventNodeTypeScroll,
    FYEventNodeTypeEnter,
    FYEventNodeTypeLeave,
    FYEventNodeTypePositive,
    FYEventNodeTypeNegative
};

@class FYEventTractingModel;

@interface FYEventTractingDataManager : NSObject

@property (nonatomic, copy) NSString *currentClass;

@property (nonatomic, copy) NSString *referClass;

@property (nonatomic, copy) NSString *currentClassName;

@property (nonatomic, copy) NSString *referClassName;

+ (instancetype)shareInstance;

// 获取model，存储model
- (void)getEventModelWithNode:(id)view withType:(FYEventNodeType)type;

// 判断class是不是自定义UIViewController
- (BOOL)judgeVC:(Class)vcClass;

// 获取xpath
- (NSString *)getXpathWithPage:(id)view;

// 获取current page UICode
- (NSString *)getUICodeForCurrentPage:(id)view;

// 获取current page ClassName
- (NSString *)getClassNameForCurrentPage:(id)view;

@end
