//
//  FingerprintTool.m
//  FingerprintTool
//
//  Created by ifenghui on 2018/8/27.
//  Copyright © 2018年 ifenghui. All rights reserved.
//

#import "FingerprintTool.h"

#import <LocalAuthentication/LocalAuthentication.h>

@implementation FingerprintTool
/**
 请求指纹,默认模式
 只有结果,非自定义
 */
+ (void)fingerprintVerification:(FingerprintResultBlock)resultBlock {
    [self fingerprintVerificationWithLocalizedReason:@"需要指纹用来解锁"
                                     fingerprintType:FingerprintTool_OnlyFinger
                                         resultBlock:resultBlock];
}

/**
 请求指纹
 自定义请求原因
 
 @param localizedReason 请求原因
 @param fingerprintType 指纹类型(纯指纹or指纹和密码) iOS<9 只支持纯指纹解锁
 */
+ (void)fingerprintVerificationWithLocalizedReason:(NSString *)localizedReason
                                   fingerprintType:(FingerprintToolType)fingerprintType
                                       resultBlock:(FingerprintResultBlock)resultBlock {
    [self fingerprintVerificationWithLocalizedReason:localizedReason
                                      fallbackString:@"使用指纹失败"
                                     fingerprintType:fingerprintType
                                         resultBlock:resultBlock];
}

/**
 请求指纹
 自定义:
 1.请求原因
 2.失败返回提示
 
 @param localizedReason 请求原因
 @param fallbackString 失败返回提示
 @param fingerprintType 指纹类型(纯指纹or指纹和密码) iOS<9 只支持纯指纹解锁
 */
+ (void)fingerprintVerificationWithLocalizedReason:(NSString *)localizedReason
                                    fallbackString:(NSString *)fallbackString
                                   fingerprintType:(FingerprintToolType)fingerprintType
                                       resultBlock:(FingerprintResultBlock)resultBlock {
    LAPolicy policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    
    if (@available(iOS 9.0, *)) {
        switch (fingerprintType) {
            case FingerprintTool_OnlyFinger:
                policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
                break;
            case FingerprintTool_FingerAndPassword:
                policy = LAPolicyDeviceOwnerAuthentication;
                break;
        }
    } else {
        NSLog(@"指纹和密码的解锁模式,只支持系统版本大于或者等于9.0");
    }

    LAContext *context = [LAContext new];
    NSError *error = NULL;
    __weak typeof(self) WS = self;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:localizedReason
                          reply:^(BOOL success, NSError * _Nullable error) {
                              if (resultBlock) {
                                  NSString *resultString = [WS referenceError:error fallbackString:fallbackString];
                                  resultBlock(success, resultString);
                              }
                          }];
    } else {
        if (resultBlock) {
            resultBlock(NO, @"不支持指纹");
        }
    }
}

#pragma mark 返回错误参考信息
+ (NSString *)referenceError:(NSError *)error fallbackString:(NSString *)fallbackString {
    switch (error.code) {
        case LAErrorAuthenticationFailed:
            return @"授权失败";
            break;
        case LAErrorUserCancel:
            return @"用户取消验证Touch ID";
            break;
        case LAErrorUserFallback:
            return fallbackString;
            break;
        case LAErrorSystemCancel:
            return @"系统取消授权，如其他APP切入";
            break;
        case LAErrorPasscodeNotSet:
            return @"系统未设置密码";
            break;
        case LAErrorTouchIDNotAvailable:
            return @"设备Touch ID不可用，例如未打开";
            break;
        case LAErrorTouchIDNotEnrolled:
            return @"设备Touch ID不可用，用户未录入";
            break;
        case LAErrorTouchIDLockout:
            return @"身份验证未成功,多次使用Touch ID失败";
            break;
        case LAErrorAppCancel:
            return @"认证被取消的应用";
            break;
        case LAErrorInvalidContext:
            return @"授权对象失效";
            break;
        case LAErrorNotInteractive:
            return @"APP未完全启动,调用失败";
            break;
            
        default:
            return @"验证成功";
            break;
    }
}
@end
