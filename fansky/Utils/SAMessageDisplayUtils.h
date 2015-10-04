//
//  SAMessageDisplayUtils.h
//  fansky
//
//  Created by Zzy on 9/17/15.
//  Copyright © 2015 Zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAMessageDisplayUtils : NSObject

+ (void)showProgressWithMessage:(NSString *)message;
+ (void)showSuccessWithMessage:(NSString *)message;
+ (void)showErrorWithMessage:(NSString *)message;
+ (void)dismiss;

@end
