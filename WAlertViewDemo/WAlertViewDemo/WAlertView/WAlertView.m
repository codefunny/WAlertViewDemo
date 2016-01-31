//
//  WAlertView.m
//  WAlertViewDemo
//
//  Created by wenchao on 16/1/31.
//  Copyright © 2016年 wenchao. All rights reserved.
//

#import "WAlertView.h"

#define kActionButtonTag  1000

//static CGFloat kDefaultButtonHeight = 40 ;
static CGFloat kDefaultButtonMargin = 10 ;
//static CGFloat kDefaultButtonSpace  = 10 ;
static NSUInteger kDefaultButtonCount = 3 ;

@interface WAlertAction ()

@property (nonatomic,readwrite) NSString*          title;
@property (nonatomic,readwrite) WAlertActionStyle  style;
@property (nonatomic,assign   ) NSUInteger         tag;
@property (nonatomic,copy     ) void(^handler)(WAlertAction *);

@end

@implementation WAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(WAlertActionStyle)style handler:(void (^)(WAlertAction * _Nullable))handler {
    WAlertAction *action = [[WAlertAction alloc] init];
    action.style = style;
    action.handler = handler;
    action.title = title;
    action.enabled = YES;
    
    return action ;
}

@end

@interface WAlertView () {
    BOOL _isShow;
}

@property (nonatomic, strong) UIView    *backgroundView;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UILabel   *messageLabel;

@property (nonatomic, readwrite) NSMutableArray<WAlertAction *> *alertActions;
@property (nonatomic, strong)  NSMutableArray<UIButton *> *actionButtons ;
@property (nonatomic, readwrite) WAlertViewStyle preferredStyle;

@end

@implementation WAlertView

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(WAlertViewStyle)preferredStyle {
    WAlertView *alertView = [[WAlertView alloc] init];
    alertView.title = title;
    alertView.message = message ;
    alertView.preferredStyle = preferredStyle ;
    
    return alertView ;
}

- (void)addAction:(WAlertAction *)action {
    if (!self.alertActions) {
        self.alertActions = [NSMutableArray array];
    }
    action.tag = self.alertActions.count + kActionButtonTag;
    [self.alertActions addObject:action];
}

- (NSArray<WAlertAction*> *)actions {
    return self.alertActions;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadContentView];
    }
    
    return self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint current = [touch locationInView:self];
    if (!CGRectContainsPoint(self.backgroundView.frame, current)) {
        if (self.isShouldDismiss) {
            [self hide];
        }
    }
}

- (void)loadContentView {
    _isShow = NO;
    self.shouldDismiss = YES;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    [self addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.titleLabel];
    [self.backgroundView addSubview:self.messageLabel];
}

- (void)addActionButtons {
    if (!self.actionButtons) {
        self.actionButtons = [NSMutableArray arrayWithCapacity:self.actions.count];
    }
    for (WAlertAction *action in self.actions) {
        UIButton *button = [self makeActionButton:action];
        [self.backgroundView addSubview:button];
        [self.actionButtons addObject:button];
    }
}

- (void)show {
    if (_isShow) {
        return ;
    }
    _isShow = YES;
    self.titleLabel.text = self.title;
    self.messageLabel.text = self.message;
    [self addActionButtons];
    [self updateCustomConstraints];
    [self addToWindow];
    
    if (self.preferredStyle == WAlertViewStyleAlert) {
        [self applayAnimationAlertIn:self.backgroundView];
    } else {
        [self applayAnimationActionSheetIn:self.backgroundView];
    }
}

- (void)hide {
    if (!_isShow) {
        return ;
    }
    if (self.preferredStyle == WAlertViewStyleAlert) {
        [self applayAnimationAlertOut:self.backgroundView];
    } else {
        [self applayAnimationActionSheetOut:self.backgroundView];
    }
    
    _isShow = NO;
}

- (void)onActionClick:(UIButton *)sender {
    WAlertAction *action = self.actions[sender.tag - kActionButtonTag];
    if (action.handler) {
        action.handler(action);
    }
    
    if(action.style == WAlertActionStyleCancel){
        [self hide];
    }
    
}

#pragma mark - constraints
- (void)updateCustomConstraints {
    UIView  *lastView = nil;
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat width = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect));
    if (self.preferredStyle == WAlertViewStyleAlert) {
        width = width * 0.65 ;
    }
    
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO ;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    if (self.preferredStyle == WAlertViewStyleAlert) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    } else {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    
    
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30]];
    lastView = self.titleLabel ;
    
    if (self.message.length > 0) {
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        CGSize size = [self.message boundingRectWithSize:CGSizeMake(width , HUGE_VAL) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:size.height]];
        lastView = self.messageLabel ;
    }
    
    if (self.actionButtons.count <= kDefaultButtonCount) {
        if (self.actionButtons.count > 0) {
            [self updateHConstaintButtons:self.actionButtons upItem:lastView];
            
            lastView = [self.actionButtons lastObject];
        }
        
    } else {
        [self updateVConstaintButtons:self.actionButtons upItem:lastView];
        lastView = [self.actionButtons lastObject];
    }
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1 constant:kDefaultButtonMargin]];
    
    [self setNeedsUpdateConstraints];
}

- (void)addToWindow {
    [self.window addSubview:self];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.window addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.window addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.window addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.window addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}

- (void)updateHConstaintButtons:(NSArray *)buttons upItem:(UIView *)upView{
    
    NSMutableString  *hFormat = [@"H:|" mutableCopy];
    [hFormat appendFormat:@"-(%f)-",kDefaultButtonMargin];
    NSMutableDictionary  *viewDict = [NSMutableDictionary dictionary];
    NSInteger i = 0;
    for (UIButton *button in buttons) {
        
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        if (i == 0) {
            [hFormat appendString:[NSString stringWithFormat:@"[view%ld]",i]];
        } else {
            [hFormat appendString:[NSString stringWithFormat:@"-10-[view%ld(view%ld)]",i,i-1]];
        }
        
        [viewDict setObject:button forKey:[NSString stringWithFormat:@"view%ld",i]];
        i++;
    }
    
    [hFormat appendFormat:@"-(%f)-|",kDefaultButtonMargin];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:hFormat options:NSLayoutFormatAlignAllCenterY | NSLayoutAttributeHeight metrics:nil views:viewDict]];
    
    [self.backgroundView addConstraints:array];
    
    NSLayoutConstraint *firstItem = [NSLayoutConstraint constraintWithItem:buttons[0] attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:upView attribute:NSLayoutAttributeBottom multiplier:1 constant:kDefaultButtonMargin];
    [self.backgroundView addConstraint:firstItem];
    
}

- (void)updateVConstaintButtons:(NSArray *)buttons upItem:(UIView *)upView{
    
    NSMutableString  *hFormat = [@"V:" mutableCopy];
    NSMutableDictionary  *viewDict = [NSMutableDictionary dictionary];
    NSInteger i = 0;
    for (UIButton *button in buttons) {
        
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        if (i == 0) {
            [hFormat appendString:[NSString stringWithFormat:@"[view%ld]",i]];
        } else {
            [hFormat appendString:[NSString stringWithFormat:@"-5-[view%ld(view%ld)]",i,i-1]];
        }
        
        [viewDict setObject:button forKey:[NSString stringWithFormat:@"view%ld",i]];
        i++;
    }
    
    [hFormat appendFormat:@"-(%f)-|",kDefaultButtonMargin];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:hFormat options:NSLayoutFormatAlignAllCenterX | NSLayoutAttributeWidth metrics:nil views:viewDict]];
    
    [self.backgroundView addConstraints:array];
    
    NSLayoutConstraint *firstItem = [NSLayoutConstraint constraintWithItem:buttons[0] attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:upView attribute:NSLayoutAttributeBottom multiplier:1 constant:kDefaultButtonMargin];
    [self.backgroundView addConstraint:firstItem];
    [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[view]-(margin)-|" options:NSLayoutFormatAlignAllLeading metrics:@{@"margin":@(kDefaultButtonMargin)} views:@{@"view":buttons[0]}]];
    
}

#pragma mark - animations
- (void)applayAnimationAlertIn:(UIView *)view {
    view.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.transform = CGAffineTransformIdentity ;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)applayAnimationAlertOut:(UIView *)view {

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        view.transform = CGAffineTransformMakeScale(0.2, 0.2) ;
        
    } completion:^(BOOL finished) {
        view.transform = CGAffineTransformIdentity ;
        [self removeFromSuperview];
    }];
}

- (void)applayAnimationActionSheetIn:(UIView *)view {
    [self layoutIfNeeded];
    view.transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.transform = CGAffineTransformIdentity ;
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)applayAnimationActionSheetOut:(UIView *)view {
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        view.transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
        
    } completion:^(BOOL finished) {
        view.transform = CGAffineTransformIdentity ;
        [self removeFromSuperview];
    }];
}

#pragma mark - getter/setter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter ;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping ;
    }
    
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont systemFontOfSize:15];
        _messageLabel.textColor = [UIColor blackColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter ;
    }
    
    return _messageLabel;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        _backgroundView.layer.cornerRadius = 5.;
        _backgroundView.layer.masksToBounds = YES;
    }
    
    return _backgroundView;
}

- (UIButton *)makeActionButton:(WAlertAction *)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:action.title forState:UIControlStateNormal];
    if (action.style == WAlertActionStyleCancel) {
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    } else {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(onActionClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = action.tag ;
   
    return button ;
}

#pragma mark -
- (UIWindow *)window {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    return window ;
}

@end
