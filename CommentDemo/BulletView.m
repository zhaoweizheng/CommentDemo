//
//  BulletView.m
//  CommentDemo
//
//  Created by apple on 16/10/19.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import "BulletView.h"

#define  Padding 10

@interface BulletView ()

@property (nonatomic, strong) UILabel *lbComment;
@end

@implementation BulletView

//初始化弹幕
- (instancetype)initWithComment:(NSString *)comment {
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        
        NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        
        CGFloat width = [comment sizeWithAttributes: attr].width;
        self.bounds = CGRectMake(0, 0, width + 2 * Padding, 30);
        self.lbComment.text = comment;
        self.lbComment.frame = CGRectMake(Padding, 0, width, 30);
        
    }
    return self;
}

//开始动画
- (void)startAnimation {
    
    //根据弹幕长度执行动画效果
    //根据 v = s/t , 时间相同的情况下, 距离越长, 速度越快
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width; //屏幕宽度
    CGFloat duration = 4.0f;//弹幕从初始化到消失的时间
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds);//总宽度=屏幕宽度+弹幕宽度
    
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         frame.origin.x  -= wholeWidth;
                         self.frame = frame;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         
                         //回调告诉动画结束
                         if (self.moveStatusBlock) {
                             self.moveStatusBlock();
                         }
                     }];
}

//结束动画
- (void)stopAnimation {
    //移除动画
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

- (UILabel *)lbComment {
    if (_lbComment) {
        _lbComment = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbComment.font = [UIFont systemFontOfSize:14];
        _lbComment.textColor = [UIColor whiteColor];
        _lbComment.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbComment];
    }
    return _lbComment;
}

@end
