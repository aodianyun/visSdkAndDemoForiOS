//
//  PlayViewController.m
//  VisSDKDemo
//
//  Created by Mac on 15/11/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PlayViewController.h"
#import "VisSDK.h"

@interface PlayViewController ()
@property (strong, nonatomic) VisSDK* visClient;
@property (weak, nonatomic) IBOutlet UIView *playView;
@end

@implementation PlayViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建对象
    _visClient = [[VisSDK alloc] init];
    //设置参数
    [_visClient setApp:_app andStream:_stream andPassword:_password andUid:_uid];
    //开始播放
    [_visClient startPlay];
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
}
@end
