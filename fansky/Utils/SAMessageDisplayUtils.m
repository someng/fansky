//
//  SAMessageDisplayUtils.m
//  fansky
//
//  Created by Zzy on 9/17/15.
//  Copyright © 2015 Zzy. All rights reserved.
//

#import "SAMessageDisplayUtils.h"
#import <WSProgressHUD/WSProgressHUD.h>

@implementation SAMessageDisplayUtils

+ (void)showProgressWithMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [WSProgressHUD showWithStatus:message];
    });
}

+ (void)showSuccessWithMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [WSProgressHUD showSuccessWithStatus:message];
    });
}

+ (void)showErrorWithMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [WSProgressHUD showErrorWithStatus:message];
    });
}

+ (void)dismiss
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [WSProgressHUD dismiss];
    });
}

@end
