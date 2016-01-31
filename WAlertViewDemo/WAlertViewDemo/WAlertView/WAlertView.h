//
//  WAlertView.h
//  WAlertViewDemo
//
//  Created by wenchao on 16/1/31.
//  Copyright © 2016年 wenchao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WAlertViewStyle) {
    WAlertViewStyleActionSheet = 0,
    WAlertViewStyleAlert
} NS_ENUM_AVAILABLE_IOS(8_0);

typedef NS_ENUM(NSInteger, WAlertActionStyle) {
    WAlertActionStyleDefault = 0,
    WAlertActionStyleCancel
};

@interface WAlertAction : NSObject

+ (instancetype)actionWithTitle:( NSString *)title style:(WAlertActionStyle)style handler:(void (^)( WAlertAction* __nullable action))handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) WAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;
@end

@interface WAlertView : UIView

+ (instancetype)alertViewWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(WAlertViewStyle)preferredStyle;

- (void)addAction:(WAlertAction *)action;
@property (nonatomic, readonly) NSArray<WAlertAction *> *actions;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;
/**
 *  该参数决定是否允许用户点击蒙层退出，默认YES
 */
@property (nonatomic, assign,getter=isShouldDismiss) BOOL   shouldDismiss ;

@property (nonatomic, readonly) WAlertViewStyle preferredStyle;

- (void)show ;
- (void)hide ;
@end

NS_ASSUME_NONNULL_END