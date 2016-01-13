//
//  ViewController.m
//  VisSDKDemo
//
//  Created by AodianYun on 15/10/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "PublishViewController.h"
#import "PlayViewController.h"

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *appTxt;
@property (weak, nonatomic) IBOutlet UITextField *streamTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UITextField *uidTxt;
@end

@implementation ViewController

- (IBAction)startPublishBtnClick:(UIButton *)sender {
    PublishViewController* ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"PublishViewController"];
    ctrl.app = _appTxt.text;
    ctrl.stream = _streamTxt.text;
    ctrl.password = _passwordTxt.text;
    ctrl.uid = [_uidTxt.text intValue];
    [self.navigationController pushViewController:ctrl animated:YES];
}
- (IBAction)startPlayBtnClick:(UIButton *)sender {
    PlayViewController* ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayViewController"];
    ctrl.app = _appTxt.text;
    ctrl.stream = _streamTxt.text;
    ctrl.password = _passwordTxt.text;
    ctrl.uid = [_uidTxt.text intValue];
    [self.navigationController pushViewController:ctrl animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
