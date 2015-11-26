//
//  VisSDK.h
//  VisSDKDemo
//
//  Created by Mac on 15/10/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//  当前SDK版本是 1.2

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kConnectionError   -100
#define kRequestError      -101
#define kPublishConflict   -102
#define kPasswordError     -103
#define kInvalidOperation  -104
#define kPublishFailed     2002

typedef void (^VisSuccessCallback)(void);
typedef void (^VisErrorCallback)(int errCode,NSString* message);

@protocol  VisSDKDelegate <NSObject>
@optional
//发布过程中，发生错误
- (void) onPublishingError:(NSString*) msg;
//未知的事件
- (void) onUnknownEvent:(int) event message:(NSString*) msg;
@end

@interface VisSDK : NSObject
@property (nonatomic, weak) id<VisSDKDelegate> delegate;
@property (nonatomic, strong, readonly) UIView* playView;
@property (nonatomic, strong, readonly) UIView* preview;
@property (nonatomic, assign) UIViewContentMode contentMode;
@property (nonatomic, assign) int bufferTime;
//获取当前状态的一些属性
@property (nonatomic, assign, readonly) BOOL isPreviewing;   //是否正在预览
@property (nonatomic, assign, readonly) BOOL isPlaying;     //是否正在播放
@property (nonatomic, assign, readonly) BOOL isPublishing;  //是否正在发布

//设置app、stream、password
- (void) setApp:(NSString*) app andStream:(NSString*) stream andPassword:(NSString*) pwd andUid:(int) uid;

//开启发布预览、关闭发布预览.需要发布前，请先开启预览。参数表示是否使用前置摄像头
- (void) startPreviewWithCamera:(BOOL) isFront;
- (void) stopPreview;

//同时启动发布和播放。会判断能不能上麦，如果能，开始播放和发布,并回调success; 不能则回调callback。flag通常传0,会自动根据空闲麦发布。
- (void) startPlayAndPubOnSuccess:(VisSuccessCallback) success onError:(VisErrorCallback) callback withFlag:(int) flag;
//同时关闭发布和播放，但不关闭预览。关闭完成后会回调success
- (void) stopPlayAndPubOnSuccess:(VisSuccessCallback) success;

//仅仅启动播放,播放VIS合成画面
- (void) startPlay;
- (void) stopPlay;

//切换摄像头
- (int) switchCamera;
//开启背景噪音消除，软件消除算法，有一定CPU消耗
- (int) setDenoiseEnable:(BOOL)denoise;
//打开/关闭麦克风
- (int) setMicEnable:(BOOL)micEnable;
//打开/关闭摄像头
- (int) setCamEnable:(BOOL)camEnable;
//打开/关闭闪关灯
- (int) setFlashEnable:(BOOL)flashEnable;

//获取当前上麦情况。state的第0位代表第一个麦，0表示没有上麦，1表示有人上麦。同理，state的第1位表示第二个麦的情况。
- (void) fetchMicState:(void (^)(int state)) success onError:(VisErrorCallback) callback;

//释放资源
- (void) shutdown;
@end
