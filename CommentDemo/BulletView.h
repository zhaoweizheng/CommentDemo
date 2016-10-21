//
//  BulletView.h
//  CommentDemo
//
//  Created by apple on 16/10/19.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, Movestatus) {
    Start,
    Enter,
    End
};

@interface BulletView : UIView

@property (nonatomic, assign) int trajectory; //弹道
@property (nonatomic, copy) void(^ moveStatusBlock)(Movestatus status); //弹幕状态回调

//初始化弹幕
- (instancetype)initWithComment:(NSString *)comment;

//开始动画
- (void)startAnimation;

//结束动画
- (void)stopAnimation;

@end
