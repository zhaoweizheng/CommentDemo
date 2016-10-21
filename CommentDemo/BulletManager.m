//
//  BulletManager.m
//  CommentDemo
//
//  Created by apple on 16/10/19.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"

@interface BulletManager ()

//弹幕的数据来源
@property (nonatomic, strong) NSMutableArray *dataSource;
//弹幕使用过程中的数组变量
@property (nonatomic, strong) NSMutableArray *bulletComments;
//存储弹幕view的数组变量
@property (nonatomic, strong) NSMutableArray *bulletViews;
@end

@implementation BulletManager
//弹幕开始执行
- (void)start {
    [self.bulletComments removeAllObjects];
    
    [self.bulletComments addObjectsFromArray:self.dataSource];
    NSLog(@"%@", self.bulletComments);
    [self initBulletComment];
}

//初始化弹幕, 随机分配弹幕轨迹
- (void)initBulletComment {
    //创建弹道数组
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@(1), @(2), @(3)]];
    for (int i = 0; i < 3; i++) {
        if (self.bulletComments.count >0) {
            //通过随机数获取到弹幕的轨迹
            NSInteger index = arc4random()%trajectorys.count;
            int trakectory = [[trajectorys objectAtIndex:index] intValue];
            [trajectorys removeObjectAtIndex:index];
            
            //从弹幕数组中逐一取出弹幕
            NSString *comment = [self.bulletComments firstObject];
            [self.bulletComments removeObjectAtIndex:0];
            
            //创建弹幕view
            [self createBulletView:comment tranjectory:trakectory];
        }
    }
}

/**
 *  创建弹道
 *
 *  @param comment     文本
 *  @param tranjectory 弹道
 */
- (void)createBulletView:(NSString *)comment tranjectory:(int)tranjectory {
    
    BulletView *view = [[BulletView alloc] initWithComment:comment];
    view.trajectory = tranjectory;
    [self.bulletViews addObject:view];
    __weak typeof (view) weakView = view;
    __weak typeof (self) myself = self;
    view.moveStatusBlock = ^(Movestatus status){
        switch (status) {
            case Start:{
                //弹幕开始进入屏幕, 将View加入弹幕管理的变量中bulletViews
                [myself.bulletViews addObject:weakView];
                break;
            }
            case Enter: {
                //弹幕完全进入屏幕, 判断是否还有其他内容, 如果有则在改弹幕轨迹中创建一个弹幕
                NSString *comment = [myself nextCommet];
                if (comment) {
                    [myself createBulletView:comment tranjectory:tranjectory]; //递归
                }
                 break;
            }
            case End: {
                //弹幕飞出屏幕后从BulletView中删除, 释放资源
                //if (myself.bulletViews containsObject:weakView) {
                    //[weakView stopAnimation];
                    
                //}
                break;
            }
                
                
            default:
                break;
        }
        
        //移除屏幕后销毁弹幕并释放资源
        [weakView stopAnimation];
        [myself.bulletViews removeObject:weakView];
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}

- (NSString *)nextCommet {
    if (self.bulletComments.count == 0) {
        return nil;
    }
    NSString *comment = [self.bulletComments firstObject];
    if (comment) {
        [self.bulletComments removeObject:comment];
    }
    return comment;
}

//弹幕停止执行
- (void)stop {
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:@[@"大幅加快落实的解放路口",
                                                       @"发的撒撒旦",
                                                       @"等噶的说法是电风扇",]];
    }
    return _dataSource;
}

- (NSMutableArray *)bulletComments {
    if (!_bulletComments) {
        _bulletComments = [NSMutableArray array];
    }
    return  _bulletComments;
}

- (NSMutableArray *)bulletViews {
    if (!_bulletViews) {
        _bulletViews = [NSMutableArray array];
    }
    return  _bulletViews;
}
@end
