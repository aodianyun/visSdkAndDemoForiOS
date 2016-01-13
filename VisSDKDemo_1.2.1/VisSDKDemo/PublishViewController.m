//
//  PublishViewController.m
//  VisSDKDemo
//
//  Created by Mac on 15/11/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PublishViewController.h"
#import "BigSmallView.h"
#import "VisSDK.h"

@interface PublishViewController ()<VisSDKDelegate>
@property (strong, nonatomic) VisSDK* visClient;
@property (nonatomic,assign) BOOL micEnable;
@property (nonatomic,assign) BOOL flashEnable;
@property (nonatomic,assign) BOOL isBusy;
@property (weak, nonatomic) IBOutlet BigSmallView* displayView;
@property (weak, nonatomic) IBOutlet UIButton *flashBtn;
@property (weak, nonatomic) IBOutlet UIButton *micBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@end

@implementation PublishViewController
{
    NSMutableString *_ms;
    NSString *_msgString;
    // 添加手势操作
    UISwipeGestureRecognizer* recognizer;
    BOOL _bShowLog;
    NSMutableArray *array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建对象
    _visClient = [[VisSDK alloc] init];
    [_visClient setDelegate:self];
    //设置参数
    [_visClient setApp:_app andStream:_stream andPassword:_password andUid:_uid];
    //关联视图
    _displayView.firstView = _visClient.preview;    //发布预览显示的视图
    _displayView.secondView = _visClient.playView;  //播放显示的视图
    //开始发布预览
    [_visClient startPreviewWithCamera:NO];
    // 清空logTextView背景
    [_logTextView setBackgroundColor: [UIColor clearColor]];
    // 设置日志view不可编辑
    self.logTextView.editable = false;
    // 优化滚动闪
    self.logTextView.layoutManager.allowsNonContiguousLayout = NO;
    
    [_logTextView setTextColor:[UIColor redColor]];
    //[self.logTextView setAlpha:0.0];
    // 拼接日志string的对象
    _ms = [[NSMutableString alloc] init];
    
    // handleSwipeFrom 是偵測到手势，所要呼叫的方法
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    // 不同的 Recognizer 有不同的实体变数
    // 例如 SwipeGesture 可以指定方向
    // 而 TapGesture 則可以指定次數
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:recognizer];
    
    array = [NSMutableArray array];
}
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //释放资源
    [_visClient shutdown];
    //删除手势
    [self.view removeGestureRecognizer:recognizer];
}
#pragma mark - 同时播放、发布
- (IBAction) playAndPublishBtnClick:(UIButton *)sender
{
    if (_isBusy) return;
    [_visClient flushIpForPlayOnsuccess:^{
        [self startVis];
    } onError:^(int errCode, NSString *message) {
        [self startVis];
    }];
}

- (void) startVis
{
    if (!_visClient.isPublishing) {
        _isBusy= YES;
        //发布直播，并播放另一个画面
        [_visClient startPlayAndPubOnSuccess:^{
            [self alertMessage:@"publish success"];
            //设置预览画面为大视图
            [_displayView setFirstViewMajor];
            _startBtn.imageView.image = [UIImage imageNamed:@"stop"];
            _isBusy = NO;
        } onError:^(int errCode, NSString *message) {
            if (errCode == kConnectionError) {
                //http连接错误
                [self alertMessage:message];
            } else if (errCode == kPasswordError) {
                //密码错误
                [self alertMessage:message];
            } else if(errCode == kPublishConflict) {
                //发布冲突
                [self alertMessage:message];
            } else if (errCode == kRequestError) {
                //错误的内部http请求
                [self alertMessage:message];
            } else {
                //发布失败 kPublishFailed
                [self alertMessage:message];
            }
            _isBusy = NO;
        } withFlag:0];
    } else {
        _isBusy = YES;
        //停止直播和播放
        [_visClient stopPlayAndPubOnSuccess:^{
            [self alertMessage:@"stoped publish"];
            _startBtn.imageView.image = [UIImage imageNamed:@"start"];
            _isBusy = NO;
        }];
    }
}

#pragma mark - 以下是一些辅助功能
- (IBAction) changeBtnClick:(UIButton *)sender
{
    //切换大小视图
    [_displayView switchMajorView];
}
- (IBAction) micBtnClick:(UIButton *)sender {
    [_visClient setMicEnable:_micEnable];
    if (_micEnable) {
        [_micBtn setBackgroundImage:[UIImage imageNamed:@"micOff"] forState:UIControlStateNormal];
    } else {
        [_micBtn setBackgroundImage:[UIImage imageNamed:@"micOn"] forState:UIControlStateNormal];
    }
    [self alertMessage:[NSString stringWithFormat:@"%d",(int)_micEnable]];
    _micEnable = !_micEnable;
}
- (IBAction) camBtnClick:(UIButton *)sender {
    [_visClient switchCamera];
}
- (IBAction) flashBtnClick:(UIButton *)sender {
    _flashEnable = !_flashEnable;
    [_visClient setFlashEnable:_flashEnable];
    if (_flashEnable) {
        [_flashBtn setBackgroundImage:[UIImage imageNamed:@"cameraFlashOff"] forState:UIControlStateNormal];
    } else {
        [_flashBtn setBackgroundImage:[UIImage imageNamed:@"cameraFlashOn"] forState:UIControlStateNormal];
    }
    [self alertMessage:[NSString stringWithFormat:@"%d",(int)_flashEnable]];
}

- (void)onEventCallback:(int)event msg:(NSString *)msg
{
    if (_bShowLog) {
        self.logTextView.text = [self limitLog:50 lastLog:msg];
        [_logTextView scrollRangeToVisible:NSMakeRange(_logTextView.text.length, 1)];
    }
}

/*
- (IBAction) getMicState:(UIButton *)sender {
    //获取上麦情况
    [_visClient fetchMicState:^(int state) {
        NSString* str = [NSString stringWithFormat:@"第1个麦:%d,第2个麦:%d",state&1,(state>>1)&1];
        [self alertMessage:str];
    } onError:^(int errCode, NSString *message) {
        if (errCode == kConnectionError) {
            //连接错误
            [self alertMessage:message];
        } else if(errCode == kPasswordError) {
            //密码错误
            [self alertMessage:message];
        } else {
            //请求错误 kRequestError
            [self alertMessage:message];
        }
    }];
}
- (IBAction) denoiseBtnClick:(UIButton *)sender {
    static BOOL denoise;
    denoise = !denoise;
    //消除背景噪音
    [_visClient setDenoiseEnable:denoise];
    [self alertMessage:[NSString stringWithFormat:@"%d",(int)denoise]];
}*/
- (void) alertMessage:(NSString *) msg
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                              nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];
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
