//
//  FingerprintTool.h
//  FingerprintTool
//
//  Created by ifenghui on 2018/8/27.
//  Copyright © 2018年 ifenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FingerprintResultBlock)(BOOL isSuccess, NSString *resultString);

typedef enum : NSUInteger {
    // 只有指纹解锁(默认)
    FingerprintTool_OnlyFinger,
    // 指纹解锁和密码解锁
    FingerprintTool_FingerAndPassword,
} FingerprintToolType;

@interface FingerprintTool : NSObject
/**
 请求指纹,默认模式
 只有结果,非自定义
 */
+ (void)fingerprintVerification:(FingerprintResultBlock)resultBlock;

/**
 请求指纹
 自定义请求原因

 @param localizedReason 请求原因
 @param fingerprintType 指纹类型(纯指纹or指纹和密码) iOS<9 只支持纯指纹解锁
 */
+ (void)fingerprintVerificationWithLocalizedReason:(NSString *)localizedReason
                                   fingerprintType:(FingerprintToolType)fingerprintType
                                       resultBlock:(FingerprintResultBlock)resultBlock;
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
                                       resultBlock:(FingerprintResultBlock)resultBlock;
@end
