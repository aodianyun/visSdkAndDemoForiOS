//
//  PublishViewController.h
//  VisSDKDemo
//
//  Created by Mac on 15/11/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishViewController : UIViewController
@property (nonatomic,copy) NSString* app;
@property (nonatomic,copy) NSString* stream;
@property (nonatomic,copy) NSString* password;
@property (nonatomic,assign) int uid;
@end
