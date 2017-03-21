//
//  UIImage+MitTest.m
//  MITAutoTest
//
//  Created by MENGCHEN on 2017/3/14.
//  Copyright © 2017年 HongtaiCaifu. All rights reserved.
//

#import "UIImage+MitTest.h"
#import "NSObject+MitTestSwizz.h"
@implementation UIImage (MitTest)


+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:[self class] origin:@selector(imageNamed:) new:@selector(mit_imageNamed:)];
    });
    
    
    
}

+ (UIImage *)mit_imageNamed:(NSString *)name{
    UIImage * image = [UIImage mit_imageNamed:name];
    image.accessibilityIdentifier = name;
    return image;
}

@end
