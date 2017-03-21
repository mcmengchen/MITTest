//
//  UIView+MitTest.m
//  MITAutoTest
//
//  Created by MENGCHEN on 2017/3/14.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import "UIView+MitTest.h"
#import "NSObject+MitTestSwizz.h"
#import "UIResponder+MitTest.h"
#import "MitAutoTestHandle.h"
@implementation UIView (MitTest)


+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzleMethod:[self class] origin:@selector(accessibilityIdentifier) new:@selector(mit_accessibilityIdentifier)];
        [self swizzleMethod:[self class] origin:@selector(accessibilityLabel) new:@selector(mit_accessibilityLabel)];
        [self swizzleMethod:[self class] origin:@selector(addSubview:) new:@selector(mit_addSubview:)];
        
    });
    
    
}
- (NSString *)mit_accessibilityIdentifier{
    NSString * accessibilityIdentifier = [self mit_accessibilityIdentifier];
    if (accessibilityIdentifier.length>0&&[[accessibilityIdentifier substringToIndex:1] isEqualToString:@"("]) {
        return accessibilityIdentifier;
    }else if ([accessibilityIdentifier isEqualToString:@"null"]){
        accessibilityIdentifier = @"";
    }
    NSString * labelStr = [self.superview findNameWithInstance:self];
    if (labelStr && ![labelStr isEqualToString:@""]) {
        labelStr = [NSString stringWithFormat:@"(%@)",labelStr];
    }else{
        if ([self isKindOfClass:[UILabel class]]) {
            labelStr = [NSString stringWithFormat:@"(%@)",((UILabel*)self).text?:@""];
        }else if ([self isKindOfClass:[UIImageView class]]){
            labelStr = [NSString stringWithFormat:@"(%@%@)",((UIButton*)self).titleLabel.text?:@"",((UIButton *)self).imageView.image.accessibilityIdentifier?:@""];
        }else if (accessibilityIdentifier) {// 已有 label，则在此基础上再次添加更多信息
            labelStr = [NSString stringWithFormat:@"(%@)",accessibilityIdentifier];
        }
        if ([self isKindOfClass:[UIButton class]]) {
            self.accessibilityValue = [NSString stringWithFormat:@"(%@)",((UIButton *)self).currentBackgroundImage.accessibilityIdentifier?:@""];
        }
        if ([labelStr isEqualToString:@"()"] || [labelStr isEqualToString:@"(null)"] || [labelStr isEqualToString:@"null"]) {
            labelStr = @"";
        }
    }
    [self setAccessibilityIdentifier:labelStr];
    return labelStr;
}


- (NSString *)mit_accessibilityLabel
{
    if ([self isKindOfClass:[UIImageView class]]) {//UIImageView 特殊处理
        NSString *name = [self.superview findNameWithInstance:self];
        if (name) {
            self.accessibilityIdentifier = [NSString stringWithFormat:@"(%@)",name];
        }
        else {
            self.accessibilityIdentifier = [NSString stringWithFormat:@"(%@)",((UIImageView *)self).image.accessibilityIdentifier?:[NSString stringWithFormat:@"image%ld",(long)((UIImageView *)self).tag]];
        }
    }
    if ([self isKindOfClass:[UITableViewCell class]]) {//UITableViewCell 特殊处理
        self.accessibilityIdentifier = [NSString stringWithFormat:@"(%@)",((UITableViewCell *)self).reuseIdentifier];
    }
    return [self mit_accessibilityLabel];
}



-(void)mit_addSubview:(UIView *)view{
    if (!view) {
        return;
    }
    [self mit_addSubview:view];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.delegate = [MitAutoTestHandle sharedManager];
    [self addGestureRecognizer:longPress];
    
}



@end
