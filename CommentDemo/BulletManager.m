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
}

//初始化弹幕, 随机分配弹幕轨迹
- (void)initBulletComment {
    //创建弹道数组
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@(1), @(2), @(3)]];
    for (int i = 0; i < trajectorys.count; i++) {
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
    view.moveStatusBlock = ^{
        [weakView stopAnimation];
        [myself.bulletViews removeObject:weakView];
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}

//弹幕停止执行
- (void)stop {
}

- (NSMutableArray *)dataSource {
    if (_dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:@[@"大幅加快落实的解放路口",
                                                       @"发的撒撒旦",
                                                       @"等噶的说法是电风扇",
                                                       @"按多少个梵蒂冈地方是"]];
    }
    return _dataSource;
}

- (NSMutableArray *)bulletComments {
    if (_bulletComments) {
        _bulletComments = [NSMutableArray array];
    }
    return  _bulletComments;
}

- (NSMutableArray *)bulletViews {
    if (_bulletViews) {
        _bulletViews = [NSMutableArray array];
    }
    return  _bulletViews;
}
@end
