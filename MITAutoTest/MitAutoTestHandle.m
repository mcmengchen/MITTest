//
//  MitAutoTestHandle.m
//  MITAutoTest
//
//  Created by MENGCHEN on 2017/3/14.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import "MitAutoTestHandle.h"
#import <UIKit/UIKit.h>
@interface MitAutoTestHandle()<UIGestureRecognizerDelegate>

@end

@implementation MitAutoTestHandle

+(instancetype)sharedManager{
    static MitAutoTestHandle * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager  = [[self alloc]init];
    });
    return manager;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    if ([otherGestureRecognizer.view isDescendantOfView:gestureRecognizer.view]) {
        return true;
    }
    if (![otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        
        return true;
    }
    return false;
    
    
}




@end
