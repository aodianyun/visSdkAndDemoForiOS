//
//  ViewController.m
//  VisSDKDemo
//
//  Created by AodianYun on 15/10/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "BigSmallView.h"
#import "VisSDK.h"

#define RTMPDEMO @"rtmp://1028.lssplay.aodianyun.com/live_1433/1430725218"

@interface ViewController ()
@property (strong, nonatomic) VisSDK* visClient;
@property (weak, nonatomic) IBOutlet BigSmallView* displayView;
@property (weak, nonatomic) IBOutlet UIButton *stopMixPlayBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopPlayAndPubBtn;
@end

@implementation ViewController
- (void) dealloc
{
    NSLog(@"ViewController.dealloc: %p",self);
}
- (void) viewDidLoad
{
    [super viewDidLoad];
    //创建对象
    _visClient = [[VisSDK alloc] init];
    //设置参数，这里请把...替换成具体的参数，uid填写正确地uid
    [_visClient setApp:@"..." andStream:@"..." andPassword:@"..." andUid:-1];
    //关联视图
    _displayView.firstView = _visClient.preview;
    _displayView.secondView = _visClient.playView;
    //开始发布预览
    [_visClient startPreviewWithCamera:NO];
}
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //释放资源
    [_visClient shutdown];
}
#pragma mark -
- (IBAction) changeBtnClick:(UIButton *)sender
{
    //切换大小视图
    [_displayView switchMajorView];
}
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
#pragma mark - 播放合成画面
- (IBAction) playMixBtnClick:(UIButton *)sender
{
    //播放合成画面
    [_visClient startPlay];
    [_displayView setSecondViewMajor];
    _stopMixPlayBtn.userInteractionEnabled = YES;
    _stopPlayAndPubBtn.userInteractionEnabled = NO;
}
- (IBAction) stopPlayMixBtnClick:(UIButton *)sender
{
    //停止播放合成画面
    [_visClient stopPlay];
}
#pragma mark - 同时播放、发布
- (IBAction) playAndPublishBtnClick:(UIButton *)sender
{
    //发布直播，并播放另一个画面
    [_visClient startPlayAndPubOnSuccess:^{
        [self alertMessage:@"publish success"];
        //设置预览画面为大视图
        [_displayView setFirstViewMajor];
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
    } withFlag:0];
    _stopMixPlayBtn.userInteractionEnabled = NO;
    _stopPlayAndPubBtn.userInteractionEnabled = YES;
}
- (IBAction) stopPlayAndPubBtnClick:(UIButton *)sender
{
    //停止直播和播放
    [_visClient stopPlayAndPubOnSuccess:^{
        [self alertMessage:@"stoped publish"];
    }];
}
#pragma mark -
- (void) alertMessage:(NSString *) msg
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                              nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];
}
@end
