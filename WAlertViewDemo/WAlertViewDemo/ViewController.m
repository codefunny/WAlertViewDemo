//
//  ViewController.m
//  WAlertViewDemo
//
//  Created by wenchao on 16/1/31.
//  Copyright © 2016年 wenchao. All rights reserved.
//

#import "ViewController.h"
#import "WAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = CGRectMake(10, 30, 80, 40);
    [button setTitle:@"alert" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onAlertClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 101;
    [self.view addSubview:button];
    
    UIButton *button1 = ({
        UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
        btn.frame = CGRectMake(90, 30, 120, 40);
        [btn setTitle:@"actionsheet" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onAlertClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 102;
        btn ;
    });
    [self.view addSubview:button1];
    
    UIButton *button2 = ({
        UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 80, 80, 40);
        [btn setTitle:@"alert1" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onAlertClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 103;
        btn ;
    });
    [self.view addSubview:button2];
    
    UIButton *button3 = ({
        UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
        btn.frame = CGRectMake(90, 80, 120, 40);
        [btn setTitle:@"actionsheet1" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onAlertClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 104;
        btn ;
    });
    [self.view addSubview:button3];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(10, 150, self.view.bounds.size.width - 20, 300);
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont systemFontOfSize:12];
    textView.text = @"参照UIAlertController的接口改造，继承自UIView \n \
        使用说明：\n\
    WAlertView *view = [WAlertView alertViewWithTitle:@\"hello\" message:@\"今天是2016年\" preferredStyle:style]; \n\
    WAlertAction *action = [WAlertAction actionWithTitle:@\"button1\" style:WAlertActionStyleDefault handler:^(WAlertAction * _Nullable action) { \n\
        NSLog(@\"hahhahaha\"); \n\
    }]; \n\
    [view addAction:action]; \n\
    [view addAction:action1]; \n\
    [view addAction:action2]; \n\
    [view addAction:action3]; \n\
    view.shouldDismiss = dismiss ; \n\
    [view show]; \n\
    ";
    textView.scrollEnabled = YES;
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onAlertClick:(UIButton *)sender {
    if (sender.tag == 101) {
        [self onAlertClickWithStyle:WAlertViewStyleAlert dismiss:NO];
    } else if(sender.tag == 102){
        [self onAlertClickWithStyle:WAlertViewStyleActionSheet dismiss:NO];
    } else if (sender.tag == 103) {
        [self onAlertClickWithStyle:WAlertViewStyleAlert dismiss:YES];
    } else if(sender.tag == 104) {
        [self onAlertClickWithStyle:WAlertViewStyleActionSheet dismiss:YES];
    }
}

- (void)onAlertClickWithStyle:(WAlertViewStyle)style dismiss:(BOOL)dismiss{
    WAlertView *view = [WAlertView alertViewWithTitle:@"hello" message:@"今天是2016年" preferredStyle:style];
    
    WAlertAction *action = [WAlertAction actionWithTitle:@"button1" style:WAlertActionStyleDefault handler:^(WAlertAction * _Nullable action) {
        NSLog(@"hahhahaha");
    }];
    WAlertAction *action1 = [WAlertAction actionWithTitle:@"button2" style:WAlertActionStyleDefault handler:^(WAlertAction * _Nullable action) {
        NSLog(@"hahhahaha");
    }];
    WAlertAction *action2 = [WAlertAction actionWithTitle:@"button3" style:WAlertActionStyleDefault handler:^(WAlertAction * _Nullable action) {
        NSLog(@"hahhahaha");
    }];
    WAlertAction *action3 = [WAlertAction actionWithTitle:@"cancel" style:WAlertActionStyleCancel handler:^(WAlertAction * _Nullable action) {
        NSLog(@"hahhahaha1");
    }];
    [view addAction:action];
    [view addAction:action1];
    [view addAction:action2];
    [view addAction:action3];
    view.shouldDismiss = dismiss ;
    [view show];
}

@end
