//
//  UIResponder+MitTest.h
//  MITAutoTest
//
//  Created by MENGCHEN on 2017/3/14.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (MitTest)
- (NSString *)findNameWithInstance:(UIView *) instance;
-(NSString *)nameWithInstance:(id)instance ;
@end
