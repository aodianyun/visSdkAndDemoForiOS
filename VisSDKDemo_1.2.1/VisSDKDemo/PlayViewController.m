//
//  PlayViewController.m
//  VisSDKDemo
//
//  Created by Mac on 15/11/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
#import <UIKit/UIGestureRecognizer.h>
#import "PlayViewController.h"
#import "VisSDK.h"

@interface PlayViewController ()<VisSDKDelegate>
@property (strong, nonatomic) VisSDK* visClient;
@property (weak, nonatomic) IBOutlet UIView *playView;
- (IBAction)startBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@end

@implementation PlayViewController
{
    BOOL _bPlaying;
    // 添加手势操作
    UISwipeGestureRecognizer* recognizer;
    BOOL _bShowLog;
    NSMutableArray *array;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建对象
    _visClient = [[VisSDK alloc] init];
    _visClient.delegate = self;
    //设置参数
    [_visClient setApp:_app andStream:_stream andPassword:_password andUid:_uid];
    // 清空logTextView背景
    [_logTextView setBackgroundColor: [UIColor clearColor]];
    // 设置日志view不可编辑
    self.logTextView.editable = false;
    // 优化滚动闪
    self.logTextView.layoutManager.allowsNonContiguousLayout = NO;
    
    [_logTextView setTextColor:[UIColor redColor]];
    //[self.logTextView setAlpha:0.0];

    _bPlaying = false;
//    //开始播放
//    [_visClient startPlay];
    

    // handleSwipeFrom 是偵測到手势，所要呼叫的方法
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    // 不同的 Recognizer 有不同的实体变数
    // 例如 SwipeGesture 可以指定方向
    // 而 TapGesture 則可以指定次數
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:recognizer];
    // 初始化消息数组
    array = [NSMutableArray array];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //设置视图
    [_visClient.playView removeFromSuperview];
    _visClient.playView.frame = _playView.bounds;
    [_playView addSubview:_visClient.playView];
}
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //停止播放VIS合成画面
    //[_visClient stopPlay];
    //释放资源
    [_visClient shutdown];
     // 底下是刪除手势的方法
    [self.view removeGestureRecognizer:recognizer];
}

- (void)onEventCallback:(int)event msg:(NSString *)msg
{
    if (_bShowLog) {
        self.logTextView.text = [self limitLog:50 lastLog:msg];
        [_logTextView scrollRangeToVisible:NSMakeRange(_logTextView.text.length, 1)];
    }
}

- (IBAction)startBtn:(id)sender {

    if (_bPlaying) {
        [_visClient stopPlay];
        _bPlaying  = false;
        [(UIButton*)sender setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }else{
        [_visClient startPlay];
        _bPlaying = true;
        [(UIButton*)sender setBackgroundImage:[UIImage imageNamed:@"stopplay.png"] forState:UIControlStateNormal];
    }
}


- (void)handleSwipeFrom:(UISwipeGestureRecognizer*) trecognizer {
    // 触发手勢事件后，在这里作些事情
    if (_bShowLog) {
        [UIView animateWithDuration:1.0 animations:^{
            [self.logTextView setAlpha:0.0];
        } completion:^(BOOL finished) {
            _bShowLog = false;
        }];
    }else{
        [UIView animateWithDuration:1.0 animations:^{
            [self.logTextView setAlpha:1.0];
        } completion:^(BOOL finished) {
            _bShowLog = true;
        }];
    }
}

- (NSString *)limitLog:(int) logNum lastLog:(NSString *) log
{
    if ([array count] > logNum) {
        [array removeObjectAtIndex:0];
    }
    [array addObject:log];
    
    return  [array componentsJoinedByString:@"\n"];
}

@end
